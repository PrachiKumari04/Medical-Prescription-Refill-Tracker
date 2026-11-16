<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pharmacist Adherence & Refill Radar &bull; RefillRx</title>
  
  <!-- Premium Modern Typography: Plus Jakarta Sans -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  
  <style>
    :root {
      --primary: #2563eb;
      --primary-dark: #1d4ed8;
      --teal: #0d9488;
      --emerald: #10b981;
      --amber: #f59e0b;
      --red: #ef4444;
      --dark: #0f172a;
      --slate: #64748b;
      --border: #e2e8f0;
      --bg: #f8fafc;
      --radius: 12px;
      --radius-sm: 8px;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #f8fafc; color: var(--dark); padding: 24px; line-height: 1.5; }
    
    header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--border); padding-bottom: 16px; margin-bottom: 24px; }
    h1 { margin: 0 0 4px 0; font-size: 22px; color: #1e3a8a; font-weight: 800; }
    .user-info { font-size: 13.5px; color: var(--slate); }

    .flash { background: #dcfce7; border: 1px solid #86efac; color: #166534; padding: 12px 16px; border-radius: var(--radius-sm); margin-bottom: 20px; font-weight: 600; font-size: 13.5px; }

    /* Top Adherence KPI Metrics */
    .kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 24px; }
    .kpi-card { background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 18px 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
    .kpi-val { font-size: 28px; font-weight: 800; color: var(--dark); margin-top: 4px; }
    .kpi-lbl { font-size: 12.5px; color: var(--slate); font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
    .kpi-card.warning { border-left: 4px solid var(--amber); }
    .kpi-card.danger { border-left: 4px solid var(--red); }
    .kpi-card.success { border-left: 4px solid var(--emerald); }

    .section-title { font-size: 18px; font-weight: 800; color: var(--dark); margin: 28px 0 14px 0; display: flex; align-items: center; gap: 8px; }
    
    /* Tables */
    table { border-collapse: collapse; width: 100%; margin-top: 10px; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); margin-bottom: 24px; }
    th, td { border: 1px solid #e2e8f0; padding: 11px 14px; text-align: left; font-size: 13px; }
    th { background: #f8fafc; font-weight: 700; color: #334155; }
    
    /* Badges */
    .status-badge { font-size: 11px; font-weight: 800; padding: 3px 10px; border-radius: 20px; text-transform: uppercase; letter-spacing: 0.3px; display: inline-block; }
    .status-badge.safe { background: #dcfce7; color: #166534; }
    .status-badge.due { background: #fef3c7; color: #b45309; }
    .status-badge.critical { background: #fee2e2; color: #b91c1c; }
    .status-badge.exhausted { background: #f1f5f9; color: #64748b; }

    .badge { padding: 4px 10px; border-radius: 12px; color: #fff; font-size: 11.5px; font-weight: 700; display: inline-block; }
    .PENDING { background: #d97706; } .APPROVED { background: #16a34a; }
    .REJECTED { background: #dc2626; } .COLLECTED { background: #2563eb; }
    .tag-otc { background: #ccfbf1; color: #0f766e; padding: 2px 6px; border-radius: 4px; font-size: 11px; font-weight: bold; }
    .tag-rx { background: #e0e7ff; color: #3730a3; padding: 2px 6px; border-radius: 4px; font-size: 11px; font-weight: bold; }

    /* Action Buttons */
    .btn { padding: 7px 14px; border: none; border-radius: 6px; cursor: pointer; font-size: 12.5px; font-weight: 700; font-family: inherit; transition: all 0.2s; }
    .btn-primary { background: var(--primary); color: #fff; }
    .btn-primary:hover { background: var(--primary-dark); }
    .btn-approve { background: #16a34a; color: #fff; }
    .btn-approve:hover { background: #15803d; }
    .btn-reject { background: #dc2626; color: #fff; }
    .btn-reject:hover { background: #b91c1c; }
    .btn-collect { background: #0284c7; color: #fff; }
    .btn-collect:hover { background: #0369a1; }
    .btn-alert { background: #f59e0b; color: #fff; }
    .btn-alert:hover { background: #d97706; }
    .btn-logout { background: #64748b; color: #fff; }

    .card { background: #fff; padding: 22px; border-radius: var(--radius); box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid var(--border); margin-bottom: 24px; }
    
    .filters { margin-bottom: 12px; font-size: 13px; color: var(--slate); }
    .filters a { display: inline-block; padding: 5px 12px; text-decoration: none; border-radius: 4px; margin-right: 6px; font-size: 12.5px; background: #e2e8f0; color: #334155; font-weight: 600; }
    .filters a:hover { background: #cbd5e1; }

    label { font-size: 13px; font-weight: 700; color: #334155; display: block; margin-bottom: 5px; margin-top: 8px; }
    input[type="text"], input[type="number"], select { width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px; font-family: inherit; }
  </style>
</head>
<body>

  <!-- Top Header Bar -->
  <header>
    <div>
      <h1>RefillRx &bull; Pharmacist Adherence Radar & Dispense Portal</h1>
      <div class="user-info">
        Signed in as Licensed Pharmacist: <strong><c:out value="${sessionScope.username}"/></strong> &middot; Automated Refill Engine &middot; <%= java.time.LocalDate.now() %>
      </div>
    </div>
    <div style="display: flex; gap: 12px; align-items: center;">
      <a href="${pageContext.request.contextPath}/" style="font-size: 13px; color: var(--primary); text-decoration: none; font-weight: 700;">&larr; RefillRx Home</a>
      <form method="post" action="${pageContext.request.contextPath}/logout">
        <button class="btn btn-logout" type="submit">Log out</button>
      </form>
    </div>
  </header>

  <c:if test="${not empty flash}">
    <div class="flash"><c:out value="${flash}"/></div>
  </c:if>

  <!-- KPI SUMMARY CARDS -->
  <c:set var="dueCount" value="0"/>
  <c:set var="criticalCount" value="0"/>
  <c:forEach var="p" items="${adherenceRadar}">
    <c:if test="${p.daysRemaining <= 2}">
      <c:set var="criticalCount" value="${criticalCount + 1}"/>
    </c:if>
    <c:if test="${p.daysRemaining <= 5 && p.daysRemaining > 2}">
      <c:set var="dueCount" value="${dueCount + 1}"/>
    </c:if>
  </c:forEach>

  <div class="kpi-grid">
    <div class="kpi-card success">
      <div class="kpi-lbl">Chronic Prescriptions Monitored</div>
      <div class="kpi-val">${adherenceRadar.size()}</div>
    </div>
    <div class="kpi-card warning">
      <div class="kpi-lbl">Refills Due Soon (&le; 5 Days)</div>
      <div class="kpi-val" style="color: #b45309;">${dueCount}</div>
    </div>
    <div class="kpi-card danger">
      <div class="kpi-lbl">Critical Run-Out (&le; 2 Days)</div>
      <div class="kpi-val" style="color: #b91c1c;">${criticalCount}</div>
    </div>
  </div>

  <!-- SECTION 1: REFILL ADHERENCE & EXHAUSTION FORECAST RADAR -->
  <div class="section-title">
    <span>📡</span> Patient Medication Exhaustion Forecast & Proactive Refill Radar
  </div>
  <p style="font-size: 13px; color: var(--slate); margin-top: -6px; margin-bottom: 12px;">
    Patients sorted by days of supply remaining. Automated algorithms calculate exhaustion dates from daily consumption rates to prevent therapy gaps.
  </p>

  <table>
    <thead>
      <tr>
        <th>Patient Name</th>
        <th>Medicine & Strength</th>
        <th>Daily Dose</th>
        <th>Supply & Last Dispensed</th>
        <th>Exhaustion (Run-Out) Date</th>
        <th>Days Left</th>
        <th>Adherence Status</th>
        <th>Proactive Pharmacist Action</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="p" items="${adherenceRadar}">
        <tr style="${p.daysRemaining <= 2 ? 'background: #fff1f2;' : (p.daysRemaining <= 5 ? 'background: #fffbeb;' : '')}">
          <td><strong><c:out value="${p.patientName}"/></strong></td>
          <td><span class="tag-rx">Rx</span> <strong><c:out value="${p.medicineName}"/></strong> (<c:out value="${p.dosage}"/>)</td>
          <td>${p.dailyDose} dose(s)/day</td>
          <td>${p.totalQuantity} units &middot; <span style="color: #64748b;">${p.dispensedDate}</span></td>
          <td><strong>${p.exhaustionDate}</strong></td>
          <td>
            <strong style="font-size: 14px; color: ${p.daysRemaining <= 2 ? '#dc2626' : (p.daysRemaining <= 5 ? '#d97706' : '#16a34a')};">
              ${p.daysRemaining} days
            </strong>
          </td>
          <td>
            <c:choose>
              <c:when test="${p.daysRemaining <= 0}"><span class="status-badge exhausted">Exhausted</span></c:when>
              <c:when test="${p.daysRemaining <= 2}"><span class="status-badge critical">Critical Due (&le;2d)</span></c:when>
              <c:when test="${p.daysRemaining <= 5}"><span class="status-badge due">Refill Due (&le;5d)</span></c:when>
              <c:otherwise><span class="status-badge safe">Adequate Supply</span></c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:choose>
              <c:when test="${p.daysRemaining <= 5}">
                <form method="post" action="${pageContext.request.contextPath}/refills" style="margin: 0;">
                  <input type="hidden" name="action" value="send_alert">
                  <input type="hidden" name="prescriptionId" value="${p.prescriptionId}">
                  <input type="hidden" name="patientId" value="${p.patientId}">
                  <input type="hidden" name="medicineName" value="${p.medicineName}">
                  <input type="hidden" name="daysRemaining" value="${p.daysRemaining}">
                  <button class="btn btn-alert" type="submit">
                    🔔 Send Refill Reminder
                  </button>
                </form>
              </c:when>
              <c:otherwise>
                <span style="color: #10b981; font-size: 12px; font-weight: 600;">✓ Supply On Track</span>
              </c:otherwise>
            </c:choose>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <!-- SECTION 2: DISPENSE MEDICATION CARD -->
  <div class="card">
    <div class="section-title" style="margin-top: 0;">
      <span>💊</span> Dispense Chronic Medication & Initialize Exhaustion Tracking
    </div>
    <p style="font-size: 13px; color: var(--slate); margin-top: -6px; margin-bottom: 14px;">
      Dispensing calculates <code>Days of Supply = (Total Quantity / Daily Dose)</code> and sets the automated exhaustion countdown clock for the patient.
    </p>

    <form method="post" action="${pageContext.request.contextPath}/refills">
      <input type="hidden" name="action" value="dispense">

      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 14px;">
        <div>
          <label for="patientId">Select Patient</label>
          <select name="patientId" id="patientId" required>
            <c:forEach var="pt" items="${patients}">
              <option value="${pt.id}"><c:out value="${pt.name}"/> (${pt.phone})</option>
            </c:forEach>
          </select>
        </div>

        <div>
          <label for="medicineName">Medicine Name</label>
          <input type="text" name="medicineName" id="medicineName" placeholder="e.g. Metformin, Amlodipine" required>
        </div>

        <div>
          <label for="dosage">Dosage Instructions</label>
          <input type="text" name="dosage" id="dosage" placeholder="e.g. 500 mg, 1 tab twice daily" required>
        </div>

        <div>
          <label for="dailyDose">Daily Consumption (Tabs/Day)</label>
          <input type="number" name="dailyDose" id="dailyDose" value="2" min="1" max="10" required>
        </div>

        <div>
          <label for="totalQuantity">Quantity Dispensed</label>
          <input type="number" name="totalQuantity" id="totalQuantity" value="60" min="1" required>
        </div>

        <div>
          <label for="totalRefills">Authorized Refills</label>
          <input type="number" name="totalRefills" id="totalRefills" value="5" min="1" max="12" required>
        </div>
      </div>

      <button class="btn btn-primary" type="submit" style="margin-top: 16px; padding: 10px 20px;">
        Dispense & Activate Exhaustion Clock
      </button>
    </form>
  </div>

  <!-- SECTION 3: REFILL & DEMAND REQUESTS QUEUE -->
  <div class="section-title">
    <span>📋</span> Patient Refill & OTC Requests Queue
  </div>

  <div class="filters">
    Filter requests by status:
    <a href="${pageContext.request.contextPath}/refills?status=ALL">ALL</a>
    <c:forEach var="s" items="${statuses}">
      <a href="${pageContext.request.contextPath}/refills?status=${s}"><c:out value="${s}"/></a>
    </c:forEach>
  </div>

  <table>
    <thead>
      <tr>
        <th style="width: 50px;">#</th>
        <th>Patient</th>
        <th>Medicine / Type</th>
        <th>Request Date</th>
        <th>Status</th>
        <th>Pharmacist Review Action</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="r" items="${requests}">
        <tr>
          <td>#<c:out value="${r.requestId}"/></td>
          <td><strong><c:out value="${r.patientName}"/></strong></td>
          <td>
            <c:choose>
              <c:when test="${r.otc}">
                <span class="tag-otc">OTC</span> <c:out value="${r.otcMedicine}"/> <strong>(Qty: ${r.quantity})</strong>
              </c:when>
              <c:otherwise>
                <span class="tag-rx">Rx</span> <c:out value="${r.medicineName} ${r.dosage}"/>
              </c:otherwise>
            </c:choose>
          </td>
          <td><c:out value="${r.requestDate}"/></td>
          <td>
            <span class="badge ${r.status}"><c:out value="${r.status}"/></span>
            <c:if test="${r.status == 'REJECTED' && not empty r.rejectionReason}">
              <div style="color: #dc2626; font-size: 12px; font-weight: 600; margin-top: 4px;">
                Reason: <c:out value="${r.rejectionReason}"/>
              </div>
            </c:if>
          </td>
          <td>
            <c:if test="${r.status == 'PENDING'}">
              <form style="display: inline;" method="post" action="${pageContext.request.contextPath}/refills">
                <input type="hidden" name="action" value="approve">
                <input type="hidden" name="requestId" value="${r.requestId}">
                <button class="btn btn-approve" type="submit">Approve & Dispense</button>
              </form>

              <form style="display: inline; margin-left: 6px;" method="post" action="${pageContext.request.contextPath}/refills">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="requestId" value="${r.requestId}">
                <input type="text" name="reason" placeholder="Rejection reason..." style="width: 150px; padding: 5px 8px; font-size: 12px;" required>
                <button class="btn btn-reject" type="submit">Reject</button>
              </form>
            </c:if>
            <c:if test="${r.status == 'APPROVED'}">
              <form style="display: inline;" method="post" action="${pageContext.request.contextPath}/refills">
                <input type="hidden" name="action" value="collect">
                <input type="hidden" name="requestId" value="${r.requestId}">
                <button class="btn btn-collect" type="submit">Mark Collected</button>
              </form>
            </c:if>
            <c:if test="${r.status == 'COLLECTED'}">
              <span style="color: #2563eb; font-weight: 600; font-size: 12.5px;">✓ Collected by Patient</span>
            </c:if>
            <c:if test="${r.status == 'REJECTED'}">
              <span style="color: #dc2626; font-weight: 600; font-size: 12.5px;">Rejected</span>
            </c:if>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty requests}">
        <tr><td colspan="6" style="text-align: center; color: var(--slate); padding: 20px;">No refill requests found.</td></tr>
      </c:if>
    </tbody>
  </table>

</body>
</html>
