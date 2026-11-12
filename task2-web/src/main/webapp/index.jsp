<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>RefillRx &bull; Medical Prescription & Refill Portal</title>
  
  <!-- Premium Modern Typography: Plus Jakarta Sans -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

  <style>
    :root {
      --primary: #2563eb;
      --primary-dark: #1d4ed8;
      --primary-soft: #eff6ff;
      --teal: #0d9488;
      --teal-soft: #f0fdfa;
      --emerald: #10b981;
      --dark: #0f172a;
      --dark-card: #1e293b;
      --slate: #64748b;
      --slate-light: #f1f5f9;
      --border: #e2e8f0;
      --border-focus: #93c5fd;
      --bg: #f8fafc;
      --radius: 16px;
      --radius-sm: 10px;
      --shadow-sm: 0 2px 4px rgba(15, 23, 42, 0.04);
      --shadow-md: 0 10px 25px -3px rgba(15, 23, 42, 0.06), 0 4px 6px -4px rgba(15, 23, 42, 0.04);
      --shadow-lg: 0 20px 35px -5px rgba(37, 99, 235, 0.12), 0 8px 12px -4px rgba(15, 23, 42, 0.05);
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }
    
    body {
      font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: radial-gradient(at 0% 0%, rgba(37, 99, 235, 0.05) 0px, transparent 50%),
                  radial-gradient(at 100% 0%, rgba(13, 148, 136, 0.05) 0px, transparent 50%),
                  var(--bg);
      color: var(--dark);
      line-height: 1.6;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      overflow-x: hidden;
    }

    a { text-decoration: none; color: inherit; }

    /* --- UNIFIED NAVBAR --- */
    .nav {
      position: sticky;
      top: 0;
      z-index: 100;
      background: rgba(255, 255, 255, 0.88);
      backdrop-filter: blur(14px);
      border-bottom: 1px solid var(--border);
      padding: 14px 28px;
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
      letter-spacing: -0.6px;
      color: var(--dark);
    }
    .brand-icon {
      width: 38px;
      height: 38px;
      background: linear-gradient(135deg, var(--primary), var(--teal));
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
      position: relative;
    }
    .brand-icon::after {
      content: "";
      position: absolute;
      top: 3px;
      right: 3px;
      width: 8px;
      height: 8px;
      background: #34d399;
      border-radius: 50%;
      border: 2px solid white;
      animation: pulseDot 2s infinite;
    }
    @keyframes pulseDot {
      0%, 100% { transform: scale(1); opacity: 1; }
      50% { transform: scale(1.3); opacity: 0.6; }
    }
    .nav-actions {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    /* --- UNIFIED BUTTONS --- */
    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      padding: 10px 22px;
      border-radius: var(--radius-sm);
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
      border: none;
      font-family: inherit;
    }
    .btn-ghost {
      background: white;
      color: var(--dark);
      border: 1px solid var(--border);
    }
    .btn-ghost:hover {
      background: var(--slate-light);
      border-color: #cbd5e1;
      transform: translateY(-1px);
    }
    .btn-primary {
      background: linear-gradient(135deg, var(--primary), var(--primary-dark));
      color: white;
      box-shadow: 0 4px 14px rgba(37, 99, 235, 0.25);
    }
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(37, 99, 235, 0.35);
    }
    .btn-teal {
      background: linear-gradient(135deg, var(--teal), #0f766e);
      color: white;
      box-shadow: 0 4px 14px rgba(13, 148, 136, 0.25);
    }
    .btn-teal:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(13, 148, 136, 0.35);
    }
    .btn-card {
      width: 100%;
      padding: 11px;
      border-radius: 10px;
      font-size: 14px;
      font-weight: 700;
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
      max-width: 1180px;
      margin: 0 auto;
      padding: 72px 24px 48px;
      display: grid;
      grid-template-columns: 1.15fr 0.85fr;
      gap: 48px;
      align-items: center;
    }
    .badge-pill {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: var(--primary-soft);
      color: var(--primary-dark);
      border: 1px solid #bfdbfe;
      padding: 6px 16px;
      border-radius: 30px;
      font-size: 13px;
      font-weight: 700;
      margin-bottom: 22px;
      letter-spacing: -0.2px;
    }
    .hero h1 {
      font-size: 52px;
      line-height: 1.15;
      font-weight: 800;
      color: var(--dark);
      letter-spacing: -1.6px;
      margin-bottom: 20px;
    }
    .hero h1 .gradient-text {
      background: linear-gradient(135deg, var(--primary) 20%, var(--teal) 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    .hero p {
      font-size: 18px;
      color: var(--slate);
      line-height: 1.6;
      margin-bottom: 32px;
      max-width: 520px;
      font-weight: 450;
    }
    .hero-actions {
      display: flex;
      gap: 14px;
      flex-wrap: wrap;
      margin-bottom: 36px;
    }

    /* --- HERO VISUAL CARD (MODERN CLINICAL STAGE) --- */
    .hero-stage {
      position: relative;
      background: white;
      border: 1px solid var(--border);
      border-radius: 24px;
      padding: 28px;
      box-shadow: var(--shadow-lg);
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    /* Floating Capsule Rows */
    .capsule-card {
      background: #ffffff;
      border: 1px solid #f1f5f9;
      border-radius: var(--radius);
      padding: 16px 20px;
      box-shadow: var(--shadow-sm);
      display: flex;
      align-items: center;
      gap: 14px;
      transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
      cursor: pointer;
    }
    .capsule-card:hover {
      transform: translateY(-4px) scale(1.02);
      box-shadow: var(--shadow-md);
      border-color: var(--border-focus);
    }
    .anim-float-1 { animation: floatSlow 5.5s ease-in-out infinite; }
    .anim-float-2 { animation: floatSlow 6s ease-in-out infinite 0.9s; }
    .anim-float-3 { animation: floatSlow 5s ease-in-out infinite 1.8s; }

    @keyframes floatSlow {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-7px); }
    }

    /* 3D Pill Capsule Graphic */
    .pill-graphic {
      width: 44px;
      height: 22px;
      border-radius: 22px;
      position: relative;
      overflow: hidden;
      box-shadow: inset 0 2px 4px rgba(255,255,255,0.7), 0 3px 6px rgba(0,0,0,0.12);
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
    .pill-green {
      background: linear-gradient(90deg, #10b981 50%, #ffffff 50%);
      border: 1px solid #10b981;
    }

    .capsule-info strong {
      display: block;
      font-size: 15px;
      color: var(--dark);
      font-weight: 700;
    }
    .capsule-info span {
      font-size: 13px;
      color: var(--slate);
    }
    .tag-pill {
      margin-left: auto;
      font-size: 12px;
      font-weight: 700;
      padding: 4px 12px;
      border-radius: 20px;
      letter-spacing: -0.2px;
    }
    .tag-green { background: #dcfce7; color: #15803d; }
    .tag-blue { background: #e0f2fe; color: #0369a1; }

    /* Animated Heartbeat Strip */
    .telemetry-strip {
      background: var(--dark);
      border-radius: 14px;
      padding: 14px 20px;
      display: flex;
      align-items: center;
      gap: 16px;
      color: white;
    }
    .ecg-svg {
      width: 120px;
      height: 26px;
    }
    .ecg-path {
      stroke: #34d399;
      stroke-width: 2.2;
      fill: none;
      stroke-dasharray: 180;
      stroke-dashoffset: 180;
      animation: ecgPulse 2.2s linear infinite;
    }
    @keyframes ecgPulse {
      0% { stroke-dashoffset: 180; }
      100% { stroke-dashoffset: 0; }
    }
    .telemetry-strip span {
      font-size: 12px;
      color: #94a3b8;
    }
    .telemetry-strip strong {
      color: #34d399;
      font-weight: 700;
    }

    /* --- SECTION: UNIFIED 3 ROLE TILES --- */
    .section {
      max-width: 1180px;
      margin: 0 auto;
      padding: 50px 24px;
      width: 100%;
    }
    .section-header {
      text-align: center;
      max-width: 600px;
      margin: 0 auto 40px;
    }
    .section-header h2 {
      font-size: 32px;
      font-weight: 800;
      letter-spacing: -0.9px;
      color: var(--dark);
      margin-bottom: 10px;
    }
    .section-header p {
      font-size: 16px;
      color: var(--slate);
    }
    .roles-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 24px;
    }
    .role-tile {
      background: white;
      border: 1px solid var(--border);
      border-radius: var(--radius);
      padding: 32px 28px;
      box-shadow: var(--shadow-sm);
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
      position: relative;
    }
    .role-tile:hover {
      transform: translateY(-6px);
      box-shadow: var(--shadow-md);
      border-color: var(--border-focus);
    }
    .role-emoji {
      font-size: 38px;
      margin-bottom: 16px;
      display: inline-block;
    }
    .role-tile h3 {
      font-size: 20px;
      font-weight: 800;
      color: var(--dark);
      margin-bottom: 8px;
      letter-spacing: -0.4px;
    }
    .role-tile p {
      font-size: 14px;
      color: var(--slate);
      line-height: 1.55;
      margin-bottom: 20px;
    }
    .feature-list {
      list-style: none;
      margin-bottom: 28px;
      font-size: 13px;
      color: #334155;
    }
    .feature-list li {
      margin-bottom: 10px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .feature-list li::before {
      content: "✓";
      color: var(--emerald);
      font-weight: 800;
      font-size: 14px;
    }

    /* --- QUICK DEMO STRIP --- */
    .demo-strip {
      background: var(--dark);
      color: white;
      border-radius: var(--radius);
      padding: 28px 32px;
      margin: 20px auto 48px;
      max-width: 1180px;
      width: calc(100% - 48px);
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 20px;
      flex-wrap: wrap;
    }
    .demo-strip h3 {
      font-size: 18px;
      font-weight: 700;
      margin-bottom: 4px;
    }
    .demo-strip p {
      font-size: 13px;
      color: #94a3b8;
    }
    .demo-chips {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
    }
    .demo-chip {
      background: rgba(255, 255, 255, 0.08);
      border: 1px solid rgba(255, 255, 255, 0.15);
      border-radius: 10px;
      padding: 8px 16px;
      font-size: 13px;
      transition: all 0.2s ease;
      display: block;
      cursor: pointer;
    }
    .demo-chip:hover {
      background: rgba(255, 255, 255, 0.15);
      border-color: #38bdf8;
      transform: translateY(-2px);
    }
    .demo-chip strong {
      color: #38bdf8;
      display: block;
      margin-bottom: 2px;
    }
    .demo-chip code {
      color: #f8fafc;
      font-family: inherit;
      font-weight: 600;
      font-size: 12px;
    }

    /* --- UNIFIED FOOTER --- */
    footer {
      border-top: 1px solid var(--border);
      background: white;
      padding: 28px 24px;
      text-align: center;
      font-size: 13px;
      color: var(--slate);
      margin-top: auto;
    }
    footer a { color: var(--primary); font-weight: 600; }
    footer a:hover { text-decoration: underline; }

    /* --- RESPONSIVE GADGET BREAKPOINTS --- */
    /* Tablet & Medium Gadgets */
    @media (max-width: 980px) {
      .hero {
        grid-template-columns: 1fr;
        padding-top: 48px;
        gap: 36px;
      }
      .hero h1 { font-size: 42px; }
      .roles-grid {
        grid-template-columns: 1fr;
        gap: 20px;
      }
      .nav { padding: 14px 20px; }
      .demo-strip {
        flex-direction: column;
        align-items: flex-start;
      }
    }

    /* Mobile Phones & Small Gadgets */
    @media (max-width: 600px) {
      .hero {
        padding: 36px 16px 32px;
      }
      .hero h1 {
        font-size: 32px;
        letter-spacing: -1px;
      }
      .hero p { font-size: 16px; }
      .hero-actions {
        flex-direction: column;
      }
      .hero-actions .btn {
        width: 100%;
      }
      .capsule-card {
        padding: 12px 14px;
      }
      .demo-chips {
        width: 100%;
        flex-direction: column;
      }
      .demo-chip {
        width: 100%;
      }
      .demo-strip {
        width: calc(100% - 32px);
        margin: 20px auto 32px;
        padding: 20px;
      }
      .nav {
        padding: 12px 16px;
      }
      .brand { font-size: 19px; }
    }
  </style>
</head>
<body>

  <!-- NAVBAR -->
  <header class="nav">
    <a href="${pageContext.request.contextPath}/" class="brand">
      <div class="brand-icon">
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
          <div class="user-pill">
            <span>●</span> Signed in as <strong><c:out value="${sessionScope.username}"/></strong>
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


  <!-- HERO -->
  <main>
    <section class="hero">
      <div>
        <div class="badge-pill">
          ✨ Trusted Prescription & Refill Network
        </div>
        <h1>
          Prescriptions managed with care, <span class="gradient-text">delivered on time.</span>
        </h1>
        <p>
          A unified, seamless portal for patients to order refills, doctors to prescribe chronic medicines, and pharmacists to dispense with verified safety.
        </p>

        <div class="hero-actions">
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

      <!-- VISUAL MEDICAL CARD -->
      <div class="hero-stage">
        <!-- Floating Pill 1 -->
        <a href="${pageContext.request.contextPath}/login?username=ravi" class="capsule-card anim-float-1">
          <div class="pill-graphic pill-teal"></div>
          <div class="capsule-info">
            <strong>Paracetamol 500 mg</strong>
            <span>Over-The-Counter &bull; Pain Relief</span>
          </div>
          <span class="tag-pill tag-green">Instant Approve</span>
        </a>

        <!-- Floating Pill 2 -->
        <a href="${pageContext.request.contextPath}/login?username=drpatil" class="capsule-card anim-float-2">
          <div class="pill-graphic pill-blue"></div>
          <div class="capsule-info">
            <strong>Telmisartan 40 mg</strong>
            <span>Dr. Patil Authorized &bull; 6 Refills Left</span>
          </div>
          <span class="tag-pill tag-blue">Physician Verified</span>
        </a>

        <!-- Floating Pill 3 -->
        <a href="${pageContext.request.contextPath}/login?username=pharma1" class="capsule-card anim-float-3">
          <div class="pill-graphic pill-green"></div>
          <div class="capsule-info">
            <strong>Atorvastatin 10 mg</strong>
            <span>Dispensary Counter &bull; Ready</span>
          </div>
          <span class="tag-pill tag-green">Ready</span>
        </a>

        <!-- Animated Telemetry Wave -->
        <div class="telemetry-strip">
          <svg class="ecg-svg" viewBox="0 0 120 26">
            <path class="ecg-path" d="M0,13 L24,13 L32,4 L38,22 L44,8 L48,16 L52,13 L120,13"/>
          </svg>
          <div>
            <strong>Live Safety Engine</strong>
            <span style="display:block;">Real-time checks & zero waiting</span>
          </div>
        </div>
      </div>
    </section>


    <!-- 3 UNIFIED ROLE CARDS -->
    <section class="section">
      <div class="section-header">
        <h2>Choose Your Portal</h2>
        <p>Select your clinical role to access your dedicated workspace.</p>
      </div>

      <div class="roles-grid">
        <!-- Patient Tile -->
        <div class="role-tile">
          <div>
            <span class="role-emoji">🧑</span>
            <h3>Patient Portal</h3>
            <p>Order refills from home and get common relief medicine fast.</p>
            <ul class="feature-list">
              <li>Track remaining refills in real-time</li>
              <li>Order OTC pain relievers (up to 10 units)</li>
              <li>View clear notes if an order is held</li>
            </ul>
          </div>
          <a href="${pageContext.request.contextPath}/login?username=ravi" class="btn btn-primary btn-card">
            Enter as Patient &rarr;
          </a>
        </div>

        <!-- Doctor Tile -->
        <div class="role-tile">
          <div>
            <span class="role-emoji">👨‍⚕️</span>
            <h3>Doctor Desk</h3>
            <p>Prescribe medications and follow patient adherence effortlessly.</p>
            <ul class="feature-list">
              <li>Prescribe new drugs to patients in seconds</li>
              <li>Monitor patient refill stats & history</li>
              <li>Inspect pharmacy dispensing audit logs</li>
            </ul>
          </div>
          <a href="${pageContext.request.contextPath}/login?username=drpatil" class="btn btn-primary btn-card">
            Enter as Doctor &rarr;
          </a>
        </div>

        <!-- Pharmacist Tile -->
        <div class="role-tile">
          <div>
            <span class="role-emoji">💊</span>
            <h3>Pharmacist Queue</h3>
            <p>Verify safety, approve refills, and dispense accurately.</p>
            <ul class="feature-list">
              <li>Live dispensary review queue</li>
              <li>One-click approvals with atomic stock checks</li>
              <li>Log clinical reasons when rejecting orders</li>
            </ul>
          </div>
          <a href="${pageContext.request.contextPath}/login?username=pharma1" class="btn btn-teal btn-card">
            Enter as Pharmacist &rarr;
          </a>
        </div>
      </div>
    </section>


    <!-- QUICK READY DEMO STRIP -->
    <div class="demo-strip">
      <div>
        <h3>⚡ 1-Click Ready Demo Logins</h3>
        <p>Click any account below to pre-fill credentials and enter:</p>
      </div>
      <div class="demo-chips">
        <a href="${pageContext.request.contextPath}/login?username=drpatil" class="demo-chip">
          <strong>👨‍⚕️ Doctor</strong>
          <code>drpatil / doc123</code>
        </a>
        <a href="${pageContext.request.contextPath}/login?username=pharma1" class="demo-chip">
          <strong>💊 Pharmacist</strong>
          <code>pharma1 / pharma123</code>
        </a>
        <a href="${pageContext.request.contextPath}/login?username=ravi" class="demo-chip">
          <strong>🧑 Patient</strong>
          <code>ravi / patient123</code>
        </a>
      </div>
    </div>
  </main>


  <!-- FOOTER -->
  <footer>
    <p>
      <strong>RefillRx</strong> &bull; Medical Prescription & Refill Tracker &bull; 
      <a href="${pageContext.request.contextPath}/login">Sign In</a> &bull; 
      <a href="${pageContext.request.contextPath}/register">Register</a> &bull; 
      <a href="https://github.com/PrachiKumari04/Medical-Prescription-Refill-Tracker" target="_blank">GitHub</a>
    </p>
  </footer>

</body>
</html>
