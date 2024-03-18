INSERT INTO person_visits
	 VALUES (
			 (SELECT MAX(id) FROM person_visits) + 1,
			 (SELECT id FROM person WHERE name = 'Dmitriy'),
			 (SELECT id FROM pizzeria WHERE name = 'DoDo Pizza'),
			 '2022-01-08'
			);

-- SELECT * FROM person_visits WHERE visit_date = '2022-01-08' AND person_id = 9;

REFRESH MATERIALIZED VIEW mv_dmitriy_visits_and_eats;

SELECT * FROM mv_dmitriy_visits_and_eats;
