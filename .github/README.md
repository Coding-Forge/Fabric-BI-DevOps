# GitHub Setup for Power BI Projects

This repository includes a GitHub Actions workflow for validating **Power BI PBIP** projects in GitHub.

Use this guide when you want to create or prepare a GitHub-hosted project repo that follows the workshop CI pattern.

## What gets added to the repo

The GitHub Actions workflow lives at [.github/workflows/powerbi-ci.yml](.github/workflows/powerbi-ci.yml).

It runs these stages:
- PBIP structure validation
- Dataset quality rules via Tabular Editor
- Report quality rules via PBI Inspector
- DAX unit tests
- Artifact upload

## Required repository structure

```text
repo-root/
├── .github/
│   ├── README.md
│   └── workflows/
│       └── powerbi-ci.yml
└── projects/
    ├── pbip-local/
    ├── Rules-Dataset.json
    ├── Rules-Report.json
    ├── scripts/
    │   └── Prepare-QualityRules.ps1
    └── tests/
        ├── run_dax_tests.py
        └── validate_pbip_structure.py
```

Notes:
- `projects/pbip-local/` contains the PBIP project checked by CI.
- `Rules-Dataset.json` and `Rules-Report.json` are optional. If missing, the workflow downloads community fallback rules.
- The workflow assumes the current workshop folder layout and uses paths under `projects/`.

## How to set up a project repo in GitHub

1. Create a GitHub repository for the Power BI project.
2. Copy the `projects/` CI support assets into the repo:
   - `projects/scripts/Prepare-QualityRules.ps1`
   - `projects/tests/validate_pbip_structure.py`
   - `projects/tests/run_dax_tests.py`
   - optional `projects/Rules-Dataset.json`
   - optional `projects/Rules-Report.json`
3. Copy the workflow file into `.github/workflows/powerbi-ci.yml`.
4. Place the PBIP project under `projects/pbip-local/`.
5. Push to GitHub.
6. Open the Actions tab and confirm the `Power BI CI` workflow runs.

## Recommended GitHub settings

Branch protection for `main`:
- Require a pull request before merging.
- Require status checks to pass before merging.
- Add the `Power BI CI` workflow checks as required.

Repository variables you can define for default skip behavior:
- `PBIP_CI_SKIP_DATASET_RULES`
- `PBIP_CI_SKIP_REPORT_RULES`
- `PBIP_CI_SKIP_DAX_TESTS`
- `PBIP_CI_SKIP_PUBLISH`

Set each value to `true` or `false` in GitHub under:
`Settings -> Secrets and variables -> Actions -> Variables`

## Manual workflow options

When running the workflow manually with `workflow_dispatch`, you can choose:
- `skip_dataset_rules`
- `skip_report_rules`
- `skip_dax_tests`
- `skip_publish`

These are useful when you are onboarding a repo and want to enable checks incrementally.

## Branch behavior

The workflow triggers on:
- pushes to `main`
- pushes to `feature/*`
- pull requests targeting `main`

Rule severity is branch-aware:
- dataset rules are stricter on `main`
- selected report warnings are promoted to errors on `main`
- feature branches stay less strict to reduce friction during development

That logic is implemented in [projects/scripts/Prepare-QualityRules.ps1](projects/scripts/Prepare-QualityRules.ps1).

## Current assumptions

This first GitHub workflow is designed for the workshop repository layout and is not yet packaged as a reusable shared workflow for multiple GitHub repos.

If you want, the next step is to factor this into a reusable GitHub Actions template that other repos can call with `workflow_call`.