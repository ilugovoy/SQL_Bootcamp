-- начать транзакцию
BEGIN;

-- обновление рейтинга "Pizza Hut" до 5 баллов
UPDATE pizzeria SET rating = 5 WHERE name = 'Pizza Hut';

-- убедиться, что изменения видны/не видны
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

-- опубликовать изменения для всех параллельных сессий
COMMIT;
