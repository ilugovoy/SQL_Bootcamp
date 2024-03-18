	 WITH	date_list AS (
			-- Создаем временную таблицу с датами
			SELECT missing_date::date
			FROM GENERATE_SERIES(date '2022-01-01', '2022-01-10', interval '1 day') AS missing_date
	      )
   SELECT	missing_date -- Выбираем даты, которые не связаны с посещениями лиц с ID 1 или 2
	 FROM 	date_list
LEFT JOIN (
			-- Выбираем уникальные даты посещений для лиц с ID 1 или 2
			SELECT DISTINCT visit_date
			FROM person_visits
			WHERE person_id IN (1, 2)
		  ) AS pv ON date_list.missing_date = pv.visit_date
	WHERE	pv.visit_date IS NULL -- Оставляем только даты, которые не связаны с посещениями лиц с ID 1 или 2
 ORDER BY 	missing_date;
