# Power BI DevOps Toolkit Roadmap

This roadmap tracks the enterprise tooling being added around PBIP CI/CD for Azure DevOps, GitHub Actions, and GitLab CI.

## Current Status

| Status | Count | Meaning |
|---|---:|---|
| Complete | 9 | Tool exists, is documented, and has been smoke tested |
| In progress | 0 | Tool is actively being built |
| Planned | 17 | Tool idea is captured but not yet implemented |

## Completed Tools

| Tool | Path | Purpose |
|---|---|---|
| Enterprise Standards Builder | `tools/enterprise-standards-builder/index.html` | Generates enterprise report and dataset quality rules from policy profiles |
| Quality Rule Designer | `tools/rule-designer/index.html` | Lets users edit individual PBI Inspector and Tabular Editor BPA rules without hand-editing JSON |
| DAX Test Builder | `tools/dax-test-builder/index.html` | Users can define DAX measure test cases, export `dax-tests.json`, export Markdown documentation, and understand how the test metadata fits into CI |
| PBIP Project Readiness Scanner | `tools/pbip-readiness-scanner/index.html` | Users can scan a PBIP repo/project folder before PR and export readiness reports in Markdown or JSON |
| Deployment Manifest Builder | `tools/deployment-manifest-builder/index.html` | Users can create `deployment-manifest.json` and a readable deployment summary for PBIP release review |
| PR Quality Summary Generator | `tools/pr-quality-summary-generator/index.html` | Users can generate reviewer-friendly PR summaries from changed files, pipeline logs, readiness output, DAX tests, and deployment context |
| Policy Exception Register | `tools/policy-exception-register/index.html` | Users can track rule exceptions with owner, reason, expiration, affected artifact, approval status, and mitigation |
| Effective Rules Generator | `tools/effective-rules-generator/index.html`, `shared/scripts/New-EffectiveQualityRules.ps1` | Users can generate branch-aware effective report and dataset rules from baselines, overrides, and approved exceptions |
| CI/CD Platform Parity Matrix | `tools/platform-parity-matrix/index.html`, `shared/platform-parity-matrix.json` | Users can compare Azure DevOps, GitHub Actions, and GitLab CI/CD support, setup differences, and known gaps |

## In Progress

No toolkit item is currently in progress.

## Planned Toolkit

| Priority | Tool | Audience | Purpose | Expected Output |
|---:|---|---|---|---|
| 1 | Release Readiness Dashboard | BI leads, release managers | Aggregate validation status, test results, quality rules, deployment target, approvals, and known exceptions | Release dashboard HTML |
| 2 | Adoption Metrics Dashboard | Program owners, governance leads | Track toolkit adoption, active projects, rule pass/fail trends, exception aging, and time-to-onboard | Adoption dashboard HTML/CSV |
| 3 | Rule Coverage Matrix | Governance owners | Map enterprise policies to automated CI rules and manual checklist items | Coverage matrix Markdown/JSON |
| 4 | Competitive Differentiation Matrix | Solution owner, field sellers, delivery leads | Compare this solution against generic CI/CD samples, internal accelerators, decks, and public solutions using measurable differentiators | Differentiation matrix Markdown |
| 5 | PBIP Diff Viewer | Reviewers, BI leads | Present report/model diffs in friendly terms instead of raw JSON | HTML diff report |
| 6 | Dependency Impact Analyzer | BI developers, reviewers | Show reports, measures, visuals, relationships, and columns impacted by a changed model object | Impact report |
| 7 | Pipeline Config Generator | Platform team | Generate Azure DevOps YAML, GitHub Actions, or GitLab CI from one profile | CI/CD pipeline YAML |
| 8 | Branch Strategy Wizard | Project leads | Recommend branch policy, environment mapping, PR requirements, and protected branch rules | Branch strategy summary |
| 9 | Environment Parameter Mapper | BI developers, DevOps | Map Dev/Test/Prod connection strings, workspace IDs, lakehouse/warehouse references, and semantic model bindings | Environment map JSON |
| 10 | Workspace Promotion Planner | Release managers | Map Dev/Test/Prod workspaces, deployment pipeline stages, approval gates, item ownership, and rollback plan | Promotion plan Markdown/JSON |
| 11 | Semantic Model Inventory Explorer | BI developers, governance | Extract tables, columns, measures, relationships, roles, perspectives, and calculation groups from TMDL/PBIP | Model inventory JSON/Markdown |
| 12 | Measure Documentation Generator | Report creators, data stewards | Generate a measure catalog with DAX, descriptions, format strings, dependencies, owner, and certification status | Measure catalog Markdown/CSV |
| 13 | Report UX Review Checklist Builder | Report creators, UX reviewers | Guide accessibility, navigation, titles, tooltips, theme, page density, and mobile layout review | UX review checklist |
| 14 | Certification Readiness Checker | BI leads, data stewards | Validate certification requirements for trusted semantic models | Certification readiness report |
| 15 | Sensitivity & Data Classification Checklist | Security, governance | Capture classification, sensitivity labels, PII indicators, sharing restrictions, and endorsement state | Security checklist |
| 16 | Workshop / Adoption Portal | End users, delivery teams | Provide a landing page for tools, screenshots, workflow, demo videos, docs, templates, and quick-start paths | Static adoption portal |
| 17 | Enterprise Quality Rules Governance Model | Enterprise BI platform teams, governance owners | Optional future pattern for centrally governed baseline rules with profile-based enforcement and project-level override files for approved exceptions | Central rules package, override schema, effective rules generator |

## Shared Metadata Direction

The toolkit should converge on a small set of reusable metadata files that any CI/CD platform can consume:

```text
enterprise-policy-profile.json
dax-tests.json
deployment-manifest.json
policy-exceptions.json
quality-rules.override.json
environment-map.json
platform-parity-matrix.json
adoption-metrics.json
```

## Working Principles

- Prefer static browser tools when the user experience matters and local installation should be avoided.
- Keep generated files plain JSON or Markdown so Azure DevOps, GitHub Actions, and GitLab CI can consume them.
- Preserve custom rules and metadata when tools regenerate managed sections.
- Treat strict enforcement as a lifecycle decision: start advisory, clean up noise, then promote to blocking.
- Document each tool for both implementation users and marketing/adoption conversations.
- Use the differentiation scorecard to convert maturity gaps into measurable roadmap items.

