# Schema catalog

SQLSentinel can use a small, version-controlled JSON catalog to evaluate risks
that span tables. It never connects to a database and never executes SQL.

## Format

```json
{
  "$schema": "../schemas/sqlsentinel-schema.schema.json",
  "tables": [
    {
      "name": "users",
      "columns": [
        {"name": "id", "nullable": false},
        {"name": "email", "nullable": false}
      ],
      "indexes": [
        {"name": "users_email", "columns": ["email"], "unique": true}
      ]
    },
    {
      "name": "orders",
      "columns": [
        {"name": "id", "nullable": false},
        {"name": "user_id", "nullable": false}
      ],
      "foreignKeys": [
        {
          "name": "orders_user_fk",
          "columns": ["user_id"],
          "references": {"table": "users", "columns": ["id"]}
        }
      ]
    }
  ]
}
```

The catalog format is described by
[`schemas/sqlsentinel-schema.schema.json`](../schemas/sqlsentinel-schema.schema.json).
Add the `$schema` field in editors that support JSON Schema completion.

Required fields are `tables`, each table's `name` and non-empty `columns`, each
index's `columns`, and each foreign key's local `columns` plus `references`.
Object names and `nullable`/`unique` flags are optional. A nullable column
defaults to `false`; an index or foreign key defaults to `false` uniqueness.

## Checks

| Rule | Severity | Condition |
| --- | --- | --- |
| SQL201 | warning | `DELETE`, `DROP`, or `TRUNCATE` targets a table referenced by an inbound foreign key |
| SQL202 | error | `ALTER TABLE ... DROP COLUMN` removes a column used by a local index, a local foreign key, or an inbound foreign key |

SQL202 identifies the exact dropped column in the report. SQL201 lists the
dependent tables in its message so the reviewer can inspect the relationship
before running a migration.

## Loading

Pass a catalog directly:

```bash
moon run --target native cmd/main -- \
  --schema .sqlsentinel/schema.json \
  db/migrations
```

Or configure one relative to `.sqlsentinel.json`:

```json
{
  "paths": ["db/migrations"],
  "schema": ".sqlsentinel/schema.json"
}
```

`--no-schema` disables the configured catalog. Supplying `--schema` after
`--no-schema` enables it again. An unreadable or invalid catalog exits with
code `2`.

## Validation rules

The loader rejects:

- an empty catalog or a table without columns;
- duplicate table, column, index, or foreign-key names (case-insensitive);
- indexes or foreign keys that mention unknown columns;
- foreign keys that mention unknown target tables or target columns;
- repeated columns inside one index;
- composite foreign keys whose local and target column counts differ.

Names are matched case-insensitively. The catalog is a review aid, not a
database migration source and not a substitute for live database validation.

The same parser and validation rules power the browser Playground, where the
catalog can be edited, imported, formatted, or disabled without sending data to
another service.
