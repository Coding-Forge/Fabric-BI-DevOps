[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$PbipPath,

    [string]$PbixFile,

    [string]$ManifestPath,

    [string]$ArtifactName,

    [string]$GeneratedBy = 'Power BI Desktop',

    [switch]$ValidateOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Resolve-PbixFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,

        [string]$ExplicitFile
    )

    if (![string]::IsNullOrWhiteSpace($ExplicitFile)) {
        $resolvedFile = (Resolve-Path -Path $ExplicitFile).Path
        if ([System.IO.Path]::GetExtension($resolvedFile) -ne '.pbix') {
            throw "Expected a .pbix file, got: $resolvedFile"
        }

        return $resolvedFile
    }

    $pbixFiles = @(Get-ChildItem -Path $RootPath -Filter '*.pbix' -File)
    if ($pbixFiles.Count -eq 0) {
        throw "No .pbix file found under $RootPath."
    }

    if ($pbixFiles.Count -gt 1) {
        $fileList = ($pbixFiles | ForEach-Object { $_.FullName }) -join ', '
        throw "Multiple .pbix files found under $RootPath. Provide -PbixFile explicitly. Matches: $fileList"
    }

    return $pbixFiles[0].FullName
}

function Get-RelativePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,

        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    $root = (Resolve-Path -Path $RootPath).Path.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
    $rootUri = [System.Uri]::new($root)
    $fileUri = [System.Uri]::new((Resolve-Path -Path $FilePath).Path)
    return [System.Uri]::UnescapeDataString($rootUri.MakeRelativeUri($fileUri).ToString()).Replace('/', '\')
}

function Get-PbipSourceFiles {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,

        [Parameter(Mandatory = $true)]
        [string]$ManifestFile
    )

    $manifestFullName = if (Test-Path -Path $ManifestFile) {
        (Resolve-Path -Path $ManifestFile).Path
    }
    else {
        [System.IO.Path]::GetFullPath($ManifestFile)
    }

    return Get-ChildItem -Path $RootPath -File -Recurse | Where-Object {
        $_.Extension -ne '.pbix' -and
        $_.FullName -ne $manifestFullName -and
        ($_.FullName -split '[\\/]' -notcontains '.pbi')
    } | Sort-Object FullName
}

function Get-PbipSourceHash {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,

        [Parameter(Mandatory = $true)]
        [string]$ManifestFile
    )

    $sourceFiles = @(Get-PbipSourceFiles -RootPath $RootPath -ManifestFile $ManifestFile)
    if ($sourceFiles.Count -eq 0) {
        throw "No PBIP source files found under $RootPath."
    }

    $entries = foreach ($file in $sourceFiles) {
        $relativePath = Get-RelativePath -RootPath $RootPath -FilePath $file.FullName
        $fileHash = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash.ToUpperInvariant()
        "$relativePath`t$fileHash"
    }

    $payload = [System.Text.Encoding]::UTF8.GetBytes(($entries -join "`n"))
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    try {
        return [System.BitConverter]::ToString($sha256.ComputeHash($payload)).Replace('-', '').ToUpperInvariant()
    }
    finally {
        $sha256.Dispose()
    }
}

