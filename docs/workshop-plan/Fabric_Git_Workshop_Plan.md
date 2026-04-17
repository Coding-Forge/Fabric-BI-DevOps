
---
title: "Fabric + Git Version Control Workshop — Plan & Materials"
description: "Full workshop agenda, labs, branching strategy, CI/CD guidance, deployment patterns, and collaboration practices for Microsoft Fabric + Git version control."
author: Brandon Campbell
version: 1.0
---

# Fabric + Git Version Control Workshop  
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

# 7. Lab #2 — CI Pipeline & Workspace Sync for PBIP

## Objectives
- Build a 4-stage CI/CD pipeline in YAML  
- Validate PBIP schema and lint rules with `pbi-tools`  
- Run DAX unit tests and publish JUnit results  
- Publish `pbip-artifacts` to Azure DevOps  
- Set the pipeline as a required status check on `main`  
- Sync the Fabric Dev workspace using **two approaches**:
  - **Approach A** — Manual sync via the Fabric portal Source control panel  
  - **Approach B** — Automated sync triggered by the pipeline using the Fabric REST API  

## Pipeline Stages Summary

| Stage | Trigger | Purpose |
|---|---|---|
| **Validate** | Every push / PR | `pbi-tools` schema validation + `pbip-lint` |
| **Test** | After Validate | DAX unit tests, JUnit XML output |
| **Publish** | After Test | Upload `pbip-artifacts` to pipeline storage |
| **SyncFabricDev** | `main` merges only | Call Fabric REST API `updateFromGit` to sync Dev workspace |

## Key YAML Pattern

```yaml
trigger:
  branches:
    include:
      - main
      - feature/*

pool:
  vmImage: 'windows-latest'

stages:
  - stage: Validate
    jobs:
      - job: ValidatePBIP
        steps:
          - script: pip install pbi-tools pbip-lint
          - script: pbi-tools validate --input fabric-workspace
          - script: pbip-lint --path fabric-workspace --config .pbiplintrc.json

  - stage: Test
    dependsOn: Validate
    jobs:
      - job: DaxTests
        steps:
          - script: python tests/run_dax_tests.py --model-path fabric-workspace

  - stage: Publish
    dependsOn: Test
    jobs:
      - job: PublishArtifacts
        steps:
          - task: PublishBuildArtifacts@1
            inputs:
              artifactName: pbip-artifacts

  - stage: SyncFabricDev
    dependsOn: Publish
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - job: TriggerFabricSync
        steps:
          - script: python scripts/sync_fabric_workspace.py
```

## Workspace Sync — Approach A (Manual, Portal)

After a PR merges to `main`, a developer opens the Fabric Dev workspace, clicks the **Source control icon**, reviews incoming changes in the side panel, and clicks **Update all**. See [Lab 2](labs/lab2-ci-pipeline.md#approach-a--manual-workspace-git-sync) for the full step-by-step UI walkthrough.

## Workspace Sync — Approach B (Automated, REST API)

The fourth pipeline stage calls `scripts/sync_fabric_workspace.py`, which authenticates as a service principal and posts to the Fabric `updateFromGit` REST API endpoint. The workspace is updated automatically on every merge to `main` without any manual action. Credentials are stored in Azure Key Vault and surfaced via an ADO variable group. See [Lab 2](labs/lab2-ci-pipeline.md#approach-b--pipeline-triggered-sync-fabric-rest-api) for setup details.

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
- Labs 1 and 2 completed — CI pipeline passing on `main`, Dev workspace has validated PBIP content  
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
