<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>RefillRx | Medical Prescription & Refill Tracker</title>
  <style>
    :root {
      --primary: #0284c7;
      --primary-dark: #0369a1;
      --primary-light: #e0f2fe;
      --teal: #0d9488;
      --teal-dark: #0f766e;
      --teal-light: #ccfbf1;
      --emerald: #10b981;
      --emerald-dark: #047857;
      --navy: #0f172a;
      --navy-light: #1e293b;
      --slate: #64748b;
      --slate-light: #f1f5f9;
      --surface: #ffffff;
      --background: #f8fafc;
      --amber: #f59e0b;
      --rose: #ef4444;
      --radius: 12px;
      --shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.08), 0 8px 10px -6px rgba(15, 23, 42, 0.04);
      --shadow-lg: 0 20px 35px -5px rgba(2, 132, 199, 0.15), 0 10px 15px -5px rgba(15, 23, 42, 0.06);
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
      background-color: var(--background);
      color: var(--navy);
      line-height: 1.6;
      overflow-x: hidden;
    }

    a { text-decoration: none; color: inherit; }

    /* --- NAV BAR --- */
    .navbar {
      position: sticky;
      top: 0;
      z-index: 100;
      background: rgba(255, 255, 255, 0.92);
      backdrop-filter: blur(12px);
      border-bottom: 1px solid #e2e8f0;
      padding: 14px 28px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      transition: all 0.3s ease;
    }
    .brand {
      display: flex;
      align-items: center;
      gap: 12px;
      font-weight: 800;
      font-size: 20px;
      color: var(--navy);
      letter-spacing: -0.5px;
    }
    .brand-icon {
      width: 38px;
      height: 38px;
      background: linear-gradient(135deg, #0284c7, #0d9488);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      box-shadow: 0 4px 10px rgba(2, 132, 199, 0.3);
      position: relative;
    }
    .brand-icon::after {
      content: "";
      position: absolute;
      width: 8px;
      height: 8px;
      background: #34d399;
      border-radius: 50%;
      top: 4px;
      right: 4px;
      box-shadow: 0 0 0 2px white;
      animation: pulseDot 2s infinite;
    }
    @keyframes pulseDot {
      0%, 100% { transform: scale(1); opacity: 1; }
      50% { transform: scale(1.4); opacity: 0.7; }
    }
    .nav-links {
      display: flex;
      align-items: center;
      gap: 28px;
      font-size: 14px;
      font-weight: 600;
      color: var(--slate);
    }
    .nav-links a:hover { color: var(--primary); }
    .nav-actions {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      padding: 10px 20px;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      border: none;
    }
    .btn-ghost {
      background: transparent;
      color: var(--navy);
      border: 1px solid #cbd5e1;
    }
    .btn-ghost:hover {
      background: var(--slate-light);
      border-color: #94a3b8;
    }
    .btn-primary {
      background: linear-gradient(135deg, var(--primary), #0369a1);
      color: white;
      box-shadow: 0 4px 12px rgba(2, 132, 199, 0.25);
    }
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 18px rgba(2, 132, 199, 0.35);
    }
    .btn-teal {
      background: linear-gradient(135deg, var(--teal), #0f766e);
      color: white;
      box-shadow: 0 4px 12px rgba(13, 148, 136, 0.25);
    }
    .btn-teal:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 18px rgba(13, 148, 136, 0.35);
    }
    .user-pill {
      background: #f0fdf4;
      border: 1px solid #86efac;
      color: #166534;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    /* --- HERO SECTION --- */
    .hero {
      position: relative;
      max-width: 1240px;
      margin: 0 auto;
      padding: 80px 24px 60px;
      display: grid;
      grid-template-columns: 1.15fr 0.85fr;
      gap: 48px;
      align-items: center;
    }
    .hero-tag {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: var(--primary-light);
      color: var(--primary-dark);
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 700;
      margin-bottom: 20px;
      border: 1px solid #bae6fd;
    }
    .hero-tag span {
      background: var(--primary);
      color: white;
      font-size: 10px;
      padding: 2px 6px;
      border-radius: 10px;
      text-transform: uppercase;
    }
    .hero h1 {
      font-size: 48px;
      line-height: 1.15;
      font-weight: 800;
      color: var(--navy);
      letter-spacing: -1.2px;
      margin-bottom: 20px;
    }
    .hero h1 .gradient-text {
      background: linear-gradient(135deg, #0284c7 0%, #0d9488 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    .hero-subtitle {
      font-size: 18px;
      color: var(--slate);
      line-height: 1.6;
      margin-bottom: 32px;
    }
    .hero-cta {
      display: flex;
      gap: 16px;
      flex-wrap: wrap;
      margin-bottom: 36px;
    }
    .hero-metrics {
      display: flex;
      gap: 24px;
      padding-top: 24px;
      border-top: 1px solid #e2e8f0;
    }
    .metric-item strong {
      display: block;
      font-size: 24px;
      color: var(--navy);
      font-weight: 800;
    }
    .metric-item span {
      font-size: 13px;
      color: var(--slate);
      font-weight: 500;
    }

    /* --- ANIMATED MEDICAL HERO CARD --- */
    .hero-stage {
      position: relative;
      background: radial-gradient(circle at 50% 50%, #eff6ff 0%, #f8fafc 100%);
      border-radius: 24px;
      padding: 36px 28px;
      border: 1px solid #e2e8f0;
      box-shadow: var(--shadow-lg);
      min-height: 440px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      overflow: hidden;
    }
    /* Ambient Glowing Orbs */
    .hero-stage::before {
      content: "";
      position: absolute;
      top: -40px;
      right: -40px;
      width: 180px;
      height: 180px;
      background: rgba(13, 148, 136, 0.12);
      border-radius: 50%;
      filter: blur(40px);
      z-index: 0;
    }
    .hero-stage::after {
      content: "";
      position: absolute;
      bottom: -40px;
      left: -40px;
      width: 180px;
      height: 180px;
      background: rgba(2, 132, 199, 0.12);
      border-radius: 50%;
      filter: blur(40px);
      z-index: 0;
    }

    /* Floating Pill Capsules */
    .capsule-badge {
      position: relative;
      z-index: 2;
      background: white;
      border-radius: 16px;
      padding: 14px 18px;
      box-shadow: 0 10px 20px -3px rgba(15, 23, 42, 0.08);
      border: 1px solid #f1f5f9;
      display: flex;
      align-items: center;
      gap: 14px;
      margin-bottom: 16px;
      transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
      cursor: pointer;
    }
    .capsule-badge:hover {
      transform: translateY(-4px) scale(1.02);
      box-shadow: 0 14px 28px -4px rgba(15, 23, 42, 0.12);
    }
    .capsule-float-1 {
      animation: floatA 4.5s ease-in-out infinite;
    }
    .capsule-float-2 {
      animation: floatB 5s ease-in-out infinite 0.6s;
    }
    .capsule-float-3 {
      animation: floatA 4.8s ease-in-out infinite 1.2s;
    }
    @keyframes floatA {
      0%, 100% { transform: translateY(0px) rotate(0deg); }
      50% { transform: translateY(-7px) rotate(0.8deg); }
    }
    @keyframes floatB {
      0%, 100% { transform: translateY(0px) rotate(0deg); }
      50% { transform: translateY(7px) rotate(-0.8deg); }
    }

    /* 3D Pill Capsule Graphic */
    .pill-icon {
      width: 44px;
      height: 22px;
      border-radius: 20px;
      position: relative;
      overflow: hidden;
      box-shadow: inset 0 2px 4px rgba(255, 255, 255, 0.6), 0 3px 6px rgba(0,0,0,0.15);
      flex-shrink: 0;
      transform: rotate(-25deg);
    }
    .pill-teal {
      background: linear-gradient(90deg, #0d9488 50%, #ffffff 50%);
      border: 1px solid #0d9488;
    }
    .pill-blue {
      background: linear-gradient(90deg, #2563eb 50%, #f59e0b 50%);
      border: 1px solid #2563eb;
    }
    .pill-emerald {
      background: linear-gradient(90deg, #10b981 50%, #ffffff 50%);
      border: 1px solid #10b981;
    }
    .capsule-info strong {
      display: block;
      font-size: 14px;
      color: var(--navy);
    }
    .capsule-info span {
      font-size: 12px;
      color: var(--slate);
    }
    .status-chip {
      margin-left: auto;
      padding: 4px 10px;
      border-radius: 20px;
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 0.3px;
    }
    .chip-green { background: #dcfce7; color: #15803d; }
    .chip-blue { background: #e0f2fe; color: #0369a1; }
    .chip-amber { background: #fef3c7; color: #b45309; }

    /* Animated Heartbeat ECG line */
    .ecg-container {
      position: relative;
      z-index: 2;
      background: #0f172a;
      border-radius: 14px;
      padding: 16px 20px;
      color: white;
      display: flex;
      align-items: center;
      gap: 14px;
    }
    .ecg-svg {
      width: 140px;
      height: 32px;
    }
    .ecg-path {
      stroke: #34d399;
      stroke-width: 2.2;
      fill: none;
      stroke-dasharray: 200;
      stroke-dashoffset: 200;
      animation: drawHeartbeat 2.4s linear infinite;
    }
    @keyframes drawHeartbeat {
      0% { stroke-dashoffset: 200; }
      100% { stroke-dashoffset: 0; }
    }
    .ecg-text {
      font-size: 12px;
      line-height: 1.4;
    }
    .ecg-text strong {
      display: block;
      color: #34d399;
      font-size: 13px;
    }

    /* --- SECTION WRAPPERS --- */
    .section {
      max-width: 1240px;
      margin: 0 auto;
      padding: 70px 24px;
    }
    .section-header {
      text-align: center;
      max-width: 700px;
      margin: 0 auto 48px;
    }
    .section-badge {
      display: inline-block;
      font-size: 12px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: var(--teal);
      background: var(--teal-light);
      padding: 4px 12px;
      border-radius: 20px;
      margin-bottom: 12px;
    }
    .section-title {
      font-size: 34px;
      font-weight: 800;
      color: var(--navy);
      letter-spacing: -0.8px;
      margin-bottom: 14px;
    }
    .section-desc {
      font-size: 16px;
      color: var(--slate);
    }

    /* --- INTERACTIVE RX LAB / SIMULATOR --- */
    .simulator-box {
      background: white;
      border-radius: 20px;
      border: 1px solid #e2e8f0;
      box-shadow: var(--shadow-lg);
      padding: 36px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 36px;
      align-items: center;
    }
    .sim-controls label {
      display: block;
      font-size: 13px;
      font-weight: 700;
      color: var(--navy);
      margin-bottom: 8px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .sim-select, .sim-slider {
      width: 100%;
      padding: 12px 14px;
      border: 2px solid #e2e8f0;
      border-radius: 10px;
      font-size: 15px;
      color: var(--navy);
      background: #f8fafc;
      outline: none;
      transition: all 0.2s ease;
      margin-bottom: 24px;
    }
    .sim-select:focus {
      border-color: var(--primary);
      background: white;
      box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.15);
    }
    .slider-wrap {
      margin-bottom: 24px;
    }
    .slider-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 8px;
    }
    .slider-val {
      font-weight: 800;
      font-size: 18px;
      color: var(--primary);
      background: var(--primary-light);
      padding: 2px 10px;
      border-radius: 6px;
    }
    .sim-slider {
      padding: 0;
      height: 8px;
      accent-color: var(--primary);
      cursor: pointer;
    }

    /* Simulator Live Card Result */
    .sim-display {
      background: linear-gradient(135deg, #f8fafc, #eff6ff);
      border: 2px dashed #cbd5e1;
      border-radius: 16px;
      padding: 28px;
      position: relative;
      transition: all 0.3s ease;
    }
    .sim-display.status-approved {
      border-color: #86efac;
      background: #f0fdf4;
    }
    .sim-display.status-warning {
      border-color: #fca5a5;
      background: #fef2f2;
    }
    .sim-display.status-rx {
      border-color: #93c5fd;
      background: #eff6ff;
    }
    .disp-tag {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 800;
      margin-bottom: 12px;
    }
    .disp-headline {
      font-size: 20px;
      font-weight: 800;
      color: var(--navy);
      margin-bottom: 10px;
    }
    .disp-body {
      font-size: 14px;
      color: var(--slate);
      line-height: 1.6;
      margin-bottom: 20px;
    }
    .disp-meta {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
      padding-top: 16px;
      border-top: 1px solid rgba(0,0,0,0.06);
      font-size: 12px;
    }
    .disp-meta strong {
      display: block;
      color: var(--navy);
      font-size: 13px;
    }

    /* --- ROLE PERSPECTIVES TABS --- */
    .tabs-nav {
      display: flex;
      justify-content: center;
      gap: 12px;
      margin-bottom: 32px;
      flex-wrap: wrap;
    }
    .tab-btn {
      padding: 12px 24px;
      border-radius: 30px;
      background: white;
      border: 1px solid #cbd5e1;
      font-size: 15px;
      font-weight: 700;
      color: var(--slate);
      cursor: pointer;
      transition: all 0.2s ease;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .tab-btn:hover {
      border-color: var(--primary);
      color: var(--primary);
    }
    .tab-btn.active {
      background: var(--navy);
      color: white;
      border-color: var(--navy);
      box-shadow: 0 4px 12px rgba(15, 23, 42, 0.2);
    }
    .tab-content {
      display: none;
      animation: fadeIn 0.3s ease;
    }
    .tab-content.active {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 36px;
      background: white;
      border-radius: 20px;
      border: 1px solid #e2e8f0;
      box-shadow: var(--shadow);
      padding: 40px;
      align-items: center;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(8px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .tab-bullets {
      list-style: none;
      margin-top: 20px;
    }
    .tab-bullets li {
      display: flex;
      align-items: flex-start;
      gap: 12px;
      font-size: 15px;
      color: var(--navy-light);
      margin-bottom: 14px;
    }
    .tab-check {
      width: 22px;
      height: 22px;
      background: #dcfce7;
      color: #15803d;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 13px;
      font-weight: bold;
      flex-shrink: 0;
      margin-top: 2px;
    }
    .tab-mockup {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 14px;
      padding: 24px;
      box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);
    }

    /* --- SYLLABUS ARCHITECTURE CARDS --- */
    .arch-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 20px;
    }
    .arch-card {
      background: white;
      border-radius: 14px;
      padding: 24px;
      border: 1px solid #e2e8f0;
      box-shadow: var(--shadow);
      transition: all 0.25s ease;
      position: relative;
      overflow: hidden;
    }
    .arch-card:hover {
      transform: translateY(-5px);
      box-shadow: var(--shadow-lg);
      border-color: var(--primary);
    }
    .arch-badge {
      display: inline-block;
      font-size: 11px;
      font-weight: 800;
      padding: 3px 8px;
      border-radius: 4px;
      margin-bottom: 12px;
      text-transform: uppercase;
    }
    .arch-card h3 {
      font-size: 17px;
      color: var(--navy);
      margin-bottom: 8px;
      font-weight: 700;
    }
    .arch-card p {
      font-size: 13px;
      color: var(--slate);
      line-height: 1.5;
    }

    /* --- QUICK DEMO CREDS DRAWER --- */
    .demo-bar {
      background: linear-gradient(135deg, #0f172a, #1e293b);
      border-radius: 20px;
      padding: 36px;
      color: white;
      margin: 40px auto;
      max-width: 1240px;
      box-shadow: 0 15px 30px rgba(15, 23, 42, 0.2);
    }
    .demo-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
      flex-wrap: wrap;
      gap: 16px;
    }
    .demo-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
      gap: 20px;
    }
    .demo-card {
      background: rgba(255, 255, 255, 0.06);
      border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 12px;
      padding: 20px;
      transition: background 0.2s ease;
    }
    .demo-card:hover {
      background: rgba(255, 255, 255, 0.1);
    }
    .demo-card strong {
      display: block;
      font-size: 15px;
      margin-bottom: 4px;
    }
    .demo-card code {
      background: rgba(0,0,0,0.3);
      padding: 3px 8px;
      border-radius: 4px;
      font-size: 13px;
      color: #38bdf8;
      font-family: monospace;
    }
    .demo-card p {
      font-size: 12px;
      color: #94a3b8;
      margin-top: 8px;
    }

    /* --- FOOTER --- */
    footer {
      background: white;
      border-top: 1px solid #e2e8f0;
      padding: 40px 24px;
      text-align: center;
      font-size: 14px;
      color: var(--slate);
    }
    footer a { color: var(--primary); font-weight: 600; }
    footer a:hover { text-decoration: underline; }

    /* --- RESPONSIVE BREAKPOINTS --- */
    @media (max-width: 900px) {
      .hero { grid-template-columns: 1fr; padding-top: 40px; }
      .hero h1 { font-size: 36px; }
      .simulator-box { grid-template-columns: 1fr; }
      .tab-content.active { grid-template-columns: 1fr; }
      .navbar { padding: 12px 16px; }
      .nav-links { display: none; }
    }
  </style>
</head>
<body>

  <!-- ============================================================== -->
  <!-- NAVIGATION BAR -->
  <!-- ============================================================== -->
  <header class="navbar">
    <a href="${pageContext.request.contextPath}/" class="brand">
      <div class="brand-icon">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"></path>
          <path d="m8.5 8.5 7 7"></path>
        </svg>
      </div>
      <span>RefillRx</span>
    </a>

    <nav class="nav-links">
      <a href="#how-it-works">How It Works</a>
      <a href="#simulator">Rx Lab Simulator</a>
      <a href="#portals">3 Roles</a>
      <a href="#architecture">MCA Architecture</a>
      <a href="https://github.com/PrachiKumari04/Medical-Prescription-Refill-Tracker" target="_blank">GitHub</a>
    </nav>

    <div class="nav-actions">
      <c:choose>
        <c:when test="${not empty sessionScope.username}">
          <div class="user-pill">
            <span>●</span> Signed in as <strong><c:out value="${sessionScope.username}"/></strong>
          </div>
          <a href="${pageContext.request.contextPath}/refills" class="btn btn-primary">Go to Portal &rarr;</a>
          <form method="post" action="${pageContext.request.contextPath}/logout" style="display:inline;">
            <button class="btn btn-ghost" type="submit">Log out</button>
          </form>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost">Sign In</a>
          <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Create Account &rarr;</a>
        </c:otherwise>
      </c:choose>
    </div>
  </header>


  <!-- ============================================================== -->
  <!-- HERO SECTION -->
  <!-- ============================================================== -->
  <main>
    <section class="hero">
      <div>
        <div class="hero-tag">
          <span>MCA Mini-Project</span> Course: 24MCAC302 Advance Java
        </div>
        <h1>
          Precision Refills.<br>
          <span class="gradient-text">Clinician Verified.</span><br>
          Zero Counter Delays.
        </h1>
        <p class="hero-subtitle">
          An enterprise-grade medical refill management system bridging patients, prescribing doctors, and pharmacy teams with real-time atomic inventory verification, self-service OTC safety ceilings, and full rejection auditability.
        </p>

        <div class="hero-cta">
          <c:choose>
            <c:when test="${not empty sessionScope.username}">
              <a href="${pageContext.request.contextPath}/refills" class="btn btn-primary" style="padding: 13px 28px; font-size: 15px;">
                Enter Your Portal Dashboard &rarr;
              </a>
            </c:when>
            <c:otherwise>
              <a href="${pageContext.request.contextPath}/login" class="btn btn-primary" style="padding: 13px 28px; font-size: 15px;">
                Sign In to Portal &rarr;
              </a>
              <a href="${pageContext.request.contextPath}/register" class="btn btn-teal" style="padding: 13px 28px; font-size: 15px;">
                Register as Patient / Doctor
              </a>
            </c:otherwise>
          </c:choose>
          <a href="#simulator" class="btn btn-ghost" style="padding: 13px 20px; font-size: 15px;">
            🧪 Test Refill Simulator
          </a>
        </div>

        <div class="hero-metrics">
          <div class="metric-item">
            <strong>&lt; 2 mins</strong>
            <span>Refill Turnaround</span>
          </div>
          <div class="metric-item">
            <strong>10 Max</strong>
            <span>Safe OTC Threshold</span>
          </div>
          <div class="metric-item">
            <strong>100%</strong>
            <span>Atomic Stock Lock</span>
          </div>
          <div class="metric-item">
            <strong>5 Units</strong>
            <span>Syllabus Stages Live</span>
          </div>
        </div>
      </div>

      <!-- ANIMATED HERO MEDICAL CARD -->
      <div class="hero-stage">
        <!-- Floating Pill Capsule 1 -->
        <div class="capsule-badge capsule-float-1" onclick="selectDemoDrug('Paracetamol 500 mg (Pain & Fever)', 8)">
          <div class="pill-icon pill-teal"></div>
          <div class="capsule-info">
            <strong>Paracetamol 500 mg</strong>
            <span>Self-Service OTC • Pain & Fever</span>
          </div>
          <span class="status-chip chip-green">Instant Approve</span>
        </div>

        <!-- Floating Pill Capsule 2 -->
        <div class="capsule-badge capsule-float-2" onclick="selectDemoDrug('Telmisartan 40 mg (Hypertension)', 1)">
          <div class="pill-icon pill-blue"></div>
          <div class="capsule-info">
            <strong>Telmisartan 40 mg</strong>
            <span>Physician Authorized Rx • 6 Refills Left</span>
          </div>
          <span class="status-chip chip-blue">Dr. Patil Verified</span>
        </div>

        <!-- Floating Pill Capsule 3 -->
        <div class="capsule-badge capsule-float-3" onclick="selectDemoDrug('Ibuprofen 200 mg (Pain Relief)', 12)">
          <div class="pill-icon pill-emerald"></div>
          <div class="capsule-info">
            <strong>Ibuprofen 200 mg (Qty: 12)</strong>
            <span>Exceeds OTC Safety Ceiling (&gt;10 units)</span>
          </div>
          <span class="status-chip chip-amber">Doctor Review Req.</span>
        </div>

        <!-- Animated EKG Pulse Wave -->
        <div class="ecg-container">
          <svg class="ecg-svg" viewBox="0 0 140 32">
            <path class="ecg-path" d="M0,16 L30,16 L38,6 L44,26 L50,10 L54,19 L58,16 L140,16"/>
          </svg>
          <div class="ecg-text">
            <strong>Live Safety Engine</strong>
            <span>Active transactions with row-level locks</span>
          </div>
        </div>
      </div>
    </section>


    <!-- ============================================================== -->
    <!-- INTERACTIVE REFILL SIMULATOR (FUN & MEDICAL) -->
    <!-- ============================================================== -->
    <section class="section" id="simulator">
      <div class="section-header">
        <span class="section-badge">Interactive Healthcare Lab</span>
        <h2 class="section-title">Test the Refill & Safety Logic Live</h2>
        <p class="section-desc">
          Experience how RefillRx prevents accidental overdose, validates chronic physician authorizations, and safeguards patient refills in real time.
        </p>
      </div>

      <div class="simulator-box">
        <!-- Controls -->
        <div class="sim-controls">
          <label for="drugSelect">1. Choose Medication:</label>
          <select id="drugSelect" class="sim-select" onchange="runSimulation()">
            <optgroup label="Over-The-Counter (Self-Service Common Medicines)">
              <option value="otc_para" data-name="Paracetamol 500 mg" data-type="OTC" data-desc="Common analgesic & antipyretic for mild-to-moderate fever and headache.">Paracetamol 500 mg (Pain & Fever)</option>
              <option value="otc_ibup" data-name="Ibuprofen 200 mg" data-type="OTC" data-desc="Non-steroidal anti-inflammatory (NSAID) for muscle cramps and body pain.">Ibuprofen 200 mg (Pain Relief)</option>
              <option value="otc_cet" data-name="Cetirizine 10 mg" data-type="OTC" data-desc="Antihistamine for seasonal rhinitis, sneezing, and allergies.">Cetirizine 10 mg (Allergy & Cold)</option>
              <option value="otc_antacid" data-name="Antacid Chewable Gel" data-type="OTC" data-desc="Neutralizes excess stomach acid; fast relief for heartburn.">Antacid Chewable Gel (Acidity)</option>
            </optgroup>
            <optgroup label="Doctor-Prescribed Chronic Therapies (Rx Only)">
              <option value="rx_met" data-name="Metformin 500 mg" data-type="RX" data-desc="Prescribed by Dr. Patil for Type-2 Glycemic Control. (Rx #101)">Metformin 500 mg (Type-2 Diabetes Rx)</option>
              <option value="rx_ator" data-name="Atorvastatin 10 mg" data-type="RX" data-desc="Prescribed by Dr. Patil for Lipid Management. (Rx #102)">Atorvastatin 10 mg (Cholesterol Rx)</option>
              <option value="rx_telmi" data-name="Telmisartan 40 mg" data-type="RX" data-desc="Prescribed by Dr. Patil for Hypertension. (Rx #103)">Telmisartan 40 mg (Blood Pressure Rx)</option>
            </optgroup>
          </select>

          <div class="slider-wrap">
            <div class="slider-header">
              <label for="qtyRange" style="margin-bottom:0;">2. Requested Quantity (Pills / Packs):</label>
              <span class="slider-val" id="qtyDisplay">6</span>
            </div>
            <input type="range" id="qtyRange" class="sim-slider" min="1" max="25" value="6" oninput="updateQty(this.value)">
            <div style="display:flex; justify-content:space-between; font-size:11px; color:var(--slate); margin-top:4px;">
              <span>1 pack</span>
              <span style="color:var(--teal); font-weight:bold;">Safe OTC Limit: 10</span>
              <span>25 packs</span>
            </div>
          </div>

          <div style="background:#f1f5f9; padding:12px 16px; border-radius:8px; font-size:13px; color:var(--slate);">
            💡 <strong>Safety Policy Rule:</strong> Common OTC drugs up to <strong>10 units</strong> are auto-approved without consultation. If quantity &gt; 10, a doctor prescription is legally required.
          </div>
        </div>

        <!-- Live Reaction Display -->
        <div id="simResult" class="sim-display status-approved">
          <span id="resBadge" class="disp-tag chip-green">APPROVED &bull; OTC SAFE</span>
          <h3 id="resHeadline" class="disp-headline">Ready for Instant Dispense</h3>
          <p id="resBody" class="disp-body">
            Request complies with clinic self-service guidelines (Quantity &le; 10). Directly queued on Pharmacist Pharma1's workbench for pickup preparation.
          </p>

          <div class="disp-meta">
            <div>
              <span>Verification Mechanism:</span>
              <strong id="resMechanism">Self-Service OTC Check</strong>
            </div>
            <div>
              <span>Turnaround Time:</span>
              <strong id="resTime">&lt; 5 minutes at counter</strong>
            </div>
            <div>
              <span>Clinician Action:</span>
              <strong id="resAction">None Required (Safe Dose)</strong>
            </div>
            <div>
              <span>Database State:</span>
              <strong id="resDbState">Atomic PENDING &rarr; APPROVED</strong>
            </div>
          </div>
        </div>
      </div>
    </section>


    <!-- ============================================================== -->
    <!-- 3 CLINICAL PORTALS / ROLES -->
    <!-- ============================================================== -->
    <section class="section" id="portals">
      <div class="section-header">
        <span class="section-badge">Collaborative Care</span>
        <h2 class="section-title">Designed for the Entire Clinical Care Team</h2>
        <p class="section-desc">
          Tailored user interfaces with role-based access control (RBAC) ensuring patients, doctors, and pharmacists have the exact tools they need.
        </p>
      </div>

      <!-- Tab Buttons -->
      <div class="tabs-nav">
        <button class="tab-btn active" onclick="switchTab('patient', this)">🧑 Patient Portal</button>
        <button class="tab-btn" onclick="switchTab('doctor', this)">👨‍⚕️ Doctor / Clinician Desk</button>
        <button class="tab-btn" onclick="switchTab('pharmacist', this)">💊 Pharmacist Dispense Queue</button>
      </div>

      <!-- Tab 1: Patient -->
      <div id="tab-patient" class="tab-content active">
        <div>
          <span class="section-badge" style="background:#fef3c7; color:#b45309;">Self-Service Portal</span>
          <h3 style="font-size:24px; color:var(--navy); margin-bottom:12px;">Patients: Stay in Control of Your Care</h3>
          <p style="color:var(--slate); font-size:15px;">
            Empowering patients with transparent refill statuses, countdown timers on remaining refills, and friction-free requests for common over-the-counter pain relievers.
          </p>
          <ul class="tab-bullets">
            <li><span class="tab-check">✓</span> <strong>1-Click Chronic Refills:</strong> Request refills from authorized prescriptions in under 5 seconds.</li>
            <li><span class="tab-check">✓</span> <strong>OTC Common Medicine Demand:</strong> Fast access to Paracetamol, Ibuprofen, and ORS hydration without queueing.</li>
            <li><span class="tab-check">✓</span> <strong>Clear Rejection Reasons:</strong> If a request is declined, the pharmacist's clinical note is shown instantly.</li>
          </ul>
          <a href="${pageContext.request.contextPath}/login" class="btn btn-primary" style="margin-top:16px;">Log In as Patient (ravi / patient123) &rarr;</a>
        </div>
        <div class="tab-mockup">
          <div style="background:white; border-radius:10px; padding:16px; border:1px solid #e2e8f0;">
            <div style="display:flex; justify-content:space-between; margin-bottom:12px;">
              <span style="font-size:12px; font-weight:bold; color:#0284c7;">Rx REFILL CARD</span>
              <span style="font-size:11px; background:#dcfce7; color:#15803d; padding:2px 6px; border-radius:4px; font-weight:bold;">4 OF 5 LEFT</span>
            </div>
            <strong style="display:block; font-size:16px; color:#0f172a;">Metformin 500 mg</strong>
            <span style="font-size:13px; color:#64748b;">Take twice daily after meals with water</span>
            <button class="btn btn-primary" style="width:100%; margin-top:14px; padding:8px; font-size:13px;" disabled>
              ✓ Request Submitted — Awaiting Pharmacy
            </button>
          </div>
        </div>
      </div>

      <!-- Tab 2: Doctor -->
      <div id="tab-doctor" class="tab-content">
        <div>
          <span class="section-badge" style="background:#e0f2fe; color:#0369a1;">Clinician Workspace</span>
          <h3 style="font-size:24px; color:var(--navy); margin-bottom:12px;">Doctors: Prescribe & Track Adherence</h3>
          <p style="color:var(--slate); font-size:15px;">
            Physicians maintain complete oversight: prescribe new medications to any registered patient, view aggregate refill histories, and monitor pharmacist dispensing decisions.
          </p>
          <ul class="tab-bullets">
            <li><span class="tab-check">✓</span> <strong>Prescribe in Seconds:</strong> Assign drugs, dosages, and refill quantities directly to registered patients.</li>
            <li><span class="tab-check">✓</span> <strong>Patient Refill Statistics:</strong> Review total requested, approved, and dispensed prescriptions per patient.</li>
            <li><span class="tab-check">✓</span> <strong>Pharmacist Audit Trail:</strong> See exact rejection rationales and dispensed dates for clinical reviews.</li>
          </ul>
          <a href="${pageContext.request.contextPath}/login" class="btn btn-primary" style="margin-top:16px;">Log In as Doctor (drpatil / doc123) &rarr;</a>
        </div>
        <div class="tab-mockup">
          <div style="background:white; border-radius:10px; padding:16px; border:1px solid #e2e8f0;">
            <div style="font-size:12px; font-weight:bold; color:#0369a1; margin-bottom:6px;">NEW PRESCRIPTION FORM</div>
            <div style="font-size:13px; margin-bottom:8px;"><strong>Patient:</strong> Karan Sharma (ID: #5)</div>
            <div style="font-size:13px; margin-bottom:8px;"><strong>Rx Drug:</strong> Telmisartan 40 mg (Once daily)</div>
            <div style="font-size:13px; margin-bottom:12px;"><strong>Authorized Refills:</strong> 6 refills</div>
            <span style="display:inline-block; font-size:11px; background:#e0f2fe; color:#0369a1; padding:4px 8px; border-radius:4px; font-weight:bold;">
              ✓ Atomically Synced with Patient Portal
            </span>
          </div>
        </div>
      </div>

      <!-- Tab 3: Pharmacist -->
      <div id="tab-pharmacist" class="tab-content">
        <div>
          <span class="section-badge" style="background:#dcfce7; color:#15803d;">Pharmacy Workbench</span>
          <h3 style="font-size:24px; color:var(--navy); margin-bottom:12px;">Pharmacists: Two-Step Safety Verification</h3>
          <p style="color:var(--slate); font-size:15px;">
            The dispensary gatekeeper: review incoming refill requests, verify remaining authorized refills with atomic locks, provide mandatory rejection reasons, and log collections.
          </p>
          <ul class="tab-bullets">
            <li><span class="tab-check">✓</span> <strong>Row-Level Concurrency Protection:</strong> Prevents race conditions during simultaneous refill attempts.</li>
            <li><span class="tab-check">✓</span> <strong>Mandatory Rejection Logging:</strong> Prompts the pharmacist for safety notes shown to both doctor and patient.</li>
            <li><span class="tab-check">✓</span> <strong>Status Progression:</strong> Seamless transition through PENDING &rarr; APPROVED &rarr; COLLECTED.</li>
          </ul>
          <a href="${pageContext.request.contextPath}/login" class="btn btn-teal" style="margin-top:16px;">Log In as Pharmacist (pharma1 / pharma123) &rarr;</a>
        </div>
        <div class="tab-mockup">
          <div style="background:white; border-radius:10px; padding:16px; border:1px solid #e2e8f0;">
            <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
              <span style="font-size:11px; font-weight:bold; background:#d97706; color:white; padding:2px 8px; border-radius:10px;">PENDING REVIEW</span>
              <span style="font-size:12px; color:#64748b;">Request #17</span>
            </div>
            <strong style="display:block; font-size:15px; color:#0f172a;">Karan Sharma &bull; Paracetamol 500 mg (8 units)</strong>
            <p style="font-size:12px; color:#64748b; margin:6px 0 12px;">OTC Self-service demand within safe limits (&le; 10)</p>
            <div style="display:flex; gap:8px;">
              <button class="btn btn-teal" style="flex:1; padding:6px; font-size:12px;" disabled>Approve</button>
              <button class="btn btn-ghost" style="flex:1; padding:6px; font-size:12px; color:#dc2626; border-color:#fca5a5;" disabled>Reject...</button>
            </div>
          </div>
        </div>
      </div>
    </section>


    <!-- ============================================================== -->
    <!-- MCA SEM III SYLLABUS ARCHITECTURE MATRIX -->
    <!-- ============================================================== -->
    <section class="section" id="architecture" style="background:#f1f5f9; border-radius:24px; margin:40px auto; padding:60px 32px;">
      <div class="section-header">
        <span class="section-badge">MCA Semester III Curriculum</span>
        <h2 class="section-title">End-to-End Advanced Java Architecture</h2>
        <p class="section-desc">
          Developed to strictly satisfy and demonstrate all 5 core units of the MCA Advanced Java Programming syllabus (Course: 24MCAC302).
        </p>
      </div>

      <div class="arch-grid">
        <!-- Unit 1 -->
        <div class="arch-card">
          <span class="arch-badge" style="background:#e0f2fe; color:#0369a1;">Unit 1 &bull; JDBC</span>
          <h3>HikariCP & Transactions</h3>
          <p>Production connection pool with row-level <code>SELECT ... FOR UPDATE</code> locks and batch execution in <code>RefillDAOImpl</code>.</p>
        </div>

        <!-- Unit 2 -->
        <div class="arch-card">
          <span class="arch-badge" style="background:#dcfce7; color:#15803d;">Unit 2 &bull; Servlets</span>
          <h3>Jakarta Servlets & JSP</h3>
          <p>Session fixation protection, role-based <code>AuthFilter</code>, PRG pattern redirect, and JSTL 3.0 server-side rendering.</p>
        </div>

        <!-- Unit 3 -->
        <div class="arch-card">
          <span class="arch-badge" style="background:#fef3c7; color:#b45309;">Unit 3 &bull; Spring MVC</span>
          <h3>JPA & Spring MVC</h3>
          <p>JPA entities, JPQL with <code>join fetch</code>, Spring IoC container, declarative <code>@Transactional</code> and Bean Validation.</p>
        </div>

        <!-- Unit 4 -->
        <div class="arch-card">
          <span class="arch-badge" style="background:#f3e8ff; color:#7e22ce;">Unit 4 &bull; Boot REST</span>
          <h3>RESTful Microservice</h3>
          <p>Spring Boot 3.3.4, Spring Data JPA, PATCH transitions, <code>@RestControllerAdvice</code> RFC-7807 error envelopes, Actuator.</p>
        </div>

        <!-- Unit 5 -->
        <div class="arch-card">
          <span class="arch-badge" style="background:#fee2e2; color:#b91c1c;">Unit 5 &bull; Hibernate</span>
          <h3>HQL, Criteria & L2 Cache</h3>
          <p>Hibernate 6 SessionFactory, dynamic Criteria query builder, aggregation queries, and Ehcache 3 second-level caching.</p>
        </div>
      </div>
    </section>


    <!-- ============================================================== -->
    <!-- QUICK DEMO CREDS DRAWER -->
    <!-- ============================================================== -->
    <div class="demo-bar">
      <div class="demo-header">
        <div>
          <h3 style="font-size:22px; font-weight:800; margin-bottom:4px;">1-Click Ready Demo Accounts</h3>
          <p style="font-size:14px; color:#94a3b8;">Use these pre-configured credentials to evaluate any perspective immediately.</p>
        </div>
        <div>
          <a href="${pageContext.request.contextPath}/register" class="btn btn-teal">
            + Register New Account
          </a>
        </div>
      </div>

      <div class="demo-grid">
        <div class="demo-card">
          <strong>👨‍⚕️ Doctor / Clinician</strong>
          <span>Username: <code>drpatil</code></span><br>
          <span>Password: <code>doc123</code></span>
          <p>Prescribe new medicines, view refill analytics & audit logs.</p>
        </div>

        <div class="demo-card">
          <strong>💊 Pharmacist (Dispensary)</strong>
          <span>Username: <code>pharma1</code></span><br>
          <span>Password: <code>pharma123</code></span>
          <p>Approve/Reject requests with reason, dispense medicines.</p>
        </div>

        <div class="demo-card">
          <strong>🧑 Patient (Self-Service)</strong>
          <span>Username: <code>ravi</code>, <code>karan</code>, <code>sneha</code></span><br>
          <span>Password: <code>patient123</code></span>
          <p>Request doctor-prescribed refills or self-service OTC pain relievers.</p>
        </div>
      </div>
    </div>
  </main>


  <!-- ============================================================== -->
  <!-- FOOTER -->
  <!-- ============================================================== -->
  <footer>
    <p>
      <strong>Medical Prescription Refill Tracker</strong> &middot; Master of Computer Applications (MCA), Semester III
    </p>
    <p style="margin-top: 6px;">
      Course: <strong>24MCAC302 - Advance Java Programming</strong> &middot; MIT-ADT University, Pune
    </p>
    <p style="margin-top: 12px; font-size:13px;">
      <a href="https://github.com/PrachiKumari04/Medical-Prescription-Refill-Tracker" target="_blank">View on GitHub</a> &bull;
      <a href="${pageContext.request.contextPath}/login">Sign In</a> &bull;
      <a href="${pageContext.request.contextPath}/register">Register</a>
    </p>
  </footer>


  <!-- ============================================================== -->
  <!-- INTERACTIVE CLIENT-SIDE JAVASCRIPT -->
  <!-- ============================================================== -->
  <script>
    function updateQty(val) {
      document.getElementById('qtyDisplay').innerText = val;
      runSimulation();
    }

    function selectDemoDrug(drugName, qty) {
      const select = document.getElementById('drugSelect');
      for (let i = 0; i < select.options.length; i++) {
        if (select.options[i].text.includes(drugName.split(' ')[0])) {
          select.selectedIndex = i;
          break;
        }
      }
      document.getElementById('qtyRange').value = qty;
      document.getElementById('qtyDisplay').innerText = qty;
      runSimulation();

      // Smooth scroll to simulator
      document.getElementById('simulator').scrollIntoView({ behavior: 'smooth' });
    }

    function runSimulation() {
      const select = document.getElementById('drugSelect');
      const opt = select.options[select.selectedIndex];
      const type = opt.getAttribute('data-type');
      const drugName = opt.getAttribute('data-name');
      const qty = parseInt(document.getElementById('qtyRange').value, 10);

      const box = document.getElementById('simResult');
      const badge = document.getElementById('resBadge');
      const headline = document.getElementById('resHeadline');
      const body = document.getElementById('resBody');
      const mech = document.getElementById('resMechanism');
      const time = document.getElementById('resTime');
      const action = document.getElementById('resAction');
      const dbState = document.getElementById('resDbState');

      box.className = 'sim-display';

      if (type === 'OTC') {
        if (qty <= 10) {
          box.classList.add('status-approved');
          badge.className = 'disp-tag chip-green';
          badge.innerHTML = 'APPROVED &bull; SAFE OTC DEMAND';
          headline.innerText = 'Self-Service Dispense Approved (' + qty + ' units)';
          body.innerText = 'Request for ' + drugName + ' complies with clinical safety ceilings (Quantity ' + qty + ' <= 10). Directly routed to pharmacist workbench for fulfillment.';
          mech.innerText = 'OTC Limit Validation';
          time.innerText = '< 5 minutes at counter';
          action.innerText = 'None required (Safe common medicine)';
          dbState.innerText = 'INSERT refill_request (otc_medicine, quantity=' + qty + ')';
        } else {
          box.classList.add('status-warning');
          badge.className = 'disp-tag chip-amber';
          badge.innerHTML = 'SAFETY CEILING EXCEEDED (>10 UNITS)';
          headline.innerText = 'Consultation Required for High Quantity (' + qty + ' units)';
          body.innerText = 'Safety Protocol Warning: Demanding ' + qty + ' units of ' + drugName + ' exceeds the allowable 10-unit OTC threshold. Dr. Patil\'s clinical prescription is required to rule out dependency or contraindications.';
          mech.innerText = 'Safety Guard Limit > 10';
          time.innerText = 'Requires Clinical Consultation';
          action.innerText = 'Dr. Patil Prescription Mandated';
          dbState.innerText = 'BLOCKED: IllegalStateException thrown';
        }
      } else {
        // Rx
        box.classList.add('status-rx');
        badge.className = 'disp-tag chip-blue';
        badge.innerHTML = 'PHYSICIAN PRESCRIPTION (Rx ONLY)';
        headline.innerText = 'Verified Against Dr. Patil\'s Prescription';
        body.innerText = drugName + ' is a scheduled prescription medicine. The system validates active prescription authorization, checks remaining refill count, and locks inventory atomically.';
        mech.innerText = 'SELECT ... FOR UPDATE (Row Lock)';
        time.innerText = 'Same-day dispensary pickup';
        action.innerText = 'Physician authorized in advance';
        dbState.innerText = 'UPDATE prescription SET refills_left = refills_left - 1';
      }
    }

    function switchTab(role, btn) {
      document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
      document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));

      btn.classList.add('active');
      document.getElementById('tab-' + role).classList.add('active');
    }

    // Initialize on load
    document.addEventListener('DOMContentLoaded', () => {
      runSimulation();
    });
  </script>
</body>
</html>
