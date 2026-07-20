---
title: "Lab 2 - CI/CD Pipeline for the Power BI Project"
description: "Step-by-step lab guide for using the existing Azure DevOps pipeline YAML in azdo/azure-pipelines.yml to validate, test, publish, and deploy PBIP artifacts."
lab: 2
duration: "60 minutes"
---

# Lab 2 - CI/CD Pipeline for the Power BI Project

## Overview

In this lab you will use the existing Azure DevOps pipeline definition at `azdo/azure-pipelines.yml` to validate, test, publish, and deploy the Power BI Project artifacts used in the workshop.

This lab focuses on the **project-local** CI/CD pipeline pattern. If your organization wants one shared CI definition for many Fabric repositories, see the reusable template guidance in [shared/universal-pipeline/README.md](../../../shared/universal-pipeline/README.md). That pattern keeps a small consumer YAML in each repo and centralizes the Validate, Test, and Publish stages in one shared template repo.

The project-local pipeline runs five stages:

- Validate PBIP structure and quality rules
- Run DAX unit tests
- Publish the validated `pbip-drop` artifact
- Deploy `main` and `develop` to the Dev workspace
- Deploy `feature/*` branches to isolated feature workspaces

By the end of the lab, every PR targeting `main` can be gated by this pipeline so only validated PBIP changes are merged, and branch runs can deploy validated content to the correct Fabric workspace.

---

## Objectives

1. Review the existing pipeline YAML at `azdo/azure-pipelines.yml`
2. Understand how the Validate stage runs PBIP and quality-rule checks
3. Understand how the Test stage runs DAX unit tests
4. Verify `pbip-drop` publication in the Publish stage
5. Understand how `scripts/deploy-dynamic.ps1` deploys Dev and feature branch runs
6. Configure branch policy to require a green pipeline on PRs to `main`

---

## Prerequisites

| Requirement | Detail |
|---|---|
| Azure DevOps project | Contributor access to create and run pipelines |
| Repository | This workshop repository with the existing `projects` folder |
| Pipeline YAML | Existing file: `azdo/azure-pipelines.yml` |
| PBIP project artifacts | Place your own PBIP files locally under `shared/pbip-local`; repository includes rules, scripts, tests, and pipeline YAML |
| Agent pool | Microsoft-hosted Windows agent (configured as `windows-2022` in YAML) |
| Service principal | Tenant settings allow the service principal, and it has access to the Dev workspace |
| Pipeline variables | Variable group or pipeline variables for `TenantId`, `AppId`, `ClientSecret`, `DevWorkspaceId` or `DEV_WORKSPACE_NAME`, and `FeatureWorkspacePrefix` for feature deployments |

---

## Part 1 - Review the Existing YAML Pipeline

Open `azdo/azure-pipelines.yml` and confirm the key settings:

```yaml
trigger:
  branches:
    include:
      - main
      - develop
      - feature/*

pr:
  branches:
    include:
      - main
      - develop

pool:
  vmImage: 'windows-2022'

variables:
  - group: pbip-shared-secrets
  - name: PBIP_PATH
    value: '.'
  - name: PYTHON_VERSION
    value: '3.11'
  - name: DEPLOY_SCRIPT_PATH
    value: 'scripts/deploy-dynamic.ps1'
  - name: DEV_WORKSPACE_NAME
    value: 'Git-Essentials'
```

This tells Azure DevOps to run on pushes and PRs, use a Windows 2022 hosted agent, read deployment secrets from `pbip-shared-secrets`, and deploy the published PBIP artifact with `scripts/deploy-dynamic.ps1`.

If you later move to a shared-enterprise model, these same settings become template parameters instead of hardcoded repo-local variables. The included universal example under `shared/universal-pipeline/` shows that pattern.

---

## Part 2 - Validate Stage (Structure + Quality Rules)

The **Validate** stage has three jobs:

1. **ValidatePBIP**
   - Runs `python tests/validate_pbip_structure.py --pbip-path "$(PBIP_PATH)"`
   - Ensures PBIP structure is present and correctly wired

2. **Build_Datasets**
   - Downloads Tabular Editor and fallback dataset rules
   - Uses `scripts/Prepare-QualityRules.ps1` in dataset mode
   - Executes dataset quality rules against semantic model definitions

3. **Build_Reports**
   - Downloads PBI Inspector and fallback report rules
   - Uses `scripts/Prepare-QualityRules.ps1` in report mode
   - Executes report quality rules against report definitions

### Why this matters

This catches structural, semantic model, and report-quality issues before changes are merged.

---

## Part 3 - Test Stage (DAX Unit Tests)

The **Test** stage runs after Validate succeeds:

- Installs `semantic-link-labs`
- Runs `python tests/run_dax_tests.py --model-path "$(PBIP_PATH)"`
- Publishes JUnit test output using `PublishTestResults@2`

This ensures DAX checks are visible in Azure DevOps test reporting.

