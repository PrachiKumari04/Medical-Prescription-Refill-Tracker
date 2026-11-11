package com.refill.model;

import jakarta.persistence.Cacheable;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "prescription")
@Cacheable
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Prescription {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "prescription_id")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(name = "medicine_name", nullable = false)
    private String medicineName;

    @Column(nullable = false)
    private String dosage;

    @Column(name = "total_refills", nullable = false)
    private int totalRefills;

    @Column(name = "refills_used", nullable = false)
    private int refillsUsed;

    @OneToMany(mappedBy = "prescription")
    private List<RefillRequest> requests = new ArrayList<>();

    public Prescription() {
    }

    public int getRefillsRemaining() {
        return totalRefills - refillsUsed;
    }

    public void consumeRefill() {
        if (refillsUsed >= totalRefills) {
            throw new IllegalStateException("No refills remaining on this prescription");
        }
        refillsUsed++;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public int getTotalRefills() { return totalRefills; }
    public void setTotalRefills(int totalRefills) { this.totalRefills = totalRefills; }

    public int getRefillsUsed() { return refillsUsed; }
    public void setRefillsUsed(int refillsUsed) { this.refillsUsed = refillsUsed; }

    public List<RefillRequest> getRequests() { return requests; }
    public void setRequests(List<RefillRequest> requests) { this.requests = requests; }
}
