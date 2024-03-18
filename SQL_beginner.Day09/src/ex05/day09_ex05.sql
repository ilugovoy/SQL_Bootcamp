-- удаление существующих функций
DROP FUNCTION IF EXISTS fnc_persons_female CASCADE;
DROP FUNCTION IF EXISTS fnc_persons_male CASCADE;

-- создание универсальной SQL-функции fnc_persons без использования PL/pgSQL
CREATE OR REPLACE FUNCTION fnc_persons(pgender VARCHAR DEFAULT 'female') RETURNS TABLE (
         id BIGINT,
       name VARCHAR,
        age INT,
     gender VARCHAR,
    address VARCHAR
) AS $$
		SELECT *
		  FROM person
		 WHERE pgender = person.gender
$$ LANGUAGE SQL;

-- вызов функции для лиц мужского пола
SELECT * FROM fnc_persons(pgender := 'male');

-- вызов функции для лиц женского пола (используется значение по умолчанию "female")
SELECT * FROM fnc_persons();
