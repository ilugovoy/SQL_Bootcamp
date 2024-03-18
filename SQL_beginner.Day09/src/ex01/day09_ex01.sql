-- cоздание триггерной функции для обработки трафика UPDATE
CREATE OR REPLACE FUNCTION fnc_trg_person_update_audit()
RETURNS TRIGGER AS $$
	BEGIN
		IF (TG_OP = 'UPDATE') THEN -- гарантирует, что операция выполняется только для обновления данных
			INSERT INTO person_audit (created, type_event, row_id, name, age, gender, address)
			VALUES (CURRENT_TIMESTAMP, 'U', OLD.*); -- сохраняем старые значения атрибутов при обновлении
		END IF;
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;


-- cоздание триггера
CREATE TRIGGER trg_person_update_audit
AFTER UPDATE ON person
FOR EACH ROW
EXECUTE FUNCTION fnc_trg_person_update_audit();

-- проверка работы триггера, шаг 1: обновление данных в person
UPDATE person SET name = 'Bulat' WHERE id = 10;
UPDATE person SET name = 'Damir' WHERE id = 10;

-- проверка работы триггера, шаг 2: проверяем новую таблицу
SELECT * FROM person_audit;
