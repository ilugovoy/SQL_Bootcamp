-- Создание триггерной функции для обработки трафика DELETE
CREATE OR REPLACE FUNCTION fnc_trg_person_delete_audit()
RETURNS TRIGGER AS $$
	BEGIN
    	-- Добавляем старые данные в таблицу person_audit при операции удаления
    	IF (TG_OP = 'DELETE') THEN
			INSERT INTO person_audit (created, type_event, row_id, name, age, gender, address)
			VALUES (CURRENT_TIMESTAMP, 'D', OLD.*); -- сохраняем старые значения атрибутов при обновлении
    	END IF;
    	RETURN OLD; -- Возвращаем удаляемую строку
	END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER trg_person_delete_audit
AFTER DELETE ON person
FOR EACH ROW
EXECUTE FUNCTION fnc_trg_person_delete_audit();

-- проверка работы триггера, шаг 1: удаление данных в person
DELETE FROM person WHERE id = 10;

-- проверка работы триггера, шаг 2: проверяем новую таблицу
SELECT * FROM person_audit;
