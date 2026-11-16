package com.refill.web;

import com.refill.dao.PatientDAO;
import com.refill.dao.PrescriptionDAO;
import com.refill.dao.RefillAlertDAO;
import com.refill.dao.RefillRequestDAO;
import com.refill.model.Prescription;
import com.refill.model.RefillRequest;
import com.refill.model.RefillStatus;
import com.refill.util.DbUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Optional;

@WebServlet("/refills")
public class RefillRequestServlet extends HttpServlet {

    private RefillRequestDAO refillDao;
    private PrescriptionDAO prescriptionDao;
    private PatientDAO patientDao;
    private RefillAlertDAO alertDao;

    @Override
    public void init() {
        refillDao = new RefillRequestDAO();
        prescriptionDao = new PrescriptionDAO();
        patientDao = new PatientDAO();
        alertDao = new RefillAlertDAO();
        log("RefillRequestServlet initialised with 2-Role Exhaustion & Adherence Engine");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String role = (String) session.getAttribute("role");
        try {
            Object flash = session.getAttribute("flash");
            if (flash != null) {
                req.setAttribute("flash", flash);
                session.removeAttribute("flash");
            }

            if ("PHARMACIST".equals(role)) {
                RefillStatus filter = parseStatus(req.getParameter("status"));
                req.setAttribute("filter", filter);
                req.setAttribute("requests", filter != null ? refillDao.findByStatus(filter) : refillDao.findAll());
                req.setAttribute("adherenceRadar", prescriptionDao.findAllWithStats());
                req.setAttribute("refillDueList", prescriptionDao.findRefillDue());
                req.setAttribute("alerts", alertDao.findAll());
                req.setAttribute("patients", patientDao.findAll());
                req.setAttribute("statuses", RefillStatus.values());
                req.getRequestDispatcher("/WEB-INF/views/pharmacist.jsp").forward(req, resp);
                return;
            }

            // PATIENT VIEW
            int patientId = (Integer) session.getAttribute("patientId");
            req.setAttribute("requests", refillDao.findByPatient(patientId));
            req.setAttribute("prescriptions", prescriptionDao.findByPatient(patientId));
            req.setAttribute("alerts", alertDao.findByPatient(patientId));
            req.setAttribute("statuses", RefillStatus.values());
            req.getRequestDispatcher("/WEB-INF/views/refills.jsp").forward(req, resp);

        } catch (SQLException ex) {
            throw new ServletException("Unable to load refill and adherence data", ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String message;
        try {
            message = perform(req, session);
        } catch (IllegalArgumentException ex) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, ex.getMessage());
            return;
        } catch (IllegalStateException ex) {
            message = ex.getMessage();
        } catch (SQLException ex) {
            throw new ServletException("Refill operation failed", ex);
        }
        session.setAttribute("flash", message);
        resp.sendRedirect(req.getContextPath() + "/refills");
    }

    @Override
    public void destroy() {
        DbUtil.shutdown();
        log("RefillRequestServlet destroyed");
    }

    private String perform(HttpServletRequest req, HttpSession session) throws SQLException {
        String action = req.getParameter("action");
        if (action == null) {
            throw new IllegalArgumentException("Missing action");
        }
        return switch (action) {
            case "submit" -> submitPrescriptionRefill(req, session);
            case "submit_otc" -> submitOtcDemand(req, session);
            case "request_new_rx" -> requestNewPrescription(req, session);
            case "dispense" -> dispenseMedicationByPharmacist(req, session);
            case "send_alert" -> sendRefillAlertByPharmacist(req, session);
            case "approve" -> {
                refillDao.approve(requestId(req));
                yield "Refill approved & dispensed. Exhaustion countdown reset with fresh supply.";
            }
            case "reject" -> {
                int id = requestId(req);
                String reason = req.getParameter("reason");
                if (reason == null || reason.isBlank()) {
                    reason = "Refill rejected by pharmacist";
                }
                refillDao.reject(id, reason);
                yield "Request #" + id + " rejected. Reason: " + reason;
            }
            case "collect" -> refillDao.markCollected(requestId(req))
                    ? "Medicine marked as collected by patient." : "Only an approved request can be collected.";
            default -> throw new IllegalArgumentException("Unknown action: " + action);
        };
    }

    private String submitPrescriptionRefill(HttpServletRequest req, HttpSession session) throws SQLException {
        int patientId = (Integer) session.getAttribute("patientId");
        int prescriptionId = Integer.parseInt(req.getParameter("prescriptionId"));
        Optional<Prescription> found = prescriptionDao.findById(prescriptionId);
        if (found.isEmpty() || found.get().getPatientId() != patientId) {
            throw new IllegalStateException("Prescription not found for this patient.");
        }
        if (found.get().getRefillsRemaining() <= 0) {
            throw new IllegalStateException("No refills remaining on this prescription.");
        }
        if (refillDao.existsPending(prescriptionId)) {
            throw new IllegalStateException("A refill request for this prescription is already pending review.");
        }
        int id = refillDao.create(new RefillRequest(prescriptionId, LocalDate.now()));
        return "Refill request #" + id + " submitted to pharmacy. The pharmacist will dispense your next supply shortly.";
    }

