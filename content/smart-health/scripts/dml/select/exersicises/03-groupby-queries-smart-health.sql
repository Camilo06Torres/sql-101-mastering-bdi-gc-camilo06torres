-- ##################################################
-- # CONSULTAS CON JOINS Y AGREGACIÓN - SMART HEALTH #
-- ##################################################

-- 1. Contar cuántos pacientes están registrados por cada tipo de documento,
-- mostrando el nombre del tipo de documento y la cantidad total de pacientes,
-- ordenados por cantidad de mayor a menor.

-- INNER JOIN
-- smart_health.patients: FK (document_type_id)
-- smart_health.document_types: PK(document_type_id)
-- AGGREGATION FUNCTION: COUNT
SELECT
    T2.type_name AS tipo_documento,
    COUNT(*) AS total_documentos


FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id
GROUP BY T2.type_name
ORDER BY total_documentos DESC;




-- 2. Obtener la cantidad de citas programadas por cada médico,
-- mostrando el nombre completo del doctor y el total de citas,
-- filtrando solo médicos con más de 5 citas, ordenados por cantidad descendente.

-- INNER JOIN
-- smart_health.appointments: FK (doctor_id)
-- smart_health.doctors: PK (doctor_id)
-- AGGREGATION FUNCTION: COUNT | GROUP BY: T2.first_name, T2.last_name
SELECT
    T2.first_name || ' ' || T2.last_name AS nombre_doctor,
    COUNT(*) AS total_citas
FROM smart_health.appointments T1
INNER JOIN smart_health.doctors T2
    ON T1.doctor_id = T2.doctor_id
GROUP BY T2.first_name, T2.last_name
HAVING COUNT(*) > 5
ORDER BY total_citas DESC;

-- 3. Contar cuántas especialidades tiene cada médico activo,
-- mostrando el nombre del doctor y el número total de especialidades,
-- ordenados por cantidad de especialidades de mayor a menor.

-- INNER JOIN
-- smart_health.doctors: PK (doctor_id)
-- smart_health.doctor_specialties: (doctor_id, specialty_id)
-- AGGREGATION FUNCTION: COUNT | GROUP BY: T1.first_name, T1.last_name
SELECT
    T1.first_name || ' ' || T1.last_name AS nombre_doctor,
    COUNT(*) AS total_especialidades
FROM smart_health.doctors T1
INNER JOIN smart_health.doctor_specialties T2
    ON T1.doctor_id = T2.doctor_id
WHERE T1.active = TRUE
  AND T2.is_active = TRUE
GROUP BY T1.first_name, T1.last_name
ORDER BY total_especialidades DESC;

-- 4. Calcular cuántos pacientes residen en cada departamento,
-- mostrando el nombre del departamento y la cantidad total de pacientes,
-- filtrando solo departamentos con al menos 3 pacientes, ordenados alfabéticamente.

-- INNER JOIN múltiples
-- smart_health.patients: PK (patient_id)
-- smart_health.patient_addresses: FK (patient_id, address_id)
-- smart_health.addresses: PK (address_id)
-- smart_health.municipalities: PK (municipality_code)
-- smart_health.departments: PK (department_code)
-- AGGREGATION FUNCTION: COUNT | GROUP BY: T5.department_name
SELECT
    T5.department_name AS departamento,
    COUNT(*) AS total_pacientes
FROM smart_health.patients T1
INNER JOIN smart_health.patient_addresses T2
    ON T1.patient_id = T2.patient_id AND T2.is_primary = TRUE
INNER JOIN smart_health.addresses T3
    ON T2.address_id = T3.address_id
INNER JOIN smart_health.municipalities T4
    ON T3.municipality_code = T4.municipality_code
INNER JOIN smart_health.departments T5
    ON T4.department_code = T5.department_code
GROUP BY T5.department_name
HAVING COUNT(*) >= 3
ORDER BY T5.department_name ASC;


-- 5. Contar cuántas citas ha tenido cada paciente por estado de cita,
-- mostrando el nombre del paciente, estado de la cita y cantidad,
-- ordenados por nombre de paciente y estado.

-- INNER JOIN
-- smart_health.appointments: FK (patient_id)
-- smart_health.patients: PK (patient_id)
-- AGGREGATION FUNCTION: COUNT | GROUP BY: nombre_paciente, T1.status
SELECT
    (T2.first_name || ' ' || COALESCE(T2.middle_name, '') || ' ' || T2.first_surname || ' ' || COALESCE(T2.second_surname, ''))::TEXT AS nombre_paciente,
    T1.status AS estado_cita,
    COUNT(*) AS total
