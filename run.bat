@echo off
title Medical Prescription Refill Tracker - Master Launcher
:MENU
cls
echo ===============================================================================
echo            MEDICAL PRESCRIPTION REFILL TRACKER - MCA SEM III
echo                     Course: 24MCAC302 - Advance Java
echo ===============================================================================
echo.
echo   [1] Task 1: Run JDBC Data Access Layer Demo (HikariCP, Transactions, Batch)
echo   [2] Task 2: Launch Servlets + JSP Web Portal (Tomcat port 8080)
echo   [3] Task 3: Launch Spring MVC + JPA Module (Tomcat port 8082)
echo   [4] Task 4: Launch Spring Boot REST Microservice (Port 8080)
echo   [5] Task 4: Run Automated REST Test Suite (Tests T4.1 - T4.6)
echo   [6] Task 5: Run Hibernate HQL, Criteria Reports & Cache Demo
echo   [7] Database: Reset MySQL Seed Data (sql\data.sql)
echo   [8] Git: View Commits & Tags (task1 - task5)
echo   [9] Open GitHub Repository in Browser
echo   [0] Exit
echo.
echo ===============================================================================
set /p choice="Enter your choice [0-9]: "

if "%choice%"=="1" goto TASK1
if "%choice%"=="2" goto TASK2
if "%choice%"=="3" goto TASK3
if "%choice%"=="4" goto TASK4
if "%choice%"=="5" goto TASK4_TEST
if "%choice%"=="6" goto TASK5
if "%choice%"=="7" goto RESET_DB
if "%choice%"=="8" goto GIT_LOG
if "%choice%"=="9" goto GITHUB
if "%choice%"=="0" goto EXIT
goto MENU

:TASK1
cls
echo -------------------------------------------------------------------------------
echo Running Task 1: JDBC Data Access Layer Demonstration...
echo -------------------------------------------------------------------------------
cd task1-jdbc
call D:\tools\apache-maven-3.9.9\bin\mvn.cmd compile exec:java -Dexec.mainClass="com.refill.DemoMain"
cd ..
echo.
pause
goto MENU

:TASK2
cls
echo -------------------------------------------------------------------------------
echo Starting Task 2: Jakarta Servlets + JSP Web Portal on http://localhost:8080/login
echo Press Ctrl+C in this window to stop the server when done.
echo -------------------------------------------------------------------------------
cd task2-web
call D:\tools\apache-maven-3.9.9\bin\mvn.cmd exec:java
cd ..
echo.
pause
goto MENU

:TASK3
cls
echo -------------------------------------------------------------------------------
echo Starting Task 3: Spring MVC + JPA on http://localhost:8082/pharmacist/refills
echo Press Ctrl+C in this window to stop the server when done.
echo -------------------------------------------------------------------------------
cd task3-spring-mvc
call D:\tools\apache-maven-3.9.9\bin\mvn.cmd exec:java
cd ..
echo.
pause
goto MENU

:TASK4
cls
echo -------------------------------------------------------------------------------
echo Starting Task 4: Spring Boot REST Microservice on http://localhost:8080/api/refills
echo Actuator Health: http://localhost:8080/actuator/health
echo Press Ctrl+C in this window to stop the server when done.
echo -------------------------------------------------------------------------------
cd task4-boot
call D:\tools\apache-maven-3.9.9\bin\mvn.cmd spring-boot:run
cd ..
echo.
pause
goto MENU

:TASK4_TEST
cls
echo -------------------------------------------------------------------------------
echo Running Task 4 Automated Test Suite (T4.1 to T4.6)...
echo -------------------------------------------------------------------------------
powershell -Command "Get-Content 'sql\data.sql' | & 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe' -u root -proot"
cd task4-boot
call D:\tools\apache-maven-3.9.9\bin\mvn.cmd test
cd ..
echo.
pause
goto MENU

:TASK5
cls
echo -------------------------------------------------------------------------------
echo Running Task 5: Hibernate 6 Core Reports & Cache Evaluation...
echo -------------------------------------------------------------------------------
powershell -Command "Get-Content 'sql\data.sql' | & 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe' -u root -proot"
cd task5-hibernate
echo === Running HQL & Criteria API Reports ===
call D:\tools\apache-maven-3.9.9\bin\mvn.cmd compile exec:java -Dexec.mainClass="com.refill.hibernate.ReportDemo"
echo.
echo === Running Ehcache 3 Second-Level Cache Demo ===
call D:\tools\apache-maven-3.9.9\bin\mvn.cmd exec:java -Dexec.mainClass="com.refill.hibernate.CacheDemo"
cd ..
echo.
pause
goto MENU

:RESET_DB
cls
echo -------------------------------------------------------------------------------
echo Restoring MySQL Database Seed Data...
echo -------------------------------------------------------------------------------
powershell -Command "Get-Content 'sql\schema.sql' | & 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe' -u root -proot; Get-Content 'sql\data.sql' | & 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe' -u root -proot"
echo Database reset successfully to initial state!
echo.
pause
goto MENU

:GIT_LOG
cls
echo -------------------------------------------------------------------------------
echo Git Commit History and Milestone Tags:
echo -------------------------------------------------------------------------------
git log --oneline --decorate --tags
echo.
pause
goto MENU

:GITHUB
start https://github.com/PrachiKumari04/Medical-Prescription-Refill-Tracker
goto MENU

:EXIT
exit /b

