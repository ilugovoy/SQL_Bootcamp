CREATE VIEW v_symmetric_union 
			AS (
					(SELECT person_id FROM person_visits AS R WHERE visit_date IN ('2022-01-02')
				 EXCEPT ALL	SELECT person_id FROM person_visits AS S WHERE visit_date IN ('2022-01-06')) 		
					  UNION	
					(SELECT person_id FROM person_visits AS S WHERE visit_date IN ('2022-01-06')
				 EXCEPT ALL	SELECT person_id FROM person_visits AS R WHERE visit_date IN ('2022-01-02'))
				  ORDER BY	1
			);

SELECT * FROM v_symmetric_union;
