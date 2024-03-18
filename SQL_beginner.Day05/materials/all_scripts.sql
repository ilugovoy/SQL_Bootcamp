-- Day_05
-- Exercise 00: Let’s create indexes for every foreign key	

CREATE INDEX idx_menu_pizzeria_id ON menu(pizzeria_id); 					--  menu
CREATE INDEX idx_person_visits_person_id ON person_visits(person_id); 		--  person_visits
CREATE INDEX idx_person_visits_pizzeria_id ON person_visits(pizzeria_id); 	--  person_visits
CREATE INDEX idx_person_order_person_id ON person_order(person_id); 		--  person_order
CREATE INDEX idx_person_order_menu_id ON person_order(menu_id);  			--  person_order

ANALYZE menu;
ANALYZE pizzeria;

ANALYZE person;
ANALYZE person_order;
ANALYZE person_visits;

-- Поиск всех индексов в базе данных
SELECT * FROM pg_indexes WHERE indexname LIKE 'idx_%';


-- Exercise 01: How to see that index works?

SET ENABLE_SEQSCAN TO OFF; -- выключить последовательное сканирование

EXPLAIN ANALYZE
SELECT 
		pizza_name, 
		pizzeria.name AS pizzeria_name 
  FROM 	menu
  JOIN 	pizzeria ON pizzeria.id = menu.pizzeria_id;




-- Exercise 02: Formula is in the index. Is it Ok?

CREATE INDEX idx_person_name ON person(UPPER(name));
ANALYZE person;
SELECT * FROM pg_indexes WHERE indexname = 'idx_person_name';

EXPLAIN ANALYZE SELECT * FROM person WHERE UPPER(name) IN ('DMITRIY');




-- Exercise 03: Multicolumn index for our goals	

DROP INDEX idx_person_order_menu_id;
DROP INDEX idx_person_order_person_id;

CREATE INDEX idx_person_order_multi ON person_order (person_id, menu_id, order_date);
ANALYZE person_order;

EXPLAIN ANALYZE
SELECT	person_id, menu_id, order_date
  FROM	person_order
 WHERE	person_id = 8 AND menu_id = 19;




-- Exercise 04: Uniqueness for data	

CREATE INDEX idx_menu_unique ON menu (pizzeria_id, pizza_name);
ANALYZE menu;

EXPLAIN ANALYZE
SELECT 
		pizza_name, 
		pizzeria.name AS pizzeria_name 
  FROM 	menu
  JOIN 	pizzeria ON pizzeria.id = menu.pizzeria_id;





-- Exercise 05: Partial uniqueness for data	

CREATE UNIQUE INDEX idx_person_order_order_date ON person_order(person_id, menu_id) WHERE order_date = '2022-01-01';
ANALYZE person_order;

EXPLAIN ANALYZE 
SELECT person_id, menu_id FROM person_order WHERE order_date = '2022-01-01';




-- Exercise 06: Let’s make performance improvement	

CREATE INDEX idx_1 ON menu(pizzeria_id, pizza_name);
ANALYZE menu;

EXPLAIN ANALYZE 	
    SELECT
			m.pizza_name AS pizza_name,
			max(rating) OVER (PARTITION BY rating ORDER BY rating ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS k
      FROM  menu m
INNER JOIN 	pizzeria pz ON m.pizzeria_id = pz.id
  ORDER BY 	1,2;







-- DROP INDEX idx_1;
-- DROP INDEX idx_menu_pizzeria_id;
-- DROP INDEX idx_person_visits_person_id;
-- DROP INDEX idx_person_visits_pizzeria_id;
-- DROP INDEX idx_person_order_person_id;
-- DROP INDEX idx_person_order_menu_id;