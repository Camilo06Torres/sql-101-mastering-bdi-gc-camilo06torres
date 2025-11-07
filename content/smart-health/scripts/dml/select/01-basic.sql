-- 1. cuantos doctores hay, medical_license_number el nombre completo del doctor con el prefijo doctor y solamente los que estan activos
--ordenar por el primer nombre de foema desendente.
--solo mostrar los primeros 10 resultados.

SELECT 
    'Dr. ' || first_name || ' ' || last_name AS fullname,
    medical_license_number
FROM smart_health.doctors
WHERE active = TRUE
ORDER BY first_name DESC
LIMIT 10;

-- 1. Cuantos doctores hay
SELECT
    'Dr. 'first_name' '||last_name AS fullname,
    medical_license_number

FROM smart_health.doctors
WHERE active = TRUE
ORDER BY first_name
LIMIT 10;

--------------------------------------------------------------------------------------------------------------------------------------


-- 1️⃣ La primera consulta obtiene los nombres y apellidos de los pacientes registrados, 
--junto con su correo electrónico y fecha de nacimiento, ordenados por fecha de registro de manera descendente 
--para visualizar los más recientes primero. Esta consulta usa un alias para facilitar la lectura de las columnas en la salida 
--y un límite para mostrar solo los diez registros más recientes.

SELECT 
	(first_name ||
		CASE WHEN middle_name IS NOT NULL AND middle_name <> '' THEN ' ' || middle_name ELSE '' END ||
		' ' || first_surname ||
		CASE WHEN second_surname IS NOT NULL AND second_surname <> '' THEN ' ' || second_surname ELSE '' END
	) AS full_name,
	email,
	birth_date
FROM smart_health.patients
ORDER BY registration_date DESC
LIMIT 10;

-- 2️⃣ La segunda consulta selecciona los nombres completos de los médicos activos junto con su número de licencia médica, 
--ordenando alfabéticamente por apellidos. También aplica alias a las columnas para mostrar un encabezado más legible y limita
--el resultado a los primeros 20 doctores.

SELECT 
	('Dr. ' || first_name || ' ' || last_name) AS full_name,
	medical_license_number
FROM smart_health.doctors
WHERE active = TRUE
ORDER BY last_name ASC
LIMIT 20;
 
-- 3️⃣ La tercera consulta obtiene el listado de municipios y sus respectivos departamentos, uniendo ambas tablas mediante 
--la clave foránea department_code. Se ordena por el nombre del departamento para facilitar la localización geográfica, 
--mostrando los 15 primeros resultados.
 
-- 4️⃣ La cuarta consulta selecciona las citas médicas programadas (tabla appointment), mostrando el tipo de cita, 
--el estado actual y la fecha correspondiente. Se utiliza un alias para cada campo y se ordena por fecha de cita en orden ascendente, 
--limitando la salida a las próximas 10 citas.

SELECT 
	appointment_type AS type,
	status,
	appointment_date AS date
FROM smart_health.appointments
ORDER BY appointment_date ASC
LIMIT 10;
 
-- 5️⃣ Finalmente, la quinta consulta obtiene los nombres comerciales de los medicamentos junto con su ingrediente activo, 
--presentándolos de forma alfabética. Se usa alias para mejorar la presentación de los encabezados y un límite de 25 registros, 
--ideal para una vista rápida del catálogo farmacológico disponible.

SELECT 
	commercial_name,
	active_ingredient
FROM smart_health.medications
ORDER BY commercial_name ASC
LIMIT 25;

