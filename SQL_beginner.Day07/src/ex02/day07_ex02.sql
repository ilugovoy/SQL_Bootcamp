SELECT name, count, action_type
FROM (
    SELECT p.name AS name, COUNT(*) AS count, 'visit' AS action_type
    FROM person_visits pv
    JOIN pizzeria p ON p.id = pv.pizzeria_id
    GROUP BY p.name

    UNION ALL

    SELECT p.name AS name, COUNT(*) AS count, 'order' AS action_type
    FROM person_order po
    JOIN menu m ON m.id = po.menu_id
    JOIN pizzeria p ON p.id = m.pizzeria_id
    GROUP BY p.name
) combined_data
ORDER BY action_type ASC, count DESC;
