		SELECT	pizzeria.name AS pizzeria_name
		  FROM	pizzeria
		 WHERE	pizzeria.id IN (
				SELECT female_choice.pizzeria_id
				FROM (
					-- выбираем посещения только женщин
					SELECT COUNT(person_id) AS count, pizzeria_id
					FROM person_visits
					WHERE person_id IN (SELECT id FROM person WHERE gender = 'female')
					GROUP BY pizzeria_id
				)	AS female_choice
				INNER JOIN (
					-- аналогично для мужчин
					SELECT COUNT(person_id) AS count, pizzeria_id
					FROM person_visits
					WHERE person_id IN (SELECT id FROM person WHERE gender = 'male')
					GROUP BY pizzeria_id
					-- соединяем результаты посещений мужчин и женщин по идентификатору пиццерии
				)	AS male_choice ON female_choice.pizzeria_id = male_choice.pizzeria_id 
			 	-- выбираем только пиццерии, где количество посещений мужчин и женщин отличается
				WHERE female_choice.count <> male_choice.count
			)
	 ORDER BY	1;
