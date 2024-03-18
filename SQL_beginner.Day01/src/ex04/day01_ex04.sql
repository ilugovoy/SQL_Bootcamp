-- EXCEPT ALL возвращает все значения из первого запроса, которые отсутствуют во втором запросе, без удаления дубликатов
	SELECT person_id
  	  FROM person_order
 	 WHERE order_date = '2022-01-07'
EXCEPT ALL
	SELECT person_id
	  FROM person_visits
	 WHERE visit_date='2022-01-07'
