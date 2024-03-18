	SELECT
    		menu.pizza_name,
    		piz.name AS pizzeria_name
	  FROM	person_order AS po
			-- Использование INNER JOIN позволяет выбирать только те заказы, 
			-- у которых есть соответствующие записи в таблице меню и пиццерии
INNER JOIN  menu ON po.menu_id = menu.id
INNER JOIN  pizzeria AS piz ON menu.pizzeria_id = piz.id
			-- Оставляем только заказы, сделанные Денисом или Анной
  	 WHERE	po.person_id IN ( SELECT id FROM person WHERE name IN ('Denis', 'Anna') )
  ORDER BY	1, 2;