function Test-Manifest {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,

        [Parameter(Mandatory = $true)]
        [string]$ManifestFile
    )

    if (!(Test-Path -Path $ManifestFile -PathType Leaf)) {
        throw "PBIX deployment manifest not found: $ManifestFile"
    }

    $manifest = Get-Content -Path $ManifestFile -Raw | ConvertFrom-Json
    $artifacts = if ($manifest.artifacts) { $manifest.artifacts } else { $manifest }
    if ([string]::IsNullOrWhiteSpace($artifacts.pbixFile)) {
        throw "Manifest is missing required property: artifacts.pbixFile"
    }

    if ([string]::IsNullOrWhiteSpace($artifacts.pbixSha256)) {
        throw "Manifest is missing required property: artifacts.pbixSha256"
    }

    if ([string]::IsNullOrWhiteSpace($artifacts.pbipSourceSha256)) {
        throw "Manifest is missing required property: artifacts.pbipSourceSha256"
    }

    if ([string]::IsNullOrWhiteSpace($artifacts.pbixGeneratedUtc)) {
        throw "Manifest is missing required property: artifacts.pbixGeneratedUtc"
    }

    [datetime]::Parse($artifacts.pbixGeneratedUtc).ToUniversalTime() | Out-Null

    $manifestDirectory = Split-Path -Parent (Resolve-Path -Path $ManifestFile).Path
    $manifestPbixPath = Join-Path $manifestDirectory $artifacts.pbixFile
    if (!(Test-Path -Path $manifestPbixPath -PathType Leaf)) {
        throw "PBIX file named by manifest was not found: $manifestPbixPath"
    }

    $actualPbixHash = (Get-FileHash -Path $manifestPbixPath -Algorithm SHA256).Hash.ToUpperInvariant()
    if ($actualPbixHash -ne $artifacts.pbixSha256.ToUpperInvariant()) {
        throw "PBIX SHA256 mismatch. Manifest: $($artifacts.pbixSha256); actual: $actualPbixHash"
    }

    $actualSourceHash = Get-PbipSourceHash -RootPath $RootPath -ManifestFile $ManifestFile
    if ($actualSourceHash -ne $artifacts.pbipSourceSha256.ToUpperInvariant()) {
        throw "PBIP source SHA256 mismatch. Manifest: $($artifacts.pbipSourceSha256); actual: $actualSourceHash"
    }

    Write-Host "PBIX deployment manifest is valid: $ManifestFile"
}

function Get-FirstRelativeFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,

        [Parameter(Mandatory = $true)]
        [string]$Filter
    )

    $file = Get-ChildItem -Path $RootPath -Filter $Filter -File | Select-Object -First 1
    if (!$file) {
        return ''
    }

    return Get-RelativePath -RootPath $RootPath -FilePath $file.FullName
}

function Get-FirstRelativeDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,

        [Parameter(Mandatory = $true)]
        [string]$Suffix
    )

    $directory = Get-ChildItem -Path $RootPath -Directory | Where-Object { $_.Name -like "*$Suffix" } | Select-Object -First 1
    if (!$directory) {
        return ''
    }

    return Get-RelativePath -RootPath $RootPath -FilePath $directory.FullName
}

function New-ToolkitDeploymentManifest {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,

        [Parameter(Mandatory = $true)]
        [string]$ResolvedPbixFile,

        [Parameter(Mandatory = $true)]
        [string]$ManifestFile,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $manifestDirectory = Split-Path -Parent $ManifestFile
    return [pscustomobject][ordered]@{
        version = 1
        solution = [pscustomobject][ordered]@{
            name = $Name
            domain = ''
            criticality = 'medium'
            businessOwner = ''
            technicalOwner = ''
            supportContact = ''
            description = ''
        }
        artifacts = [pscustomobject][ordered]@{
            pbipFile = Get-FirstRelativeFile -RootPath $RootPath -Filter '*.pbip'
            reportPath = Get-FirstRelativeDirectory -RootPath $RootPath -Suffix '.Report'
            semanticModelPath = Get-FirstRelativeDirectory -RootPath $RootPath -Suffix '.SemanticModel'
            rulesReport = 'shared/Rules-Report.json'
            rulesDataset = 'shared/Rules-Dataset.json'
            daxTests = 'shared/dax-tests.json'
            pbixFile = Get-RelativePath -RootPath $manifestDirectory -FilePath $ResolvedPbixFile
            pbixSha256 = ''
            pbipSourceSha256 = ''
            pbixGeneratedUtc = ''
            pbixGeneratedBy = ''
        }
        environments = @(
            [pscustomobject][ordered]@{ name = 'Dev'; workspaceName = ''; workspaceId = ''; deploymentStage = 'Development'; connectionProfile = 'dev' },
            [pscustomobject][ordered]@{ name = 'Test'; workspaceName = ''; workspaceId = ''; deploymentStage = 'Test'; connectionProfile = 'test' },
            [pscustomobject][ordered]@{ name = 'Prod'; workspaceName = ''; workspaceId = ''; deploymentStage = 'Production'; connectionProfile = 'prod' }
        )
        parameters = @()
        validationGates = @(
            [pscustomobject][ordered]@{ name = 'PBIP structure validation'; requirement = 'required' },
            [pscustomobject][ordered]@{ name = 'PBIX deployment manifest validation'; requirement = 'required for GCC High' }
        )
        deployment = [pscustomobject][ordered]@{
            strategy = 'Git PR -> CI validation -> Deploy to Dev -> Promote Test -> Promote Prod'
            rollback = 'Revert Git commit and redeploy the previous successful artifact.'
            requiresManualApprovalForProd = $true
        }
        approvals = @()
        exceptions = @()
    }
}

