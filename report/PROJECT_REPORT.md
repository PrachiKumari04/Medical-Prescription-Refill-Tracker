# MCA PROGRAMME
**Course:** 24MCAC302 - Advance Java Programming  
**MINI-PROJECT REPORT**  
**Title:** Medical Prescription Refill Tracker: Design, Implementation and Deployment using Advanced Java  
**Submitted in partial fulfilment of the continuous assessment component of the MCA programme, Semester III**  

**Submitted by:** [Student Name]  
**Roll No.:** [Roll Number]  
**Under the guidance of:** Dr. Netra Patil, MCA Department, COM&CA, MIT-ADT University, Pune  
**Academic Year:** 2026 - 2027  

---

## CERTIFICATE
This is to certify that the mini-project report entitled **"Medical Prescription Refill Tracker: Design, Implementation and Deployment using Advanced Java"** is a bonafide record of the work carried out by **[Student Name]**, Roll No. **[Roll Number]**, in partial fulfilment of the continuous assessment component of the MCA programme, Semester III, during the academic year 2026-2027.

The work has been carried out under my guidance, and all five tasks of the assignment (JDBC, Servlets and JSP, JPA and Spring MVC, Spring Boot, Hibernate) have been completed and demonstrated.

**Dr. Netra Patil**  
Professor, COM&CA, MIT-ADT University  
Date: ____________ Place: Pune  

---

## DECLARATION
I hereby declare that the mini-project report entitled **"Medical Prescription Refill Tracker: Design, Implementation and Deployment using Advanced Java"** submitted to the MCA Department is my own work. The design, source code and written analysis are original, libraries and documentation have been used only as references and are listed in the References section. This work has not been submitted earlier to any other institution or for any other course.

Date: ____________ Place: Pune  
**[Student Name]**  
Roll No.: [Roll Number]  

---

## ABSTRACT
This report presents the design, implementation and deployment of a Medical Prescription Refill Tracker built with Advanced Java technologies. A patient submits a refill request against an existing prescription; a pharmacist approves or rejects it; and the system records the lifecycle of every request as PENDING, then APPROVED or REJECTED, and finally COLLECTED. The same module and the same four-table MySQL database (`refill_db`) are implemented five times, once in the technology of each syllabus unit: JDBC with HikariCP, Servlets and JSP, JPA with Spring MVC, Spring Boot REST, and core Hibernate with HQL, the Criteria API and a second-level cache.

The work demonstrates connection pooling, PreparedStatement and batch processing; transactions that approve a request and increment the refill counter atomically, with rollback when no refills remain; session management, a security filter and Post-Redirect-Get; entity mapping, JPQL, constructor dependency injection and server-side validation; REST endpoints with correct status codes and central JSON error handling; and an evidence-based caching decision. A comparison of JDBC and JPA and a microservices note support the analysis.

**Keywords:** JDBC, Servlet, JSP, JPA, Spring MVC, Spring Boot, REST, Hibernate, HQL, Criteria API, Ehcache, MySQL.

---

## 1. Introduction

### 1.1 Background and Motivation
Patients who take medicines for long-term conditions such as diabetes, hypertension, thyroid disorders or asthma do not receive their whole supply at once. A prescription normally authorises a fixed number of refills, and every time the medicine runs out the patient must ask the pharmacy for the next one. In many pharmacies this process is still manual: the patient telephones or visits the counter, the pharmacist looks up a paper register to find the prescription, checks by hand how many refills have already been used, and writes the decision in the same register. The patient has no way of knowing whether the request has been approved, and the pharmacy has no reliable record of how many refills of a prescription have been consumed.

A Medical Prescription Refill Tracker removes these steps. The patient submits a request against one of his or her prescriptions from a browser; the pharmacist sees all pending requests in one list and approves or rejects each of them; and when the medicine is handed over the request is marked as collected. The server keeps the refill counter of every prescription, so that a prescription can never be refilled more often than it was authorised.

The tracker is also a suitable vehicle for learning Advance Java Programming (24MCAC302). It combines transactional behaviour (approving a request and incrementing the refill counter must succeed or fail together), security requirements (only authenticated users may see requests, and only a pharmacist may approve them) and read-heavy behaviour (patient and prescription data are read far more often than they change), which makes it a natural subject for caching decisions. This report describes one module, the Medical Prescription Refill Tracker, built five times, once in the technology introduced in each unit of the syllabus.

### 1.2 Problem Statement
To design, develop and deploy a Medical Prescription Refill Tracker that allows a patient to log in and request a refill of one of his or her prescriptions, allows a pharmacist to approve or reject pending requests, and tracks every request through the lifecycle PENDING, APPROVED or REJECTED, and COLLECTED. The system must update the refill counter of the prescription atomically with the approval, must refuse requests that break the business rules, and must provide reports such as approved refills per patient. The same four-table MySQL database (`refill_db`) must be used by every implementation, so that the reader can compare JDBC, Servlets/JSP, JPA with Spring MVC, Spring Boot and core Hibernate on identical requirements.

### 1.3 Objectives
- To apply JDBC (connection pooling, PreparedStatement, batch processing and transactions) to build the data-access layer of the module.
- To apply Servlets, JSP, sessions and filters to build a secured, session-aware portal for patients and pharmacists.
- To analyse how JPA entity mapping, Spring IoC/Dependency Injection and Spring MVC validation restructure the JDBC application.
- To design and test RESTful endpoints with Spring Boot, including status codes, central exception handling and the position of the service in a microservices architecture.
- To evaluate persistence choices in core Hibernate (HQL versus Criteria API, first- versus second-level cache) and justify them with evidence.

