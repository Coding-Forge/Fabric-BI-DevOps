---
title: "CI/CD Architecture — Microsoft Fabric + Git"
description: "Architecture reference for the end-to-end CI/CD pipeline supporting PBIP-based development in Microsoft Fabric, including Azure DevOps pipelines and Fabric Deployment Pipelines."
---

# CI/CD Architecture

This document describes the end-to-end **CI/CD architecture** for Microsoft Fabric workspaces that use Power BI Projects (PBIP) and Git-based lifecycle management.

For teams standardizing across many repositories, the same approach can be implemented as a **single shared Azure DevOps template repo**. In that model, one central pipeline template validates and publishes Fabric artifacts, while each project repo keeps only a thin consumer `azure-pipelines.yml` that references the shared template.

---

## Architecture Overview

The project-local workshop pipeline spans Azure DevOps automation plus Fabric-native promotion:

| System | Purpose |
|---|---|
| **Azure DevOps CI/CD** | Validates, tests, publishes, and deploys PBIP artifacts on branch runs |
| **Fabric Deployment Pipelines** | Promotes validated Dev workspace content across Dev → Test → Prod workspaces |

Together they enforce that no unvalidated, unreviewed change can reach the production workspace.

---

## End-to-End Flow

```mermaid
flowchart TD
    Dev[Developer\nFabric Portal / VS Code]
    FeatureBranch[Feature Branch\nin Git Repo]
    PR[Pull Request\ninto main]
    CI[Azure DevOps CI/CD Pipeline\nValidate · Test · Publish]
    DeployBranch{Branch target}
    DeployFeature[deploy-dynamic.ps1\nCreate/update feature workspace]
    DeployDev[deploy-dynamic.ps1\nUpdate Dev workspace]
    Main[main Branch\nProtected]
    FabricDev[Fabric Dev Workspace\nGit-connected]
    FeatureWS[Fabric Feature Workspace\nEphemeral]
    DeployTest[Fabric Deployment Pipeline\nDev → Test Promotion]
    FabricTest[Fabric Test Workspace]
    ApprovalGate[Manual Approval Gate]
    DeployProd[Fabric Deployment Pipeline\nTest → Prod Promotion]
    FabricProd[Fabric Prod Workspace]

    Dev -->|commit + push| FeatureBranch
    FeatureBranch -->|open PR| PR
    PR -->|triggers| CI
    CI -->|pass| PR
    FeatureBranch -->|push| CI
    CI --> DeployBranch
    DeployBranch -->|feature/*| DeployFeature --> FeatureWS
    PR -->|approved + merged| Main
    Main -->|push| CI
    DeployBranch -->|main or develop| DeployDev --> FabricDev
    FabricDev -->|promote| DeployTest
    DeployTest --> FabricTest
    FabricTest --> ApprovalGate
    ApprovalGate -->|approved| DeployProd
    DeployProd --> FabricProd
```

---

## Azure DevOps Pipeline Detail

The project-local pipeline (defined in `projects/azure-pipelines.yml`) runs on pushes to `main`, `develop`, and `feature/*`, and on PRs targeting `main` or `develop`.

Two implementation patterns are valid:

| Pattern | When to use it |
|---|---|
| **Project-local pipeline** | Single workshop repo or a team that wants one self-contained YAML file such as `projects/azure-pipelines.yml` |
| **Shared template pipeline** | Multiple Fabric repos that should all use the same validation, test, and publish logic from a central template repo |

The shared-template option is documented in [projects/universal-pipeline/README.md](../../projects/universal-pipeline/README.md).

```mermaid
flowchart TD
    Trigger[Git Trigger\nfeature/* or main]
    Agent[Windows Build Agent]
    Validate[Run PBIP Structure Validation\nvalidate_pbip_structure.py]
    Quality[Run Dataset + Report Quality Rules\nPrepare-QualityRules.ps1]
    DaxTests[DAX Unit Tests\nJUnit XML output]
    Publish[Publish Pipeline Artifact\npbip-drop]
    DeployDev[Deploy_Dev\nmain/develop]
    DeployFeature[Deploy_Feature\nfeature/*]
    DeployScript[deploy-dynamic.ps1\nFabric REST API]
    Status[CI Status Check\nreported to PR]

    Trigger --> Agent
    Agent --> Validate
    Validate --> Quality
    Quality --> DaxTests
    DaxTests --> Publish
    Publish --> DeployDev
    Publish --> DeployFeature
    DeployDev --> DeployScript
    DeployFeature --> DeployScript
    Publish --> Status
```

### Pipeline Stages

