---
title: "Enterprise BI DevOps with Microsoft Fabric — Workshop Datasheet"
description: "Customer-facing datasheet for positioning and scoping the Enterprise BI DevOps with Microsoft Fabric workshop."
audience: "Customers, account teams, delivery leads, Fabric and Power BI stakeholders"
---

# Enterprise BI DevOps with Microsoft Fabric

## Workshop Datasheet

Enterprise BI DevOps with Microsoft Fabric is a hands-on workshop and accelerator for teams that want to bring governed CI/CD, quality gates, and release discipline to Power BI and Microsoft Fabric projects.

The workshop helps analytics teams move beyond basic Git integration and toward a repeatable operating model for source-controlled BI delivery.

## Who should attend

| Role | Why attend |
|---|---|
| BI developers and report creators | Learn how PBIP projects, Git workflows, quality rules, and pull requests fit into day-to-day delivery |
| Semantic model owners | Understand validation, DAX test metadata, model quality checks, and release readiness patterns |
| Fabric administrators | See how workspace topology, permissions, deployment pipelines, and governance controls work together |
| DevOps engineers | Review CI/CD patterns for Azure DevOps, GitHub Actions, and GitLab CI/CD |
| BI leads and governance owners | Define standards, exception patterns, release gates, and operating model guidance |
| IT leaders and program sponsors | Understand how the approach reduces release risk and improves analytics delivery consistency |

## Recommended format

| Format | Description |
|---|---|
| Half-day briefing | Executive and technical overview, recommended for early stakeholder alignment |
| Full-day workshop | Hands-on delivery with labs, validation, governance tooling, and release discussion |
| Multi-session enablement | Modular delivery across architecture, CI/CD, governance, and hands-on labs |

## Business outcomes

Participants leave with a practical understanding of how to:

- Source-control Power BI and Fabric artifacts using PBIP and Git.
- Use branch and pull request workflows for BI delivery.
- Validate PBIP structure before merge.
- Run report and semantic model quality gates in CI/CD.
- Capture DAX test metadata for critical measures.
- Generate deployment manifests and readiness reports.
- Align Dev/Test/Prod workspace strategy with release governance.
- Choose an adoption path for Azure DevOps, GitHub Actions, or GitLab CI/CD.

## Workshop modules

| Module | Focus |
|---|---|
| Operating model | Why BI DevOps matters, roles, responsibilities, and delivery principles |
| Git integration and PBIP | Fabric Git integration, PBIP structure, repo layout, and branching |
| Workspace strategy | Dev, feature, test, and production workspace patterns |
| CI/CD validation | PBIP validation, quality rules, DAX tests, and artifact publication |
| No-code governance tools | Standards Builder, Rule Designer, DAX Test Builder, Manifest Builder, Readiness Scanner |
| Deployment and release | Deployment pipelines, release readiness, approvals, and rollback planning |
| Enterprise maturity | Central rules, profiles, project exceptions, and future governance model |

## Prerequisites

| Area | Requirement |
|---|---|
| Microsoft Fabric | Access to a Fabric capacity-backed workspace |
| Power BI Desktop | Current version installed for PBIP authoring |
| Git provider | Azure DevOps, GitHub, or GitLab repository access |
| Local tools | Git, VS Code, PowerShell, and required organizational authentication |
| Permissions | Ability to create branches, pull requests, and connect Fabric workspaces to Git |
| Optional deployment | Service principal and workspace permissions for automated deployment scenarios |

## Materials provided

- Workshop agenda and lab guides.
- Architecture and CI/CD reference documentation.
- Platform-specific pipeline examples for Azure DevOps, GitHub Actions, and GitLab CI/CD.
- Static browser tools for governance artifacts.
- Sparse clone scripts for toolkit-only or workshop-enabled adoption.
- Sample quality rules, DAX test metadata, deployment manifest patterns, and readiness scanner guidance.

## Recommended pre-work

Before the session, confirm:

- Target Git provider and repository strategy.
- Fabric tenant Git integration settings.
- Workspace topology and naming conventions.
- Whether the delivery will be demo-only, hands-on, or pilot-project based.
- Which CI/CD platform will be used during the workshop.
- Whether deployment automation is in scope or deferred.

## Outputs

By the end of the workshop, participants should have:

- A shared understanding of the BI DevOps operating model.
- A reference repo layout for PBIP-based delivery.
- A platform-specific CI/CD starting point.
- A governance artifact plan for rules, tests, manifests, and readiness checks.
- A prioritized adoption path for project-level or enterprise-level rollout.

## Follow-up recommendations

- Select one pilot Power BI/Fabric project.
- Start with advisory rules and non-blocking validation.
- Add branch policies after initial false positives are addressed.
- Use deployment manifests for release review.
- Move toward central baseline rules and project exception files as adoption matures.

