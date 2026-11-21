# Review response: v0.16.0

This release responds to the initial-review concerns with a project-level
analysis engine rather than additional text-pattern checks.

Run `sqlsentinel --capabilities` for the explicit bounded-semantic pipeline,
precision claims, and unsupported syntax. Plan, impact, and review JSON include
the same metadata under `analysis_model`.

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

## Machine-verifiable generality

Version 0.14.0 adds a statement coverage ledger rather than asking reviewers to
infer parser behavior from examples. Every migration statement produces a
structured trace containing its source span, token count, matched grammar
branch, analyzed/ignored status, and reason. The ledger is available in plan,
impact, and review JSON and is summarized in Markdown.

`--require-full-coverage` makes an ignored statement fail plan, impact, or review
CI output. `examples/coverage/` demonstrates unsupported syntax that remains
visible instead of disappearing. This separates exact supported-grammar behavior
from unsupported SQL without claiming complete database semantics.

Version 0.15.0 carries statement, migration, and downstream-impact findings into
one SARIF 2.1.0 run. `review-sarif` is therefore consumable by GitHub code
scanning without maintaining a separate report pipeline. Verdict, parser
coverage, schema changes, impacted-file count, and the bounded analysis model
remain available as SARIF run properties.

Version 0.16.0 extends the structural migration grammar to MySQL
`MODIFY COLUMN` and `CHANGE COLUMN`. A combined rename and type change emits
both SQL304 and SQL301, and the dialect example participates in automatic
coverage and acceptance checks.

## Functional coverage

The project now spans four layers:

1. statement-level SQL risk checks, suppression, dialects, and explanations;
2. project-level schema evolution and migration impact analysis;
3. policy controls including schema declarations, baselines, and severity
   overrides;
4. integrations including CLI, library API, GitHub Action, SARIF, Markdown,
   JSON, and a browser Playground.

The unified Review Packet combines all three analysis layers into a single
pass/review/block artifact with combined metrics, parser coverage provenance,
and suggested actions.

## Incremental value

Compared with a basic SQL linter, SQLSentinel can answer:

- which tables and columns this migration set changes;
- which changes are destructive or compatibility-sensitive;
- whether migration order references missing objects;
- whether PostgreSQL-style or MySQL column-modification grammar was applied;
- whether a new foreign key has a supporting index;
- which statements matched a specific structural grammar branch;
- which statements were ignored and why;
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
