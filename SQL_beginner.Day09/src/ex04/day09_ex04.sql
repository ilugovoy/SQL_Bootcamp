-- функция для возврата женщин
CREATE OR REPLACE FUNCTION fnc_persons_female() RETURNS TABLE (
         id BIGINT,
       name VARCHAR,
        age INT,
     gender VARCHAR,
    address VARCHAR
) AS $$
    SELECT id, name , age, gender, address
    FROM person
	WHERE person.gender = 'female';
$$ LANGUAGE SQL;

-- функция для возврата мужчин
CREATE OR REPLACE FUNCTION fnc_persons_male() RETURNS TABLE (
         id BIGINT,
       name VARCHAR,
        age INT,
     gender VARCHAR,
    address VARCHAR
) AS $$
    SELECT id, name, age, gender, address
    FROM person
	WHERE person.gender = 'male';
$$ LANGUAGE SQL;

-- вызов функции с фильтром по женщинам
SELECT *
FROM fnc_persons_female();

-- вызов с фильтром по мужчинам
SELECT *
FROM fnc_persons_male();
