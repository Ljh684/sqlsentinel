# Changelog

All notable changes to SQLSentinel will be documented here.

## 0.1.0

- Add a dependency-free SQL-aware lexer.
- Add eight SQL safety and portability rules.
- Add text, JSON, Markdown, and SARIF 2.1.0 output.
- Add a native CLI with configurable failure thresholds.
- Add statement-level `sqlsentinel: ignore` directives and SQL100 diagnostics.
- Add deterministic recursive `.sql` discovery with duplicate removal and
  generated-directory filtering.
- Add `--changed` and `--base` Git-aware review selection for native CLI runs.
- Add `.sqlsentinel.json` project configuration with CLI override precedence.
- Add case-insensitive `*`, `?`, and `**` path matching for SQL files.
- Add safe and intentionally risky migration examples.
- Add unit tests and a GitHub Actions verification workflow.
