# SQLSentinel v0.16.0

SQLSentinel is a deterministic database-change analysis engine written in
MoonBit. It reviews SQL without a database connection and combines
statement-level risks, ordered schema evolution, and downstream query impact.

## Highlights

- 15 stable risk rules plus directive diagnostics.
- Multi-file DDL planning with evolving table, column, type, index, and foreign
  key state.
- PostgreSQL-style type changes plus MySQL `MODIFY COLUMN` and `CHANGE COLUMN`.
- SQL301-SQL305 migration and downstream-impact findings.
- Statement-level parser coverage with source spans, grammar branches,
  analyzed/ignored status, and reasons.
- `--require-full-coverage` for strict CI enforcement.
- Unified `pass` / `review` / `block` review packets.
- `review-sarif`, a single SARIF 2.1.0 report containing statement, migration,
  and query-impact findings for GitHub code scanning.
- Native CLI, reusable library API, composite GitHub Action, and browser
  playground.

## Verification

```powershell
.\scripts\acceptance.ps1
```

The acceptance run verifies formatting, all targets, 83 Native tests, 79
Wasm-GC tests, package creation, strict coverage behavior, migration/impact/
review reports, unified SARIF, and the browser build.

Representative commands:

```powershell
moon run --target native cmd/main -- --capabilities
moon run --target native cmd/main -- --format plan-json `
  --schema examples/plan/schema.json examples/plan
moon run --target native cmd/main -- --format review-sarif `
  --schema examples/plan/schema.json examples/plan `
  --query examples/impact/queries
```

## Distribution

- Package: `Ljh684-sqlsentinel-0.16.0.zip`
- Registry: `Ljh684/sqlsentinel@0.16.0` on mooncakes.io
- License: Apache-2.0
- Primary implementation: MoonBit
- Runtime network/model dependency: none

## Boundaries

This release intentionally does not claim a complete SQL AST, database
execution semantics, live schema introspection, query-plan analysis, or
procedural/dynamic SQL support. Unsupported migration statements are exposed as
ignored coverage traces rather than silently accepted.

See `docs/ACCEPTANCE.md`, `docs/ANALYSIS_MODEL.md`, and
`docs/REVIEW_RESPONSE.md` for the full acceptance mapping and technical
rationale.

The generated captioned walkthrough is available at
`docs/media/sqlsentinel-demo.mp4`.
