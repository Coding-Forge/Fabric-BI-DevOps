
# Fabric + Git Essentials Workshop

> **Version:** 1.1 &nbsp;|&nbsp; **Author:** Brandon Campbell &nbsp;|&nbsp; **Updated:** April 2026

A hands-on workshop covering Git integration, CI/CD automation, and deployment best practices for **Microsoft Fabric** and **Power BI** (PBIP format).

This README provides a **topic-by-topic index** of supporting resources, architecture docs, lab guides, and reference materials used throughout the workshop.

> PBIP artifacts are intentionally **not committed** in this repository. Bring your own PBIP files locally under `projects/` (or `projects/pbip-local/`) and keep reusable CI assets (`Rules-*.json`, `scripts/`, `tests/`, `azure-pipelines.yml`) in source control.
>
> This repo now also includes a reusable **universal Fabric CI pipeline** under `projects/universal-pipeline/`. The intent is to host one shared template repo for Fabric artifact validation/deployment, while each project repo keeps only a small consumer `azure-pipelines.yml`.

---

## Quick Navigation

| Section | Description |
|---------|-------------|
| [1. Workshop Topics Table](#1-workshop-topics--supporting-documents-table) | Agenda-mapped resource overview |
| [2. Detailed Breakdowns](#2-detailed-topicby-topic-resource-breakdown) | Per-topic doc references |
| [3. Best Practices Summary](#3-best-practices-summary) | Governance, Git, CI/CD, Embedded |
| [4. Folder Structure](#4-appendix-repository-folder-structure) | Actual repo layout |

### CI Pipeline Options
- Use [projects/azure-pipelines.yml](/home/brandon/projects/workshops/Fabric-Git-Essentials/projects/azure-pipelines.yml) for the workshop's PBIP-specific CI walkthrough.
- Use [projects/universal-pipeline/README.md](projects/universal-pipeline/README.md) when you want one shared Azure DevOps template repo that can be consumed by many Fabric project repos.

### Presentation Decks (Marp)
- [01 — Kickoff & Overview](presentations/01-kickoff-overview.md)
- [02 — Version Control in Fabric & PBIP](presentations/02-version-control-pbip.md)
- [03 — Lab 1: Connect Workspace to Git](presentations/03-lab1-connect-git.md)
- [04 — Collaboration & Governance](presentations/04-collaboration-governance.md)
- [05 — Deployment Strategy](presentations/05-deployment-strategy.md)
- [06 — Lab 2: CI Pipeline for PBIP](presentations/06-lab2-ci-pipeline.md)
- [06a — Lab 2 Facilitator Briefing (One Slide)](presentations/06a-lab2-facilitator-briefing.md)
- [07 — Lab 3: Fabric Deployment Pipelines](presentations/07-lab3-deployment-pipelines.md)
- [08 — Release Checklist & Power BI Embedded](presentations/08-release-embedded.md)

> Render with the [Marp for VS Code](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode) extension, or export to PDF/HTML via `npx @marp-team/marp-cli`.

### PowerPoint Exports
Pre-generated `.pptx` files are in the `powerpoint/` folder — one per deck, with the same filename stem.
These are generated from the Marp source using `python-pptx` and can be opened directly in PowerPoint or Google Slides.

- [06a Facilitator Briefing (PPTX)](powerpoint/06a-lab2-facilitator-briefing.pptx)
- [06a Facilitator Briefing (PDF)](powerpoint/06a-lab2-facilitator-briefing.pdf)

### Architecture Docs
- [Fabric + Git Integration](docs/architecture/fabric-git-integration.md) — diagrams for the full integration, PBIP workflow, CI pipeline, deployment pipeline, end-to-end DevOps, and Power BI Embedded
- [Branching Strategy](docs/architecture/branching-strategy.md)
- [CI/CD Architecture](docs/architecture/cicd-architecture.md)
- [Workspace Strategy](docs/architecture/workspace-strategy.md)

### Labs
- [Lab 1 — Connect Workspace to Git](docs/workshop-plan/labs/lab1-connect-git.md)
- [Lab 2 — CI Pipeline Validation for the Power BI Project](docs/workshop-plan/labs/lab2-ci-pipeline.md)
- [Lab 3 — Deployment Pipelines](docs/workshop-plan/labs/lab3-deployment-pipelines.md)

### Governance
- [Governance Checklist](docs/governance/governance-checklist.md)

---

# 1. Workshop Topics & Supporting Documents Table

| Agenda Topic & Time | Key Supporting Documents / Resources |
|---------------------|---------------------------------------|
| **Kickoff, Objectives, Roles, Prerequisites**<br>(09:00–09:20) | Workshop Overview (agenda, objectives); Governance deck; Connect Fabric Workspaces to ADO prereqs |
| **Version Control in Fabric & PBIP**<br>(09:20–10:15) | Git integration overview; PBIP basics; Branching & workspace separation guides |
| **Lab #1 — Connect Workspace to Git**<br>(10:30–11:30) | Lab Guide for Git connection; Branded slides; CI/CD architecture diagrams |
| **Collaboration Patterns & Best Practices**<br>(11:30–12:15) | DataOps deck; Governance essentials; RACI examples; Go‑Live assessment |
| **Deployment Strategy: Dev→Test→Prod**<br>(13:00–13:45) | CI/CD Delivery Guide; Enterprise‑scale Power BI Dev examples; Deployment pipeline docs |
| **Lab #2 — CI Pipeline Validation for the Power BI Project**<br>(13:45–14:45) | CI lab guide (YAML examples, PBIP validation); ADO test integration; MS Learn pipeline tutorials |
| **Lab #3 — Fabric Deployment Pipelines**<br>(15:00–16:00) | [Lab 3 guide](docs/workshop-plan/labs/lab3-deployment-pipelines.md); Architecture diagrams; Governance checklist; Deployment rules & promotion guidance |
| **Publishing Artifacts & Release Checklist**<br>(16:00–16:30) | Release checklist; Prod readiness; RLS/CLS validation; Sensitivity labels guidance |
| **Power BI Embedded POC + Communication Plan**<br>(16:30–17:00) | Embedded analytics deck; Service principal setup guide; Comms plan templates |

---

# 2. Detailed Topic‑by‑Topic Resource Breakdown

## 2.1 Kickoff, Objectives, Roles & Prerequisites
Supporting resources:
- **Workshop Overview Doc**  
  Includes agenda, workshop objectives, and success criteria.
- **Fabric Governance Workshop Deck**  
  Provides RBAC roles (Admin, Member, Contributor, Viewer) and tenant-level governance.
- **Connect Fabric Workspaces to Azure DevOps Guide**  
  Contains full prerequisite checklist:
  - Fabric workspace access  
  - Repo access  
  - PAT or service principal  
  - Admin toggle validation  

Use these materials to ensure all participants are technically ready before entering Lab 1.

---

## 2.2 Version Control in Fabric & PBIP; Git with ADO/GitHub

Key references:
- **PBIP Format Overview**  
  Explains the structure of `.pbip` (TMDL, JSON, YAML).
- **Git Integration in Fabric (Admin + UX)**  
  Covers enabling Git integration and setting repo/branch mappings.
- **Branching Strategy Guidance**  
  Concepts:
  - Trunk‑based dev  
  - Short-lived feature branches  
  - Workspace branching (“branch → new workspace”)  
  - Avoid editing directly in shared workspaces  
- **Microsoft Learn — Git Integration**  
  Baseline fundamentals for participants who are new to Git in Fabric.

These resources help attendees understand *why* Git matters and *how* Fabric synchronizes workspace items.

---

## 2.3 Lab #1 — Connect a Fabric Workspace to Git

Documents:
- **Lab #1 Guide — Connect Fabric Workspace to Azure DevOps**  
  Walks through:
  - Selecting Git provider  
  - Mapping workspace → repo → branch  
  - Initial sync  
  - Verifying Git icons  
  - Creating feature branches  
  - Submitting a PR
- **Branded Slide Pack**  
  Step‑by‑step visuals: Git setup, PR demo.
- **Architecture diagrams** for Git integration & PR flow

Validation checklist (end of lab):
- Workspace shows Git‑connected status  
- No pending changes  
- PR merged → synced back to Fabric  

---

## 2.4 Collaboration Patterns & Best Practices

Foundational references:
- **Power BI DataOps Deck**  
  Themes:
  - Dev/Test/Prod separation  
  - Pipelines  
  - Approval gates  
  - Change review patterns
- **Governance Essentials — Workspace & Role Governance**  
  Includes:
  - RACI matrix  
  - Naming conventions  
  - Workspace lifecycle guidance
- **Fabric Go‑Live Assessment Guide**  
  Production governance readiness:
  - RLS/CLS validation  
  - Endorsements  
  - Monitoring & auditing
- **Workshop Plan — Best Practices Section**  
  Reinforces:
  - Branching standards  
  - PR templates  
  - RLS consistency  
  - Review gates  

---

## 2.5 Deployment Strategy: Dev → Test → Prod

Materials:
- **CI/CD Delivery Guide**  
  Provides the end‑to‑end CI/CD model for PBIP-based development.
- **Knowledge Transfer (Enterprise-Scale Dev) PDF**  
  Contains:
  - Real YAML examples  
  - REST API automation  
  - Deployment pipeline synchronization  
- **Microsoft Learn — Deployment Pipelines**  
  Covers:
  - Stages  
  - Workspace binding  
  - Selective deployment  
  - Automation via APIs

Key messages:
- Every merge to main triggers validations  
- Environment-specific configs (via parameters, Key Vault)  
- No manual promotion to production  

---

## 2.6 Lab #2 — CI Pipeline for PBIP & Automated Validations

Primary references:
- **Lab #2 Guide — CI for PBIP**  
  Includes YAML patterns for:
  - PBIP schema validation  
  - DAX unit tests  
  - Lint rules  
  - Publishing artifacts
- **AzureDevOps Deep Dive**  
  Shows integration with dashboards and test plans.
- **Microsoft Learn — CI/CD Tutorial**  
  Mirrors the steps of building a working PBIP validation pipeline.

Lab #2 Outcomes:
- Working CI pipeline  
- PR branch policies enforced  
- PBIP validation occurs automatically  

---

## 2.7 Lab #3 — Fabric Deployment Pipelines: Dev → Test → Prod

Primary references:
- **[Lab #3 Guide — Fabric Deployment Pipelines](docs/workshop-plan/labs/lab3-deployment-pipelines.md)**  
  Covers:
  - Creating a three-stage deployment pipeline in the Fabric portal  
  - Binding `WS-Dev`, `WS-Test`, and `WS-Prod` workspaces to their stages  
  - Configuring **deployment rules** to swap data source parameters per environment  
  - Reviewing the **comparison diff** before promoting content  
  - Promoting **Dev → Test** and verifying the deployment log  
  - Completing the UAT checklist (RLS testing, refresh validation, rule verification)  
  - Gating **Test → Prod** with a manual approval step  
  - Verifying Prod content and confirming semantic model refresh against the Prod database
- **Architecture Diagrams — [Deployment Pipeline Flow](docs/architecture/fabric-git-integration.md)**  
  Visual reference for the three-stage promotion model.
- **[Governance Checklist](docs/governance/governance-checklist.md)**  
  UAT gates and compliance checks required before Prod promotion.
- **Microsoft Learn — Fabric Deployment Pipelines**  
  Official docs for stage binding, selective deployment, and REST API automation.

Lab #3 Outcomes:
- Three-stage Fabric Deployment Pipeline configured and bound to workspaces  
- Deployment rules in place to swap data source connections per environment  
- Dev workspace content successfully promoted to Test  
- UAT checklist completed; Test → Prod promotion gated and executed  
- Prod workspace verified with a passing semantic model refresh  

---

## 2.8 Publishing Artifacts & Release Checklist

Supporting documents:
- **Workshop Overview — Release Checklist**  
  Items include:
  - CI green  
  - Schema diff validated  
  - Dev → Test promotion  
  - RLS check  
  - App publishing
- **Production Deployment Oversight — Security & Compliance**  
  Covers:
  - Gateways  
  - Conditional Access  
  - Security principals  
  - Logging & audit
- **Fabric Warehouse Governance Guide**  
  Provides:
  - Endorsement rules  
  - Sensitivity labels  
  - OLS/RLS governance

Checklist also applies to:
- Notebooks  
- Dataflows  
- Pipelines  

---

## 2.9 Webapp Team POC — Power BI Embedded & Comms Plan

Supporting documents:
- **Embedded Analytics Deck**  
  Explains:
  - Embed for your org vs. Embed for your customers  
  - Service principal authentication  
  - Token issuance flow
- **Demo Instructions — Service Principal Setup**  
  Steps:
  - Azure AD App Registration  
  - Assign API permissions  
  - Enable SP in Power BI Admin Portal  
  - Acquire tokens via backend  
- **QualityHub Requirements Document**  
  Rules for embedded experiences:
  - Performance SLAs  
  - Approved visuals  
  - Security controls  
- **Communications Plan Template**  
  Guidance:
  - Teams channel structure  
  - Weekly touchpoints  
  - Decision log  
  - PR review workflow  

---

# 3. Best Practices Summary

### Governance
- Enforce workspace separation  
- Require PR-based development  
- Centralize RLS/CLS rules  
- Standardize naming conventions  

### Git Integration
- Keep branches small  
- Protect `main`  
- Use Workspace → Git sync workflows  

### CI/CD
- Automate schema validation  
- Treat PBIP artifacts as code  
- Use Key Vault for secrets  

### Embedded Analytics
- Prefer **App Owns Data** for external apps  
- Use service principals exclusively  
- Validate RLS interactions with embedding  

---

# 4. Appendix: Repository Folder Structure

```text
/
├── README.md
├── Supporting_Docs_For_Workshop.md
├── FabricGitIntegration.html
├── presentations/
│   ├── 01-kickoff-overview.md
│   ├── 02-version-control-pbip.md
│   ├── 03-lab1-connect-git.md
│   ├── 04-collaboration-governance.md
│   ├── 05-deployment-strategy.md
│   ├── 06-lab2-ci-pipeline.md
│   ├── 07-lab3-deployment-pipelines.md
│   └── 08-release-embedded.md
├── powerpoint/
│   ├── 01-kickoff-overview.pptx
│   ├── 02-version-control-pbip.pptx
│   ├── 03-lab1-connect-git.pptx
│   ├── 04-collaboration-governance.pptx
│   ├── 05-deployment-strategy.pptx
│   ├── 06-lab2-ci-pipeline.pptx
│   ├── 07-lab3-deployment-pipelines.pptx
│   └── 08-release-embedded.pptx
└── docs/
    ├── index.md
    ├── architecture/
    │   ├── fabric-git-integration.md   ← all architecture diagrams
    │   ├── branching-strategy.md
    │   ├── cicd-architecture.md
    │   ├── workspace-strategy.md
    │   └── images/
    │       └── fabgitplantuml.puml
    ├── governance/
    │   └── governance-checklist.md
    └── workshop-plan/
        ├── Fabric_Git_Workshop_Plan.md
        └── labs/
            ├── lab1-connect-git.md
            ├── lab2-ci-pipeline.md
            └── lab3-deployment-pipelines.md
