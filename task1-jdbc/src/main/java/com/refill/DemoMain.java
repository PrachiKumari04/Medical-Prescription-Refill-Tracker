package com.refill;

import com.refill.dao.PrescriptionDAO;
import com.refill.dao.RefillRequestDAO;
import com.refill.model.Prescription;
import com.refill.model.RefillRequest;
import com.refill.model.RefillStatus;
import com.refill.util.DbUtil;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

public class DemoMain {

    private static final RefillRequestDAO DAO = new RefillRequestDAO();
    private static final PrescriptionDAO PRESCRIPTIONS = new PrescriptionDAO();

    public static void main(String[] args) {
        try {
            createDemo();
            readDemo();
            commitDemo();
            rollbackDemo();
            batchDemo();
            lifecycleDemo();
        } catch (SQLException ex) {
            System.err.println("Database error: " + ex.getMessage());
        } finally {
            DbUtil.shutdown();
        }
    }

    private static void createDemo() throws SQLException {
        heading("1. CREATE a refill request");
        int id = DAO.create(new RefillRequest(5, LocalDate.of(2026, 11, 5)));
        System.out.println("Inserted: " + DAO.findById(id).orElseThrow());
    }

    private static void readDemo() throws SQLException {
        heading("2. READ pending requests (PreparedStatement)");
        List<RefillRequest> pending = DAO.findByStatus(RefillStatus.PENDING);
        for (RefillRequest r : pending) {
            System.out.println("  " + r);
        }
        System.out.println("  " + pending.size() + " row(s)");
    }

    private static void commitDemo() throws SQLException {
        heading("3. TRANSACTION - approve request 2 (commit)");
        printRefills(1);
        DAO.approve(2);
        System.out.println("COMMIT   : request 2 is now " + DAO.findById(2).orElseThrow().getStatus());
        printRefills(1);
    }

    private static void rollbackDemo() throws SQLException {
        heading("4. TRANSACTION - approve request 3 (rollback)");
        printRefills(2);
        try {
            DAO.approve(3);
        } catch (IllegalStateException ex) {
            System.out.println("ROLLBACK : " + ex.getMessage());
        }
        System.out.println("After    : request 3 is still " + DAO.findById(3).orElseThrow().getStatus());
        printRefills(2);
    }

    private static void batchDemo() throws SQLException {
        heading("5. BATCH - three requests in one round trip");
        LocalDate day = LocalDate.of(2026, 11, 5);
        List<RefillRequest> batch = List.of(
                new RefillRequest(1, day),
                new RefillRequest(3, day),
                new RefillRequest(4, day));
        int[] counts = DAO.insertBatch(batch);
        System.out.println("Batch counts: " + Arrays.toString(counts));
        System.out.println("Pending requests now: " + DAO.findByStatus(RefillStatus.PENDING).size());
    }

    private static void lifecycleDemo() throws SQLException {
        heading("6. LIFECYCLE - reject, collect, delete");
        System.out.println("reject(4)        = " + DAO.reject(4));
        System.out.println("markCollected(7) = " + DAO.markCollected(7));
        System.out.println("markCollected(6) = " + DAO.markCollected(6));
        System.out.println("delete(13)       = " + DAO.delete(13));
    }

    private static void printRefills(int prescriptionId) throws SQLException {
        Prescription p = PRESCRIPTIONS.findById(prescriptionId).orElseThrow();
        System.out.println("  Prescription " + prescriptionId + " (" + p.getMedicineName() + " "
                + p.getDosage() + "): " + p.getRefillsUsed() + " of " + p.getTotalRefills()
                + " refills used");
    }

    private static void heading(String title) {
        System.out.println();
        System.out.println("=== " + title + " ===");
    }
}
