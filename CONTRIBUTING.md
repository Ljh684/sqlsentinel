# Contributing

## Development

```bash
moon update
moon fmt
moon check --target native
moon test --target native
```

Before opening a pull request, run the full acceptance harness:

```powershell
.\scripts\acceptance.ps1
```

On Linux/macOS use `bash scripts/acceptance.sh`.

Run the CLI against the examples before opening a pull request:

```bash
moon run --target native cmd/main -- examples/safe_migration.sql
```

## Adding a rule

A new rule should include:

1. A stable `SQLNNN` identifier;
2. a conservative detection strategy that does not require schema knowledge;
3. a clear risk explanation and remediation;
4. a positive test and a nearby false-positive regression test;
5. an entry in `rule_catalog()`.

Prefer extending the shared token model over matching raw SQL with regular
expressions. This keeps strings, quoted identifiers, and comments from producing
misleading findings.

State changes and new rules should be covered by the semantic fixtures and
should update `docs/ANALYSIS_MODEL.md` when they expand or reduce the supported
grammar.

## Reporting false positives

Include the smallest SQL statement that reproduces the issue, the database
dialect if relevant, the observed finding, and why the pattern is intentional.
Do not include production credentials, customer data, or full production dumps.
