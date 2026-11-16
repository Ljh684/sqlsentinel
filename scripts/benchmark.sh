#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$root/_build/benchmark"
mkdir -p "$out"
input="$out/queries.sql"
report="$out/report.json"

for i in $(seq 1 5000); do
  printf 'SELECT id, email FROM users WHERE id = %s ORDER BY id LIMIT 1;\n' "$i"
done > "$input"

cd "$root"
start="$(date +%s%3N)"
moon run --target native cmd/main -- \
  --format json --fail-on never "$input" > "$report"
end="$(date +%s%3N)"

echo "5000 statements scanned in $((end - start)) ms; report $(wc -c < "$report") bytes"
