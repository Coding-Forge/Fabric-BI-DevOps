
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
| 13:45–14:45 | **Lab #2:** Build CI pipeline for PBIP & automated validations         |
| 14:45–15:00 | Break                                                                  |
| 15:00–16:00 | Solving session: design 2–3 dashboard pages & semantic model changes   |
| 16:00–16:30 | Publishing artifacts & release checklist                               |
| 16:30–17:00 | SDA webapp team POC: Power BI Embedded + communications plan           |

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

## Recommended branching strategy
- **Trunk‑based development**  
- Short‑lived feature branches (`feature/*`)  
- Protected `main` branch  
- Mandatory PRs with reviewer requirements  
- Status checks: schema validation, DAX tests, linting  
- Tag releases as: `vYYYY.MM.DD`  

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

# 7. Lab #2 — Azure DevOps CI Pipeline for PBIP

## Objectives
- Build CI pipeline in YAML  
- Validate PBIP metadata  
- Run automated tests  
- Publish artifacts  

## Example YAML components

```yaml
trigger:
  branches:
    include:
      - main
      - feature/*

pool:
  vmImage: 'windows-latest'

steps:
  - task: UsePythonVersion@0
    inputs:
      versionSpec: '3.x'

  - script: pip install pbi-tools
    displayName: "Install pbi-tools"

  - script: pbi-tools validate --input ./pbip
    displayName: "Validate PBIP"

  - task: PublishBuildArtifacts@1
    inputs:
      pathToPublish: "$(Build.SourcesDirectory)"
      artifactName: "pbip-artifacts"
```