---

## 2. System Analysis and Requirements

### 2.1 Existing Manual Process vs. Proposed System

| Aspect | Existing (Manual) | Proposed (Online System) |
| :--- | :--- | :--- |
| **Submitting a request** | Telephone call or visit to counter | Patient logs in and submits online against own prescription |
| **Checking refills left** | Pharmacist counts in paper book | Server checks `refills_used` vs `total_refills` automatically |
| **Approval** | Verbal or handwritten decision | Pharmacist approves/rejects; refill counter updated atomically |
| **Status visibility** | Patient must call or visit | Patient views live status (PENDING, APPROVED, REJECTED, COLLECTED) |
| **Duplicate requests** | Easily duplicated and missed | System rejects duplicate pending request per prescription |
| **Reporting** | Paper loose slips; rarely prepared | Dynamic criteria search and HQL aggregation reports |

---

## 3. System Design & Database Model

### 3.1 Entity Relationship Model
- **`patient`** (1) ──── (N) **`prescription`**
- **`prescription`** (1) ──── (N) **`refill_request`**
- **`patient`** (1) ──── (1) **`app_user`** (for PATIENT role; null for PHARMACIST)

```
+--------------------+       +-----------------------------+       +-----------------------------+
|      PATIENT       |       |        PRESCRIPTION         |       |       REFILL_REQUEST        |
+--------------------+       +-----------------------------+       +-----------------------------+
| PK patient_id      | 1   N | PK prescription_id          | 1   N | PK request_id               |
|    name            |<------| FK patient_id               |<------| FK prescription_id          |
|    phone           |       |    medicine_name            |       |    request_date             |
+--------------------+       |    dosage                   |       |    status (ENUM)            |
         ^                   |    total_refills            |       +-----------------------------+
         |                   |    refills_used             |
         |                   +-----------------------------+
         | 1
         | 1 (Optional)
+--------------------+
|      APP_USER      |
+--------------------+
| PK user_id         |
|    username        |
|    password_hash   |
|    role (ENUM)     |
| FK patient_id      |
+--------------------+
```

---

## 4. Summary of the Five Progressive Implementations

### Task 1: JDBC Data Access Layer (`task1-jdbc`)
- **Connection Pooling**: HikariCP maintains active connections with cached PreparedStatements.
- **Transactions**: `setAutoCommit(false)` with `SELECT ... FOR UPDATE` row-level pessimistic locking.
- **Atomic Operations**: Request status and prescription refill counters increment together or roll back on error.
- **Batch Processing**: Multiple requests inserted in a single round-trip via `executeBatch()`.

### Task 2: Servlets & JSP Web Portal (`task2-web`)
- **Session Security**: Session fixation defense via `session.invalidate()` and `session.setMaxInactiveInterval(1800)`.
- **AuthFilter**: Intercepts unauthenticated users; enforces Role-Based Access Control (RBAC).
- **Pattern**: Post-Redirect-Get (PRG) with session flash messages to avoid form resubmission.

### Task 3: JPA & Spring MVC Module (`task3-spring-mvc`)
- **Declarative ORM**: Entity mapping with `@ManyToOne(fetch = LAZY)` and `@OneToMany`.
- **JPQL with Join Fetch**: Solves N+1 and `LazyInitializationException`.
- **Dirty Checking**: `@Transactional` on service methods flushes SQL UPDATEs automatically without explicit save calls.
- **Bean Validation**: Form validation using `@Valid`, `@NotNull`, `@Min(1)`, and `@PastOrPresent`.

### Task 4: Spring Boot REST Microservice (`task4-boot`)
- **Spring Data JPA**: Repository interfaces replacing boilerplate DAO classes.
- **REST Semantics**: `POST /api/refills` (201 Created), `PATCH /api/refills/{id}/approve` (200 OK), `GET /api/refills/99` (404 Not Found), duplicate requests (409 Conflict).
- **Central Handling**: `@RestControllerAdvice` emitting standardized `ApiError` JSON payloads.
- **Microservices Fit**: Decouples refill logic from user/prescription authority services; ready for Docker/Kubernetes deployment.

### Task 5: Hibernate Core, Reports & L2 Caching (`task5-hibernate`)
- **Hibernate Core**: Low-level `SessionFactory`, `Session`, and programmatic transaction demarcation.
- **HQL Aggregations**: `GROUP BY` and `HAVING count(r) >= :min` report of approved refills per patient.
- **Criteria API**: Type-safe dynamic multi-filter queries producing immutable `RefillRow` records.
- **Ehcache 3 L2 Cache**: Proves cache performance with evidence: 3 sessions reading reference entities result in **1 SQL statement**, **2 L2 cache hits**, and **0 redundant database calls**.

---

## 5. References
1. Basham, B., Sierra, K. & Bates, B., *Head First Servlets and JSP*, O'Reilly.
2. Walls, C., *Spring Boot in Action*, Manning Publications.
3. Cosmina, I. et al., *Pro Spring 5: An In-Depth Guide to the Spring Framework*, Apress.
4. Bauer, C., King, G. & Gregory, G., *Java Persistence with Hibernate*, Manning Publications.
5. Oracle Corporation, *The Java Tutorials - JDBC Database Access* (docs.oracle.com/javase/tutorial).

