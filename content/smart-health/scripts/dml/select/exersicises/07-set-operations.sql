SELECT 'orders' AS TABLA, COUNT(*) AS TOTAL_RECORDS FROM smart_health.orders
UNION
SELECT 'payments' AS TABLA, COUNT(*) AS TOTAL_RECORDS FROM smart_health.payments
UNION
SELECT 'patients' AS TABLA, COUNT(*) AS TOTAL_RECORDS FROM smart_health.patients
UNION
SELECT 'doctors' AS TABLA, COUNT(*) AS TOTAL_RECORDS FROM smart_health.doctors;

-- string_agg('alejo,carlos,d')

-- 07-set-operations.sql

SELECT
    'Dr. '||T1.first_name||' '||T1.last_name AS doctor
FROM smart_health.doctors T1
INNER JOIN smart_health.doctor_specialties T2
    ON T1.doctor_id = T2.doctor_id
INNER JOIN smart_health.specialties T3 
    ON T2.specialty_id = T3.specialty_id
WHERE T3.specialty_name LIKE '%Medicina de emergencia%'

INTERSECT

SELECT
    'Dr. '||T1.first_name||' '||T1.last_name AS doctor
FROM smart_health.doctors T1
INNER JOIN smart_health.doctor_specialties T2
    ON T1.doctor_id = T2.doctor_id
INNER JOIN smart_health.specialties T3 
    ON T2.specialty_id = T3.specialty_id
WHERE T3.specialty_name LIKE '%Auditoría médica%';

-- 4. Listar todos los pacientes que tienen alergias registradas
-- pero que NO tienen prescripciones médicas activas,
-- mostrando el ID del paciente, nombre completo, 
-- tipo de sangre y cantidad de alergias,
-- utilizando EXCEPT para excluir aquellos con prescripciones.
-- Dificultad: INTERMEDIA


---- psql functions

CREATE OR REPLACE FUNCTION smart_health.obtener_edad_paciente(
    p_id INTEGER)
    RETURNS INTEGER
    LANGUAGE plpgsql
    AS
$$
DECLARE
    v_age INTEGER := 0;
BEGIN
    SELECT
        EXTRACT (YEAR FROM AGE(CURRENT_DATE, birth_date))
        INTO v_age
    FROM smart_health.patients
        WHERE patient_id = p_id;
    RETURN COALESCE(v_age, 0);
END;
$$;

SELECT
    patient_id,
    birth_date,
    smart_health.obtener_edad_paciente(patient_id)

FROM smart_health.patients
LIMIT 5;



-- SELECT
--     patient_id,
--     EXTRACT (YEAR FROM AGE(CURRENT_DATE, birth_date)) AS AGE
-- FROM smart_health.patients
-- WHERE patient_id = 1;

-- ##################################################
-- # CONSULTAS SET OPERATIONS - SMART HEALTH #
-- ##################################################

-- 1. Obtener una lista combinada de todos los nombres únicos
-- de pacientes y doctores en el sistema, mostrando el nombre completo
-- y el tipo de registro (Paciente o Doctor),
-- ordenados alfabéticamente por nombre completo.
-- Dificultad: BAJA

SELECT
    COALESCE(T1.first_name || ' ' || COALESCE(T1.middle_name || ' ', '') || T1.first_surname || ' ' || COALESCE(T1.second_surname, ''), '') AS nombre_completo,
    'Paciente' AS tipo_registro
FROM smart_health.patients T1

UNION

SELECT
    COALESCE(T2.first_name || ' ' || T2.last_name, '') AS nombre_completo,
    'Doctor' AS tipo_registro
FROM smart_health.doctors T2

ORDER BY nombre_completo ASC;

-- 2. Listar todos los municipios que tienen tanto pacientes como doctores registrados,
-- mostrando el código del municipio, el nombre del municipio y el nombre del departamento,
-- utilizando INTERSECT para encontrar solo los municipios con ambos tipos de usuarios.
-- Dificultad: BAJA-INTERMEDIA

SELECT
    T3.municipality_code AS codigo_municipio,
    T3.municipality_name AS nombre_municipio,
    T4.department_name AS nombre_departamento
FROM smart_health.patient_addresses T1
INNER JOIN smart_health.addresses T2
    ON T1.address_id = T2.address_id
INNER JOIN smart_health.municipalities T3
    ON T2.municipality_code = T3.municipality_code
INNER JOIN smart_health.departments T4
    ON T3.department_code = T4.department_code

INTERSECT

SELECT
    T3.municipality_code AS codigo_municipio,
    T3.municipality_name AS nombre_municipio,
    T4.department_name AS nombre_departamento
