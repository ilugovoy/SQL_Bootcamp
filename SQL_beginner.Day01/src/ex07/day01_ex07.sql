-- склеиваем колонки с помощью CONCAT
	SELECT 	orders.order_date,
			CONCAT(persons.name, ' (age:', persons.age, ')') AS person_information
	  FROM 	person_order 		AS orders
 LEFT JOIN 	person 				AS persons 					ON orders.person_id = persons.id
  ORDER BY 	1, 2
