package com.refill.dao;

import com.refill.model.Prescription;
import com.refill.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class PrescriptionDAO {

    private static final String SELECT =
            "SELECT prescription_id, patient_id, medicine_name, dosage, total_refills, refills_used "
          + "FROM prescription ";

    public Optional<Prescription> findById(int prescriptionId) throws SQLException {
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "WHERE prescription_id = ?")) {
            ps.setInt(1, prescriptionId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public List<Prescription> findByPatient(int patientId) throws SQLException {
        List<Prescription> list = new ArrayList<>();
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "WHERE patient_id = ? ORDER BY prescription_id")) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    private static Prescription map(ResultSet rs) throws SQLException {
        Prescription p = new Prescription();
        p.setPrescriptionId(rs.getInt("prescription_id"));
        p.setPatientId(rs.getInt("patient_id"));
        p.setMedicineName(rs.getString("medicine_name"));
        p.setDosage(rs.getString("dosage"));
        p.setTotalRefills(rs.getInt("total_refills"));
        p.setRefillsUsed(rs.getInt("refills_used"));
        return p;
    }
}
