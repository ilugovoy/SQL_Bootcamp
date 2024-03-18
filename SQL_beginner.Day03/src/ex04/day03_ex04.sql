	  WITH 	male_pizzerias AS (
		  		-- выбор уникальных pizzeria_id, в которых делали заказы только мужчины
				SELECT DISTINCT pizzeria_id
				FROM menu
				JOIN person_order ON menu_id = menu.id
				JOIN person ON person_order.person_id = person.id
				WHERE person.gender = 'male'
			),
			female_pizzerias AS (
				-- аналогично для женщин
				SELECT DISTINCT pizzeria_id
				FROM menu
				JOIN person_order ON menu_id = menu.id
				JOIN person ON person_order.person_id = person.id
				WHERE person.gender = 'female'
			)

	-- Основной запрос для выбора названий пиццерий, удовлетворяющих условиям
	SELECT	pizzeria.name AS pizzeria_name
	  FROM	pizzeria
	 WHERE	pizzeria.id IN (
		 		-- Выбрать названия пиццерий, в которых только мужчины делали заказы
				SELECT pizzeria_id
				FROM male_pizzerias
				EXCEPT -- чтобы исключить из male_pizzerias те пиццерии, где заказы делали и женщины
				SELECT pizzeria_id
				FROM female_pizzerias
			)
		OR	pizzeria.id IN (
				-- аналогично для женщин
				SELECT pizzeria_id
				FROM female_pizzerias
				EXCEPT -- чтобы исключить из female_pizzerias те пиццерии, где заказы делали и мужчины
				SELECT pizzeria_id
				FROM male_pizzerias
			)
  ORDER BY	pizzeria_name;
