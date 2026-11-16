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
- `review-markdown` for pull requests, documentation, and AI review.

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

Review formats are standalone project reviews and cannot be combined with
baseline application. Use normal report formats when baseline-managed historical
findings are required.
