<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login - Refill Tracker</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 48px; background-color: #f8fafc; color: #1e293b; }
    .card { background: #ffffff; max-width: 400px; margin: 40px auto; padding: 32px; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -2px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; }
    h1 { font-size: 20px; margin-top: 0; color: #0f172a; text-align: center; }
    label { display: block; margin-top: 14px; font-size: 14px; font-weight: 500; }
    input[type="text"], input[type="password"] { width: 100%; box-sizing: border-box; padding: 8px 12px; margin-top: 6px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 14px; }
    button { width: 100%; margin-top: 20px; background-color: #2563eb; color: white; border: none; padding: 10px; border-radius: 4px; font-size: 15px; cursor: pointer; font-weight: 600; }
    button:hover { background-color: #1d4ed8; }
    .error { color: #dc2626; background: #fee2e2; border: 1px solid #f87171; padding: 8px 12px; border-radius: 4px; margin-top: 16px; font-size: 13px; text-align: center; }
    .creds { margin-top: 24px; font-size: 12px; color: #64748b; background: #f1f5f9; padding: 10px; border-radius: 4px; line-height: 1.5; }
  </style>
</head>
<body>
  <div class="card">
    <h1>Medical Prescription Refill Tracker</h1>
    <form method="post" action="${pageContext.request.contextPath}/login">
      <label>Username <input type="text" name="username" required></label>
      <label>Password <input type="password" name="password" required></label>
      <button type="submit">Log in</button>
    </form>
    <c:if test="${not empty error}">
      <p class="error"><c:out value="${error}"/></p>
    </c:if>
    <div class="creds">
      <strong>Demo Accounts:</strong><br/>
      Pharmacist: <code>pharma1</code> / <code>pharma123</code><br/>
      Patient: <code>ravi</code>, <code>sneha</code>, <code>amit</code>, <code>priya</code> / <code>patient123</code>
    </div>
  </div>
</body>
</html>

