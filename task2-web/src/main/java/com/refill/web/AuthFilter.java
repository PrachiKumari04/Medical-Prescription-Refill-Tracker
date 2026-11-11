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

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (path.equals("/login") || path.startsWith("/css/")) {
            chain.doFilter(request, response);            // public resources
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        resp.setHeader("Cache-Control", "no-store");

        if ("POST".equalsIgnoreCase(req.getMethod()) && path.equals("/refills")) {
            boolean isPharmacist = "PHARMACIST".equals(session.getAttribute("role"));
            String action = req.getParameter("action");
            boolean pharmacistOnly = action != null && PHARMACIST_ACTIONS.contains(action);
            if (pharmacistOnly != isPharmacist) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "This action is not allowed for your role.");
                return;
            }
        }
        chain.doFilter(request, response);
    }
}

