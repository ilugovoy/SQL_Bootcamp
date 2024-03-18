-- удаление всех представлений
DO $$
DECLARE
    view_name RECORD;
BEGIN
    FOR view_name IN 
        SELECT table_schema, table_name 
        FROM information_schema.tables 
        WHERE table_type = 'VIEW' AND table_schema NOT IN ('pg_catalog', 'information_schema')
    LOOP
        EXECUTE 'DROP VIEW ' || view_name.table_schema || '.' || view_name.table_name || ' CASCADE;';
    END LOOP;
END $$;