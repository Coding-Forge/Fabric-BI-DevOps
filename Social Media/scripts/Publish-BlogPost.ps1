param(
    [string]$SourcePath = 'Social Media/Blog-Post.md',

    [string]$OutputRoot = 'docs/blog',

    [switch]$SkipPdf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function ConvertTo-Slug {
    param([string]$Value)

    $slug = $Value.ToLowerInvariant()
    $slug = [regex]::Replace($slug, '[^a-z0-9]+', '-')
    $slug = $slug.Trim('-')
    if ([string]::IsNullOrWhiteSpace($slug)) {
        return 'blog-post'
    }

    return $slug
}

function Get-BrowserPath {
    $commands = @('msedge', 'chrome', 'chromium', 'chromium-browser', 'google-chrome')
    foreach ($command in $commands) {
        $found = Get-Command $command -ErrorAction SilentlyContinue
        if ($found) {
            return $found.Source
        }
    }

    $knownPaths = @(
        'C:\Program Files\Microsoft\Edge\Application\msedge.exe',
        'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
        'C:\Program Files\Google\Chrome\Application\chrome.exe',
        'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
    )

    foreach ($path in $knownPaths) {
        if (Test-Path -LiteralPath $path) {
            return $path
        }
    }

    return $null
}

function Copy-BlogImages {
    param(
        [string]$Markdown,
        [string]$SourceDirectory,
        [string]$AssetsDirectory
    )

    New-Item -ItemType Directory -Path $AssetsDirectory -Force | Out-Null
    $imageMatches = [regex]::Matches($Markdown, '!\[[^\]]*\]\(([^)]+)\)')
    $rewritten = $Markdown
    $usedNames = @{}

    foreach ($match in $imageMatches) {
        $imageRef = $match.Groups[1].Value.Trim()
        if ($imageRef -match '^(https?:|data:|#)') {
            continue
        }

        $sourceImage = Join-Path $SourceDirectory $imageRef
        $sourceImage = [System.IO.Path]::GetFullPath($sourceImage)
        if (!(Test-Path -LiteralPath $sourceImage)) {
            throw "Blog image not found: $imageRef"
        }

        $fileName = [System.IO.Path]::GetFileName($sourceImage)
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
        $extension = [System.IO.Path]::GetExtension($fileName)
        $targetName = $fileName
        $counter = 1

        while ($usedNames.ContainsKey($targetName)) {
            $targetName = "$baseName-$counter$extension"
            $counter += 1
        }

        $usedNames[$targetName] = $true
        Copy-Item -LiteralPath $sourceImage -Destination (Join-Path $AssetsDirectory $targetName) -Force
        $rewritten = $rewritten.Replace("($imageRef)", "(assets/$targetName)")
    }

    return $rewritten
}

function Split-FrontMatter {
    param([string]$Markdown)

    $metadata = @{}
    $body = $Markdown

    if ($Markdown -match '(?s)^---\s*\r?\n(.*?)\r?\n---\s*\r?\n(.*)$') {
        $frontMatter = $Matches[1]
        $body = $Matches[2]
        foreach ($line in ($frontMatter -split '\r?\n')) {
            if ($line -match '^\s*([^:#]+):\s*(.+?)\s*$') {
                $metadata[$Matches[1].Trim()] = $Matches[2].Trim().Trim('"')
            }
        }
    }

    return [pscustomobject]@{
        Metadata = $metadata
        Body = $body
    }
}

$resolvedSource = Resolve-Path -LiteralPath $SourcePath
$sourceDirectory = Split-Path -Path $resolvedSource -Parent
$repoRoot = (Resolve-Path '.').Path
$rawMarkdown = Get-Content -LiteralPath $resolvedSource -Raw
$parsed = Split-FrontMatter -Markdown $rawMarkdown

$title = $parsed.Metadata['title']
if ([string]::IsNullOrWhiteSpace($title) -and $parsed.Body -match '(?m)^#\s+(.+)$') {
    $title = $Matches[1].Trim()
}
if ([string]::IsNullOrWhiteSpace($title)) {
    $title = 'Blog Post'
}

$publishedDate = $parsed.Metadata['publishedDate']
if ([string]::IsNullOrWhiteSpace($publishedDate)) {
    $publishedDate = Get-Date -Format 'yyyy-MM-dd'
}

$slug = $parsed.Metadata['slug']
if ([string]::IsNullOrWhiteSpace($slug)) {
    $slug = ConvertTo-Slug -Value $title
}

$outputDirectory = Join-Path $repoRoot (Join-Path $OutputRoot "$publishedDate-$slug")
$assetsDirectory = Join-Path $outputDirectory 'assets'
New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null

$markdownForPublishing = Copy-BlogImages -Markdown $parsed.Body -SourceDirectory $sourceDirectory -AssetsDirectory $assetsDirectory
$articleHtml = (ConvertFrom-Markdown -InputObject $markdownForPublishing).Html
$encodedTitle = [System.Net.WebUtility]::HtmlEncode($title)

$html = @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$encodedTitle</title>
  <style>
    :root {
      color-scheme: light;
      --bg: #f7f4ef;
      --surface: #ffffff;
      --border: #dedede;
      --text: #242424;
      --muted: #5c5c5c;
      --accent: #b11f4b;
      --accent-soft: rgba(177, 31, 75, 0.08);
    }
    body {
      margin: 0;
      background: var(--bg);
      color: var(--text);
      font-family: "Segoe UI", Aptos, Calibri, Arial, sans-serif;
      line-height: 1.62;
    }
    main {
      max-width: 980px;
      margin: 0 auto;
      padding: 48px 24px 64px;
    }
    article {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: 24px;
      padding: 42px;
      box-shadow: 0 18px 48px rgba(0, 0, 0, 0.08);
    }
    h1 {
      font-size: clamp(32px, 5vw, 52px);
      line-height: 1.08;
      margin: 0 0 18px;
    }
    h2 {
      margin-top: 38px;
      font-size: 28px;
    }
    p, li {
      font-size: 18px;
    }
    .meta {
      color: var(--muted);
      font-weight: 700;
      letter-spacing: 0.02em;
      text-transform: uppercase;
      margin-bottom: 28px;
    }
    img {
      display: block;
      max-width: 100%;
      height: auto;
      margin: 28px auto;
      border: 1px solid var(--border);
      border-radius: 18px;
      background: #fff;
    }
    ul {
      padding-left: 1.4rem;
    }
    a {
      color: var(--accent);
    }
    blockquote {
      margin: 28px 0;
      padding: 18px 22px;
      border-left: 5px solid var(--accent);
      background: var(--accent-soft);
      border-radius: 12px;
    }
    @media print {
      body { background: #fff; }
      main { max-width: none; padding: 0; }
      article { border: 0; box-shadow: none; border-radius: 0; padding: 0; }
      img { break-inside: avoid; }
    }
  </style>
</head>
<body>
  <main>
    <article>
      <div class="meta">Published $publishedDate</div>
      $articleHtml
    </article>
  </main>
</body>
</html>
"@

$htmlPath = Join-Path $outputDirectory 'index.html'
$pdfPath = Join-Path $outputDirectory "$slug.pdf"
Set-Content -LiteralPath $htmlPath -Value $html -Encoding UTF8

if (!$SkipPdf) {
    $browserPath = Get-BrowserPath
    if (!$browserPath) {
        throw 'Could not find Microsoft Edge, Google Chrome, or Chromium to generate PDF. Install one of these browsers or rerun with -SkipPdf.'
    }

    $htmlUri = ([System.Uri]$htmlPath).AbsoluteUri
    $pdfArgument = "--print-to-pdf=$pdfPath"
    & $browserPath --headless --disable-gpu --no-sandbox $pdfArgument $htmlUri | Out-Null

    if ($LASTEXITCODE -ne 0 -or !(Test-Path -LiteralPath $pdfPath)) {
        throw "PDF generation failed: $pdfPath"
    }
}

Write-Host "Published blog HTML: $htmlPath"
if (!$SkipPdf) {
    Write-Host "Published blog PDF:  $pdfPath"
}

