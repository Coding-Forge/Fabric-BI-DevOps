---
marp: true
theme: default
paginate: true
style: |
  section {
    font-family: "Segoe UI", sans-serif;
    background-color: #ffffff;
    color: #1a1a1a;
  }
  section.lead {
    background-color: #0f5132;
    color: #ffffff;
    text-align: center;
  }
  section.lead h1, section.lead h2 { color: #ffffff; }
  section.lead p { color: #d1e7dd; }
  h2 { color: #0f5132; border-bottom: 3px solid #0f5132; padding-bottom: 0.2em; }
  table { width: 100%; font-size: 0.80em; }
  section th { background-color: #0f5132; color: #ffffff; }
  section td { color: #1a1a1a; background-color: #ffffff; }
  section tr:nth-child(even) td { background-color: #f0f0f0; }
  code { background-color: #f0fff4; color: #1a1a1a; border-radius: 4px; padding: 2px 5px; }
  pre { background-color: #1a1a2e; border-radius: 6px; }
  pre code { background-color: transparent; color: #c9d1d9; font-size: 0.85em; }
---
<!-- class: lead -->

# Lab 2
## CI Pipeline for the Power BI Project

**Duration: 60 minutes**
`13:45 - 14:45`

Validate -> Test -> Publish

---

## Lab 2 Objectives

By the end of this lab you will have:

1. Used the existing pipeline YAML at `projects/azure-pipelines.yml`
2. Verified CI triggers for `main` and `feature/*`
3. Reviewed Validate jobs for PBIP structure and quality rules
4. Reviewed DAX unit test execution and JUnit publishing
5. Verified `pbip-artifacts` publication
6. Configured branch policy to require pipeline success on `main`

---

## Pipeline Stages Overview

| Stage | Purpose |
|---|---|
| **Validate** | PBIP structure check + dataset/report quality rules |
| **Test** | DAX unit tests with JUnit output |
| **Publish** | Publish pipeline artifact `pbip-artifacts` |

---

## Project Files Used in This Lab

| File | Purpose |
|---|---|
| `projects/azure-pipelines.yml` | Azure DevOps pipeline definition |
| `projects/tests/validate_pbip_structure.py` | PBIP structure validation script |
| `projects/tests/run_dax_tests.py` | DAX test runner |
| `projects/scripts/Prepare-QualityRules.ps1` | Branch-aware quality rule preparation |
| `projects/Rules-Dataset.json` | Dataset quality rules |
| `projects/Rules-Report.json` | Report quality rules |

---

## Part 1 - YAML Basics

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

---

## Part 2 - Validate Job: PBIP Structure

```yaml
- script: |
    python tests/validate_pbip_structure.py --pbip-path "$(PBIP_PATH)"
  displayName: 'Run PBIP structure validation'
```

Checks include:
- `.pbip` file presence
- report definition wiring
- semantic model definition and TMDL files

---

## Part 2 - Validate Job: Dataset Rules

```yaml
- job: Build_Datasets
  displayName: 'Run Dataset Quality Rules'
```

What runs:
- Download Tabular Editor
- Prepare effective rules from `Rules-Dataset.json`
- Execute rules against semantic model definitions

---

## Part 2 - Validate Job: Report Rules

```yaml
- job: Build_Reports
  displayName: 'Run Report Quality Rules'
```

What runs:
- Download PBI Inspector CLI
- Prepare effective rules from `Rules-Report.json`
- Execute rules against report definitions

---

## Part 3 - Test Stage

```yaml
- stage: Test
  dependsOn: Validate
```

Core steps:

```yaml
- script: |
    pip install semantic-link-labs

- script: |
    python tests/run_dax_tests.py --model-path "$(PBIP_PATH)"

- task: PublishTestResults@2
```

---

## Part 4 - Publish Stage

```yaml
- stage: Publish
  dependsOn: Test

- task: PublishBuildArtifacts@1
  inputs:
    pathToPublish: '$(Build.SourcesDirectory)/$(PBIP_PATH)'
    artifactName: 'pbip-artifacts'
```

---

## Part 5 - Run in Azure DevOps

1. Pipelines -> New pipeline
2. Select repository
3. Choose Existing YAML
4. Path: `/projects/azure-pipelines.yml`
5. Run

Expected order: Validate -> Test -> Publish

---

## Part 6 - Add Branch Policy

1. Repos -> Branches -> `main` -> Branch policies
2. Add Build validation
3. Select this pipeline
4. Set Required + Automatic

Result: PRs to `main` must pass this pipeline.

---

## Lab 2 Validation Checklist

- [ ] Pipeline uses `projects/azure-pipelines.yml`
- [ ] Validate stage passes all jobs
- [ ] Test stage publishes JUnit results
- [ ] Publish stage generates `pbip-artifacts`
- [ ] Branch policy requires this build on `main`

---
<!-- class: lead -->

# Break

### 14:45 - 15:00

Lab 3 starts at 15:00
