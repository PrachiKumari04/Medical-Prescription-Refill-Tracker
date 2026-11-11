package com.refill.hibernate;

import com.refill.model.Patient;
import com.refill.model.Prescription;
import com.refill.model.RefillRequest;
import com.refill.model.RefillStatus;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class RefillHibernateDao {

    /* ---------- CRUD with a Session ---------- */
    public Integer create(Integer prescriptionId, LocalDate date) {
        return inTx(s -> {
            RefillRequest r = new RefillRequest(s.getReference(Prescription.class, prescriptionId), date);
            s.persist(r);
            return r.getId();
        });
    }

    public Optional<RefillRequest> find(Integer id) {
        try (Session s = HibernateUtil.factory().openSession()) {
            return Optional.ofNullable(s.get(RefillRequest.class, id));
        }
    }

    public void changeStatus(Integer id, RefillStatus status) {
        inTx(s -> {
            RefillRequest r = s.get(RefillRequest.class, id);
            if (r == null) {
                throw new IllegalArgumentException("Request " + id + " not found");
            }
            r.setStatus(status);            // dirty checking: UPDATE issued at commit
            return null;
        });
    }

    public boolean delete(Integer id) {
        return inTx(s -> {
            RefillRequest r = s.get(RefillRequest.class, id);
            if (r == null) {
                return false;
            }
            s.remove(r);
            return true;
        });
    }

    /* ---------- HQL aggregate: approved refills per patient ---------- */
    public List<Object[]> approvedPerPatient(long minCount) {
        String hql = "select pt.name, count(r) "
                   + "from RefillRequest r join r.prescription p join p.patient pt "
                   + "where r.status in (:statuses) "
                   + "group by pt.name "
                   + "having count(r) >= :min "
                   + "order by count(r) desc, pt.name";
        try (Session s = HibernateUtil.factory().openSession()) {
            return s.createQuery(hql, Object[].class)
                    .setParameterList("statuses", List.of(RefillStatus.APPROVED, RefillStatus.COLLECTED))
                    .setParameter("min", minCount)
                    .getResultList();
        }
    }

    /* ---------- Criteria API: dynamic search ---------- */
    public List<RefillRow> search(String patientName, RefillStatus status, LocalDate from, LocalDate to) {
        try (Session s = HibernateUtil.factory().openSession()) {
            CriteriaBuilder cb = s.getCriteriaBuilder();
            CriteriaQuery<RefillRow> cq = cb.createQuery(RefillRow.class);
            Root<RefillRequest> r = cq.from(RefillRequest.class);
            Join<RefillRequest, Prescription> p = r.join("prescription");
            Join<Prescription, Patient> pt = p.join("patient");

            List<Predicate> filters = new ArrayList<>();
            if (patientName != null && !patientName.isBlank()) {
                filters.add(cb.like(cb.lower(pt.<String>get("name")),
                        "%" + patientName.toLowerCase() + "%"));
            }
            if (status != null) {
                filters.add(cb.equal(r.get("status"), status));
            }
            if (from != null) {
                filters.add(cb.greaterThanOrEqualTo(r.<LocalDate>get("requestDate"), from));
            }
            if (to != null) {
                filters.add(cb.lessThanOrEqualTo(r.<LocalDate>get("requestDate"), to));
            }

            cq.select(cb.construct(RefillRow.class,
                            r.get("id"), pt.get("name"), p.get("medicineName"),
                            r.get("requestDate"), r.get("status")))
              .where(filters.toArray(new Predicate[0]))
              .orderBy(cb.asc(r.get("requestDate")), cb.asc(r.get("id")));
            return s.createQuery(cq).getResultList();
        }
    }

    /* ---------- Transaction helper ---------- */
    private <T> T inTx(Function<Session, T> work) {
        try (Session s = HibernateUtil.factory().openSession()) {
            Transaction tx = s.beginTransaction();
            try {
                T result = work.apply(s);
                tx.commit();
                return result;
            } catch (RuntimeException e) {
                tx.rollback();
                throw e;
            }
        }
    }
}

