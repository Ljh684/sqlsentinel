# Downstream query impact

Impact analysis combines an ordered migration set with downstream query sources.
It reports where a schema change can break SQL outside the migration directory.

## Run

```bash
moon run --target native cmd/main -- \
  --format impact-json \
  --schema examples/plan/schema.json \
  examples/plan \
  --query examples/impact/queries
```

Use `impact` for terminal output or `impact-markdown` for review documents.
`--query` may be repeated and accepts files, directories, and glob patterns.

Equivalent project configuration:

```json
{
  "paths": ["db/migrations"],
  "queries": ["services/**/*.sql", "analytics/**/*.sql"],
  "schema": ".sqlsentinel/schema.json",
  "format": "impact-json"
}
```

Relative query paths resolve from the config file's directory.

## Matching

SQL305 correlates every relevant migration change with each query statement:

- drop table and rename table match references to the original table;
- drop column, rename column, and alter column type require both a reference to
  the affected table and the changed column identifier.

The report includes query path, source location, migration change kind, impacted
tables, impacted files, evidence, severity, and remediation. Drop operations are
errors by default; renames and type changes are warnings. `severityOverrides`
and global `ignore` apply to SQL305.

Impact analysis is intentionally conservative. It does not evaluate dynamic SQL,
ORM-generated queries, database views, or procedural code, but its deterministic
source references are useful in CI and review workflows.
