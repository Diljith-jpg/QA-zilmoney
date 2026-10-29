<#
.SYNOPSIS
  Render a QA document (test plan / test report) from HTML to PDF (Chrome) and DOCX (Word).

.DESCRIPTION
  The HTML is the single source. It must carry two meta tags:
    <meta name="qa-header" content="QA Scheduled · OCW-24254">
    <meta name="qa-footer" content="Internal — Confidential · Zil Money — OCW-24254 QA Test Plan">
  qa-doc.css is inlined automatically; the HTML does not need to link it.

  Output: <OutDir>\<html basename>.pdf   (plus .docx with -Docx — experimental)
  OutDir defaults to the parent of the HTML's folder (working\ -> task folder).

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File C:\OCW-QA\qa-tools\render.ps1 -Html "C:\OCW-QA\qa-tasks\OCW-24254 - Payee\working\OCW-24254_QA_Test_Plan.html"
#>
param(
  [Parameter(Mandatory = $true)][string]$Html,
  [string]$OutDir,
  [switch]$Docx,        # opt-in: also write DOCX via Word (experimental — can hang on a Word dialog)
  [switch]$DocxOnly     # skip the PDF, only write DOCX
)
$ErrorActionPreference = 'Stop'

$Html = (Resolve-Path $Html).Path
if (-not $OutDir) { $OutDir = Split-Path (Split-Path $Html -Parent) -Parent }
New-Item -ItemType Directory -Force $OutDir | Out-Null
$base = [IO.Path]::GetFileNameWithoutExtension($Html)
$pdf  = Join-Path $OutDir "$base.pdf"
$docxPath = Join-Path $OutDir "$base.docx"

$css = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'qa-doc.css'), [Text.Encoding]::UTF8)
$src = [IO.File]::ReadAllText($Html, [Text.Encoding]::UTF8)

function Get-Meta([string]$name) {
  $m = [regex]::Match($src, "<meta\s+name=`"$name`"\s+content=`"([^`"]*)`"", 'IgnoreCase')
  if ($m.Success) { return [Net.WebUtility]::HtmlDecode($m.Groups[1].Value) } else { return '' }
}
$header = Get-Meta 'qa-header'
$footer = Get-Meta 'qa-footer'

# Zebra rows: tag every second <tr> inside each <tbody> with class="alt" (Word ignores :nth-child).
$src = [regex]::Replace($src, '(?s)<tbody>(.*?)</tbody>', {
  param($m)
  $script:i = 0
  $body = [regex]::Replace($m.Groups[1].Value, '<tr(?=[\s>])', {
    param($t)
    $script:i++
    if ($script:i % 2 -eq 0) { '<tr class="alt"' } else { '<tr' }
  })
  "<tbody>$body</tbody>"
})

function Escape-Css([string]$s) { $s.Replace('\', '\\').Replace('"', '\"') }
$pageCss = "@page { @top-right { content: `"$(Escape-Css $header)`"; } @bottom-center { content: `"$(Escape-Css $footer)`"; } }"

$tmpDir = Join-Path $env:TEMP "ocw-qa-render"
New-Item -ItemType Directory -Force $tmpDir | Out-Null
$utf8 = New-Object Text.UTF8Encoding($true)

# ---------- PDF via headless Chrome ----------
if (-not $DocxOnly) {
  $chromeHtml = Join-Path $tmpDir "$base.chrome.html"
  $withCss = $src -replace '</head>', "<style>`n$css`n$pageCss`n</style>`n</head>"
  [IO.File]::WriteAllText($chromeHtml, $withCss, $utf8)

  $chrome = @(
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
  ) | Where-Object { Test-Path $_ } | Select-Object -First 1
  if (-not $chrome) { throw "Chrome/Edge not found" }

  if (Test-Path $pdf) { Remove-Item $pdf -Force }
  $profileDir = Join-Path $tmpDir "chrome-profile"
  $uri = ([Uri]$chromeHtml).AbsoluteUri
  $args = @('--headless=new', '--disable-gpu', '--no-pdf-header-footer', "--user-data-dir=`"$profileDir`"",
            "--print-to-pdf=`"$pdf`"", $uri)
  Start-Process -FilePath $chrome -ArgumentList $args -Wait -WindowStyle Hidden
  if (-not (Test-Path $pdf)) { throw "PDF was not produced" }
  Write-Output "PDF : $pdf"
}

# ---------- DOCX via Word ----------
if ($Docx -or $DocxOnly) {
  $wordHtml = Join-Path $tmpDir "$base.word.html"
  # Word gets the CSS without the @page margin boxes (it cannot parse nested @-rules).
  $wordCss = [regex]::Replace($css, '(?s)@page\s*\{.*?\n\}', '')
  $withCss = $src -replace '</head>', "<style>`n$wordCss`n</style>`n</head>"
  [IO.File]::WriteAllText($wordHtml, $withCss, $utf8)

  $word = New-Object -ComObject Word.Application
  $word.Visible = $false
  $word.DisplayAlerts = 0
  try {
    $doc = $word.Documents.Open($wordHtml, $false, $true)
    $word.ActiveWindow.View.Type = 3          # print layout
    $ps = $doc.PageSetup
    $ps.PageWidth = 612; $ps.PageHeight = 792  # US Letter
    $ps.LeftMargin = 72; $ps.RightMargin = 72; $ps.TopMargin = 68; $ps.BottomMargin = 65
    $ps.HeaderDistance = 30; $ps.FooterDistance = 30

    $green = 0x5B7D2E   # Word colours are BGR: #2E7D5B
    $muted = 0x72645A   # #5A6472
    $rule  = 0xDCD2C9   # #C9D2DC

    $h = $doc.Sections(1).Headers(1).Range
    $h.Text = $header
    $h.Font.Name = 'Calibri'; $h.Font.Size = 8.5; $h.Font.Bold = $true; $h.Font.Color = $green
    $h.Font.Spacing = 1.6
    $h.ParagraphFormat.Alignment = 2
    $b = $h.ParagraphFormat.Borders(-3); $b.LineStyle = 1; $b.LineWidth = 6; $b.Color = $rule

    $f = $doc.Sections(1).Footers(1).Range
    $f.Text = $footer
    $f.Font.Name = 'Calibri'; $f.Font.Size = 8; $f.Font.Bold = $false; $f.Font.Color = $muted
    $f.ParagraphFormat.Alignment = 1
    $b = $f.ParagraphFormat.Borders(-1); $b.LineStyle = 1; $b.LineWidth = 6; $b.Color = $rule

    $doc.SaveAs2($docxPath, 16)
    $doc.Close($false)
  } finally {
    $word.Quit()
    [Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
  }
  Write-Output "DOCX: $docxPath"
}
