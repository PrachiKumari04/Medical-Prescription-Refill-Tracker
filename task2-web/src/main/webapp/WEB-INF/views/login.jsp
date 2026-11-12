<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login - Refill Tracker</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 48px 16px; background-color: #f8fafc; color: #1e293b; }
    .card { background: #ffffff; max-width: 440px; margin: 20px auto; padding: 32px; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -2px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; }
    h1 { font-size: 20px; margin-top: 0; color: #0f172a; text-align: center; }
    label { display: block; margin-top: 14px; font-size: 14px; font-weight: 500; }
    input[type="text"], input[type="password"] { width: 100%; box-sizing: border-box; padding: 10px 12px; margin-top: 6px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 14px; }
    button.btn-login { width: 100%; margin-top: 20px; background-color: #2563eb; color: white; border: none; padding: 11px; border-radius: 4px; font-size: 15px; cursor: pointer; font-weight: 600; }
    button.btn-login:hover { background-color: #1d4ed8; }
    .flash { background: #dcfce7; border: 1px solid #86efac; color: #166534; padding: 12px; border-radius: 4px; margin-top: 16px; font-size: 13px; text-align: center; font-weight: 500; }
    .error { color: #dc2626; background: #fee2e2; border: 1px solid #f87171; padding: 10px 12px; border-radius: 4px; margin-top: 16px; font-size: 13px; text-align: center; }
    .register-box { margin-top: 20px; text-align: center; padding: 12px; background: #f0fdf4; border: 1px dashed #86efac; border-radius: 6px; font-size: 13px; color: #166534; }
    .register-box a { color: #15803d; font-weight: bold; text-decoration: none; }
    .register-box a:hover { text-decoration: underline; }
    .creds { margin-top: 20px; font-size: 12px; color: #475569; background: #f1f5f9; padding: 14px; border-radius: 6px; line-height: 1.6; border: 1px solid #e2e8f0; }
    .creds strong { color: #0f172a; }
    .role-tag { font-weight: bold; padding: 1px 5px; border-radius: 3px; font-size: 11px; }
    .doctor-tag { background: #e0f2fe; color: #0369a1; }
    .pharma-tag { background: #dcfce7; color: #15803d; }
    .patient-tag { background: #fef3c7; color: #b45309; }
  </style>
</head>
<body>
  <div class="card">
    <div style="margin-bottom: 14px; font-size: 13px;">
      <a href="${pageContext.request.contextPath}/" style="color: #64748b; text-decoration: none; font-weight: 500;">&larr; Back to RefillRx Home</a>
    </div>
    <h1>Medical Prescription Refill Tracker</h1>
    
    <c:if test="${not empty sessionScope.flash}">
      <div class="flash">
        <c:out value="${sessionScope.flash}"/>
        <c:remove var="flash" scope="session"/>
      </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login">
      <label>Username <input type="text" id="usernameInput" name="username" value="<c:out value='${param.username}'/>" placeholder="e.g. drpatil, pharma1, ravi" required></label>
      <label>Password <input type="password" id="passwordInput" name="password" placeholder="Enter password" required></label>
      <button class="btn-login" type="submit">Log in</button>
    </form>

    <c:if test="${not empty error}">
      <p class="error"><c:out value="${error}"/></p>
    </c:if>

    <div class="register-box">
      Don't have an account? <a href="${pageContext.request.contextPath}/register">Create an Account / Register &rarr;</a>
    </div>

    <div class="creds">
      <strong>⚡ Quick 1-Tap Login Fill (Click to populate):</strong><br/>
      <div style="display:flex; gap:8px; margin-top:8px; flex-wrap:wrap;">
        <button type="button" onclick="fillCreds('drpatil','doc123')" style="cursor:pointer; background:#e0f2fe; border:1px solid #bae6fd; color:#0369a1; padding:5px 10px; border-radius:6px; font-weight:600; font-size:12px;">👨‍⚕️ Doctor (drpatil)</button>
        <button type="button" onclick="fillCreds('pharma1','pharma123')" style="cursor:pointer; background:#dcfce7; border:1px solid #bbf7d0; color:#15803d; padding:5px 10px; border-radius:6px; font-weight:600; font-size:12px;">💊 Pharmacist (pharma1)</button>
        <button type="button" onclick="fillCreds('ravi','patient123')" style="cursor:pointer; background:#fef3c7; border:1px solid #fde68a; color:#b45309; padding:5px 10px; border-radius:6px; font-weight:600; font-size:12px;">🧑 Patient (ravi)</button>
      </div>
    </div>
  </div>

  <script>
    function fillCreds(u, p) {
      document.getElementById('usernameInput').value = u;
      document.getElementById('passwordInput').value = p;
    }
    // Auto-fill password if username was passed via query parameter
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
