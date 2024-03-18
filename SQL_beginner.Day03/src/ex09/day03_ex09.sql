-- визит Дениса
INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
	 VALUES	((SELECT MAX(id) FROM menu) + 1,
			(SELECT id FROM person WHERE name = 'Denis'), 
			(SELECT id FROM pizzeria WHERE name = 'Dominos'), '2022-02-24');

-- визит Ирины
INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
	 VALUES ((SELECT MAX(id) FROM menu) + 2,
			(SELECT id FROM person WHERE name = 'Irina'), 
			(SELECT id FROM pizzeria WHERE name = 'Dominos'), '2022-02-24');

-- проверяем, что добавление успешно
SELECT *
  FROM person_visits
 WHERE visit_date = '2022-02-24';
