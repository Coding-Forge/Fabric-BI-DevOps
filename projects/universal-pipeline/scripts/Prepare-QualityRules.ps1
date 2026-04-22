param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('dataset', 'report')]
    [string]$Mode,

    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath,

    [Parameter(Mandatory = $true)]
    [string]$SourceBranch
)

$ErrorActionPreference = 'Stop'

$outputDirectory = Split-Path -Path $OutputPath -Parent
if ($outputDirectory) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

$isMain = $SourceBranch -eq 'refs/heads/main'

if ($Mode -eq 'dataset') {
    $rules = Get-Content -Path $SourcePath -Raw | ConvertFrom-Json
    $minimumSeverity = if ($isMain) { 2 } else { 3 }
    $effectiveRules = @($rules | Where-Object { [int]$_.Severity -ge $minimumSeverity })
    $effectiveRules | ConvertTo-Json -Depth 100 | Set-Content -Path $OutputPath -Encoding UTF8
    Write-Host "Prepared dataset rules for $SourceBranch with minimum severity $minimumSeverity."
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
        $rule.logType = if ($isMain) { 'error' } else { 'warning' }
    }
}

$reportRules | ConvertTo-Json -Depth 100 | Set-Content -Path $OutputPath -Encoding UTF8
Write-Host "Prepared report rules for $SourceBranch. Main-only blocking rules promoted: $isMain"
