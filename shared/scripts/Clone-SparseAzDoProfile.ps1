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
    git sparse-checkout disable
    if ($LASTEXITCODE -ne 0) { throw 'git sparse-checkout disable failed.' }
    git config --unset core.sparseCheckout 2>$null
    git config --unset core.sparseCheckoutCone 2>$null
    git config --worktree --unset core.sparseCheckout 2>$null
    git config --worktree --unset core.sparseCheckoutCone 2>$null
    Remove-Item -LiteralPath (Join-Path (Get-Location) '.git\info\sparse-checkout') -Force -ErrorAction SilentlyContinue

    $remotes = @(git remote)
    foreach ($remote in $remotes) {
        git remote remove $remote
        if ($LASTEXITCODE -ne 0) { throw "Failed to remove remote: $remote" }
    }
}

Write-Host "Cloning $RepoUrl into $Destination (branch: $Branch)..."
git clone --no-checkout --branch $Branch $RepoUrl $Destination

if ($LASTEXITCODE -ne 0 -or !(Test-Path -LiteralPath $Destination)) {
    throw "git clone failed. Verify repository URL, branch, and access permissions."
}

Push-Location $Destination
try {
    # Azure DevOps profile: pipeline definitions + shared CI assets + docs + no-code accelerator tools.
    git sparse-checkout init --cone
    git sparse-checkout set azdo shared docs tools images
    git checkout $Branch
    Complete-IndependentClone

    Write-Host ''
    Write-Host 'Azure DevOps profile materialized as a normal standalone working tree.'
    Write-Host 'Included folders: azdo, shared, docs, tools, images'
    Write-Host 'Sparse checkout disabled.'
    Write-Host 'Removed all source remotes.'
    Write-Host 'Create a new empty repo, then add it with: git remote add origin <new-azdo-repo-url>'
    Write-Host "Working directory: $(Get-Location)"
}
finally {
    Pop-Location
}
