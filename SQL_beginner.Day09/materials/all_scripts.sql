-- Day 09
-- Exercise 00: Audit of incoming inserts

-- -- создание таблицы person_audit
-- CREATE TABLE person_audit (
--        created 	TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
-- 				-- ограничиваем возможные значения колонки type_event с помощью CHECK
--     type_event 	CHAR(1) DEFAULT 'I' NOT NULL CHECK (type_event IN ('I', 'U', 'D')),
--         row_id 	BIGINT NOT NULL,
--           name 	VARCHAR,
--            age 	INTEGER DEFAULT 10,
--         gender 	VARCHAR,
--        address 	VARCHAR
-- );

-- -- cоздание триггерной функции для обработки трафика INSERT
-- CREATE OR REPLACE FUNCTION fnc_trg_person_insert_audit()
-- RETURNS TRIGGER AS $$ -- возвращаем триггер
-- 		BEGIN
-- 			-- добавляем новые данные в таблицу person_audit
-- 			INSERT INTO person_audit (row_id, name, age, gender, address)
-- 			-- NEW представляет новую строку данных, сгенерированную при операции вставки
-- 			VALUES (NEW.id, NEW.name, NEW.age, NEW.gender, NEW.address);
-- 			RETURN NEW; -- возвращаем новую строку
-- 		END;
-- $$ LANGUAGE plpgsql;


-- -- cоздание триггера базы данных trg_person_insert_audit
-- CREATE TRIGGER trg_person_insert_audit
-- AFTER INSERT ON person -- указывает, что триггер должен срабатывать после операции вставки в таблицу person
-- FOR EACH ROW -- гарантирует, что триггер будет выполняться отдельно для каждой вставленной строки данных
-- EXECUTE FUNCTION fnc_trg_person_insert_audit(); -- задает выполнение функции fnc_trg_person_insert_audit при срабатывании триггера

-- -- проверка создания триггера, вывод всех триггеров для указанной таблицы
-- SELECT * 
--   FROM information_schema.triggers 
--  WHERE event_object_table = 'person';

-- -- проверка работы триггера, шаг 1: вставка новых данных в person
-- INSERT INTO person (id, name, age, gender, address) VALUES (10, 'Damir', 22, 'male', 'Irkutsk');

-- -- проверка работы триггера, шаг 2: проверяем новую таблицу
-- SELECT * FROM person_audit;



-- Exercise 01: Audit of incoming updates

-- -- cоздание триггерной функции для обработки трафика UPDATE
-- CREATE OR REPLACE FUNCTION fnc_trg_person_update_audit()
-- RETURNS TRIGGER AS $$
-- 	BEGIN
-- 		IF (TG_OP = 'UPDATE') THEN -- гарантирует, что операция выполняется только для обновления данных
-- 			INSERT INTO person_audit (created, type_event, row_id, name, age, gender, address)
-- 			VALUES (CURRENT_TIMESTAMP, 'U', OLD.*); -- сохраняем старые значения атрибутов при обновлении
-- 		END IF;
-- 		RETURN NEW;
-- 	END;
-- $$ LANGUAGE plpgsql;


-- -- cоздание триггера
-- CREATE TRIGGER trg_person_update_audit
-- AFTER UPDATE ON person
-- FOR EACH ROW
-- EXECUTE FUNCTION fnc_trg_person_update_audit();

-- -- проверка работы триггера, шаг 1: обновление данных в person
-- UPDATE person SET name = 'Bulat' WHERE id = 10;
-- UPDATE person SET name = 'Damir' WHERE id = 10;

-- -- проверка работы триггера, шаг 2: проверяем новую таблицу
-- SELECT * FROM person_audit;


-- Exercise 02: Audit of incoming deletes

-- -- Создание триггерной функции для обработки трафика DELETE
-- CREATE OR REPLACE FUNCTION fnc_trg_person_delete_audit()
-- RETURNS TRIGGER AS $$
-- 	BEGIN
--     	-- Добавляем старые данные в таблицу person_audit при операции удаления
--     	IF (TG_OP = 'DELETE') THEN
-- 			INSERT INTO person_audit (created, type_event, row_id, name, age, gender, address)
-- 			VALUES (CURRENT_TIMESTAMP, 'D', OLD.*); -- сохраняем старые значения атрибутов при обновлении
--     	END IF;
--     	RETURN OLD; -- Возвращаем удаляемую строку
-- 	END;
-- $$ LANGUAGE plpgsql;

-- -- Создание триггера
-- CREATE TRIGGER trg_person_delete_audit
-- AFTER DELETE ON person
-- FOR EACH ROW
-- EXECUTE FUNCTION fnc_trg_person_delete_audit();

