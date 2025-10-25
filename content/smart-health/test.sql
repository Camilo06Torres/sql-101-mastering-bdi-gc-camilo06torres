-- creacion de squema 
CREATE SCHEMA IF NOT EXISTS smart_health AUTHORIZATION camilo_gc;
-- creacion de tablas
-- 01. empleados
CREATE TABLE smart_health.empleados (
    ID SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_contratacion DATE,
    salario NUMERIC(10,2),
    es_activo BOOLEAN
);
-- 02. departamentos
CREATE TABLE smart_health.departamentos (
    ID SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE,
    presupuesto NUMERIC(10,2) CHECK(presupuesto > 0)
);
-- INSERT TEST
INSERT INTO smart_health.departamentos (nombre, presupuesto) VALUES ('RRHH', -2);
--ADD FOREING KEY TO EMPLEADOS - DEPARTAMENTOS
ALTER TABLE smart_health.empleados
ADD COLUMN departamento_id INTEGER;

ALTER TABLE smart_health.empleados
ADD CONSTRAINT departamentos_id_fk
FOREIGN KEY (departamento_id)
REFERENCES smart_health.departamentos(id);

--ADD DEFAULT FIELD TO DEPARTAMENTOS
ALTER TABLE smart_health.departamentos
ADD COLUMN fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
