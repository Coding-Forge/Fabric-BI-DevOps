
---
title: "Enterprise BI DevOps with Microsoft Fabric Workshop — Plan & Materials"
description: "Full workshop agenda, labs, branching strategy, CI/CD guidance, deployment patterns, and collaboration practices for Microsoft Fabric + Git version control."
author: Brandon Campbell
version: 1.0
---

# Enterprise BI DevOps with Microsoft Fabric Workshop  
Comprehensive Workshop Plan & Supporting Material

## Overview
This workshop provides a full-day (adaptable to half-day) hands‑on experience for adopting **Git‑based lifecycle management** for Microsoft Fabric and Power BI Projects (PBIP).  
Participants will learn workspace–repo integration, branching strategies, PR workflows, CI pipelines, governance, and deployment best practices.

---

# 1. Agenda

| Time        | Topic                                                                 |
|-------------|------------------------------------------------------------------------|
| 09:00–09:20 | Kickoff, objectives, prerequisites check                               |
| 09:20–10:15 | Version control in Fabric & PBIP; Git with Azure DevOps/GitHub         |
| 10:15–10:30 | Break                                                                  |
| 10:30–11:30 | **Lab #1:** Connect Workspace → Git; branch & PR workflow              |
| 11:30–12:15 | Collaboration patterns & governance best practices                     |
| 12:15–13:00 | Lunch                                                                  |
| 13:00–13:45 | Deployment Strategy: Dev → Test → Prod; CI/CD with Azure DevOps        |
| 13:45–14:45 | **Lab #2:** CI pipeline for PBIP, workspace Git sync (manual & automated) |
| 14:45–15:00 | Break                                                                  |
| 15:00–16:00 | **Lab #3:** Fabric Deployment Pipelines — bind workspaces, configure deployment rules, promote Dev → Test → Prod |
| 16:00–16:30 | Publishing artifacts & release checklist                               |
| 16:30–17:00 | Webapp team POC: Power BI Embedded + communications plan           |

---

# 2. Participant Prerequisites

- Access to a **Fabric capacity-backed workspace** (Contributor or higher)  
- Latest **Power BI Desktop** installed  
- **VS Code** with Git extensions  
- Access to **Azure DevOps or GitHub** repo with permissions to create branches & PRs  
- Fabric **Git integration admin toggles enabled**  
- PAT or **service principal** credentials (if org CA policies block OAuth)  
- Local copy of sample dataset & PBIP starter project  

---

# 3. Version Control & Git Integration Concepts

## Power BI Projects (PBIP)
The PBIP format stores reports + semantic models as text‑based artifacts (JSON, YAML, TMDL).  
Enables:
- Source control  
- Code reviews  
- Branching strategies  
- CI automation  

## Recommended Branching Strategy

### Core principles
- **Trunk‑based development** — `main` is always deployable  
- Short‑lived feature branches (`feature/<alias>-<task>`) — target < 5 days  
- Protected `main` branch — no direct commits; PRs required  
- Mandatory PRs with reviewer requirements  
- Status checks: schema validation, DAX tests, linting  
- Tag releases as: `vYYYY.MM.DD`  

### Branch-Out Strategy — Feature Workspaces

Fabric's Git integration enables a powerful pattern that goes beyond standard branching: each feature branch is paired with a **dedicated personal or scoped Fabric workspace**. Developers do not work in the shared Dev workspace — they branch out.

| Workspace | Branch | Purpose |
|---|---|---|
| `WS-Dev-<team>` | `main` | Shared; always reflects latest reviewed state |
| `WS-Dev-<alias>` | `feature/<alias>-*` | Personal; fully isolated development |
| `WS-Dev-<team>-<feature>` | `feature/<team>-*` | Scoped; multi-developer feature collaboration |

**Why it matters:**
- In-progress and experimental changes never appear in the shared workspace  
- Reviewers can connect to a PR's feature workspace to preview live rendered reports before approving  
- Multiple developers work in parallel with zero coordination overhead  
- Safe experimentation — delete the branch and workspace to undo everything  
- Mirrors modern software engineering "review app" / "preview environment" patterns applied to BI  

See the [Branching Strategy architecture doc](../../docs/architecture/branching-strategy.md) for the full workflow, topology diagrams, and anti-patterns.

---

# 4. Lab #1 — Connect Workspace to Git

## Objectives
1. Connect Fabric workspace to an Azure DevOps or GitHub repo  
2. Initialize synchronization  
3. Create feature branches  
4. Make changes in PBIP  
5. Submit and merge PR  

## Step‑by‑Step

1. Open **Workspace → Settings → Git Integration**  
2. Select Git provider  
3. Choose Org / Project / Repo / Branch  
4. Define folder path for PBIP storage  
5. Sync from Git → Fabric items appear with Git status indicators  
6. Create feature branch  
7. Make a small report or model change  
8. Commit & push  
9. Open PR → request reviewers → merge  

---

# 5. Collaboration Best Practices

## Workspace strategy
- Separate **Dev / Test / Prod** workspaces  
- Clear permission model (Admin, Member, Contributor, Viewer)  