function Ensure-Property {
    param(
        [Parameter(Mandatory = $true)]
        [object]$InputObject,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [object]$Value
    )

    if ($InputObject.PSObject.Properties.Name -contains $Name) {
        $InputObject.$Name = $Value
    }
    else {
        $InputObject | Add-Member -NotePropertyName $Name -NotePropertyValue $Value
    }
}

$resolvedPbipPath = (Resolve-Path -Path $PbipPath).Path
if ([string]::IsNullOrWhiteSpace($ManifestPath)) {
    $ManifestPath = Join-Path $resolvedPbipPath 'deployment-manifest.json'
}

$manifestFullPath = if (Test-Path -Path $ManifestPath) {
    (Resolve-Path -Path $ManifestPath).Path
}
else {
    [System.IO.Path]::GetFullPath($ManifestPath)
}

if ($ValidateOnly) {
    Test-Manifest -RootPath $resolvedPbipPath -ManifestFile $manifestFullPath
    return
}

$resolvedPbixFile = Resolve-PbixFile -RootPath $resolvedPbipPath -ExplicitFile $PbixFile
if ([string]::IsNullOrWhiteSpace($ArtifactName)) {
    $ArtifactName = [System.IO.Path]::GetFileNameWithoutExtension($resolvedPbixFile)
}

$manifestDirectory = Split-Path -Parent $manifestFullPath
if (!(Test-Path -Path $manifestDirectory)) {
    New-Item -ItemType Directory -Path $manifestDirectory -Force | Out-Null
}

$manifest = if (Test-Path -Path $manifestFullPath -PathType Leaf) {
    Get-Content -Path $manifestFullPath -Raw | ConvertFrom-Json
}
else {
    New-ToolkitDeploymentManifest -RootPath $resolvedPbipPath -ResolvedPbixFile $resolvedPbixFile -ManifestFile $manifestFullPath -Name $ArtifactName
}

if (!($manifest.PSObject.Properties.Name -contains 'version')) {
    $manifest = New-ToolkitDeploymentManifest -RootPath $resolvedPbipPath -ResolvedPbixFile $resolvedPbixFile -ManifestFile $manifestFullPath -Name $ArtifactName
}

if (!($manifest.PSObject.Properties.Name -contains 'artifacts') -or !$manifest.artifacts) {
    $manifest | Add-Member -NotePropertyName 'artifacts' -NotePropertyValue ([pscustomobject]@{})
}

Ensure-Property -InputObject $manifest.artifacts -Name 'pbixFile' -Value (Get-RelativePath -RootPath $manifestDirectory -FilePath $resolvedPbixFile)
Ensure-Property -InputObject $manifest.artifacts -Name 'pbixSha256' -Value (Get-FileHash -Path $resolvedPbixFile -Algorithm SHA256).Hash.ToUpperInvariant()
Ensure-Property -InputObject $manifest.artifacts -Name 'pbipSourceSha256' -Value (Get-PbipSourceHash -RootPath $resolvedPbipPath -ManifestFile $manifestFullPath)
Ensure-Property -InputObject $manifest.artifacts -Name 'pbixGeneratedUtc' -Value ([datetime]::UtcNow.ToString('o'))
Ensure-Property -InputObject $manifest.artifacts -Name 'pbixGeneratedBy' -Value $GeneratedBy

$manifest | ConvertTo-Json -Depth 10 | Set-Content -Path $manifestFullPath -Encoding UTF8
Write-Host "Wrote PBIX deployment manifest: $manifestFullPath"
