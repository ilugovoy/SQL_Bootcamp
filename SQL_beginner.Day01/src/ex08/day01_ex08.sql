-- задаем id как primary_id, a person_id превращаем в id чтобы NATURAL JOIN сработал
-- бред конечно, могли бы и нормальный пример подобрать, где NATURAL JOIN уместен
	  SELECT 	orders.order_date,
				CONCAT(persons.name, ' (age:', persons.age, ')') AS person_information
	    FROM 	person_order AS orders (primary_id, id, menu_id, order_date)
NATURAL JOIN 	person AS persons 
    ORDER BY 	1, 2
