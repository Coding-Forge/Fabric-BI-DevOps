# GitHub Actions Setup for Power BI and Fabric Projects

This folder contains the GitHub Actions workflow for running Enterprise BI DevOps with Microsoft Fabric against **Power BI PBIP** projects in GitHub.

Use this guide when you want to create or prepare a GitHub-hosted project repo that follows the workshop CI/CD pattern.

## What gets added to the repo

The GitHub Actions workflow lives at [.github/workflows/powerbi-ci.yml](.github/workflows/powerbi-ci.yml).

It runs these stages:
- PBIP structure validation
- Dataset quality rules via Tabular Editor
- Report quality rules via PBI Inspector
- DAX unit tests
- Artifact upload
- Deploy to Dev workspace (`main` and `develop`)
- Deploy to feature workspace (`feature/*`)

## Required repository structure

```text
repo-root/
├── .github/
│   ├── README.md
│   └── workflows/
│       └── powerbi-ci.yml
├── shared/
│   ├── pbip-local/
│   ├── Rules-Dataset.json
│   ├── Rules-Report.json
│   ├── dax-tests.json
│   ├── scripts/
│   │   ├── Prepare-QualityRules.ps1
│   │   └── deploy-dynamic.ps1
│   └── tests/
│       ├── run_dax_tests.py
│       └── validate_pbip_structure.py
├── tools/
│   └── index.html
└── images/
```

Notes:
- `shared/pbip-local/` contains the PBIP project checked by CI.
- `Rules-Dataset.json` and `Rules-Report.json` are optional. If missing, the workflow downloads community fallback rules.
- The workflow assumes the current workshop folder layout and uses paths under `shared/`.

## How to set up a project repo in GitHub

1. Create a GitHub repository for the Power BI project.
2. Copy the `shared/` CI/CD support assets into the repo:
   - `shared/scripts/Prepare-QualityRules.ps1`
   - `shared/scripts/deploy-dynamic.ps1`
   - `shared/tests/validate_pbip_structure.py`
   - `shared/tests/run_dax_tests.py`
   - optional `shared/dax-tests.json`
   - optional `shared/Rules-Dataset.json`
   - optional `shared/Rules-Report.json`
3. Copy `tools/` and `images/` if you want the no-code accelerator builders, scanners, launchpad, and screenshots.
4. Copy the workflow file into `.github/workflows/powerbi-ci.yml`.
5. Place the PBIP project under `shared/pbip-local/`.
6. Push to GitHub.
7. Open the Actions tab and confirm the `Power BI CI/CD` workflow runs.

If you used `shared/scripts/Clone-SparseGitHubProfile.ps1`, the script removes the source `origin` remote after checkout. Add the new customer GitHub repo as `origin` before pushing:

```powershell
git remote add origin https://github.com/<org>/<repo>.git
git push -u origin main
```

## Recommended GitHub settings

Branch protection for `main`:
- Require a pull request before merging.
- Require status checks to pass before merging.
- Add the `Power BI CI/CD` workflow checks as required.

Repository secrets required for deployment:
- `TENANT_ID`
- `APP_ID`
- `CLIENT_SECRET`
- `DEV_WORKSPACE_ID` (optional if `DEV_WORKSPACE_NAME` is set)

Repository or environment variables required for deployment:
- `DEV_WORKSPACE_NAME` (optional if `DEV_WORKSPACE_ID` is set)
- `FEATURE_WORKSPACE_PREFIX` (required for `feature/*` deployments)

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
- pushes to `develop`
- pushes to `feature/*`
- pull requests targeting `main` or `develop`

Deployment behavior:
- `main` and `develop`: deploy to Dev workspace
- `feature/*`: create or update a prefixed feature workspace
- pull requests: validation and tests run, but deploy jobs are skipped

Rule severity is branch-aware:
- dataset rules are stricter on protected target branches such as `main`
- selected report warnings are promoted to errors on protected target branches such as `main`
- feature branches stay less strict to reduce friction during development

That logic is implemented in [shared/scripts/Prepare-QualityRules.ps1](shared/scripts/Prepare-QualityRules.ps1).

## Current assumptions

This first GitHub workflow is designed for the workshop repository layout and is not yet packaged as a reusable shared workflow for multiple GitHub repos.

If you want, the next step is to factor this into a reusable GitHub Actions template that other repos can call with `workflow_call`.
