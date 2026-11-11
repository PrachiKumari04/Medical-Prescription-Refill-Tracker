package com.refill.model;

import java.time.LocalDate;

public class RefillRequest {

    private int requestId;
    private Integer prescriptionId;
    private Integer patientId;
    private String otcMedicine;
    private int quantity = 1;
    private LocalDate requestDate;
    private RefillStatus status = RefillStatus.PENDING;
    private String rejectionReason;

    private String patientName;
    private String medicineName;
    private String dosage;

    public RefillRequest() {
    }

    public RefillRequest(int prescriptionId, LocalDate requestDate) {
        this.prescriptionId = prescriptionId;
        this.requestDate = requestDate;
    }

    public RefillRequest(Integer patientId, String otcMedicine, int quantity, LocalDate requestDate) {
        this.patientId = patientId;
        this.otcMedicine = otcMedicine;
        this.quantity = quantity;
        this.requestDate = requestDate;
        this.status = RefillStatus.PENDING;
    }

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public Integer getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(Integer prescriptionId) { this.prescriptionId = prescriptionId; }

    public Integer getPatientId() { return patientId; }
    public void setPatientId(Integer patientId) { this.patientId = patientId; }

    public String getOtcMedicine() { return otcMedicine; }
    public void setOtcMedicine(String otcMedicine) { this.otcMedicine = otcMedicine; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public boolean isOtc() { return otcMedicine != null && !otcMedicine.isBlank(); }

    public LocalDate getRequestDate() { return requestDate; }
    public void setRequestDate(LocalDate requestDate) { this.requestDate = requestDate; }

    public RefillStatus getStatus() { return status; }
    public void setStatus(RefillStatus status) { this.status = status; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public String getDisplayMedicine() {
        if (isOtc()) {
            return "[OTC] " + otcMedicine + " (Qty: " + quantity + ")";
        }
        return medicineName + " " + dosage;
    }

    @Override
    public String toString() {
        return String.format("#%d | %s | %s | %s | %s",
                requestId, patientName, getDisplayMedicine(), requestDate, status);
    }
}
