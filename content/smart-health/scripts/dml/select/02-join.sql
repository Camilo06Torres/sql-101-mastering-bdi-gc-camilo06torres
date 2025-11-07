-- 3️⃣ La tercera consulta obtiene el listado de municipios y sus respectivos departamentos, uniendo ambas tablas mediante 
--la clave foránea department_code. Se ordena por el nombre del departamento para facilitar la localización geográfica, 
--mostrando los 15 primeros resultados.

--INNER JOIN
--1.tablas asosiadas
--smart_health.municipalities
--smart_health.departments

--2.llaves de cruce
--t1.department_code
--t2.department_code

SELECT
    T1.municipality_code AS codigo_municio,
    T1.municipality_name AS municipio,
    T2.department_name AS departamento
FROM municipalities T1
INNER JOIN departments T2 ON T1.department_code = T2.department_code
ORDER BY T2.department_name
LIMIT 15;

--contar los pacientes que tengan o no tengan un numero de telefono asociado
--RIGHT JOIN
--1.tablas asosiadas
--smart_health.patients T1
--smart_health.patient_phones T2

--2.llaves de cruce
--t1.patient_id
--t2.patient_id

SELECT
    COUNT(DISTINCT T1.patient_id)
FROM patient_phones T1
RIGHT JOIN patients T2 ON T1.patient_id = T2.patient_id;

--contar los doctores que no tienen especialidad
--LEFT JOIN
--1.tablas asociadas
--smart_healt.doctors T1
--smart_healt.doctor_specialties T2

--2.llaves de cruce
--T1.doctor_id
--T2.specialty_id 
SELECT
    COUNT(*)
FROM doctor_specialties T2
LEFT JOIN doctors T1 ON T1.doctor_id = T2.doctor_id
WHERE T2.specialty_id IS NULL;

--Mostrar las citas que se haya cancelado
--entre el 20 de octubre del 2025 y el 23 de octubre del 2025.
--Adicionalmente, es importante conocer, en que cuarto se iban 
--a atender estas citas. Y la razon de la cancelacion si la hay.
--Mostrar solo los 10 primeros registros.

--LEFT JOIN
--1.tablas asosiadas
--smart_health.appointments T1
--smart_health.rooms T2

--2.llaves de cruce
--T1.room_id
--T2.room_id

SELECT
    T1.appointment_type AS tipo_cita,
    T1.status AS estado,
    T1.appointment_date AS fecha,
    T2.room_name AS sala,
    T1.reason AS razon_cancelacion
FROM appointments T1
LEFT JOIN rooms T2 ON T1.room_id = T2.room_id
WHERE T1.status = 'Cancelled'
  AND T1.appointment_date BETWEEN DATE '2025-10-20' AND DATE '2025-10-23'
ORDER BY T2.room_name
LIMIT 10;

SELECT
    COUNT(*)
FROM appointments T1
LEFT JOIN rooms T2 ON T1.room_id = T2.room_id
WHERE T1.status = 'Cancelled'
  AND T1.appointment_date BETWEEN DATE '2025-10-20' AND DATE '2025-10-23'
LIMIT 10;

--la tabla pacientes tiene un atributo llamado blood_type, tiene que mostrar los tipos de sangre (a+,o+,..)
--y tiene que contar de cada uno de los tipos de sangre
--ejemplo blood_type(o+) COUNT 32502

---------------------------------------------------------------------------------------------------
--cosultas de tarea

--1. Obtener los nombres, apellidos y número de documento de los pacientes
--junto con el nombre del tipo de documento al que pertenecen.

--INNER JOIN
--1.tablas asosiadas
--smart_health.patients T1
--smart_health.document_types T2

--2.llaves de cruce
--T1.document_type_id
--T2.document_type_id

SELECT
    T1.first_name,
    T1.middle_name,
    T1.first_surname,
    T1.second_surname,
    T1.document_number,
    T2.type_name AS tipo_documento
FROM patients T1
INNER JOIN document_types T2 ON T1.document_type_id = T2.document_type_id;


--2. Listar los nombres de los municipios y las direcciones registradas en cada uno,
--de manera que se muestren todos los municipios, incluso los que no tengan direcciones asociadas.

--LEFT JOIN
--1.tablas asosiadas
--smart_health.municipalities T1
--smart_health.addresses T2

