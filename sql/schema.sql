CREATE DATABASE IF NOT EXISTS refill_db CHARACTER SET utf8mb4;
USE refill_db;

DROP TABLE IF EXISTS app_user;
DROP TABLE IF EXISTS refill_request;
DROP TABLE IF EXISTS prescription;
DROP TABLE IF EXISTS patient;

CREATE TABLE patient (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(80)  NOT NULL,
  phone      VARCHAR(15)  NOT NULL
) ENGINE=InnoDB;

CREATE TABLE prescription (
  prescription_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id      INT          NOT NULL,
  medicine_name   VARCHAR(100) NOT NULL,
  dosage          VARCHAR(40)  NOT NULL,
  total_refills   INT          NOT NULL,
  refills_used    INT          NOT NULL DEFAULT 0,
  CONSTRAINT fk_presc_patient FOREIGN KEY (patient_id) REFERENCES patient (patient_id),
  CONSTRAINT chk_refills CHECK (refills_used >= 0 AND refills_used <= total_refills)
) ENGINE=InnoDB;

CREATE TABLE refill_request (
  request_id       INT AUTO_INCREMENT PRIMARY KEY,
  prescription_id  INT NULL,
  patient_id       INT NULL,
  otc_medicine     VARCHAR(100) NULL,
  quantity         INT NOT NULL DEFAULT 1,
  request_date     DATE NOT NULL,
  status           ENUM('PENDING','APPROVED','REJECTED','COLLECTED') NOT NULL DEFAULT 'PENDING',
  rejection_reason VARCHAR(255) NULL,
  CONSTRAINT fk_req_presc FOREIGN KEY (prescription_id) REFERENCES prescription (prescription_id),
  CONSTRAINT fk_req_patient FOREIGN KEY (patient_id) REFERENCES patient (patient_id),
  INDEX idx_req_status_date (status, request_date)
) ENGINE=InnoDB;

CREATE TABLE app_user (
  user_id       INT AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(40) NOT NULL UNIQUE,
  password_hash CHAR(64)    NOT NULL,
  role          ENUM('PATIENT','PHARMACIST','DOCTOR') NOT NULL,
  patient_id    INT NULL,
  CONSTRAINT fk_user_patient FOREIGN KEY (patient_id) REFERENCES patient (patient_id),
  CONSTRAINT chk_user_role CHECK (
    (role = 'PATIENT' AND patient_id IS NOT NULL) OR 
    (role IN ('PHARMACIST', 'DOCTOR') AND patient_id IS NULL))
) ENGINE=InnoDB;