---

## Part 4 - Publish Stage (Pipeline Artifact)

The **Publish** stage runs only if Validate and Test succeed.

It publishes repository content as the `pbip-drop` pipeline artifact:

```yaml
- task: PublishPipelineArtifact@1
  inputs:
    targetPath: '$(Build.SourcesDirectory)/$(PBIP_PATH)'
    artifact: 'pbip-drop'
    publishLocation: 'pipeline'
```

Use this artifact for traceability and for the downstream deployment stages.

---

## Part 5 - Deployment Stages

The deployment stages download `pbip-drop` and run `scripts/deploy-dynamic.ps1`.

| Stage | Branch condition | Target |
|---|---|---|
| **Deploy_Dev** | `main` or `develop` | Existing Dev workspace, resolved by `DEV_WORKSPACE_NAME` or `DevWorkspaceId` |
| **Deploy_Feature** | `feature/*` | Existing or newly created workspace named from `FeatureWorkspacePrefix` plus the safe branch name |

The script authenticates to the Fabric REST API with `TenantId`, `AppId`, and `ClientSecret`, finds PBIP report and semantic model folders from the `.pbip` file, deploys semantic models first, and then updates report definitions to point at the deployed semantic model ID.

Before running the pipeline, confirm the service principal is allowed by Fabric tenant settings and added to the Dev workspace. Feature workspace creation also requires the service principal to have permission to create workspaces.

---

## Part 6 - Create and Run the Pipeline in Azure DevOps

1. Go to **Pipelines -> New pipeline**.
2. Choose your Git provider and repository.
3. Select **Existing Azure Pipelines YAML file**.
4. Set YAML path to `/azdo/azure-pipelines.yml`.
5. Run the pipeline.

### Verify the run

1. Confirm stages run in order: **Validate -> Test -> Publish**, followed by the branch-appropriate deploy stage.
2. Confirm all stages are green.
3. Open the **Tests** tab to verify JUnit results were published.
4. Open the **Artifacts** tab and confirm `pbip-drop` exists.
5. Open the deployment logs and confirm `Fabric PBIP deployment completed.` appears.

---

## Part 7 - Set Required Branch Policy on `main`

1. Go to **Repos -> Branches**.
2. Open branch policies for `main`.
3. Add **Build validation** for this pipeline.
4. Set policy to **Required** and trigger to **Automatic**.
5. Save.

After this, PRs into `main` must pass the pipeline before merge.

---

## Part 8 - Validate with a Feature Branch PR

1. Create or use a feature branch with a small PBIP change.
2. Push branch and open PR to `main`.
3. Confirm pipeline runs automatically on the PR.
4. Confirm the feature branch push creates or updates the expected feature workspace.
5. Resolve any pipeline failures.
6. Merge once all required checks pass.

---

## Validation Checklist

- [ ] `azdo/azure-pipelines.yml` is used by the Azure DevOps pipeline
- [ ] Validate stage runs PBIP structure and dataset/report quality jobs
- [ ] Test stage runs `tests/run_dax_tests.py` and publishes JUnit results
- [ ] Publish stage outputs the `pbip-drop` artifact
- [ ] `Deploy_Dev` succeeds for `main` or `develop`, or `Deploy_Feature` succeeds for `feature/*`
- [ ] Deployment logs show `scripts/deploy-dynamic.ps1` completed successfully
- [ ] Pipeline is configured as a required PR check on `main`
- [ ] A PR to `main` passes the pipeline end-to-end

---

## Troubleshooting

| Issue | Resolution |
|---|---|
| `No .pbip file found` | Ensure your local PBIP project files are present under `shared/pbip-local`. |
| Dataset/report quality job fails | Review logs for failing rule IDs. Adjust project content or update rules files as needed. |
| DAX test stage fails | Check `tests/run_dax_tests.py` output and verify semantic model files exist. |
| Test results not shown | Confirm JUnit XML files are created under `test-results` before `PublishTestResults@2` runs. |
| Missing deployment variable | Define `TenantId`, `AppId`, and `ClientSecret` in the pipeline UI or linked variable group. Add `DevWorkspaceId` or set `DEV_WORKSPACE_NAME` for Dev deployments. |
| Feature deployment fails | Set `FeatureWorkspacePrefix` and confirm the service principal can create or access Fabric workspaces. |
| Deployment script not found | Confirm `DEPLOY_SCRIPT_PATH` points to `scripts/deploy-dynamic.ps1` and that the script is included in the published artifact. |
| Branch policy does not block PR | Confirm build validation is marked Required and linked to the correct pipeline definition. |

---

## Next Steps

Proceed to **[Lab 3 - Fabric Deployment Pipelines (Dev -> Test -> Prod)](lab3-deployment-pipelines.md)**.

For a multi-repo operating model, review [shared/universal-pipeline/README.md](../../../shared/universal-pipeline/README.md) after completing this lab.


