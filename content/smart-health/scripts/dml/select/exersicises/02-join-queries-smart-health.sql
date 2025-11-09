-- ##################################################
-- #   CONSULTAS CON JOINS - SMART HEALTH          #
-- ##################################################

-- 1. Listar todos los pacientes con su tipo de documento correspondiente,
-- mostrando el nombre completo del paciente, número de documento y nombre del tipo de documento,
-- ordenados por apellido del paciente.
SELECT
    T1.first_name||' '||COALESCE(T1.middle_name, '')||' '||T1.first_surname||' '||COALESCE(T1.second_surname, '') AS paciente,
    T1.document_number AS numero_documento,
    T2.type_name AS tipo_documento

FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id
ORDER BY T1.first_surname
LIMIT 10; 


-- 2. Consultar todas las citas médicas con la información del paciente y del doctor asignado,
-- mostrando nombres completos, fecha y hora de la cita,
-- ordenadas por fecha de cita de forma descendente.

SELECT
    T2.first_name||' '||COALESCE(T2.middle_name, '')||' '||T2.first_surname||' '||COALESCE(T2.second_surname, '') AS paciente,
    T1.appointment_date AS fecha_cita,
    T1.start_time AS hora_inicio_cita,
    T1.end_time AS hora_fin_cita,
    'Dr. '||' '||T3.first_name||' '||COALESCE(T3.last_name, '') AS doctor_asignado,
    T3.internal_code AS codigo_medico

FROM smart_health.appointments T1
INNER JOIN smart_health.patients T2
    ON T1.patient_id = T2.patient_id
INNER JOIN smart_health.doctors T3
    ON T1.doctor_id = T3.doctor_id
ORDER BY T1.appointment_date DESC
LIMIT 10;


-- 3. Obtener todas las direcciones de pacientes con información completa del municipio y departamento,
-- mostrando el nombre del paciente, dirección completa y ubicación geográfica,
-- ordenadas por departamento y municipio.

SELECT
    T1.first_name||' '||COALESCE(T1.middle_name, '')||' '||T1.first_surname||' '||COALESCE(T1.second_surname, '') AS paciente,
    T3.address_line AS direccion_completa,
    T4.municipality_name AS municipio,
    T5.department_name AS departamento
FROM smart_health.patients T1
INNER JOIN smart_health.patient_addresses T2
    ON T1.patient_id = T2.patient_id
INNER JOIN smart_health.addresses T3
    ON T2.address_id = T3.address_id
INNER JOIN smart_health.municipalities T4
    ON T3.municipality_code = T4.municipality_code
INNER JOIN smart_health.departments T5
    ON T4.department_code = T5.department_code
ORDER BY T5.department_name ASC, T4.municipality_name ASC
LIMIT 10;

-- 4. Listar todos los médicos con sus especialidades asignadas,
-- mostrando el nombre del doctor, especialidad y fecha de certificación,
-- filtrando solo especialidades activas y ordenadas por apellido del médico.

SELECT
    T1.first_name||' '||T1.last_name AS nombre_doctor,
    T3.specialty_name AS especialidad,
    T2.certification_date AS fecha_certificacion
FROM smart_health.doctors T1
INNER JOIN smart_health.doctor_specialties T2
    ON T1.doctor_id = T2.doctor_id
INNER JOIN smart_health.specialties T3
    ON T2.specialty_id = T3.specialty_id
WHERE T2.is_active = TRUE
ORDER BY T1.last_name ASC
LIMIT 10;


-- [NO REALIZAR]
-- 5. Consultar todas las alergias de pacientes con información del medicamento asociado,
-- mostrando el nombre del paciente, medicamento, severidad y descripción de la reacción,
-- filtrando solo alergias graves o críticas, ordenadas por severidad.

-- [NO REALIZAR]
-- 6. Obtener todos los registros médicos con el diagnóstico principal asociado,
-- mostrando el paciente, doctor que registró, diagnóstico y fecha del registro,
-- filtrando registros del último año, ordenados por fecha de registro descendente.

