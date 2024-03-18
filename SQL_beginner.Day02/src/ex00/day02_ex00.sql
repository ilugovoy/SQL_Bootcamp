	SELECT 	
			name, 
			rating
	  FROM 	pizzeria AS p
 LEFT JOIN	person_visits  AS pv ON p.id = pv.pizzeria_id
	 WHERE 	pv.pizzeria_id IS NULL;
