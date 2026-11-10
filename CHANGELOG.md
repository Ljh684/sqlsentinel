# Changelog

All notable changes to SQLSentinel will be documented here.

## 0.10.0 - 2026-11-11

- Add downstream query impact analysis across migration and query inputs.
- Add query discovery via `--query` and project `queries` configuration.
- Add SQL305 schema-to-query dependency findings.
- Add `impact`, `impact-json`, and `impact-markdown` formats.
- Add `analyze_change_impact` library API, Action input, examples, and CI.

## 0.9.0 - 2026-11-11

- Add ordered multi-file migration plan analysis with evolving schema state.
- Track create/drop table, add/drop column, type changes, renames, indexes, and foreign keys.
- Add SQL301 type-change, SQL302 missing-object, SQL303 foreign-key-index, and SQL304 rename rules.
- Add `plan`, `plan-json`, and `plan-markdown` CLI output formats.
- Add the reusable `analyze_migrations` library API and migration renderers.
- Add migration-plan examples, Action coverage, and CI verification.

## 0.8.0 - 2026-11-07

- Add per-rule severity overrides to the library options and scanner.
- Add `--severity` and `--no-severity-overrides` CLI policy controls.
- Add `severityOverrides` project configuration and Action input.
- Audit effective override policy in text, Markdown, JSON, and SARIF reports.
- Preserve severity policy through baseline filtering.

## 0.7.0 - 2026-11-07

- Add JSON finding baselines with normalized path, rule, token fingerprint, evidence, and count.
- Add `--baseline`, `--write-baseline`, and `--no-baseline`.
- Add project-config and GitHub Action baseline inputs.
- Expose baseline status and separately audited suppression counts in reports.
- Add CLI integration tests proving historical findings pass while new ones fail.

## 0.6.0 - 2026-11-07

- Share the validated schema parser between the CLI and browser playground.
- Add a browser schema editor with enable, import, and JSON formatting controls.
- Return JSON and Markdown together for schema-aware browser scans.
- Add SQL201/SQL202 browser examples and invalid-schema diagnostics.
- Extend browser smoke tests and static demo documentation.

## 0.5.0 - 2026-11-05

- Add SQL201 for destructive operations on tables referenced by foreign keys.
- Add SQL202 for dropping columns used by indexes or foreign-key relationships.
- Add validated local schema catalogs with a machine-readable JSON Schema.
- Add `--schema`, `--no-schema`, project-config, Action, JSON, and SARIF support.
- Add schema-aware examples and end-to-end CI verification.

## 0.4.0 - 2026-11-05

- Publish a static browser playground build and add Pages-ready deployment.
- Add Markdown download, suppression details, favicon, and stale-build CI checks.

## 0.3.0 - 2026-11-04

- Add a browser playground with JSON and Markdown exports.

## 0.2.0 - 2026-11-04

- Add `auto`, `postgres`, `mysql`, and `sqlite` dialect profiles.
- Elevate SQLite `NOT NULL` column additions to errors.
- Gate `ILIKE` performance checks to PostgreSQL and generic mode.

## 0.1.0

- Add a dependency-free SQL-aware lexer.
- Add eight SQL safety and portability rules.
- Add text, JSON, Markdown, SARIF 2.1.0, and GitHub annotation output.
- Add a native CLI with configurable failure thresholds.
- Add statement-level `sqlsentinel: ignore` directives and SQL100 diagnostics.
- Add deterministic recursive `.sql` discovery with duplicate removal and
  generated-directory filtering.
- Add `--changed` and `--base` Git-aware review selection for native CLI runs.
- Add `.sqlsentinel.json` project configuration with CLI override precedence.
- Add case-insensitive `*`, `?`, and `**` path matching for SQL files.
- Add a reusable composite GitHub Action for Linux, macOS, and Windows runners.
- Add GitHub workflow annotation output and NUL-safe changed-file parsing.
- Add suppression audit counts to every report format.
- Add safe and intentionally risky migration examples.
- Add unit tests and a GitHub Actions verification workflow.
