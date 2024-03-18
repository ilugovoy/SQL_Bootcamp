INSERT INTO	menu (id, pizzeria_id, pizza_name, price)
	 -- находим максимальное значение id в таблице menu и ++ его
	 VALUES ((SELECT MAX(id) FROM menu) + 1,
	 -- извлекаем идентификатор ресторана "Dominos" из таблицы pizzeria для записи
	(SELECT id FROM pizzeria WHERE name = 'Dominos'), 'sicilian pizza', 900);

-- проверяем, что добавление успешно
	--  SELECT	*
	--    FROM	menu
	--   WHERE	pizza_name = 'sicilian pizza';
