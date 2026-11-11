package com.refill.web;

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

    @Override
    public void init() {
        refillDao = new RefillRequestDAO();
        prescriptionDao = new PrescriptionDAO();
        log("RefillRequestServlet initialised");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String role = (String) session.getAttribute("role");
        try {
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
            Object flash = session.getAttribute("flash");
            if (flash != null) {
                req.setAttribute("flash", flash);
                session.removeAttribute("flash");
            }
            req.getRequestDispatcher("/WEB-INF/views/refills.jsp").forward(req, resp);
        } catch (SQLException ex) {
            throw new ServletException("Unable to load refill requests", ex);
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
            message = ex.getMessage();                    // business rule refused the action
        } catch (SQLException ex) {
            throw new ServletException("Refill operation failed", ex);
        }
        session.setAttribute("flash", message);
        resp.sendRedirect(req.getContextPath() + "/refills");   // Post-Redirect-Get
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
            case "submit" -> submit(req, session);
            case "approve" -> {
                refillDao.approve(requestId(req));        // Task 1 transaction
                yield "Request approved.";
            }
            case "reject" -> refillDao.reject(requestId(req))
                    ? "Request rejected." : "Only a pending request can be rejected.";
            case "collect" -> refillDao.markCollected(requestId(req))
                    ? "Request marked as collected." : "Only an approved request can be collected.";
            default -> throw new IllegalArgumentException("Unknown action: " + action);
        };
    }

    private String submit(HttpServletRequest req, HttpSession session) throws SQLException {
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