## Naming standards
Example:
## RLS/CLS governance
- Implement patterns consistently across environments  
- Validate role bindings before promoting to Test or Prod  

## RACI Example

| Activity          | Responsible | Accountable | Consulted     | Informed      |
|------------------|-------------|-------------|----------------|---------------|
| Model changes     | Data Eng    | BI Lead     | Security, DBA | Stakeholders  |
| Report pages      | BI Dev      | BI Lead     | UX, SMEs      | Stakeholders  |
| CI/CD pipeline    | DevOps      | BI Lead     | CSA, IT       | Team          |
| Workspace perms   | Admin       | IT Sec      | CSA           | Team          |

---

# 6. Deployment Strategy (Dev → Test → Prod)

## Key principles
- Use **Fabric Deployment Pipelines**  
- Bind each stage to a separate workspace  
- Parameterize connections (Power Query, Dataflows)  
- Store secrets in **Azure Key Vault**  
- Automate validations (schema diff, DAX tests, linting)  
- Require approvals for promotions  

## What to validate before promotion
- Dataset refresh succeeds  
- RLS role integrity  
- No unapproved schema drift  
- Accessibility checks  
- Visual consistency tests (theme, layout)  

---

# 7. Lab #2 — CI Pipeline Validation for the Power BI Project

## Objectives
- Use the existing YAML pipeline at `azdo/azure-pipelines.yml`  
- Validate PBIP structure and run dataset/report quality rules  
- Run DAX unit tests and publish JUnit results  
- Publish `pbip-drop` to Azure DevOps  
- Deploy validated PBIP content to Dev or feature workspaces using `scripts/deploy-dynamic.ps1`  
- Set the pipeline as a required status check on `main`  

This lab uses the workshop's self-contained PBIP pipeline. For enterprise rollout across many Fabric repos, the same Validate/Test/Publish pattern can be centralized as a shared template repo with thin consumer YAML files per project.

## Pipeline Stages Summary

| Stage | Trigger | Purpose |
|---|---|---|
| **Validate** | Every push / PR | PBIP structure validation + dataset/report quality rules |
| **Test** | After Validate | DAX unit tests, JUnit XML output |
| **Publish** | After Test | Upload `pbip-drop` to pipeline storage |
| **Deploy_Dev** | After Publish on `main` or `develop` | Deploy the artifact to the Dev workspace |
| **Deploy_Feature** | After Publish on `feature/*` | Create or update an isolated feature workspace |

## Key YAML Pattern

```yaml
trigger:
  branches:
    include:
      - main
      - develop
      - feature/*

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

stages:
  - stage: Validate
    jobs:
      - job: ValidatePBIP
        steps:
          - script: python tests/validate_pbip_structure.py --pbip-path "$(PBIP_PATH)"
      - job: Build_Datasets
      - job: Build_Reports

  - stage: Test
    dependsOn: Validate
    jobs:
      - job: DaxTests
        steps:
          - script: python tests/run_dax_tests.py --model-path "$(PBIP_PATH)"

  - stage: Publish
    dependsOn: Test
    jobs:
      - job: PublishArtifacts
        steps:
          - task: PublishPipelineArtifact@1
            inputs:
              targetPath: '$(Build.SourcesDirectory)/$(PBIP_PATH)'
              artifact: pbip-drop

  - stage: Deploy_Dev
    dependsOn: Publish
    condition: main or develop branch

  - stage: Deploy_Feature
    dependsOn: Publish
    condition: feature branch
```

See [Lab 2](labs/lab2-ci-pipeline.md) for the full hands-on walkthrough using the current project files under `projects`.

For the reusable multi-repo variant, see [shared/universal-pipeline/README.md](../../shared/universal-pipeline/README.md).

---

# 8. Lab #3 — Fabric Deployment Pipelines (Dev → Test → Prod)

## Objectives
- Create a three-stage Fabric Deployment Pipeline in the Fabric portal  
- Bind `WS-Dev`, `WS-Test`, and `WS-Prod` workspaces to their respective stages  
- Configure **deployment rules** to swap data source parameters (server, database) per environment  
- Review the **comparison diff** between stages before promoting  
- Promote content **Dev → Test** and validate via UAT checklist  
- Gate **Test → Prod** with a manual approval  
- Verify Prod workspace content and confirm semantic model refresh  

## Prerequisites
- Labs 1 and 2 completed — CI/CD pipeline passing on `main`, Dev workspace has validated PBIP content  
- Three Fabric capacity-backed workspaces: `WS-Dev-<team>`, `WS-Test-<team>`, `WS-Prod-<team>`  
- **Admin** role on all three workspaces  
- Fabric Admin toggle enabled: **Users can create and use deployment pipelines**  
- Sample semantic model uses Power Query parameters for server and database name  

## Key Concepts

| Concept | Description |
|---|---|
| **Stage** | Development, Test, or Production — each bound to exactly one workspace |
| **Deployment rules** | Per-stage overrides applied at promotion time (e.g., swap connection strings) |
| **Comparison view** | Shows items that differ between adjacent stages before promoting |
| **Selective deployment** | Promotes a subset of items rather than the full workspace |

See [Lab 3](labs/lab3-deployment-pipelines.md) for the full step-by-step walkthrough.


