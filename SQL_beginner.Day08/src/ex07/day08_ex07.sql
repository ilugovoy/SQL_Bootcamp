-- Сессия №1
BEGIN;
UPDATE pizzeria SET rating = 4.99 WHERE id = 1;
UPDATE pizzeria SET rating = 4.99 WHERE id = 2;
COMMIT;
SELECT * FROM pizzeria WHERE id IN (1,2);

-- Сессия №2
BEGIN;
UPDATE pizzeria SET rating = 3.99 WHERE id = 2;
UPDATE pizzeria SET rating = 3.99 WHERE id = 1;
COMMIT;
SELECT * FROM pizzeria WHERE id IN (1,2);

-- Вернуть изменения в рейтинге (в любой сессии)
BEGIN;
UPDATE pizzeria SET rating = 5 WHERE id = 1; -- pizzeria.id 1 это Pizza Hut с рейтингом 5
UPDATE pizzeria SET rating = 4.3 WHERE id = 2; -- pizzeria.id 2 это Dominos с рейтингом 4.3
COMMIT;
SELECT * FROM pizzeria WHERE id IN (1,2);