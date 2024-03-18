DROP INDEX idx_person_order_menu_id;
DROP INDEX idx_person_order_person_id;

CREATE INDEX idx_person_order_multi ON person_order (person_id, menu_id, order_date);
ANALYZE person_order;

EXPLAIN ANALYZE
SELECT	person_id, menu_id, order_date
  FROM	person_order
 WHERE	person_id = 8 AND menu_id = 19;
