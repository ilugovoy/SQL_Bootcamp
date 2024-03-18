-- создание функции PL/pgSQL fnc_fibonacci
CREATE OR REPLACE FUNCTION fnc_fibonacci(pstop INTEGER DEFAULT 10) 
RETURNS TABLE (fib_num BIGINT) AS $$
	DECLARE
		a BIGINT := 0;  -- первое число Фибоначчи
		b BIGINT := 1;  -- второе число Фибоначчи
		temp BIGINT;     -- временная переменная для обмена значений
		BEGIN
			fib_num := a;  -- возвращаем первое число Фибоначчи
			RETURN NEXT;

			WHILE b < pstop LOOP
				fib_num := b;  -- возвращаем текущее число Фибоначчи
				RETURN NEXT;

				temp := a + b;  -- подсчет следующего числа Фибоначчи
				a := b;
				b := temp;
			END LOOP;

			RETURN;  -- завершение функции
		END;
$$ LANGUAGE plpgsql;

-- вызов функции для получения всех чисел Фибоначчи, меньших, чем 20
SELECT * FROM fnc_fibonacci(20);

-- вызов функции для получения всех чисел Фибоначчи, меньших, чем 10 (значение по умолчанию)
SELECT * FROM fnc_fibonacci();
