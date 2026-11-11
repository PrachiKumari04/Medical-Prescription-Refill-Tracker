package com.refill.model;

public class Prescription {

    private int prescriptionId;
    private int patientId;
    private String patientName;
    private String medicineName;
    private String dosage;
    private int totalRefills;
    private int refillsUsed;

    public Prescription() {
    }

    public int getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(int prescriptionId) { this.prescriptionId = prescriptionId; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public int getTotalRefills() { return totalRefills; }
    public void setTotalRefills(int totalRefills) { this.totalRefills = totalRefills; }

    public int getRefillsUsed() { return refillsUsed; }
    public void setRefillsUsed(int refillsUsed) { this.refillsUsed = refillsUsed; }

    public int getRefillsRemaining() {
        return totalRefills - refillsUsed;
    }
}
