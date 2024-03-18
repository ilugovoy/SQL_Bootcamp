CREATE SEQUENCE seq_person_discounts START 1; -- создание последовательности базы данных

ALTER TABLE person_discounts
ALTER COLUMN id SET DEFAULT nextval('seq_person_discounts'); -- установка значения по умолчанию для атрибута id в таблице person_discounts
