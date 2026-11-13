<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sign In &bull; RefillRx</title>
  
  <!-- Premium Modern Typography: Plus Jakarta Sans -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

  <style>
    :root {
      --primary: #2563eb;
      --primary-dark: #1d4ed8;
      --primary-soft: #eff6ff;
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
      padding: 24px 16px;
    }

    .card {
      background: #ffffff;
      width: 100%;
      max-width: 440px;
      padding: 36px 32px;
      border-radius: var(--radius);
      box-shadow: var(--shadow-md);
      border: 1px solid var(--border);
      position: relative;
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
      margin-top: 16px;
      font-size: 13px;
      font-weight: 700;
      color: #334155;
    }
    input[type="text"], input[type="password"] {
      width: 100%;
      box-sizing: border-box;
      padding: 12px 14px;
      margin-top: 6px;
      border: 1.5px solid var(--border);
      border-radius: var(--radius-sm);
      font-size: 14px;
      font-family: inherit;
      outline: none;
      transition: all 0.2s ease;
      background: #fafcff;
    }
    input:focus {
      border-color: var(--primary);
      background: white;
      box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
    }

    button.btn-login {
      width: 100%;
      margin-top: 24px;
      background: linear-gradient(135deg, var(--primary), var(--primary-dark));
      color: white;
      border: none;
      padding: 12px;
      border-radius: var(--radius-sm);
      font-size: 15px;
      cursor: pointer;
      font-weight: 700;
      font-family: inherit;
      transition: all 0.25s ease;
      box-shadow: 0 4px 14px rgba(37, 99, 235, 0.25);
    }
    button.btn-login:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(37, 99, 235, 0.35);
    }

    .flash {
      background: #dcfce7;
      border: 1px solid #86efac;
      color: #166534;
      padding: 12px;
      border-radius: var(--radius-sm);
      margin-bottom: 18px;
      font-size: 13px;
      text-align: center;
      font-weight: 600;
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

    .register-box {
      margin-top: 22px;
      text-align: center;
      font-size: 13px;
      color: var(--slate);
    }
    .register-box a {
      color: var(--primary);
      font-weight: 700;
      text-decoration: none;
    }
    .register-box a:hover { text-decoration: underline; }

    .creds {
      margin-top: 24px;
      font-size: 12px;
      color: var(--slate);
      background: #f8fafc;
      padding: 16px;
      border-radius: var(--radius-sm);
      border: 1px solid var(--border);
    }
    .creds strong {
      display: block;
      margin-bottom: 8px;
      color: var(--dark);
      font-size: 12px;
    }
    .quick-btns {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
    }
    .quick-btn {
      cursor: pointer;
      background: white;
      border: 1px solid var(--border);
      padding: 6px 10px;
      border-radius: 8px;
      font-weight: 600;
      font-size: 12px;
      font-family: inherit;
      color: var(--dark);
      transition: all 0.2s ease;
    }
    .quick-btn:hover {
      border-color: var(--primary);
      color: var(--primary);
      transform: translateY(-1px);
    }
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
      <h1>Sign in to RefillRx</h1>
      <div class="subtitle">Access your clinical portal</div>
    </div>

    <c:if test="${not empty sessionScope.flash}">
      <div class="flash">
        <c:out value="${sessionScope.flash}"/>
        <c:remove var="flash" scope="session"/>
      </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login">
      <label for="usernameInput">Username</label>
      <input type="text" id="usernameInput" name="username" value="<c:out value='${not empty param.username ? param.username : \"drpatil\"}'/>" placeholder="e.g. drpatil, pharma1, ravi" required autofocus>

      <label for="passwordInput">Password</label>
      <input type="password" id="passwordInput" name="password" value="<c:out value='${not empty param.password ? param.password : (not empty param.error || not empty error ? \"wrongpassword\" : \"\")}'/>" placeholder="Enter password" required>

      <button class="btn-login" type="submit">Log in</button>
    </form>

    <c:set var="loginErr" value="${not empty error ? error : param.error}"/>
    <c:if test="${not empty loginErr}">
      <p class="error"><c:out value="${loginErr}"/></p>
    </c:if>

    <div class="register-box">
      New patient? <a href="${pageContext.request.contextPath}/register">Create Account &rarr;</a>
    </div>

    <div class="creds">
      <strong>⚡ 1-Click Demo Fill:</strong>
      <div class="quick-btns">
        <button type="button" class="quick-btn" onclick="fillCreds('drpatil','doc123')">👨‍⚕️ Doctor</button>
        <button type="button" class="quick-btn" onclick="fillCreds('pharma1','pharma123')">💊 Pharmacist</button>
        <button type="button" class="quick-btn" onclick="fillCreds('ravi','patient123')">🧑 Patient</button>
      </div>
    </div>
  </div>

  <script>
    function fillCreds(u, p) {
      document.getElementById('usernameInput').value = u;
      document.getElementById('passwordInput').value = p;
    }
    (function() {
      const u = document.getElementById('usernameInput').value;
      if (u === 'drpatil') {
        document.getElementById('passwordInput').value = 'doc123';
      } else if (u === 'pharma1') {
        document.getElementById('passwordInput').value = 'pharma123';
      } else if (u === 'ravi' || u === 'sneha' || u === 'amit' || u === 'priya' || u === 'karan') {
        document.getElementById('passwordInput').value = 'patient123';
      }
    })();
  </script>
</body>
</html>
