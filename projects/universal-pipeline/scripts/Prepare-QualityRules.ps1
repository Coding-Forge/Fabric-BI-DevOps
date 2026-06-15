param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('dataset', 'report')]
    [string]$Mode,

    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath,

    [Parameter(Mandatory = $true)]
    [string]$SourceBranch,

    [string]$TargetBranch
)

$ErrorActionPreference = 'Stop'

function Test-UsableBranchRef {
    param([string]$Value)

    return ![string]::IsNullOrWhiteSpace($Value) -and $Value -notlike '$(*'
}

function ConvertTo-BranchRef {
    param([string]$Value)

    if (!(Test-UsableBranchRef -Value $Value)) {
        return ''
    }

    if ($Value.StartsWith('refs/', [System.StringComparison]::OrdinalIgnoreCase)) {
        return $Value
    }

    return "refs/heads/$Value"
}

$outputDirectory = Split-Path -Path $OutputPath -Parent
if ($outputDirectory) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

$sourceBranchRef = ConvertTo-BranchRef -Value $SourceBranch
$targetBranchRef = ConvertTo-BranchRef -Value $TargetBranch
$policyBranchRef = if (Test-UsableBranchRef -Value $targetBranchRef) { $targetBranchRef } else { $sourceBranchRef }
$strictBranchRefs = @('refs/heads/main', 'refs/heads/develop')
$isStrictBranch = $strictBranchRefs -contains $policyBranchRef

if ($Mode -eq 'dataset') {
    $rules = Get-Content -Path $SourcePath -Raw | ConvertFrom-Json
    $minimumSeverity = if ($isStrictBranch) { 2 } else { 3 }
    $effectiveRules = @($rules | Where-Object { [int]$_.Severity -ge $minimumSeverity })
    $effectiveRules | ConvertTo-Json -Depth 100 | Set-Content -Path $OutputPath -Encoding UTF8
    Write-Host "Prepared dataset rules for $policyBranchRef with minimum severity $minimumSeverity."
    exit 0
}

$mainOnlyBlockingWarnings = @(
    'REDUCE_VISUALS_ON_PAGE',
    'REDUCE_OBJECTS_WITHIN_VISUALS',
    'REDUCE_PAGES',
    'SHOW_AXES_TITLES',
    'GIVE_VISIBLE_PAGES_MEANINGFUL_NAMES'
)

$reportRules = Get-Content -Path $SourcePath -Raw | ConvertFrom-Json
foreach ($rule in $reportRules.rules) {
    if ($rule.PSObject.Properties.Name -notcontains 'logType' -or [string]::IsNullOrWhiteSpace($rule.logType)) {
        $rule | Add-Member -NotePropertyName logType -NotePropertyValue 'warning'
    }

    if ($mainOnlyBlockingWarnings -contains $rule.id) {
        $rule.logType = if ($isStrictBranch) { 'error' } else { 'warning' }
    }
}

$reportRules | ConvertTo-Json -Depth 100 | Set-Content -Path $OutputPath -Encoding UTF8
Write-Host "Prepared report rules for $policyBranchRef. Strict-branch blocking rules promoted: $isStrictBranch"
