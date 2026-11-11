package com.refill.boot.repository;

import com.refill.model.RefillRequest;
import com.refill.model.RefillStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RefillRequestRepository extends JpaRepository<RefillRequest, Integer> {

    @Query("select r from RefillRequest r join fetch r.prescription p join fetch p.patient order by r.requestDate desc, r.id desc")
    List<RefillRequest> findAllWithDetails();

    @Query("select r from RefillRequest r join fetch r.prescription p join fetch p.patient where r.status = :status order by r.requestDate asc, r.id asc")
    List<RefillRequest> findByStatusWithDetails(@Param("status") RefillStatus status);

    @Query("select r from RefillRequest r join fetch r.prescription p join fetch p.patient pt where pt.id = :patientId order by r.requestDate desc, r.id desc")
    List<RefillRequest> findByPatientIdWithDetails(@Param("patientId") Integer patientId);

    @Query("select count(r) > 0 from RefillRequest r where r.prescription.id = :prescriptionId and r.status = 'PENDING'")
    boolean existsPendingForPrescription(@Param("prescriptionId") Integer prescriptionId);
}
