package com.refill.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Prescription {

    private int prescriptionId;
    private int patientId;
    private String patientName;
    private String medicineName;
    private String dosage;
    private int dailyDose = 1;
    private int totalQuantity = 30;
    private LocalDate dispensedDate;
    private int daysOfSupply = 30;
    private LocalDate exhaustionDate;
    private String status = "ACTIVE";
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

    public int getDailyDose() { return dailyDose; }
    public void setDailyDose(int dailyDose) { this.dailyDose = dailyDose; }

    public int getTotalQuantity() { return totalQuantity; }
    public void setTotalQuantity(int totalQuantity) { this.totalQuantity = totalQuantity; }

    public LocalDate getDispensedDate() { return dispensedDate; }
    public void setDispensedDate(LocalDate dispensedDate) { this.dispensedDate = dispensedDate; }

    public int getDaysOfSupply() { return daysOfSupply; }
    public void setDaysOfSupply(int daysOfSupply) { this.daysOfSupply = daysOfSupply; }

    public LocalDate getExhaustionDate() { return exhaustionDate; }
    public void setExhaustionDate(LocalDate exhaustionDate) { this.exhaustionDate = exhaustionDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getTotalRefills() { return totalRefills; }
    public void setTotalRefills(int totalRefills) { this.totalRefills = totalRefills; }

    public int getRefillsUsed() { return refillsUsed; }
    public void setRefillsUsed(int refillsUsed) { this.refillsUsed = refillsUsed; }

    public int getRefillsRemaining() {
        return totalRefills - refillsUsed;
    }

    public long getDaysRemaining() {
        if (exhaustionDate == null) return 0;
        return ChronoUnit.DAYS.between(LocalDate.now(), exhaustionDate);
    }

    public int getRemainingPills() {
        long days = getDaysRemaining();
        if (days <= 0) return 0;
        return (int) Math.min(totalQuantity, days * Math.max(1, dailyDose));
    }

    public int getPillPercentage() {
        if (totalQuantity <= 0) return 0;
        int remaining = getRemainingPills();
        return (int) Math.min(100, Math.max(0, ((double) remaining / totalQuantity) * 100));
    }

    public boolean isRefillDue() {
        long days = getDaysRemaining();
        return days <= 5 && days > 0;
    }

    public boolean isExhausted() {
        return getDaysRemaining() <= 0;
    }

    public String getAdherenceLevel() {
        long days = getDaysRemaining();
        if (days <= 0) return "EXHAUSTED";
        if (days <= 2) return "CRITICAL";
        if (days <= 5) return "DUE";
        return "SAFE";
    }
}
