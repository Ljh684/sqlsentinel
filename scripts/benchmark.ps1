$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$out = Join-Path $root "_build\benchmark"
New-Item -ItemType Directory -Force -Path $out | Out-Null
$input = Join-Path $out "queries.sql"
$report = Join-Path $out "report.json"
$lines = for ($i = 1; $i -le 5000; $i++) {
  "SELECT id, email FROM users WHERE id = $i ORDER BY id LIMIT 1;"
}
[IO.File]::WriteAllLines($input, $lines)
Push-Location $root
try {
  $timer = [Diagnostics.Stopwatch]::StartNew()
  & moon run --target native cmd/main -- `
    --format json --fail-on never $input > $report
  if ($LASTEXITCODE -ne 0) {
    throw "benchmark scan failed with exit code $LASTEXITCODE"
  }
  $timer.Stop()
  $size = (Get-Item $report).Length
  Write-Host ("5000 statements scanned in {0:N0} ms; report {1:N0} bytes" -f `
    $timer.Elapsed.TotalMilliseconds, $size)
} finally {
  Pop-Location
}
