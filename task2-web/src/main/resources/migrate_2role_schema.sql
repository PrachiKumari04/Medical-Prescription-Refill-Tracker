-- Migration Script: Refill Medicine Tracker Adherence & Exhaustion Engine (2-Role Model)

USE refill_db;

-- 1. Add Adherence and Exhaustion Tracking columns to prescription table (if not exists)
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
                   WHERE TABLE_SCHEMA = 'refill_db' AND TABLE_NAME = 'prescription' AND COLUMN_NAME = 'daily_dose');

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE prescription 
        ADD COLUMN daily_dose INT NOT NULL DEFAULT 1 AFTER dosage,
        ADD COLUMN total_quantity INT NOT NULL DEFAULT 30 AFTER daily_dose,
        ADD COLUMN dispensed_date DATE NOT NULL DEFAULT (CURRENT_DATE) AFTER total_quantity,
        ADD COLUMN days_of_supply INT NOT NULL DEFAULT 30 AFTER dispensed_date,
        ADD COLUMN exhaustion_date DATE NOT NULL DEFAULT (CURRENT_DATE + INTERVAL 30 DAY) AFTER days_of_supply,
        ADD COLUMN status ENUM(\'ACTIVE\', \'COMPLETED\', \'DISCONTINUED\') DEFAULT \'ACTIVE\' AFTER exhaustion_date', 
    'SELECT "Columns already exist"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. Create Refill Alerts table
CREATE TABLE IF NOT EXISTS refill_alert (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    patient_id INT NOT NULL,
    alert_date DATE NOT NULL,
    message VARCHAR(255) NOT NULL,
    status ENUM('PENDING', 'SENT', 'ACKNOWLEDGED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_alert_rx FOREIGN KEY (prescription_id) REFERENCES prescription(prescription_id) ON DELETE CASCADE,
    CONSTRAINT fk_alert_patient FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE CASCADE
);

-- 3. Populate realistic adherence data for existing chronic prescriptions
-- Prescription 1: Ravi Kulkarni - Metformin 500mg (2 tabs/day, 60 tabs, dispensed 26 days ago -> 4 DAYS LEFT: REFILL DUE!)
UPDATE prescription 
SET daily_dose = 2,
    total_quantity = 60,
    dispensed_date = DATE_SUB(CURRENT_DATE, INTERVAL 26 DAY),
    days_of_supply = 30,
    exhaustion_date = DATE_ADD(DATE_SUB(CURRENT_DATE, INTERVAL 26 DAY), INTERVAL 30 DAY),
    status = 'ACTIVE'
WHERE prescription_id = 1;

-- Prescription 5: Priya Patil - Salbutamol Inhaler (1 puff/day, 30 doses, dispensed 28 days ago -> 2 DAYS LEFT: CRITICAL REFILL DUE!)
UPDATE prescription 
SET daily_dose = 1,
    total_quantity = 30,
    dispensed_date = DATE_SUB(CURRENT_DATE, INTERVAL 28 DAY),
    days_of_supply = 30,
    exhaustion_date = DATE_ADD(DATE_SUB(CURRENT_DATE, INTERVAL 28 DAY), INTERVAL 30 DAY),
    status = 'ACTIVE'
WHERE prescription_id = 5;

-- Prescription 6: Prachi Kumari - Amoxicillin 500 mg (2 caps/day, 20 caps, dispensed 2 days ago -> 8 DAYS LEFT: SAFE!)
UPDATE prescription 
SET daily_dose = 2,
    total_quantity = 20,
    dispensed_date = DATE_SUB(CURRENT_DATE, INTERVAL 2 DAY),
    days_of_supply = 10,
    exhaustion_date = DATE_ADD(DATE_SUB(CURRENT_DATE, INTERVAL 2 DAY), INTERVAL 10 DAY),
    status = 'ACTIVE'
WHERE prescription_id = 6;

-- Prescription 3: Sneha Joshi - Atorvastatin 10 mg (1 tab/day, 30 tabs, dispensed 15 days ago -> 15 DAYS LEFT: SAFE!)
UPDATE prescription 
SET daily_dose = 1,
    total_quantity = 30,
    dispensed_date = DATE_SUB(CURRENT_DATE, INTERVAL 15 DAY),
    days_of_supply = 30,
    exhaustion_date = DATE_ADD(DATE_SUB(CURRENT_DATE, INTERVAL 15 DAY), INTERVAL 30 DAY),
    status = 'ACTIVE'
WHERE prescription_id = 3;

-- 4. Insert automated refill alerts for due prescriptions (Ravi & Priya)
INSERT INTO refill_alert (prescription_id, patient_id, alert_date, message, status)
SELECT 1, 1, CURRENT_DATE, 'Alert: Your Metformin 500mg supply ends in 4 days! Click to request your next 30-day refill.', 'SENT'
WHERE NOT EXISTS (SELECT 1 FROM refill_alert WHERE prescription_id = 1 AND patient_id = 1);

INSERT INTO refill_alert (prescription_id, patient_id, alert_date, message, status)
SELECT 5, 4, CURRENT_DATE, 'Urgent: Your Salbutamol Inhaler supply ends in 2 days! Refill required to avoid therapy disruption.', 'SENT'
WHERE NOT EXISTS (SELECT 1 FROM refill_alert WHERE prescription_id = 5 AND patient_id = 4);
