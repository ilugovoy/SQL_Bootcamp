ALTER TABLE person_discounts
    ADD CONSTRAINT ch_nn_person_id CHECK (person_id IS NOT NULL), -- не должен быть NULL
    ADD CONSTRAINT ch_nn_pizzeria_id CHECK (pizzeria_id IS NOT NULL), -- не должен быть NULL
    ADD CONSTRAINT ch_nn_discount CHECK (discount IS NOT NULL), -- не должен быть NULL
    ADD CONSTRAINT ch_range_discount CHECK (discount >= 0 AND discount <= 100); -- должен быть в диапазоне от 0 до 100

ALTER TABLE person_discounts
    ALTER COLUMN discount SET DEFAULT 0; -- установка столбца discount по умолчанию на 0 процентов
