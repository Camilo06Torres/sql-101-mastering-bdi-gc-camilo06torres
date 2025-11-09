-- ##################################################
-- # CONSULTAS DATEPART, NOW, CURRENT_DATE, EXTRACT, AGE, INTERVAL - SMART HEALTH #
-- ##################################################

-- 1. Obtener todos los pacientes que nacieron en el mes actual,
-- mostrando su nombre completo, fecha de nacimiento y edad actual en años.
-- Dificultad: BAJA

SELECT
    first_name||' '||COALESCE(middle_name, '')||' '||first_surname||' '||COALESCE(second_surname, '') AS nombre_completo,
    birth_date AS fecha_nacimiento,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS edad_actual_anos
FROM smart_health.patients
WHERE EXTRACT(MONTH FROM birth_date) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR FROM birth_date) = EXTRACT(YEAR FROM CURRENT_DATE)
ORDER BY birth_date ASC;

-- 2. Listar todas las citas programadas para los próximos 7 días,
-- mostrando la fecha de la cita, el nombre del paciente, el nombre del doctor,
-- y cuántos días faltan desde hoy hasta la cita.
-- Dificultad: BAJA

SELECT
    T1.appointment_date AS fecha_cita,
    T2.first_name||' '||COALESCE(T2.middle_name, '')||' '||T2.first_surname||' '||COALESCE(T2.second_surname, '') AS nombre_paciente,
    T3.first_name||' '||T3.last_name AS nombre_doctor,
    (T1.appointment_date - CURRENT_DATE) AS dias_faltantes
FROM smart_health.appointments T1
INNER JOIN smart_health.patients T2
    ON T1.patient_id = T2.patient_id
INNER JOIN smart_health.doctors T3
    ON T1.doctor_id = T3.doctor_id
WHERE T1.appointment_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days'
ORDER BY T1.appointment_date ASC;

-- 3. Mostrar todos los médicos que ingresaron al hospital hace más de 5 años,
-- incluyendo su nombre completo, fecha de ingreso, y la cantidad exacta de años,
-- meses y días que han trabajado en el hospital.
-- Dificultad: BAJA-INTERMEDIA

SELECT
    first_name||' '||last_name AS nombre_completo,
    hospital_admission_date AS fecha_ingreso,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hospital_admission_date)) AS anos_trabajados,
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, hospital_admission_date)) AS meses_trabajados,
    EXTRACT(DAY FROM AGE(CURRENT_DATE, hospital_admission_date)) AS dias_trabajados
FROM smart_health.doctors
WHERE AGE(CURRENT_DATE, hospital_admission_date) > INTERVAL '5 years'
ORDER BY hospital_admission_date ASC;

-- 4. Obtener las prescripciones emitidas en el último mes,
-- mostrando la fecha de prescripción, el nombre del medicamento,
-- el nombre del paciente, cuántos días han pasado desde la prescripción,
-- y el día de la semana en que fue prescrito.
-- Dificultad: INTERMEDIA

SELECT
    T1.prescription_date AS fecha_prescripcion,
    T2.commercial_name AS nombre_medicamento,
    T4.first_name||' '||COALESCE(T4.middle_name, '')||' '||T4.first_surname||' '||COALESCE(T4.second_surname, '') AS nombre_paciente,
    (CURRENT_DATE - DATE(T1.prescription_date)) AS dias_desde_prescripcion,
    CASE EXTRACT(DOW FROM T1.prescription_date)
        WHEN 0 THEN 'Domingo'
        WHEN 1 THEN 'Lunes'
        WHEN 2 THEN 'Martes'
        WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves'
        WHEN 5 THEN 'Viernes'
        WHEN 6 THEN 'Sábado'
    END AS dia_semana
FROM smart_health.prescriptions T1
INNER JOIN smart_health.medications T2
    ON T1.medication_id = T2.medication_id
INNER JOIN smart_health.medical_records T3
    ON T1.medical_record_id = T3.medical_record_id
INNER JOIN smart_health.patients T4
    ON T3.patient_id = T4.patient_id
WHERE T1.prescription_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
  AND T1.prescription_date < DATE_TRUNC('month', CURRENT_DATE)
ORDER BY T1.prescription_date DESC;

-- 5. Listar todos los pacientes registrados en el sistema durante el trimestre actual,
-- mostrando su nombre completo, fecha de registro, edad actual,
-- el trimestre de registro, y cuántas semanas han pasado desde su registro,
-- ordenados por fecha de registro más reciente primero.
-- Dificultad: INTERMEDIA

SELECT
    first_name||' '||COALESCE(middle_name, '')||' '||first_surname||' '||COALESCE(second_surname, '') AS nombre_completo,
    registration_date AS fecha_registro,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS edad_actual,
    EXTRACT(QUARTER FROM registration_date) AS trimestre_registro,
    FLOOR((CURRENT_DATE - DATE(registration_date)) / 7) AS semanas_desde_registro
FROM smart_health.patients
WHERE EXTRACT(QUARTER FROM registration_date) = EXTRACT(QUARTER FROM CURRENT_DATE)
  AND EXTRACT(YEAR FROM registration_date) = EXTRACT(YEAR FROM CURRENT_DATE)
ORDER BY registration_date DESC;


-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################