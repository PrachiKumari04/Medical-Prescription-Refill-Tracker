package com.refill.model;

import java.time.LocalDate;

public class RefillRequest {

    private int requestId;
    private int prescriptionId;
    private LocalDate requestDate;
    private RefillStatus status = RefillStatus.PENDING;
    private String patientName;
    private String medicineName;
    private String dosage;

    public RefillRequest() {
    }

    public RefillRequest(int prescriptionId, LocalDate requestDate) {
        this.prescriptionId = prescriptionId;
        this.requestDate = requestDate;
    }

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(int prescriptionId) { this.prescriptionId = prescriptionId; }

    public LocalDate getRequestDate() { return requestDate; }
    public void setRequestDate(LocalDate requestDate) { this.requestDate = requestDate; }

    public RefillStatus getStatus() { return status; }
    public void setStatus(RefillStatus status) { this.status = status; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    @Override
    public String toString() {
        return String.format("#%d | %s | %s %s | %s | %s",
                requestId, patientName, medicineName, dosage, requestDate, status);
    }
}

