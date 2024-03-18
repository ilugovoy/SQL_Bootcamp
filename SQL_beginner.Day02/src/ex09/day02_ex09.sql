	SELECT	name
	  FROM	person
	 WHERE	gender = 'female'
	 		-- EXISTS используется для проверки наличия хотя бы одной строки, удовлетворяющей условиям подзапроса 
	   		-- проверяем, существует ли заказ пиццы пепперони для каждой женщины
	   AND	EXISTS (
		   		SELECT 1 FROM person_order AS p_o 
				JOIN menu ON p_o.menu_id = menu.id 
				WHERE p_o.person_id = person.id 
				AND menu.pizza_name = 'pepperoni pizza'
	   		)
			-- аналогично проверяем заказ сырной пиццы 
	   AND	EXISTS (
				SELECT 1 FROM person_order AS p_o 
				JOIN menu ON p_o.menu_id = menu.id 
				WHERE p_o.person_id = person.id 
				AND menu.pizza_name = 'cheese pizza'
			)
  ORDER BY	1