    private String submitOtcDemand(HttpServletRequest req, HttpSession session) throws SQLException {
        int patientId = (Integer) session.getAttribute("patientId");
        String otcMedicine = req.getParameter("otcMedicine");
        String qtyStr = req.getParameter("quantity");
        if (otcMedicine == null || otcMedicine.isBlank()) {
            throw new IllegalStateException("Please select an over-the-counter medicine.");
        }
        int quantity = 1;
        try {
            quantity = Integer.parseInt(qtyStr);
        } catch (NumberFormatException e) {
            throw new IllegalStateException("Invalid quantity.");
        }
        if (quantity <= 0) {
            throw new IllegalStateException("Quantity must be at least 1 unit.");
        }
        if (quantity > 10) {
            throw new IllegalStateException("Quantity (" + quantity + ") exceeds OTC safety threshold (max 10 units). For chronic amounts, please submit a prescription.");
        }

        int id = refillDao.createOTC(patientId, otcMedicine.trim(), quantity, LocalDate.now());
        return "OTC demand for " + otcMedicine + " (Qty: " + quantity + ") submitted (#" + id + "). Pending pharmacist pickup review.";
    }

    private String requestNewPrescription(HttpServletRequest req, HttpSession session) throws SQLException {
        int patientId = (Integer) session.getAttribute("patientId");
        String medicineName = req.getParameter("medicineName");
        String dosage = req.getParameter("dosage");
        String dailyDoseStr = req.getParameter("dailyDose");

        if (medicineName == null || medicineName.isBlank() || dosage == null || dosage.isBlank()) {
            throw new IllegalStateException("Medicine name and dosage instructions are mandatory.");
        }
        int dailyDose = 1;
        try {
            if (dailyDoseStr != null && !dailyDoseStr.isBlank()) {
                dailyDose = Integer.parseInt(dailyDoseStr);
            }
        } catch (NumberFormatException ignored) {}

        // Create prescription record with initial pending dispense
        int prescriptionId = prescriptionDao.dispenseNew(patientId, medicineName.trim(), dosage.trim(), dailyDose, 30, 3);
        return "New prescription for " + medicineName.trim() + " submitted to your pharmacist (#" + prescriptionId + "). 30-day initial supply recorded.";
    }

    private String dispenseMedicationByPharmacist(HttpServletRequest req, HttpSession session) throws SQLException {
        int patientId = Integer.parseInt(req.getParameter("patientId"));
        String medicineName = req.getParameter("medicineName");
        String dosage = req.getParameter("dosage");
        int dailyDose = Integer.parseInt(req.getParameter("dailyDose"));
        int totalQuantity = Integer.parseInt(req.getParameter("totalQuantity"));
        int totalRefills = Integer.parseInt(req.getParameter("totalRefills"));

        if (medicineName == null || medicineName.isBlank() || dosage == null || dosage.isBlank()) {
            throw new IllegalStateException("Medicine name and dosage are mandatory.");
        }
        if (dailyDose <= 0 || totalQuantity <= 0) {
            throw new IllegalStateException("Daily dosage and total quantity must be positive integers.");
        }

        int prescriptionId = prescriptionDao.dispenseNew(patientId, medicineName.trim(), dosage.trim(), dailyDose, totalQuantity, totalRefills);
        int daysOfSupply = totalQuantity / dailyDose;
        return "Successfully dispensed " + totalQuantity + " units of " + medicineName + " (" + daysOfSupply + " days of supply). Exhaustion forecast active.";
    }

    private String sendRefillAlertByPharmacist(HttpServletRequest req, HttpSession session) throws SQLException {
        int prescriptionId = Integer.parseInt(req.getParameter("prescriptionId"));
        int patientId = Integer.parseInt(req.getParameter("patientId"));
        String medicineName = req.getParameter("medicineName");
        long daysRemaining = Long.parseLong(req.getParameter("daysRemaining"));

        String msg = "Pharmacy Reminder: Your " + medicineName + " supply has " + daysRemaining + " day(s) left. Please request your refill to avoid missing doses!";
        alertDao.create(prescriptionId, patientId, msg);
        return "Refill reminder alert dispatched to patient for " + medicineName + ".";
    }

    private static int requestId(HttpServletRequest req) {
        return Integer.parseInt(req.getParameter("requestId"));
    }

    private static RefillStatus parseStatus(String value) {
        if (value == null || value.isBlank() || "ALL".equalsIgnoreCase(value)) {
            return null;
        }
        try {
            return RefillStatus.valueOf(value);
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }
}
