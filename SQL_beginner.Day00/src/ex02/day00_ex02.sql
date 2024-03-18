	SELECT 
			pizzeria.name,
			pizzeria.rating
	  FROM	pizzeria
	 WHERE	pizzeria.rating >= '3.5' AND pizzeria.rating <= '5'
  ORDER BY	pizzeria.rating;
	SELECT 
			pizzeria.name,
			pizzeria.rating
	  FROM	pizzeria
	 WHERE 	pizzeria.rating BETWEEN 3.5 AND 5
  ORDER BY	pizzeria.rating;
  