<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Doctor Portal - Prescription Refill Tracker</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 24px; background: #f8fafc; color: #1e293b; }
    header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #e2e8f0; padding-bottom: 14px; margin-bottom: 24px; }
    h1 { margin: 0 0 6px 0; font-size: 24px; color: #0f172a; }
    .user-info { font-size: 14px; color: #64748b; }
    .doctor-badge { background: #0284c7; color: white; padding: 2px 8px; border-radius: 4px; font-weight: 600; font-size: 12px; }
    .card { background: #ffffff; border-radius: 8px; border: 1px solid #e2e8f0; padding: 20px; margin-bottom: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }
    h2 { margin-top: 0; font-size: 18px; color: #1e293b; border-bottom: 1px solid #f1f5f9; padding-bottom: 10px; }
    table { border-collapse: collapse; width: 100%; margin-top: 12px; font-size: 14px; }
    th, td { border: 1px solid #e2e8f0; padding: 10px 14px; text-align: left; }
    th { background: #f1f5f9; font-weight: 600; color: #475569; }
    .flash { background: #dcfce7; border: 1px solid #86efac; color: #166534; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; font-weight: 500; }
    .badge { padding: 3px 10px; border-radius: 12px; color: #fff; font-size: 12px; font-weight: bold; display: inline-block; }
    .PENDING { background: #d97706; } .APPROVED { background: #16a34a; }
    .REJECTED { background: #dc2626; } .COLLECTED { background: #2563eb; }
    .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 600; }
    .btn-primary { background: #2563eb; color: #fff; }
    .btn-primary:hover { background: #1d4ed8; }
    .btn-logout { background: #64748b; color: #fff; }
    .form-row { display: flex; gap: 16px; flex-wrap: wrap; margin-bottom: 14px; align-items: flex-end; }
    .form-group { display: flex; flex-direction: column; flex: 1; min-width: 180px; }
    label { font-size: 13px; font-weight: 600; margin-bottom: 6px; color: #334155; }
    input[type="text"], input[type="number"], select { padding: 9px 12px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 14px; }
    .rejection-note { color: #dc2626; font-size: 12px; margin-top: 4px; font-weight: 500; }
    .stats-pill { display: inline-block; padding: 2px 8px; border-radius: 4px; font-size: 12px; font-weight: 600; }
    .stats-good { background: #dcfce7; color: #166534; }
    .stats-warn { background: #fee2e2; color: #991b1b; }
  </style>
</head>
<body>
  <header>
    <div>
      <h1>Medical Prescription Refill Tracker</h1>
      <div class="user-info">
        Signed in as <strong><c:out value="${sessionScope.username}"/></strong>
        <span class="doctor-badge">PHYSICIAN / CLINICIAN</span> &middot; <%= java.time.LocalDate.now() %>
      </div>
    </div>
    <div style="display: flex; gap: 12px; align-items: center;">
      <a href="${pageContext.request.contextPath}/" style="font-size: 13px; color: #0284c7; text-decoration: none; font-weight: 600;">&larr; RefillRx Home</a>
      <form method="post" action="${pageContext.request.contextPath}/logout">
        <button class="btn btn-logout" type="submit">Log out</button>
      </form>
    </div>
  </header>

  <c:if test="${not empty flash}">
    <div class="flash"><c:out value="${flash}"/></div>
  </c:if>

  <!-- Section 1: Prescribe New Medicine -->
  <div class="card">
    <h2>Prescribe New Medicine to Patient</h2>
    <form method="post" action="${pageContext.request.contextPath}/refills">
      <input type="hidden" name="action" value="prescribe">
      <div class="form-row">
        <div class="form-group">
          <label for="patientId">Select Patient:</label>
          <select name="patientId" id="patientId" required>
            <c:forEach var="pt" items="${patients}">
              <option value="${pt.id}"><c:out value="${pt.name}"/> (ID: #${pt.id}, Phone: ${pt.phone})</option>
            </c:forEach>
          </select>
        </div>
        <div class="form-group">
          <label for="medicineName">Medicine Name:</label>
          <input type="text" name="medicineName" id="medicineName" placeholder="e.g. Telmisartan, Amoxicillin" required>
        </div>
        <div class="form-group">
          <label for="dosage">Dosage / Strength:</label>
          <input type="text" name="dosage" id="dosage" placeholder="e.g. 40 mg, 500 mg, Once daily" required>
        </div>
        <div class="form-group" style="max-width: 140px;">
          <label for="totalRefills">Authorized Refills:</label>
          <input type="number" name="totalRefills" id="totalRefills" min="0" max="24" value="5" required>
        </div>
        <div>
          <button class="btn btn-primary" type="submit">+ Prescribe Medicine</button>
        </div>
      </div>
    </form>
  </div>

  <!-- Section 2: Live Prescription & Refill Analytics -->
  <div class="card">
    <h2>Patient Prescription & Refill Consumption Stats</h2>
    <table>
      <thead>
        <tr>
          <th>Prescription #</th>
          <th>Patient</th>
          <th>Prescribed Medicine</th>
          <th>Dosage</th>
          <th>Total Refills</th>
          <th>Refills Consumed</th>
          <th>Refills Remaining</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="p" items="${prescriptions}">
          <tr>
            <td>#<c:out value="${p.prescriptionId}"/></td>
            <td><strong><c:out value="${p.patientName}"/></strong></td>
            <td><c:out value="${p.medicineName}"/></td>
            <td><c:out value="${p.dosage}"/></td>
            <td><c:out value="${p.totalRefills}"/></td>
            <td><c:out value="${p.refillsUsed}"/> of <c:out value="${p.totalRefills}"/></td>
            <td>
              <strong><c:out value="${p.refillsRemaining}"/> left</strong>
            </td>
            <td>
              <c:choose>
                <c:when test="${p.refillsRemaining > 0}">
                  <span class="stats-pill stats-good">Active Refills Available</span>
                </c:when>
                <c:otherwise>
                  <span class="stats-pill stats-warn">Refills Exhausted (Renewal Needed)</span>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <!-- Section 3: Audit Trail of Pharmacist Refill Decisions -->
  <div class="card">
    <h2>Audit Trail: Pharmacist Refill Approvals & Rejection Reasons</h2>
    <table>
      <thead>
        <tr>
          <th>Request #</th>
          <th>Patient</th>
          <th>Medicine</th>
          <th>Requested Date</th>
          <th>Refill Status</th>
          <th>Pharmacist Notes / Reason</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="r" items="${requests}">
          <tr>
            <td>#<c:out value="${r.requestId}"/></td>
            <td><c:out value="${r.patientName}"/></td>
            <td><c:out value="${r.displayMedicine}"/></td>
            <td><c:out value="${r.requestDate}"/></td>
            <td><span class="badge ${r.status}"><c:out value="${r.status}"/></span></td>
            <td>
              <c:choose>
                <c:when test="${r.status == 'REJECTED' && not empty r.rejectionReason}">
                  <div class="rejection-note">⚠️ Rejected: <c:out value="${r.rejectionReason}"/></div>
                </c:when>
                <c:when test="${r.status == 'COLLECTED'}">
                  <span style="color: #2563eb; font-size: 13px;">Dispensed & Collected</span>
                </c:when>
                <c:when test="${r.status == 'APPROVED'}">
                  <span style="color: #16a34a; font-size: 13px;">Approved & Ready for Pickup</span>
                </c:when>
                <c:otherwise>
                  <span style="color: #d97706; font-size: 13px;">Awaiting Pharmacist Decision</span>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</body>
</html>

