param(
    [string]$VideoPath = 'Social Media/video/enterprise-bi-devops-demo.mp4',

    [string]$AudioPath = 'Social Media/video/narration.wav',

    [string]$OutputPath = 'Social Media/video/enterprise-bi-devops-demo-narrated.mp4',

    [switch]$LoopVideoToAudio
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-FfmpegPath {
    $ffmpeg = Get-Command ffmpeg -ErrorAction SilentlyContinue
    if ($ffmpeg) {
        return $ffmpeg.Source
    }

    $pythonProbe = @'
from shutil import which
ffmpeg = which("ffmpeg")
if ffmpeg:
    print(ffmpeg)
    raise SystemExit(0)
try:
    import static_ffmpeg
    static_ffmpeg.add_paths()
    ffmpeg = which("ffmpeg")
    if ffmpeg:
        print(ffmpeg)
        raise SystemExit(0)
except Exception:
    pass
try:
    import imageio_ffmpeg
    print(imageio_ffmpeg.get_ffmpeg_exe())
    raise SystemExit(0)
except Exception:
    pass
raise SystemExit(1)
'@

    $probePath = Join-Path $env:TEMP 'find-ffmpeg.py'
    Set-Content -Path $probePath -Value $pythonProbe -Encoding UTF8
    $result = & python $probePath 2>$null
    if ($LASTEXITCODE -eq 0 -and ![string]::IsNullOrWhiteSpace($result)) {
        return ($result | Select-Object -First 1)
    }

    throw 'No ffmpeg executable found. Install ffmpeg or run: python -m pip install static-ffmpeg'
}

$repoRoot = (Resolve-Path '.').Path
$resolvedVideo = Join-Path $repoRoot $VideoPath
$resolvedAudio = Join-Path $repoRoot $AudioPath
$resolvedOutput = Join-Path $repoRoot $OutputPath

if (!(Test-Path -LiteralPath $resolvedVideo)) {
    throw "Video file not found: $resolvedVideo"
}

if (!(Test-Path -LiteralPath $resolvedAudio)) {
    throw "Audio file not found: $resolvedAudio"
}

$outputDirectory = Split-Path -Path $resolvedOutput -Parent
if ($outputDirectory) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

$ffmpegPath = Get-FfmpegPath

$arguments = @('-y')
if ($LoopVideoToAudio) {
    $arguments += @('-stream_loop', '-1')
}

$arguments += @(
    '-i', $resolvedVideo,
    '-i', $resolvedAudio,
    '-map', '0:v:0',
    '-map', '1:a:0',
    '-c:v', 'copy',
    '-c:a', 'aac',
    '-b:a', '192k',
    '-shortest',
    $resolvedOutput
)

Write-Host "Combining video and narration..."
Write-Host "Video:  $resolvedVideo"
Write-Host "Audio:  $resolvedAudio"
Write-Host "Output: $resolvedOutput"

& $ffmpegPath @arguments
if ($LASTEXITCODE -ne 0) {
    throw "ffmpeg failed with exit code $LASTEXITCODE"
}

Write-Host "Narrated video created: $resolvedOutput"

