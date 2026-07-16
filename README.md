
# Enterprise BI DevOps for Microsoft Fabric

> **Version:** 1.1 &nbsp;|&nbsp; **Author:** Brandon Campbell &nbsp;|&nbsp; **Updated:** June 2026

A hands-on workshop covering Git integration, CI/CD automation, and deployment best practices for **Microsoft Fabric** and **Power BI** (PBIP format).

This README provides a **topic-by-topic index** of supporting resources, architecture docs, lab guides, and reference materials used throughout the workshop.

> PBIP artifacts are intentionally **not committed** in this repository. Bring your own PBIP files locally under `shared/` (or `shared/pbip-local/`) and keep reusable CI/CD assets (`Rules-*.json`, `scripts/`, `tests/`, `azdo/azure-pipelines.yml`) in source control.
>
> This repo now also includes a reusable **universal Fabric CI/CD pipeline** under `shared/universal-pipeline/`. The intent is to host one shared template repo for Fabric artifact validation/deployment, while each project repo keeps only a small consumer `azure-pipelines.yml`.

---

## Quick Navigation

| Section | Description |
|---------|-------------|
| [1. Workshop Topics Table](#1-workshop-topics--supporting-documents-table) | Agenda-mapped resource overview |
| [2. Detailed Breakdowns](#2-detailed-topicby-topic-resource-breakdown) | Per-topic doc references |
| [3. Best Practices Summary](#3-best-practices-summary) | Governance, Git, CI/CD, Embedded |
| [4. Contributing](#4-contributing) | How to suggest improvements or changes |
| [5. Disclaimer](#5-disclaimer) | Example-code and as-is notice |
| [6. Folder Structure](#6-appendix-repository-folder-structure) | Actual repo layout |

### No-Code Fabric BI DevOps Accelerator Tools

This repo includes static browser tools that help teams define and maintain enterprise Power BI standards without hand-editing JSON:

Start from the central launchpad:

`tools/index.html`

| Tool | Path | Purpose |
|---|---|---|
| **Fabric BI DevOps Accelerator Launchpad** | `tools/index.html` | Central entry point with tool links, recommended workflow, audience guidance, and generated artifact descriptions. |
| **Enterprise Standards Builder** | `tools/enterprise-standards-builder/index.html` | Choose policy profiles and generate `Rules-Report.json`, `Rules-Dataset.json`, a reusable policy profile, and a review summary. |
| **Quality Rule Designer** | `tools/rule-designer/index.html` | Edit individual report and dataset rules, including custom PBI Inspector and Tabular Editor BPA logic. |
| **DAX Test Builder** | `tools/dax-test-builder/index.html` | Customize `shared/dax-tests.json`, define DAX measure test metadata, and export a test catalog for CI/CD adoption. |
| **PBIP Project Readiness Scanner** | `tools/pbip-readiness-scanner/index.html` | Scan a local PBIP repo or project folder before PR and export readiness reports. |

Use the Enterprise Standards Builder first for governance policy setup, then use the Quality Rule Designer for advanced tuning.

See [Fabric BI DevOps Accelerator Tools](docs/governance/power-bi-governance-tools.md) for screenshots, demo flow, and positioning language.

### Repository Structure by Platform

This repository organizes CI/CD platforms and shared assets at the top level for clarity:

| Folder | Purpose |
|--------|---------|
| **`.github/`** | GitHub Actions workflows and setup guides for GitHub-hosted repos |
| **`azdo/`** | Azure DevOps YAML pipelines and configuration for Azure DevOps projects || **`gitlab/`** | GitLab CI/CD pipeline definitions for GitLab-hosted repos || **`shared/`** | Shared, platform-agnostic CI/CD assets (rules, scripts, tests, PBIP artifacts) |

Each CI platform folder contains entry-point pipeline definitions that reference shared assets in `shared/`.

### CI/CD Pipeline Options
- Use [azdo/azure-pipelines.yml](azdo/azure-pipelines.yml) for the workshop's PBIP-specific Azure DevOps CI/CD walkthrough. It validates, tests, publishes `pbip-drop`, then deploys to Dev or feature workspaces with [shared/scripts/deploy-dynamic.ps1](shared/scripts/deploy-dynamic.ps1).
- Use [shared/universal-pipeline/README.md](shared/universal-pipeline/README.md) when you want one shared Azure DevOps template repo that can be consumed by many Fabric project repos.
- Use [.github/workflows/powerbi-ci.yml](.github/workflows/powerbi-ci.yml) for GitHub Actions-based PBIP validation in GitHub-hosted repos.
- Use [.github/README.md](.github/README.md) for a dedicated GitHub project setup guide.
- Use [gitlab/gitlab-ci.yml](gitlab/gitlab-ci.yml) for GitLab CI/CD-based PBIP validation and deployment. Configure GitLab to use the file via **Settings → CI/CD → CI/CD configuration file** → `gitlab/gitlab-ci.yml`.

### Sparse Clone Presets

This repo includes ready-to-run PowerShell scripts that clone only the folders needed for a platform profile.

- Azure DevOps profile script: [shared/scripts/Clone-SparseAzDoProfile.ps1](shared/scripts/Clone-SparseAzDoProfile.ps1)
- GitHub profile script: [shared/scripts/Clone-SparseGitHubProfile.ps1](shared/scripts/Clone-SparseGitHubProfile.ps1)

Run either script from any PowerShell prompt:

```powershell
# Azure DevOps profile (.github and gitlab omitted)
./shared/scripts/Clone-SparseAzDoProfile.ps1 -RepoUrl https://github.com/<org>/<repo>.git -Destination Fabric-AzDo

# GitHub profile (azdo and gitlab omitted)
./shared/scripts/Clone-SparseGitHubProfile.ps1 -RepoUrl https://github.com/<org>/<repo>.git -Destination Fabric-GitHub

# GitLab profile (.github and azdo omitted)
./shared/scripts/Clone-SparseGitLabProfile.ps1 -RepoUrl https://gitlab.com/<group>/<repo>.git -Destination Fabric-GitLab
```

Default included folders per profile:

- Azure DevOps: `azdo`, `shared`, `docs`
- GitHub: `.github`, `shared`, `docs`
- GitLab: `gitlab`, `shared`, `docs`

Use a different branch with `-Branch`:

```powershell
./shared/scripts/Clone-SparseAzDoProfile.ps1 -RepoUrl https://github.com/<org>/<repo>.git -Destination Fabric-AzDo-Dev -Branch develop
```

To apply a preset on an existing clone:

```powershell
git sparse-checkout init --cone
git sparse-checkout set azdo shared docs    # Azure DevOps preset
# or
git sparse-checkout set .github shared docs # GitHub preset
```

### GitHub Actions CI (Power BI)

The GitHub Actions workflow at [.github/workflows/powerbi-ci.yml](.github/workflows/powerbi-ci.yml) mirrors the workshop CI pattern: Validate -> Quality Rules -> DAX Tests -> Publish Artifacts.

Required repository structure:

```text
repo-root/
├── .github/
│   └── workflows/
│       └── powerbi-ci.yml
└── shared/
    ├── pbip-local/                  # local PBIP artifacts used by CI checks
    ├── Rules-Dataset.json           # optional; fallback downloaded if missing
    ├── Rules-Report.json            # optional; fallback downloaded if missing
    ├── scripts/
    │   └── Prepare-QualityRules.ps1
    └── tests/
        ├── validate_pbip_structure.py
        └── run_dax_tests.py
```

Skip controls (similar to universal Azure template behavior):
- Manual run inputs in GitHub Actions: `skip_dataset_rules`, `skip_report_rules`, `skip_dax_tests`, `skip_publish`.
- Optional repository/org variables for default behavior on all runs:
  - `PBIP_CI_SKIP_DATASET_RULES`
  - `PBIP_CI_SKIP_REPORT_RULES`
  - `PBIP_CI_SKIP_DAX_TESTS`
  - `PBIP_CI_SKIP_PUBLISH`

Set variable values to `true` or `false`.

Branch policy behavior:
- The workflow triggers on `main`, `feature/*`, and pull requests targeting `main`.
- Branch-aware severity handling is applied by [shared/scripts/Prepare-QualityRules.ps1](shared/scripts/Prepare-QualityRules.ps1):
  - Dataset rules enforce severity >= 2 on protected target branches such as `main` and `develop`, and >= 3 on feature branches.
  - Report rules keep selected checks as warnings on feature branches, and promote those checks to errors on protected target branches.

This pattern keeps feature-branch feedback fast while preserving stricter enforcement for protected integration branches.

### Presentation Decks (Marp)
- [01 — Kickoff & Overview](presentations/01-kickoff-overview.md)
- [02 — Version Control in Fabric & PBIP](presentations/02-version-control-pbip.md)
- [03 — Lab 1: Connect Workspace to Git](presentations/03-lab1-connect-git.md)
- [04 — Collaboration & Governance](presentations/04-collaboration-governance.md)
- [05 — Deployment Strategy](presentations/05-deployment-strategy.md)
- [06 — Lab 2: CI/CD Pipeline for PBIP](presentations/06-lab2-ci-pipeline.md)
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
- [Fabric + Git Integration](docs/architecture/fabric-git-integration.md) — diagrams for the full integration, PBIP workflow, CI/CD pipeline, deployment pipeline, end-to-end DevOps, and Power BI Embedded
- [GitHub Best Practices for Fabric Git Integration](docs/architecture/github-fabric-git-best-practices.md)
- [Branching Strategy](docs/architecture/branching-strategy.md)
- [CI/CD Architecture](docs/architecture/cicd-architecture.md)
- [Workspace Strategy](docs/architecture/workspace-strategy.md)

### Labs
- [Lab 1 — Connect Workspace to Git](docs/workshop-plan/labs/lab1-connect-git.md)
- [Lab 2 — CI/CD Pipeline for the Power BI Project](docs/workshop-plan/labs/lab2-ci-pipeline.md)
- [Lab 3 — Deployment Pipelines](docs/workshop-plan/labs/lab3-deployment-pipelines.md)

### Governance
- [Governance Checklist](docs/governance/governance-checklist.md)
- [OneLake Security Guidance](docs/governance/onelake-security.md)
- [Fabric BI DevOps Accelerator Tools](docs/governance/power-bi-governance-tools.md)

---

# 1. Workshop Topics & Supporting Documents Table

| Agenda Topic & Time | Key Supporting Documents / Resources |
|---------------------|---------------------------------------|
| **Kickoff, Objectives, Roles, Prerequisites**<br>(09:00–09:20) | Workshop Overview (agenda, objectives); Governance deck; Connect Fabric Workspaces to ADO prereqs |
| **Version Control in Fabric & PBIP**<br>(09:20–10:15) | Git integration overview; PBIP basics; Branching & workspace separation guides |
| **Lab #1 — Connect Workspace to Git**<br>(10:30–11:30) | Lab Guide for Git connection; Branded slides; CI/CD architecture diagrams |
| **Collaboration Patterns & Best Practices**<br>(11:30–12:15) | DataOps deck; Governance essentials; RACI examples; Go‑Live assessment |
| **Deployment Strategy: Dev→Test→Prod**<br>(13:00–13:45) | CI/CD Delivery Guide; Enterprise‑scale Power BI Dev examples; Deployment pipeline docs |
| **Lab #2 — CI/CD Pipeline for the Power BI Project**<br>(13:45–14:45) | CI/CD lab guide (YAML examples, PBIP validation, artifact publication, workspace deployment); ADO test integration; MS Learn pipeline tutorials |
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
- Every push to `main`, `develop`, or `feature/*` triggers validation, testing, and artifact publication  
- `main` and `develop` runs deploy the validated PBIP artifact to the Dev workspace  
- `feature/*` runs create or update isolated feature workspaces using a configured workspace prefix  
- Environment-specific configs use Azure DevOps variables, variable groups, and service principal authentication  
- No manual promotion to production  

---

## 2.6 Lab #2 — CI/CD Pipeline for PBIP

Primary references:
- **Lab #2 Guide — CI/CD Pipeline for PBIP**  
  Includes YAML patterns for:
  - PBIP schema validation  
  - DAX unit tests  
  - Lint rules  
  - Publishing the `pbip-drop` pipeline artifact  
  - Deploying validated PBIP definitions with `scripts/deploy-dynamic.ps1`
- **AzureDevOps Deep Dive**  
  Shows integration with dashboards and test plans.
- **Microsoft Learn — CI/CD Tutorial**  
  Mirrors the steps of building a working PBIP validation and deployment pipeline.

Lab #2 Outcomes:
- Working CI/CD pipeline  
- PR branch policies enforced with the CI/CD pipeline as the required status check  
- PBIP validation, testing, artifact publication, and workspace deployment occur automatically  

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
- Publish validated PBIP artifacts from the YAML pipeline  
- Deploy `main` and `develop` to Dev, and `feature/*` branches to isolated feature workspaces  
- Treat PBIP artifacts as code  
- Use service principals and secured variable groups or Key Vault-linked variable groups for deployment secrets  

### Embedded Analytics
- Prefer **App Owns Data** for external apps  
- Use service principals exclusively  
- Validate RLS interactions with embedding  

---

# 4. Contributing

Contributions are welcome when they improve the workshop, clarify the learning path, or make the examples easier to adapt in real Fabric and Power BI environments.

Suggested contribution workflow:

1. Create a short-lived branch such as `feature/<alias>-<change>` or `docs/<alias>-<topic>`.
2. Keep changes focused on one topic, lab, script, or pipeline behavior.
3. Update related documentation when changing YAML, PowerShell, tests, rules, or workshop flow.
4. Run the relevant local checks before opening a pull request. For PBIP validation changes, start with [shared/tests/validate_pbip_structure.py](shared/tests/validate_pbip_structure.py) and the quality-rule preparation script.
5. Open a pull request with a clear summary, testing notes, and any environment assumptions.

Good contributions include documentation fixes, clearer lab steps, safer validation rules, reusable pipeline improvements, and examples that help teams adapt the workshop to their own Fabric tenant. Avoid committing tenant-specific IDs, client secrets, tokens, real customer data, exported PBIP files that should remain local, or environment-specific values that belong in variable groups or secure configuration.

---

# 5. Disclaimer

This repository contains workshop material and example automation code. The YAML pipelines, PowerShell scripts, validation rules, tests, and deployment examples are provided as reference implementations and starting points only.

Before using any code from this repository in your own environment, review it carefully, modify it for your tenant, workspace topology, security model, naming conventions, branch policies, and deployment process, and verify it with non-production workspaces and test data. You are responsible for validating permissions, service principal configuration, secrets handling, Fabric tenant settings, API behavior, and deployment outcomes in your environment.

The contents of this repository are provided "as is" without warranty of any kind, express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, and non-infringement. The authors and contributors are not liable for any damages, data loss, service interruption, security issue, or other impact arising from use of these examples.

---

# 6. Appendix: Repository Folder Structure

```text
/
├── README.md
├── Supporting_Docs_For_Workshop.md
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
  ├── index.html                 ← GitHub Pages landing page
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


