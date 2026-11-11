package com.refill.boot.service;

import com.refill.boot.dto.NewRefillRequest;
import com.refill.boot.dto.RefillResponse;
import com.refill.boot.repository.PatientRepository;
import com.refill.boot.repository.PrescriptionRepository;
import com.refill.boot.repository.RefillRequestRepository;
import com.refill.exception.BusinessRuleException;
import com.refill.exception.ResourceNotFoundException;
import com.refill.model.Prescription;
import com.refill.model.RefillRequest;
import com.refill.model.RefillStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@Transactional
public class RefillService {

    private final RefillRequestRepository requestRepo;
    private final PrescriptionRepository prescriptionRepo;
    private final PatientRepository patientRepo;

    public RefillService(RefillRequestRepository requestRepo,
                         PrescriptionRepository prescriptionRepo,
                         PatientRepository patientRepo) {
        this.requestRepo = requestRepo;
        this.prescriptionRepo = prescriptionRepo;
        this.patientRepo = patientRepo;
    }

    public RefillResponse submit(NewRefillRequest req) {
        Prescription prescription = prescriptionRepo.findByIdWithPatient(req.prescriptionId())
                .orElseThrow(() -> new ResourceNotFoundException("Prescription " + req.prescriptionId() + " not found"));

        if (!prescription.getPatient().getId().equals(req.patientId())) {
            throw new BusinessRuleException("Prescription " + req.prescriptionId() + " does not belong to patient " + req.patientId());
        }

        if (prescription.getRefillsRemaining() <= 0) {
            throw new BusinessRuleException("No refills remaining on this prescription");
        }

        if (requestRepo.existsPendingForPrescription(prescription.getId())) {
            throw new BusinessRuleException("A refill request for this prescription is already pending");
        }

        RefillRequest newRequest = new RefillRequest(prescription, LocalDate.now());
        RefillRequest saved = requestRepo.save(newRequest);
        return RefillResponse.from(saved);
    }

    public RefillResponse approve(Integer requestId) {
        RefillRequest req = load(requestId);
        if (req.getStatus() != RefillStatus.PENDING) {
            throw new BusinessRuleException("Only a pending request can be approved");
        }
        req.getPrescription().consumeRefill(); // dirty checking flushes UPDATE to prescription
        req.setStatus(RefillStatus.APPROVED);
        return RefillResponse.from(req);
    }

    public RefillResponse reject(Integer requestId) {
        RefillRequest req = load(requestId);
        if (req.getStatus() != RefillStatus.PENDING) {
            throw new BusinessRuleException("Only a pending request can be rejected");
        }
        req.setStatus(RefillStatus.REJECTED);
        return RefillResponse.from(req);
    }

    public RefillResponse collect(Integer requestId) {
        RefillRequest req = load(requestId);
        if (req.getStatus() != RefillStatus.APPROVED) {
            throw new BusinessRuleException("Only an approved request can be collected");
        }
        req.setStatus(RefillStatus.COLLECTED);
        return RefillResponse.from(req);
    }

    @Transactional(readOnly = true)
    public RefillResponse getById(Integer id) {
        return RefillResponse.from(load(id));
    }

    @Transactional(readOnly = true)
    public List<RefillResponse> getAll(RefillStatus status) {
        List<RefillRequest> list = (status == null)
                ? requestRepo.findAllWithDetails()
                : requestRepo.findByStatusWithDetails(status);
        return list.stream().map(RefillResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public List<RefillResponse> getByPatientId(Integer patientId) {
        if (!patientRepo.existsById(patientId)) {
            throw new ResourceNotFoundException("Patient " + patientId + " not found");
        }
        return requestRepo.findByPatientIdWithDetails(patientId).stream()
                .map(RefillResponse::from)
                .toList();
    }

    public void delete(Integer requestId) {
        RefillRequest req = load(requestId);
        if (req.getStatus() != RefillStatus.PENDING) {
            throw new BusinessRuleException("Only a pending request can be deleted");
        }
        requestRepo.delete(req);
    }

    private RefillRequest load(Integer id) {
        return requestRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Refill request " + id + " not found"));
    }
}

