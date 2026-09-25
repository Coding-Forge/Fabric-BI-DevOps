param(
    [Parameter(Mandatory = $true)]
    [string]$RepoUrl,

    [string]$Destination,

    [string]$Branch = 'main',

    [Parameter(Mandatory = $true)]
    [ValidateSet('AzDo', 'GitHub', 'GitLab', 'None', 'All')]
    [string]$Platform,

    [ValidateSet('Standard', 'Minimal')]
    [string]$Profile = 'Standard',

    [switch]$IncludeWorkshop
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

function Get-PlatformPaths {
    param([string]$PlatformName)

    switch ($PlatformName) {
        'AzDo' { return @('azdo/') }
        'GitHub' { return @('.github/GITHUB_ACTIONS_SETUP.md', '.github/workflows/powerbi-ci.yml') }
        'GitLab' { return @('gitlab/') }
        'All' { return @('azdo/', '.github/', 'gitlab/') }
        'None' { return @() }
        default { throw "Unsupported platform: $PlatformName" }
    }
}

function Get-ProfilePaths {
    param(
        [string]$PlatformName,
        [string]$ProfileName,
        [bool]$WithWorkshop
    )

    $platformPaths = @(Get-PlatformPaths -PlatformName $PlatformName)

    if ($ProfileName -eq 'Minimal') {
        return @($platformPaths + @(
            'README.md',
            'shared/',
            'docs/deployment/',
            'docs/architecture/gcc-high-deployment.md'
        ) | Select-Object -Unique)
    }

    $standardPaths = @(
        'README.md',
        'shared/',
        'tools/',
        'images/',
        'docs/index.md',
        'docs/index.html',
        'docs/images/',
        'docs/deployment/',
        'docs/architecture/gcc-high-deployment.md',
        'docs/governance/',
        'docs/enterprise-quality-rules-pattern.md'
    )

    if ($WithWorkshop) {
        $standardPaths += @(
            'Supporting_Docs_For_Workshop.md',
            'docs/workshops/',
            'docs/delivery/',
            'docs/architecture/',
            'docs/faq.md',
            'docs/Rules-Authoring-Guide.md',
            'docs/sparse-clone-guide.md',
            'presentations/',
            'powerpoint/',
            'Social Media/video/'
        )
    }

    return @($platformPaths + $standardPaths | Select-Object -Unique)
}

$paths = @(Get-ProfilePaths -PlatformName $Platform -ProfileName $Profile -WithWorkshop $IncludeWorkshop.IsPresent)
if ($paths.Count -eq 0) {
    throw 'No paths were selected for sparse checkout.'
}

function ConvertTo-SparsePattern {
    param([string]$Path)

    $normalized = $Path.Replace('\', '/').TrimStart('/')
    if ($normalized.EndsWith('/')) {
        return "/$normalized**"
    }

    return "/$normalized"
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

$sparsePatterns = @($paths | ForEach-Object { ConvertTo-SparsePattern -Path $_ })

Write-Host "Cloning $RepoUrl into $Destination (branch: $Branch)..."
git clone --no-checkout --branch $Branch $RepoUrl $Destination

if ($LASTEXITCODE -ne 0 -or !(Test-Path -LiteralPath $Destination)) {
    throw 'git clone failed. Verify repository URL, branch, and access permissions.'
}

Push-Location $Destination
try {
    git sparse-checkout init --no-cone
    git sparse-checkout set --no-cone @sparsePatterns
    git checkout $Branch
    Complete-IndependentClone

    Write-Host ''
    Write-Host "Toolkit profile materialized as a normal standalone working tree."
    Write-Host "Platform: $Platform"
    Write-Host "Profile: $Profile"
    Write-Host "Include workshop material: $($IncludeWorkshop.IsPresent)"
    Write-Host "Included paths: $($paths -join ', ')"
    Write-Host 'Converted sparse checkout to a new standalone repository.'
    Write-Host 'Create a new empty repo, then add it with: git remote add origin <new-repo-url>'
    Write-Host "Working directory: $(Get-Location)"
}
finally {
    Pop-Location
}


