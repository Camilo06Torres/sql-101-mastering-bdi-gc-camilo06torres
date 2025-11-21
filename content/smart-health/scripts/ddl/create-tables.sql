-- ##################################################
-- #            DDL SCRIPT DOCUMENTATION            #
-- ##################################################
-- This script defines the database structure for Smart Health Hospital Management System
-- Includes tables for PATIENTS, DOCTORS, APPOINTMENTS, MEDICAL_RECORDS, and supporting
-- catalog tables for geographic locations, document types, specialties, diagnoses, and medications.
-- The system is designed to manage patient records, medical appointments, clinical history,
-- prescriptions, and professional credentials in a normalized academic environment.
-- All tables include appropriate constraints, relationships, and data types to ensure 
-- data integrity and support comprehensive healthcare management operations.
-- Database Normalization: 4NF (Fourth Normal Form)
-- Target DBMS: PostgreSQL

-- ##################################################
-- #        MÓDULO MÉTODOS DE PAGO - INDEPENDENT    #
-- ##################################################

-- Table: payment_method
CREATE TABLE IF NOT EXISTS smart_health.payment_methods (
    payment_method_id SERIAL PRIMARY KEY,
    payment_name VARCHAR(50) NOT NULL
);

-- Table: payment_method
CREATE TABLE IF NOT EXISTS smart_health.payments (
    payment_id SERIAL PRIMARY KEY,
    reference_number VARCHAR(50) NOT NULL,
    payment_date DATE NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    payment_method_id INTEGER NOT NULL,
    order_id INTEGER NOT NULL
);

-- Table: orders
CREATE TABLE IF NOT EXISTS smart_health.orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL DEFAULT 0,
    tax_amount NUMERIC(10, 2),
    status BOOLEAN DEFAULT TRUE,
    patient_id INTEGER NOT NULL,
    appointment_id INTEGER NULL
);

-- ##################################################
-- #            RELATIONSHIP DEFINITIONS            #
-- ##################################################

-- Relationships for MÓDULO MÉTODOS DE PAGO

ALTER TABLE smart_health.payments ADD CONSTRAINT fk_payments_payment_methods
    FOREIGN KEY (payment_method_id) REFERENCES smart_health.payment_methods (payment_method_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

-- Relationships for PAYMENTS - ORDERS
ALTER TABLE smart_health.payments ADD CONSTRAINT fk_payments_orders
    FOREIGN KEY (order_id) REFERENCES smart_health.orders (order_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

-- Relationships for PATIENT - ORDERS
ALTER TABLE smart_health.orders ADD CONSTRAINT fk_orders_patients
    FOREIGN KEY (patient_id) REFERENCES smart_health.patients (patient_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

-- Relationships for APPOINTMENT - ORDERS
ALTER TABLE smart_health.orders ADD CONSTRAINT fk_orders_appointments
    FOREIGN KEY (appointment_id) REFERENCES smart_health.appointments (appointment_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


-- ##################################################
-- #                ALTERATIONS                     #
-- ##################################################

ALTER TABLE smart_health.payments
ADD CONSTRAINT chk_payment_amount
CHECK (amount > 0);

ALTER TABLE smart_health.orders
ADD CONSTRAINT chk_total_amount
CHECK (total_amount >= 0);

ALTER TABLE smart_health.orders
ADD CONSTRAINT chk_tax_amount
CHECK (tax_amount >= 0);


-- ##################################################
-- #                 END OF SCRIPT                  #
-- ##################################################