	SELECT
    		pizzeria.name
	  FROM	pizzeria
INNER JOIN  person_visits AS pv ON pv.pizzeria_id = pizzeria.id
INNER JOIN  person ON person.id = pv.person_id
	 WHERE	pv.visit_date = '2022-01-08'
	   AND	person.name = 'Dmitriy'
