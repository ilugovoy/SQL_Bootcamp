-- создание функции PL/pgSQL func_minimum с обработкой целых чисел без десятичной точки
CREATE OR REPLACE FUNCTION func_minimum(VARIADIC arr numeric[]) RETURNS text AS $$
DECLARE
    min_val numeric;  -- переменная для содержания минимального значения
    result_text text;  -- переменная для вывода результата
BEGIN
    SELECT MIN(val) INTO min_val FROM unnest(arr) AS val; -- выборка минимального значения из массива
    IF min_val = ROUND(min_val) THEN
        result_text := to_char(min_val, '9,999'); -- преобразование целого числа без десятичной точки в текст
    ELSE
        result_text := to_char(min_val, '9,999.9'); -- преобразование числа с десятичной точкой в текст
    END IF;
    RETURN result_text;  -- возврат минимального значения в виде текста
END;
$$ LANGUAGE plpgsql;

-- вызов функции для поиска минимального значения из массива
SELECT func_minimum(VARIADIC ARRAY[10.0, -1.0, 5.0, 4.4]);