FROM smart_health.doctor_addresses T1
INNER JOIN smart_health.addresses T2
    ON T1.address_id = T2.address_id
INNER JOIN smart_health.municipalities T3
    ON T2.municipality_code = T3.municipality_code
INNER JOIN smart_health.departments T4
    ON T3.department_code = T4.department_code

ORDER BY codigo_municipio ASC;

-- 3. Obtener una lista unificada de todos los IDs de pacientes
-- que aparecen en citas o en órdenes de pago,
-- mostrando el ID del paciente, nombre completo y correo electrónico,
-- eliminando duplicados y ordenados por ID de paciente.
-- Dificultad: BAJA

SELECT DISTINCT
    T1.patient_id AS id_paciente,
    COALESCE(T1.first_name || ' ' || COALESCE(T1.middle_name || ' ', '') || T1.first_surname || ' ' || COALESCE(T1.second_surname, ''), '') AS nombre_completo,
    T1.email AS correo_electronico
FROM smart_health.patients T1
INNER JOIN smart_health.appointments T2
    ON T1.patient_id = T2.patient_id

UNION

SELECT DISTINCT
    T1.patient_id AS id_paciente,
    COALESCE(T1.first_name || ' ' || COALESCE(T1.middle_name || ' ', '') || T1.first_surname || ' ' || COALESCE(T1.second_surname, ''), '') AS nombre_completo,
    T1.email AS correo_electronico
FROM smart_health.patients T1
INNER JOIN smart_health.orders T3
    ON T1.patient_id = T3.patient_id

ORDER BY id_paciente ASC;

-- 4. Listar todos los pacientes que tienen alergias registradas
-- pero que NO tienen prescripciones médicas activas,
-- mostrando el ID del paciente, nombre completo, tipo de sangre y cantidad de alergias,
-- utilizando EXCEPT para excluir aquellos con prescripciones.
-- Dificultad: INTERMEDIA

SELECT
    T1.patient_id AS id_paciente,
    COALESCE(T1.first_name || ' ' || COALESCE(T1.middle_name || ' ', '') || T1.first_surname || ' ' || COALESCE(T1.second_surname, ''), '') AS nombre_completo,
    T1.blood_type AS tipo_sangre,
    COUNT(T2.patient_allergy_id) AS cantidad_alergias
FROM smart_health.patients T1
INNER JOIN smart_health.patient_allergies T2
    ON T1.patient_id = T2.patient_id
GROUP BY T1.patient_id, T1.first_name, T1.middle_name, T1.first_surname, T1.second_surname, T1.blood_type

EXCEPT

SELECT
    T1.patient_id AS id_paciente,
    COALESCE(T1.first_name || ' ' || COALESCE(T1.middle_name || ' ', '') || T1.first_surname || ' ' || COALESCE(T1.second_surname, ''), '') AS nombre_completo,
    T1.blood_type AS tipo_sangre,
    COUNT(DISTINCT T2.patient_allergy_id) AS cantidad_alergias
FROM smart_health.patients T1
INNER JOIN smart_health.patient_allergies T2
    ON T1.patient_id = T2.patient_id
WHERE EXISTS (
    SELECT 1
    FROM smart_health.medical_records T3
    INNER JOIN smart_health.prescriptions T4
        ON T3.medical_record_id = T4.medical_record_id
    WHERE T3.patient_id = T1.patient_id
        AND T4.prescription_date >= CURRENT_DATE - INTERVAL '30 days'
)
GROUP BY T1.patient_id, T1.first_name, T1.middle_name, T1.first_surname, T1.second_surname, T1.blood_type

ORDER BY id_paciente ASC;

-- 5. Obtener una lista combinada de todos los métodos de pago utilizados
-- y todos los tipos de citas registradas en el sistema,
-- mostrando el nombre del concepto, el tipo (Método de Pago o Tipo de Cita),
-- y un contador de cuántas veces aparece cada uno,
-- ordenados primero por tipo y luego por cantidad descendente.
-- Dificultad: INTERMEDIA-ALTA

SELECT
    T1.payment_name AS concepto,
    'Método de Pago' AS tipo,
    COUNT(T2.payment_id) AS cantidad
FROM smart_health.payment_methods T1
LEFT JOIN smart_health.payments T2
    ON T1.payment_method_id = T2.payment_method_id
GROUP BY T1.payment_method_id, T1.payment_name

UNION ALL

SELECT
    T3.appointment_type AS concepto,
    'Tipo de Cita' AS tipo,
    COUNT(T3.appointment_id) AS cantidad
FROM smart_health.appointments T3
GROUP BY T3.appointment_type

ORDER BY tipo ASC, cantidad DESC;


-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################