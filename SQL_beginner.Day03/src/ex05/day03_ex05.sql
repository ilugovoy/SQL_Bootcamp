	SELECT	pizzeria.name AS pizzeria_name
	  FROM	pizzeria
	  JOIN	person_visits AS p_v	ON	p_v.pizzeria_id = pizzeria.id
	  JOIN	person	ON person.id = p_v.person_id
	 WHERE	person.name = 'Andrey' 
	   -- выбираем все пиццерии, в которых нет заказа от нашего person.id отфильтрованного по Андрею
	   AND	person.id NOT IN (
				SELECT pizzeria_id
				  FROM person_order
				 WHERE person_id = person.id
    		)
  ORDER BY	1;
