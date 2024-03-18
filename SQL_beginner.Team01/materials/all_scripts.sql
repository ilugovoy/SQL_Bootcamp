-- SELECT * FROM balance;
-- SELECT * FROM "user";
-- SELECT * FROM currency;

-- Exercise 00: Classical DWH

-- -- ВАРИАНТ №1 С ИСПОЛЬЗОВАНИЕМ CTE (чуток эффективнее)
-- -- создание предварительных агрегированных данных о балансе пользователя и валюте
-- -- EXPLAIN ANALYZE
-- WITH aggregated_user_balance AS (
--       SELECT
-- 			 -- выборка и агрегация баланса пользователей по типу и валюте
-- 			 user_id, 
-- 			 SUM(money) AS total_balance, 
-- 			 type, 
-- 			 currency_id
--         FROM balance
--     GROUP BY user_id, type, currency_id
-- ), 

-- latest_currency_rates AS (
--   SELECT 
-- 		 -- получение последних курсов валют к USD
--          currency.id, 
--          currency.name AS currency_name, 
--          currency.rate_to_usd AS last_rate_to_usd
--     FROM currency
--     JOIN (
--       SELECT 
-- 			  -- поиск последнего обновления курса для каждой валюты
--              id, 
--              name, 
--              MAX(updated) AS max_updated
--         FROM currency 
--     GROUP BY id, name
--     ) AS latest ON currency.id = latest.id AND currency.name = latest.name AND currency.updated = latest.max_updated
-- )

-- -- Выборка и вычисление итогового общего объема в USD с сортировкой
--    SELECT
-- 			COALESCE(usr.name, 'not defined') AS user_name, -- имя пользователя, (при отсутствии выводится "not defined") 
-- 			COALESCE(usr.lastname, 'not defined') AS user_lastname, -- фамилия (при отсутствии "not defined")
-- 			bal.type AS balance_type, -- тип баланса
-- 			bal.total_balance AS total_balance, -- общий баланс пользователя
-- 			COALESCE(cur.currency_name, 'not defined') AS currency_name, -- наименование валюты (при отсутствии "not defined")
-- 			COALESCE(cur.last_rate_to_usd, 1) AS last_rate_to_usd, -- курс валюты к USD, при отсутствии выводится 1 (USD)
-- 			CAST(ROUND(bal.total_balance * COALESCE(cur.last_rate_to_usd, 1), 6) AS real) AS total_balance_in_usd -- общий баланс пользователя в USD с округлением до 6 знаков
--      FROM	aggregated_user_balance AS bal
-- LEFT JOIN	"user" usr ON usr.id = bal.user_id
-- LEFT JOIN	latest_currency_rates cur ON cur.id = bal.currency_id
--  ORDER BY	user_name DESC, user_lastname, balance_type
--  ;


-- -- ВАРИАНТ №2 С ИСПОЛЬЗОВАНИЕМ МАТЕРИАЛИЗОВАННОГО ПРЕДСТАВЛЕНИЯ
-- -- создание материализованного представления для агрегированных данных о балансе пользователя и валюте
-- CREATE 	MATERIALIZED VIEW aggregated_user_balance_mv AS 
-- 	SELECT
-- 			user_id, 
-- 			SUM(money) AS total_balance, 
-- 			type, 
-- 			currency_id
-- 	  FROM	balance
--   GROUP BY	user_id, type, currency_id;

-- -- создание материализованного представления для последних курсов валют к USD
-- CREATE MATERIALIZED VIEW latest_currency_rates_mv AS
--   SELECT 
-- 		 currency.id, 
-- 		 currency.name AS currency_name, 
-- 		 currency.rate_to_usd AS last_rate_to_usd
-- 	FROM currency
-- 	JOIN (
-- 	  SELECT 
-- 			 id, 
-- 			 name, 
-- 			 MAX(updated) AS max_updated
-- 		FROM currency 
-- 	GROUP BY id, name
-- ) AS latest ON currency.id = latest.id AND currency.name = latest.name AND currency.updated = latest.max_updated;

-- -- использование материализованных представлений в основном запросе
-- -- EXPLAIN ANALYZE
-- SELECT
-- 			COALESCE(usr.name, 'not defined') AS user_name,
-- 			COALESCE(usr.lastname, 'not defined') AS user_lastname,
-- 			bal.type AS balance_type,
-- 			bal.total_balance AS total_balance,
-- 			COALESCE(cur.currency_name, 'not defined') AS currency_name,
-- 			COALESCE(cur.last_rate_to_usd, 1) AS last_rate_to_usd,
-- 			CAST(ROUND(bal.total_balance * COALESCE(cur.last_rate_to_usd, 1), 6) AS real) AS total_balance_in_usd
-- 	 FROM	aggregated_user_balance_mv AS bal
-- LEFT JOIN	"user" usr ON usr.id = bal.user_id
-- LEFT JOIN	latest_currency_rates_mv AS cur ON cur.id = bal.currency_id
--  ORDER BY	user_name DESC, user_lastname, balance_type
--  ;	




-- Exercise 01: Detailed Query

-- INSERT INTO currency VALUES (100, 'EUR', 0.85, '2022-01-01 13:29');  
-- INSERT INTO currency VALUES (100, 'EUR', 0.79, '2022-01-08 13:29');
