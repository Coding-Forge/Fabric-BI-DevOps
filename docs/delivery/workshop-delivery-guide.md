---
title: "Enterprise BI DevOps with Microsoft Fabric — Delivery Guide"
description: "Internal delivery guide for preparing, delivering, and following up on the Enterprise BI DevOps with Microsoft Fabric workshop."
audience: "Facilitators, delivery leads, account teams, technical specialists"
---

# Enterprise BI DevOps with Microsoft Fabric

## Delivery Guide

This guide is for facilitators delivering the Enterprise BI DevOps with Microsoft Fabric workshop or adapting the hosted materials for a customer, partner, or internal community session.

Use the datasheet for customer-facing positioning. Use this delivery guide for planning, setup, execution, and follow-up.

## Delivery principles

- Keep the conversation business-outcome driven.
- Use the customer or team CI/CD platform when possible.
- Treat PBIP, quality rules, DAX tests, and manifests as governed delivery assets.
- Start with advisory validation before making rules blocking.
- Keep workshop and toolkit materials separate unless the session explicitly includes enablement labs.
- Prefer hosted links for durable sharing and PDF snapshots for Teams attachments.

## Material locations

| Material | Location |
|---|---|
| Root solution README | `README.md` |
| Workshop datasheet | `docs/delivery/workshop-datasheet.md` |
| Workshop plan | `docs/workshop-plan/Fabric_Git_Workshop_Plan.md` |
| Lab guides | `docs/workshop-plan/labs/` |
| Sparse clone guide | `docs/sparse-clone-guide.md` |
| Platform setup guides | `azdo/README.md`, `.github/README.md`, `gitlab/README.md` |
| No-code tools overview | `docs/governance/power-bi-governance-tools.md` |
| Blog HTML/PDF | `docs/blog/2026-07-17-enterprise-bi-devops-with-microsoft-fabric/` |
| Social and announcement content | `Social Media/` |

## Hosted material pattern

Use a durable hosted landing page as the canonical entry point:

```text
GitHub Pages or SharePoint landing page
        |
        |-- Root README / docs hub
        |-- Platform setup guides
        |-- Workshop datasheet
        |-- Delivery guide
        |-- Blog article HTML
        |-- PDF snapshot
        |-- Repository source
```

Recommended sharing pattern:

| Channel | Share |
|---|---|
| Teams channel | Hosted article link plus PDF attachment when needed |
| Viva Engage or community post | Short announcement with hosted landing page link |
| Customer follow-up | Datasheet, delivery summary, and next-step checklist |
| Technical audience | Repo link, sparse clone guide, and platform setup guide |

## Date-stamped publishing pattern

For published articles and hosted assets, use stable date-stamped folders:

```text
docs/blog/YYYY-MM-DD-slug/
```

Each published article folder should include:

```text
index.html
<slug>.pdf
assets/
```

The Markdown source remains the source of truth. Regenerate HTML/PDF outputs whenever the Markdown source or images change.

## Recommended delivery motions

### Briefing motion

Use when the audience is evaluating whether to adopt the approach.

| Segment | Focus |
|---|---|
| Opening | Business problem, why BI DevOps matters |
| Demo | Show repo layout, no-code tools, and pipeline flow |
| Architecture | Explain platform-neutral CI/CD and workspace strategy |
| Governance | Discuss rule maturity, exceptions, and release gates |
| Next steps | Identify pilot project and adoption path |

### Workshop motion

Use when participants will complete hands-on labs.

| Segment | Focus |
|---|---|
| Kickoff | Objectives, prerequisites, roles, and environment check |
| Lab 1 | Connect workspace to Git and use branch/PR workflow |
| Governance | Review quality rules, workspace strategy, and branch policies |
| Lab 2 | Run CI validation and inspect results |
| Lab 3 | Review deployment pipeline and release readiness |
| Wrap-up | Adoption plan, risks, follow-up owners |

### Pilot enablement motion

Use when a real project is being onboarded.

| Segment | Focus |
|---|---|
| Discovery | Current BI delivery process, pain points, source control status |
| Repo setup | Sparse clone profile, platform folder, shared assets |
| Rule tuning | Start with advisory rules, tune known exceptions |
| CI/CD setup | Configure variables, secrets, branch policies, and validation |
| Release planning | Manifest, readiness scan, deployment path |
| Handoff | Backlog, owners, operating model, next checkpoints |

## Pre-delivery checklist

Confirm the following before delivery:

- Delivery motion selected: briefing, workshop, or pilot enablement.
- Target CI/CD platform selected: Azure DevOps, GitHub Actions, GitLab, or undecided.
- Attendee roles and expected hands-on participation confirmed.
- Fabric tenant Git integration enabled.
- Workspace access confirmed.
- Git repo access confirmed.
- Power BI Desktop and local Git tools installed where hands-on labs are planned.
- Service principal details available if deployment automation is in scope.
- Hosted material link prepared.
- PDF snapshot prepared for Teams or follow-up attachment.

## Environment checklist

| Area | Check |
|---|---|
| Fabric workspace | Capacity-backed and accessible |
| Git provider | Repo exists and participants have access |
| Branch strategy | `main`, feature branches, PR policy agreed |
| PBIP project | Starter project or customer project available |
| CI/CD platform | Pipeline runner available |
| Secrets | Variables or secret store configured for deployment scenarios |
| Rules | `Rules-Report.json` and `Rules-Dataset.json` available or generated |
| DAX tests | `dax-tests.json` available if DAX testing is in scope |

## Delivery flow

1. Start with the business problem: faster delivery with stronger governance.
2. Show the platform-neutral repo layout.
3. Explain the difference between toolkit-only and workshop-enabled sparse clones.
4. Show the no-code tools and generated artifacts.
5. Walk through the CI/CD flow.
6. Demonstrate branch-aware quality rule behavior.
7. Discuss workspace strategy and feature workspaces.
8. Review deployment manifest and readiness scanner output.
9. Align on adoption path and next steps.

## Toolkit setup guidance

Use the toolkit sparse clone script for new project repos:

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination <destination-folder> `
  -Platform AzDo `
  -Profile Standard
```

Use `-Profile Minimal` when the team only wants CI/CD and PBIP support files.

Use `-IncludeWorkshop` only when the new repo should include hosted workshop material:

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination <destination-folder> `
  -Platform AzDo `
  -IncludeWorkshop
```

## Follow-up package

After delivery, send:

- Hosted landing page link.
- Blog article link.
- PDF article snapshot.
- Platform setup guide link.
- Sparse clone guide link.
- Recommended pilot backlog.
- Open risks and owner list.

## Pilot backlog template

| Item | Owner | Notes |
|---|---|---|
| Select pilot PBIP project |  |  |
| Confirm workspace topology |  |  |
| Create or clone project repo |  |  |
| Configure CI/CD platform |  |  |
| Generate initial rule files |  |  |
| Run readiness scan |  |  |
| Enable branch policy |  |  |
| Document deployment manifest |  |  |
| Review exceptions and rule maturity |  |  |
| Schedule follow-up checkpoint |  |  |

## Success criteria

A delivery is successful when the customer or team can explain:

- How PBIP artifacts move through source control.
- Which CI/CD platform pattern they will use.
- How validation, quality rules, and DAX tests fit into pull requests.
- How release readiness will be documented.
- Which project will be used as the first pilot.
- Which rules should start advisory and which should become blocking later.

