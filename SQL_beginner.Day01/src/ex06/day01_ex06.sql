	SELECT 	DISTINCT orders.order_date 	AS action_date, persons.name AS person_name
	  FROM 	person_order 		AS orders
 LEFT JOIN 	person_visits 		AS visits 					ON orders.order_date = visits.visit_date 
 LEFT JOIN 	person 				AS persons 					ON visits.person_id = persons.id
  ORDER BY 	1, 2 DESC
