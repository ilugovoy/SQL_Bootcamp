--  COALESCE для замены NULL на '-'
	SELECT 	COALESCE(p.name, '-') AS person_name,
		   	sub_1.visit_date AS visit_date,
		   	COALESCE(piz.name, '-') AS pizzeria_name
	  FROM 	person AS p
-- FULL JOIN для объединения таблиц "person" и "pizzeria" со всеми записями из подзапроса "sub_1"
-- FULL JOIN сохраняет все данные из обеих таблиц, и если нет совпадающих записей, то заполняет соответствующие значения NULL
-- Это позволяет получить полную картину посещений включая случаи, когда информация отсутствует в одной из таблиц	  
 FULL JOIN	(
			 SELECT *
	   		   FROM person_visits AS pv
	   		  WHERE pv.visit_date BETWEEN '2022-01-01' AND '2022-01-03'
 	  		) AS sub_1 ON p.id = sub_1.person_id 
 FULL JOIN pizzeria AS piz ON sub_1.pizzeria_id = piz.id
  ORDER BY person_name, visit_date, pizzeria_name;
