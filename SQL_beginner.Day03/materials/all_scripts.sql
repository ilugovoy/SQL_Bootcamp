-- -- Exercise 00 - Let’s find appropriate prices for Kate
-- 		SELECT	
-- 				menu.pizza_name,
-- 				menu.price,
-- 				pizzeria.name AS pizzeria_name, 
-- 				person_visits.visit_date
-- 		  FROM	menu
-- 		  JOIN	pizzeria	ON	pizzeria.id = menu.pizzeria_id
-- 		  JOIN	person_visits	ON	person_visits.pizzeria_id = pizzeria.id
-- 		  JOIN	person 	ON	person.id = person_visits.person_id
-- 		 WHERE	person.name = 'Kate' AND menu.price BETWEEN 800 AND 1000
-- 	  ORDER BY	1, 2, 3
		  
-- -- Exercise 01: Let’s find forgotten menus			  
-- 		SELECT	menu.id AS menu_id
-- 		  FROM	menu
-- 		 WHERE	menu.id NOT IN (SELECT menu_id FROM person_order)
-- 	  ORDER BY	1;
	  
	  
-- -- Exercise 02: Let’s find forgotten pizza and pizzerias
-- 		SELECT	
-- 				menu.pizza_name,
-- 				menu.price,
-- 				pizzeria.name AS pizzeria_name
-- 		 FROM	menu
-- 		 JOIN	pizzeria	ON	pizzeria.id = menu.pizzeria_id
-- 		 WHERE	menu.id NOT IN (SELECT menu_id FROM person_order)
-- 	  ORDER BY	1, 2;



-- -- Exercise 03: Let’s compare visits	
-- 		SELECT	pizzeria.name AS pizzeria_name
-- 		  FROM	pizzeria
-- 		 WHERE	pizzeria.id IN (
-- 				SELECT female_choice.pizzeria_id
-- 				FROM (
-- 					-- выбираем посещения только женщин
-- 					SELECT COUNT(person_id) AS count, pizzeria_id
-- 					FROM person_visits
-- 					WHERE person_id IN (SELECT id FROM person WHERE gender = 'female')
-- 					GROUP BY pizzeria_id
-- 				)	AS female_choice
-- 				INNER JOIN (
-- 					-- аналогично для мужчин
-- 					SELECT COUNT(person_id) AS count, pizzeria_id
-- 					FROM person_visits
-- 					WHERE person_id IN (SELECT id FROM person WHERE gender = 'male')
-- 					GROUP BY pizzeria_id
-- 					-- соединяем результаты посещений мужчин и женщин по идентификатору пиццерии
-- 				)	AS male_choice ON female_choice.pizzeria_id = male_choice.pizzeria_id 
-- 			 	-- выбираем только пиццерии, где количество посещений мужчин и женщин отличается
-- 				WHERE female_choice.count <> male_choice.count
-- 			)
-- 	 ORDER BY	1;

		
		
-- -- Exercise 04: Let’s compare orders 	
-- 	  WITH 	male_pizzerias AS (
-- 		  		-- выбор уникальных pizzeria_id, в которых делали заказы только мужчины
-- 				SELECT DISTINCT pizzeria_id
-- 				FROM menu
-- 				JOIN person_order ON menu_id = menu.id
-- 				JOIN person ON person_order.person_id = person.id
-- 				WHERE person.gender = 'male'
-- 			),
-- 			female_pizzerias AS (
-- 				-- аналогично для женщин
-- 				SELECT DISTINCT pizzeria_id
-- 				FROM menu
-- 				JOIN person_order ON menu_id = menu.id
-- 				JOIN person ON person_order.person_id = person.id
-- 				WHERE person.gender = 'female'
-- 			)

-- 	-- Основной запрос для выбора названий пиццерий, удовлетворяющих условиям
-- 	SELECT	pizzeria.name AS pizzeria_name
-- 	  FROM	pizzeria
-- 	  		-- выбираем только ту пиццерию, в заказы были сделаны только лицами одного пола (только мужчинами или только женщинами)
-- 	 WHERE	pizzeria.id IN (
-- 		 		-- Выбрать названия пиццерий, в которых только мужчины делали заказы
-- 				SELECT pizzeria_id
-- 				FROM male_pizzerias
-- 				EXCEPT -- чтобы исключить из male_pizzerias те пиццерии, где заказы делали и женщины
-- 				SELECT pizzeria_id
-- 				FROM female_pizzerias
-- 			)
-- 		OR	pizzeria.id IN (
-- 				-- аналогично для женщин
-- 				SELECT pizzeria_id
-- 				FROM female_pizzerias
-- 				EXCEPT -- чтобы исключить из female_pizzerias те пиццерии, где заказы делали и мужчины
-- 				SELECT pizzeria_id
-- 				FROM male_pizzerias
-- 			)
--   ORDER BY	pizzeria_name;



