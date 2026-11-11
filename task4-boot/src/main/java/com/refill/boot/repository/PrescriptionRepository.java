package com.refill.boot.repository;

import com.refill.model.Prescription;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface PrescriptionRepository extends JpaRepository<Prescription, Integer> {

    @Query("select p from Prescription p join fetch p.patient where p.id = :id")
    Optional<Prescription> findByIdWithPatient(@Param("id") Integer id);

    @Query("select p from Prescription p join fetch p.patient where p.patient.id = :patientId order by p.id")
    List<Prescription> findByPatientId(@Param("patientId") Integer patientId);
}

