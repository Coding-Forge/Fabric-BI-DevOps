param(
    [string]$SceneUrl = 'http://127.0.0.1:8765/Social%20Media/video/scenes/index.html',
    [string]$OutputPath = 'Social Media/video/enterprise-bi-devops-demo.mp4',
    [int]$SecondsPerScene = 7
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path '.').Path
$videoRoot = Join-Path $repoRoot 'Social Media/video'
$framesRoot = Join-Path $videoRoot 'scenes/frames'
New-Item -ItemType Directory -Path $framesRoot -Force | Out-Null

$captureScript = @"
const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1920, height: 1080 }, deviceScaleFactor: 1 });
  await page.goto('$SceneUrl', { waitUntil: 'networkidle' });
  const scenes = await page.locator('.scene').count();
  for (let i = 0; i < scenes; i++) {
    const scene = page.locator('.scene').nth(i);
    await scene.screenshot({ path: '$($framesRoot.Replace('\', '/'))/scene-' + String(i + 1).padStart(2, '0') + '.png' });
  }
  await browser.close();
})();
"@

$capturePath = Join-Path $env:TEMP 'capture-enterprise-bi-devops-scenes.js'
Set-Content -Path $capturePath -Value $captureScript -Encoding UTF8

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
    Write-Host 'Capturing scene frames...'
    node $capturePath
    if ($LASTEXITCODE -ne 0) {
        throw 'Scene capture failed. Ensure Playwright is available and the local server is running.'
    }
} else {
    Write-Warning 'Node.js was not found. Skipping browser frame capture and using any existing PNG frames.'
}

$frames = Get-ChildItem -Path $framesRoot -Filter 'scene-*.png' | Sort-Object Name
if (!$frames) {
    throw "No scene frames were found in $framesRoot. Install Node.js with Playwright or capture frames with browser automation first."
}

$pythonScript = @"
from PIL import Image
from pathlib import Path
import subprocess
import sys
import shutil

frames_dir = Path(r'''$framesRoot''')
output = Path(r'''$(Join-Path $repoRoot $OutputPath)''')
seconds = int($SecondsPerScene)
frames = sorted(frames_dir.glob('scene-*.png'))
if not frames:
    raise SystemExit('No frames found')

expanded = []
expanded_dir = frames_dir / 'expanded'
if expanded_dir.exists():
    shutil.rmtree(expanded_dir)
expanded_dir.mkdir(exist_ok=True)
index = 1
fps = 1
for frame in frames:
    img = Image.open(frame).convert('RGB')
    for _ in range(seconds):
        out = expanded_dir / f'frame_{index:04d}.png'
        img.save(out)
        expanded.append(out)
        index += 1

ffmpeg = None
try:
    import static_ffmpeg
    static_ffmpeg.add_paths()
except Exception:
    pass

try:
    import imageio_ffmpeg
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
except Exception:
    pass

if ffmpeg is None:
    from shutil import which
    ffmpeg = which('ffmpeg')

if ffmpeg is None:
    raise SystemExit('No ffmpeg executable found. Install ffmpeg or run: python -m pip install static-ffmpeg')
cmd = [
    ffmpeg,
    '-y',
    '-framerate', str(fps),
    '-i', str(expanded_dir / 'frame_%04d.png'),
    '-c:v', 'libx264',
    '-pix_fmt', 'yuv420p',
    '-r', '30',
    str(output)
]
subprocess.check_call(cmd)
shutil.rmtree(expanded_dir)
print(output)
"@

$pythonPath = Join-Path $env:TEMP 'build-enterprise-bi-devops-video.py'
Set-Content -Path $pythonPath -Value $pythonScript -Encoding UTF8

try {
    python $pythonPath
} catch {
    Write-Warning $_.Exception.Message
    Write-Warning 'MP4 generation requires imageio-ffmpeg. Run: python -m pip install imageio-ffmpeg'
    Write-Warning "Frames were generated at: $framesRoot"
    return
}

Write-Host "Video output: $OutputPath"

