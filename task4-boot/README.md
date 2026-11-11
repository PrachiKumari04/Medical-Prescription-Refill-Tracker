# Task 4: RESTful Microservice using Spring Boot

## Environment
- Java: OpenJDK 17 / Oracle JDK 21
- Framework: Spring Boot 3.3.4 (Spring Web, Spring Data JPA, Bean Validation, Spring Boot Actuator)
- Database: MySQL 8.0 (refill_db)

## How to Build and Run
```powershell
Set-Location "d:\MCA\sem 3\java\RefilTracker\task4-boot"
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" spring-boot:run
```
Or package as executable JAR:
```powershell
mvn clean package
java -jar target/refill-service.jar
```
Service runs on port `8080`.
Actuator Health Endpoint: `http://localhost:8080/actuator/health`

## How to Run Automated Tests
Before running tests, ensure `sql/data.sql` is refreshed:
```powershell
Get-Content ..\sql\data.sql | & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" test
```

## Postman Collection
Import `postman/Refill_Tracker.postman_collection.json` into Postman. It covers test cases:
1. `T4.1` - `POST /api/refills` with `{"patientId":4,"prescriptionId":5}` -> **201 Created** with `Location: /api/refills/10`
2. `T4.2` - Duplicate `POST` -> **409 Conflict** ("A refill request for this prescription is already pending")
3. `T4.3` - `POST` with empty body `{}` -> **400 Bad Request** with `fieldErrors`
4. `T4.4` - `PATCH /api/refills/2/approve` -> **200 OK** (status APPROVED), then `PATCH /api/refills/2/collect` -> **200 OK** (status COLLECTED)
5. `T4.5` - `PATCH /api/refills/3/approve` (prescription 2 has 3 of 3 used) -> **409 Conflict** ("No refills remaining")
6. `T4.6` - `GET /api/refills/99` -> **404 Not Found** with uniform JSON error payload

## Microservices Architecture Position
- Owns solely the refill lifecycle and refill counter state.
- In a full microservices architecture, integrates with:
  - **Patient Service** (owns patient demographics)
  - **Prescription Service** (owns clinical prescriptions)
  - **Identity / Auth Service** (JWT issuance and RBAC)
  - **Notification Service** (asynchronous event consumption for SMS/Email notifications)
- Central Exception Handling implemented via `@RestControllerAdvice` emitting standardized `ApiError` JSON responses.

