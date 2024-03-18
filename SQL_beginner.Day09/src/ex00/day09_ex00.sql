-- создание таблицы person_audit
CREATE TABLE person_audit (
       created 	TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
				-- ограничиваем возможные значения колонки type_event с помощью CHECK
    type_event 	CHAR(1) DEFAULT 'I' NOT NULL CHECK (type_event IN ('I', 'U', 'D')),
        row_id 	BIGINT NOT NULL,
          name 	VARCHAR,
           age 	INTEGER DEFAULT 10,
        gender 	VARCHAR,
       address 	VARCHAR
);

-- cоздание триггерной функции для обработки трафика INSERT
CREATE OR REPLACE FUNCTION fnc_trg_person_insert_audit()
RETURNS TRIGGER AS $$ -- возвращаем триггер
		BEGIN
			-- добавляем новые данные в таблицу person_audit при операции вставки
			IF (TG_OP = 'INSERT') THEN
				INSERT INTO person_audit (row_id, name, age, gender, address)
				-- NEW представляет новую строку данных, сгенерированную при операции вставки
				VALUES (NEW.id, NEW.name, NEW.age, NEW.gender, NEW.address);
			END IF;
			RETURN NEW; -- возвращаем новую строку
		END;
$$ LANGUAGE plpgsql;


-- cоздание триггера
CREATE TRIGGER trg_person_insert_audit
AFTER INSERT ON person -- указывает, что триггер должен срабатывать после операции вставки в таблицу person
FOR EACH ROW -- гарантирует, что триггер будет выполняться отдельно для каждой вставленной строки данных
EXECUTE FUNCTION fnc_trg_person_insert_audit(); -- задает выполнение функции fnc_trg_person_insert_audit при срабатывании триггера

-- проверка создания триггера
SELECT * 
  FROM information_schema.triggers 
 WHERE event_object_table = 'person_audit';

-- проверка работы триггера, шаг 1: вставка новых данных в person
INSERT INTO person (id, name, age, gender, address) VALUES (10, 'Damir', 22, 'male', 'Irkutsk');

-- проверка работы триггера, шаг 2: проверяем новую таблицу
SELECT * FROM person_audit;
