package com.refill.web;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Set;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final Set<String> PHARMACIST_ACTIONS = Set.of("approve", "reject", "collect");
    private static final Set<String> PATIENT_ACTIONS = Set.of("submit", "submit_otc");
    private static final Set<String> DOCTOR_ACTIONS = Set.of("prescribe");

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (path.equals("/login") || path.equals("/register") || path.startsWith("/css/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        resp.setHeader("Cache-Control", "no-store");

        String role = (String) session.getAttribute("role");
        if ("POST".equalsIgnoreCase(req.getMethod()) && path.equals("/refills")) {
            String action = req.getParameter("action");
            if (action != null) {
                if (PHARMACIST_ACTIONS.contains(action) && !"PHARMACIST".equals(role)) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only a pharmacist can perform this action.");
                    return;
                }
                if (PATIENT_ACTIONS.contains(action) && !"PATIENT".equals(role)) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only a patient can submit refill requests.");
                    return;
                }
                if (DOCTOR_ACTIONS.contains(action) && !"DOCTOR".equals(role)) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only a doctor can prescribe medicines.");
                    return;
                }
            }
        }
        chain.doFilter(request, response);
    }
}
