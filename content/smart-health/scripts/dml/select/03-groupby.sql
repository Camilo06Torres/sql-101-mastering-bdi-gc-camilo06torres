-- ##################################################
-- # CONSULTAS CON AGREGACIONES - SMART HEALTH #
-- ##################################################

-- 1. Obtener el paciente con la cita más antigua registrada,
-- mostrando su nombre completo y la fecha de la cita.

-- INNER JOIN
-- smart_health.patients: PK (patient_id)
-- smart_health.appointments: FK (patient_id)
-- FILTRO: fecha mínima global
SELECT
    T1.first_name || ' ' || COALESCE(T1.middle_name, '') || ' ' ||
    T1.first_surname || ' ' || COALESCE(T1.second_surname, '') AS paciente,
    T2.appointment_date AS fecha_cita
FROM smart_health.patients T1
INNER JOIN smart_health.appointments T2
    ON T1.patient_id = T2.patient_id
WHERE T2.appointment_date = (
    SELECT MIN(appointment_date)
    FROM smart_health.appointments
)
ORDER BY paciente
LIMIT 1;


-- 2. Obtener el paciente con la cita más reciente registrada,
-- mostrando su nombre completo y la fecha de la cita.

-- INNER JOIN
-- smart_health.patients: PK (patient_id)
-- smart_health.appointments: FK (patient_id)
-- FILTRO: fecha máxima global
SELECT
    T1.first_name || ' ' || COALESCE(T1.middle_name, '') || ' ' ||
    T1.first_surname || ' ' || COALESCE(T1.second_surname, '') AS paciente,
    T2.appointment_date AS fecha_cita
FROM smart_health.patients T1
INNER JOIN smart_health.appointments T2
    ON T1.patient_id = T2.patient_id
WHERE T2.appointment_date = (
    SELECT MAX(appointment_date)
    FROM smart_health.appointments
)
ORDER BY paciente
LIMIT 1;


-- 3. Listar los 5 pacientes de mayor edad del hospital,
-- mostrando su nombre completo y la edad calculada actualmente.

-- AGREGACIÓN: AGE + DATE_PART | ORDER BY edad descendente
SELECT
    T1.first_name || ' ' || COALESCE(T1.middle_name, '') || ' ' ||
    T1.first_surname || ' ' || COALESCE(T1.second_surname, '') AS paciente,
    DATE_PART('year', AGE(CURRENT_DATE, T1.birth_date)) AS edad_anios
FROM smart_health.patients T1
WHERE T1.birth_date IS NOT NULL
ORDER BY edad_anios DESC, paciente ASC
LIMIT 5;

-- ##################################################
-- #              FIN DE CONSULTAS                  #
-- ##################################################