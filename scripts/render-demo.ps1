param(
  [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
if (-not $OutputPath) {
  $OutputPath = Join-Path $root "docs\media\sqlsentinel-demo.mp4"
}
$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)
$outDir = Join-Path $root "_build\demo"
$frameDir = Join-Path $outDir "frames"

$ffmpegCandidates = @(
  (Get-Command ffmpeg -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty Source),
  "C:\Program Files (x86)\Lenovo\LegionZone\2.0.27.7062\SEGamingAI\services\editor\ffmpeg.exe"
)
$ffmpeg = $ffmpegCandidates |
  Where-Object { $_ -and (Test-Path -LiteralPath $_) } |
  Select-Object -First 1
if (-not $ffmpeg) {
  throw "ffmpeg was not found."
}

$slides = @(
  @{
    section = "FINAL DEMO"
    title = "SQLSentinel"
    body = @(
      "Deterministic database-change intelligence written in MoonBit.",
      "",
      "v0.16.0   |   15 + 1 risk rules   |   zero runtime model calls"
    )
  },
  @{
    section = "PROBLEM"
    title = "Review database changes before deployment"
    body = @(
      "> Statement risks: unsafe DML and destructive DDL",
      "> Migration semantics: ordered schema evolution",
      "> Downstream impact: queries that depend on changed objects",
      "",
      "No database connection. No SQL execution."
    )
  },
  @{
    section = "ARCHITECTURE"
    title = "A bounded semantic pipeline"
    body = @(
      "context lexer -> top-level splitter -> structural parser",
      "schema reducer -> coverage tracer -> query impact -> policy",
      "",
      "Each statement has a source span, grammar branch,",
      "coverage status, and an explicit ignore reason."
    )
  },
  @{
    section = "COVERAGE"
    title = "Unsupported syntax stays visible"
    body = @(
      "Coverage: 0/2 statements analyzed, 2 ignored",
      "COMMENT ON TABLE ... -> root outside grammar",
      "DROP CONSTRAINT ... -> unsupported migration branch",
      "",
      "--require-full-coverage -> CI fails explicitly"
    )
  },
  @{
    section = "MIGRATION PLAN"
    title = "Ordered multi-file schema state"
    body = @(
      "5/5 statements traced   |   4 schema changes",
      "SQL301-SQL304 semantic migration findings",
      "",
      "Tables, columns, indexes, foreign keys, types,",
      "and renames evolve in execution order."
    )
  },
  @{
    section = "DIALECT COVERAGE"
    title = "PostgreSQL and MySQL grammar"
    body = @(
      "ALTER TABLE users MODIFY COLUMN email VARCHAR(320);",
      "ALTER TABLE users CHANGE COLUMN email primary_email VARCHAR(320);",
      "",
      "2/2 analyzed   |   SQL301 type change   |   SQL304 rename risk"
    )
  },
  @{
    section = "IMPACT AND REVIEW"
    title = "One review, all evidence"
    body = @(
      "2 affected query files   |   verdict: BLOCK",
      "SARIF 2.1.0 for GitHub Code Scanning",
      "",
      "SQL301-SQL305 findings share one action artifact,",
      "remediation guidance, and stable fingerprints."
    )
  },
  @{
    section = "ACCEPTANCE"
    title = "Reproducible delivery"
    body = @(
      "83 Native tests   |   79 Wasm-GC tests",
      "full-target type check   |   package validation",
      "browser smoke test   |   unified acceptance PASS",
      "",
      ".\scripts\acceptance.ps1",
      "moon add Ljh684/sqlsentinel@0.16.0"
    )
  },
  @{
    section = "LINKS"
    title = "SQLSentinel v0.16.0"
    body = @(
      "github.com/Ljh684/sqlsentinel",
      "mooncakes.io -> Ljh684/sqlsentinel@0.16.0",
      "docs -> ACCEPTANCE | ANALYSIS_MODEL | DEMO",
      "",
      "> Deterministic evidence. Explicit boundaries. Reproducible review."
    )
  }
)

New-Item -ItemType Directory -Force -Path $frameDir | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutputPath) |
  Out-Null

