@echo off
title View Refill Database (refill_db)
cls
echo ===============================================================================
echo                CURRENT DATABASE TABLES AND RECORDS (refill_db)
echo ===============================================================================
echo.
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -e "USE refill_db; SELECT '=== PATIENTS ===' AS ''; SELECT * FROM patient; SELECT '=== PRESCRIPTIONS ===' AS ''; SELECT * FROM prescription; SELECT '=== REFILL REQUESTS ===' AS ''; SELECT * FROM refill_request; SELECT '=== APP USERS ===' AS ''; SELECT user_id, username, role, patient_id FROM app_user;"
echo.
echo ===============================================================================
pause

