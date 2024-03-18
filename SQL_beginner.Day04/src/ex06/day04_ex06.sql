CREATE MATERIALIZED VIEW	mv_dmitriy_visits_and_eats 
AS
	SELECT	pizzeria.name
	  FROM
			pizzeria
			INNER JOIN person_visits AS pv ON pv.pizzeria_id = pizzeria.id
			INNER JOIN person ON person.id = pv.person_id
	 WHERE
			person.name = 'Dmitriy'
			AND pv.visit_date = '2022-01-08';

SELECT * FROM mv_dmitriy_visits_and_eats;
