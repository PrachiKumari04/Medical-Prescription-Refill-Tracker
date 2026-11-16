<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Patient Medication & Refill Portal &bull; RefillRx</title>
  
  <!-- Premium Modern Typography: Plus Jakarta Sans -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  
  <style>
    :root {
      --primary: #2563eb;
      --primary-dark: #1d4ed8;
      --teal: #0d9488;
      --teal-dark: #0f766e;
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

    /* Refill Alert Banners */
    .alert-banner { background: #fef3c7; border: 1px solid #fde047; border-left: 5px solid #d97706; padding: 14px 18px; border-radius: var(--radius-sm); margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between; }
    .alert-banner.urgent { background: #fee2e2; border-color: #fca5a5; border-left-color: #dc2626; }
    .alert-icon { font-size: 22px; margin-right: 12px; }
    .alert-content { flex: 1; }
    .alert-title { font-weight: 800; font-size: 14px; color: #92400e; }
    .alert-banner.urgent .alert-title { color: #991b1b; }
    .alert-msg { font-size: 13px; color: #78350f; margin-top: 2px; }
    .alert-banner.urgent .alert-msg { color: #7f1d1d; }

    /* Section Headers */
    .section-title { font-size: 18px; font-weight: 800; color: var(--dark); margin: 28px 0 16px 0; display: flex; align-items: center; gap: 8px; }
    
    /* Active Medications Grid */
    .med-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 18px; margin-bottom: 30px; }
    .med-card { background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); position: relative; display: flex; flex-direction: column; justify-content: space-between; }
    .med-card.status-due { border-color: #fcd34d; box-shadow: 0 0 0 1px #fcd34d, 0 4px 12px rgba(245, 158, 11, 0.12); }
    .med-card.status-critical { border-color: #fca5a5; box-shadow: 0 0 0 1px #fca5a5, 0 4px 12px rgba(239, 68, 68, 0.15); }

    .med-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; }
    .med-name { font-size: 17px; font-weight: 800; color: #1e293b; }
    .med-dose { font-size: 13px; color: var(--slate); font-weight: 600; margin-top: 2px; }
    
    .status-badge { font-size: 11px; font-weight: 800; padding: 4px 10px; border-radius: 20px; text-transform: uppercase; letter-spacing: 0.3px; }
    .status-badge.safe { background: #dcfce7; color: #166534; }
    .status-badge.due { background: #fef3c7; color: #b45309; }
    .status-badge.critical { background: #fee2e2; color: #b91c1c; }
    .status-badge.exhausted { background: #f1f5f9; color: #64748b; }

    /* Pill Gauge Progress Bar */
    .gauge-container { margin: 14px 0; }
    .gauge-info { display: flex; justify-content: space-between; font-size: 12px; font-weight: 700; color: #475569; margin-bottom: 6px; }
    .progress-bar-bg { width: 100%; height: 10px; background: #e2e8f0; border-radius: 6px; overflow: hidden; }
    .progress-bar-fill { height: 100%; border-radius: 6px; transition: width 0.3s; }
    .fill-safe { background: linear-gradient(90deg, #10b981, #059669); }
    .fill-due { background: linear-gradient(90deg, #f59e0b, #d97706); }
    .fill-critical { background: linear-gradient(90deg, #ef4444, #dc2626); }

    .med-meta { font-size: 12px; color: var(--slate); margin-bottom: 14px; line-height: 1.6; }
    .med-meta strong { color: var(--dark); }

    /* Action Forms Cards */
    .card { background: #fff; padding: 22px; border-radius: var(--radius); box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid var(--border); }
    .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
    
    label { font-size: 13px; font-weight: 700; color: #334155; display: block; margin-bottom: 6px; margin-top: 10px; }
    input[type="text"], input[type="number"], select { width: 100%; padding: 9px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13.5px; font-family: inherit; }
    
    .btn { padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 700; font-family: inherit; transition: all 0.2s; }
    .btn-primary { background: var(--primary); color: #fff; }
    .btn-primary:hover { background: var(--primary-dark); }
    .btn-otc { background: var(--teal); color: #fff; }
    .btn-otc:hover { background: var(--teal-dark); }
    .btn-refill-now { width: 100%; padding: 9px; background: #2563eb; color: white; border: none; border-radius: 6px; font-weight: 700; cursor: pointer; font-size: 13px; margin-top: 8px; }
    .btn-refill-now:hover { background: #1d4ed8; }
    .btn-refill-now.urgent { background: #dc2626; }
    .btn-refill-now.urgent:hover { background: #b91c1c; }
    .btn-logout { background: #64748b; color: #fff; }

    /* Requests History Table */
    table { border-collapse: collapse; width: 100%; margin-top: 12px; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
    th, td { border: 1px solid #e2e8f0; padding: 11px 14px; text-align: left; font-size: 13px; }
    th { background: #f8fafc; font-weight: 700; color: #334155; }
    .badge { padding: 4px 10px; border-radius: 12px; color: #fff; font-size: 11.5px; font-weight: 700; display: inline-block; }
    .PENDING { background: #d97706; } .APPROVED { background: #16a34a; }
    .REJECTED { background: #dc2626; } .COLLECTED { background: #2563eb; }
    .tag-otc { background: #ccfbf1; color: #0f766e; padding: 2px 6px; border-radius: 4px; font-size: 11px; font-weight: bold; }
    .tag-rx { background: #e0e7ff; color: #3730a3; padding: 2px 6px; border-radius: 4px; font-size: 11px; font-weight: bold; }
    .reason-text { color: #dc2626; font-size: 12px; margin-top: 4px; font-weight: 600; }
  </style>
</head>
<body>

  <!-- Top Header Bar -->
  <header>
    <div>
      <h1>RefillRx &bull; Patient Medication Tracker</h1>
      <div class="user-info">
        Welcome back, <strong><c:out value="${sessionScope.username}"/></strong> &middot; Real-Time Adherence & Exhaustion Engine &middot; <%= java.time.LocalDate.now() %>
      </div>
    </div>
    <div style="display: flex; gap: 12px; align-items: center;">
      <a href="${pageContext.request.contextPath}/" style="font-size: 13px; color: var(--primary); text-decoration: none; font-weight: 700;">&larr; RefillRx Home</a>
      <form method="post" action="${pageContext.request.contextPath}/logout">
        <button class="btn btn-logout" type="submit">Log out</button>
      </form>
    </div>
  </header>

  <!-- Flash Notification Message -->
  <c:if test="${not empty flash}">
    <div class="flash"><c:out value="${flash}"/></div>
  </c:if>

  <!-- ACTIVE REFILL ALERTS FROM PHARMACIST -->
  <c:if test="${not empty alerts}">
    <c:forEach var="a" items="${alerts}">
      <c:if test="${a.status == 'SENT'}">
        <div class="alert-banner ${a.daysRemaining <= 2 ? 'urgent' : ''}">
          <div style="display: flex; align-items: center;">
            <div class="alert-icon">🔔</div>
            <div class="alert-content">
              <div class="alert-title">
                <c:choose>
                  <c:when test="${a.daysRemaining <= 2}">CRITICAL ADHERENCE ALERT &bull; MEDICINE RUNNING OUT!</c:when>
                  <c:otherwise>AUTOMATED REFILL REMINDER &bull; ACTION REQUIRED</c:otherwise>
                </c:choose>
              </div>
              <div class="alert-msg"><c:out value="${a.message}"/> (Alert Date: <c:out value="${a.alertDate}"/>)</div>
            </div>
          </div>
          <div>
            <form method="post" action="${pageContext.request.contextPath}/refills" style="margin: 0;">
              <input type="hidden" name="action" value="submit">
              <input type="hidden" name="prescriptionId" value="${a.prescriptionId}">
              <button class="btn btn-primary" type="submit" style="white-space: nowrap;">⚡ Request Refill Now</button>
            </form>
          </div>
        </div>
      </c:if>
    </c:forEach>
  </c:if>

  <!-- SECTION 1: MY ACTIVE MEDICATIONS & PILL GAUGE -->
  <div class="section-title">
    <span>💊</span> My Active Chronic Medications & Pill Count Gauge
  </div>

  <c:choose>
    <c:when test="${not empty prescriptions}">
      <div class="med-grid">
        <c:forEach var="p" items="${prescriptions}">
          <div class="med-card ${p.daysRemaining <= 2 ? 'status-critical' : (p.daysRemaining <= 5 ? 'status-due' : '')}">
            <div>
              <div class="med-header">
                <div>
                  <div class="med-name"><c:out value="${p.medicineName}"/></div>
                  <div class="med-dose"><c:out value="${p.dosage}"/></div>
                </div>
                <div>
                  <c:choose>
                    <c:when test="${p.daysRemaining <= 0}">
                      <span class="status-badge exhausted">Exhausted</span>
                    </c:when>
                    <c:when test="${p.daysRemaining <= 2}">
                      <span class="status-badge critical">Run-Out in ${p.daysRemaining}d!</span>
                    </c:when>
                    <c:when test="${p.daysRemaining <= 5}">
                      <span class="status-badge due">Refill Due (${p.daysRemaining}d)</span>
                    </c:when>
                    <c:otherwise>
                      <span class="status-badge safe">Safe (${p.daysRemaining}d left)</span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>

              <!-- Pill Gauge Progress Bar -->
              <div class="gauge-container">
                <div class="gauge-info">
                  <span>Pill Supply Remaining:</span>
                  <span><strong>${p.remainingPills}</strong> / ${p.totalQuantity} units (${p.pillPercentage}%)</span>
                </div>
                <div class="progress-bar-bg">
                  <div class="progress-bar-fill ${p.daysRemaining <= 2 ? 'fill-critical' : (p.daysRemaining <= 5 ? 'fill-due' : 'fill-safe')}"
                       style="width: ${p.pillPercentage}%;"></div>
                </div>
              </div>

              <!-- Metadata & Adherence Info -->
              <div class="med-meta">
                <div>Daily Intake: <strong>${p.dailyDose} dose(s)/day</strong> &middot; Last Dispensed: <strong>${p.dispensedDate}</strong></div>
                <div>Estimated Run-Out: <strong style="color: ${p.daysRemaining <= 5 ? '#dc2626' : '#1e293b'};">${p.exhaustionDate}</strong></div>
                <div>Refills Remaining: <strong>${p.refillsRemaining} of ${p.totalRefills} authorized</strong></div>
              </div>
            </div>

            <!-- 1-Click Refill Action -->
            <form method="post" action="${pageContext.request.contextPath}/refills">
              <input type="hidden" name="action" value="submit">
              <input type="hidden" name="prescriptionId" value="${p.prescriptionId}">
              <c:choose>
                <c:when test="${p.refillsRemaining > 0}">
                  <button type="submit" class="btn-refill-now ${p.daysRemaining <= 2 ? 'urgent' : ''}">
                    <c:choose>
                      <c:when test="${p.daysRemaining <= 5}">⚡ Refill Due &mdash; Order 30-Day Refill</c:when>
                      <c:otherwise>Request Routine Refill</c:otherwise>
                    </c:choose>
                  </button>
                </c:when>
                <c:otherwise>
                  <button type="button" class="btn-refill-now" style="background: #94a3b8; cursor: not-allowed;" disabled>
                    0 Refills Left (Consult Doctor)
                  </button>
                </c:otherwise>
              </c:choose>
            </form>
          </div>
        </c:forEach>
      </div>
    </c:when>
    <c:otherwise>
      <div style="background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 24px; text-align: center; color: var(--slate); margin-bottom: 24px;">
        No active chronic medications on file. Submit your doctor's prescription below to start automated exhaustion tracking!
      </div>
    </c:otherwise>
  </c:choose>

  <!-- SECTION 2: PRESCRIPTION SUBMISSION & OTC DEMAND (2 COLUMNS) -->
  <div class="grid-2">
    <!-- Card 1: Submit Prescription to Pharmacist -->
    <div class="card">
      <h2 style="font-size: 16px; margin: 0 0 6px 0; color: #1e3a8a;"><span class="tag-rx">Rx</span> Submit Doctor's Prescription to Pharmacist</h2>
      <p style="font-size: 12.5px; color: var(--slate); margin-bottom: 12px;">
        Hand in or enter your doctor's prescription details. Your pharmacist will verify and activate your supply tracker.
      </p>
      <form method="post" action="${pageContext.request.contextPath}/refills">
        <input type="hidden" name="action" value="request_new_rx">
        
        <label for="medicineName">Medicine Name & Strength</label>
        <input type="text" name="medicineName" id="medicineName" placeholder="e.g. Metformin 500 mg, Amlodipine 5 mg" required>

        <label for="dosage">Dosage Instructions</label>
        <input type="text" name="dosage" id="dosage" placeholder="e.g. 1 tablet twice daily after meals" required>

        <label for="dailyDose">Daily Consumption (Pills per Day)</label>
        <input type="number" name="dailyDose" id="dailyDose" value="2" min="1" max="10" required>

        <button class="btn btn-primary" type="submit" style="width: 100%; margin-top: 16px; padding: 10px;">
          Submit Prescription to Pharmacy
        </button>
      </form>
    </div>

    <!-- Card 2: Self-Service OTC Demand -->
    <div class="card">
      <h2 style="font-size: 16px; margin: 0 0 6px 0; color: #0d9488;"><span class="tag-otc">OTC</span> Self-Service Common Medicines (Pain, Fever, Acidity)</h2>
      <p style="font-size: 12.5px; color: var(--slate); margin-bottom: 12px;">
        Request non-prescription everyday essentials (max 10 units limit per pharmacy safety protocol).
      </p>
      <form method="post" action="${pageContext.request.contextPath}/refills">
        <input type="hidden" name="action" value="submit_otc">
        
        <label for="otcMedicine">Select Common Medicine</label>
        <select name="otcMedicine" id="otcMedicine" required>
          <option value="Paracetamol 500 mg (Pain & Fever)">Paracetamol 500 mg (Pain & Fever)</option>
          <option value="Ibuprofen 200 mg (Pain Relief)">Ibuprofen 200 mg (Pain Relief)</option>
          <option value="Cetirizine 10 mg (Allergy & Cold)">Cetirizine 10 mg (Allergy & Cold)</option>
          <option value="Antacid Gel / Chewable Tablets (Acidity)">Antacid Gel / Chewable Tablets (Acidity)</option>
          <option value="ORS Electrolyte Hydration Pack">ORS Electrolyte Hydration Pack</option>
          <option value="Throat Lozenges (Cough/Throat Relief)">Throat Lozenges (Cough/Throat Relief)</option>
        </select>

        <label for="quantity">Quantity (Max 10 Units)</label>
        <input type="number" name="quantity" id="quantity" min="1" max="10" value="10" required>

        <button class="btn btn-otc" type="submit" style="width: 100%; margin-top: 16px; padding: 10px;">
          Submit OTC Demand
        </button>
      </form>
    </div>
  </div>

  <!-- SECTION 3: REQUESTS & DISPENSE AUDIT HISTORY -->
  <div class="section-title">
    <span>📋</span> My Refill & Pickup Requests History
  </div>

  <table>
    <thead>
      <tr>
        <th style="width: 60px;">#</th>
        <th>Medicine / Type</th>
        <th>Request Date</th>
        <th>Status</th>
        <th>Pharmacy Action / Status Notes</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="r" items="${requests}">
        <tr>
          <td>#<c:out value="${r.requestId}"/></td>
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
              <div class="reason-text">Reason: <c:out value="${r.rejectionReason}"/></div>
            </c:if>
          </td>
          <td>
            <c:choose>
              <c:when test="${r.status == 'PENDING'}"><span style="color: #d97706; font-weight: 600;">Pharmacist Reviewing & Preparing Batch</span></c:when>
              <c:when test="${r.status == 'APPROVED'}"><span style="color: #16a34a; font-weight: 700;">✓ Ready for Pickup at Pharmacy Counter!</span></c:when>
              <c:when test="${r.status == 'COLLECTED'}"><span style="color: #2563eb; font-weight: 600;">Collected by Patient</span></c:when>
              <c:when test="${r.status == 'REJECTED'}"><span style="color: #dc2626; font-weight: 600;">Rejected &mdash; please check reason</span></c:when>
            </c:choose>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty requests}">
        <tr><td colspan="5" style="text-align: center; color: var(--slate); padding: 20px;">No requests found.</td></tr>
      </c:if>
    </tbody>
  </table>

</body>
</html>
