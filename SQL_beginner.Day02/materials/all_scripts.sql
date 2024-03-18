-- -- SQL_beginner.Day02

-- -- Exercise 00 - Move to the LEFT, move to the RIGHT
-- 	SELECT 	
-- 			name, 
-- 			rating
-- 	  FROM 	pizzeria AS p
--  LEFT JOIN	person_visits  AS pv ON p.id = pv.pizzeria_id
-- 	 WHERE 	pv.pizzeria_id IS NULL;


-- -- Exercise 01 - Find data gaps
-- -- создаём список дат, присоединяем таблицу person_visits
--    SELECT missing_date::date
-- 	 FROM GENERATE_SERIES(date '2022-01-01', '2022-01-10', '1 day') AS missing_date
-- LEFT JOIN person_visits AS pv
-- -- проводим связи и заполняем даты, когда были лица с id 1 или 2
-- 	   ON missing_date = pv.visit_date
-- 	  AND (pv.person_id = 1 OR pv.person_id = 2)
-- -- и выбираем только те даты, которые не заполнились
-- 	WHERE pv.visit_date IS NULL
--  ORDER BY missing_date;

-- -- Exercise 02 - FULL means ‘completely filled’
-- --  COALESCE для замены NULL на '-'
-- 	SELECT 	COALESCE(p.name, '-') AS person_name,
-- 		   	sub_1.visit_date AS visit_date,
-- 		   	COALESCE(piz.name, '-') AS pizzeria_name
-- 	  FROM 	person AS p
-- -- FULL JOIN для объединения таблиц "person" и "pizzeria" со всеми записями из подзапроса "sub_1"
-- -- FULL JOIN сохраняет все данные из обеих таблиц, и если нет совпадающих записей, то заполняет соответствующие значения NULL. 
-- -- Это позволяет получить полную картину посещений включая случаи, когда информация отсутствует в одной из таблиц	  
--  FULL JOIN	(
-- 			 SELECT *
-- 	   		   FROM person_visits AS pv
-- 	   		  WHERE pv.visit_date BETWEEN '2022-01-01' AND '2022-01-03'
--  	  		) AS sub_1 ON p.id = sub_1.person_id 
--  FULL JOIN pizzeria AS piz ON sub_1.pizzeria_id = piz.id
--   ORDER BY person_name, visit_date, pizzeria_name;



-- -- Exercise 03 - Reformat to CTE
-- 	 WITH	date_list AS (
-- 			-- Создаем временную таблицу с датами
-- 			SELECT missing_date::date
-- 			FROM GENERATE_SERIES(date '2022-01-01', '2022-01-10', interval '1 day') AS missing_date
-- 	      )
--    SELECT	missing_date -- Выбираем даты, которые не связаны с посещениями лиц с ID 1 или 2
-- 	 FROM 	date_list
-- LEFT JOIN (
-- 			-- Выбираем уникальные даты посещений для лиц с ID 1 или 2
-- 			SELECT DISTINCT visit_date
-- 			FROM person_visits
-- 			WHERE person_id IN (1, 2)
-- 		  ) AS pv ON date_list.missing_date = pv.visit_date
-- 	WHERE	pv.visit_date IS NULL -- Оставляем только даты, которые не связаны с посещениями лиц с ID 1 или 2
--  ORDER BY 	missing_date;


-- -- Exercise 04 - Find favourite pizzas
-- 	SELECT	
-- 			menu.pizza_name,
-- 			pizzeria.name AS pizzeria_name,
-- 			menu.price
-- 	  FROM	menu
--  LEFT JOIN	pizzeria ON pizzeria.id = menu.pizzeria_id
--  	 WHERE	menu.pizza_name = 'pepperoni pizza' OR menu.pizza_name = 'mushroom pizza'
--   ORDER BY	1, 2;
	  


-- -- Exercise 05 - Investigate Person Data
-- 	SELECT	
-- 			person.name
-- 	  FROM	person
-- 	 WHERE	person.age > 25
--   ORDER BY	1;


-- -- Exercise 06 - favourite pizzas for Denis and Anna
-- 	SELECT
--     		menu.pizza_name,
--     		piz.name AS pizzeria_name
-- 	  FROM	person_order AS po
-- 			-- Использование INNER JOIN позволяет выбирать только те заказы, 
-- 			-- у которых есть соответствующие записи в таблице меню и пиццерии
-- INNER JOIN  menu ON po.menu_id = menu.id
-- INNER JOIN  pizzeria AS piz ON menu.pizzeria_id = piz.id
-- 			-- Оставляем только заказы, сделанные Денисом или Анной
--   	 WHERE	po.person_id IN ( SELECT id FROM person WHERE name IN ('Denis', 'Anna') )
--   ORDER BY	1, 2;




-- -- Exercise 07 - Cheapest pizzeria for Dmitriy
-- 	SELECT
--     		pizzeria.name
-- 	  FROM	pizzeria
-- INNER JOIN  person_visits AS pv ON pv.pizzeria_id = pizzeria.id
-- INNER JOIN  person ON person.id = pv.person_id
-- 	 WHERE	pv.visit_date = '2022-01-08'
-- 	   AND	person.name = 'Dmitriy';
-- -- проверка сделок на дату
-- -- 	SELECT
-- --     		person_order.order_date,
-- -- 			person.name
-- -- 	  FROM	person_order
-- -- 	  JOIN	person ON person.id = person_order.person_id
-- -- 	 WHERE	person_order.order_date = '2022-01-08'
-- -- то есть Денис пришёл в пиццерию, походил там, но ничего не заказывал



-- -- Exercise 08 - Continuing to research data
-- 	SELECT	person.name
-- 	  FROM	person
--  	  JOIN	person_order AS p_o ON p_o.person_id = person.id
--  	  JOIN	menu ON menu.id = p_o.menu_id
-- 	 WHERE	person.gender = 'male'
-- 	   AND	person.address IN ('Moscow', 'Samara')
-- 	   AND	menu.pizza_name IN ('pepperoni pizza', 'mushroom pizza')
--   ORDER BY	1 DESC;



-- -- Exercise 09 - Who loves cheese and pepperoni?
-- 	SELECT	name
-- 	  FROM	person
-- 	 WHERE	gender = 'female'
-- 	 		-- EXISTS используется для проверки наличия хотя бы одной строки, удовлетворяющей условиям подзапроса 
-- 	   		-- проверяем, существует ли заказ пиццы пепперони для каждой женщины
-- 	   AND	EXISTS (
-- 		   		SELECT 1 FROM person_order AS p_o 
-- 				JOIN menu ON p_o.menu_id = menu.id 
-- 				WHERE p_o.person_id = person.id 
-- 				AND menu.pizza_name = 'pepperoni pizza'
-- 	   		)
-- 			-- аналогично проверяем заказ сырной пиццы 
-- 	   AND	EXISTS (
-- 				SELECT 1 FROM person_order AS p_o 
-- 				JOIN menu ON p_o.menu_id = menu.id 
-- 				WHERE p_o.person_id = person.id 
-- 				AND menu.pizza_name = 'cheese pizza'
-- 			)
--   ORDER BY	1;



-- -- Exercise 10 - Find persons from one city
-- 	  SELECT	
-- 				DISTINCT p1.name AS person_name1,
-- 				p2.name AS person_name2,
-- 				p1.address AS common_address
-- 		FROM	person AS p1
-- 				-- p1.id > p2.id чтобы исключить дублирование строк , ограничив выборку уникальными сочетаниями
-- 		JOIN	person AS p2 ON p1.address = p2.address AND p1.id > p2.id
-- 	ORDER BY	1, 2, 3;













