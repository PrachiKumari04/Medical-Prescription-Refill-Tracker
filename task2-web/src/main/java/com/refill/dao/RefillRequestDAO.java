package com.refill.dao;

import com.refill.model.RefillRequest;
import com.refill.model.RefillStatus;
import com.refill.util.DbUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class RefillRequestDAO {

    private static final String SELECT_BASE =
            "SELECT r.request_id, r.prescription_id, r.patient_id, r.otc_medicine, r.quantity, r.request_date, r.status, r.rejection_reason, "
          + "COALESCE(pt.name, pt_otc.name) AS patient_name, "
          + "p.medicine_name, p.dosage "
          + "FROM refill_request r "
          + "LEFT JOIN prescription p ON p.prescription_id = r.prescription_id "
          + "LEFT JOIN patient pt ON pt.patient_id = p.patient_id "
          + "LEFT JOIN patient pt_otc ON pt_otc.patient_id = r.patient_id ";

    private static final String INSERT =
            "INSERT INTO refill_request (prescription_id, patient_id, otc_medicine, quantity, request_date, status) VALUES (?, ?, ?, ?, ?, ?)";

    /* ---------- Create ---------- */
    public int create(RefillRequest r) throws SQLException {
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            if (r.getPrescriptionId() != null) {
                ps.setInt(1, r.getPrescriptionId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            if (r.getPatientId() != null) {
                ps.setInt(2, r.getPatientId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, r.getOtcMedicine());
            ps.setInt(4, r.getQuantity());
            ps.setDate(5, Date.valueOf(r.getRequestDate()));
            ps.setString(6, r.getStatus().name());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    r.setRequestId(keys.getInt(1));
                }
            }
            return r.getRequestId();
        }
    }

    public int createOTC(int patientId, String otcMedicine, int quantity, LocalDate date) throws SQLException {
        RefillRequest r = new RefillRequest(patientId, otcMedicine, quantity, date);
        return create(r);
    }

    /* ---------- Read ---------- */
    public Optional<RefillRequest> findById(int requestId) throws SQLException {
        String sql = SELECT_BASE + "WHERE r.request_id = ?";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public List<RefillRequest> findByStatus(RefillStatus status) throws SQLException {
        String sql = SELECT_BASE + "WHERE r.status = ? ORDER BY r.request_date, r.request_id";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status.name());
            return collect(ps);
        }
    }

    public List<RefillRequest> findByPatient(int patientId) throws SQLException {
        String sql = SELECT_BASE + "WHERE p.patient_id = ? OR r.patient_id = ? ORDER BY r.request_date DESC, r.request_id DESC";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ps.setInt(2, patientId);
            return collect(ps);
        }
    }

    public List<RefillRequest> findAll() throws SQLException {
        String sql = SELECT_BASE + "ORDER BY r.request_date DESC, r.request_id DESC";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            return collect(ps);
        }
    }

    public boolean existsPending(int prescriptionId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM refill_request WHERE prescription_id = ? AND status = 'PENDING'";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, prescriptionId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    /* ---------- Update: status transitions with reason ---------- */
    public boolean reject(int requestId, String reason) throws SQLException {
        String sql = "UPDATE refill_request SET status = 'REJECTED', rejection_reason = ? WHERE request_id = ? AND status = 'PENDING'";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, reason != null && !reason.isBlank() ? reason.trim() : "Rejected by pharmacist");
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean markCollected(int requestId) throws SQLException {
        String sql = "UPDATE refill_request SET status = 'COLLECTED' WHERE request_id = ? AND status = 'APPROVED'";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            return ps.executeUpdate() > 0;
        }
    }

    /* ---------- Transaction: approve + consume one refill (or approve OTC) ---------- */
    public void approve(int requestId) throws SQLException {
        try (Connection c = DbUtil.getConnection()) {
            c.setAutoCommit(false);
            try {
                // Check if prescription_id exists
                Integer prescriptionId = lockPending(c, requestId);
                setStatus(c, requestId, RefillStatus.APPROVED);
                if (prescriptionId != null) {
                    consumeRefill(c, prescriptionId);
                }
                c.commit();
            } catch (SQLException | RuntimeException ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    private static Integer lockPending(Connection c, int requestId) throws SQLException {
        String sql = "SELECT prescription_id FROM refill_request WHERE request_id = ? AND status = 'PENDING' FOR UPDATE";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new IllegalStateException("Request " + requestId + " is not PENDING or does not exist");
                }
                int pid = rs.getInt("prescription_id");
                return rs.wasNull() ? null : pid;
            }
        }
    }

    private static void setStatus(Connection c, int requestId, RefillStatus status) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "UPDATE refill_request SET status = ? WHERE request_id = ?")) {
            ps.setString(1, status.name());
            ps.setInt(2, requestId);
            ps.executeUpdate();
        }
    }

    private static void consumeRefill(Connection c, int prescriptionId) throws SQLException {
        String sql = "UPDATE prescription SET refills_used = refills_used + 1 "
                   + "WHERE prescription_id = ? AND refills_used < total_refills";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, prescriptionId);
            if (ps.executeUpdate() == 0) {
                throw new IllegalStateException("No refills remaining for prescription " + prescriptionId);
            }
        }
    }

    /* ---------- Helpers ---------- */
    private static List<RefillRequest> collect(PreparedStatement ps) throws SQLException {
        List<RefillRequest> list = new ArrayList<>();
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    private static RefillRequest map(ResultSet rs) throws SQLException {
        RefillRequest r = new RefillRequest();
        r.setRequestId(rs.getInt("request_id"));
        int pid = rs.getInt("prescription_id");
        if (!rs.wasNull()) {
            r.setPrescriptionId(pid);
        }
        int ptid = rs.getInt("patient_id");
        if (!rs.wasNull()) {
            r.setPatientId(ptid);
        }
        r.setOtcMedicine(rs.getString("otc_medicine"));
        r.setQuantity(rs.getInt("quantity"));
        r.setRequestDate(rs.getDate("request_date").toLocalDate());
        r.setStatus(RefillStatus.valueOf(rs.getString("status")));
        r.setRejectionReason(rs.getString("rejection_reason"));

        r.setPatientName(rs.getString("patient_name"));
        r.setMedicineName(rs.getString("medicine_name"));
        r.setDosage(rs.getString("dosage"));
        return r;
    }
}
