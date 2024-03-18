DO $$
DECLARE
    l_rec record;
BEGIN
    FOR l_rec IN (SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname = 'public') 
    LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || l_rec.tablename || ' CASCADE';
    END LOOP;
END $$;