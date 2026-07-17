# Azure DevOps Setup for Power BI and Fabric Projects

This folder contains Azure DevOps-specific pipeline entry points for running Enterprise BI DevOps with Microsoft Fabric against Power BI PBIP projects.

Use this guide when you want to create or prepare an Azure DevOps-hosted project repo that follows the shared validation, quality, test, publish, and deployment pattern.

## Files

| File | Purpose |
|---|---|
| `azure-pipelines.yml` | Full CI/CD pipeline: Validate -> Quality Rules -> DAX Tests -> Publish -> Deploy |
| `azure-pipelines_ci.yml` | CI-focused pipeline for validation, quality rules, DAX tests, and artifact publication |

## What the pipeline runs

The full pipeline runs these stages:

- PBIP structure validation
- Dataset quality rules via Tabular Editor
- Report quality rules via PBI Inspector / Fab Inspector
- DAX unit tests from `shared/dax-tests.json`
- Artifact publication
- Deploy to Dev workspace on `main` and `develop`
- Deploy to feature workspace on `feature/*`

Pull request runs validate and test, but deployment should remain gated by branch conditions.

## Required repository structure

```text
repo-root/
├── azdo/
│   ├── README.md
│   ├── azure-pipelines.yml
│   └── azure-pipelines_ci.yml
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

## Shared Assets

These pipelines use common project assets from sibling folders under `shared/`:

- `shared/pbip-local/` for local PBIP artifacts
- `shared/scripts/` for branch-aware quality rule prep and deployment scripts
- `shared/tests/` for PBIP validation and DAX unit test runners
- `shared/Rules-Dataset.json` and `shared/Rules-Report.json` for quality rule configuration
- `shared/dax-tests.json` for metadata-driven DAX test definitions
- `tools/` for the no-code accelerator builders, scanners, and launchpad
- `images/` for tool screenshots used by docs and the launchpad

## Quick Setup

### 1. Create the Azure DevOps pipeline

When creating a pipeline in Azure DevOps for this workshop repo, select:

- `/azdo/azure-pipelines.yml`

Use `/azdo/azure-pipelines_ci.yml` when you want CI validation without the full deployment path.

### 2. Add required variables

The deployment stages require these variables in the pipeline UI or in a linked variable group:

| Variable | Description |
|---|---|
| `TenantId` | Microsoft Entra tenant ID |
| `AppId` | Service principal application/client ID |
| `ClientSecret` | Service principal client secret |
| `DevWorkspaceId` | Fabric workspace GUID for Dev deployment |
| `FeatureWorkspacePrefix` | Prefix for auto-created feature workspaces |

The included pipeline references the variable group:

```yaml
variables:
  - group: pbip-shared-secrets
```

Create that variable group or update the YAML to match your organization's variable group name.

### 3. Confirm service principal permissions

The service principal must be:

- Allowed by Fabric tenant settings.
- Added to the target Fabric workspace.
- Granted permission to create/update items required by the deployment script.

### 4. Configure branch policy

For protected branches such as `main` and `develop`, configure branch policies to require:

- Pull request review.
- Successful Azure Pipeline validation.
- No direct pushes, if that is part of your governance model.

If you used `shared/scripts/Clone-SparseAzDoProfile.ps1`, the script removes the source `origin` remote after checkout. Add the new Azure DevOps repo as `origin` before pushing:

```powershell
git remote add origin https://dev.azure.com/<org>/<project>/_git/<repo>
git push -u origin main
```

## Branch behavior

| Branch | Behavior |
|---|---|
| `main` / `develop` | Validate, run quality rules, run tests, publish artifacts, deploy to Dev |
| `feature/*` | Validate, run quality rules, run tests, publish artifacts, deploy to a feature workspace |
| Pull request | Validate, run quality rules, and run tests without deployment |

Rule severity is branch-aware:

- Dataset rules enforce lower severity thresholds on protected target branches.
- Selected report warnings are promoted to errors on protected target branches.
- Feature branches stay less strict to reduce friction during development.

That logic is implemented in [`../shared/scripts/Prepare-QualityRules.ps1`](../shared/scripts/Prepare-QualityRules.ps1).
