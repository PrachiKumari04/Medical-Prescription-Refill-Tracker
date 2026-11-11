# Task 5: Hibernate, HQL, Criteria API and Caching

## Environment
- Java: OpenJDK 17 / Oracle JDK 21
- ORM: Hibernate 6.5.2.Final (core SessionFactory & Session)
- Second-Level Cache: Ehcache 3.10.8 via JCache (JSR-107) Region Factory
- Database: MySQL 8.0 (refill_db)

## How to Build and Run
Before running, refresh sample data in MySQL:
```powershell
Get-Content ..\sql\data.sql | & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot
```

### 1. Run HQL & Criteria API Reports (`ReportDemo`)
```powershell
Set-Location "d:\MCA\sem 3\java\RefilTracker\task5-hibernate"
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" compile exec:java -Dexec.mainClass="com.refill.hibernate.ReportDemo"
```

### 2. Run Second-Level Cache Demonstration (`CacheDemo`)
```powershell
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" exec:java -Dexec.mainClass="com.refill.hibernate.CacheDemo"
```

## Expected Results
- **ReportDemo**:
  - HQL aggregation `approvedPerPatient(1)`: Groups by patient name, counts approved/collected refills, filters with `HAVING count(r) >= 1`.
  - Criteria API `search()`: Dynamic type-safe multi-condition query returning strongly typed `RefillRow` records.
- **CacheDemo**:
  - Session 1: Performs initial SQL `SELECT`, caches entity in L1 and puts into L2 cache (`puts: 1`).
  - Session 2 & Session 3: New sessions miss L1 but hit L2 cache (`hits: 2`, `SQL prepared: 1`).