| Stage | Steps | Failure Behaviour |
|---|---|---|
| **Validate** | `validate_pbip_structure.py`, dataset rules, report rules | Fails build immediately |
| **Test** | DAX unit tests via `run_dax_tests.py` | Fails build; JUnit results published |
| **Publish** | `PublishPipelineArtifact` creates `pbip-drop` | Skipped if prior stage fails |
| **Deploy_Dev** | Downloads `pbip-drop` and runs `scripts/deploy-dynamic.ps1` against the Dev workspace | Runs only for `main` and `develop`; fails if deployment variables or workspace target are missing |
| **Deploy_Feature** | Downloads `pbip-drop`, creates or reuses a prefixed feature workspace, and deploys the PBIP definition | Runs only for `feature/*`; fails if `FeatureWorkspacePrefix` is missing |

In the shared-template pattern, these same stages live in one central template file and are reused by many consumer repos via `extends:`.

### Deployment Script

`scripts/deploy-dynamic.ps1` authenticates with the Fabric REST API using a service principal, resolves the target workspace from the branch, and creates or updates Fabric semantic model and report items from the published PBIP definition. The script expects `.platform` metadata, deploys semantic models before reports, and rewrites report dataset references to the deployed semantic model ID.

Required pipeline variables are `TenantId`, `AppId`, and `ClientSecret`. Dev deployments also need either `DevWorkspaceId` or `DEV_WORKSPACE_NAME`; feature deployments require `FeatureWorkspacePrefix`.

---

## Deployment Pipelines

### Dev → Test → Prod

Fabric Deployment Pipelines manage the promotion of workspace content across environments. Each stage is bound to a dedicated Fabric workspace.

```mermaid
flowchart LR
    DevWS[Dev Workspace\nGit-connected\nMain branch]
    TestWS[Test Workspace\nRead-only access]
    ProdWS[Prod Workspace\nRestricted access]

    subgraph DP["Fabric Deployment Pipeline"]
        Promote1[Dev → Test\nPromotion]
        Promote2[Test → Prod\nPromotion]
    end

    DevWS --> Promote1 --> TestWS
    TestWS --> Promote2 --> ProdWS

    subgraph Gates["Validation Gates"]
        G1[CI green on main]
        G2[Schema diff review]
        G3[RLS/CLS validation]
        G4[Dataset refresh test]
        G5[Manual approval\nfrom stakeholder]
    end

    Promote1 --> G1
    Promote1 --> G2
    Promote2 --> G3
    Promote2 --> G4
    Promote2 --> G5
```

### Promotion Checklist

Before promoting from **Dev → Test**:
- [ ] CI pipeline passes on `main`  
- [ ] No schema drift detected (compare against last known-good artifact)  
- [ ] All report visuals render correctly in Dev workspace  
- [ ] Dataset refresh completes without errors  

Before promoting from **Test → Prod**:
- [ ] UAT sign-off from stakeholders  
- [ ] RLS role bindings validated for all personas  
- [ ] CLS column-level security reviewed  
- [ ] Sensitivity labels applied  
- [ ] Connection string parameters swapped (Dev → Prod data sources)  
- [ ] Manual approval granted in the Deployment Pipeline UI  

---

## Workspace-to-Branch Mapping

The **branch-out strategy** extends the standard Dev/Test/Prod topology with personal and scoped feature workspaces. Each feature branch has a corresponding isolated workspace; only `main` feeds the shared team Dev workspace.

| Workspace | Branch | Git Integration | Purpose |
|---|---|---|---|
| `WS-Dev-<team>` | `main` | Connected — auto-sync on merge | Shared team baseline |
| `WS-Dev-<alias>` | `feature/<alias>-*` | Connected to feature branch | Personal isolated development |
| `WS-Dev-<team>-<feature>` | `feature/<team>-*` | Connected to feature branch | Scoped multi-developer feature |
| `WS-Test-<team>` | — | Promoted via Deployment Pipeline, not Git | UAT / integration |
| `WS-Prod-<team>` | — | Promoted via Deployment Pipeline, not Git | Live production |

> Personal and scoped feature workspaces are **ephemeral** — they are created for the duration of the feature branch and deleted after the PR merges. Only the shared Dev, Test, and Prod workspaces are permanent.
>
> See [Branching Strategy](branching-strategy.md) for the full branch-out workflow.

---

## Security Considerations

- **Service principal** used for automated pipeline operations; no personal credentials stored in the pipeline.  
- Secrets (client secrets, connection strings, API keys) stored in secured variable groups or **Azure Key Vault** and referenced via pipeline variable groups linked to the Key Vault.  
- Branch policies on `main` require:
  - Minimum **1 reviewer** approval  
  - Linked CI build passing  
  - Comment resolution  
- Fabric workspace permissions follow least-privilege: Prod workspace is **Viewer-only** for all non-admin accounts.

---

## Related Documents

- [Lab 2 — CI Pipeline Validation for the Power BI Project](../workshop-plan/labs/lab2-ci-pipeline.md)  
- [Workspace Strategy](workspace-strategy.md)  
- [Governance Checklist](../governance/governance-checklist.md)  
- [Fabric + Git Integration Architecture](fabric-git-integration.md)
