	SELECT 	
			*
	  FROM 	person_order 
	 WHERE 	person_order.person_id % 2 = 0
  ORDER BY 	person_order.person_id
  