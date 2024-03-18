-- STEP 1: CREATE TABLES
-- Создаем таблицу paths для хранения путей между городами

CREATE TABLE IF NOT EXISTS paths (
  point1 CHAR(1),
  point2 CHAR(1),
  cost INT
);


INSERT INTO paths (point1, point2, cost) VALUES 
('a', 'b', 10),
('a', 'c', 15),
('a', 'd', 20),

('b', 'c', 35),
('c', 'd', 30),
('b', 'd', 25),
('c', 'b', 35),
('d', 'b', 25),
('d', 'c', 30),

('b', 'a', 10),
('c', 'a', 15),
('d', 'a', 20);

SELECT * FROM paths ;


-- STEP 2: CREATE VIEW WITH RECURSIVE
-- Создаем запрос для нахождения всех туров с минимальной стоимостью, начиная с города "a"

-- если объект уже существует, CREATE OR REPLACE обновит его
CREATE MATERIALIZED VIEW v_path_way AS (
	WITH RECURSIVE path_finder(last_point, tour, cost) 
		AS (
			SELECT point1, ARRAY[point1], 0 AS cost -- массив для хранения точек маршрута
			  FROM paths
			 WHERE point1 = 'a' -- начинаем с точки "а"
	    UNION
			SELECT 	paths.point2 AS last_point, -- точка финиша
					(path_finder.tour || paths.point2)::char(1)[], -- объединяем массив p.tour с новым значением paths.point2
					path_finder.cost + paths.cost -- вычисление стоимости маршрута 
			  FROM 	paths 
			  JOIN 	path_finder ON paths.point1 = path_finder.last_point -- начало и конец пути
			 WHERE 	NOT paths.point2 = ANY(path_finder.tour) -- исключаем точки, которые уже прошли
		),
		result_path AS (
			SELECT 	-- добавляем символ "а" в конец пути и вычисляем общую стоимость маршрута
					array_append(tour, 'a') AS tour, 
					cost + (SELECT cost FROM paths WHERE point1 = path_finder.last_point AND point2 = 'a') AS cost
			FROM path_finder
			WHERE array_length(path_finder.tour, 1) = 4 -- выставляем длину маршрута (после старта, 5-1=4)
		)
SELECT cost AS total_cost, tour
FROM result_path
ORDER BY total_cost, tour
);

-- выводим результат
SELECT * FROM v_path_way 
WHERE total_cost = (SELECT MIN(total_cost) FROM v_path_way)
ORDER BY total_cost, tour;
