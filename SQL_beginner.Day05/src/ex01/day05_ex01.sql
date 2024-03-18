SET ENABLE_SEQSCAN TO OFF; -- выключить последовательное сканирование

EXPLAIN ANALYZE
SELECT 
		pizza_name, 
		pizzeria.name AS pizzeria_name 
  FROM 	menu
  JOIN 	pizzeria ON pizzeria.id = menu.pizzeria_id;
