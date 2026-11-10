# Migration plan analysis

SQLSentinel can analyze an ordered set of migration files while maintaining an
in-memory schema. This is project-level analysis rather than a collection of
independent statement checks.

## Run

```bash
moon run --target native cmd/main -- \
  --format plan \
  --schema examples/plan/schema.json \
  examples/plan
```

Machine-readable and pull-request variants:

```bash
moon run --target native cmd/main -- \
  --format plan-json \
  --schema examples/plan/schema.json \
  examples/plan

moon run --target native cmd/main -- \
  --format plan-markdown \
  --schema examples/plan/schema.json \
  examples/plan
```

Directory discovery is deterministic and sorted before analysis. Library
callers pass `MigrationInput` records in execution order. Supplying a schema
catalog is strongly recommended when a change set starts from an existing
database rather than creating every table itself.

Plan formats are standalone analysis modes and cannot be combined with
`--baseline` or `--write-baseline`; use the normal JSON/text formats for
baseline-managed statement findings.

## Tracked changes

- create and drop table;
- add and drop column;
- alter column type;
- rename table and column;
- create index;
- add foreign key.

The result includes before/after table snapshots, affected tables, ordered
schema changes, breaking-change count, findings, and severity totals.

## Semantic rules

| Rule | Severity | Condition |
| --- | --- | --- |
| SQL301 | warning | An existing column type is changed in place |
| SQL302 | error | ALTER, index, or foreign-key work references a missing table or column |
| SQL303 | warning | An added foreign key has no index with a matching leading column prefix |
| SQL304 | warning | A table or column rename can break callers outside the change set |

Rule severities still honor `severityOverrides`, and global `ignore` settings
also apply to plan findings.

## Library API

```mbt
let analysis = @sqlsentinel.analyze_migrations(
  [
    @sqlsentinel.MigrationInput::{
      path: "db/001.sql",
      source: ddl_text,
    },
  ],
  @sqlsentinel.ScanOptions::new(schema=catalog),
)
```

Use `migration_analysis_to_json`, `migration_analysis_to_markdown`, or
`migration_analysis_to_text` to render the result.

This is a conservative structural migration model, not a complete SQL parser or
database execution engine. Dialect-specific procedural blocks, expression
semantics, and destructive data operations inside DML should still use the
statement-level rules and normal database review.
