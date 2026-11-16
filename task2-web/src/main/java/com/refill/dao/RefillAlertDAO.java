package com.refill.dao;

import com.refill.model.RefillAlert;
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

public class RefillAlertDAO {

    private static final String SELECT_BASE =
            "SELECT a.alert_id, a.prescription_id, a.patient_id, a.alert_date, a.message, a.status, "
          + "pt.name AS patient_name, p.medicine_name, "
          + "DATEDIFF(p.exhaustion_date, CURDATE()) AS days_remaining "
          + "FROM refill_alert a "
          + "JOIN patient pt ON pt.patient_id = a.patient_id "
          + "JOIN prescription p ON p.prescription_id = a.prescription_id ";

    public List<RefillAlert> findByPatient(int patientId) throws SQLException {
        List<RefillAlert> list = new ArrayList<>();
        String sql = SELECT_BASE + "WHERE a.patient_id = ? ORDER BY a.alert_date DESC, a.alert_id DESC";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public List<RefillAlert> findAll() throws SQLException {
        List<RefillAlert> list = new ArrayList<>();
        String sql = SELECT_BASE + "ORDER BY a.alert_date DESC, a.alert_id DESC";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public int create(int prescriptionId, int patientId, String message) throws SQLException {
        String sql = "INSERT INTO refill_alert (prescription_id, patient_id, alert_date, message, status) VALUES (?, ?, ?, ?, 'SENT')";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, prescriptionId);
            ps.setInt(2, patientId);
            ps.setDate(3, Date.valueOf(LocalDate.now()));
            ps.setString(4, message);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
            return 0;
        }
    }

    public boolean acknowledge(int alertId) throws SQLException {
        String sql = "UPDATE refill_alert SET status = 'ACKNOWLEDGED' WHERE alert_id = ?";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, alertId);
            return ps.executeUpdate() > 0;
        }
    }

    private static RefillAlert map(ResultSet rs) throws SQLException {
        RefillAlert a = new RefillAlert();
        a.setAlertId(rs.getInt("alert_id"));
        a.setPrescriptionId(rs.getInt("prescription_id"));
        a.setPatientId(rs.getInt("patient_id"));
        a.setPatientName(rs.getString("patient_name"));
        a.setMedicineName(rs.getString("medicine_name"));
        Date d = rs.getDate("alert_date");
        a.setAlertDate(d != null ? d.toLocalDate() : LocalDate.now());
        a.setMessage(rs.getString("message"));
        a.setStatus(rs.getString("status"));
        a.setDaysRemaining(rs.getLong("days_remaining"));
        return a;
    }
}
