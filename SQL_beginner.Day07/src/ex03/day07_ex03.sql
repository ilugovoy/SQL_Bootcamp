WITH combined_data AS (
    -- выбираем название пиццерии из таблицы person_visits и считаем количество посещений
    SELECT p.name AS name, COUNT(*) AS total_count
    FROM person_visits pv
    JOIN pizzeria p ON p.id = pv.pizzeria_id
    GROUP BY p.name
    
    UNION ALL
    
    -- выбираем название пиццерии из таблицы person_order, связываем через меню и считаем количество заказов
    SELECT p.name AS name, COUNT(*) AS total_count
    FROM person_order po
    JOIN menu m ON m.id = po.menu_id
    JOIN pizzeria p ON p.id = m.pizzeria_id
    GROUP BY p.name
)

-- выбираем название пиццерии и суммируем общее количество (посещений и заказов), группируем по названию пиццерии
SELECT name, SUM(total_count) AS total_count
FROM combined_data
GROUP BY name
ORDER BY total_count DESC, name ASC;
