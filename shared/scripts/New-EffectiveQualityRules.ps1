param(
    [Parameter(Mandatory = $true)]
    [string]$ReportRulesPath,

    [Parameter(Mandatory = $true)]
    [string]$DatasetRulesPath,

    [string]$OverridePath,

    [string]$ExceptionsPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory,

    [string]$SourceBranch = 'refs/heads/main',

    [string]$TargetBranch
)

$ErrorActionPreference = 'Stop'

function Test-UsableBranchRef {
    param([string]$Value)
    return ![string]::IsNullOrWhiteSpace($Value) -and $Value -notlike '$(*'
}

function ConvertTo-BranchRef {
    param([string]$Value)
    if (!(Test-UsableBranchRef -Value $Value)) { return '' }
    if ($Value.StartsWith('refs/', [System.StringComparison]::OrdinalIgnoreCase)) { return $Value }
    return "refs/heads/$Value"
}

function Test-ActiveException {
    param($Exception)
    if (!$Exception) { return $false }
    if ($Exception.status -ne 'approved') { return $false }
    if ([string]::IsNullOrWhiteSpace($Exception.expiresOn)) { return $false }
    $expires = [datetime]::Parse($Exception.expiresOn).Date
    return $expires -ge (Get-Date).Date
}

function Set-RuleThreshold {
    param(
        [Parameter(Mandatory = $true)]
        $Node,

        [Parameter(Mandatory = $true)]
        [int]$Threshold
    )

    if ($null -eq $Node) { return $false }

    if ($Node -is [System.Collections.IEnumerable] -and $Node -isnot [string]) {
        foreach ($item in $Node) {
            if (Set-RuleThreshold -Node $item -Threshold $Threshold) { return $true }
        }
        return $false
    }

    if ($Node.PSObject -and $Node.PSObject.Properties) {
        foreach ($propertyName in @('>', '>=', '<', '<=')) {
            $property = $Node.PSObject.Properties[$propertyName]
            if ($property -and $property.Value -is [System.Collections.IList] -and $property.Value.Count -ge 2) {
                $property.Value[1] = $Threshold
                return $true
            }
        }

        foreach ($property in $Node.PSObject.Properties) {
            if (Set-RuleThreshold -Node $property.Value -Threshold $Threshold) { return $true }
        }
    }

    return $false
}

function Apply-RuleChanges {
    param(
        [Parameter(Mandatory = $true)]
        $Rule,

        [Parameter(Mandatory = $true)]
        $Changes
    )

    if (!$Changes) { return @() }
    $applied = @()

    foreach ($property in $Changes.PSObject.Properties) {
        switch -Regex ($property.Name) {
            '^(logType|disabled)$' {
                if ($Rule.PSObject.Properties[$property.Name]) {
                    $Rule.$($property.Name) = $property.Value
                } else {
                    $Rule | Add-Member -NotePropertyName $property.Name -NotePropertyValue $property.Value
                }
                $applied += $property.Name
            }
            '^threshold$' {
                if ($Rule.test -and (Set-RuleThreshold -Node $Rule.test -Threshold ([int]$property.Value))) {
                    $applied += 'threshold'
                }
            }
            default {
                if ($Rule.PSObject.Properties[$property.Name]) {
                    $Rule.$($property.Name) = $property.Value
                } else {
                    $Rule | Add-Member -NotePropertyName $property.Name -NotePropertyValue $property.Value
                }
                $applied += $property.Name
            }
        }
    }

    return $applied
}

