# Five-minute acceptance demo

Run from the repository root.

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
CLI positive/negative flows, plan/impact/review reports, and browser smoke tests
all pass.
