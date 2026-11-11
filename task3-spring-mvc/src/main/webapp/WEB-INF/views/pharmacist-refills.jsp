<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Pharmacist Console - Spring MVC & JPA</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 32px; background: #f8fafc; color: #1e293b; }
    h1 { color: #0f172a; margin-bottom: 4px; }
    .subtitle { color: #64748b; margin-bottom: 24px; font-size: 14px; }
    .card { background: #fff; padding: 24px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; margin-bottom: 24px; }
    table { border-collapse: collapse; width: 100%; margin-top: 14px; background: #fff; }
    th, td { border: 1px solid #cbd5e1; padding: 8px 12px; text-align: left; }
    th { background: #f1f5f9; color: #334155; }
    .flash { background: #dcfce7; border: 1px solid #86efac; color: #166534; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-weight: 500; }
    .error-box { background: #fee2e2; border: 1px solid #f87171; color: #991b1b; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-weight: 500; }
    .badge { padding: 3px 10px; border-radius: 12px; color: #fff; font-size: 12px; font-weight: bold; }
    .PENDING { background: #d97706; } .APPROVED { background: #16a34a; }
    .REJECTED { background: #dc2626; } .COLLECTED { background: #2563eb; }
    form.inline { display: inline; margin-right: 4px; }
    .btn { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; font-weight: 500; }
    .btn-approve { background: #16a34a; color: #fff; }
    .btn-reject { background: #dc2626; color: #fff; }
    .btn-collect { background: #0284c7; color: #fff; }
    .summary-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 20px; }
    .summary-tile { background: #f1f5f9; border-radius: 6px; padding: 16px; text-align: center; border: 1px solid #e2e8f0; }
    .summary-tile .count { font-size: 26px; font-weight: bold; margin-top: 6px; }
    .filters a { display: inline-block; padding: 6px 12px; text-decoration: none; border-radius: 4px; margin-right: 6px; font-size: 13px; background: #e2e8f0; color: #334155; font-weight: 500; }
    .filters a.active { background: #2563eb; color: #fff; }
    .nav-links a { color: #2563eb; text-decoration: none; margin-right: 12px; font-size: 14px; }
  </style>
</head>
<body>
  <h1>Medical Prescription Refill Tracker</h1>
  <div class="subtitle">Task 3: Spring MVC + JPA / Hibernate Module</div>

  <div class="nav-links" style="margin-bottom: 20px;">
    Patient Portal:
    <a href="${pageContext.request.contextPath}/patients/1/refills">Ravi (Patient 1)</a> |
    <a href="${pageContext.request.contextPath}/patients/2/refills">Sneha (Patient 2)</a> |
    <a href="${pageContext.request.contextPath}/patients/3/refills">Amit (Patient 3)</a> |
    <a href="${pageContext.request.contextPath}/patients/4/refills">Priya (Patient 4)</a>
  </div>

  <c:if test="${not empty message}">
    <div class="flash"><c:out value="${message}"/></div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="error-box"><c:out value="${error}"/></div>
  </c:if>

  <div class="summary-grid">
    <div class="summary-tile">
      <div style="color: #d97706; font-weight: bold;">PENDING</div>
      <div class="count" style="color: #d97706;"><c:out value="${summary['PENDING']}"/></div>
    </div>
    <div class="summary-tile">
      <div style="color: #16a34a; font-weight: bold;">APPROVED</div>
      <div class="count" style="color: #16a34a;"><c:out value="${summary['APPROVED']}"/></div>
    </div>
    <div class="summary-tile">
      <div style="color: #dc2626; font-weight: bold;">REJECTED</div>
      <div class="count" style="color: #dc2626;"><c:out value="${summary['REJECTED']}"/></div>
    </div>
    <div class="summary-tile">
      <div style="color: #2563eb; font-weight: bold;">COLLECTED</div>
      <div class="count" style="color: #2563eb;"><c:out value="${summary['COLLECTED']}"/></div>
    </div>
  </div>

  <div class="card">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
      <h2 style="margin: 0;">Refill Requests (<c:out value="${status}"/>)</h2>
      <div class="filters">
        <c:forEach var="s" items="${statuses}">
          <a class="${s == status ? 'active' : ''}" href="${pageContext.request.contextPath}/pharmacist/refills?status=${s}">
            <c:out value="${s}"/>
          </a>
        </c:forEach>
      </div>
    </div>

    <table>
      <thead>
        <tr>
          <th>#</th><th>Patient</th><th>Medicine</th><th>Requested</th><th>Status</th><th>Action</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="r" items="${requests}">
          <tr>
            <td>#<c:out value="${r.id}"/></td>
            <td><c:out value="${r.prescription.patient.name}"/></td>
            <td><c:out value="${r.prescription.medicineName} ${r.prescription.dosage}"/></td>
            <td><c:out value="${r.requestDate}"/></td>
            <td><span class="badge ${r.status}"><c:out value="${r.status}"/></span></td>
            <td>
              <c:if test="${r.status == 'PENDING'}">
                <form class="inline" method="post" action="${pageContext.request.contextPath}/pharmacist/refills/${r.id}/approve">
                  <button class="btn btn-approve" type="submit">Approve</button>
                </form>
                <form class="inline" method="post" action="${pageContext.request.contextPath}/pharmacist/refills/${r.id}/reject">
                  <button class="btn btn-reject" type="submit">Reject</button>
                </form>
              </c:if>
              <c:if test="${r.status == 'APPROVED'}">
                <form class="inline" method="post" action="${pageContext.request.contextPath}/pharmacist/refills/${r.id}/collect">
                  <button class="btn btn-collect" type="submit">Mark Collected</button>
                </form>
              </c:if>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty requests}">
          <tr><td colspan="6" style="text-align: center; color: #64748b; padding: 20px;">No requests found for this status.</td></tr>
        </c:if>
      </tbody>
    </table>
  </div>
</body>
</html>
