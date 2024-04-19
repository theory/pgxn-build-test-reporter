CREATE TABLE IF NOT EXISTS builds ( result JSONB );
TRUNCATE builds;
\copy builds FROM PROGRAM 'cat data/*.log | sed "s|\\\\|\\\\\\\\|g"'
