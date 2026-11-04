# Initial Review Checklist

## Product value

- [x] Solves a concrete pre-deployment database review problem.
- [x] Works without a database connection or live schema.
- [x] Produces actionable explanations and remediation, not only parser errors.
- [x] Supports local CLI, library, SARIF, and GitHub Pull Request annotations.
- [x] Keeps AI review optional and bounded to deterministic findings.

## MoonBit implementation

- [x] Core lexer, analyzer, reports, and rule catalog are implemented in MoonBit.
- [x] The library API performs no I/O and compiles across all configured targets.
- [x] Native-only Git integration is isolated in the CLI package.
- [x] Official MoonBit tooling is pinned in CI.

## Engineering quality

- [x] SQL comments, quoted identifiers, dollar-quoted strings, and semicolons are
  covered by tests.
- [x] Rules have stable IDs, severities, rationale, and remediation.
- [x] Config, glob, recursive directory, Git changes, and statement directives
  have positive and failure-path tests.
- [x] Suppressed findings remain visible through audit counts.
- [x] Schema catalogs validate references, duplicate names, and composite keys.
- [x] SQL201/SQL202 reach JSON, SARIF, annotations, and suppression audits.
- [x] CI checks formatting, all-target type checking, tests, examples, JSON,
  SARIF, configuration, annotations, and the reusable Action.

## Open-source readiness

- [x] Apache-2.0 license is present.
- [x] README includes installation, examples, API, CI, and limitations.
- [x] Changelog and contribution guidance are present.
- [x] Public GitHub repository is synchronized with `main`.
- [ ] Publish mooncakes.io release.
- [x] Create `v0.1.0`, `v0.2.0`, `v0.3.0`, `v0.4.0`, and `v0.5.0` Git tags.
- [ ] Publish GitHub Release metadata.
- [ ] Record the final demo video.

## Demo path

1. Scan `examples/dangerous_migration.sql` and show SQL001/SQL002.
2. Generate Markdown and explain the review packet.
3. Generate GitHub annotations and show file/line placement.
4. Run the changed-file mode from a temporary Git checkout.
5. Show a clean CI run and suppression audit.
