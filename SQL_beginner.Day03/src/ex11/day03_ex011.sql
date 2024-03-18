	UPDATE	menu
	   SET	price = price * 0.9
	 WHERE	pizza_name = 'greek pizza';

-- проверяем, что обновление успешно
	 SELECT	*
	   FROM	menu
	  WHERE	pizza_name = 'greek pizza';
