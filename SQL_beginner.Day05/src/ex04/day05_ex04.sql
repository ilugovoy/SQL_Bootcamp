CREATE INDEX idx_menu_unique ON menu (pizzeria_id, pizza_name);
ANALYZE menu;

EXPLAIN ANALYZE
SELECT 
		pizza_name, 
		pizzeria.name AS pizzeria_name 
  FROM 	menu
  JOIN 	pizzeria ON pizzeria.id = menu.pizzeria_id;
