-- Заказ Дениса
INSERT INTO person_order (id, person_id, menu_id, order_date)
	 VALUES (
		 	(SELECT MAX(id) FROM person_order) + 1,
	 		(SELECT id FROM person WHERE name = 'Denis'), 
			(SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'), 
			'2022-02-24');
-- Заказ Ирины
INSERT INTO person_order (id, person_id, menu_id, order_date)
	 VALUES (
				(SELECT MAX(id) FROM person_order) + 2,
				(SELECT id FROM person WHERE name = 'Irina'), 
				(SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'), 
				'2022-02-24'
			);
-- проверяем, что добавление успешно
SELECT *
  FROM person_order
 WHERE order_date = '2022-02-24';