-- -- Exercise 05: Visited but did not make any order	
-- 	SELECT	pizzeria.name AS pizzeria_name
-- 	  FROM	pizzeria
-- 	  JOIN	person_visits AS p_v	ON	p_v.pizzeria_id = pizzeria.id
-- 	  JOIN	person	ON person.id = p_v.person_id
-- 	 WHERE	person.name = 'Andrey' 
-- 	   AND	person.id NOT IN (
-- 				SELECT pizzeria_id
-- 				  FROM person_order
-- 				 WHERE person_id = person.id
--     		)
--   ORDER BY	1;



-- -- Exercise 06: Find price-similarity pizzas
-- WITH pizzas AS (
-- 	SELECT  -- временная таблица "pizzas" с информацией о названии пиццы, пиццерии и цене
-- 			menu.pizza_name,
-- 			pizzeria.name AS pizzeria_name,
-- 			menu.price
-- 	  FROM 	menu
-- 	  JOIN 	pizzeria ON pizzeria.id = menu.pizzeria_id
-- )

-- 	SELECT  -- основной запрос
-- 			p1.pizza_name,
-- 			p1.pizzeria_name AS pizzeria_name_1,
-- 			p2.pizzeria_name AS pizzeria_name_2,
-- 			p1.price
-- 	FROM	pizzas AS p1
-- 	JOIN	pizzas AS p2 ON p1.price = p2.price -- Соединение по цене
-- 	 AND	p1.pizza_name = p2.pizza_name -- Соединение по названию пиццы
-- 	 AND	p1.pizzeria_name < p2.pizzeria_name -- Исключение повторяющихся комбинаций
-- ORDER BY	1;



-- Exercise 07: Let’s cook a new type of pizza	
INSERT INTO	menu (id, pizzeria_id, pizza_name, price)
	 VALUES	(19, 2, 'greek pizza', 800);

-- проверяем, что добавление успешно
	 SELECT	*
	   FROM	menu
	  WHERE	pizza_name = 'greek pizza';




-- Exercise 08: Let’s cook a new type of pizza with more dynamics	
INSERT INTO	menu (id, pizzeria_id, pizza_name, price)
	 -- находим максимальное значение id в таблице menu и ++ его
	 VALUES ((SELECT MAX(id) FROM menu) + 1,
	 -- извлекаем идентификатор ресторана "Dominos" из таблицы pizzeria для записи
	(SELECT id FROM pizzeria WHERE name = 'Dominos'), 'sicilian pizza', 900);

-- проверяем, что добавление успешно
	 SELECT	*
	   FROM	menu
	  WHERE	pizza_name = 'sicilian pizza';




-- -- Exercise 09: New pizza means new visits

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




-- Exercise 10: New visits means new orders

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




-- Exercise 11: “Improve” a price for clients
	UPDATE	menu
	   SET	price = price * 0.9
	 WHERE	pizza_name = 'greek pizza';

-- проверяем, что обновление успешно
	 SELECT	*
	   FROM	menu
	  WHERE	pizza_name = 'greek pizza';



-- Exercise 12: New orders are coming!		
WITH new_ids AS (
  SELECT 
	-- Генерируем уникальные id
	-- для генерации id мы используем функцию GENERATE_SERIES для создания последовательности чисел от (MAX(id) + 1) в таблице person_order 
	-- до (MAX(id) + COUNT()), где COUNT() подсчитывает общее количество записей в таблице person_order 
	-- так мы получаем уникальные значения id для вставки новых записей  
	GENERATE_SERIES(
		-- 
		(SELECT MAX(id) + 1 FROM person_order),
		(SELECT MAX(id) + (SELECT COUNT(*) FROM person) FROM person_order)
	) AS id,
	-- Генерируем уникальные значения person_id
	-- в диапазоне от минимального id в person до (MIN(id) + COUNT())
	GENERATE_SERIES(
		(SELECT MIN(id) FROM person),
		-- '-1' используется для указание последнего значения в этой последовательности
		(SELECT MIN(id) + (SELECT COUNT(*) FROM person) - 1 FROM person)
	) AS person_id
)
-- вставляем новые записи в таблицу person_order с использованием сгенерированных значений id и person_id
INSERT INTO person_order (id, person_id, menu_id, order_date)
	 SELECT 
  			n.id, -- Выбираем сгенерированные уникальные значения id
  			n.person_id, -- Выбираем сгенерированные уникальные значения person_id
  			(SELECT id FROM menu WHERE pizza_name = 'greek pizza'),
  			'2022-02-25'
	   FROM new_ids AS n;  -- Используем временную таблицу new_ids для вставки
	  
-- проверяем, что добавление успешно
SELECT *
  FROM person_order
 WHERE order_date = '2022-02-25';


-- Exercise 13: Money back to our customers
DELETE	FROM person_order
 WHERE	order_date = '2022-02-25';

DELETE	FROM menu
 WHERE	pizza_name = 'greek pizza';




		
		
		
		
		
		