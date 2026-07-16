# GitLab CI/CD Pipelines

This folder contains the GitLab CI/CD pipeline for Microsoft Fabric PBIP validation and deployment. Entry-point pipeline references shared assets in [`../shared/`](../shared/).

## Files

| File | Purpose |
|------|---------|
| `gitlab-ci.yml` | Full 5-stage CI/CD pipeline: Validate → Quality Rules → DAX Tests → Publish → Deploy |

## Quick Setup

### 1. Configure GitLab to use this pipeline file

By default GitLab looks for `.gitlab-ci.yml` at the repo root. To use the file from this folder:

1. Go to **Settings → CI/CD → General pipelines**
2. Set **CI/CD configuration file** to: `gitlab/gitlab-ci.yml`
3. Save changes

### 2. Register a Windows runner (required for quality rules and deploy jobs)

Dataset rules (Tabular Editor) and report rules (Fab Inspector) require a Windows shell runner:

1. Go to **Settings → CI/CD → Runners → New project runner**
2. Select **Windows** as the operating system
3. Add the tag `windows`
4. Follow the runner registration steps and install as a Windows service

Linux shared runners handle `validate`, `dax_tests`, and `publish_artifact` jobs automatically.

### 3. Add required CI/CD variables

Go to **Settings → CI/CD → Variables** and add the following. Mark all as **Masked** and **Protected**:

| Variable | Description |
|----------|-------------|
| `TENANT_ID` | Azure AD tenant ID |
| `APP_ID` | Service principal application (client) ID |
| `CLIENT_SECRET` | Service principal client secret |
| `DEV_WORKSPACE_NAME` | Display name of the target Dev Fabric workspace |
| `DEV_WORKSPACE_ID` | *(alternative to DEV_WORKSPACE_NAME)* Fabric workspace GUID |
| `FEATURE_WORKSPACE_PREFIX` | Prefix for auto-created feature workspaces (feature/* deployments only) |

### 4. Optional skip variables

Set any of these to `true` to skip a stage across all pipelines:

| Variable | Default | Effect |
|----------|---------|--------|
| `SKIP_DATASET_RULES` | `false` | Skip Tabular Editor dataset quality rules |
| `SKIP_REPORT_RULES` | `false` | Skip Fab Inspector report quality rules |
| `SKIP_DAX_TESTS` | `false` | Skip DAX unit tests |
| `SKIP_PUBLISH` | `false` | Skip artifact publish and deployment |

## Pipeline Stages

```
validate → quality (dataset + report, parallel) → test → publish → deploy
```

| Stage | Jobs | Runner |
|-------|------|--------|
| validate | `validate_pbip` — PBIP folder structure check | Linux |
| quality | `dataset_rules` — Tabular Editor BPA rules | Windows |
| quality | `report_rules` — Fab Inspector PBIR rules | Windows |
| test | `dax_tests` — semantic-link-labs DAX unit tests | Linux |
| publish | `publish_artifact` — packages PBIP artifact | Linux |
| deploy | `deploy_dev` — deploys to Dev workspace on main/develop | Windows |
| deploy | `deploy_feature` — deploys to feature workspace on feature/* | Windows |

## Branch Behavior

| Branch | Stages run |
|--------|-----------|
| `main` / `develop` | All stages including Deploy Dev |
| `feature/*` | All stages including Deploy Feature (auto-creates workspace) |
| Merge Request | validate + quality + test only (no publish/deploy) |

## Shared Assets

These pipelines use common assets from [`../shared/`](../shared/):

- `shared/pbip-local/` — local PBIP artifacts (place your `.pbip` project here)
- `shared/scripts/Prepare-QualityRules.ps1` — branch-aware quality rule preparation
- `shared/scripts/deploy-dynamic.ps1` — Fabric REST API deployment script
- `shared/tests/validate_pbip_structure.py` — PBIP structure validator
- `shared/tests/run_dax_tests.py` — DAX unit test runner
- `shared/Rules-Dataset.json` — dataset quality rule configuration
- `shared/Rules-Report.json` — report quality rule configuration
- `shared/dax-tests.json` — metadata-driven DAX test catalog
- `tools/` — no-code accelerator builders, scanners, and launchpad
- `images/` — tool screenshots used by docs and the launchpad

## Sparse Clone (GitLab profile)

To clone only the GitLab-relevant folders from a shell:

```powershell
.\shared\scripts\Clone-SparseGitLabProfile.ps1 `
  -RepoUrl https://gitlab.com/<group>/<repo>.git `
  -Destination C:\Projects\Fabric-GitLab-Dev `
  -Branch main
```

Included folders: `gitlab`, `shared`, `docs`, `tools`, `images`
