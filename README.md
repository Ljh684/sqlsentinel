# SQLSentinel

[![CI](https://github.com/Ljh684/sqlsentinel/actions/workflows/ci.yml/badge.svg)](https://github.com/Ljh684/sqlsentinel/actions/workflows/ci.yml)

**Deterministic database change intelligence for SQL, written in MoonBit.**

SQLSentinel is a dependency-light library and CLI for statement-level SQL risk
review and project-level migration planning. It is designed for application
migrations, analytics pipelines, database change review, CI gates, editor
integration, and AI-assisted workflows where teams need deterministic evidence
instead of a raw SQL dump.

SQLSentinel does **not** connect to a database and does not execute SQL. It
lexes source text locally, masks string literals in evidence, and returns stable
findings in text, JSON, Markdown, SARIF 2.1.0, or GitHub annotations.

## Why this project

The MoonBit ecosystem already has SQL parsers, ORMs, and SQLite bindings. A
general-purpose, database-independent SQL **risk review** layer remains much
less represented. SQLSentinel focuses on a different job:

- review a migration or query file before execution;
- explain why a statement is risky;
- produce a deterministic report suitable for CI;
- produce a bounded review packet for a human or LLM reviewer.

This is intentionally not an SQL compatibility checker, query optimizer, or SQL
dialect parser. It uses a conservative structural model and only reports patterns
that can be explained with a source location.

The project-level analyzer goes beyond independent rules: it processes an
ordered migration set, maintains an evolving in-memory schema, and reports
impact, missing objects, incompatible type changes, renames, foreign keys, and
supporting indexes.

## Rules

| ID | Severity | Rule |
| --- | --- | --- |
| SQL001 | error | `UPDATE`/`DELETE` without a top-level `WHERE` or with an always-true predicate |
| SQL002 | error | Destructive DDL such as `DROP TABLE`, `TRUNCATE`, or `DROP COLUMN` |
| SQL003 | warning | Wildcard projection |
| SQL004 | warning | `LIMIT` without `ORDER BY` |
| SQL005 | warning | `LIKE` pattern starting with `%` or `_` |
| SQL006 | warning | Comma-separated table list without explicit `JOIN` |
| SQL007 | warning | `INSERT` without a target-column list |
| SQL008 | warning | Added `NOT NULL` column without `DEFAULT` |
| SQL100 | warning | Malformed or unreachable SQLSentinel directive |
| SQL201 | warning | Destructive operation on a table referenced by another table |
| SQL202 | error | Dropping a column used by an index or foreign key |
| SQL301 | warning | In-place existing column type change |
| SQL302 | error | Migration references a missing schema object |
| SQL303 | warning | Foreign key without a supporting index prefix |
| SQL304 | warning | Table or column rename can break external callers |

Run `sqlsentinel --rules` for the complete rationale and remediation guidance.
SQL201 and SQL202 run only when a local schema catalog is supplied.

### Migration plan analysis

Analyze a multi-file change set as one evolving schema:

```bash
moon run --target native cmd/main -- \
  --format plan \
  --schema examples/plan/schema.json \
  examples/plan
```

Machine-readable and review variants use `--format plan-json` and
`--format plan-markdown`. The plan includes table counts before/after, affected
tables, ordered schema changes, breaking changes, and semantic findings.
[Migration plan analysis](docs/MIGRATION_PLAN.md) documents supported DDL,
ordering rules, and the reusable `analyze_migrations` API.

## Quick start

Requirements:

- MoonBit toolchain from <https://www.moonbitlang.com/download/>
- A native C toolchain supported by MoonBit for the CLI

CI pins MoonBit `0.10.14+7d59c7ec9` so formatting and compilation checks remain
reproducible. Newer toolchains may propose formatter-driven syntax migrations.

```bash
moon update
moon run --target native cmd/main -- examples/safe_query.sql
```

Review a migration directory:

```bash
moon run --target native cmd/main -- \
  --fail-on warning \
  db/migrations
```

Directory inputs are scanned recursively for files ending in `.sql` (case
insensitive). Explicit file inputs are always scanned regardless of extension.
Results are sorted, duplicate files are removed, and the generated/dependency
directories `.git`, `_build`, `.mooncakes`, `node_modules`, and `target` are
skipped.

Path arguments and configured paths may use `*`, `?`, and `**` glob segments:

```bash
moon run --target native cmd/main -- 'db/**/*.sql'
moon run --target native cmd/main -- 'queries/query_?.SQL'
```

Glob matching is case insensitive and only selects files ending in `.sql`.
Quote patterns in shells that would otherwise expand them.

### Project configuration

SQLSentinel automatically loads `.sqlsentinel.json` from the current directory
when present. An explicit path can be selected with `--config`, while
`--no-config` disables discovery:

```bash
moon run --target native cmd/main -- \
  --config examples/sqlsentinel.example.json
```

```json
{
  "paths": ["db/**/*.sql", "queries/**/*.sql"],
  "format": "text",
  "failOn": "error",
  "allowDestructive": false,
  "styleChecks": true,
  "ignore": ["SQL008"],
  "base": "origin/main...HEAD",
  "dialect": "postgres",
  "schema": "schema.json",
  "baseline": ".sqlsentinel/baseline.json",
  "severityOverrides": {
    "SQL008": "error",
    "SQL003": "info"
  }
}
```

Command paths support `*`, `?`, and `**` glob segments. Supported configuration
fields are `paths`, `format`, `failOn`, `allowDestructive`,
`styleChecks`, `ignore`, `base`, `dialect`, `schema`, `baseline`, and
`severityOverrides`. Relative paths, including schema and baseline paths,
resolve from the config file's directory. Unknown fields and invalid values are
errors.

Command-line values override configuration. Positional paths override
`paths`; `--ignore` replaces the configured ignore list; `--strict-destructive`
and `--style` override the corresponding boolean fields. `base` is used when
`--changed` is enabled.

### Schema-aware review

Some risks require knowledge beyond one SQL statement. Supply a small,
version-controlled JSON catalog without connecting to a database:

```json
{
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

`name` and `columns` are required; `nullable`, `indexes`, `foreignKeys`,
`unique`, and object names are optional. The loader rejects duplicate tables or
columns and validates every index and foreign-key column against the catalog.
It remains a local declaration, not a live database introspection result.

Run the example:

```bash
moon run --target native cmd/main -- \
  --schema examples/schema.json \
  examples/schema_risks.sql
```

This reports SQL201 because `orders` references `users`, and SQL202 because
`users.email` is indexed. `--no-schema` disables a schema selected by the
project configuration. The JSON and SARIF reports expose `"schema": true`, and
schema findings are includable in GitHub annotations and suppression audits.
See [Schema catalog](docs/SCHEMA.md) for the complete format and validation
behavior, or use the [JSON Schema](schemas/sqlsentinel-schema.schema.json) for
editor completion.

### Finding baselines

Existing review debt can be recorded once so CI only blocks new findings:

```bash
moon run --target native cmd/main -- \
  --write-baseline .sqlsentinel/baseline.json \
  db/migrations

moon run --target native cmd/main -- \
  --baseline .sqlsentinel/baseline.json \
  --fail-on error \
  db/migrations
```

Baseline fingerprints use normalized paths, rule IDs, non-reversible token
fingerprints, bounded evidence, and occurrence counts. Moving a statement to
another line does not invalidate it; changing a literal or adding another
identical risky statement still produces a finding. Reports include `baseline`
status and a separate `baseline_suppressed` count. Use
`--no-baseline` to disable a configured baseline. See
[Finding baselines](docs/BASELINE.md) for the format and refresh workflow.

### Severity policy overrides

Promote or demote individual rules without editing the project source:

```bash
moon run --target native cmd/main -- \
  --severity SQL008=error,SQL003=info \
  db/migrations
```

Supported levels are `info`, `warning`, and `error`. The first CLI option
replaces configured overrides, and `--no-severity-overrides` disables them.
Effective severities drive failure thresholds and all report totals; the active
override list is recorded in JSON and SARIF. See
[Severity overrides](docs/SEVERITY.md) for precedence and semantics.

### Browser playground

The reusable core compiles to a standalone ES module for local browser use:

```bash
bash scripts/build-web.sh
python3 -m http.server 8080 --directory web/dist
```

Open `http://localhost:8080`. The page supports SQL input, dialect selection,
safe/dangerous/schema examples, an editable schema catalog, schema JSON import
and formatting, finding cards, suppression metrics, Markdown copying, and JSON
download. Schema validation and SQL201/SQL202 run in the browser through the
same MoonBit parser used by the CLI. SQL, schema data, and findings are never
sent over the network.

The static build is committed under `web/dist`. GitHub Pages deployment is
ready in `Deploy Playground`, but Pages must first be enabled under repository
settings. See [Pages deployment](docs/PAGES.md).

Generate a Markdown review packet for a pull request or an AI reviewer:

```bash
moon run --target native cmd/main -- \
  --format markdown \
  --fail-on never \
  db/migrations > sql-review.md
```

Generate SARIF for GitHub code scanning:

```bash
moon run --target native cmd/main -- \
  --format sarif \
  --fail-on never \
  db/migrations > sqlsentinel.sarif
```

Generate GitHub Actions annotations:

```bash
moon run --target native cmd/main -- \
  --format github \
  db/migrations
```

Review only SQL changed from a Git base:

```bash
moon run --target native cmd/main -- --changed

moon run --target native cmd/main -- \
  --changed \
  --base origin/main...HEAD
```

`--changed` defaults to comparing `HEAD` with staged and unstaged tracked
changes. `--base` can select another safe Git revision or range. Added, copied,
modified, and renamed SQL files are considered; deleted files are skipped.
Untracked files must be staged before Git can report them.

Scan an inline statement:

```bash
moon run --target native cmd/main -- \
  --format json \
  --fail-on never \
  --sql "UPDATE users SET active = false;"
```

## CLI

```text
sqlsentinel [options] <file-or-directory>...
sqlsentinel --sql "<SQL text>"
```

Options:

- `--format text|json|markdown|sarif|github|plan|plan-json|plan-markdown`
  selects the output format.
- `--config <path>` selects a project configuration file.
- `--no-config` disables `.sqlsentinel.json` discovery.
- `--fail-on never|info|warning|error` controls the exit threshold.
- `--dialect auto|postgres|mysql|sqlite` selects dialect-sensitive behavior.
- `--schema <path>` loads a local JSON table/index/foreign-key catalog.
- `--no-schema` disables a schema selected by project configuration.
- `--baseline <path>` suppresses findings recorded in a reviewed baseline.
- `--write-baseline <path>` writes the current active findings as a baseline.
- `--no-baseline` disables a baseline selected by project configuration.
- `--allow-destructive` downgrades SQL001 and SQL002 from errors to warnings.
- `--strict-destructive` restores SQL001 and SQL002 to errors.
- `--no-style` disables SQL003 through SQL008 while retaining destructive checks.
- `--style` enables style checks even when disabled in the configuration.
- `--ignore SQL003,SQL005` suppresses specific rules after they have been reviewed.
- `--severity SQL008=error,SQL003=info` overrides effective rule severities.
- `--no-severity-overrides` disables configured severity overrides.
- `--changed` scans only SQL reported by Git as changed.
- `--base <git-ref>` selects the Git comparison base; it implies `--changed`.
- `--rules` prints the rule catalog as Markdown.
- `--help` and `--version` provide CLI metadata.

### Statement-level suppression

Use a directive comment immediately before the statement whose finding has been
reviewed:

```sql
-- sqlsentinel: ignore SQL003
SELECT * FROM legacy_export_view;

SELECT * FROM users; -- SQL003 is still reported here
```

Multiple rules and block comments are supported:

```sql
/* sqlsentinel: ignore SQL003, SQL004 */
SELECT * FROM legacy_export_view LIMIT 100;
```

The directive applies only to the next SQL statement. An unknown rule ID,
unsupported command, missing colon, or directive without a following statement
produces `SQL100`, so a typo cannot silently hide a finding.

Reports always include a suppression audit. Text, JSON, Markdown, and GitHub
output show how many findings were suppressed and the count for each rule, so
review exceptions remain visible instead of silently accumulating.

Exit codes:

- `0`: scan completed and no finding reached the fail threshold;
- `1`: at least one finding reached the fail threshold;
- `2`: invalid arguments or file I/O failure.

## Library API

```mbt
let report = @sqlsentinel.scan_sql(
  "DELETE FROM users WHERE disabled_at IS NOT NULL;",
)

if report.should_fail(@sqlsentinel.FailLevel::Warning) {
  println(@sqlsentinel.report_to_markdown(report))
}
```

The core API performs no I/O and can be embedded in another MoonBit tool:

- `scan_sql(source)`;
- `scan_sql_with(source, options)`;
- `analyze_migrations(inputs, options)` for ordered multi-file schema analysis;
- `SchemaCatalog` and `ScanOptions::new(schema=...)` for embedded schema checks;
- `@schema.parse_schema_json(text, source)` for validated JSON catalogs;
- `report_to_json(report)`;
- `report_to_markdown(report)`;
- `report_to_text(report)`;
- `files_to_sarif(files)`;
- `rule_catalog()`.

## Design choices

**Local and deterministic.** No network, model API, SQL server, or database
driver is required.

**Comments and literals are lexed.** Semicolons or keywords inside strings,
quoted identifiers, nested block comments, and PostgreSQL-style dollar-quoted
strings do not become fake statements.

**Evidence is bounded.** String literals are replaced by `<literal>` in the
evidence field, reducing the chance that a report leaks application data.

**Reports are machine-first.** Findings have stable rule IDs, source locations,
statement indexes, explanations, and remediation text. JSON and SARIF are
directly consumable by automation.

**AI is optional.** Markdown output gives an LLM a narrow, evidence-backed task:
review these findings and the shown SQL excerpt. It does not ask a model to
invent a verdict from an entire repository.

## GitHub Actions

The repository root is a reusable composite action for Linux, macOS, and
Windows runners. It builds the native CLI with a pinned MoonBit toolchain and
runs from the consumer repository directory. See
[GitHub Action usage](docs/GITHUB_ACTION.md).

Minimal usage:

```yaml
jobs:
  sql-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: Ljh684/sqlsentinel@v0.9.0
        with:
          paths: |
            db/**/*.sql
            queries/**
          fail-on: error
```

The project CI also exercises the composite action through `uses: ./`. See
[`.github/workflows/ci.yml`](.github/workflows/ci.yml).

## Current limitations

- The scanner uses a structural lexer, not a complete dialect-specific parser.
  Schema-aware checks rely on the supplied JSON catalog and do not introspect a
  live database.
- Migration plans are conservative and model common table, column, index,
  rename, and foreign-key DDL; they do not execute or fully parse procedural SQL.
- Plan inputs must be ordered. A starting schema catalog is required when the
  first migration does not create every existing table.
- `GO` batch separators and dialect-specific procedural blocks are not yet
  modeled.
- Rules avoid claims about table sizes, lock behavior, or query plans that
  cannot be established from SQL text and the supplied schema metadata.
- Directory discovery currently includes `.sql` files only and uses a fixed
  skip list for common generated/dependency directories.
- Changed-file mode requires a native binary, Git on `PATH`, and a Git checkout.

## Roadmap

- broader dialect-specific DDL and procedural-block coverage;
- custom organization policy packs and severity profiles;
- optional database-dump import for seeded schema catalogs.

## Development

```bash
moon check --target native
moon test --target native
moon fmt --check
moon run --target native cmd/main -- examples/safe_migration.sql
```

Project layout:

```text
types.mbt       public models and rule catalog
lexer.mbt       SQL-aware tokenization and statement splitting
analyzer.mbt    structural checks and report aggregation
schema_analyzer.mbt
                schema-aware cross-object checks
migration_analyzer.mbt
                evolving multi-file schema and migration plan analysis
schema/         shared JSON schema parser and validation
render.mbt      text, JSON, Markdown, and SARIF renderers
cmd/main/       native CLI, baseline loading, and Git integration
action.yml      reusable composite GitHub Action
examples/       safe and intentionally risky SQL files
docs/           project plan and review notes
```

## License

Apache-2.0. See [LICENSE](LICENSE).

Additional project material:

- [One-page project summary](docs/ONE_PAGER.md)
- [Finding baselines](docs/BASELINE.md)
- [Migration plan analysis](docs/MIGRATION_PLAN.md)
- [Initial-review response](docs/REVIEW_RESPONSE.md)
- [Severity overrides](docs/SEVERITY.md)
- [Initial review checklist](docs/REVIEW_CHECKLIST.md)
- [Reusable GitHub Action guide](docs/GITHUB_ACTION.md)
