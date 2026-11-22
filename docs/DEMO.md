# Five-minute acceptance demo

Run from the repository root.

A generated 70-second captioned walkthrough is available at
[sqlsentinel-demo.mp4](media/sqlsentinel-demo.mp4). It can be regenerated with:

```powershell
.\scripts\render-demo.ps1
```

The interactive [browser slide deck](demo/demo.html) contains all nine demo
slides. Use the previous/next buttons, click a progress dot, or use the
left/right arrow and Home/End keys. The `Auto` button advances every 6.5 seconds.

## 1. Confirm build identity and boundaries

```bash
moon run --target native cmd/main -- --version
moon run --target native cmd/main -- --capabilities
```

Show that the project explicitly states its bounded semantic model and unsupported
features.

## 2. Show a blocking statement review

```bash
moon run --target native cmd/main -- \
  --fail-on error \
  examples/dangerous_migration.sql
```

Expected: non-zero exit with SQL001/SQL002 evidence and remediation.

## 3. Show migration plan analysis

```bash
moon run --target native cmd/main -- \
  --format plan-json \
  --schema examples/plan/schema.json \
  examples/plan
```

Expected: four schema changes and SQL301–SQL304 findings.

Show the `coverage` object: all five statements have a trace, `complete` is true,
and each trace names the matched grammar branch and source span.

Then show the strict boundary with `examples/coverage/`:

```bash
moon run --target native cmd/main -- \
  --format plan \
  --require-full-coverage \
  examples/coverage
```

Expected: exit code 1, with both ignored statements and their reasons visible.
This demonstrates that unsupported syntax is explicit and cannot be mistaken for
complete analysis.

## 4. Show downstream query impact

```bash
moon run --target native cmd/main -- \
  --format impact-json \
  --schema examples/plan/schema.json \
  examples/plan \
  --query examples/impact/queries
```

Expected: two impacted query files and SQL305 findings.

## 5. Show one review artifact

```bash
moon run --target native cmd/main -- \
  --format review-markdown \
  --schema examples/plan/schema.json \
  examples/plan \
  --query examples/impact/queries
```

Expected: `BLOCK` verdict, combined metrics, migration changes, impacted queries,
and suggested actions.

Export the same review for GitHub code scanning:

```bash
moon run --target native cmd/main -- \
  --format review-sarif \
  --schema examples/plan/schema.json \
  examples/plan \
  --query examples/impact/queries > sqlsentinel-review.sarif
```

Expected: SARIF 2.1.0 with SQL301-SQL305 results and `verdict=block` in run
properties. This file can be passed to `github/codeql-action/upload-sarif`.

## 6. Show browser behavior

```bash
bash scripts/build-web.sh
python3 -m http.server 8080 --directory web/dist
```

Open `http://localhost:8080`, select “Migration Plan 示例”, and show the schema
change panel. All processing remains local.

## 7. Run the acceptance harness

```powershell
.\scripts\acceptance.ps1
```

Expected: formatting, all-target checking, native/wasm-gc tests, package build,
CLI positive/negative flows, parser coverage gates, plan/impact/review reports,
`acceptance-summary.json`, and browser smoke tests all pass.
