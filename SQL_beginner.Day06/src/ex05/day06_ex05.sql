 COMMENT ON TABLE person_discounts IS 'Эта таблица хранит информацию о персональных скидках, предоставляемых на основе истории заказов конкретных клиентов в конкретных пиццериях.';
COMMENT ON COLUMN person_discounts.person_id IS 'Идентификатор клиента, для которого рассчитывается персональная скидка.';
COMMENT ON COLUMN person_discounts.pizzeria_id IS 'Идентификатор пиццерии, в которой клиент совершал заказы, на основе которых рассчитывается персональная скидка.';
COMMENT ON COLUMN person_discounts.discount IS 'Размер персональной скидки, рассчитанной на основе истории заказов клиента.';

-- проверяем добавление
SELECT col_description((SELECT 'person_discounts'::regclass), ordinal_position)
FROM information_schema.columns
WHERE table_name = 'person_discounts';