--2.llaves de cruce
--T1.municipality_code
--T2.municipality_code

SELECT
    T1.municipality_name AS municipio,
    T2.address_line AS direccion
FROM municipalities T1
LEFT JOIN addresses T2 ON T1.municipality_code = T2.municipality_code
ORDER BY T1.municipality_name;


--3. Consultar las citas médicas junto con el nombre y apellido del médico asignado,
--filtrando solo las citas con estado "Confirmed".

--INNER JOIN
--1.tablas asosiadas
--smart_health.appointments T1
--smart_health.doctors T2

--2.llaves de cruce
--T1.doctor_id
--T2.doctor_id

SELECT
    T1.appointment_date AS fecha,
    T1.appointment_type AS tipo_cita,
    T2.first_name AS nombre_medico,
    T2.last_name AS apellido_medico
FROM appointments T1
INNER JOIN doctors T2 ON T1.doctor_id = T2.doctor_id
WHERE T1.status = 'Confirmed';


--4. Mostrar los nombres y apellidos de los pacientes junto con su dirección principal,
--de forma que aparezcan también los pacientes sin dirección registrada.

--LEFT JOIN
--1.tablas asosiadas
--smart_health.patients T1
--smart_health.patient_addresses T2
--smart_health.addresses T3

--2.llaves de cruce
--T1.patient_id = T2.patient_id
--T2.address_id = T3.address_id

SELECT
    T1.first_name,
    T1.middle_name,
    T1.first_surname,
    T1.second_surname,
    T3.address_line AS direccion_principal
FROM patients T1
LEFT JOIN patient_addresses T2 ON T1.patient_id = T2.patient_id
   AND T2.is_primary = TRUE
LEFT JOIN addresses T3 ON T2.address_id = T3.address_id;


--5. Agrupar los pacientes por tipo de sangre y mostrar la cantidad de tipos de sangre que tienen cada uno.

--GROUP BY
--1.tabla asociada
--smart_health.patients T1

--2.columna de agrupacion
--T1.blood_type

SELECT
    T1.blood_type,
    COUNT(*) AS count
FROM patients T1
GROUP BY T1.blood_type
ORDER BY count DESC;

---------------------------------------------------------------------------------------------------------------------
--consulta reto

--Obtener los nombres y apellidos de los pacientes junto con el nombre del médico que los atendió,
--la especialidad del médico, la fecha de la cita y el departamento donde reside el paciente.
--Aplicar condiciones para mostrar solo pacientes y doctores activos, citas con estado confirmado
--y limitar el resultado a los 5 registros más recientes.

--INNER JOIN múltiples tablas
--1.tablas asosiadas
--smart_health.patients T1, appointments T2, doctors T3, doctor_specialties T4, specialties T5,
--patient_addresses T6, addresses T7, municipalities T8, departments T9

--2.llaves de cruce
--T1.patient_id = T2.patient_id = T6.patient_id | T2.doctor_id = T3.doctor_id = T4.doctor_id
--T4.specialty_id = T5.specialty_id | T6.address_id = T7.address_id | T7.municipality_code = T8.municipality_code | T8.department_code = T9.department_code

SELECT
    T1.first_name, T1.middle_name, T1.first_surname, T1.second_surname,
    T3.first_name AS nombre_medico, T3.last_name AS apellido_medico,
    T5.specialty_name AS especialidad, T2.appointment_date AS fecha_cita,
    T9.department_name AS departamento
FROM patients T1
INNER JOIN appointments T2 ON T1.patient_id = T2.patient_id
INNER JOIN doctors T3 ON T2.doctor_id = T3.doctor_id
INNER JOIN doctor_specialties T4 ON T3.doctor_id = T4.doctor_id
INNER JOIN specialties T5 ON T4.specialty_id = T5.specialty_id
INNER JOIN patient_addresses T6 ON T1.patient_id = T6.patient_id AND T6.is_primary = TRUE
INNER JOIN addresses T7 ON T6.address_id = T7.address_id
INNER JOIN municipalities T8 ON T7.municipality_code = T8.municipality_code
INNER JOIN departments T9 ON T8.department_code = T9.department_code
WHERE T1.active = TRUE AND T3.active = TRUE AND T2.status = 'Confirmed' AND T4.is_active = TRUE
ORDER BY T2.appointment_date DESC, T2.creation_date DESC
LIMIT 5;
