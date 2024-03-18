WITH new_ids AS (
  SELECT 
	-- Генерируем уникальные id
	-- для генерации id мы используем функцию GENERATE_SERIES для создания последовательности чисел от (MAX(id) + 1) в таблице person_order 
	-- до (MAX(id) + COUNT()), где COUNT() подсчитывает общее количество записей в таблице person_order 
	-- так мы получаем уникальные значения id для вставки новых записей  
	GENERATE_SERIES(
		-- 
		(SELECT MAX(id) + 1 FROM person_order),
		(SELECT MAX(id) + (SELECT COUNT(*) FROM person) FROM person_order)
	) AS id,
	-- Генерируем уникальные значения person_id
	-- в диапазоне от минимального id в person до (MIN(id) + COUNT())
	GENERATE_SERIES(
		(SELECT MIN(id) FROM person),
		-- '-1' используется для указание последнего значения в этой последовательности
		(SELECT MIN(id) + (SELECT COUNT(*) FROM person) - 1 FROM person)
	) AS person_id
)
-- вставляем новые записи в таблицу person_order с использованием сгенерированных значений id и person_id
INSERT INTO person_order (id, person_id, menu_id, order_date)
	 SELECT 
  			n.id, -- Выбираем сгенерированные уникальные значения id
  			n.person_id, -- Выбираем сгенерированные уникальные значения person_id
  			(SELECT id FROM menu WHERE pizza_name = 'greek pizza'),
  			'2022-02-25'
	   FROM new_ids AS n;  -- Используем временную таблицу new_ids для вставки

-- проверяем, что добавление успешно
-- SELECT *
--   FROM person_order
--  WHERE order_date = '2022-02-25';
