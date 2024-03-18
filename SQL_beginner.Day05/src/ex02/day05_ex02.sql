CREATE INDEX idx_person_name ON person(UPPER(name));
ANALYZE person;
SELECT * FROM pg_indexes WHERE indexname = 'idx_person_name';

EXPLAIN ANALYZE SELECT * FROM person WHERE UPPER(name) IN ('DMITRIY');
