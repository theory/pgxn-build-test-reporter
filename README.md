# pgxn-build-test-reporter

## Create the data file:

``` sh
psql -d pgxn -AXqt -o data/distributions.txt <<'SQL'
SELECT format('%s %s', name, max(version))
  FROM distributions
 GROUP BY name
 ORDER BY name
SQL
```
