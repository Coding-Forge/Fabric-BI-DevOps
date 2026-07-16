# Power BI DevOps Toolkit Roadmap

This roadmap tracks the enterprise tooling being added around PBIP CI/CD for Azure DevOps, GitHub Actions, and GitLab CI.

## Current Status

| Status | Count | Meaning |
|---|---:|---|
| Complete | 3 | Tool exists, is documented, and has been smoke tested |
| In progress | 0 | Tool is actively being built |
| Planned | 17 | Tool idea is captured but not yet implemented |

## Completed Tools

| Tool | Path | Purpose |
|---|---|---|
| Enterprise Standards Builder | `tools/enterprise-standards-builder/index.html` | Generates enterprise report and dataset quality rules from policy profiles |
| Quality Rule Designer | `tools/rule-designer/index.html` | Lets users edit individual PBI Inspector and Tabular Editor BPA rules without hand-editing JSON |
| DAX Test Builder | `tools/dax-test-builder/index.html` | Users can define DAX measure test cases, export `dax-tests.json`, export Markdown documentation, and understand how the test metadata fits into CI |

## In Progress

No toolkit item is currently in progress.

## Planned Toolkit

| Priority | Tool | Audience | Purpose | Expected Output |
|---:|---|---|---|---|
| 1 | PBIP Project Readiness Scanner | Report creators, platform team | Scan a repo/workspace folder before PR for missing `.pbip`, `.Report`, `.SemanticModel`, broken references, naming issues, and missing rule files | Readiness report, checklist, optional JSON |
| 2 | PR Quality Summary Generator | PR authors, reviewers | Create a plain-English PR summary from PBIP diffs, changed reports/models, failed/passed rules, DAX tests, and deployment impact | Markdown PR summary |
| 3 | Deployment Manifest Builder | Release managers, BI leads | Define source/target workspaces, item names, environment parameters, approvals, and rollback notes | `deployment-manifest.json`, release summary |
| 4 | Policy Exception Register | Governance owners | Track rule exceptions with owner, reason, expiration, affected artifact, and approval status | `policy-exceptions.json`, exception summary |
| 5 | Environment Parameter Mapper | BI developers, DevOps | Map Dev/Test/Prod connection strings, workspace IDs, lakehouse/warehouse references, and semantic model bindings | Environment map JSON |
| 6 | PBIP Diff Viewer | Reviewers, BI leads | Present report/model diffs in friendly terms instead of raw JSON | HTML diff report |
| 7 | Semantic Model Inventory Explorer | BI developers, governance | Extract tables, columns, measures, relationships, roles, perspectives, and calculation groups from TMDL/PBIP | Model inventory JSON/Markdown |
| 8 | Measure Documentation Generator | Report creators, data stewards | Generate a measure catalog with DAX, descriptions, format strings, dependencies, owner, and certification status | Measure catalog Markdown/CSV |
| 9 | Report UX Review Checklist Builder | Report creators, UX reviewers | Guide accessibility, navigation, titles, tooltips, theme, page density, and mobile layout review | UX review checklist |
| 10 | Release Readiness Dashboard | BI leads, release managers | Aggregate validation status, test results, quality rules, deployment target, approvals, and known exceptions | Release dashboard HTML |
| 11 | Pipeline Config Generator | Platform team | Generate Azure DevOps YAML, GitHub Actions, or GitLab CI from one profile | CI/CD pipeline YAML |
| 12 | Branch Strategy Wizard | Project leads | Recommend branch policy, environment mapping, PR requirements, and protected branch rules | Branch strategy summary |
| 13 | Workspace Promotion Planner | Release managers | Map Dev/Test/Prod workspaces, deployment pipeline stages, approval gates, item ownership, and rollback plan | Promotion plan Markdown/JSON |
| 14 | Sensitivity & Data Classification Checklist | Security, governance | Capture classification, sensitivity labels, PII indicators, sharing restrictions, and endorsement state | Security checklist |
| 15 | Dependency Impact Analyzer | BI developers, reviewers | Show reports, measures, visuals, relationships, and columns impacted by a changed model object | Impact report |
| 16 | Certification Readiness Checker | BI leads, data stewards | Validate certification requirements for trusted semantic models | Certification readiness report |
| 17 | Rule Coverage Matrix | Governance owners | Map enterprise policies to automated CI rules and manual checklist items | Coverage matrix Markdown/JSON |
| 18 | Workshop / Adoption Portal | End users, delivery teams | Provide a landing page for tools, screenshots, workflow, demo videos, docs, templates, and quick-start paths | Static adoption portal |

## Shared Metadata Direction

The toolkit should converge on a small set of reusable metadata files that any CI/CD platform can consume:

```text
enterprise-policy-profile.json
dax-tests.json
deployment-manifest.json
policy-exceptions.json
environment-map.json
```

## Working Principles

- Prefer static browser tools when the user experience matters and local installation should be avoided.
- Keep generated files plain JSON or Markdown so Azure DevOps, GitHub Actions, and GitLab CI can consume them.
- Preserve custom rules and metadata when tools regenerate managed sections.
- Treat strict enforcement as a lifecycle decision: start advisory, clean up noise, then promote to blocking.
- Document each tool for both implementation users and marketing/adoption conversations.

