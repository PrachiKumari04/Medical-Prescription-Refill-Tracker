<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Patient Refills - Spring MVC & JPA</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 32px; background: #f8fafc; color: #1e293b; }
    h1 { color: #0f172a; margin-bottom: 4px; }
    .subtitle { color: #64748b; margin-bottom: 24px; font-size: 14px; }
    .card { background: #fff; padding: 24px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; margin-bottom: 24px; }
    table { border-collapse: collapse; width: 100%; margin-top: 12px; background: #fff; }
    th, td { border: 1px solid #cbd5e1; padding: 8px 12px; text-align: left; }
    th { background: #f1f5f9; color: #334155; }
    .flash { background: #dcfce7; border: 1px solid #86efac; color: #166534; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; }
    .error-box { background: #fee2e2; border: 1px solid #f87171; color: #991b1b; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; }
    .error-msg { color: #dc2626; font-size: 13px; margin-top: 4px; }
    .badge { padding: 3px 10px; border-radius: 12px; color: #fff; font-size: 12px; font-weight: bold; }
    .PENDING { background: #d97706; }
    .form-group { margin-bottom: 16px; }
    label { display: block; font-weight: 500; margin-bottom: 6px; font-size: 14px; }
    select, input[type="date"] { padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 14px; }
    button { background: #2563eb; color: #fff; border: none; padding: 9px 18px; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; }
    button:hover { background: #1d4ed8; }
    .nav-links a { color: #2563eb; text-decoration: none; margin-right: 12px; font-size: 14px; }
  </style>
</head>
<body>
  <h1>Medical Prescription Refill Tracker</h1>
  <div class="subtitle">Task 3: Spring MVC + JPA / Hibernate Module</div>

  <div class="nav-links" style="margin-bottom: 16px;">
    Switch Patient:
    <a href="${pageContext.request.contextPath}/patients/1/refills">Patient 1 (Ravi)</a> |
    <a href="${pageContext.request.contextPath}/patients/2/refills">Patient 2 (Sneha)</a> |
    <a href="${pageContext.request.contextPath}/patients/3/refills">Patient 3 (Amit)</a> |
    <a href="${pageContext.request.contextPath}/patients/4/refills">Patient 4 (Priya)</a> |
    <a href="${pageContext.request.contextPath}/pharmacist/refills" style="font-weight: bold;">Pharmacist Dashboard &rarr;</a>
  </div>

  <c:if test="${not empty message}">
    <div class="flash"><c:out value="${message}"/></div>
  </c:if>

  <div class="card">
    <h2>Submit Refill Request (Server-Side Validated)</h2>
    <form:form modelAttribute="refillForm" method="post" action="">
      <form:errors path="*" element="div" cssClass="error-box" />

      <div class="form-group">
        <label for="prescriptionId">Select Prescription:</label>
        <form:select path="prescriptionId" id="prescriptionId">
          <form:option value="" label="-- Choose Prescription --" />
          <c:forEach var="p" items="${prescriptions}">
            <form:option value="${p.id}">
              <c:out value="${p.medicineName} ${p.dosage}"/> (<c:out value="${p.refillsRemaining}"/> of <c:out value="${p.totalRefills}"/> refills remaining)
            </form:option>
          </c:forEach>
        </form:select>
        <form:errors path="prescriptionId" cssClass="error-msg" element="div"/>
      </div>

      <div class="form-group">
        <label for="requestDate">Request Date:</label>
        <form:input path="requestDate" type="date" id="requestDate"/>
        <form:errors path="requestDate" cssClass="error-msg" element="div"/>
      </div>

      <button type="submit">Submit Refill Request</button>
    </form:form>
  </div>

  <div class="card">
    <h2>My Pending Refill Requests</h2>
    <table>
      <thead>
        <tr>
          <th>Request #</th><th>Medicine</th><th>Dosage</th><th>Request Date</th><th>Status</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="r" items="${pending}">
          <tr>
            <td>#<c:out value="${r.id}"/></td>
            <td><c:out value="${r.prescription.medicineName}"/></td>
            <td><c:out value="${r.prescription.dosage}"/></td>
            <td><c:out value="${r.requestDate}"/></td>
            <td><span class="badge ${r.status}"><c:out value="${r.status}"/></span></td>
          </tr>
        </c:forEach>
        <c:if test="${empty pending}">
          <tr><td colspan="5" style="text-align: center; color: #64748b; padding: 16px;">No pending refill requests.</td></tr>
        </c:if>
      </tbody>
    </table>
  </div>
</body>
</html>
