-- Создание основной триггерной функции
CREATE OR REPLACE FUNCTION fnc_trg_person_audit()
RETURNS TRIGGER AS $$
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			INSERT INTO person_audit (created, type_event, row_id, name, age, gender, address)
			VALUES (CURRENT_TIMESTAMP, 'I', NEW.id, NEW.name, NEW.age, NEW.gender, NEW.address);
		ELSIF (TG_OP = 'UPDATE') THEN
			INSERT INTO person_audit (created, type_event, row_id, name, age, gender, address)
			VALUES (CURRENT_TIMESTAMP, 'U', OLD.*);
		ELSIF (TG_OP = 'DELETE') THEN
			INSERT INTO person_audit (created, type_event, row_id, name, age, gender, address)
			VALUES (CURRENT_TIMESTAMP, 'D', OLD.*);
		END IF;
		RETURN NULL;
	END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER trg_person_audit
AFTER INSERT OR UPDATE OR DELETE ON person
FOR EACH ROW
EXECUTE FUNCTION fnc_trg_person_audit();

-- Удаление старых триггеров
DROP TRIGGER IF EXISTS trg_person_insert_audit ON person CASCADE;
DROP TRIGGER IF EXISTS trg_person_update_audit ON person CASCADE;
DROP TRIGGER IF EXISTS trg_person_delete_audit ON person CASCADE;

-- Удаление старых триггерных функций
DROP FUNCTION IF EXISTS fnc_trg_person_insert_audit CASCADE;
DROP FUNCTION IF EXISTS fnc_trg_person_update_audit CASCADE;
DROP FUNCTION IF EXISTS fnc_trg_person_delete_audit CASCADE;

-- Удаление всех строк в таблице person_audit
DELETE FROM person_audit;

-- проверка работы триггера, шаг 1: изменение данных в person
INSERT INTO person(id, name, age, gender, address) VALUES (10,'Damir', 22, 'male', 'Irkutsk');
UPDATE person SET name = 'Bulat' WHERE id = 10;
UPDATE person SET name = 'Damir' WHERE id = 10;
DELETE FROM person WHERE id = 10;

-- проверка работы триггера, шаг 2: проверяем новую таблицу
SELECT * FROM person_audit;