FROM smart_health.appointments T1
INNER JOIN smart_health.patients T2
    ON T1.patient_id = T2.patient_id
GROUP BY nombre_paciente, T1.status
ORDER BY nombre_paciente ASC, estado_cita ASC;

-- 6. Calcular cuántos registros médicos ha realizado cada doctor,
-- mostrando el nombre del doctor y el total de registros,
-- filtrando solo doctores con más de 10 registros, ordenados por cantidad descendente.

-- INNER JOIN
-- smart_health.medical_records: FK (doctor_id)
-- smart_health.doctors: PK (doctor_id)
-- AGGREGATION FUNCTION: COUNT | GROUP BY: T2.first_name, T2.last_name
SELECT
    T2.first_name || ' ' || T2.last_name AS nombre_doctor,
    COUNT(*) AS total_registros
FROM smart_health.medical_records T1
INNER JOIN smart_health.doctors T2
    ON T1.doctor_id = T2.doctor_id
GROUP BY T2.first_name, T2.last_name
HAVING COUNT(*) > 10
ORDER BY total_registros DESC;

-- 7. Contar cuántas prescripciones se han emitido para cada medicamento,
-- mostrando el nombre comercial del medicamento y el total de prescripciones,
-- filtrando medicamentos con al menos 2 prescripciones, ordenados por cantidad descendente.

-- INNER JOIN
-- smart_health.prescriptions: FK (medication_id)
-- smart_health.medications: PK (medication_id)
-- AGGREGATION FUNCTION: COUNT | GROUP BY: T2.commercial_name
SELECT
    T2.commercial_name AS medicamento,
    COUNT(*) AS total_prescripciones
FROM smart_health.prescriptions T1
INNER JOIN smart_health.medications T2
    ON T1.medication_id = T2.medication_id
GROUP BY T2.commercial_name
HAVING COUNT(*) >= 2
ORDER BY total_prescripciones DESC;

-- 8. Calcular cuántos pacientes tienen alergias por cada medicamento,
-- mostrando el nombre del medicamento y la cantidad de pacientes alérgicos,
-- ordenados por cantidad de mayor a menor.

-- INNER JOIN
-- smart_health.patient_allergies: (patient_id, medication_id)
-- smart_health.medications: PK (medication_id)
-- AGGREGATION FUNCTION: COUNT(DISTINCT patient_id) | GROUP BY: T2.commercial_name
SELECT
    T2.commercial_name AS medicamento,
    COUNT(DISTINCT T1.patient_id) AS pacientes_alergicos
FROM smart_health.patient_allergies T1
INNER JOIN smart_health.medications T2
    ON T1.medication_id = T2.medication_id
GROUP BY T2.commercial_name
ORDER BY pacientes_alergicos DESC;

-- 9. Contar cuántas direcciones tiene registrado cada paciente,
-- mostrando el nombre del paciente y el total de direcciones,
-- filtrando solo pacientes con más de 1 dirección, ordenados por cantidad descendente.

-- INNER JOIN
-- smart_health.patient_addresses: FK (patient_id)
-- smart_health.patients: PK (patient_id)
-- AGGREGATION FUNCTION: COUNT | GROUP BY: nombre_paciente
SELECT
    (T2.first_name || ' ' || COALESCE(T2.middle_name, '') || ' ' || T2.first_surname || ' ' || COALESCE(T2.second_surname, ''))::TEXT AS nombre_paciente,
    COUNT(*) AS total_direcciones
FROM smart_health.patient_addresses T1
INNER JOIN smart_health.patients T2
    ON T1.patient_id = T2.patient_id
GROUP BY nombre_paciente
HAVING COUNT(*) > 1
ORDER BY total_direcciones DESC;

-- 10. Calcular cuántas salas de cada tipo están activas en el hospital,
-- mostrando el tipo de sala y la cantidad total,
-- filtrando solo tipos con al menos 2 salas, ordenados por cantidad descendente.

-- AGGREGATION FUNCTION: COUNT | GROUP BY: room_type | FILTER: active = TRUE
SELECT
    room_type AS tipo_sala,
    COUNT(*) AS total_salas
FROM smart_health.rooms
WHERE active = TRUE
GROUP BY room_type
HAVING COUNT(*) >= 2
ORDER BY total_salas DESC;

-- ##################################################
-- #              FIN DE CONSULTAS                  #
-- ##################################################