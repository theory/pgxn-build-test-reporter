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

In Docker:

``` sh
docker run -it --rm -v "$PWD:/repo" --platform linux/amd64 -w /repo pgxn/pgxn-tools bash
make debian-deps
pg-start 16
make run
```

Build only specific distributions:

``` sh
bin/build-test-reporter -v --dist pgtap --dist jsonschema
```

## Load Results

Set [connection environment variables] and run:

```sh
make load
```

## Queries

### Report Outcomes

``` sql
SELECT COUNT(*), result->>'arch' AS arch, COALESCE(result->>'reason', 'Success') AS outcome
  FROM builds
 GROUP BY arch, outcome
 ORDER BY arch, count;
```

### Show Build for Reason

``` sql
SELECT result->>'package'
FROM builds
WHERE result->>'reason' = 'cargo pgrx init failed';
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

### Show pgrx Outcomes

```sql
SELECT result->>'arch' AS arch,
       result->>'package' AS package,
       COALESCE(result->>'reason', 'Success') AS outcome
 FROM builds
WHERE result->>'pipeline' = 'pgrx';
```

## Show Failed Packages For Command

``` sql
SELECT result->>'arch' AS arch,
       result->>'package' AS package
  FROM builds
 WHERE result->>'reason' = 'make failed'
 ORDER BY package;
 ```

## Show Failed Packages For Command and Architecture

``` sql
SELECT result->>'package' AS package
  FROM builds
 WHERE result->>'reason' = 'make failed'
   AND result->>'arch' = 'aarch64-linux'
 ORDER BY package;
```

  [connection environment variables]: https://www.postgresql.org/docs/current/libpq-envars.html
