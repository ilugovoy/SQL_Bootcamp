-- CROSS JOIN в SQL используется для декартова произведения двух таблиц, или объединения каждой строки из одной таблицы со всеми строками другой таблицы 
	SELECT t_1.id AS person_id, t_1.name AS person_name, t_1.age, t_1.gender, t_1.address,
		   t_2.id AS pizzeria_id, t_2.name AS pizzeria_name, t_2.rating
  	  FROM person AS t_1
CROSS JOIN pizzeria AS t_2
  ORDER BY t_1.id, t_2.id
