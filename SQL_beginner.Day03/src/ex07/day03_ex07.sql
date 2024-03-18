INSERT INTO	menu (id, pizzeria_id, pizza_name, price)
	 VALUES	(19, 2, 'greek pizza', 800);

-- проверяем, что добавление успешно
	 SELECT	*
	   FROM	menu
	  WHERE	pizza_name = 'greek pizza';