function Apply-DatasetChanges {
    param(
        [Parameter(Mandatory = $true)]
        $Rule,

        [Parameter(Mandatory = $true)]
        $Changes
    )

    if (!$Changes) { return @() }
    $applied = @()

    foreach ($property in $Changes.PSObject.Properties) {
        $name = if ($property.Name -eq 'severity') { 'Severity' } else { $property.Name }
        if ($Rule.PSObject.Properties[$name]) {
            $Rule.$name = $property.Value
        } else {
            $Rule | Add-Member -NotePropertyName $name -NotePropertyValue $property.Value
        }
        $applied += $name
    }

    return $applied
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

$reportRules = Get-Content -Path $ReportRulesPath -Raw | ConvertFrom-Json
$datasetRules = @(Get-Content -Path $DatasetRulesPath -Raw | ConvertFrom-Json)
$override = if ($OverridePath -and (Test-Path -LiteralPath $OverridePath)) { Get-Content -Path $OverridePath -Raw | ConvertFrom-Json } else { $null }
$exceptionRegister = if ($ExceptionsPath -and (Test-Path -LiteralPath $ExceptionsPath)) { Get-Content -Path $ExceptionsPath -Raw | ConvertFrom-Json } else { $null }

$sourceBranchRef = ConvertTo-BranchRef -Value $SourceBranch
$targetBranchRef = ConvertTo-BranchRef -Value $TargetBranch
$policyBranchRef = if (Test-UsableBranchRef -Value $targetBranchRef) { $targetBranchRef } else { $sourceBranchRef }
$strictBranchRefs = @('refs/heads/main', 'refs/heads/develop')
$isStrictBranch = $strictBranchRefs -contains $policyBranchRef
$mainOnlyBlockingWarnings = @(
    'REDUCE_VISUALS_ON_PAGE',
    'REDUCE_OBJECTS_WITHIN_VISUALS',
    'REDUCE_PAGES',
    'SHOW_AXES_TITLES',
    'GIVE_VISIBLE_PAGES_MEANINGFUL_NAMES'
)

$summary = [ordered]@{
    generatedAt = (Get-Date).ToString('o')
    policyBranch = $policyBranchRef
    strictBranch = $isStrictBranch
    reportRules = @()
    datasetRules = @()
    exceptionsApplied = @()
    exceptionsIgnored = @()
}

foreach ($rule in $reportRules.rules) {
    if ($rule.PSObject.Properties.Name -notcontains 'logType' -or [string]::IsNullOrWhiteSpace($rule.logType)) {
        $rule | Add-Member -NotePropertyName logType -NotePropertyValue 'warning'
    }

    if ($mainOnlyBlockingWarnings -contains $rule.id) {
        $rule.logType = if ($isStrictBranch) { 'error' } else { 'warning' }
        $summary.reportRules += [ordered]@{ id = $rule.id; action = 'branch-promotion'; value = $rule.logType }
    }
}

if ($override) {
    foreach ($item in @($override.reportRuleOverrides)) {
        $rule = $reportRules.rules | Where-Object { $_.id -eq $item.id } | Select-Object -First 1
        if ($rule) {
            $applied = Apply-RuleChanges -Rule $rule -Changes $item.changes
            $summary.reportRules += [ordered]@{ id = $item.id; action = 'override'; changes = $applied }
        }
    }

    foreach ($item in @($override.datasetRuleOverrides)) {
        $rule = $datasetRules | Where-Object { $_.ID -eq $item.id -or $_.ID -eq $item.ID } | Select-Object -First 1
        if ($rule) {
            $applied = Apply-DatasetChanges -Rule $rule -Changes $item.changes
            $summary.datasetRules += [ordered]@{ id = $rule.ID; action = 'override'; changes = $applied }
        }
    }

    foreach ($item in @($override.disabledRules)) {
        $rule = $reportRules.rules | Where-Object { $_.id -eq $item.id } | Select-Object -First 1
        if ($rule) {
            $rule.disabled = $true
            $summary.reportRules += [ordered]@{ id = $item.id; action = 'disabled' }
        }
    }
}

foreach ($exception in @($exceptionRegister.exceptions)) {
    if (!(Test-ActiveException -Exception $exception)) {
        $summary.exceptionsIgnored += [ordered]@{ id = $exception.id; ruleId = $exception.ruleId; status = $exception.status; expiresOn = $exception.expiresOn }
        continue
    }

    $reportRule = $reportRules.rules | Where-Object { $_.id -eq $exception.ruleId } | Select-Object -First 1
    $datasetRule = $datasetRules | Where-Object { $_.ID -eq $exception.ruleId } | Select-Object -First 1
    if ($exception.changes -and $reportRule) {
        $applied = Apply-RuleChanges -Rule $reportRule -Changes $exception.changes
        $summary.exceptionsApplied += [ordered]@{ id = $exception.id; ruleId = $exception.ruleId; changes = $applied }
    } elseif ($exception.changes -and $datasetRule) {
        $applied = Apply-DatasetChanges -Rule $datasetRule -Changes $exception.changes
        $summary.exceptionsApplied += [ordered]@{ id = $exception.id; ruleId = $exception.ruleId; changes = $applied }
    } else {
        $summary.exceptionsApplied += [ordered]@{ id = $exception.id; ruleId = $exception.ruleId; changes = @(); note = 'Approved exception tracked; no rule changes defined.' }
    }
}

$minimumSeverity = if ($isStrictBranch) { 2 } else { 3 }
$effectiveDatasetRules = @($datasetRules | Where-Object { [int]$_.Severity -ge $minimumSeverity })

$reportOutputPath = Join-Path $OutputDirectory 'Rules-Report.effective.json'
$datasetOutputPath = Join-Path $OutputDirectory 'Rules-Dataset.effective.json'
$summaryJsonPath = Join-Path $OutputDirectory 'effective-rules-summary.json'
$summaryMarkdownPath = Join-Path $OutputDirectory 'effective-rules-summary.md'

$reportRules | ConvertTo-Json -Depth 100 | Set-Content -Path $reportOutputPath -Encoding UTF8
$effectiveDatasetRules | ConvertTo-Json -Depth 100 | Set-Content -Path $datasetOutputPath -Encoding UTF8
$summary | ConvertTo-Json -Depth 100 | Set-Content -Path $summaryJsonPath -Encoding UTF8

$markdown = @(
    '# Effective Quality Rules Summary',
    '',
    "| Field | Value |",
    "|---|---|",
    "| Generated | $($summary.generatedAt) |",
    "| Policy branch | $policyBranchRef |",
    "| Strict branch | $isStrictBranch |",
    "| Dataset minimum severity | $minimumSeverity |",
    "| Report output | Rules-Report.effective.json |",
    "| Dataset output | Rules-Dataset.effective.json |",
    '',
    '## Applied exceptions',
    ''
)

if ($summary.exceptionsApplied.Count -eq 0) {
    $markdown += '- No active exceptions changed effective rules.'
} else {
    foreach ($item in $summary.exceptionsApplied) {
        $markdown += "- $($item.id) / $($item.ruleId): $(@($item.changes) -join ', ')"
    }
}

$markdown | Set-Content -Path $summaryMarkdownPath -Encoding UTF8

Write-Host "Effective report rules: $reportOutputPath"
Write-Host "Effective dataset rules: $datasetOutputPath"
Write-Host "Summary: $summaryMarkdownPath"
