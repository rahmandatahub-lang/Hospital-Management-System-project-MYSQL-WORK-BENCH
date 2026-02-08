CREATE DATABASE OWAISI_HOSPITAL;
USE OWAISI_HOSPITAL;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    phone VARCHAR(15),
    city VARCHAR(50),
    admission_date DATE
);

INSERT INTO patients (patient_name, gender, age, phone, city, admission_date) VALUES
('Rahul Sharma','Male',34,'9000011111','Delhi','2025-01-10'),
('Ayesha Khan','Female',28,'9000022222','Mumbai','2025-01-12'),
('John Paul','Male',45,'9000033333','Bangalore','2025-01-15'),
('Sneha Reddy','Female',31,'9000044444','Hyderabad','2025-01-18');
SELECT * FROM PATIENTS;
---------------------------------------------------------------------------------------------------
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100),
    specialization VARCHAR(100),
    phone VARCHAR(15),
    consultation_fee DECIMAL(10,2)
);
INSERT INTO doctors (doctor_name, specialization, phone, consultation_fee) VALUES
('Dr. Mehta','Cardiology','8000011111',800),
('Dr. Rao','Orthopedics','8000022222',600),
('Dr. Smith','Neurology','8000033333',1000);

SELECT * FROM DOCTORS;

CREATE TABLE doctor_schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT,
    available_day VARCHAR(20),
    available_time VARCHAR(20),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);
INSERT INTO doctor_schedules (doctor_id, available_day, available_time) VALUES
(1,'Monday','10AM-2PM'),
(1,'Wednesday','10AM-2PM'),
(2,'Tuesday','11AM-3PM'),
(3,'Friday','9AM-1PM');
SELECT * FROM doctor_schedules ;
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) VALUES
(1,1,'2025-01-20','Completed'),
(2,2,'2025-01-21','Completed'),
(3,3,'2025-01-22','Cancelled'),
(4,1,'2025-01-23','Completed');
SELECT * FROM APPOINTMENTS;

CREATE TABLE treatments (
    treatment_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT,
    treatment_name VARCHAR(100),
    treatment_cost DECIMAL(10,2),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);
INSERT INTO treatments (appointment_id, treatment_name, treatment_cost) VALUES
(1,'ECG',2000),
(1,'Consultation',800),
(2,'X-Ray',1500),
(4,'Heart Checkup',5000);


CREATE TABLE bills (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    bill_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);
INSERT INTO bills (patient_id, total_amount, payment_status, bill_date) VALUES
(1,2800,'Paid','2025-01-20'),
(2,1500,'Paid','2025-01-21'),
(4,5000,'Unpaid','2025-01-23');
SELECT * FROM BILLS;

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    bill_id INT,
    amount_paid DECIMAL(10,2),
    payment_mode VARCHAR(20),
    payment_date DATE,
    FOREIGN KEY (bill_id) REFERENCES bills(bill_id)
);

INSERT INTO payments (bill_id, amount_paid, payment_mode, payment_date) VALUES
(1,2800,'Cash','2025-01-20'),
(2,1500,'Card','2025-01-21');
SELECT * FROM payments;

--------------------------------------------------------------------------------------------------------------
									##QUERIES
--------------------------------------------------------------------------------------------------------------

SELECT * FROM DOCTORS;
SELECT * FROM PATIENTS;
SELECT * FROM TREATMENTS;
SELECT * FROM PAYMENTS;
SELECT * FROM BILLS;
SELECT * FROM doctor_schedules;
SELECT * FROM APPOINTMENTS;

#1....Q1. Show all tables
SHOW TABLES;

#2.......Describe patients table
DESC PATIENTS;

#3...........Display all patients
SELECT * FROM PATIENTS;

#4.........Display patient name and city

SELECT PATIENT_NAME,CITY FROM PATIENTS;

#5.......Patients from Delhi

SELECT * FROM PATIENTS WHERE CITY = 'DELHI';

#6......Doctors with fee > 700
SELECT * FROM DOCTORS;
SELECT * FROM DOCTORS WHERE CONSULTATION_FEE>700;

#7......Unique cities
SHOW TABLES;
SELECT * FROM PATIENTS;

SELECT distinct CITY FROM PATIENTS;

#8..........Doctors sorted by fee (high → low)

SELECT CONSULTATION_FEE FROM DOCTORS ORDER BY CONSULTATION_FEE DESC; 

#9..........Top 3 highest paid doctors
SELECT CONSULTATION_FEE FROM DOCTORS ORDER BY CONSULTATION_FEE DESC LIMIT 3;


#10.........Total patients

SELECT * FROM PATIENTS;

#11...........Average consultation fee
SELECT AVG(CONSULTATION_FEE) FROM DOCTORS;


#12........Maximum treatment cost
SELECT * FROM TREATMENTS;

SELECT MAX(TREATMENT_COST) FROM TREATMENTS;

SELECT COUNT(*) FROM PATIENTS;

SHOW TABLES;

#13.......Appointments per doctor
SELECT doctor_id, COUNT(*) 
FROM appointments
GROUP BY doctor_id;

#14........Doctors with more than 1 appointment
SELECT doctor_id, COUNT(*)
FROM appointments
GROUP BY doctor_id
HAVING COUNT(*) > 1;


#15.............Q15. Patient with doctor name

SELECT patients.patient_name, doctors.doctor_name
FROM patients 
JOIN appointments  ON patients.patient_id = appointments.patient_id
JOIN doctors  ON appointments.doctor_id = doctors.doctor_id;


#16... Doctors with or without appointments

SELECT doctors.doctor_name, appointments.appointment_id
FROM doctors 
LEFT JOIN appointments  ON doctors.doctor_id = appointments.doctor_id;


#17........Patients who have appointments
select * from patients;


SELECT * FROM patients WHERE patient_id IN (SELECT patient_id FROM appointments);

#18...Doctors with above-average fee

select * from doctors where consultation_fee>(select avg(consultation_fee) from doctors);

#19.....Bill payment status
SELECT bill_id, total_amount,
CASE
  WHEN payment_status = 'Paid' THEN 'Completed'
  ELSE 'Pending'
END AS status
FROM bills;

#20....Q22. January appointments

SELECT * FROM appointments
WHERE MONTH(appointment_date) = 1;

#21.....Q23. Appointment count per doctor

SELECT doctor_id,
COUNT(*) OVER (PARTITION BY doctor_id) AS total_appointments
FROM appointments;


#22..........Q26. Total hospital revenue

select * from bills;
select sum(total_amount) from bills where payment_status='paid';

#23....... Create patient bill summary view

CREATE VIEW patient_bill_summary AS
SELECT patients.patient_name, bills.total_amount, bills.payment_status
FROM patients 
JOIN bills  ON patients.patient_id = bills.patient_id;

select * from patient_bill_summary;

#24...... Find NULL values

select * from patients where phone is null;

#25.......... Patients with unpaid bills

select * from patients;
select * from bills;

SELECT patients.patient_name, bills.total_amount
FROM patients 
JOIN bills 
 ON patients.patient_id = bills.patient_id
WHERE bills.payment_status = 'Unpaid';



---------------------------------------------------------------------------
										##END##
-----------------------------------------------------------------------------
                                        













