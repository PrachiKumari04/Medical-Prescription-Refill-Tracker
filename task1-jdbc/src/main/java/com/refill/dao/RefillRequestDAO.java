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
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class RefillRequestDAO {

    private static final String SELECT_BASE =
            "SELECT r.request_id, r.prescription_id, r.request_date, r.status, "
          + "pt.name AS patient_name, p.medicine_name, p.dosage "
          + "FROM refill_request r "
          + "JOIN prescription p ON p.prescription_id = r.prescription_id "
          + "JOIN patient pt ON pt.patient_id = p.patient_id ";

    private static final String INSERT =
            "INSERT INTO refill_request (prescription_id, request_date, status) VALUES (?, ?, ?)";

    /* ---------- Create ---------- */
    public int create(RefillRequest r) throws SQLException {
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getPrescriptionId());
            ps.setDate(2, Date.valueOf(r.getRequestDate()));
            ps.setString(3, r.getStatus().name());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    r.setRequestId(keys.getInt(1));
                }
            }
            return r.getRequestId();
        }
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
        String sql = SELECT_BASE + "WHERE p.patient_id = ? ORDER BY r.request_date DESC, r.request_id DESC";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, patientId);
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

    /* ---------- Update: status transitions ---------- */
    public boolean reject(int requestId) throws SQLException {
        return updateStatus(requestId, RefillStatus.PENDING, RefillStatus.REJECTED);
    }

    public boolean markCollected(int requestId) throws SQLException {
        return updateStatus(requestId, RefillStatus.APPROVED, RefillStatus.COLLECTED);
    }

    private boolean updateStatus(int requestId, RefillStatus expected, RefillStatus next) throws SQLException {
        String sql = "UPDATE refill_request SET status = ? WHERE request_id = ? AND status = ?";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, next.name());
            ps.setInt(2, requestId);
            ps.setString(3, expected.name());
            return ps.executeUpdate() > 0;
        }
    }

    /* ---------- Transaction: approve + consume one refill ---------- */
    public void approve(int requestId) throws SQLException {
        try (Connection c = DbUtil.getConnection()) {
            c.setAutoCommit(false);                       // start of the transaction
            try {
                int prescriptionId = lockPending(c, requestId);
                setStatus(c, requestId, RefillStatus.APPROVED);
                consumeRefill(c, prescriptionId);
                c.commit();                               // both updates or none
            } catch (SQLException | RuntimeException ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    private static int lockPending(Connection c, int requestId) throws SQLException {
        String sql = "SELECT prescription_id FROM refill_request "
                   + "WHERE request_id = ? AND status = 'PENDING' FOR UPDATE";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new IllegalStateException(
                            "Request " + requestId + " is not PENDING or does not exist");
                }
                return rs.getInt(1);
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

    /* ---------- Batch: several requests in one round trip ---------- */
    public int[] insertBatch(List<RefillRequest> requests) throws SQLException {
        try (Connection c = DbUtil.getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement ps = c.prepareStatement(INSERT)) {
                for (RefillRequest r : requests) {
                    ps.setInt(1, r.getPrescriptionId());
                    ps.setDate(2, Date.valueOf(r.getRequestDate()));
                    ps.setString(3, r.getStatus().name());
                    ps.addBatch();
                }
                int[] counts = ps.executeBatch();         // all rows, one round trip
                c.commit();
                return counts;
            } catch (SQLException ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    /* ---------- Delete ---------- */
    public boolean delete(int requestId) throws SQLException {
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement("DELETE FROM refill_request WHERE request_id = ?")) {
            ps.setInt(1, requestId);
            return ps.executeUpdate() > 0;
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
        r.setPrescriptionId(rs.getInt("prescription_id"));
        r.setRequestDate(rs.getDate("request_date").toLocalDate());
        r.setStatus(RefillStatus.valueOf(rs.getString("status")));
        r.setPatientName(rs.getString("patient_name"));
        r.setMedicineName(rs.getString("medicine_name"));
        r.setDosage(rs.getString("dosage"));
        return r;
    }
}
