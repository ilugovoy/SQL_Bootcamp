CREATE INDEX idx_menu_pizzeria_id ON menu(pizzeria_id); 					--  menu
CREATE INDEX idx_person_visits_person_id ON person_visits(person_id); 		--  person_visits
CREATE INDEX idx_person_visits_pizzeria_id ON person_visits(pizzeria_id); 	--  person_visits
CREATE INDEX idx_person_order_person_id ON person_order(person_id); 		--  person_order
CREATE INDEX idx_person_order_menu_id ON person_order(menu_id);  			--  person_order

-- обновляем статус таблиц и включаем созданные индексы
ANALYZE menu;
ANALYZE pizzeria;
ANALYZE person;
ANALYZE person_visits;
ANALYZE person_order;

-- Поиск всех индексов в базе данных
SELECT * FROM pg_indexes WHERE indexname LIKE 'idx_%';