-- -- проверка работы триггера, шаг 1: удаление данных в person
-- DELETE FROM person WHERE id = 10;

-- -- проверка работы триггера, шаг 2: проверяем новую таблицу
-- SELECT * FROM person_audit;





-- Exercise 03: Generic Audit

-- -- Создание основной триггерной функции
-- CREATE OR REPLACE FUNCTION fnc_trg_person_audit()
-- RETURNS TRIGGER AS $$
-- 	BEGIN
-- 		IF (TG_OP = 'INSERT') THEN
-- 			INSERT INTO person_audit (created, type_event, row_id, name, age, gender, address)
-- 			VALUES (CURRENT_TIMESTAMP, 'I', NEW.id, NEW.name, NEW.age, NEW.gender, NEW.address);
-- 		ELSIF (TG_OP = 'UPDATE') THEN
-- 			INSERT INTO person_audit (created, type_event, row_id, name, age, gender, address)
-- 			VALUES (CURRENT_TIMESTAMP, 'U', OLD.*);
-- 		ELSIF (TG_OP = 'DELETE') THEN
-- 			INSERT INTO person_audit (created, type_event, row_id, name, age, gender, address)
-- 			VALUES (CURRENT_TIMESTAMP, 'D', OLD.*);
-- 		END IF;
-- 		RETURN NULL;
-- 	END;
-- $$ LANGUAGE plpgsql;

-- -- Создание триггера
-- CREATE TRIGGER trg_person_audit
-- AFTER INSERT OR UPDATE OR DELETE ON person
-- FOR EACH ROW
-- EXECUTE FUNCTION fnc_trg_person_audit();

-- -- Удаление старых триггеров
-- DROP TRIGGER IF EXISTS trg_person_insert_audit ON person CASCADE;
-- DROP TRIGGER IF EXISTS trg_person_update_audit ON person CASCADE;
-- DROP TRIGGER IF EXISTS trg_person_delete_audit ON person CASCADE;

-- -- Удаление старых триггерных функций
-- DROP FUNCTION IF EXISTS fnc_trg_person_insert_audit CASCADE;
-- DROP FUNCTION IF EXISTS fnc_trg_person_update_audit CASCADE;
-- DROP FUNCTION IF EXISTS fnc_trg_person_delete_audit CASCADE;

-- -- Удаление всех строк в таблице person_audit
-- DELETE FROM person_audit;

-- -- проверка работы триггера, шаг 1: изменение данных в person
-- INSERT INTO person(id, name, age, gender, address) VALUES (10,'Damir', 22, 'male', 'Irkutsk');
-- UPDATE person SET name = 'Bulat' WHERE id = 10;
-- UPDATE person SET name = 'Damir' WHERE id = 10;
-- DELETE FROM person WHERE id = 10;

-- -- проверка работы триггера, шаг 2: проверяем новую таблицу
-- SELECT * FROM person_audit;




-- Exercise 04: Database View VS Database Function

-- -- функция для возврата женщин
-- CREATE OR REPLACE FUNCTION fnc_persons_female() RETURNS TABLE (
--          id BIGINT,
--        name VARCHAR,
--         age INT,
--      gender VARCHAR,
--     address VARCHAR
-- ) AS $$
--     SELECT id, name , age, gender, address
--     FROM person
-- 	WHERE person.gender = 'female';
-- $$ LANGUAGE SQL;

-- -- функция для возврата мужчин
-- CREATE OR REPLACE FUNCTION fnc_persons_male() RETURNS TABLE (
--          id BIGINT,
--        name VARCHAR,
--         age INT,
--      gender VARCHAR,
--     address VARCHAR
-- ) AS $$
--     SELECT id, name, age, gender, address
--     FROM person
-- 	WHERE person.gender = 'male';
-- $$ LANGUAGE SQL;

-- -- вызов функции с фильтром по женщинам
-- SELECT *
-- FROM fnc_persons_female();

-- -- вызов с фильтром по мужчинам
-- SELECT *
-- FROM fnc_persons_male();






-- Exercise 05: Parameterized Database Function

-- -- удаление существующих функций
-- DROP FUNCTION IF EXISTS fnc_persons_female CASCADE;
-- DROP FUNCTION IF EXISTS fnc_persons_male CASCADE;

-- -- создание универсальной SQL-функции fnc_persons без использования PL/pgSQL
-- CREATE OR REPLACE FUNCTION fnc_persons(pgender VARCHAR DEFAULT 'female') RETURNS TABLE (
--          id BIGINT,
--        name VARCHAR,
--         age INT,
--      gender VARCHAR,
--     address VARCHAR
-- ) AS $$
-- 		SELECT *
-- 		  FROM person
-- 		 WHERE pgender = person.gender
-- $$ LANGUAGE SQL;

