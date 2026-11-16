$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$out = Join-Path $root "_build\acceptance"
New-Item -ItemType Directory -Force -Path $out | Out-Null
Push-Location $root

function Invoke-Required([string]$name, [scriptblock]$command) {
  Write-Host "==> $name"
  & $command
  if ($LASTEXITCODE -ne 0) {
    throw "$name failed with exit code $LASTEXITCODE"
  }
}

try {
  Invoke-Required "format" { moon fmt --check }
  Invoke-Required "all-target type check" { moon check --target all }
  Invoke-Required "native tests" { moon test --target native }
  Invoke-Required "wasm-gc tests" { moon test --target wasm-gc }
  Invoke-Required "package" { moon package }

  Invoke-Required "capability report" {
    moon run --target native cmd/main -- --capabilities > (Join-Path $out "capabilities.md")
  }
  Invoke-Required "safe examples" {
    moon run --target native cmd/main -- --fail-on warning `
      examples/safe_query.sql `
      examples/safe_migration.sql `
      examples/inline_ignore.sql | Out-Null
  }

  Write-Host "==> dangerous example must fail"
  & moon run --target native cmd/main -- --fail-on error `
    examples/dangerous_migration.sql *> $null
  if ($LASTEXITCODE -eq 0) {
    throw "dangerous example unexpectedly passed"
  }

  Invoke-Required "migration plan report" {
    moon run --target native cmd/main -- `
      --format plan-json `
      --fail-on never `
      --schema examples/plan/schema.json `
      examples/plan > (Join-Path $out "plan.json")
  }
  $plan = Get-Content -Raw (Join-Path $out "plan.json") | ConvertFrom-Json
  if ($plan.analysis_model.mode -ne "bounded_semantic" -or
      $plan.summary.changes -ne 4 -or
      $plan.summary.errors -ne 1 -or
      $plan.summary.warnings -ne 3) {
    throw "migration plan assertions failed"
  }

  Invoke-Required "downstream impact report" {
    moon run --target native cmd/main -- `
      --format impact-json `
      --fail-on never `
      --schema examples/plan/schema.json `
      examples/plan `
      --query examples/impact/queries > (Join-Path $out "impact.json")
  }
  $impact = Get-Content -Raw (Join-Path $out "impact.json") | ConvertFrom-Json
  if ($impact.summary.references -ne 2 -or
      $impact.summary.impacted_files -ne 2 -or
      $impact.summary.warnings -ne 2) {
    throw "impact analysis assertions failed"
  }

  Invoke-Required "unified review report" {
    moon run --target native cmd/main -- `
      --format review-markdown `
      --fail-on never `
      --schema examples/plan/schema.json `
      examples/plan `
      --query examples/impact/queries > (Join-Path $out "review.md")
  }
  $review = Get-Content -Raw (Join-Path $out "review.md")
  if (-not $review.Contains("Verdict: BLOCK") -or
      -not $review.Contains("## Downstream query impact")) {
    throw "review packet assertions failed"
  }

  Invoke-Required "browser build" { & (Join-Path $PSScriptRoot "build-web.ps1") }
  $node = Get-Command node -ErrorAction SilentlyContinue
  if ($node) {
    Invoke-Required "browser smoke test" { node scripts/browser-smoke.mjs }
  } else {
    Write-Host "==> browser smoke skipped: node not found"
  }

  Write-Host ""
  Write-Host "ACCEPTANCE PASSED"
  Write-Host "Artifacts: $out"
} finally {
  Pop-Location
}
