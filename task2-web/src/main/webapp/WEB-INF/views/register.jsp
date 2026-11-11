<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Register - Medical Prescription Refill Tracker</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 36px 16px; background-color: #f8fafc; color: #1e293b; }
    .card { background: #ffffff; max-width: 460px; margin: 20px auto; padding: 32px; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -2px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; }
    h1 { font-size: 22px; margin-top: 0; color: #0f172a; text-align: center; }
    .subtitle { text-align: center; font-size: 13px; color: #64748b; margin-top: -6px; margin-bottom: 20px; }
    label { display: block; margin-top: 14px; font-size: 13px; font-weight: 600; color: #334155; }
    input[type="text"], input[type="password"], select { width: 100%; box-sizing: border-box; padding: 9px 12px; margin-top: 5px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 14px; }
    input:focus, select:focus { outline: none; border-color: #2563eb; ring: 2px solid #93c5fd; }
    .btn-submit { width: 100%; margin-top: 24px; background-color: #16a34a; color: white; border: none; padding: 11px; border-radius: 4px; font-size: 15px; cursor: pointer; font-weight: 600; }
    .btn-submit:hover { background-color: #15803d; }
    .error { color: #dc2626; background: #fee2e2; border: 1px solid #f87171; padding: 10px 14px; border-radius: 4px; margin-top: 16px; font-size: 13px; text-align: center; }
    .footer-link { margin-top: 22px; text-align: center; font-size: 13px; color: #64748b; }
    .footer-link a { color: #2563eb; text-decoration: none; font-weight: 600; }
    .footer-link a:hover { text-decoration: underline; }
    .role-select { background: #f8fafc; padding: 10px; border-radius: 6px; border: 1px solid #e2e8f0; margin-top: 6px; }
  </style>
</head>
<body>
  <div class="card">
    <h1>Create New Account</h1>
    <div class="subtitle">Medical Prescription Refill Tracker</div>

    <form method="post" action="${pageContext.request.contextPath}/register">
      <label for="role">Account Type:</label>
      <div class="role-select">
        <select name="role" id="role">
          <option value="PATIENT" selected>🧑 Patient (Self-Service Refill Portal)</option>
          <option value="DOCTOR">👨‍⚕️ Doctor / Clinician (Prescribe & Analytics)</option>
          <option value="PHARMACIST">💊 Pharmacist (Review, Approve & Dispense)</option>
        </select>
      </div>

      <label for="name">Full Name: <input type="text" name="name" id="name" placeholder="e.g. Karan Sharma" required></label>
      <label for="phone">Phone Number: <input type="text" name="phone" id="phone" placeholder="e.g. 9822000005"></label>
      <label for="username">Desired Username: <input type="text" name="username" id="username" placeholder="e.g. karan" required></label>
      <label for="password">Password: <input type="password" name="password" id="password" placeholder="At least 4 characters" required></label>
      <label for="confirmPassword">Confirm Password: <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Re-enter password" required></label>

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
