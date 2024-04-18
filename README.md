# pgxn-build-test-reporter

## Create the data file:

``` sh
psql -d pgxn -AXqt -o distributions.txt <<'SQL'
SELECT format('%s %s', name, max(version))
  FROM distributions
 GROUP BY name
 ORDER BY name
SQL
```

# Run a Report

Will read the contents of [`data/distributions.txt](./data/distributions.txt)
and write out a report in the `data` directory.

```sh
make run
```

## Load Results

Set [connection environment variables] and run:

```sh
make load
```

## Queries

### Report Outcomes

``` sql
SELECT COUNT(*), COALESCE(result->>'reason', 'Success') AS outcome
  FROM builds
 GROUP BY outcome
 ORDER BY count;
```

### Show Failed Command

``` sql
SELECT jsonb_pretty(jsonb_path_query(result, '$.steps[last]'))
  FROM builds
 WHERE result->>'package' = 'pg_later';
```

```sh
psql -AXqt <<'SQL'
SELECT jsonb_pretty(jsonb_path_query(result, '$.steps[last]'))
  FROM builds
 WHERE result->>'package' = 'pg_later';
SQL
```



  [connection environment variables]: https://www.postgresql.org/docs/current/libpq-envars.html