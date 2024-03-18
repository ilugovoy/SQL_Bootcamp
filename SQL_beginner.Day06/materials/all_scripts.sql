-- Day 06
-- Exercise 00: Discounts, discounts , everyone loves discounts

CREATE TABLE person_discounts (
     		id 	SERIAL PRIMARY KEY, -- автоматически генерирует уникальные значения при вставке новой записи
      person_id 	BIGINT,
    pizzeria_id 	BIGINT,
       discount 	NUMERIC,
     CONSTRAINT 	fk_person_discounts_person_id FOREIGN KEY (person_id) REFERENCES person(id),
     CONSTRAINT 	fk_person_discounts_pizzeria_id FOREIGN KEY (pizzeria_id) REFERENCES pizzeria(id)
);




-- Exercise 01: Let’s set personal discounts

-- создаем СТЕ для подсчета количества заказов 
WITH order_counts AS (
    SELECT person_order.person_id, 
           menu.pizzeria_id, 
           COUNT(*) AS order_count -- считаем кол-во заказов для каждой уникальной комбинации person_id и pizzeria_id
      FROM person_order
     JOIN menu ON person_order.menu_id = menu.id -- присоединяем таблицу menu для получения информации о пиццерии
  GROUP BY person_order.person_id, menu.pizzeria_id -- группируем результаты по person_id и pizzeria_id
)

INSERT INTO person_discounts (id, person_id, pizzeria_id, discount)
-- вставляем данные в таблицу person_discounts
SELECT ROW_NUMBER() OVER () AS id, -- генерируем уникальные значения id
       order_counts.person_id,
       order_counts.pizzeria_id, 
       CASE
        WHEN order_counts.order_count = 1 THEN 10.5
        WHEN order_counts.order_count = 2 THEN 22
        ELSE 30
       END AS discount -- рассчитываем значение скидки основываясь на количестве заказов
  FROM order_counts; 

SELECT * FROM person_discounts;




-- Exercise 02: Let’s recalculate a history of orders	

WITH discounted_orders AS
(
    -- создаем СТЕ для получения истории заказов с учетом примененной скидки
    SELECT person.name,
           menu.pizza_name, 
           menu.price,
           ROUND((menu.price * ((100 - pd.discount) / 100))) AS discount_price, -- рассчитываем цену со скидкой на основе примененной скидки из таблицы person_discounts
           piz.name AS pizzeria_name 
    FROM person_order AS po
    JOIN person ON person.id = po.person_id 
    JOIN menu ON po.menu_id = menu.id 
    JOIN pizzeria AS piz ON menu.pizzeria_id = piz.id 
    JOIN person_discounts AS pd ON (po.person_id = pd.person_id AND menu.pizzeria_id = pd.pizzeria_id)
)
-- извлекаем все столбцы из СТЕ
SELECT * FROM discounted_orders ORDER BY 1, 2;




-- Exercise 03: Improvements are in a way

CREATE UNIQUE INDEX idx_person_discounts_unique ON person_discounts (person_id, pizzeria_id);
ANALYZE person_discounts;

SET ENABLE_SEQSCAN TO OFF;
EXPLAIN ANALYZE
SELECT * from person_discounts WHERE person_id = 1 AND pizzeria_id = 1;






-- Exercise 04: We need more Data Consistency	

ALTER TABLE person_discounts
    ADD CONSTRAINT ch_nn_person_id CHECK (person_id IS NOT NULL), -- не должен быть NULL
    ADD CONSTRAINT ch_nn_pizzeria_id CHECK (pizzeria_id IS NOT NULL), -- не должен быть NULL
    ADD CONSTRAINT ch_nn_discount CHECK (discount IS NOT NULL), -- не должен быть NULL
    ADD CONSTRAINT ch_range_discount CHECK (discount >= 0 AND discount <= 100); -- должен быть в диапазоне от 0 до 100

ALTER TABLE person_discounts
    ALTER COLUMN discount SET DEFAULT 0; -- установка столбца discount по умолчанию на 0 процентов




-- Exercise 05: Data Governance Rules

 COMMENT ON TABLE person_discounts IS 'Эта таблица хранит информацию о персональных скидках, предоставляемых на основе истории заказов конкретных клиентов в конкретных пиццериях.';
COMMENT ON COLUMN person_discounts.person_id IS 'Идентификатор клиента, для которого рассчитывается персональная скидка.';
COMMENT ON COLUMN person_discounts.pizzeria_id IS 'Идентификатор пиццерии, в которой клиент совершал заказы, на основе которых рассчитывается персональная скидка.';
COMMENT ON COLUMN person_discounts.discount IS 'Размер персональной скидки, рассчитанной на основе истории заказов клиента.';

-- проверяем добавление
SELECT col_description((SELECT 'person_discounts'::regclass), ordinal_position)
FROM information_schema.columns
WHERE table_name = 'person_discounts';



-- Exercise 06: Let’s automate Primary Key generation	

CREATE SEQUENCE seq_person_discounts START 1; -- создание последовательности базы данных

ALTER TABLE person_discounts
ALTER COLUMN id SET DEFAULT nextval('seq_person_discounts'); -- установка значения по умолчанию для атрибута id в таблице person_discounts

-- -- Создаем последовательность базы данных с именем seq_person_discounts, начиная с значения 1.
-- -- Изменяем таблицу person_discounts, устанавливая значение по умолчанию для атрибута id, чтобы оно автоматически бралось из последовательности seq_person_discounts при вставке новых записей.
-- -- Это позволит автоматически присваивать значения атрибуту id из созданной последовательности и избежать нарушений первичного ключа при вставке новых записей.












