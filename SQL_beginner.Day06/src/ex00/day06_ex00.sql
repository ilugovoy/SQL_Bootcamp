CREATE TABLE person_discounts (
     		 id 	SERIAL PRIMARY KEY, -- автоматически генерирует уникальные значения при вставке новой записи
      person_id 	BIGINT,
    pizzeria_id 	BIGINT,
      discounts 	NUMERIC,
     CONSTRAINT 	fk_person_discounts_person_id FOREIGN KEY (person_id) REFERENCES person(id),
     CONSTRAINT 	fk_person_discounts_pizzeria_id FOREIGN KEY (pizzeria_id) REFERENCES pizzeria(id)
);