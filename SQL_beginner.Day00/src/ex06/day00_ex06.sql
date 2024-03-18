	SELECT (
			SELECT 	person.name 
			  FROM 	person 
			 WHERE 	person.id = person_order.person_id  -- проводим связь между таблицами person и person_order
	),
	  CASE -- создаём новый столбец с результатом проверки имени
			WHEN (
					SELECT person.name 
					  FROM person 
					 WHERE person.id = person_order.person_id) = 'Denis' 
					 THEN 'true' 
					 ELSE 'false'
			END AS 	check_name
	  FROM	person_order
	 WHERE	( -- скобки для соответствия выборке по дате
		 	person_order.menu_id = 13 
		OR 	person_order.menu_id = 14 
		OR 	person_order.menu_id = 18
	 )
	   AND 	person_order.order_date = '2022-01-07';
	   