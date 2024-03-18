WITH pizzas AS (
	SELECT  -- временная таблица "pizzas" с информацией о названии пиццы, пиццерии и цене
			menu.pizza_name,
			pizzeria.name AS pizzeria_name,
			menu.price
	  FROM 	menu
	  JOIN 	pizzeria ON pizzeria.id = menu.pizzeria_id
)

	SELECT  -- основной запрос
			p1.pizza_name,
			p1.pizzeria_name AS pizzeria_name_1,
			p2.pizzeria_name AS pizzeria_name_2,
			p1.price
	FROM	pizzas AS p1
	JOIN	pizzas AS p2 ON p1.price = p2.price -- Соединение по цене
	 AND	p1.pizza_name = p2.pizza_name -- Соединение по названию пиццы
	 AND	p1.pizzeria_name < p2.pizzeria_name -- Исключение повторяющихся комбинаций
ORDER BY	1;
