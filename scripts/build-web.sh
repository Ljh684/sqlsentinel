#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dist="$root/web/dist"

cd "$root"
moon build --target js --release web
mkdir -p "$dist"
cp _build/js/release/build/web/web.js "$dist/"
cp web/site/* "$dist/"
echo "Playground written to $dist"
