-- ##################################################
-- # CONSULTAS UPPER, LOWER, CONCAT, LENGTH, SUBSTRING - SMART HEALTH #
-- ##################################################

-- 1. Mostrar el nombre completo de todos los pacientes en mayúsculas,
-- junto con la longitud total de su nombre completo,
-- ordenados por la longitud del nombre de mayor a menor.
-- Dificultad: BAJA

SELECT
    UPPER(first_name||' '||COALESCE(middle_name, '')||' '||first_surname||' '||COALESCE(second_surname, '')) AS nombre_completo_mayusculas,
    LENGTH(first_name||' '||COALESCE(middle_name, '')||' '||first_surname||' '||COALESCE(second_surname, '')) AS longitud_nombre
FROM smart_health.patients
ORDER BY longitud_nombre DESC
LIMIT 10;

-- 2. Listar todos los médicos mostrando su nombre en minúsculas,
-- su apellido en mayúsculas, y el correo electrónico profesional
-- con el dominio extraído después del símbolo '@'.
-- Dificultad: BAJA

SELECT
    LOWER(first_name) AS nombre_minusculas,
    UPPER(last_name) AS apellido_mayusculas,
    SUBSTRING(professional_email FROM POSITION('@' IN professional_email) + 1) AS dominio_email
FROM smart_health.doctors
ORDER BY first_name ASC
LIMIT 10;

-- 3. Obtener los nombres comerciales de todos los medicamentos en formato título
-- (primera letra mayúscula), junto con las primeras 3 letras del código ATC,
-- y la longitud del principio activo.
-- Dificultad: BAJA-INTERMEDIA

SELECT
    INITCAP(commercial_name) AS nombre_comercial_titulo,
    SUBSTRING(atc_code, 1, 3) AS primeras_3_letras_atc,
    LENGTH(active_ingredient) AS longitud_principio_activo
FROM smart_health.medications
ORDER BY commercial_name ASC
LIMIT 10;

-- 4. Mostrar el nombre completo de los pacientes concatenado con su tipo de documento,
-- las iniciales del paciente en mayúsculas (primera letra del nombre y apellido),
-- y los últimos 4 dígitos de su número de documento.
-- Dificultad: INTERMEDIA

SELECT
    first_name||' '||COALESCE(middle_name, '')||' '||first_surname||' '||COALESCE(second_surname, '')||' - '||T2.type_name AS nombre_completo_tipo_documento,
    UPPER(SUBSTRING(first_name, 1, 1)||SUBSTRING(first_surname, 1, 1)) AS iniciales_mayusculas,
    RIGHT(document_number, 4) AS ultimos_4_digitos
FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id
ORDER BY first_name ASC
LIMIT 10;

-- 5. Listar las especialidades médicas mostrando el nombre en mayúsculas,
-- los primeros 10 caracteres de la descripción, la longitud total de la descripción,
-- y un código generado con las primeras 3 letras de la especialidad en mayúsculas.
-- Dificultad: INTERMEDIA

SELECT
    UPPER(specialty_name) AS nombre_especialidad_mayusculas,
    SUBSTRING(COALESCE(description, ''), 1, 10) AS primeros_10_caracteres_descripcion,
    LENGTH(COALESCE(description, '')) AS longitud_total_descripcion,
    UPPER(SUBSTRING(specialty_name, 1, 3)) AS codigo_generado
FROM smart_health.specialties
ORDER BY specialty_name ASC;

-- 6. Obtener información de las citas mostrando el nombre del paciente en formato título,
-- el tipo de cita en minúsculas, el motivo con solo los primeros 20 caracteres,
-- y un código de referencia concatenando el ID de la cita con las iniciales del doctor.
-- Dificultad: INTERMEDIA-ALTA

SELECT
    INITCAP(T2.first_name||' '||COALESCE(T2.middle_name, '')||' '||T2.first_surname||' '||COALESCE(T2.second_surname, '')) AS nombre_paciente_titulo,
    LOWER(T1.appointment_type) AS tipo_cita_minusculas,
    SUBSTRING(COALESCE(T1.reason, ''), 1, 20) AS motivo_primeros_20_caracteres,
    T1.appointment_id||'-'||UPPER(SUBSTRING(T3.first_name, 1, 1)||SUBSTRING(T3.last_name, 1, 1)) AS codigo_referencia
FROM smart_health.appointments T1
INNER JOIN smart_health.patients T2
    ON T1.patient_id = T2.patient_id
INNER JOIN smart_health.doctors T3
    ON T1.doctor_id = T3.doctor_id
ORDER BY T1.appointment_date DESC
LIMIT 10;

-- 7. Mostrar las direcciones completas concatenando todos sus componentes,
-- el código del municipio en mayúsculas, los primeros 5 caracteres de la línea de dirección,
-- la longitud de la dirección completa, y el código postal formateado en minúsculas,
-- junto con el nombre del municipio y departamento en formato título.
-- Dificultad: ALTA

SELECT
    T1.address_line||', '||T2.municipality_name||', '||T3.department_name AS direccion_completa,
    UPPER(T1.municipality_code) AS codigo_municipio_mayusculas,
    SUBSTRING(T1.address_line, 1, 5) AS primeros_5_caracteres_direccion,
    LENGTH(T1.address_line) AS longitud_direccion,
    LOWER(COALESCE(T1.postal_code, '')) AS codigo_postal_minusculas,
    INITCAP(T2.municipality_name) AS nombre_municipio_titulo,
    INITCAP(T3.department_name) AS nombre_departamento_titulo
FROM smart_health.addresses T1
INNER JOIN smart_health.municipalities T2
    ON T1.municipality_code = T2.municipality_code
INNER JOIN smart_health.departments T3
    ON T2.department_code = T3.department_code
ORDER BY T1.address_line ASC
LIMIT 10;

-- ##################################################
-- #                 END OF QUERIES                 #
-- ##################################################