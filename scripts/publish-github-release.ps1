param(
  [string]$Tag = "v0.16.0",
  [string]$AssetPath = "",
  [string]$NotesPath = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
if (-not $AssetPath) {
  $AssetPath = Join-Path $root "_build\publish\Ljh684-sqlsentinel-0.16.0.zip"
}
if (-not $NotesPath) {
  $NotesPath = Join-Path $root "docs\RELEASE_NOTES.md"
}

$token = if ($env:GH_TOKEN) {
  $env:GH_TOKEN
} elseif ($env:GITHUB_TOKEN) {
  $env:GITHUB_TOKEN
} else {
  ""
}
if (-not $token) {
  throw "Set GH_TOKEN or GITHUB_TOKEN before publishing the GitHub Release."
}
if (-not (Test-Path -LiteralPath $AssetPath)) {
  throw "Release asset was not found: $AssetPath"
}
if (-not (Test-Path -LiteralPath $NotesPath)) {
  throw "Release notes were not found: $NotesPath"
}

$headers = @{
  Authorization = "Bearer $token"
  Accept = "application/vnd.github+json"
  "X-GitHub-Api-Version" = "2022-11-28"
  "User-Agent" = "SQLSentinel-Release"
}
$payload = @{
  tag_name = $Tag
  target_commitish = "main"
  name = "SQLSentinel $Tag"
  body = Get-Content -Raw -Encoding UTF8 $NotesPath
  draft = $false
  prerelease = $false
  generate_release_notes = $false
} | ConvertTo-Json -Depth 4

$release = Invoke-RestMethod `
  -Method Post `
  -Uri "https://api.github.com/repos/Ljh684/sqlsentinel/releases" `
  -Headers $headers `
  -ContentType "application/json" `
  -Body $payload

$asset = Get-Item -LiteralPath $AssetPath
$uploadBase = $release.upload_url -replace "\{.*$", ""
$uploadUri = "$uploadBase?name=$([Uri]::EscapeDataString($asset.Name))"
$assetHeaders = $headers.Clone()
$assetHeaders["Content-Type"] = "application/zip"
$uploaded = Invoke-RestMethod `
  -Method Post `
  -Uri $uploadUri `
  -Headers $assetHeaders `
  -InFile $asset.FullName

Write-Output "Published release: $($release.html_url)"
Write-Output "Uploaded asset: $($uploaded.browser_download_url)"
