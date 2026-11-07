# Severity overrides

Projects can promote or demote individual built-in rules without changing the
default rule catalog.

## Configuration

```json
{
  "paths": ["db/migrations"],
  "severityOverrides": {
    "SQL008": "error",
    "SQL003": "info"
  }
}
```

Supported levels are `info`, `warning`, and `error`. Rule IDs must be known
built-in IDs. Matching is case-insensitive and output is sorted by rule ID.

## Command line

```bash
moon run --target native cmd/main -- \
  --severity SQL008=error,SQL003=info \
  db/migrations
```

The first `--severity` option replaces the configured override list. Further
`--severity` options append entries, and duplicate rules are rejected.
`--no-severity-overrides` disables the configured list.

## Semantics

Overrides are applied after inline/global finding suppression and before the
failure threshold and severity totals are calculated. JSON, text, Markdown,
SARIF, and GitHub output use the effective severity, and all report formats
record the active override list.

Baselines identify findings independently of severity. A later policy change
continues to match the same reviewed finding while updating its effective
severity.

The default catalog remains visible through `sqlsentinel --rules`, so report
overrides can always be compared with the documented defaults.
