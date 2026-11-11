package com.refill.hibernate;

import com.refill.model.RefillStatus;
import java.time.LocalDate;

public record RefillRow(Integer requestId,
                        String patientName,
                        String medicineName,
                        LocalDate requestDate,
                        RefillStatus status) {

    @Override
    public String toString() {
        return "#" + requestId + " | " + patientName + " | " + medicineName
                + " | " + requestDate + " | " + status;
    }
}
