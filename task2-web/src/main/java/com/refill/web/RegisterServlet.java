package com.refill.web;

import com.refill.util.DbUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.HexFormat;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final String REGISTER_VIEW = "/WEB-INF/views/register.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher(REGISTER_VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String role = req.getParameter("role");

        if (role == null || role.isBlank()) {
            role = "PATIENT";
        } else {
            role = role.trim().toUpperCase();
        }

        // 1. Validation checks
        if (name == null || name.isBlank() ||
            username == null || username.isBlank() ||
            password == null || password.isBlank()) {
            req.setAttribute("error", "Name, username, and password are required.");
            req.getRequestDispatcher(REGISTER_VIEW).forward(req, resp);
            return;
        }

        username = username.trim().toLowerCase();
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match. Please re-enter.");
            req.getRequestDispatcher(REGISTER_VIEW).forward(req, resp);
            return;
        }

        if (password.length() < 4) {
            req.setAttribute("error", "Password must be at least 4 characters.");
            req.getRequestDispatcher(REGISTER_VIEW).forward(req, resp);
            return;
        }

        try (Connection c = DbUtil.getConnection()) {
            // 2. Check username uniqueness
            String checkSql = "SELECT COUNT(*) FROM app_user WHERE username = ?";
            try (PreparedStatement psCheck = c.prepareStatement(checkSql)) {
                psCheck.setString(1, username);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        req.setAttribute("error", "Username '" + username + "' is already taken. Please pick another.");
                        req.getRequestDispatcher(REGISTER_VIEW).forward(req, resp);
                        return;
                    }
                }
            }

            // 3. Atomically register in transaction
            c.setAutoCommit(false);
            try {
                Integer patientId = null;
                if ("PATIENT".equals(role)) {
                    String ptSql = "INSERT INTO patient (name, phone) VALUES (?, ?)";
                    try (PreparedStatement psPt = c.prepareStatement(ptSql, Statement.RETURN_GENERATED_KEYS)) {
                        psPt.setString(1, name.trim());
                        psPt.setString(2, phone != null && !phone.isBlank() ? phone.trim() : "N/A");
                        psPt.executeUpdate();
                        try (ResultSet keys = psPt.getGeneratedKeys()) {
                            if (keys.next()) {
                                patientId = keys.getInt(1);
                            }
                        }
                    }
                }

                String userSql = "INSERT INTO app_user (username, password_hash, role, patient_id) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psUser = c.prepareStatement(userSql)) {
                    psUser.setString(1, username);
                    psUser.setString(2, sha256(password));
                    psUser.setString(3, role);
                    if (patientId != null) {
                        psUser.setInt(4, patientId);
                    } else {
                        psUser.setNull(4, Types.INTEGER);
                    }
                    psUser.executeUpdate();
                }

                c.commit();
            } catch (SQLException | RuntimeException ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }

            // Registration successful! Store flash message and redirect to login
            HttpSession session = req.getSession(true);
            session.setAttribute("flash", "Account registered successfully for " + username + " (" + role + ")! Please log in.");
            resp.sendRedirect(req.getContextPath() + "/login");

        } catch (SQLException ex) {
            throw new ServletException("Registration failed", ex);
        }
    }

    private static String sha256(String text) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            return HexFormat.of().formatHex(md.digest(text.getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException ex) {
            throw new IllegalStateException("SHA-256 is not available", ex);
        }
    }
}
