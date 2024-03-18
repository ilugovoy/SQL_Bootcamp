-- создаём список дат, присоединяем таблицу person_visits
   SELECT missing_date::date
	 FROM GENERATE_SERIES(date '2022-01-01', '2022-01-10', '1 day') AS missing_date
LEFT JOIN person_visits AS pv
-- проводим связи и заполняем даты, когда были лица с id 1 или 2
	   ON missing_date = pv.visit_date
	  AND (pv.person_id = 1 OR pv.person_id = 2)
-- и выбираем только те даты, которые не заполнились
	WHERE pv.visit_date IS NULL
 ORDER BY missing_date;
