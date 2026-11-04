# Changelog

All notable changes to SQLSentinel will be documented here.

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
