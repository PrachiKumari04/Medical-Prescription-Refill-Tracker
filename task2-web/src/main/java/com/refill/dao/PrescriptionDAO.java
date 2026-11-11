package com.refill.dao;

import com.refill.model.Prescription;
import com.refill.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class PrescriptionDAO {

    private static final String SELECT =
            "SELECT p.prescription_id, p.patient_id, p.medicine_name, p.dosage, p.total_refills, p.refills_used, "
          + "pt.name AS patient_name "
          + "FROM prescription p "
          + "JOIN patient pt ON pt.patient_id = p.patient_id ";

    public Optional<Prescription> findById(int prescriptionId) throws SQLException {
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "WHERE p.prescription_id = ?")) {
            ps.setInt(1, prescriptionId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public List<Prescription> findByPatient(int patientId) throws SQLException {
        List<Prescription> list = new ArrayList<>();
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "WHERE p.patient_id = ? ORDER BY p.prescription_id")) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public List<Prescription> findAllWithStats() throws SQLException {
        List<Prescription> list = new ArrayList<>();
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "ORDER BY pt.name, p.prescription_id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public int create(int patientId, String medicineName, String dosage, int totalRefills) throws SQLException {
        String sql = "INSERT INTO prescription (patient_id, medicine_name, dosage, total_refills, refills_used) VALUES (?, ?, ?, ?, 0)";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, patientId);
            ps.setString(2, medicineName.trim());
            ps.setString(3, dosage.trim());
            ps.setInt(4, totalRefills);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
            return 0;
        }
    }

    private static Prescription map(ResultSet rs) throws SQLException {
        Prescription p = new Prescription();
        p.setPrescriptionId(rs.getInt("prescription_id"));
        p.setPatientId(rs.getInt("patient_id"));
        p.setPatientName(rs.getString("patient_name"));
        p.setMedicineName(rs.getString("medicine_name"));
        p.setDosage(rs.getString("dosage"));
        p.setTotalRefills(rs.getInt("total_refills"));
        p.setRefillsUsed(rs.getInt("refills_used"));
        return p;
    }
}
