# Local Validation Guide

This guide shows how to validate the PBIP project locally before pushing changes.

## What You Can Validate Locally

- PBIP file and folder structure
- branch-aware preparation of report and dataset rules
- DAX test harness execution

Tool execution for Tabular Editor and PBI Inspector is handled directly in CI, but this guide shows how to validate the inputs they rely on.

## Prerequisites

- PowerShell 7 or Windows PowerShell
- Python 3.11 or later available on `PATH`
- repository cloned at the project root

## 1. Validate PBIP Structure

Run this from the repository root:

```powershell
python tests/validate_pbip_structure.py --pbip-path "."
```

Expected outcome:

- one `.pbip` file exists at the root
- the report path exists
- the report points to a semantic model path
- required report and semantic model files exist

## 2. Prepare Effective Dataset Rules

The pipeline never runs `Rules-Dataset.json` directly. It first prepares an effective ruleset based on branch name.

Example for a feature branch:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Prepare-QualityRules.ps1 `
  -Mode dataset `
  -SourcePath .\Rules-Dataset.json `
  -OutputPath .\artifacts\Rules-Dataset.effective.json `
  -SourceBranch refs/heads/feature/example
```

Example for `main`:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Prepare-QualityRules.ps1 `
  -Mode dataset `
  -SourcePath .\Rules-Dataset.json `
  -OutputPath .\artifacts\Rules-Dataset.effective.json `
  -SourceBranch refs/heads/main
```

Behavior:

- feature branch output keeps only `Severity >= 3`
- `main` output keeps only `Severity >= 2`

## 3. Prepare Effective Report Rules

Example for a feature branch:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Prepare-QualityRules.ps1 `
  -Mode report `
  -SourcePath .\Rules-Report.json `
  -OutputPath .\artifacts\Rules-Report.effective.json `
  -SourceBranch refs/heads/feature/example
```

Example for `main`:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Prepare-QualityRules.ps1 `
  -Mode report `
  -SourcePath .\Rules-Report.json `
  -OutputPath .\artifacts\Rules-Report.effective.json `
  -SourceBranch refs/heads/main
```

Behavior:

- rules missing `logType` are defaulted to `warning`
- selected rules are promoted from `warning` to `error` on protected branches such as `main` and `develop`

## 4. Run the DAX Test Harness

The current test runner is a lightweight placeholder that checks for model existence and emits JUnit XML.

Run it with:

```powershell
python tests/run_dax_tests.py --model-path "."
```

Expected output:

- `test-results/dax-test-results.xml`

## 5. Inspect Prepared Rule Outputs

Prepared files are the best way to confirm branch-specific behavior before pushing.

Useful checks:

```powershell
Get-Content .\artifacts\Rules-Dataset.effective.json
Get-Content .\artifacts\Rules-Report.effective.json
```

## What CI Adds Beyond Local Checks

`azure-pipelines.yml` also downloads and runs:

- Tabular Editor for dataset BPA rules
- PBI Inspector CLI for report rules
- published JUnit test results

If a local validation passes but CI fails, the next place to inspect is usually rule preparation or tool-specific rule execution.

## Recommended Pre-Push Sequence

Use this order before opening a PR:

1. Validate PBIP structure.
2. Prepare effective dataset rules for the target branch.
3. Prepare effective report rules for the target branch.
4. Run the DAX test harness.
5. Review diffs in rule files if you changed standards.