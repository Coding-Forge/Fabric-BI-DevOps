param(
    [Parameter(Mandatory = $true)]
    [string]$RepoUrl,

    [string]$Destination,

    [string]$Branch = 'main'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git is not installed or not available on PATH.'
}

if ([string]::IsNullOrWhiteSpace($Destination)) {
    $repoName = [System.IO.Path]::GetFileNameWithoutExtension($RepoUrl.TrimEnd('/'))
    if ([string]::IsNullOrWhiteSpace($repoName)) {
        throw 'Could not infer destination folder name from RepoUrl. Pass -Destination explicitly.'
    }

    $Destination = $repoName
}

$destinationParent = Split-Path -Path $Destination -Parent
if (-not [string]::IsNullOrWhiteSpace($destinationParent) -and !(Test-Path -LiteralPath $destinationParent)) {
    New-Item -ItemType Directory -Path $destinationParent -Force | Out-Null
}

if (Test-Path -LiteralPath $Destination) {
    throw "Destination path already exists: $Destination"
}

Write-Host "Cloning $RepoUrl into $Destination (branch: $Branch)..."
git clone --filter=blob:none --no-checkout --branch $Branch $RepoUrl $Destination

if ($LASTEXITCODE -ne 0 -or !(Test-Path -LiteralPath $Destination)) {
    throw "git clone failed. Verify repository URL, branch, and access permissions."
}

Push-Location $Destination
try {
    # GitHub profile: GitHub workflows + shared assets + docs.
    git sparse-checkout init --cone
    git sparse-checkout set .github shared docs
    git checkout $Branch

    Write-Host ''
    Write-Host 'Sparse checkout configured for GitHub profile.'
    Write-Host 'Included folders: .github, shared, docs'
    Write-Host "Working directory: $(Get-Location)"
}
finally {
    Pop-Location
}
