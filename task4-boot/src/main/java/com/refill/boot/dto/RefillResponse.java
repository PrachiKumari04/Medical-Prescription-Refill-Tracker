package com.refill.boot.dto;

import com.refill.model.RefillRequest;
import com.refill.model.RefillStatus;

import java.time.LocalDate;

public record RefillResponse(
        Integer id,
        Integer patientId,
        String patientName,
        Integer prescriptionId,
        String medicineName,
        String dosage,
        LocalDate requestDate,
        RefillStatus status,
        int refillsRemaining
) {
    public static RefillResponse from(RefillRequest r) {
        return new RefillResponse(
                r.getId(),
                r.getPrescription().getPatient().getId(),
                r.getPrescription().getPatient().getName(),
                r.getPrescription().getId(),
                r.getPrescription().getMedicineName(),
                r.getPrescription().getDosage(),
                r.getRequestDate(),
                r.getStatus(),
                r.getPrescription().getRefillsRemaining()
        );
    }
}