$secondsPerSlide = 7
Add-Type -AssemblyName System.Drawing
for ($i = 0; $i -lt $slides.Count; $i++) {
  $slide = $slides[$i]
  $bitmap = New-Object System.Drawing.Bitmap 1280, 720
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

  $background = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point 0, 0),
    (New-Object System.Drawing.Point 1280, 720),
    [System.Drawing.ColorTranslator]::FromHtml("#06101d"),
    [System.Drawing.ColorTranslator]::FromHtml("#0c1d31")
  )
  $graphics.FillRectangle($background, 0, 0, 1280, 720)
  $glow = New-Object System.Drawing.SolidBrush(
    [System.Drawing.Color]::FromArgb(42, 36, 95, 140)
  )
  $graphics.FillEllipse($glow, 820, -160, 620, 500)
  $accent = New-Object System.Drawing.SolidBrush(
    [System.Drawing.ColorTranslator]::FromHtml("#56e6bd")
  )
  $graphics.FillRectangle($accent, 0, 0, 10, 720)

  $headerFont = New-Object System.Drawing.Font "Segoe UI", 18, ([System.Drawing.FontStyle]::Bold)
  $sectionFont = New-Object System.Drawing.Font "Segoe UI", 15
  $titleFont = New-Object System.Drawing.Font "Segoe UI", 38, ([System.Drawing.FontStyle]::Bold)
  $bodyFont = New-Object System.Drawing.Font "Segoe UI", 20
  $codeFont = New-Object System.Drawing.Font "Consolas", 18
  $footerFont = New-Object System.Drawing.Font "Segoe UI", 13
  $white = New-Object System.Drawing.SolidBrush(
    [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
  )
  $muted = New-Object System.Drawing.SolidBrush(
    [System.Drawing.ColorTranslator]::FromHtml("#89a8c5")
  )
  $bodyBrush = New-Object System.Drawing.SolidBrush(
    [System.Drawing.ColorTranslator]::FromHtml("#c2d5e8")
  )
  $footerBrush = New-Object System.Drawing.SolidBrush(
    [System.Drawing.ColorTranslator]::FromHtml("#7895b1")
  )

  $graphics.DrawString("SQLSENTINEL", $headerFont, $accent, 76, 48)
  $sectionSize = $graphics.MeasureString($slide.section, $sectionFont)
  $graphics.DrawString(
    $slide.section,
    $sectionFont,
    $muted,
    1200 - $sectionSize.Width,
    54
  )
  $graphics.DrawString($slide.title, $titleFont, $white, 76, 150)

  for ($lineIndex = 0; $lineIndex -lt $slide.body.Count; $lineIndex++) {
    $line = $slide.body[$lineIndex]
    $brush = if ($line.StartsWith(">")) { $accent } else { $bodyBrush }
    $font = if (
      $line.Contains("ALTER TABLE") -or
      $line.Contains("--require") -or
      $line.StartsWith(".\")
    ) { $codeFont } else { $bodyFont }
    $graphics.DrawString($line, $font, $brush, 92, 290 + ($lineIndex * 45))
  }

  $footerPen = New-Object System.Drawing.Pen(
    [System.Drawing.ColorTranslator]::FromHtml("#29445f"),
    1
  )
  $graphics.DrawLine($footerPen, 76, 630, 1204, 630)
  $graphics.DrawString(
    "MoonBit Hackathon 2026 | Ljh684",
    $footerFont,
    $footerBrush,
    76,
    655
  )
  $slideLabel = "SLIDE $($i + 1) / $($slides.Count)"
  $labelSize = $graphics.MeasureString($slideLabel, $footerFont)
  $graphics.DrawString(
    $slideLabel,
    $footerFont,
    $accent,
    1204 - $labelSize.Width,
    655
  )

  $pngPath = Join-Path $frameDir ("slide-{0:d2}.png" -f ($i + 1))
  $bitmap.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)

  $graphics.Dispose()
  $bitmap.Dispose()
  $background.Dispose()
  $glow.Dispose()
  $accent.Dispose()
  $headerFont.Dispose()
  $sectionFont.Dispose()
  $titleFont.Dispose()
  $bodyFont.Dispose()
  $codeFont.Dispose()
  $footerFont.Dispose()
  $white.Dispose()
  $muted.Dispose()
  $bodyBrush.Dispose()
  $footerBrush.Dispose()
  $footerPen.Dispose()
}

$concat = Join-Path $outDir "slides.txt"
$lines = @()
for ($i = 1; $i -le $slides.Count; $i++) {
  $frame = (Join-Path $frameDir ("slide-{0:d2}.png" -f $i)).Replace("\", "/")
  $lines += "file '$frame'"
  $lines += "duration $secondsPerSlide"
}
$last = (Join-Path $frameDir ("slide-{0:d2}.png" -f $slides.Count)).Replace("\", "/")
$lines += "file '$last'"
$lines | Set-Content -LiteralPath $concat -Encoding ascii

& $ffmpeg `
  -y `
  -hide_banner `
  -loglevel error `
  -f concat `
  -safe 0 `
  -i $concat `
  -vf "scale=1280:720,format=yuv420p" `
  -r 30 `
  -c:v h264_mf `
  -b:v 1200k `
  -maxrate 1500k `
  -bufsize 3M `
  -movflags +faststart `
  $OutputPath
if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $OutputPath)) {
  throw "Failed to encode demo video"
}

$video = Get-Item -LiteralPath $OutputPath
Write-Output "Demo video written to $($video.FullName) ($($video.Length) bytes)"
