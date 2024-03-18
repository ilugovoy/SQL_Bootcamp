-- удалить все функции
DO $$
DECLARE
    function_name RECORD;
BEGIN
    FOR function_name IN 
        SELECT routine_schema, routine_name 
        FROM information_schema.routines 
        WHERE routine_type = 'FUNCTION' AND specific_schema NOT IN ('pg_catalog', 'information_schema')
    LOOP
        EXECUTE 'DROP FUNCTION ' || function_name.routine_schema || '.' || function_name.routine_name || ' CASCADE;';
    END LOOP;
END $$;