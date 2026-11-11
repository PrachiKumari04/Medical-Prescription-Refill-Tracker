package com.refill.web;

import com.refill.exception.BusinessRuleException;
import com.refill.exception.ResourceNotFoundException;
import com.refill.model.RefillRequest;
import com.refill.model.RefillStatus;
import com.refill.service.RefillService;

import jakarta.validation.Valid;
import java.time.LocalDate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class RefillController {

    private final RefillService service;

    public RefillController(RefillService service) {
        this.service = service;                 // constructor injection
    }

    @GetMapping("/")
    public String index() {
        return "redirect:/pharmacist/refills";
    }

    @GetMapping("/patients/{patientId}/refills")
    public String patientPage(@PathVariable("patientId") Integer patientId, Model model) {
        if (!model.containsAttribute("refillForm")) {
            RefillForm form = new RefillForm();
            form.setRequestDate(LocalDate.now());
            model.addAttribute("refillForm", form);
        }
        loadPatientData(patientId, model);
        return "patient-refills";
    }

    @PostMapping("/patients/{patientId}/refills")
    public String submit(@PathVariable("patientId") Integer patientId,
                         @Valid @ModelAttribute("refillForm") RefillForm form,
                         BindingResult result,
                         Model model,
                         RedirectAttributes flash) {
        if (!result.hasErrors()) {
            try {
                RefillRequest created = service.submit(patientId, form);
                flash.addFlashAttribute("message", "Refill request #" + created.getId() + " submitted.");
                return "redirect:/patients/" + patientId + "/refills";   // Post-Redirect-Get
            } catch (BusinessRuleException | ResourceNotFoundException ex) {
                result.reject("business.rule", ex.getMessage());
            }
        }
        loadPatientData(patientId, model);
        return "patient-refills";
    }

    @GetMapping("/pharmacist/refills")
    public String pharmacistPage(@RequestParam(name = "status", defaultValue = "PENDING") RefillStatus status,
                                 Model model) {
        model.addAttribute("status", status);
        model.addAttribute("statuses", RefillStatus.values());
        model.addAttribute("requests", service.requestsByStatus(status));
        model.addAttribute("summary", service.statusSummary());
        return "pharmacist-refills";
    }

    @PostMapping("/pharmacist/refills/{id}/{action}")
    public String decide(@PathVariable("id") Integer id,
                         @PathVariable("action") String action,
                         RedirectAttributes flash) {
        try {
            switch (action) {
                case "approve" -> service.approve(id);
                case "reject" -> service.reject(id);
                case "collect" -> service.collect(id);
                default -> throw new BusinessRuleException("Unknown action: " + action);
            }
            flash.addFlashAttribute("message", "Request #" + id + ": " + action + " completed.");
        } catch (BusinessRuleException | ResourceNotFoundException ex) {
            flash.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/pharmacist/refills";
    }

    private void loadPatientData(Integer patientId, Model model) {
        model.addAttribute("prescriptions", service.prescriptionsOf(patientId));
        model.addAttribute("pending", service.pendingForPatient(patientId));
    }
}

