# Medical Prescription Refill Tracker

**Course:** 24MCAC302 - Advance Java Programming  
**Programme:** Master of Computer Applications (MCA), Semester III  
**Institution:** MIT-ADT University, Pune  

---

## 📌 Project Overview
The **Medical Prescription Refill Tracker** is an enterprise-grade medical refill management system developed across five stages of Advanced Java:
1. **Task 1: Refill Data Access Layer using JDBC & HikariCP** (Connection pooling, PreparedStatement, batch execution, atomic transaction commit/rollback).
2. **Task 2: Patient/Pharmacist Portal using Jakarta Servlets and JSP** (Session management, security filter `AuthFilter`, PRG pattern, JSTL views).
3. **Task 3: ORM-Based Module using JPA and Spring MVC** (Entity associations, JPQL with join fetch, Spring IoC, declarative `@Transactional`, Bean Validation).
4. **Task 4: RESTful Microservice using Spring Boot** (Spring Data JPA, REST endpoints with PATCH status transitions, central `@RestControllerAdvice` error handling, Actuator).
5. **Task 5: Hibernate 6 Core, HQL, Criteria API and Caching** (SessionFactory, HQL aggregations, Criteria API dynamic query builder, L1 & Ehcache 3 L2 cache evaluation).

---

## 🗄️ Database Setup (MySQL 8.0)
The application relies on a shared relational database `refill_db`.
Ensure MySQL 8.0 is running on `localhost:3306` with user `root` and password `root`.

Initialize or reset schema and initial test data:
```powershell
Get-Content "sql\schema.sql" | & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot
Get-Content "sql\data.sql"   | & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot
```

### Test Accounts
- **Pharmacist:** `username: pharma1`, `password: pharma123`
- **Patient:** `username: ravi`, `password: patient123` (also `sneha`, `amit`, `priya`)

---

## 🚀 How to Build and Run Each Stage

### 1. Build All Modules
From the root directory:
```powershell
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" clean package -DskipTests
```

### 2. Task 1: JDBC Console Demonstration
```powershell
Set-Location "task1-jdbc"
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" compile exec:java -Dexec.mainClass="com.refill.DemoMain"
```

### 3. Task 2: Jakarta Servlets & JSP Web Portal
```powershell
Set-Location "task2-web"
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" clean compile exec:java
```
Access at: `http://localhost:8080/login`

### 4. Task 3: Spring MVC & JPA Module
```powershell
Set-Location "task3-spring-mvc"
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" clean compile exec:java
```
Access at:
- Pharmacist Dashboard: `http://localhost:8082/pharmacist/refills`
- Patient Dashboard: `http://localhost:8082/patients/1/refills`

### 5. Task 4: Spring Boot REST Microservice
```powershell
Set-Location "task4-boot"
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" spring-boot:run
```
Access at: `http://localhost:8080/api/refills`  
Health check: `http://localhost:8080/actuator/health`  
Automated test suite (T4.1 to T4.6):
```powershell
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" test
```

### 6. Task 5: Hibernate HQL, Criteria API & L2 Caching
```powershell
Set-Location "task5-hibernate"
# Run HQL and Criteria API Reports:
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" compile exec:java -Dexec.mainClass="com.refill.hibernate.ReportDemo"

# Run Second-Level Cache Demonstration:
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" exec:java -Dexec.mainClass="com.refill.hibernate.CacheDemo"
```

---

## 📁 Repository Structure
```
RefilTracker/
├── pom.xml                     # Multi-module root aggregator POM
├── README.md                   # Complete repository documentation
├── sql/
│   ├── schema.sql              # MySQL DDL (4 tables with constraints)
│   └── data.sql                # Seed data (patients, prescriptions, requests, users)
├── task1-jdbc/                 # Task 1: JDBC, HikariCP, PreparedStatement, Transactions
├── task2-web/                  # Task 2: Jakarta Servlet 6, JSP, JSTL, AuthFilter, PRG
├── task3-spring-mvc/           # Task 3: JPA Entities, JPQL, Spring MVC, Bean Validation
├── task4-boot/                 # Task 4: Spring Boot 3.3 REST microservice & Postman collection
├── task5-hibernate/            # Task 5: Core Hibernate 6, HQL, Criteria API, Ehcache 3 L2
└── report/                     # Academic Report documentation
```
