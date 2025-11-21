--4 listar todos los pacientes que tienen alergias registradas
--pero que no tienen prescripciones medicas activas,
--mostrando el ID del paciente, nombre completo,
--tipo de sangre y cantidad de alergias,
--utilizando EXCEPT para excluir aquellos con prescripciones.
-- DIFICULTAD: INTERMEDIA






-- psql function

CREATE OR REPLACE FUNCTION smart_health.obtener_edad_paciente(
    p_id INTEGER)
    RETURNS INTEGER
    LANGUAGE plpgsql
    AS
$$
DECLARE 
    v_age INTEGER :=0 ;
BEGIN
    SELECT 
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date))
        INTO v_age
        FROM smart_health.patients
            WHERE patient_id = p_id;
        RETURN COALESCE(v_age,0);
END;

$$


--SELECT 
--    patient_id,
--    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS AGE
--    FROM smart_health.patients
--    WHERE patient_id = p_id;