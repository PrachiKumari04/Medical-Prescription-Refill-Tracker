package com.refill.dao;

import com.refill.model.Prescription;
import com.refill.util.DbUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class PrescriptionDAO {

    private static final String SELECT =
            "SELECT p.prescription_id, p.patient_id, p.medicine_name, p.dosage, "
          + "p.daily_dose, p.total_quantity, p.dispensed_date, p.days_of_supply, p.exhaustion_date, p.status, "
          + "p.total_refills, p.refills_used, "
          + "pt.name AS patient_name, "
          + "DATEDIFF(p.exhaustion_date, CURDATE()) AS days_left "
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
        // Ordered by days_left ASC so patients running out of medicine show at the top!
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "ORDER BY days_left ASC, pt.name");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public List<Prescription> findRefillDue() throws SQLException {
        List<Prescription> list = new ArrayList<>();
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "WHERE DATEDIFF(p.exhaustion_date, CURDATE()) <= 5 ORDER BY days_left ASC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public int dispenseNew(int patientId, String medicineName, String dosage, int dailyDose, int totalQuantity, int totalRefills) throws SQLException {
        int dose = Math.max(1, dailyDose);
        int qty = Math.max(1, totalQuantity);
        int daysOfSupply = qty / dose;
        LocalDate now = LocalDate.now();
        LocalDate exhaustion = now.plusDays(daysOfSupply);

        String sql = "INSERT INTO prescription (patient_id, medicine_name, dosage, daily_dose, total_quantity, "
                   + "dispensed_date, days_of_supply, exhaustion_date, total_refills, refills_used, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 'ACTIVE')";

        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, patientId);
            ps.setString(2, medicineName.trim());
            ps.setString(3, dosage.trim());
            ps.setInt(4, dose);
            ps.setInt(5, qty);
            ps.setDate(6, Date.valueOf(now));
            ps.setInt(7, daysOfSupply);
            ps.setDate(8, Date.valueOf(exhaustion));
            ps.setInt(9, totalRefills);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
            return 0;
        }
    }

    public int create(int patientId, String medicineName, String dosage, int totalRefills) throws SQLException {
        return dispenseNew(patientId, medicineName, dosage, 1, 30, totalRefills);
    }

    private static Prescription map(ResultSet rs) throws SQLException {
        Prescription p = new Prescription();
        p.setPrescriptionId(rs.getInt("prescription_id"));
        p.setPatientId(rs.getInt("patient_id"));
        p.setPatientName(rs.getString("patient_name"));
        p.setMedicineName(rs.getString("medicine_name"));
        p.setDosage(rs.getString("dosage"));
        p.setDailyDose(rs.getInt("daily_dose"));
        p.setTotalQuantity(rs.getInt("total_quantity"));

        Date dDate = rs.getDate("dispensed_date");
        if (dDate != null) p.setDispensedDate(dDate.toLocalDate());

        p.setDaysOfSupply(rs.getInt("days_of_supply"));

        Date eDate = rs.getDate("exhaustion_date");
        if (eDate != null) p.setExhaustionDate(eDate.toLocalDate());

        p.setStatus(rs.getString("status"));
        p.setTotalRefills(rs.getInt("total_refills"));
        p.setRefillsUsed(rs.getInt("refills_used"));
        return p;
    }
}
