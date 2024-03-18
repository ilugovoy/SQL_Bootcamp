	SELECT	
			menu.pizza_name,
			pizzeria.name AS pizzeria_name,
			menu.price
	  FROM	menu
 LEFT JOIN	pizzeria ON pizzeria.id = menu.pizzeria_id
 	 WHERE	menu.pizza_name = 'pepperoni pizza' OR menu.pizza_name = 'mushroom pizza'
  ORDER BY	1, 2
