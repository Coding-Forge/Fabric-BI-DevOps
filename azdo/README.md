# Azure DevOps Pipelines

This folder contains Azure DevOps-specific pipeline entrypoints for the workshop repository.

## Files

- `azure-pipelines.yml`: Full workshop CI/CD pipeline (Validate, Test, Publish, Deploy_Dev, Deploy_Feature).
- `azure-pipelines_ci.yml`: CI-focused variant used for validation and artifact publication.

## Shared Assets

These pipelines use common project assets from sibling folders under `shared/`:

- `shared/pbip-local/` for local PBIP artifacts
- `shared/scripts/` for branch-aware quality rule prep and deployment scripts
- `shared/tests/` for PBIP validation and DAX unit test runners
- `shared/Rules-Dataset.json` and `shared/Rules-Report.json` for quality rule configuration
- `shared/dax-tests.json` for metadata-driven DAX test definitions
- `tools/` for the no-code accelerator builders, scanners, and launchpad
- `images/` for tool screenshots used by docs and the launchpad

## Azure DevOps YAML Path

When creating a pipeline in Azure DevOps for this workshop repo, select:

- `/azdo/azure-pipelines.yml`

If you used `shared/scripts/Clone-SparseAzDoProfile.ps1`, the script removes the source `origin` remote after checkout. Add the new Azure DevOps repo as `origin` before pushing:

```powershell
git remote add origin https://dev.azure.com/<org>/<project>/_git/<repo>
git push -u origin main
```

