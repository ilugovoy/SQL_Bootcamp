	SELECT	person.name
	  FROM	person
 	  JOIN	person_order AS p_o ON p_o.person_id = person.id
 	  JOIN	menu ON menu.id = p_o.menu_id
	 WHERE	person.gender = 'male'
	   AND	person.address IN ('Moscow', 'Samara')
	   AND	menu.pizza_name IN ('pepperoni pizza', 'mushroom pizza')
  ORDER BY	1 DESC
