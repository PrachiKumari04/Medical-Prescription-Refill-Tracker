<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Refill Requests</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 24px; background: #fdfdfd; color: #222; }
    header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #e2e8f0; padding-bottom: 12px; margin-bottom: 20px; }
    h1 { margin: 0 0 6px 0; font-size: 24px; color: #1e3a8a; }
    .user-info { font-size: 14px; color: #475569; }
    table { border-collapse: collapse; width: 100%; margin-top: 14px; background: #fff; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    th, td { border: 1px solid #cbd5e1; padding: 8px 12px; text-align: left; }
    th { background: #f1f5f9; font-weight: 600; color: #334155; }
    .flash { background: #dcfce7; border: 1px solid #86efac; color: #166534; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-weight: 500; }
    .badge { padding: 3px 10px; border-radius: 12px; color: #fff; font-size: 12px; font-weight: bold; display: inline-block; }
    .PENDING { background: #d97706; } .APPROVED { background: #16a34a; }
    .REJECTED { background: #dc2626; } .COLLECTED { background: #2563eb; }
    form.inline { display: inline; margin-right: 4px; }
    .btn { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; font-weight: 500; }
    .btn-primary { background: #2563eb; color: #fff; }
    .btn-approve { background: #16a34a; color: #fff; }
    .btn-reject { background: #dc2626; color: #fff; }
    .btn-collect { background: #0284c7; color: #fff; }
    .btn-logout { background: #64748b; color: #fff; }
    select { padding: 7px 10px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 14px; min-width: 280px; }
    .filters a { display: inline-block; padding: 4px 10px; text-decoration: none; border-radius: 4px; margin-right: 4px; font-size: 13px; background: #e2e8f0; color: #334155; }
    .filters a:hover { background: #cbd5e1; }
  </style>
</head>
<body>
  <header>
    <div>
      <h1>Medical Prescription Refill Tracker</h1>
      <div class="user-info">
        Signed in as <strong><c:out value="${sessionScope.username}"/></strong>
        (<c:out value="${sessionScope.role}"/>) &middot; <%= java.time.LocalDate.now() %>
      </div>
    </div>
    <div>
      <form method="post" action="${pageContext.request.contextPath}/logout">
        <button class="btn btn-logout" type="submit">Log out</button>
      </form>
    </div>
  </header>

  <c:if test="${not empty flash}">
    <div class="flash"><c:out value="${flash}"/></div>
  </c:if>

  <c:choose>
    <c:when test="${sessionScope.role == 'PHARMACIST'}">
      <h2>Refill requests: <c:out value="${filter}"/></h2>
      <p class="filters">Filter by status:
        <c:forEach var="s" items="${statuses}">
          <a href="${pageContext.request.contextPath}/refills?status=${s}"><c:out value="${s}"/></a>
        </c:forEach>
      </p>
    </c:when>
    <c:otherwise>
      <h2>Request a Refill</h2>
      <form method="post" action="${pageContext.request.contextPath}/refills" style="margin-bottom: 24px;">
        <input type="hidden" name="action" value="submit">
        <label for="prescriptionId" style="font-weight: 500;">Select Prescription: </label>
        <select name="prescriptionId" id="prescriptionId" required>
          <c:forEach var="p" items="${prescriptions}">
            <option value="${p.prescriptionId}">
              <c:out value="${p.medicineName} ${p.dosage}"/> (<c:out value="${p.refillsRemaining}"/> refills left)
            </option>
          </c:forEach>
        </select>
        &nbsp;
        <button class="btn btn-primary" type="submit">Submit Request</button>
      </form>
      <h2>My Refill Requests</h2>
    </c:otherwise>
  </c:choose>

  <table>
    <thead>
      <tr>
        <th>#</th><th>Patient</th><th>Medicine</th><th>Requested</th><th>Status</th><th>Action</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="r" items="${requests}">
        <tr>
          <td><c:out value="${r.requestId}"/></td>
          <td><c:out value="${r.patientName}"/></td>
          <td><c:out value="${r.medicineName} ${r.dosage}"/></td>
          <td><c:out value="${r.requestDate}"/></td>
          <td><span class="badge ${r.status}"><c:out value="${r.status}"/></span></td>
          <td>
            <c:if test="${sessionScope.role == 'PHARMACIST'}">
              <c:if test="${r.status == 'PENDING'}">
                <form class="inline" method="post" action="${pageContext.request.contextPath}/refills">
                  <input type="hidden" name="action" value="approve">
                  <input type="hidden" name="requestId" value="${r.requestId}">
                  <button class="btn btn-approve" type="submit">Approve</button>
                </form>
                <form class="inline" method="post" action="${pageContext.request.contextPath}/refills">
                  <input type="hidden" name="action" value="reject">
                  <input type="hidden" name="requestId" value="${r.requestId}">
                  <button class="btn btn-reject" type="submit">Reject</button>
                </form>
              </c:if>
              <c:if test="${r.status == 'APPROVED'}">
                <form class="inline" method="post" action="${pageContext.request.contextPath}/refills">
                  <input type="hidden" name="action" value="collect">
                  <input type="hidden" name="requestId" value="${r.requestId}">
                  <button class="btn btn-collect" type="submit">Mark Collected</button>
                </form>
              </c:if>
            </c:if>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty requests}">
        <tr><td colspan="6" style="text-align: center; color: #64748b; padding: 20px;">No requests found.</td></tr>
      </c:if>
    </tbody>
  </table>
</body>
</html>

