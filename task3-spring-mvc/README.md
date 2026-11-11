# Task 3: ORM-Based Module using JPA and Spring MVC

## Environment
- Java: OpenJDK 17 / Oracle JDK 21
- Frameworks: Spring Framework 6.1.10, Hibernate 6.5.2.Final, Jakarta Validation 3.0
- Application Server: Apache Tomcat 10.1+ (or embedded Tomcat 10.1.25)
- Database: MySQL 8.0 (refill_db)

## How to Build and Run

### Option A: Embedded Tomcat (Port 8082)
```powershell
Set-Location "d:\MCA\sem 3\java\RefilTracker\task3-spring-mvc"
& "D:\tools\apache-maven-3.9.9\bin\mvn.cmd" clean compile exec:java
```
Endpoints:
- Pharmacist Dashboard: `http://localhost:8082/pharmacist/refills`
- Patient 1 Refills: `http://localhost:8082/patients/1/refills`
- Patient 2 Refills: `http://localhost:8082/patients/2/refills`

### Option B: Deploy WAR to External Tomcat 10.1
1. Package the WAR:
   ```powershell
   mvn clean package
   ```
2. Deploy `target/refill-mvc.war` into Tomcat `webapps/`.
3. Access at: `http://localhost:8080/refill-mvc/pharmacist/refills`

## Key Concepts Demonstrated
1. **JPA Entity Mapping**:
   - `@Entity` mapping with `@Table`
   - `@OneToMany` and `@ManyToOne(fetch = FetchType.LAZY)`
   - `@Enumerated(EnumType.STRING)`
   - Encapsulated business method `prescription.consumeRefill()`
2. **JPQL and Repository Layer**:
   - `EntityManager` with `@PersistenceContext`
   - Explicit `join fetch` preventing the N+1 SELECT problem and `LazyInitializationException`
   - Aggregations with `GROUP BY`
3. **Spring IoC & Dependency Injection**:
   - Constructor-based injection across Controller, Service, and Repository
   - Java Config (`WebInit`, `WebConfig`, `PersistenceConfig`) completely replacing XML
4. **Declarative Transactions (`@Transactional`)**:
   - Dirty checking: modifications to managed entities (`consumeRefill()`, `setStatus()`) are automatically converted to SQL UPDATE statements upon transaction commit.
   - Automatic rollback on unchecked exceptions (`BusinessRuleException`).
5. **Server-Side Validation**:
   - `@Valid` and JSR-380 annotations (`@NotNull`, `@Min`, `@PastOrPresent`) on `RefillForm`
   - Error feedback presented in view via Spring `BindingResult`

