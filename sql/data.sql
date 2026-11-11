USE refill_db;

DELETE FROM app_user;
DELETE FROM refill_request;
DELETE FROM prescription;
DELETE FROM patient;

INSERT INTO patient (patient_id, name, phone) VALUES
  (1, 'Ravi Kulkarni', '9822000001'),
  (2, 'Sneha Joshi',   '9822000002'),
  (3, 'Amit Deshmukh', '9822000003'),
  (4, 'Priya Patil',   '9822000004');

INSERT INTO prescription (prescription_id, patient_id, medicine_name, dosage, total_refills, refills_used) VALUES
  (1, 1, 'Metformin',         '500 mg', 5, 2),
  (2, 1, 'Amlodipine',        '5 mg',   3, 3),
  (3, 2, 'Atorvastatin',      '10 mg',  6, 1),
  (4, 3, 'Levothyroxine',     '50 mcg', 4, 0),
  (5, 4, 'Salbutamol Inhaler','100 mcg',2, 1);

INSERT INTO refill_request (request_id, prescription_id, request_date, status) VALUES
  (1, 1, '2026-09-05', 'COLLECTED'),
  (2, 1, '2026-10-20', 'PENDING'),
  (3, 2, '2026-10-22', 'PENDING'),
  (4, 3, '2026-10-25', 'PENDING'),
  (5, 3, '2026-09-15', 'REJECTED'),
  (6, 4, '2026-10-28', 'PENDING'),
  (7, 5, '2026-10-10', 'APPROVED'),
  (8, 3, '2026-08-12', 'COLLECTED'),
  (9, 1, '2026-08-05', 'COLLECTED');

INSERT INTO app_user (user_id, username, password_hash, role, patient_id) VALUES
  (1, 'pharma1', '1c7d7f2a7668a1de0ea8f04a0ce6ff072e14781b052c51ee506a41b05d28b5cb', 'PHARMACIST', NULL),
  (2, 'ravi',    'd4587ea9ead060c13fd994f21ecfa7926272a78854a2c20136b10a3c9e53e71e', 'PATIENT', 1),
  (3, 'sneha',   'd4587ea9ead060c13fd994f21ecfa7926272a78854a2c20136b10a3c9e53e71e', 'PATIENT', 2),
  (4, 'amit',    'd4587ea9ead060c13fd994f21ecfa7926272a78854a2c20136b10a3c9e53e71e', 'PATIENT', 3),
  (5, 'priya',   'd4587ea9ead060c13fd994f21ecfa7926272a78854a2c20136b10a3c9e53e71e', 'PATIENT', 4);

