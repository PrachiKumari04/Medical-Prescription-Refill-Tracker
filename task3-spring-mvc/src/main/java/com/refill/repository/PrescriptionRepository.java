package com.refill.repository;

import com.refill.model.Prescription;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Repository;

@Repository
public class PrescriptionRepository {

    @PersistenceContext
    private EntityManager em;

    public Optional<Prescription> findById(Integer id) {
        return Optional.ofNullable(em.find(Prescription.class, id));
    }

    public List<Prescription> findByPatient(Integer patientId) {
        return em.createQuery(
                "select p from Prescription p where p.patient.id = :patientId order by p.id",
                Prescription.class)
                .setParameter("patientId", patientId)
                .getResultList();
    }
}
