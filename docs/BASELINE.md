# Finding baselines

A baseline records findings that have already been reviewed so CI can block new
SQL risks without requiring every historical issue to be fixed first.
The machine-readable format is defined by
[`schemas/sqlsentinel-baseline.schema.json`](../schemas/sqlsentinel-baseline.schema.json).

## Create

Scan the project once and write its current findings:

```bash
moon run --target native cmd/main -- \
  --write-baseline .sqlsentinel/baseline.json \
  db/migrations
```

`--write-baseline` scans with the current CLI, schema, dialect, ignore, and
style settings. It writes only findings that remain active after statement and
rule suppression. Baseline creation is an explicit maintenance action and exits
successfully unless scanning or writing fails.

## Use

```bash
moon run --target native cmd/main -- \
  --baseline .sqlsentinel/baseline.json \
  --fail-on error \
  db/migrations
```

Or configure it relative to `.sqlsentinel.json`:

```json
{
  "paths": ["db/migrations"],
  "baseline": ".sqlsentinel/baseline.json"
}
```

`--no-baseline` disables a configured baseline. An explicit `--baseline`
overrides configuration. `--baseline` and `--write-baseline` are mutually
exclusive.

## Matching

Each record compares a normalized path, rule ID, non-reversible token
fingerprint, bounded SQL evidence, and occurrence count:

```json
{
  "schema_version": "1.0",
  "tool": "SQLSentinel baseline",
  "findings": [
    {
      "path": "db/migrations/001_cleanup.sql",
      "rule_id": "SQL001",
      "evidence": "DELETE FROM users",
      "fingerprint": "14695981039346656037",
      "count": 1
    }
  ]
}
```

Line and column movements do not invalidate a match. Path separators and case
are normalized. The fingerprint is computed from the complete token stream,
including literals, so changing `%alice%` to `%secret%` creates a new finding
without storing either literal. Older baselines without a fingerprint fall back
to case-insensitive evidence matching. Repeating the same finding adds to
`count`, so a baseline containing one occurrence cannot hide a second newly
added occurrence.

Renaming a file or materially rewriting the matched statement creates a new
finding. This is intentional: the reviewer should explicitly refresh the
baseline after those changes.

## Audit

Text, JSON, Markdown, SARIF, and GitHub summary output expose:

- whether baseline filtering was enabled;
- how many findings were suppressed by the baseline;
- the remaining active error, warning, and info counts.

Baseline suppression is additional to inline and global rule suppression.
Evidence already masks string literals, so baseline files do not store literal
application values.
