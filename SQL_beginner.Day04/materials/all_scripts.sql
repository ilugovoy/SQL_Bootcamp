-- Exercise 00: Let’s create separated views for persons	
CREATE VIEW	v_persons_female AS
	 SELECT	id, name, age, gender, address
	   FROM	person
	  WHERE	gender = 'female';

CREATE VIEW	v_persons_male AS
	 SELECT	id, name, age, gender, address
	   FROM	person
	  WHERE	gender = 'male';




-- Exercise 01: From parts to common view	
  SELECT	name FROM v_persons_female
   UNION	ALL
  SELECT	name FROM v_persons_male
ORDER BY	1;



-- Exercise 02: “Store” generated dates in one place
CREATE VIEW	v_generated_dates 
		 AS
			SELECT	generated_date::date
			  FROM	GENERATE_SERIES('2022-01-01'::date, '2022-01-31'::date, '1 day') AS generated_date
		  ORDER BY	1;
		  
SELECT * FROM v_generated_dates; -- вывод результата



-- Exercise 03: Find missing visit days with Database View
SELECT DISTINCT generated_date AS missing_date FROM v_generated_dates
		 EXCEPT	SELECT DISTINCT visit_date FROM person_visits
	  ORDER BY	1;




-- Exercise 04: Let’s find something from Set Theory 
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




-- Exercise 05: Let’s calculate a discount price for each person
CREATE VIEW v_price_with_discount 
	AS (
		SELECT	person.name,
				menu.pizza_name,
				menu.price,
				CAST(menu.price * 0.9 AS INT) AS discount_price
      	  FROM	person
          JOIN	person_order AS p_o ON person.id = p_o.person_id
          JOIN	menu ON p_o.menu_id = menu.id
      ORDER BY	1, 2
	);

SELECT * FROM v_price_with_discount;




-- Exercise 06: Materialization from virtualization	
CREATE MATERIALIZED VIEW	mv_dmitriy_visits_and_eats 
AS
	SELECT	pizzeria.name
	  FROM
			pizzeria
			INNER JOIN person_visits AS pv ON pv.pizzeria_id = pizzeria.id
			INNER JOIN person ON person.id = pv.person_id
	 WHERE
			person.name = 'Dmitriy'
			AND pv.visit_date = '2022-01-08';

SELECT * FROM mv_dmitriy_visits_and_eats;


-- Exercise 07: Refresh our state
INSERT INTO person_visits
	 VALUES (
			 (SELECT MAX(id) FROM person_visits) + 1,
			 (SELECT id FROM person WHERE name = 'Dmitriy'),
			 (SELECT id FROM pizzeria WHERE name = 'DoDo Pizza'),
			 '2022-01-08'
			);

SELECT * FROM person_visits WHERE visit_date = '2022-01-08' AND person_id = 9;

REFRESH MATERIALIZED VIEW mv_dmitriy_visits_and_eats;

SELECT * FROM mv_dmitriy_visits_and_eats;





-- Exercise 08: Just clear our database
DROP MATERIALIZED VIEW IF EXISTS mv_dmitriy_visits_and_eats;

