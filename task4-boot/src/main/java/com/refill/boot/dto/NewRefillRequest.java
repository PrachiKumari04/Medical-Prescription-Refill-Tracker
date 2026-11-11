package com.refill.boot.dto;

import jakarta.validation.constraints.NotNull;

public record NewRefillRequest(
        @NotNull(message = "patientId is required")
        Integer patientId,

        @NotNull(message = "prescriptionId is required")
        Integer prescriptionId
) {
}
