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

function Complete-IndependentClone {
    Remove-Item -LiteralPath (Join-Path (Get-Location) '.git') -Recurse -Force
    git init -b $Branch
    if ($LASTEXITCODE -ne 0) {
        git init
        if ($LASTEXITCODE -ne 0) { throw 'git init failed.' }
        git checkout -b $Branch
        if ($LASTEXITCODE -ne 0) { throw "Failed to create branch: $Branch" }
    }

    git add -A
    if ($LASTEXITCODE -ne 0) { throw 'git add failed.' }

    git commit -m 'Initial sparse profile materialization'
    if ($LASTEXITCODE -ne 0) {
        Write-Warning 'Initial commit failed, likely because Git user.name/user.email is not configured. Files are staged for the first commit.'
    }
}

Write-Host "Cloning $RepoUrl into $Destination (branch: $Branch)..."
git clone --no-checkout --branch $Branch $RepoUrl $Destination

if ($LASTEXITCODE -ne 0 -or !(Test-Path -LiteralPath $Destination)) {
    throw "git clone failed. Verify repository URL, branch, and access permissions."
}

Push-Location $Destination
try {
    # GitHub profile: GitHub Actions workflow + setup guide + shared CI assets + docs + no-code accelerator tools.
    git sparse-checkout init --no-cone
    git sparse-checkout set --no-cone `
        '/.github/GITHUB_ACTIONS_SETUP.md' `
        '/.github/workflows/powerbi-ci.yml' `
        '/shared/**' `
        '/docs/**' `
        '/tools/**' `
        '/images/**' `
        '/README.md' `
        '/.gitignore'
    git checkout $Branch
    Complete-IndependentClone

    Write-Host ''
    Write-Host 'GitHub profile materialized as a normal standalone working tree.'
    Write-Host 'Included paths: .github/workflows/powerbi-ci.yml, .github/GITHUB_ACTIONS_SETUP.md, shared, docs, tools, images, README.md, .gitignore'
    Write-Host 'Converted sparse checkout to a new standalone repository.'
    Write-Host 'Create a new empty repo, then add it with: git remote add origin <new-github-repo-url>'
    Write-Host "Working directory: $(Get-Location)"
}
finally {
    Pop-Location
}
