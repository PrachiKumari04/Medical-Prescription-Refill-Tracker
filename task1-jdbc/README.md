# Task 1: Refill Data Access Layer using JDBC

## Environment
- Java: OpenJDK 17 / Oracle JDK 21
- Build Tool: Apache Maven 3.9.9
- Database: MySQL 8.0 (refill_db)
- Driver: mysql-connector-j 8.4.0
- Connection Pool: HikariCP 5.1.0

## Database Setup
Ensure MySQL is running on `localhost:3306` with user `root` and password `root`.
Reset the database schema and sample data before running the demo:
```powershell
Get-Content ..\sql\schema.sql | & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot
Get-Content ..\sql\data.sql | & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot
```

## How to Build and Run
```powershell
mvn clean compile
mvn exec:java -Dexec.mainClass="com.refill.DemoMain"
```
Or with custom database credentials:
```powershell
mvn exec:java -Dexec.mainClass="com.refill.DemoMain" -Ddb.url="jdbc:mysql://localhost:3306/refill_db?useSSL=false&serverTimezone=Asia/Kolkata&allowPublicKeyRetrieval=true" -Ddb.user="root" -Ddb.password="root"
```

## Key Concepts Demonstrated
1. **HikariCP Connection Pooling (`DbUtil`)**: Configured with max pool size 10, min idle 2, connection timeout 10s, and prepared statement caching.
2. **PreparedStatements**: Parameterized queries preventing SQL injection across all CRUD and search queries.
3. **Atomic Transactions (`approve`)**: Disables auto-commit (`c.setAutoCommit(false)`), locks the target row using `SELECT ... FOR UPDATE`, checks available refills, increments `refills_used` and sets status to `APPROVED`. Commits atomically or rolls back on failure (`c.rollback()`).
4. **Batch Processing (`insertBatch`)**: Groups multiple `INSERT` statements using `ps.addBatch()` and executes them in a single round-trip using `ps.executeBatch()` within a single transaction.
5. **Lifecycle Operations**: Demonstrates status transitions (`PENDING` -> `APPROVED` -> `COLLECTED` or `PENDING` -> `REJECTED`) and deletion.

