CREATE VIEW v_price_with_discount 
	AS (
		SELECT	person.name,
				menu.pizza_name,
				menu.price,
				CAST(menu.price * 0.9 AS INT) AS discount_price
      	  FROM	person
          JOIN	person_order AS p_o ON person.id = p_o.person_id
          JOIN	menu ON p_o.menu_id = menu.id
      ORDER BY	1, 2
	);

SELECT * FROM v_price_with_discount;
