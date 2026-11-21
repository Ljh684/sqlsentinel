# Unified review packet

Review formats combine statement findings, migration plan analysis, and optional
downstream query impact into one deterministic artifact.

```bash
moon run --target native cmd/main -- \
  --format review-markdown \
  --schema examples/plan/schema.json \
  examples/plan \
  --query examples/impact/queries
```

Available formats:

- `review` for terminal output;
- `review-json` for automation;
- `review-markdown` for pull requests, documentation, and AI review;
- `review-sarif` for GitHub code scanning and SARIF consumer integrations.

The packet contains:

- a `pass`, `review`, or `block` verdict;
- combined error, warning, info, and suppression totals;
- migration parser coverage totals and per-statement analyzed/ignored traces;
- statement findings by file;
- schema changes and breaking-change counts;
- affected downstream query files, when `--query` or configured `queries` are
  provided;
- remediation actions derived from every finding.

Use `--require-full-coverage` when the pipeline should fail if any migration
statement falls outside the documented bounded grammar.

### GitHub code scanning

Write the unified report to a file and upload it in the same job:

```yaml
permissions:
  contents: read
  security-events: write

steps:
  - uses: actions/checkout@v4
  - uses: Ljh684/sqlsentinel@v0.15.0
    with:
      paths: db/migrations
      queries: |
        services/**/*.sql
        analytics/**/*.sql
      schema: .sqlsentinel/schema.json
      format: review-sarif
      sarif-file: sqlsentinel-review.sarif
      require-full-coverage: "true"
      fail-on: warning
  - uses: github/codeql-action/upload-sarif@v3
    if: always()
    with:
      sarif_file: sqlsentinel-review.sarif
      category: sqlsentinel
```

The SARIF run contains statement, migration, and downstream-impact findings in
one artifact, plus review verdict, coverage counts, schema changes, and analysis
model metadata in run properties. Upload with `if: always()` if the scanner step
is allowed to fail on findings and the report must still reach code scanning.

Review formats are standalone project reviews and cannot be combined with
baseline application. Use normal report formats when baseline-managed historical
findings are required.
