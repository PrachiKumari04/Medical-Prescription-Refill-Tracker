package com.refill.service;

import com.refill.exception.BusinessRuleException;
import com.refill.exception.ResourceNotFoundException;
import com.refill.model.Prescription;
import com.refill.model.RefillRequest;
import com.refill.model.RefillStatus;
import com.refill.repository.PrescriptionRepository;
import com.refill.repository.RefillRequestRepository;
import com.refill.web.RefillForm;

import java.util.EnumMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class RefillService {

    private final RefillRequestRepository requests;
    private final PrescriptionRepository prescriptions;

    public RefillService(RefillRequestRepository requests, PrescriptionRepository prescriptions) {
        this.requests = requests;               // injected by Spring
        this.prescriptions = prescriptions;
    }

    public RefillRequest submit(Integer patientId, RefillForm form) {
        Prescription p = prescriptions.findById(form.getPrescriptionId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Prescription " + form.getPrescriptionId() + " not found"));
        if (!p.getPatient().getId().equals(patientId)) {
            throw new BusinessRuleException("Prescription does not belong to this patient");
        }
        if (p.getRefillsRemaining() <= 0) {
            throw new BusinessRuleException("No refills remaining on this prescription");
        }
        if (requests.existsPendingForPrescription(p.getId())) {
            throw new BusinessRuleException("A request for this prescription is already pending");
        }
        RefillRequest request = new RefillRequest(p, form.getRequestDate());
        requests.save(request);
        return request;
    }

    public RefillRequest approve(Integer requestId) {
        RefillRequest r = load(requestId);
        if (r.getStatus() != RefillStatus.PENDING) {
            throw new BusinessRuleException("Only a pending request can be approved");
        }
        r.getPrescription().consumeRefill();    // dirty checking issues the UPDATE
        r.setStatus(RefillStatus.APPROVED);
        return r;
    }

    public RefillRequest reject(Integer requestId) {
        RefillRequest r = load(requestId);
        if (r.getStatus() != RefillStatus.PENDING) {
            throw new BusinessRuleException("Only a pending request can be rejected");
        }
        r.setStatus(RefillStatus.REJECTED);
        return r;
    }

    public RefillRequest collect(Integer requestId) {
        RefillRequest r = load(requestId);
        if (r.getStatus() != RefillStatus.APPROVED) {
            throw new BusinessRuleException("Only an approved request can be collected");
        }
        r.setStatus(RefillStatus.COLLECTED);
        return r;
    }

    @Transactional(readOnly = true)
    public List<RefillRequest> pendingForPatient(Integer patientId) {
        return requests.findPendingByPatient(patientId);
    }

    @Transactional(readOnly = true)
    public List<RefillRequest> requestsByStatus(RefillStatus status) {
        return requests.findByStatus(status);
    }

    @Transactional(readOnly = true)
    public List<Prescription> prescriptionsOf(Integer patientId) {
        return prescriptions.findByPatient(patientId);
    }

    @Transactional(readOnly = true)
    public Map<RefillStatus, Long> statusSummary() {
        Map<RefillStatus, Long> summary = new EnumMap<>(RefillStatus.class);
        for (RefillStatus s : RefillStatus.values()) {
            summary.put(s, 0L);
        }
        for (Object[] row : requests.countByStatus()) {
            summary.put((RefillStatus) row[0], (Long) row[1]);
        }
        return summary;
    }

    private RefillRequest load(Integer requestId) {
        return requests.findById(requestId)
                .orElseThrow(() -> new ResourceNotFoundException("Request " + requestId + " not found"));
    }
}
