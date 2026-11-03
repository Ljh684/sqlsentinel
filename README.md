# SQLSentinel

**Deterministic SQL safety review for queries and migrations, written in MoonBit.**

SQLSentinel is a dependency-light library and CLI that flags high-impact SQL
review risks before a statement reaches production. It is designed for pull
requests, migration directories, database change reviews, and AI-assisted
development workflows where the reviewer needs concise evidence instead of a
raw SQL dump.

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

## Rules in the first release

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

Run `sqlsentinel --rules` for the complete rationale and remediation guidance.

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
  "base": "origin/main...HEAD"
}
```

Command paths support `*`, `?`, and `**` glob segments. Supported configuration
fields are `paths`, `format`, `failOn`, `allowDestructive`,
`styleChecks`, `ignore`, and `base`. Relative paths resolve from the config
file's directory. Unknown fields and invalid values are errors.

Command-line values override configuration. Positional paths override
`paths`; `--ignore` replaces the configured ignore list; `--strict-destructive`
and `--style` override the corresponding boolean fields. `base` is used when
`--changed` is enabled.

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

- `--format text|json|markdown|sarif|github` selects the output format.
- `--config <path>` selects a project configuration file.
- `--no-config` disables `.sqlsentinel.json` discovery.
- `--fail-on never|info|warning|error` controls the exit threshold.
- `--allow-destructive` downgrades SQL001 and SQL002 from errors to warnings.
- `--strict-destructive` restores SQL001 and SQL002 to errors.
- `--no-style` disables SQL003 through SQL008 while retaining destructive checks.
- `--style` enables style checks even when disabled in the configuration.
- `--ignore SQL003,SQL005` suppresses specific rules after they have been reviewed.
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
      - uses: Ljh684/sqlsentinel@main
        with:
          paths: |
            db/**/*.sql
            queries/**
          fail-on: error
```

The project CI also exercises the composite action through `uses: ./`. See
[`.github/workflows/ci.yml`](.github/workflows/ci.yml).

## Current limitations

- The first release uses a structural lexer, not a complete dialect-specific
  parser. It is conservative and may miss risks that require schema knowledge.
- `GO` batch separators and dialect-specific procedural blocks are not yet
  modeled.
- Rules avoid claims that depend on indexes, table sizes, nullability, or
  database-engine behavior that cannot be established from SQL text alone.
- Directory discovery currently includes `.sql` files only and uses a fixed
  skip list for common generated/dependency directories.
- Changed-file mode requires a native binary, Git on `PATH`, and a Git checkout.

## Roadmap

- dialect profiles for PostgreSQL, MySQL, and SQLite;
- optional WASM playground sharing the same MoonBit core;
- migration diff review and lock-risk rules requiring schema context.

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
render.mbt      text, JSON, Markdown, and SARIF renderers
cmd/main/       native CLI
action.yml      reusable composite GitHub Action
examples/       safe and intentionally risky SQL files
docs/           project plan and review notes
```

## License

Apache-2.0. See [LICENSE](LICENSE).

Additional project material:

- [One-page project summary](docs/ONE_PAGER.md)
- [Initial review checklist](docs/REVIEW_CHECKLIST.md)
- [Reusable GitHub Action guide](docs/GITHUB_ACTION.md)
