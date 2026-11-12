<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Refill Requests - Pharmacy Portal</title>
  <!-- Premium Modern Typography: Plus Jakarta Sans -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; margin: 24px; background: #f8fafc; color: #1e293b; }
    header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #e2e8f0; padding-bottom: 12px; margin-bottom: 20px; }
    h1 { margin: 0 0 6px 0; font-size: 24px; color: #1e3a8a; }
    .user-info { font-size: 14px; color: #475569; }
    .card { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.06); border: 1px solid #e2e8f0; margin-bottom: 20px; }
    table { border-collapse: collapse; width: 100%; margin-top: 14px; background: #fff; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }
    th, td { border: 1px solid #cbd5e1; padding: 10px 12px; text-align: left; }
    th { background: #f1f5f9; font-weight: 600; color: #334155; }
    .flash { background: #dcfce7; border: 1px solid #86efac; color: #166534; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-weight: 500; }
    .badge { padding: 3px 10px; border-radius: 12px; color: #fff; font-size: 12px; font-weight: bold; display: inline-block; }
    .PENDING { background: #d97706; } .APPROVED { background: #16a34a; }
    .REJECTED { background: #dc2626; } .COLLECTED { background: #2563eb; }
    form.inline { display: inline; margin-right: 4px; }
    .btn { padding: 7px 14px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; font-weight: 600; }
    .btn-primary { background: #2563eb; color: #fff; }
    .btn-primary:hover { background: #1d4ed8; }
    .btn-otc { background: #0d9488; color: #fff; }
    .btn-otc:hover { background: #0f766e; }
    .btn-approve { background: #16a34a; color: #fff; }
    .btn-reject { background: #dc2626; color: #fff; }
    .btn-collect { background: #0284c7; color: #fff; }
    .btn-logout { background: #64748b; color: #fff; }
    select, input[type="number"], input[type="text"] { padding: 8px 10px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 14px; }
    .filters a { display: inline-block; padding: 5px 12px; text-decoration: none; border-radius: 4px; margin-right: 6px; font-size: 13px; background: #e2e8f0; color: #334155; font-weight: 500; }
    .filters a:hover { background: #cbd5e1; }
    .banner { padding: 12px 16px; border-radius: 6px; margin-bottom: 14px; font-size: 13px; line-height: 1.5; }
    .banner-info { background: #f0fdfa; border: 1px solid #99f6e4; color: #115e59; }
    .tag-otc { background: #ccfbf1; color: #0f766e; padding: 2px 6px; border-radius: 4px; font-size: 11px; font-weight: bold; margin-right: 4px; }
    .tag-rx { background: #e0e7ff; color: #3730a3; padding: 2px 6px; border-radius: 4px; font-size: 11px; font-weight: bold; margin-right: 4px; }
    .reason-text { color: #dc2626; font-size: 12px; margin-top: 4px; font-weight: 500; }
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
    <div style="display: flex; gap: 12px; align-items: center;">
      <a href="${pageContext.request.contextPath}/" style="font-size: 13px; color: #2563eb; text-decoration: none; font-weight: 600;">&larr; RefillRx Home</a>
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
      <h2>Refill & Demand Requests: <c:out value="${filter}"/></h2>
      <p class="filters">Filter by status:
        <c:forEach var="s" items="${statuses}">
          <a href="${pageContext.request.contextPath}/refills?status=${s}"><c:out value="${s}"/></a>
        </c:forEach>
      </p>
    </c:when>

    <c:otherwise>
      <!-- PATIENT WORKFLOW -->
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px;">
        
        <!-- CARD 1: Prescribed Refill -->
        <div class="card">
          <h2 style="font-size: 17px; margin-top: 0; color: #1e3a8a;"><span class="tag-rx">Rx</span> Request Doctor-Prescribed Refill</h2>
          <p style="font-size: 13px; color: #64748b; margin-top: 0;">Refill a chronic prescription authorised by your physician.</p>
          <form method="post" action="${pageContext.request.contextPath}/refills">
            <input type="hidden" name="action" value="submit">
            <label for="prescriptionId" style="font-weight: 600; display: block; font-size: 13px; margin-bottom: 6px;">Your Authorized Prescriptions:</label>
            <c:choose>
              <c:when test="${not empty prescriptions}">
                <select name="prescriptionId" id="prescriptionId" style="width: 100%; margin-bottom: 12px;" required>
                  <c:forEach var="p" items="${prescriptions}">
                    <option value="${p.prescriptionId}">
                      <c:out value="${p.medicineName} ${p.dosage}"/> (<c:out value="${p.refillsRemaining}"/> of <c:out value="${p.totalRefills}"/> refills left)
                    </option>
                  </c:forEach>
                </select>
                <button class="btn btn-primary" type="submit">Request Prescription Refill</button>
              </c:when>
              <c:otherwise>
                <p style="color: #64748b; font-size: 13px; background: #f8fafc; padding: 10px; border-radius: 4px; border: 1px solid #e2e8f0; margin-bottom: 0;">
                  No active prescriptions assigned yet. You can request Over-The-Counter medicines on the right, or ask your physician (Dr. Patil) to prescribe chronic medicines for you!
                </p>
              </c:otherwise>
            </c:choose>
          </form>
        </div>

        <!-- CARD 2: OTC Common Medicine Demand -->
        <div class="card">
          <h2 style="font-size: 17px; margin-top: 0; color: #0d9488;"><span class="tag-otc">OTC</span> Demand Common Medicine (Pain Relievers, Fever, etc.)</h2>
          <div class="banner banner-info">
            <strong>Self-Service OTC Policy:</strong> You can request common medicines without a doctor's prescription up to <strong>maximum 10 units</strong>. For quantities &gt; 10, a doctor prescription is required.
          </div>
          <form method="post" action="${pageContext.request.contextPath}/refills">
            <input type="hidden" name="action" value="submit_otc">
            <div style="display: flex; gap: 10px; margin-bottom: 12px;">
              <div style="flex: 2;">
                <label for="otcMedicine" style="font-weight: 600; display: block; font-size: 13px; margin-bottom: 6px;">Select Common Medicine:</label>
                <select name="otcMedicine" id="otcMedicine" style="width: 100%;" required>
                  <option value="Paracetamol 500 mg (Pain & Fever)">Paracetamol 500 mg (Pain & Fever)</option>
                  <option value="Ibuprofen 200 mg (Pain Relief)">Ibuprofen 200 mg (Pain Relief)</option>
                  <option value="Cetirizine 10 mg (Allergy & Cold)">Cetirizine 10 mg (Allergy & Cold)</option>
                  <option value="Antacid Gel / Chewable Tablets (Acidity)">Antacid Gel / Chewable Tablets (Acidity)</option>
                  <option value="ORS Electrolyte Hydration Pack">ORS Electrolyte Hydration Pack</option>
                  <option value="Throat Lozenges (Cough/Throat Relief)">Throat Lozenges (Cough/Throat Relief)</option>
                </select>
              </div>
              <div style="flex: 1; max-width: 100px;">
                <label for="quantity" style="font-weight: 600; display: block; font-size: 13px; margin-bottom: 6px;">Qty (Max 10):</label>
                <input type="number" name="quantity" id="quantity" min="1" max="10" value="10" style="width: 100%; box-sizing: border-box;" required>
              </div>
            </div>
            <button class="btn btn-otc" type="submit">Submit OTC Demand</button>
          </form>
        </div>

      </div>

      <h2>My Refill & Medicine Requests</h2>
    </c:otherwise>
  </c:choose>

  <!-- TABLE OF REQUESTS -->
  <table>
    <thead>
      <tr>
        <th>#</th>
        <th>Patient</th>
        <th>Medicine / Type</th>
        <th>Requested</th>
        <th>Status</th>
        <th>Pharmacist Action / Notes</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="r" items="${requests}">
        <tr>
          <td><c:out value="${r.requestId}"/></td>
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
              <div class="reason-text">Reason: <c:out value="${r.rejectionReason}"/></div>
            </c:if>
          </td>
          <td>
            <c:if test="${sessionScope.role == 'PHARMACIST'}">
              <c:if test="${r.status == 'PENDING'}">
                <form class="inline" method="post" action="${pageContext.request.contextPath}/refills">
                  <input type="hidden" name="action" value="approve">
                  <input type="hidden" name="requestId" value="${r.requestId}">
                  <button class="btn btn-approve" type="submit">Approve</button>
                </form>

                <!-- Rejection with mandatory reason input -->
                <form class="inline" method="post" action="${pageContext.request.contextPath}/refills" style="margin-left: 8px;">
                  <input type="hidden" name="action" value="reject">
                  <input type="hidden" name="requestId" value="${r.requestId}">
                  <input type="text" name="reason" placeholder="Enter reason to reject..." style="width: 170px; padding: 5px 8px; font-size: 12px;" required>
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

            <c:if test="${sessionScope.role == 'PATIENT'}">
              <c:choose>
                <c:when test="${r.status == 'PENDING'}"><span style="color: #d97706; font-size: 13px;">Reviewing</span></c:when>
                <c:when test="${r.status == 'APPROVED'}"><span style="color: #16a34a; font-weight: 600; font-size: 13px;">Ready for Pickup!</span></c:when>
                <c:when test="${r.status == 'COLLECTED'}"><span style="color: #2563eb; font-size: 13px;">Collected</span></c:when>
                <c:when test="${r.status == 'REJECTED'}"><span style="color: #dc2626; font-size: 13px;">Contact Doctor/Pharmacy</span></c:when>
              </c:choose>
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
