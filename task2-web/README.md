# Task 2: Patient/Pharmacist Portal using Servlets and JSP

## Environment
- Java: OpenJDK 17 / Oracle JDK 21
- Web Specification: Jakarta Servlet 6.0, Jakarta Server Pages (JSP) 3.1, JSTL 3.0
- Application Server: Apache Tomcat 10.1+ (or embedded Tomcat 10.1.25)
- Database: MySQL 8.0 (refill_db)

## How to Build and Run

### Option A: Embedded Tomcat (Zero-Setup, One Command)
```powershell
Set-Location "d:\MCA\sem 3\java\RefilTracker\task2-web"
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" clean compile exec:java
```
Then open your browser and navigate to:
`http://localhost:8080/login`

### Option B: Deploy to External Tomcat 10.1
1. Package the WAR:
   ```powershell
   mvn clean package
   ```
2. Copy `target/refills.war` into Tomcat's `webapps/` folder.
3. Access at: `http://localhost:8080/refills/login`

## Test Credentials
- **Pharmacist**: username `pharma1`, password `pharma123`
- **Patient**: username `ravi`, password `patient123` (also `sneha`, `amit`, `priya`)

## Architecture and Key Concepts
1. **Jakarta Servlets**:
   - `LoginServlet` (`/login`, `/logout`): Authenticates SHA-256 hashed password against `app_user`. Invalidates existing session to prevent Session Fixation, creates a new session with 30-min timeout.
   - `RefillRequestServlet` (`/refills`): Implements Post-Redirect-Get (PRG) pattern with flash attributes in session.
2. **Security & Session Management (`AuthFilter`)**:
   - WebFilter mapped to `/*`.
   - Protects unauthorized access by redirecting unauthenticated requests to `/login`.
   - Prevents caching of secured responses via `Cache-Control: no-store`.
   - Role-Based Access Control (RBAC): Restricts `approve`, `reject`, `collect` actions exclusively to `PHARMACIST` and returns HTTP 403 Forbidden if a patient attempts them.
3. **Views**:
   - `login.jsp`: Clean login form with error feedback and demo credentials display.
   - `refills.jsp`: Role-aware UI rendering with JSTL (`<c:choose>`, `<c:if>`, `<c:forEach>`) and `<c:out>` for XSS defense. Shows patient refill request dropdown and history, or pharmacist review/action table.

