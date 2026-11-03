$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$dist = Join-Path $root "web\dist"

Push-Location $root
try {
  moon build --target js --release web
  New-Item -ItemType Directory -Force -Path $dist | Out-Null
  Copy-Item "_build\js\release\build\web\web.js" $dist -Force
  Copy-Item "web\site\*" $dist -Force
  Write-Host "Playground written to $dist"
} finally {
  Pop-Location
}
