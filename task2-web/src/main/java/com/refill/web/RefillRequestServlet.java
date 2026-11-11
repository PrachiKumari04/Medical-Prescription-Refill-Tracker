package com.refill.web;

import com.refill.dao.PatientDAO;
import com.refill.dao.PrescriptionDAO;
import com.refill.dao.RefillRequestDAO;
import com.refill.model.Prescription;
import com.refill.model.RefillRequest;
import com.refill.model.RefillStatus;
import com.refill.util.DbUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Optional;

@WebServlet("/refills")
public class RefillRequestServlet extends HttpServlet {

    private RefillRequestDAO refillDao;
    private PrescriptionDAO prescriptionDao;
    private PatientDAO patientDao;

    @Override
    public void init() {
        refillDao = new RefillRequestDAO();
        prescriptionDao = new PrescriptionDAO();
        patientDao = new PatientDAO();
        log("RefillRequestServlet initialised with Doctor & OTC capabilities");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String role = (String) session.getAttribute("role");
        try {
            Object flash = session.getAttribute("flash");
            if (flash != null) {
                req.setAttribute("flash", flash);
                session.removeAttribute("flash");
            }

            if ("DOCTOR".equals(role)) {
                // Doctor Dashboard: Patients list, Prescriptions with live stats, Audit requests log
                req.setAttribute("patients", patientDao.findAll());
                req.setAttribute("prescriptions", prescriptionDao.findAllWithStats());
                req.setAttribute("requests", refillDao.findAll());
                req.getRequestDispatcher("/WEB-INF/views/doctor.jsp").forward(req, resp);
                return;
            }

            if ("PHARMACIST".equals(role)) {
                RefillStatus filter = parseStatus(req.getParameter("status"));
                req.setAttribute("filter", filter);
                req.setAttribute("requests", refillDao.findByStatus(filter));
            } else {
                int patientId = (Integer) session.getAttribute("patientId");
                req.setAttribute("requests", refillDao.findByPatient(patientId));
                req.setAttribute("prescriptions", prescriptionDao.findByPatient(patientId));
            }
            req.setAttribute("statuses", RefillStatus.values());
            req.getRequestDispatcher("/WEB-INF/views/refills.jsp").forward(req, resp);
        } catch (SQLException ex) {
            throw new ServletException("Unable to load refill data", ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String message;
        try {
            message = perform(req, session);
        } catch (IllegalArgumentException ex) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, ex.getMessage());
            return;
        } catch (IllegalStateException ex) {
            message = ex.getMessage();
        } catch (SQLException ex) {
            throw new ServletException("Refill operation failed", ex);
        }
        session.setAttribute("flash", message);
        resp.sendRedirect(req.getContextPath() + "/refills");
    }

    @Override
    public void destroy() {
        DbUtil.shutdown();
        log("RefillRequestServlet destroyed");
    }

    private String perform(HttpServletRequest req, HttpSession session) throws SQLException {
        String action = req.getParameter("action");
        if (action == null) {
            throw new IllegalArgumentException("Missing action");
        }
        return switch (action) {
            case "submit" -> submitPrescriptionRefill(req, session);
            case "submit_otc" -> submitOtcDemand(req, session);
            case "prescribe" -> prescribeNewMedicine(req, session);
            case "approve" -> {
                refillDao.approve(requestId(req));
                yield "Request approved.";
            }
            case "reject" -> {
                int id = requestId(req);
                String reason = req.getParameter("reason");
                if (reason == null || reason.isBlank()) {
                    reason = "Refill rejected by pharmacist";
                }
                refillDao.reject(id, reason);
                yield "Request #" + id + " rejected. Reason: " + reason;
            }
            case "collect" -> refillDao.markCollected(requestId(req))
                    ? "Request marked as collected." : "Only an approved request can be collected.";
            default -> throw new IllegalArgumentException("Unknown action: " + action);
        };
    }

    private String submitPrescriptionRefill(HttpServletRequest req, HttpSession session) throws SQLException {
        int patientId = (Integer) session.getAttribute("patientId");
        int prescriptionId = Integer.parseInt(req.getParameter("prescriptionId"));
        Optional<Prescription> found = prescriptionDao.findById(prescriptionId);
        if (found.isEmpty() || found.get().getPatientId() != patientId) {
            throw new IllegalStateException("Prescription not found for this patient.");
        }
        if (found.get().getRefillsRemaining() <= 0) {
            throw new IllegalStateException("No refills remaining on this prescription.");
        }
        if (refillDao.existsPending(prescriptionId)) {
            throw new IllegalStateException("A refill request for this prescription is already pending.");
        }
        int id = refillDao.create(new RefillRequest(prescriptionId, LocalDate.now()));
        return "Refill request #" + id + " submitted.";
    }

    private String submitOtcDemand(HttpServletRequest req, HttpSession session) throws SQLException {
        int patientId = (Integer) session.getAttribute("patientId");
        String otcMedicine = req.getParameter("otcMedicine");
        String qtyStr = req.getParameter("quantity");
        if (otcMedicine == null || otcMedicine.isBlank()) {
            throw new IllegalStateException("Please select an over-the-counter medicine.");
        }
        int quantity = 1;
        try {
            quantity = Integer.parseInt(qtyStr);
        } catch (NumberFormatException e) {
            throw new IllegalStateException("Invalid quantity.");
        }
        if (quantity <= 0) {
            throw new IllegalStateException("Quantity must be at least 1 unit.");
        }
        // OTC LIMIT RULE: Maximum 10 units allowed without doctor prescription
        if (quantity > 10) {
            throw new IllegalStateException("Quantity (" + quantity + ") exceeds the over-the-counter limit (max 10 units). For higher quantities, please consult your doctor for a prescription.");
        }

        int id = refillDao.createOTC(patientId, otcMedicine.trim(), quantity, LocalDate.now());
        return "OTC demand for " + otcMedicine + " (Qty: " + quantity + ") submitted (#" + id + "). Pending pharmacist review.";
    }

    private String prescribeNewMedicine(HttpServletRequest req, HttpSession session) throws SQLException {
        int patientId = Integer.parseInt(req.getParameter("patientId"));
        String medicineName = req.getParameter("medicineName");
        String dosage = req.getParameter("dosage");
        int totalRefills = Integer.parseInt(req.getParameter("totalRefills"));

        if (medicineName == null || medicineName.isBlank() || dosage == null || dosage.isBlank()) {
            throw new IllegalStateException("Medicine name and dosage are mandatory.");
        }
        if (totalRefills < 0 || totalRefills > 24) {
            throw new IllegalStateException("Authorized refills must be between 0 and 24.");
        }

        int prescriptionId = prescriptionDao.create(patientId, medicineName.trim(), dosage.trim(), totalRefills);
        return "New prescription #" + prescriptionId + " (" + medicineName.trim() + " " + dosage.trim()
                + ", " + totalRefills + " refills) successfully prescribed.";
    }

    private static int requestId(HttpServletRequest req) {
        return Integer.parseInt(req.getParameter("requestId"));
    }

    private static RefillStatus parseStatus(String value) {
        if (value == null || value.isBlank()) {
            return RefillStatus.PENDING;
        }
        try {
            return RefillStatus.valueOf(value);
        } catch (IllegalArgumentException ex) {
            return RefillStatus.PENDING;
        }
    }
}
