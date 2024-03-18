WITH discounted_orders AS
(
    -- создаем СТЕ для получения истории заказов с учетом примененной скидки
    SELECT person.name,
           menu.pizza_name, 
           menu.price,
           ROUND((menu.price * ((100 - pd.discount) / 100))) AS discount_price, -- рассчитываем цену со скидкой на основе примененной скидки из таблицы person_discounts
           piz.name AS pizzeria_name 
    FROM person_order AS po
    JOIN person ON person.id = po.person_id 
    JOIN menu ON po.menu_id = menu.id 
    JOIN pizzeria AS piz ON menu.pizzeria_id = piz.id 
    JOIN person_discounts AS pd ON (po.person_id = pd.person_id AND menu.pizzeria_id = pd.pizzeria_id)
)
-- извлекаем все столбцы из СТЕ
SELECT * FROM discounted_orders ORDER BY 1, 2;
