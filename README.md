# SQLSentinel

**Deterministic SQL safety review for queries and migrations, written in MoonBit.**

SQLSentinel is a dependency-light library and CLI that flags high-impact SQL
review risks before a statement reaches production. It is designed for pull
requests, migration directories, database change reviews, and AI-assisted
development workflows where the reviewer needs concise evidence instead of a
raw SQL dump.

SQLSentinel does **not** connect to a database and does not execute SQL. It
lexes source text locally, masks string literals in evidence, and returns stable
findings in text, JSON, Markdown, or SARIF 2.1.0.

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

```bash
moon update
moon run --target native cmd/main -- examples/safe_query.sql
```

Review a migration directory:

```bash
moon run --target native cmd/main -- \
  --fail-on warning \
  db/migrations/*.sql
```

Generate a Markdown review packet for a pull request or an AI reviewer:

```bash
moon run --target native cmd/main -- \
  --format markdown \
  --fail-on never \
  db/migrations/*.sql > sql-review.md
```

Generate SARIF for GitHub code scanning:

```bash
moon run --target native cmd/main -- \
  --format sarif \
  --fail-on never \
  db/migrations/*.sql > sqlsentinel.sarif
```

Scan an inline statement:

```bash
moon run --target native cmd/main -- \
  --format json \
  --fail-on never \
  --sql "UPDATE users SET active = false;"
```

## CLI

```text
sqlsentinel [options] <file.sql>...
sqlsentinel --sql "<SQL text>"
```

Options:

- `--format text|json|markdown|sarif` selects the output format.
- `--fail-on never|info|warning|error` controls the exit threshold.
- `--allow-destructive` downgrades SQL001 and SQL002 from errors to warnings.
- `--no-style` disables SQL003 through SQL008 while retaining destructive checks.
- `--ignore SQL003,SQL005` suppresses specific rules after they have been reviewed.
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

The repository includes a CI workflow that checks formatting, builds the native
CLI, runs tests, validates JSON/SARIF output, and verifies that a dangerous
example is actually rejected. See
[`.github/workflows/ci.yml`](.github/workflows/ci.yml).

For a consuming repository, a minimal job is:

```yaml
jobs:
  sql-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up MoonBit
        run: |
          curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
          echo "$HOME/.moon/bin" >> "$GITHUB_PATH"
      - name: Review SQL
        run: |
          moon update
          moon run --target native cmd/main -- \
            --fail-on error db/migrations/*.sql
```

## Current limitations

- The first release uses a structural lexer, not a complete dialect-specific
  parser. It is conservative and may miss risks that require schema knowledge.
- `GO` batch separators and dialect-specific procedural blocks are not yet
  modeled.
- Rules avoid claims that depend on indexes, table sizes, nullability, or
  database-engine behavior that cannot be established from SQL text alone.
- The CLI does not recursively expand directories by itself. Use a shell glob or
  a file discovery step in CI.

## Roadmap

- Rule and path configuration in a checked-in config file;
- audit counts for inline suppression directives;
- recursive directory discovery and changed-file filtering;
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
examples/       safe and intentionally risky SQL files
docs/           project plan and review notes
```

## License

Apache-2.0. See [LICENSE](LICENSE).
