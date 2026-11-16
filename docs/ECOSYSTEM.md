# Ecosystem positioning

Mooncakes contains multiple relevant database packages. SQLSentinel does not
claim that no overlapping work exists. It documents the nearest projects and the
boundary of its contribution.

## Nearest packages

| Project | Primary job | Relationship to SQLSentinel |
| --- | --- | --- |
| [`kath61105/moon_schema_plan`](https://github.com/kath61105/moon-schema-plan) | Diff two explicit schema descriptions, gate destructive changes, generate SQLite/PostgreSQL SQL | Closest overlap in migration planning. SQLSentinel starts from ordered migration SQL, tracks applied state, and correlates changes with downstream query source. It does not generate migration SQL. |
| [`lyjttio/moon-data-contract`](https://github.com/lyjttio/moon-data-contract) | Contract/schema governance, payload validation, compatibility and migration planning | Focuses on data contracts and payload compatibility. SQLSentinel focuses on SQL source review, migration state, and query references. |
| [`Milky2018/sqlparser`](https://github.com/Milky2018/sqlparser-mbt) | Extensible SQL lexer/parser | A parser can act as an alternative front end; SQLSentinel contributes policy, migration state, impact, reports, and CI behavior. |
| [`bobzhang/sqlglot`](https://github.com/bobzhang/sqlglot.mbt) | SQL parser/transpiler/optimizer | SQLSentinel does not transpile or optimize SQL. It reviews risks and project-level change impact. |
| SQLite/PostgreSQL/MySQL drivers and ORMs | Connection, query execution, typed query construction | SQLSentinel never connects to or executes on a database, so it can run in CI before credentials or infrastructure exist. |

## Distinctive combination

The project combines capabilities that are individually present elsewhere but
rarely in one workflow:

1. static statement-level risk findings;
2. ordered multi-file DDL state simulation;
3. changed-table/column to downstream-query impact;
4. baselines and per-rule severity policy;
5. SARIF/GitHub annotations and a unified review packet;
6. a pure, database-independent MoonBit core usable from CLI, Action, and web.

## Honest boundary

SQLSentinel is complementary to schema-diff planners and full SQL parsers. It
does not attempt to be a database engine or a complete SQL compatibility layer.
Its ecosystem value is the auditable review workflow around migration source and
affected consumers.
