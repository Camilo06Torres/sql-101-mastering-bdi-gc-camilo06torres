-- ##################################################
-- # CONSULTAS GROUP BY QUERIES AND AGG FUNCTIONS WITH DATE AND STRING FUNCTIONS LIKE DATEPART, SPLIT, AGE, INTERVAL, UPPER, LOWER AND SO ON, USING JOINS - SMART HEALTH #
-- ##################################################

-- 1. Contar cuántos pacientes nacieron en cada mes del año,
-- mostrando el número del mes y el nombre del mes en mayúsculas,
-- junto con la cantidad total de pacientes nacidos en ese mes.
-- Dificultad: BAJA

SELECT
    EXTRACT(MONTH FROM birth_date) AS numero_mes,
    UPPER(TO_CHAR(birth_date, 'Month')) AS nombre_mes,
    COUNT(*) AS total_pacientes
FROM smart_health.patients
GROUP BY EXTRACT(MONTH FROM birth_date), TO_CHAR(birth_date, 'Month')
ORDER BY numero_mes ASC;

-- 2. Mostrar el número de citas programadas agrupadas por día de la semana,
-- incluyendo el nombre del día en español y la cantidad de citas,
-- ordenadas por la cantidad de citas de mayor a menor.
-- Dificultad: BAJA

SELECT
    CASE EXTRACT(DOW FROM appointment_date)
        WHEN 0 THEN 'Domingo'
        WHEN 1 THEN 'Lunes'
        WHEN 2 THEN 'Martes'
        WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves'
        WHEN 5 THEN 'Viernes'
        WHEN 6 THEN 'Sábado'
    END AS dia_semana,
    COUNT(*) AS cantidad_citas
FROM smart_health.appointments
GROUP BY EXTRACT(DOW FROM appointment_date)
ORDER BY cantidad_citas DESC;

-- 3. Calcular la cantidad de años promedio que los médicos han trabajado en el hospital,
-- agrupados por especialidad, mostrando el nombre de la especialidad en mayúsculas
-- y el promedio de años de experiencia redondeado a un decimal.
-- Dificultad: BAJA-INTERMEDIA

SELECT
    UPPER(T2.specialty_name) AS especialidad,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, T1.hospital_admission_date))), 1) AS promedio_anos_experiencia
FROM smart_health.doctors T1
INNER JOIN smart_health.doctor_specialties T3
    ON T1.doctor_id = T3.doctor_id
INNER JOIN smart_health.specialties T2
    ON T3.specialty_id = T2.specialty_id
WHERE T3.is_active = TRUE
GROUP BY T2.specialty_name
ORDER BY promedio_anos_experiencia DESC;

-- 4. Obtener el número de pacientes registrados por año,
-- mostrando el año de registro, el trimestre, y el total de pacientes,
-- solo para aquellos trimestres que tengan más de 2 pacientes registrados.
-- Dificultad: INTERMEDIA

SELECT
    EXTRACT(YEAR FROM registration_date) AS ano_registro,
    EXTRACT(QUARTER FROM registration_date) AS trimestre,
    COUNT(*) AS total_pacientes
FROM smart_health.patients
GROUP BY EXTRACT(YEAR FROM registration_date), EXTRACT(QUARTER FROM registration_date)
HAVING COUNT(*) > 2
ORDER BY ano_registro DESC, trimestre ASC;

-- 5. Listar el número de prescripciones emitidas por mes y año,
-- mostrando el mes en formato texto con la primera letra en mayúscula,
-- el año, y el total de prescripciones, junto con el nombre del medicamento más prescrito.
-- Dificultad: INTERMEDIA

SELECT
    INITCAP(TO_CHAR(prescription_date, 'Month')) AS mes,
    EXTRACT(YEAR FROM prescription_date) AS ano,
    COUNT(*) AS total_prescripciones,
    (SELECT commercial_name 
     FROM smart_health.medications T2
     INNER JOIN smart_health.prescriptions T3
         ON T2.medication_id = T3.medication_id
     WHERE EXTRACT(YEAR FROM T3.prescription_date) = EXTRACT(YEAR FROM T1.prescription_date)
       AND EXTRACT(MONTH FROM T3.prescription_date) = EXTRACT(MONTH FROM T1.prescription_date)
     GROUP BY T2.commercial_name
     ORDER BY COUNT(*) DESC
     LIMIT 1) AS medicamento_mas_prescrito
