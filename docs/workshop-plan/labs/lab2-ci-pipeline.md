---
title: "Lab 2 - CI Pipeline Validation for the Power BI Project"
description: "Step-by-step lab guide for using the existing Azure DevOps pipeline YAML in projects/azure-pipelines.yml to validate and test PBIP artifacts."
lab: 2
duration: "60 minutes"
---

# Lab 2 - CI Pipeline Validation for the Power BI Project

## Overview

In this lab you will use the existing Azure DevOps pipeline definition at `projects/azure-pipelines.yml` to validate and test the Power BI Project artifacts used in the workshop.

This lab focuses on the **project-local** pipeline pattern. If your organization wants one shared CI definition for many Fabric repositories, see the reusable template guidance in [projects/universal-pipeline/README.md](../../../projects/universal-pipeline/README.md). That pattern keeps a small consumer YAML in each repo and centralizes the Validate, Test, and Publish stages in one shared template repo.

The pipeline runs three stages:

- Validate PBIP structure and quality rules
- Run DAX unit tests
- Publish validated artifacts

By the end of the lab, every PR targeting `main` can be gated by this pipeline so only validated PBIP changes are merged.

---

## Objectives

1. Review the existing pipeline YAML at `projects/azure-pipelines.yml`
2. Understand how the Validate stage runs PBIP and quality-rule checks
3. Understand how the Test stage runs DAX unit tests
4. Verify artifact publication in the Publish stage
5. Configure branch policy to require a green pipeline on PRs to `main`

---

## Prerequisites

| Requirement | Detail |
|---|---|
| Azure DevOps project | Contributor access to create and run pipelines |
| Repository | This workshop repository with the existing `projects` folder |
| Pipeline YAML | Existing file: `projects/azure-pipelines.yml` |
| PBIP project artifacts | Place your own PBIP files locally under `projects/pbip-local`; repository includes rules, scripts, tests, and pipeline YAML |
| Agent pool | Microsoft-hosted Windows agent (configured as `windows-2022` in YAML) |

---

## Part 1 - Review the Existing YAML Pipeline

Open `projects/azure-pipelines.yml` and confirm the key settings:

```yaml
trigger:
  branches:
    include:
      - main
      - feature/*

pr:
  branches:
    include:
      - main

pool:
  vmImage: 'windows-2022'

variables:
  PROJECT_ROOT: '.'
  PBIP_PATH: 'pbip-local'
  PYTHON_VERSION: '3.11'
```

This tells Azure DevOps to run on both pushes and PRs, then execute the pipeline on a Windows 2022 hosted agent.

If you later move to a shared-enterprise model, these same settings become template parameters instead of hardcoded repo-local variables. The included universal example under `projects/universal-pipeline/` shows that pattern.

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

## Part 4 - Publish Stage (Build Artifacts)

The **Publish** stage runs only if Validate and Test succeed.

It publishes repository content as the `pbip-artifacts` build artifact:

```yaml
- task: PublishBuildArtifacts@1
  inputs:
    pathToPublish: '$(Build.SourcesDirectory)/$(PBIP_PATH)'
    artifactName: 'pbip-artifacts'
    publishLocation: 'Container'
```

Use this artifact for traceability and downstream release workflows.

---

## Part 5 - Create and Run the Pipeline in Azure DevOps

1. Go to **Pipelines -> New pipeline**.
2. Choose your Git provider and repository.
3. Select **Existing Azure Pipelines YAML file**.
4. Set YAML path to `/projects/azure-pipelines.yml`.
5. Run the pipeline.

### Verify the run

1. Confirm stages run in order: **Validate -> Test -> Publish**.
2. Confirm all stages are green.
3. Open the **Tests** tab to verify JUnit results were published.
4. Open the **Artifacts** tab and confirm `pbip-artifacts` exists.

---

## Part 6 - Set Required Branch Policy on `main`

1. Go to **Repos -> Branches**.
2. Open branch policies for `main`.
3. Add **Build validation** for this pipeline.
4. Set policy to **Required** and trigger to **Automatic**.
5. Save.

After this, PRs into `main` must pass the pipeline before merge.

---

## Part 7 - Validate with a Feature Branch PR

1. Create or use a feature branch with a small PBIP change.
2. Push branch and open PR to `main`.
3. Confirm pipeline runs automatically on the PR.
4. Resolve any pipeline failures.
5. Merge once all required checks pass.

---

## Validation Checklist

- [ ] `projects/azure-pipelines.yml` is used by the Azure DevOps pipeline
- [ ] Validate stage runs PBIP structure and dataset/report quality jobs
- [ ] Test stage runs `tests/run_dax_tests.py` and publishes JUnit results
- [ ] Publish stage outputs the `pbip-artifacts` artifact
- [ ] Pipeline is configured as a required PR check on `main`
- [ ] A PR to `main` passes the pipeline end-to-end

---

## Troubleshooting

| Issue | Resolution |
|---|---|
| `No .pbip file found` | Ensure your local PBIP project files are present under `projects/pbip-local`. |
| Dataset/report quality job fails | Review logs for failing rule IDs. Adjust project content or update rules files as needed. |
| DAX test stage fails | Check `tests/run_dax_tests.py` output and verify semantic model files exist. |
| Test results not shown | Confirm JUnit XML files are created under `test-results` before `PublishTestResults@2` runs. |
| Branch policy does not block PR | Confirm build validation is marked Required and linked to the correct pipeline definition. |

---

## Next Steps

Proceed to **[Lab 3 - Fabric Deployment Pipelines (Dev -> Test -> Prod)](lab3-deployment-pipelines.md)**.

For a multi-repo operating model, review [projects/universal-pipeline/README.md](../../../projects/universal-pipeline/README.md) after completing this lab.
