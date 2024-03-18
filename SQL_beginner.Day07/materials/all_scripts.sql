-- Day 07
-- Exercise 00: Simple aggregated information	

--   SELECT person_id, COUNT(*) AS count_of_visits -- подсчет количества посещений для каждого person_id
--     FROM person_visits
-- GROUP BY person_id
-- ORDER BY count_of_visits DESC, person_id ASC;


-- Exercise 01: Let’s see real names	
--   SELECT person.name, COUNT(*) AS count_of_visits -- подсчет количества посещений для каждого person_id
--     FROM person_visits
-- 	JOIN person ON person.id = person_visits.person_id
-- GROUP BY person.name, person_visits.person_id
-- ORDER BY count_of_visits DESC, person.name
--    LIMIT 4;




-- Exercise 02: Restaurants statistics

-- SELECT name, count, action_type
-- FROM (
--     SELECT p.name AS name, COUNT(*) AS count, 'visit' AS action_type
--     FROM person_visits pv
--     JOIN pizzeria p ON p.id = pv.pizzeria_id
--     GROUP BY p.name

--     UNION ALL

--     SELECT p.name AS name, COUNT(*) AS count, 'order' AS action_type
--     FROM person_order po
--     JOIN menu m ON m.id = po.menu_id
--     JOIN pizzeria p ON p.id = m.pizzeria_id
--     GROUP BY p.name
-- ) combined_data
-- ORDER BY action_type ASC, count DESC;




-- Exercise 03: Restaurants statistics #2	

-- WITH combined_data AS (
--     -- выбираем название пиццерии из таблицы person_visits и считаем количество посещений
--     SELECT p.name AS name, COUNT(*) AS total_count
--     FROM person_visits pv
--     JOIN pizzeria p ON p.id = pv.pizzeria_id
--     GROUP BY p.name
    
--     UNION ALL
    
--     -- выбираем название пиццерии из таблицы person_order, связываем через меню и считаем количество заказов
--     SELECT p.name AS name, COUNT(*) AS total_count
--     FROM person_order po
--     JOIN menu m ON m.id = po.menu_id
--     JOIN pizzeria p ON p.id = m.pizzeria_id
--     GROUP BY p.name
-- )

-- -- выбираем название пиццерии и суммируем общее количество (посещений и заказов), группируем по названию пиццерии
-- SELECT name, SUM(total_count) AS total_count
-- FROM combined_data
-- GROUP BY name
-- ORDER BY total_count DESC, name ASC;





-- Exercise 04: Clause for groups

--    SELECT p.name AS name, COUNT(*) AS count_of_visits
-- 	 FROM person_visits pv
-- 	 JOIN person AS p ON p.id = pv.person_id
--  GROUP BY p.name
--    HAVING COUNT(*) > 3;




-- Exercise 05: Person's uniqueness	

-- SELECT DISTINCT p.name
-- FROM person p
-- JOIN person_order po ON p.id = po.person_id
-- ORDER BY p.name;





-- Exercise 06: Restaurant metrics	

--   SELECT 
-- 			p.name AS name, 
-- 			COUNT(po.id) AS count_of_orders, 
-- 			ROUND(AVG(m.price), 2) AS average_price, 
-- 			MAX(m.price) AS max_price, 
-- 			MIN(m.price) AS min_price
--     FROM 	pizzeria p
--     JOIN 	menu m ON p.id = m.pizzeria_id
--     JOIN 	person_order po ON m.id = po.menu_id
-- GROUP BY 	p.name
-- ORDER BY 	p.name;




-- Exercise 07: Average global rating

-- SELECT ROUND(AVG(rating), 4) AS global_rating
-- FROM pizzeria;




-- Exercise 08: Find pizzeria’s restaurant locations

--   SELECT p.address, pz.name, COUNT(po.id) AS count_of_orders
--     FROM person p
--     JOIN person_order po ON p.id = po.person_id
--     JOIN menu m ON po.menu_id = m.id
--     JOIN pizzeria pz ON m.pizzeria_id = pz.id
--    WHERE p.address = p.address
-- GROUP BY p.address, pz.name
-- ORDER BY p.address, pz.name;




-- Exercise 09: Explicit type transformation

--   SELECT 
-- 			DISTINCT address,
-- 			ROUND(MAX(age::numeric) - (MIN(age::numeric) / MAX(age::numeric)), 2) AS formula,
-- 			ROUND(AVG(age::numeric), 2) AS average,
-- 			(MAX(age::numeric) - (MIN(age::numeric) / MAX(age::numeric))) > AVG(age::numeric) AS comparison
--     FROM 	person
-- GROUP BY 	address
-- ORDER BY 	address;









