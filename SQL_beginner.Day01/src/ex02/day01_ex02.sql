-- подходит как union без all, так и intersect
	SELECT pizza_name FROM menu
 INTERSECT 
-- 	UNION
	SELECT pizza_name FROM menu
  ORDER BY 1 DESC
  