-- 7. Listar todas las prescripciones médicas con información del medicamento y registro médico asociado,
-- mostrando el paciente, medicamento prescrito, dosis y si se generó alguna alerta,
-- filtrando prescripciones con alertas generadas, ordenadas por fecha de prescripción.

SELECT
    T3.first_name||' '||COALESCE(T3.middle_name, '')||' '||T3.first_surname||' '||COALESCE(T3.second_surname, '') AS paciente,
    T2.commercial_name AS medicamento_prescrito,
    T1.dosage AS dosis,
    T1.alert_generated AS alerta_generada
FROM smart_health.prescriptions T1
INNER JOIN smart_health.medications T2
    ON T1.medication_id = T2.medication_id
INNER JOIN smart_health.medical_records T4
    ON T1.medical_record_id = T4.medical_record_id
INNER JOIN smart_health.patients T3
    ON T4.patient_id = T3.patient_id
WHERE T1.alert_generated = TRUE
ORDER BY T1.prescription_date ASC
LIMIT 10;

-- 8. Consultar todas las citas con información de la sala asignada (si tiene),
-- mostrando paciente, doctor, sala y horario,
-- usando LEFT JOIN para incluir citas sin sala asignada, ordenadas por fecha y hora.

SELECT
    T2.first_name||' '||COALESCE(T2.middle_name, '')||' '||T2.first_surname||' '||COALESCE(T2.second_surname, '') AS paciente,
    T3.first_name||' '||T3.last_name AS doctor,
    COALESCE(T4.room_name, 'Sin sala asignada') AS sala,
    T1.appointment_date AS fecha,
    T1.start_time AS hora_inicio,
    T1.end_time AS hora_fin
FROM smart_health.appointments T1
INNER JOIN smart_health.patients T2
    ON T1.patient_id = T2.patient_id
INNER JOIN smart_health.doctors T3
    ON T1.doctor_id = T3.doctor_id
LEFT JOIN smart_health.rooms T4
    ON T1.room_id = T4.room_id
ORDER BY T1.appointment_date ASC, T1.start_time ASC
LIMIT 10;

-- 9. Listar todos los teléfonos de pacientes con información completa del paciente,
-- mostrando nombre, tipo de teléfono, número y si es el teléfono principal,
-- filtrando solo teléfonos móviles, ordenados por nombre del paciente.

SELECT
    T2.first_name||' '||COALESCE(T2.middle_name, '')||' '||T2.first_surname||' '||COALESCE(T2.second_surname, '') AS nombre_paciente,
    T1.phone_type AS tipo_telefono,
    T1.phone_number AS numero_telefono,
    T1.is_primary AS telefono_principal
FROM smart_health.patient_phones T1
INNER JOIN smart_health.patients T2
    ON T1.patient_id = T2.patient_id
WHERE T1.phone_type = 'Móvil'
ORDER BY T2.first_name ASC, T2.first_surname ASC
LIMIT 10;

-- 10. Obtener todos los doctores que NO tienen especialidades asignadas (ANTI JOIN),
-- mostrando su información básica y fecha de ingreso,
-- útil para identificar médicos que requieren actualización de información,
-- ordenados por fecha de ingreso al hospital.

SELECT
    T1.first_name||' '||T1.last_name AS nombre_doctor,
    T1.internal_code AS codigo_interno,
    T1.professional_email AS correo_profesional,
    T1.hospital_admission_date AS fecha_ingreso
FROM smart_health.doctors T1
LEFT JOIN smart_health.doctor_specialties T2
    ON T1.doctor_id = T2.doctor_id AND T2.is_active = TRUE
WHERE T2.doctor_specialty_id IS NULL
ORDER BY T1.hospital_admission_date ASC
LIMIT 10;


-- ##################################################
-- #              FIN DE CONSULTAS                  #
-- ##################################################