# Review response: v0.10.0

This release responds to the initial-review concerns with a project-level
analysis engine rather than additional text-pattern checks.

## Analysis depth

Previous behavior evaluated each statement independently. The new
`analyze_migrations` API consumes an ordered migration set and maintains an
evolving schema across files. It models table/column creation and removal, type
changes, renames, indexes, and foreign keys, then reports before/after state,
affected tables, breaking changes, and semantic findings.

Evidence:

- `migration_analyzer.mbt`;
- SQL301–SQL304;
- `plan`, `plan-json`, and `plan-markdown`;
- multi-file examples under `examples/plan`.

The impact layer (`impact_analyzer.mbt`, SQL305) then correlates migration
changes with downstream query sources and identifies query files that reference
dropped, renamed, or incompatible objects.

## Functional coverage

The project now spans four layers:

1. statement-level SQL risk checks, suppression, dialects, and explanations;
2. project-level schema evolution and migration impact analysis;
3. policy controls including schema declarations, baselines, and severity
   overrides;
4. integrations including CLI, library API, GitHub Action, SARIF, Markdown,
   JSON, and a browser Playground.

## Incremental value

Compared with a basic SQL linter, SQLSentinel can answer:

- which tables and columns this migration set changes;
- which changes are destructive or compatibility-sensitive;
- whether migration order references missing objects;
- whether a new foreign key has a supporting index;
- which historical findings are intentionally baselined;
- which rules a project has promoted or demoted.

These outputs are deterministic, locally reproducible, and do not require a
database connection or model API.

## Generality

The same MoonBit core is reusable from applications, migration frameworks,
editors, CI systems, and AI-assisted review tools. Typical scenarios include
application schema migrations, analytics/data-platform DDL, multi-service
change review, policy enforcement, and gradual adoption through baselines.

## Verification

See the repository CI and:

```bash
moon run --target native cmd/main -- \
  --format plan-json \
  --schema examples/plan/schema.json \
  examples/plan
```

The example reports four schema changes and SQL301–SQL304 semantic findings
with a stable, machine-readable impact document.

Cross-source impact can be reproduced with:

```bash
moon run --target native cmd/main -- \
  --format impact-json \
  --schema examples/plan/schema.json \
  examples/plan \
  --query examples/impact/queries
```

It identifies the two downstream query files affected by the example migration
plan through SQL305.
