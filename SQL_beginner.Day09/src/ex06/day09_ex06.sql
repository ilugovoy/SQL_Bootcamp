-- создание функции PL/pgSQL fnc_person_visits_and_eats_on_date
CREATE OR REPLACE FUNCTION fnc_person_visits_and_eats_on_date
	(
			IN pperson VARCHAR DEFAULT 'Dmitriy', 
			IN pprice NUMERIC DEFAULT 500, 
			IN pdate DATE DEFAULT '2022-01-08'
	) 
	RETURNS VARCHAR AS $$
		DECLARE 
			pizzeria_name VARCHAR;  -- переменная для хранения названия пиццерии
			BEGIN
				-- выборка названия пиццерии в переменную pizzeria_name
				SELECT pizzeria.name INTO pizzeria_name
				  FROM pizzeria
				  JOIN person_visits ON person_visits.pizzeria_id = pizzeria.id
				  JOIN person ON person.id = person_id
				  JOIN menu ON menu.pizzeria_id = pizzeria.id
				 WHERE person.name = pperson AND price < pprice AND visit_date = pdate;
				
				RETURN pizzeria_name;  -- возврат названия пиццерии
			END;
$$ LANGUAGE PLPGSQL;

-- вызов функции для поиска пиццерии, где человек мог купить пиццу дешевле 800 рублей 8 января 2022 года
SELECT * FROM fnc_person_visits_and_eats_on_date(pprice := 800);

-- вызов функции для указания другого человека (Anna), суммы и даты покупки пиццы
SELECT * FROM fnc_person_visits_and_eats_on_date(pperson := 'Anna', pprice := 1300, pdate := '2022-01-01');