FROM smart_health.prescriptions T1
GROUP BY EXTRACT(YEAR FROM prescription_date), EXTRACT(MONTH FROM prescription_date), TO_CHAR(prescription_date, 'Month')
ORDER BY ano DESC, EXTRACT(MONTH FROM prescription_date) ASC;

-- 6. Calcular la edad promedio de los pacientes agrupados por tipo de sangre,
-- mostrando el tipo de sangre, la edad mínima, la edad máxima y la edad promedio,
-- solo para grupos que tengan al menos 3 pacientes.
-- Dificultad: INTERMEDIA

SELECT
    blood_type AS tipo_sangre,
    MIN(EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date))) AS edad_minima,
    MAX(EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date))) AS edad_maxima,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date))), 2) AS edad_promedio
FROM smart_health.patients
WHERE blood_type IS NOT NULL
GROUP BY blood_type
HAVING COUNT(*) >= 3
ORDER BY blood_type ASC;

-- 7. Mostrar el número de citas por médico y por mes,
-- incluyendo el nombre completo del doctor en mayúsculas, el mes y año de la cita,
-- la duración promedio de las citas en minutos, y el total de citas realizadas,
-- solo para aquellos médicos que tengan más de 5 citas en el mes.
-- Dificultad: INTERMEDIA-ALTA

SELECT
    UPPER(T2.first_name || ' ' || T2.last_name) AS nombre_doctor,
    EXTRACT(MONTH FROM T1.appointment_date) AS mes,
    EXTRACT(YEAR FROM T1.appointment_date) AS ano,
    ROUND(AVG(EXTRACT(EPOCH FROM (T1.end_time - T1.start_time)) / 60), 2) AS duracion_promedio_minutos,
    COUNT(*) AS total_citas
FROM smart_health.appointments T1
INNER JOIN smart_health.doctors T2
    ON T1.doctor_id = T2.doctor_id
GROUP BY T2.first_name, T2.last_name, EXTRACT(MONTH FROM T1.appointment_date), EXTRACT(YEAR FROM T1.appointment_date)
HAVING COUNT(*) > 5
ORDER BY ano DESC, mes DESC, total_citas DESC;

-- 8. Obtener estadísticas de alergias por severidad y mes de diagnóstico,
-- mostrando la severidad en minúsculas, el nombre del mes abreviado,
-- el total de alergias registradas, y el número de pacientes únicos afectados,
-- junto con el nombre comercial del medicamento más común en cada grupo.
-- Dificultad: INTERMEDIA-ALTA

SELECT
    LOWER(T1.severity) AS severidad,
    UPPER(TO_CHAR(T1.diagnosed_date, 'Mon')) AS mes_abreviado,
    COUNT(*) AS total_alergias,
    COUNT(DISTINCT T1.patient_id) AS pacientes_unicos_afectados,
    (SELECT commercial_name 
     FROM smart_health.medications T3
     INNER JOIN smart_health.patient_allergies T4
         ON T3.medication_id = T4.medication_id
     WHERE LOWER(T4.severity) = LOWER(T1.severity)
       AND EXTRACT(MONTH FROM T4.diagnosed_date) = EXTRACT(MONTH FROM T1.diagnosed_date)
       AND EXTRACT(YEAR FROM T4.diagnosed_date) = EXTRACT(YEAR FROM T1.diagnosed_date)
     GROUP BY T3.commercial_name
     ORDER BY COUNT(*) DESC
     LIMIT 1) AS medicamento_mas_comun
FROM smart_health.patient_allergies T1
WHERE T1.diagnosed_date IS NOT NULL
GROUP BY T1.severity, EXTRACT(MONTH FROM T1.diagnosed_date), EXTRACT(YEAR FROM T1.diagnosed_date), TO_CHAR(T1.diagnosed_date, 'Mon')
ORDER BY EXTRACT(YEAR FROM T1.diagnosed_date) DESC, EXTRACT(MONTH FROM T1.diagnosed_date) DESC, severidad ASC;

-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################