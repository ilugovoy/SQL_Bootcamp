SELECT name
FROM pizzeria
WHERE id NOT IN (SELECT DISTINCT pizzeria_id FROM person_visits);

-- Первый запрос использует оператор NOT IN для сравнения значений в столбце id из таблицы pizzeria с результатами подзапроса,   
-- который возвращает уникальные значения столбца pizzeria_id из таблицы person_visits. 
-- Этот подзапрос может вернуть набор уникальных идентификаторов пиццерий, которые связаны с записями в таблице person_visits.   
-- Затем оператор NOT IN возвращает названия пиццерий, чьи идентификаторы не содержатся в этом подзапросе.

SELECT name
FROM pizzeria
WHERE NOT EXISTS (SELECT 1 FROM person_visits WHERE person_visits.pizzeria_id = pizzeria.id);

-- Второй запрос использует оператор NOT EXISTS, который проверяет, существуют ли записи в таблице person_visits, связанные с конкретной пиццерией.   
-- Подзапрос возвращает единицу для каждой записи в person_visits, связанной с пиццерией из главного запроса.   
-- Если подзапрос не вернет ни одной записи, значит, такая пиццерия не содержится в person_visits, и она возвращается в результате.

