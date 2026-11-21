#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$root/_build/acceptance"
mkdir -p "$out"
cd "$root"

echo "==> format"
moon fmt --check
echo "==> all-target type check"
moon check --target all
echo "==> native tests"
moon test --target native
echo "==> wasm-gc tests"
moon test --target wasm-gc
echo "==> package"
moon package

moon run --target native cmd/main -- --capabilities > "$out/capabilities.md"
moon run --target native cmd/main -- --fail-on warning \
  examples/safe_query.sql \
  examples/safe_migration.sql \
  examples/inline_ignore.sql > /dev/null

if moon run --target native cmd/main -- --fail-on error \
  examples/dangerous_migration.sql > /dev/null 2>&1; then
  echo "dangerous example unexpectedly passed" >&2
  exit 1
fi

moon run --target native cmd/main -- \
  --format plan-json \
  --fail-on never \
  --schema examples/plan/schema.json \
  examples/plan > "$out/plan.json"
python3 -c "import json; d=json.load(open('$out/plan.json')); \
  assert d['analysis_model']['mode'] == 'bounded_semantic'; \
  assert d['summary']['changes'] == 4; \
  assert d['summary']['errors'] == 1; \
  assert d['summary']['warnings'] == 3; \
  assert d['coverage']['ignored'] == 0; \
  assert d['coverage']['complete'] is True"

moon run --target native cmd/main -- \
  --format plan-json \
  --fail-on never \
  examples/coverage > "$out/coverage.json"
python3 -c "import json; d=json.load(open('$out/coverage.json')); \
  assert d['summary']['statements'] == 2; \
  assert d['summary']['ignored_statements'] == 2; \
  assert d['coverage']['complete'] is False"

if moon run --target native cmd/main -- \
  --format plan \
  --fail-on never \
  --require-full-coverage \
  examples/coverage > /dev/null 2>&1; then
  echo "strict coverage gate unexpectedly passed" >&2
  exit 1
fi

moon run --target native cmd/main -- \
  --format plan \
  --fail-on never \
  --require-full-coverage \
  --schema examples/plan/schema.json \
  examples/plan > /dev/null

moon run --target native cmd/main -- \
  --format plan-json \
  --fail-on never \
  --schema examples/plan/schema.json \
  examples/dialects/mysql > "$out/mysql-plan.json"
python3 -c "import json; d=json.load(open('$out/mysql-plan.json')); \
  assert d['summary']['statements'] == 2; \
  assert d['summary']['analyzed_statements'] == 2; \
  assert d['summary']['ignored_statements'] == 0; \
  ids={f['rule_id'] for f in d['findings']}; \
  assert {'SQL301', 'SQL304'} <= ids"

moon run --target native cmd/main -- \
  --format impact-json \
  --fail-on never \
  --schema examples/plan/schema.json \
  examples/plan \
  --query examples/impact/queries > "$out/impact.json"
python3 -c "import json; d=json.load(open('$out/impact.json')); \
  assert d['summary']['references'] == 2; \
  assert d['summary']['impacted_files'] == 2; \
  assert d['summary']['warnings'] == 2"

moon run --target native cmd/main -- \
  --format review-markdown \
  --fail-on never \
  --schema examples/plan/schema.json \
  examples/plan \
  --query examples/impact/queries > "$out/review.md"
grep -q "Verdict: BLOCK" "$out/review.md"
grep -q "## Downstream query impact" "$out/review.md"
grep -q "## Parser coverage" "$out/review.md"

moon run --target native cmd/main -- \
  --format review-sarif \
  --fail-on never \
  --schema examples/plan/schema.json \
  examples/plan \
  --query examples/impact/queries > "$out/review.sarif"
python3 -c "import json; d=json.load(open('$out/review.sarif')); \
  assert d['version'] == '2.1.0'; \
  assert d['runs'][0]['properties']['verdict'] == 'block'; \
  ids={r['ruleId'] for r in d['runs'][0]['results']}; \
  assert 'SQL301' in ids; \
  assert 'SQL305' in ids"

bash scripts/build-web.sh
if command -v node > /dev/null 2>&1; then
  node scripts/browser-smoke.mjs
else
  echo "==> browser smoke skipped: node not found"
fi

echo
echo "ACCEPTANCE PASSED"
echo "Artifacts: $out"