-- -- вызов функции для лиц мужского пола
-- SELECT * FROM fnc_persons(pgender := 'male');

-- -- вызов функции для лиц женского пола (используется значение по умолчанию "female")
-- SELECT * FROM fnc_persons();






-- Exercise 06: Function like a function-wrapper

-- создание функции PL/pgSQL fnc_person_visits_and_eats_on_date
CREATE OR REPLACE FUNCTION fnc_person_visits_and_eats_on_date
	(
			IN pperson VARCHAR DEFAULT 'Dmitriy', 
			IN pprice NUMERIC DEFAULT 500, 
			IN pdate DATE DEFAULT '2022-01-08'
	) 
	RETURNS VARCHAR AS $$
		DECLARE 
			pizzeria_name VARCHAR;  -- переменная для хранения названия пиццерии
			BEGIN
				-- выборка названия пиццерии в переменную pizzeria_name
				SELECT pizzeria.name INTO pizzeria_name
				FROM pizzeria
				JOIN person_visits ON person_visits.pizzeria_id = pizzeria.id
				JOIN person ON person.id = person_id
				JOIN menu ON menu.pizzeria_id = pizzeria.id
				WHERE person.name = pperson AND price < pprice AND visit_date = pdate;
				
				RETURN pizzeria_name;  -- возврат названия пиццерии
			END;
$$ LANGUAGE PLPGSQL;

-- вызов функции для поиска пиццерии, где человек мог купить пиццу дешевле 800 рублей 8 января 2022 года
SELECT * FROM fnc_person_visits_and_eats_on_date(pprice := 800);

-- вызов функции для указания другого человека (Anna), суммы и даты покупки пиццы
SELECT * FROM fnc_person_visits_and_eats_on_date(pperson := 'Anna', pprice := 1300, pdate := '2022-01-01');






-- Exercise 07: Different view to find a Minimum

-- -- создание функции PL/pgSQL func_minimum с обработкой целых чисел без десятичной точки
-- CREATE OR REPLACE FUNCTION func_minimum(VARIADIC arr numeric[]) RETURNS text AS $$
-- DECLARE
--     min_val numeric;  -- переменная для содержания минимального значения
--     result_text text;  -- переменная для вывода результата
-- BEGIN
--     SELECT MIN(val) INTO min_val FROM unnest(arr) AS val; -- выборка минимального значения из массива
--     IF min_val = ROUND(min_val) THEN
--         result_text := to_char(min_val, '9,999'); -- преобразование целого числа без десятичной точки в текст
--     ELSE
--         result_text := to_char(min_val, '9,999.9'); -- преобразование числа с десятичной точкой в текст
--     END IF;
--     RETURN result_text;  -- возврат минимального значения в виде текста
-- END;
-- $$ LANGUAGE plpgsql;

-- -- вызов функции для поиска минимального значения из массива
-- SELECT func_minimum(VARIADIC ARRAY[10.0, -1.0, 5.0, 4.4]);






-- Exercise 08: Fibonacci algorithm is in a function	

-- -- создание функции PL/pgSQL fnc_fibonacci
-- CREATE OR REPLACE FUNCTION fnc_fibonacci(pstop INTEGER DEFAULT 10) 
-- RETURNS TABLE (fib_num BIGINT) AS $$
-- 	DECLARE
-- 		a BIGINT := 0;  -- первое число Фибоначчи
-- 		b BIGINT := 1;  -- второе число Фибоначчи
-- 		temp BIGINT;     -- временная переменная для обмена значений
-- 		BEGIN
-- 			fib_num := a;  -- возвращаем первое число Фибоначчи
-- 			RETURN NEXT;

-- 			WHILE b < pstop LOOP
-- 				fib_num := b;  -- возвращаем текущее число Фибоначчи
-- 				RETURN NEXT;

-- 				temp := a + b;  -- подсчет следующего числа Фибоначчи
-- 				a := b;
-- 				b := temp;
-- 			END LOOP;

-- 			RETURN;  -- завершение функции
-- 		END;
-- $$ LANGUAGE plpgsql;

-- -- вызов функции для получения всех чисел Фибоначчи, меньших, чем 20
-- SELECT * FROM fnc_fibonacci(20);

-- -- вызов функции для получения всех чисел Фибоначчи, меньших, чем 10 (значение по умолчанию)
-- SELECT * FROM fnc_fibonacci();

















