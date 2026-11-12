<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Account &bull; RefillRx</title>
  
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
      --dark: #0f172a;
      --slate: #64748b;
      --border: #e2e8f0;
      --bg: #f8fafc;
      --radius: 16px;
      --radius-sm: 10px;
      --shadow-md: 0 10px 25px -3px rgba(15, 23, 42, 0.06), 0 4px 6px -4px rgba(15, 23, 42, 0.04);
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: radial-gradient(at 0% 0%, rgba(37, 99, 235, 0.05) 0px, transparent 50%),
                  radial-gradient(at 100% 0%, rgba(13, 148, 136, 0.05) 0px, transparent 50%),
                  var(--bg);
      color: var(--dark);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      padding: 32px 16px;
    }

    .card {
      background: #ffffff;
      width: 100%;
      max-width: 480px;
      padding: 36px 32px;
      border-radius: var(--radius);
      box-shadow: var(--shadow-md);
      border: 1px solid var(--border);
    }

    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      margin-bottom: 20px;
      font-size: 13px;
      color: var(--slate);
      font-weight: 600;
      text-decoration: none;
      transition: color 0.2s;
    }
    .back-link:hover { color: var(--primary); }

    .brand-header {
      text-align: center;
      margin-bottom: 24px;
    }
    .brand-icon {
      width: 44px;
      height: 44px;
      background: linear-gradient(135deg, #2563eb, #0d9488);
      border-radius: 12px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      color: white;
      box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
      margin-bottom: 12px;
    }
    h1 {
      font-size: 24px;
      font-weight: 800;
      letter-spacing: -0.6px;
      color: var(--dark);
    }
    .subtitle {
      font-size: 14px;
      color: var(--slate);
      margin-top: 4px;
    }

    label {
      display: block;
      margin-top: 14px;
      font-size: 13px;
      font-weight: 700;
      color: #334155;
    }
    input[type="text"], input[type="password"], select {
      width: 100%;
      box-sizing: border-box;
      padding: 11px 14px;
      margin-top: 6px;
      border: 1.5px solid var(--border);
      border-radius: var(--radius-sm);
      font-size: 14px;
      font-family: inherit;
      outline: none;
      transition: all 0.2s ease;
      background: #fafcff;
    }
    input:focus, select:focus {
      border-color: var(--primary);
      background: white;
      box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
    }

    .role-box {
      background: #f8fafc;
      padding: 12px;
      border-radius: var(--radius-sm);
      border: 1px solid var(--border);
      margin-top: 6px;
    }

    button.btn-submit {
      width: 100%;
      margin-top: 24px;
      background: linear-gradient(135deg, var(--teal), #0f766e);
      color: white;
      border: none;
      padding: 12px;
      border-radius: var(--radius-sm);
      font-size: 15px;
      cursor: pointer;
      font-weight: 700;
      font-family: inherit;
      transition: all 0.25s ease;
      box-shadow: 0 4px 14px rgba(13, 148, 136, 0.25);
    }
    button.btn-submit:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(13, 148, 136, 0.35);
    }

    .error {
      color: #dc2626;
      background: #fee2e2;
      border: 1px solid #f87171;
      padding: 10px 14px;
      border-radius: var(--radius-sm);
      margin-top: 16px;
      font-size: 13px;
      text-align: center;
      font-weight: 600;
    }

    .footer-link {
      margin-top: 22px;
      text-align: center;
      font-size: 13px;
      color: var(--slate);
    }
    .footer-link a {
      color: var(--primary);
      font-weight: 700;
      text-decoration: none;
    }
    .footer-link a:hover { text-decoration: underline; }
  </style>
</head>
<body>

  <div class="card">
    <a href="${pageContext.request.contextPath}/" class="back-link">
      &larr; Back to RefillRx Home
    </a>

    <div class="brand-header">
      <div class="brand-icon">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"></path>
          <path d="m8.5 8.5 7 7"></path>
        </svg>
      </div>
      <h1>Create an Account</h1>
      <div class="subtitle">Join the RefillRx Care Network</div>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/register">
      <label for="role">Select Your Role</label>
      <div class="role-box">
        <select name="role" id="role">
          <option value="PATIENT" selected>🧑 Patient (Self-Service Refill Portal)</option>
          <option value="DOCTOR">👨‍⚕️ Doctor / Clinician (Prescribe & Analytics)</option>
          <option value="PHARMACIST">💊 Pharmacist (Review & Dispense)</option>
        </select>
      </div>

      <label for="name">Full Name</label>
      <input type="text" name="name" id="name" placeholder="e.g. Karan Sharma" required>

      <label for="phone">Phone Number</label>
      <input type="text" name="phone" id="phone" placeholder="e.g. 9822000005">

      <label for="username">Desired Username</label>
      <input type="text" name="username" id="username" placeholder="e.g. karan" required>

      <label for="password">Password</label>
      <input type="password" name="password" id="password" placeholder="At least 4 characters" required>

      <label for="confirmPassword">Confirm Password</label>
      <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Re-enter password" required>

      <button class="btn-submit" type="submit">Register Account</button>
    </form>

    <c:if test="${not empty error}">
      <p class="error"><c:out value="${error}"/></p>
    </c:if>

    <div class="footer-link">
      Already have an account? <a href="${pageContext.request.contextPath}/login">Log in here &rarr;</a>
    </div>
  </div>

</body>
</html>
