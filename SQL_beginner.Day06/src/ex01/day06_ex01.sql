WITH order_counts AS (
    SELECT person_order.person_id, 
           menu.pizzeria_id, 
           COUNT(*) AS order_count -- считаем кол-во заказов для каждой уникальной комбинации person_id и pizzeria_id
      FROM person_order
     JOIN menu ON person_order.menu_id = menu.id -- присоединяем таблицу menu для получения информации о пиццерии
  GROUP BY person_order.person_id, menu.pizzeria_id -- группируем результаты по person_id и pizzeria_id
)

INSERT INTO person_discounts (id, person_id, pizzeria_id, discounts)
-- вставляем данные в таблицу person_discounts
SELECT ROW_NUMBER() OVER () AS id, -- генерируем уникальные значения id
       order_counts.person_id,
       order_counts.pizzeria_id, 
       CASE
        WHEN order_counts.order_count = 1 THEN 10.5
        WHEN order_counts.order_count = 2 THEN 22
        ELSE 30
       END AS discount -- рассчитываем значение скидки основываясь на количестве заказов
  FROM order_counts; 
