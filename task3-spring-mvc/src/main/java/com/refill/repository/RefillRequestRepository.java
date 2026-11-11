package com.refill.repository;

import com.refill.model.RefillRequest;
import com.refill.model.RefillStatus;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Repository;

@Repository
public class RefillRequestRepository {

    @PersistenceContext
    private EntityManager em;

    public void save(RefillRequest request) {
        em.persist(request);
    }

    public Optional<RefillRequest> findById(Integer id) {
        return Optional.ofNullable(em.find(RefillRequest.class, id));
    }

    public List<RefillRequest> findPendingByPatient(Integer patientId) {
        return em.createQuery(
                "select r from RefillRequest r "
              + "join fetch r.prescription p join fetch p.patient pt "
              + "where pt.id = :patientId and r.status = :status "
              + "order by r.requestDate, r.id", RefillRequest.class)
                .setParameter("patientId", patientId)
                .setParameter("status", RefillStatus.PENDING)
                .getResultList();
    }

    public List<RefillRequest> findByStatus(RefillStatus status) {
        return em.createQuery(
                "select r from RefillRequest r "
              + "join fetch r.prescription p join fetch p.patient "
              + "where r.status = :status order by r.requestDate, r.id", RefillRequest.class)
                .setParameter("status", status)
                .getResultList();
    }

    public boolean existsPendingForPrescription(Integer prescriptionId) {
        Long count = em.createQuery(
                "select count(r) from RefillRequest r "
              + "where r.prescription.id = :pid and r.status = :status", Long.class)
                .setParameter("pid", prescriptionId)
                .setParameter("status", RefillStatus.PENDING)
                .getSingleResult();
        return count > 0;
    }

    public List<Object[]> countByStatus() {
        return em.createQuery(
                "select r.status, count(r) from RefillRequest r group by r.status", Object[].class)
                .getResultList();
    }
}
