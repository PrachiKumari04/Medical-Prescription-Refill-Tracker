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
import java.util.HexFormat;

@WebServlet(urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private static final String LOGIN_VIEW = "/WEB-INF/views/login.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if ("/logout".equals(req.getServletPath())) {
            resp.sendRedirect(req.getContextPath() + "/refills");
            return;
        }
        req.getRequestDispatcher(LOGIN_VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if ("/logout".equals(req.getServletPath())) {
            HttpSession current = req.getSession(false);
            if (current != null) {
                current.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        try {
            if (username != null && password != null && authenticate(req, username.trim(), password)) {
                resp.sendRedirect(req.getContextPath() + "/refills");
                return;
            }
        } catch (SQLException ex) {
            throw new ServletException("Login failed", ex);
        }
        req.setAttribute("error", "Invalid username or password.");
        resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        req.getRequestDispatcher(LOGIN_VIEW).forward(req, resp);
    }

    private boolean authenticate(HttpServletRequest req, String username, String password)
            throws SQLException {
        String sql = "SELECT user_id, role, patient_id FROM app_user WHERE username = ? AND password_hash = ?";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, sha256(password));
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }
                HttpSession old = req.getSession(false);
                if (old != null) {
                    old.invalidate();                      // defence against session fixation
                }
                HttpSession session = req.getSession(true);   // brand-new session id
                session.setMaxInactiveInterval(30 * 60);
                session.setAttribute("userId", rs.getInt("user_id"));
                session.setAttribute("username", username);
                session.setAttribute("role", rs.getString("role"));
                int patientId = rs.getInt("patient_id");
                if (!rs.wasNull()) {
                    session.setAttribute("patientId", patientId);
                }
                return true;
            }
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

