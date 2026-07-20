# Workshop Catalog

This folder is the canonical home for workshop material in **Enterprise BI DevOps with Microsoft Fabric**.

The previous `docs/workshop-plan/` folder is retained only as a compatibility redirect for older links. New workshop content should be added under this `docs/workshops/` catalog.

## Current workshops

| Workshop | Audience | Purpose |
|---|---|---|
| [Core Fabric Git Workshop](core-fabric-git/README.md) | BI developers, Fabric admins, DevOps engineers, BI leads | Teach Fabric workspace Git integration, PBIP source control, branching, PR flow, CI/CD validation, and deployment pipelines |
| [Accelerator Toolkit Workshop](accelerator-toolkit/README.md) | BI leads, report creators, semantic model owners, platform engineers, governance owners, release managers | Teach how to use the no-code accelerator tools to create standards, rules, policies, review evidence, pipeline config, release readiness, adoption metrics, and reference outputs |

## Future workshop placeholders

| Placeholder | Purpose |
|---|---|
| [Branch Strategy Workshop](future/branch-strategy-workshop.md) | Branch policy, feature workspaces, PR gates, and protected branches |
| [Environment Parameter Mapping Workshop](future/environment-parameter-mapping-workshop.md) | Dev/Test/Prod parameter mapping, workspace IDs, connection references, and semantic bindings |
| [Workspace Promotion Planning Workshop](future/workspace-promotion-planning-workshop.md) | Promotion stages, approvals, rollback, ownership, and release management |
| [Semantic Model Inventory Workshop](future/semantic-model-inventory-workshop.md) | TMDL/PBIP inventory, model documentation, and stewardship |
| [Measure Documentation Workshop](future/measure-documentation-workshop.md) | DAX measure catalog, dependencies, ownership, and certification support |
| [Report UX Review Workshop](future/report-ux-review-workshop.md) | Accessibility, navigation, layout, theme, tooltips, and mobile review |
| [Certification and Security Readiness Workshop](future/certification-security-readiness-workshop.md) | Certification evidence, sensitivity labels, PII checks, sharing restrictions, and endorsement |
| [Adoption Portal Workshop](future/adoption-portal-workshop.md) | Workshop portal, quick starts, screenshots, videos, templates, and onboarding paths |
| [Enterprise Rules Governance Workshop](future/enterprise-rules-governance-workshop.md) | Central baseline rules, override schema, exception lifecycle, and profile-based enforcement |

## Folder convention

Use this structure for each workshop:

```text
docs/workshops/<workshop-name>/
  README.md
  labs/
  reference-output/
  facilitator-notes/
```

Only add subfolders that are actually needed. Every workshop should include a `README.md` with audience, outcomes, prerequisites, agenda, and links to labs/reference outputs.

