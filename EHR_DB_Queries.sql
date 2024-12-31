
-- Create and Use Database:
CREATE DATABASE EHR_DB;
USE EHR_DB;

-- Create Tables:
CREATE TABLE Patient (
    Patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR (100),
    age INT,
    address_phone VARCHAR (255), 
    gender ENUM ('Male', 'Female', 'Other'),
    Hospital_id INT, 
    Doctor_id INT, 
    FOREIGN KEY (Hospital_id) REFERENCES Hospital (Hospital_id),
    FOREIGN KEY (Doctor_id) REFERENCES Doctor (Doctor_id)
);

CREATE TABLE Doctor (
    Doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR (100),
    specialty VARCHAR (50),
    Hospital_id INT,
    FOREIGN KEY (Hospital_id) REFERENCES Hospital(Hospital_id)
);

CREATE TABLE Hospital (
    Hospital_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR (100),
    location VARCHAR (255)
);

CREATE TABLE Emergency_Contact (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Patient_id INT, 
    contact_name VARCHAR (100),
    contact_phone VARCHAR (15),
    FOREIGN KEY (Patient_id) REFERENCES Patient (Patient_id)
);

CREATE TABLE Patient_EmergencyContact (
    patient_id INT,
    id INT,
    PRIMARY KEY (patient_id, id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (id) REFERENCES Emergency_Contact(id)
);

-- Describe Tables:
DESCRIBE Patient;
DESCRIBE Doctor;
DESCRIBE Hospital;
DESCRIBE Emergency_Contact;

-- Insert Into Tables:
INSERT INTO Patient (name, age, address_phone, gender, hospital_id, doctor_id)
VALUES
('Ram', 25, 'Kathmandu-1234567890', 'Male', 1, 1),
('Shyam', 30, 'Pokhara-9876543210', 'Male', 3, 3),
('Mohan', 28, 'Lalitpur-1231231234', 'Male', 4, 4),
('Siya', 27, 'Bhaktapur-4564564567', 'Female', 2, 2),
('Jiya', 35, 'Chitwan-7897897890', 'Female', 5, 5);

INSERT INTO Doctor (name, specialty, hospital_id)
VALUES
('Dr. Prabal', 'Cardiologist', 1),
('Dr. Roshan', 'Neurologist', 2),
('Dr. Saroj', 'Orthopedic', 3),
('Dr. Krish', 'Pediatrician', 4),
('Dr. Suyog', 'Dermatologist', 5),
('Dr. Saurav', 'Surgeon', 1);

INSERT INTO Hospital (name, location)
VALUES
('KMC', 'Kathmandu'),
('Dhulikhel', 'Kavre'),
('Grandee', 'Pokhara'),
('HAMS', 'Lalitpur'),
('BIR', 'Biratnagar');

INSERT INTO Emergency_Contact (patient_id, contact_name, contact_phone)
VALUES
(1, 'Yashu', '9847600000'),
(2, 'Shiva', '9847600001'),
(3, 'Allah', '9847600002'),
(4, 'Bashu', '9847600003'),
(5, 'Hanuman', '9847600004');

INSERT INTO Patient_EmergencyContact (patient_id, id)
VALUES
(1,1),
(1,2),
(2,1),
(3,3);

-- View/Select Table:
SELECT * FROM Patient;
SELECT * FROM Doctor;
SELECT * FROM Hospital;
SELECT * FROM Emergency_Contact;

-- Relationships:
SELECT Patient.name AS patient_name, Doctor.name AS doctor_name
FROM Patient
JOIN Doctor ON Patient.Doctor_id = Doctor.Doctor_id;

SELECT Hospital.name AS hospital_name, Doctor.name AS doctor_name
FROM Hospital
JOIN Doctor ON Hospital.Hospital_id = Doctor.hospital_id;

SELECT Patient.name AS patient_name, Emergency_Contact.contact_name AS emergency_contact_name 
FROM 
Patient
JOIN 
Patient_EmergencyContact ON Patient.patient_id = Patient_EmergencyContact.patient_id
JOIN 
Emergency_Contact ON Patient_EmergencyContact.id = Emergency_Contact.id;

-- Selection and Projection:
SELECT * FROM Patient WHERE gender = 'Male';
SELECT name, age FROM Patient;

-- Set Operations:
SELECT name FROM Patient
UNION
SELECT name FROM Doctor;

SELECT name FROM Patient
INTERSECT 
SELECT name FROM Doctor;

SELECT name FROM Patient
EXCEPT 
SELECT name FROM Doctor;

-- Joins:
SELECT Doctor.name AS doctor_name, Hospital.name AS hospital_name
FROM Doctor
JOIN Hospital ON Doctor.hospital_id = Hospital.Hospital_id;

SELECT Patient.name, Emergency_Contact.contact_name
FROM Patient
LEFT JOIN Emergency_Contact ON Patient.Patient_id = Emergency_Contact.patient_id;

SELECT Patient.name, Emergency_Contact.contact_name
FROM Patient
RIGHT JOIN Emergency_Contact ON Patient.Patient_id = Emergency_Contact.patient_id;

SELECT Patient.name, Emergency_Contact.contact_name
FROM Patient
LEFT JOIN Emergency_Contact ON Patient.Patient_id = Emergency_Contact.patient_id
UNION
SELECT Patient.name, Emergency_Contact.contact_name
FROM Patient
RIGHT JOIN Emergency_Contact ON Patient.Patient_id = Emergency_Contact.patient_id;

-- Transactions:
START TRANSACTION;
INSERT INTO Patient (name, age, address_phone, gender, hospital_id, doctor_id)
VALUES ('Raj', 32, 'Pokhara-9876543210', 'Male', 3, 3);
INSERT INTO Emergency_Contact (patient_id, contact_name, contact_phone)
VALUES (999, 'Sita', '9847602345');
ROLLBACK;

START TRANSACTION;
INSERT INTO Patient (name, age, address_phone, gender, hospital_id, doctor_id)
VALUES ('Raj', 32, 'Pokhara-9876543210', 'Male', 3, 3);
INSERT INTO Emergency_Contact (patient_id, contact_name, contact_phone)
VALUES (999, 'Sita', '9847602345');
COMMIT;
