<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>RefillRx &bull; Medical Prescription & Refill Tracker</title>
  <style>
    :root {
      --primary: #2563eb;
      --primary-hover: #1d4ed8;
      --primary-light: #eff6ff;
      --teal: #0d9488;
      --teal-light: #f0fdfa;
      --emerald: #10b981;
      --navy: #0f172a;
      --slate: #64748b;
      --slate-light: #f8fafc;
      --border: #e2e8f0;
      --radius: 16px;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
      background: #fafcff;
      color: var(--navy);
      line-height: 1.5;
      overflow-x: hidden;
    }

    a { text-decoration: none; color: inherit; }

    /* --- NAVBAR --- */
    .nav {
      position: sticky;
      top: 0;
      z-index: 100;
      background: rgba(255, 255, 255, 0.85);
      backdrop-filter: blur(16px);
      border-bottom: 1px solid var(--border);
      padding: 16px 36px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .brand {
      display: flex;
      align-items: center;
      gap: 12px;
      font-weight: 800;
      font-size: 21px;
      color: var(--navy);
      letter-spacing: -0.5px;
    }
    .brand-pill {
      width: 36px;
      height: 36px;
      background: linear-gradient(135deg, #2563eb, #0d9488);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
      position: relative;
    }
    .brand-pill::after {
      content: "";
      position: absolute;
      top: 3px;
      right: 3px;
      width: 8px;
      height: 8px;
      background: #34d399;
      border-radius: 50%;
      border: 2px solid white;
      animation: pulse 2s infinite;
    }
    @keyframes pulse {
      0%, 100% { transform: scale(1); opacity: 1; }
      50% { transform: scale(1.3); opacity: 0.6; }
    }
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
      padding: 10px 22px;
      border-radius: 10px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      border: none;
    }
    .btn-ghost {
      background: transparent;
      color: var(--navy);
      border: 1px solid var(--border);
    }
    .btn-ghost:hover {
      background: #f1f5f9;
      border-color: #cbd5e1;
    }
    .btn-primary {
      background: linear-gradient(135deg, #2563eb, #1d4ed8);
      color: white;
      box-shadow: 0 4px 14px rgba(37, 99, 235, 0.25);
    }
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(37, 99, 235, 0.35);
    }
    .btn-teal {
      background: linear-gradient(135deg, #0d9488, #0f766e);
      color: white;
      box-shadow: 0 4px 14px rgba(13, 148, 136, 0.25);
    }
    .btn-teal:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(13, 148, 136, 0.35);
    }
    .user-tag {
      background: #f0fdf4;
      border: 1px solid #86efac;
      color: #166534;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
    }

    /* --- HERO --- */
    .hero {
      max-width: 1200px;
      margin: 0 auto;
      padding: 70px 24px 50px;
      display: grid;
      grid-template-columns: 1.1fr 0.9fr;
      gap: 48px;
      align-items: center;
    }
    .pill-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: #eff6ff;
      color: #1d4ed8;
      border: 1px solid #bfdbfe;
      padding: 6px 14px;
      border-radius: 30px;
      font-size: 13px;
      font-weight: 600;
      margin-bottom: 20px;
    }
    .hero h1 {
      font-size: 52px;
      line-height: 1.15;
      font-weight: 800;
      color: #0f172a;
      letter-spacing: -1.5px;
      margin-bottom: 20px;
    }
    .hero h1 span {
      background: linear-gradient(135deg, #2563eb, #0d9488);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    .hero p {
      font-size: 18px;
      color: #475569;
      line-height: 1.6;
      margin-bottom: 32px;
      max-width: 520px;
    }
    .hero-btns {
      display: flex;
      gap: 14px;
      flex-wrap: wrap;
      margin-bottom: 36px;
    }

    /* --- HERO ANIMATED CARD --- */
    .hero-card {
      position: relative;
      background: linear-gradient(145deg, #ffffff, #f0fdfa);
      border: 1px solid #e2e8f0;
      border-radius: 24px;
      padding: 32px;
      box-shadow: 0 20px 40px -10px rgba(15, 23, 42, 0.08), 0 1px 3px rgba(0,0,0,0.05);
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    /* Floating Pill Capsules */
    .capsule-row {
      background: white;
      border-radius: 16px;
      padding: 16px 20px;
      border: 1px solid #f1f5f9;
      box-shadow: 0 8px 16px -2px rgba(15, 23, 42, 0.04);
      display: flex;
      align-items: center;
      gap: 14px;
      transition: all 0.3s ease;
      cursor: pointer;
    }
    .capsule-row:hover {
      transform: translateY(-4px) scale(1.02);
      box-shadow: 0 12px 24px -4px rgba(15, 23, 42, 0.08);
      border-color: #cbd5e1;
    }
    .float-1 { animation: floatSlow 5s ease-in-out infinite; }
    .float-2 { animation: floatSlow 5.5s ease-in-out infinite 0.8s; }
    .float-3 { animation: floatSlow 4.8s ease-in-out infinite 1.6s; }

    @keyframes floatSlow {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-8px); }
    }

    /* 3D-styled mini pill */
    .mini-pill {
      width: 42px;
      height: 20px;
      border-radius: 20px;
      position: relative;
      overflow: hidden;
      box-shadow: 0 2px 6px rgba(0,0,0,0.15);
      flex-shrink: 0;
      transform: rotate(-30deg);
    }
    .pill-teal {
      background: linear-gradient(90deg, #0d9488 50%, #ffffff 50%);
      border: 1px solid #0d9488;
    }
    .pill-blue {
      background: linear-gradient(90deg, #2563eb 50%, #f59e0b 50%);
      border: 1px solid #2563eb;
    }
    .pill-green {
      background: linear-gradient(90deg, #10b981 50%, #ffffff 50%);
      border: 1px solid #10b981;
    }

    .capsule-text strong {
      display: block;
      font-size: 15px;
      color: #0f172a;
    }
    .capsule-text span {
      font-size: 13px;
      color: #64748b;
    }
    .tag {
      margin-left: auto;
      font-size: 12px;
      font-weight: 700;
      padding: 4px 10px;
      border-radius: 12px;
    }
    .tag-green { background: #dcfce7; color: #166534; }
    .tag-blue { background: #e0f2fe; color: #0369a1; }
    .tag-amber { background: #fef3c7; color: #b45309; }

    /* Animated Heartbeat Line Banner */
    .heartbeat-strip {
      background: #0f172a;
      color: white;
      border-radius: 14px;
      padding: 14px 18px;
      display: flex;
      align-items: center;
      gap: 16px;
    }
    .ecg-wave {
      width: 120px;
      height: 26px;
    }
    .ecg-line {
      stroke: #34d399;
      stroke-width: 2.2;
      fill: none;
      stroke-dasharray: 180;
      stroke-dashoffset: 180;
      animation: heartbeat 2.2s linear infinite;
    }
    @keyframes heartbeat {
      0% { stroke-dashoffset: 180; }
      100% { stroke-dashoffset: 0; }
    }
    .heartbeat-strip span {
      font-size: 12px;
      color: #94a3b8;
    }
    .heartbeat-strip strong {
      color: #34d399;
    }

    /* --- 3 SIMPLE STEPS --- */
    .section {
      max-width: 1200px;
      margin: 0 auto;
      padding: 60px 24px;
    }
    .section-title {
      text-align: center;
      font-size: 32px;
      font-weight: 800;
      color: #0f172a;
      letter-spacing: -0.8px;
      margin-bottom: 12px;
    }
    .section-subtitle {
      text-align: center;
      font-size: 16px;
      color: #64748b;
      margin-bottom: 48px;
    }
    .steps-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 24px;
    }
    .step-card {
      background: white;
      border: 1px solid var(--border);
      border-radius: 20px;
      padding: 32px 28px;
      box-shadow: 0 4px 12px rgba(15, 23, 42, 0.03);
      transition: all 0.25s ease;
      position: relative;
    }
    .step-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 16px 32px -4px rgba(15, 23, 42, 0.08);
      border-color: #cbd5e1;
    }
    .step-num {
      width: 44px;
      height: 44px;
      border-radius: 12px;
      background: #eff6ff;
      color: #2563eb;
      font-size: 18px;
      font-weight: 800;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 20px;
    }
    .step-card h3 {
      font-size: 19px;
      color: #0f172a;
      margin-bottom: 10px;
      font-weight: 700;
    }
    .step-card p {
      font-size: 15px;
      color: #64748b;
      line-height: 1.6;
    }

    /* --- 3 PORTAL TILES (PATIENT, DOCTOR, PHARMACIST) --- */
    .roles-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
      gap: 24px;
    }
    .role-card {
      background: white;
      border: 1px solid var(--border);
      border-radius: 20px;
      padding: 32px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      transition: all 0.25s ease;
    }
    .role-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 16px 32px -4px rgba(15, 23, 42, 0.08);
    }
    .role-icon {
      font-size: 36px;
      margin-bottom: 16px;
    }
    .role-card h3 {
      font-size: 20px;
      color: #0f172a;
      margin-bottom: 8px;
      font-weight: 700;
    }
    .role-card p {
      font-size: 14px;
      color: #64748b;
      line-height: 1.6;
      margin-bottom: 20px;
    }
    .role-features {
      list-style: none;
      margin-bottom: 24px;
      font-size: 13px;
      color: #334155;
    }
    .role-features li {
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .role-features li::before {
      content: "✓";
      color: #10b981;
      font-weight: bold;
    }

    /* --- READY DEMO ACCOUNTS STRIP --- */
    .creds-banner {
      background: #0f172a;
      color: white;
      border-radius: 20px;
      padding: 32px 36px;
      margin: 40px auto;
      max-width: 1200px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 24px;
    }
    .creds-banner h3 {
      font-size: 20px;
      margin-bottom: 6px;
    }
    .creds-banner p {
      font-size: 13px;
      color: #94a3b8;
    }
    .creds-pills {
      display: flex;
      gap: 14px;
      flex-wrap: wrap;
    }
    .cred-pill {
      background: rgba(255, 255, 255, 0.08);
      border: 1px solid rgba(255, 255, 255, 0.15);
      border-radius: 12px;
      padding: 10px 16px;
      font-size: 13px;
    }
    .cred-pill strong {
      color: #38bdf8;
      display: block;
      margin-bottom: 2px;
    }
    .cred-pill code {
      color: #f1f5f9;
      font-family: monospace;
    }

    /* --- FOOTER --- */
    footer {
      border-top: 1px solid var(--border);
      background: white;
      padding: 32px 24px;
      text-align: center;
      font-size: 13px;
      color: var(--slate);
    }
    footer a { color: var(--primary); font-weight: 600; }
    footer a:hover { text-decoration: underline; }

    @media (max-width: 860px) {
      .hero { grid-template-columns: 1fr; padding-top: 40px; }
      .hero h1 { font-size: 38px; }
      .nav { padding: 14px 20px; }
      .creds-banner { flex-direction: column; align-items: flex-start; }
    }
  </style>
</head>
<body>

  <!-- NAVBAR -->
  <header class="nav">
    <a href="${pageContext.request.contextPath}/" class="brand">
      <div class="brand-pill">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"></path>
          <path d="m8.5 8.5 7 7"></path>
        </svg>
      </div>
      <span>RefillRx</span>
    </a>

    <div class="nav-actions">
      <c:choose>
        <c:when test="${not empty sessionScope.username}">
          <div class="user-tag">
            ● Signed in as <strong><c:out value="${sessionScope.username}"/></strong>
          </div>
          <a href="${pageContext.request.contextPath}/refills" class="btn btn-primary">Go to Dashboard &rarr;</a>
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


  <!-- HERO SECTION -->
  <main>
    <section class="hero">
      <div>
        <div class="pill-badge">
          ✨ Medical Prescription Refill Tracker
        </div>
        <h1>
          Healthcare that <span>never misses</span> a dose.
        </h1>
        <p>
          Connect patients, doctors, and pharmacists in one simple workflow. Request chronic refills in seconds, order common pain relievers, and pick up on time.
        </p>

        <div class="hero-btns">
          <c:choose>
            <c:when test="${not empty sessionScope.username}">
              <a href="${pageContext.request.contextPath}/refills" class="btn btn-primary" style="padding: 13px 28px; font-size: 15px;">
                Enter Your Portal &rarr;
              </a>
            </c:when>
            <c:otherwise>
              <a href="${pageContext.request.contextPath}/login" class="btn btn-primary" style="padding: 13px 28px; font-size: 15px;">
                Sign In to Portal &rarr;
              </a>
              <a href="${pageContext.request.contextPath}/register" class="btn btn-teal" style="padding: 13px 28px; font-size: 15px;">
                Create Free Account
              </a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- ANIMATED INTERACTIVE MEDICAL CARD -->
      <div class="hero-card">
        <!-- Floating Pill 1 -->
        <div class="capsule-row float-1">
          <div class="mini-pill pill-teal"></div>
          <div class="capsule-text">
            <strong>Paracetamol 500 mg</strong>
            <span>Common OTC &bull; Pain & Fever</span>
          </div>
          <span class="tag tag-green">Instant Approve</span>
        </div>

        <!-- Floating Pill 2 -->
        <div class="capsule-row float-2">
          <div class="mini-pill pill-blue"></div>
          <div class="capsule-text">
            <strong>Telmisartan 40 mg</strong>
            <span>Dr. Patil Authorized &bull; 6 Refills Left</span>
          </div>
          <span class="tag tag-blue">Physician Verified</span>
        </div>

        <!-- Floating Pill 3 -->
        <div class="capsule-row float-3">
          <div class="mini-pill pill-green"></div>
          <div class="capsule-text">
            <strong>Atorvastatin 10 mg</strong>
            <span>Dispensed &bull; Ready for Pickup</span>
          </div>
          <span class="tag tag-green">Ready</span>
        </div>

        <!-- Heartbeat ECG Pulse -->
        <div class="heartbeat-strip">
          <svg class="ecg-wave" viewBox="0 0 120 26">
            <path class="ecg-line" d="M0,13 L24,13 L32,4 L38,22 L44,8 L48,16 L52,13 L120,13"/>
          </svg>
          <div>
            <strong style="display:block; font-size:13px;">Live Clinical Safeguards</strong>
            <span>Real-time verification & zero waiting</span>
          </div>
        </div>
      </div>
    </section>


    <!-- 3 SIMPLE STEPS -->
    <section class="section">
      <h2 class="section-title">How It Works</h2>
      <p class="section-subtitle">A seamless 3-step prescription loop for patients and providers.</p>

      <div class="steps-grid">
        <div class="step-card">
          <div class="step-num">1</div>
          <h3>Doctor Prescribes</h3>
          <p>Your physician prescribes chronic medications with dosage schedules and authorized refill counts directly in the system.</p>
        </div>

        <div class="step-card">
          <div class="step-num">2</div>
          <h3>One-Tap Request</h3>
          <p>Patients submit refill requests with one tap, or order common pain relievers (like Paracetamol) without booking an appointment.</p>
        </div>

        <div class="step-card">
          <div class="step-num">3</div>
          <h3>Pharmacist Dispenses</h3>
          <p>The pharmacy reviews, confirms availability, and marks orders ready for counter pickup with zero confusion.</p>
        </div>
      </div>
    </section>


    <!-- 3 CLINICAL ROLES -->
    <section class="section" style="padding-top: 10px;">
      <h2 class="section-title">Built for Everyone</h2>
      <p class="section-subtitle">Simple, purpose-built interfaces for each healthcare role.</p>

      <div class="roles-grid">
        <!-- Patient -->
        <div class="role-card">
          <div>
            <div class="role-icon">🧑</div>
            <h3>For Patients</h3>
            <p>Order refills from home and get common relief medicine fast.</p>
            <ul class="role-features">
              <li>Track remaining refills in real-time</li>
              <li>Order OTC pain relievers (up to 10 units)</li>
              <li>See exact rejection notes if an order is held</li>
            </ul>
          </div>
          <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost" style="width:100%;">Sign In as Patient &rarr;</a>
        </div>

        <!-- Doctor -->
        <div class="role-card">
          <div>
            <div class="role-icon">👨‍⚕️</div>
            <h3>For Doctors</h3>
            <p>Prescribe medications and follow patient adherence effortlessly.</p>
            <ul class="role-features">
              <li>Prescribe new drugs to any patient in seconds</li>
              <li>View patient refill statistics and logs</li>
              <li>Inspect pharmacy dispensing history</li>
            </ul>
          </div>
          <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost" style="width:100%;">Sign In as Doctor &rarr;</a>
        </div>

        <!-- Pharmacist -->
        <div class="role-card">
          <div>
            <div class="role-icon">💊</div>
            <h3>For Pharmacists</h3>
            <p>Verify safety, approve refills, and dispense accurately.</p>
            <ul class="role-features">
              <li>Live dispensary queue with safety checks</li>
              <li>One-click approval and collection logging</li>
              <li>Mandatory rejection reasons for patient safety</li>
            </ul>
          </div>
          <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost" style="width:100%;">Sign In as Pharmacist &rarr;</a>
        </div>
      </div>
    </section>


    <!-- QUICK READY DEMO ACCOUNTS -->
    <div class="creds-banner">
      <div>
        <h3>⚡ Ready-to-Test Demo Accounts</h3>
        <p>Select any role below to test the live portal immediately:</p>
      </div>
      <div class="creds-pills">
        <div class="cred-pill">
          <strong>👨‍⚕️ Doctor</strong>
          <code>drpatil</code> / <code>doc123</code>
        </div>
        <div class="cred-pill">
          <strong>💊 Pharmacist</strong>
          <code>pharma1</code> / <code>pharma123</code>
        </div>
        <div class="cred-pill">
          <strong>🧑 Patient</strong>
          <code>ravi</code> / <code>patient123</code>
        </div>
      </div>
    </div>
  </main>


  <!-- FOOTER -->
  <footer>
    <p>
      <strong>RefillRx</strong> &bull; Medical Prescription & Refill Tracker &bull; 
      <a href="${pageContext.request.contextPath}/login">Sign In</a> &bull; 
      <a href="${pageContext.request.contextPath}/register">Create Account</a> &bull; 
      <a href="https://github.com/PrachiKumari04/Medical-Prescription-Refill-Tracker" target="_blank">GitHub</a>
    </p>
  </footer>

</body>
</html>
