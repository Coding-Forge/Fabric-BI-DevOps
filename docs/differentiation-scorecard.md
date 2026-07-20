# Differentiation Scorecard

This scorecard defines how **Enterprise BI DevOps with Microsoft Fabric** differentiates from generic CI/CD examples, internal accelerators, best-practice decks, and public solution samples.

Use it as:

- A positioning artifact for stakeholders.
- A growth metric for solution maturity.
- A gap analysis tool against competing internal or public approaches.
- A source of future backlog items in `TODO.md`.

## Differentiation thesis

Most BI CI/CD materials focus on one layer of the problem:

- A pipeline YAML file.
- A slide deck.
- A best-practice checklist.
- A Git integration walkthrough.
- A deployment pipeline explanation.
- A single-platform accelerator.

This solution should differentiate by being a **complete operating model** for governed BI delivery:

```text
Source control
  + platform-neutral CI/CD
  + quality rules
  + no-code governance tools
  + deployment manifests
  + readiness scanning
  + workshop enablement
  + social/adoption materials
  + enterprise exception model
  = repeatable BI DevOps practice
```

## Competitive comparison

| Capability | Generic CI/CD sample | Best-practice deck | Internal accelerator | Enterprise BI DevOps with Microsoft Fabric |
|---|---:|---:|---:|---:|
| PBIP-aware repo structure | Partial | No | Sometimes | Yes |
| Azure DevOps support | Often | Conceptual | Often | Yes |
| GitHub Actions support | Sometimes | Conceptual | Rare | Yes |
| GitLab CI/CD support | Rare | No | Rare | Yes |
| Pipeline configuration generator | Rare | No | Rare | Yes |
| Branch-aware rule enforcement | Rare | Conceptual | Sometimes | Yes |
| Report quality rules | Sometimes | Conceptual | Sometimes | Yes |
| Dataset quality rules | Sometimes | Conceptual | Sometimes | Yes |
| DAX test metadata | Rare | No | Rare | Yes |
| Deployment manifest | Rare | Conceptual | Rare | Yes |
| Pre-PR readiness scanner | Rare | No | Rare | Yes |
| PBIP diff viewer | Rare | No | Rare | Yes |
| Dependency impact analyzer | Rare | Conceptual | Rare | Yes |
| No-code rule/tool builders | Rare | No | Rare | Yes |
| Toolkit-only sparse clone | Rare | No | Rare | Yes |
| Workshop delivery materials | Rare | Yes | Sometimes | Yes |
| Social/adoption content | No | Sometimes | Sometimes | Yes |
| Published HTML/PDF article package | No | Sometimes | Rare | Yes |
| Enterprise rules override model | Rare | Conceptual | Rare | Documented and partially implemented |

## Differentiation pillars

Score each pillar from 0 to 5.

| Score | Meaning |
|---:|---|
| 0 | Not addressed |
| 1 | Concept only |
| 2 | Basic artifact exists |
| 3 | Working artifact with documentation |
| 4 | Reusable, validated, and adoption-ready |
| 5 | Measured, automated, and enterprise-ready |

### 1. Platform neutrality

| Metric | Current target |
|---|---|
| Supports Azure DevOps, GitHub Actions, and GitLab CI/CD | Yes |
| Shared scripts and rule prep reused across platforms | Yes |
| Platform-specific setup guides exist | Yes |
| Pipeline YAML can be generated from one profile | Yes |
| CI/CD behavior parity documented across platforms | Yes |
| Automated tests prove parity across platforms | Future backlog |

**Growth metric:** number of supported CI/CD platforms with documented and tested parity.

### 2. BI-specific quality gates

| Metric | Current target |
|---|---|
| PBIP structure validation | Yes |
| Report quality rules | Yes |
| Dataset quality rules | Yes |
| Branch-aware severity/promotion | Yes |
| Rule exception register | Complete |
| Rule coverage matrix | Complete |

**Growth metric:** percentage of governance policies covered by automated rules or documented manual checks.

### 3. No-code governance tooling

| Metric | Current target |
|---|---|
| Enterprise Standards Builder | Complete |
| Quality Rule Designer | Complete |
| DAX Test Builder | Complete |
| Deployment Manifest Builder | Complete |
| PBIP Readiness Scanner | Complete |
| Policy Exception Register | Complete |

**Growth metric:** number of governance artifacts a non-developer can generate without editing JSON.

### 4. Release readiness and reviewability

| Metric | Current target |
|---|---|
| Deployment manifest | Complete |
| Readiness scanner | Complete |
| PBIP diff viewer | Complete |
| PR quality summary | Complete |
| Release readiness dashboard | Complete |
| Dependency impact analyzer | Complete |

**Growth metric:** percentage of release review questions answered by generated artifacts.

### 5. Enterprise adoption model

| Metric | Current target |
|---|---|
| Workshop plan | Complete |
| Datasheet | Complete |
| Delivery guide | Complete |
| Sparse clone toolkit profiles | Complete |
| Hosted article and PDF | Complete |
| Adoption portal | Future backlog |

**Growth metric:** time required for a new team to discover, clone, configure, and run the toolkit.

### 6. Enterprise governance maturity

| Metric | Current target |
|---|---|
| Project-level rules | Current model |
| Central rules pattern documented | Complete |
| Override file model | Documented |
| Override schema | Future backlog |
| Effective rules generator | Complete |
| Exception expiration enforcement | Future backlog |

**Growth metric:** number of projects using governed baseline + exception model without forking full rule files.

### 7. Evidence and telemetry

| Metric | Current target |
|---|---|
| Generated artifacts | Yes |
| Pipeline pass/fail results | Yes |
| Adoption metrics dashboard | Complete |
| Tool usage telemetry | Future backlog, optional and privacy-aware |
| Before/after delivery metrics | Future backlog |

**Growth metric:** ability to show adoption, quality improvement, and reduced release friction over time.

## Maturity model

| Level | Name | Characteristics |
|---:|---|---|
| 1 | Reference | Docs, sample pipelines, and workshop material exist |
| 2 | Toolkit | Reusable tools, scripts, rules, and setup guides exist |
| 3 | Repeatable | Sparse clone profiles, platform guides, and delivery guides make onboarding consistent |
| 4 | Governed | Baseline rules, exception model, manifests, readiness checks, and PR summaries support governance |
| 5 | Measured | Adoption, rule coverage, exception aging, release quality, and time-to-onboard are tracked |

## Suggested scoring worksheet

| Pillar | Score 0-5 | Evidence | Improvement backlog |
|---|---:|---|---|
| Platform neutrality | 4 | Three platform folders, setup guides, shared assets, parity matrix, and pipeline generator exist | Add automated parity tests |
| BI-specific quality gates | 4 | PBIP validation, report rules, dataset rules, branch-aware prep, exceptions, and coverage matrix | Add deeper dependency impact analysis |
| No-code governance tooling | 4 | Fifteen static tools exist across standards, review, release, governance, adoption, impact analysis, and differentiation | Add deeper inventory and certification tools |
| Release readiness and reviewability | 4 | Manifest builder, readiness scanner, PBIP diff viewer, dependency impact analyzer, PR summary, and release dashboard exist | Add branch strategy and environment mapping guidance |
| Enterprise adoption model | 4 | Datasheet, delivery guide, sparse clone guide, social assets | Add adoption portal |
| Enterprise governance maturity | 3 | Central rules pattern, override model, exception register, and effective rules generator exist | Add override schema and exception expiration enforcement |
| Evidence and telemetry | 3 | Pipeline outputs, release readiness, adoption metrics, rule coverage, and differentiation metrics exist | Add optional tool usage telemetry and before/after quality trends |

## Recommended implementation sequence

The next roadmap items should prioritize features that strengthen the clearest differentiators: reviewer productivity, enterprise governance, platform neutrality, and measurable adoption.

| Priority | Recommendation | Why it matters |
|---:|---|---|
| 1 | Branch Strategy Wizard | Recommends branch policy, environment mapping, PR requirements, and protected branch rules |
| 2 | Environment Parameter Mapper | Documents Dev/Test/Prod connection strings, workspace IDs, lakehouse or warehouse references, and semantic model bindings |
| 3 | Workspace Promotion Planner | Creates release manager guidance for workspace stages, approval gates, ownership, and rollback |
| 4 | Semantic Model Inventory Explorer | Extracts model metadata into catalog artifacts that governance and reviewers can inspect |
| 5 | Measure Documentation Generator | Turns DAX measures, descriptions, dependencies, and owners into a steward-ready catalog |
| 6 | Report UX Review Checklist Builder | Standardizes accessibility, navigation, tooltip, theme, mobile, and layout review |
| 7 | Certification Readiness Checker | Validates trusted semantic model ownership, support, documentation, endorsement, and release-readiness evidence |
| 8 | Sensitivity & Data Classification Checklist | Captures classification, sensitivity labels, PII indicators, sharing restrictions, and endorsement state |

After these items, the roadmap can shift toward certification, security classification, adoption portal polish, and deeper enterprise quality rules governance.

## Differentiator statements

Use these in presentations, datasheets, blog posts, and stakeholder conversations.

### Short version

Enterprise BI DevOps with Microsoft Fabric is not just a CI/CD pipeline. It is a platform-neutral operating model for governed Power BI and Fabric delivery.

### Technical version

The solution combines PBIP-aware validation, branch-aware quality rules, DAX test metadata, deployment manifests, readiness scanning, and no-code governance tools across Azure DevOps, GitHub Actions, and GitLab CI/CD.

### Executive version

The solution helps teams reduce analytics release risk by standardizing how Power BI and Fabric changes are reviewed, validated, governed, and promoted.

### Enterprise version

The long-term pattern enables central baseline rules with project-level exceptions, allowing organizations to standardize governance without blocking legitimate solution-specific needs.

## Gap-to-backlog mapping

| Gap | Backlog item |
|---|---|
| Hard to compare pipeline parity across platforms | CI/CD Platform Parity Matrix |
| No formal exception lifecycle artifact | Policy Exception Register |
| No automated rule-to-policy mapping | Rule Coverage Matrix |
| No generated pull request summary | PR Quality Summary Generator |
| No consolidated readiness dashboard | Release Readiness Dashboard |
| No central baseline + override implementation | Effective Rules Generator |
| No adoption metrics | Adoption Metrics Dashboard |
| No external/public solution comparison artifact | Competitive Differentiation Matrix |
| Hard to review raw PBIP JSON and TMDL changes | PBIP Diff Viewer |
| Hard to understand downstream impact of changed model objects | Dependency Impact Analyzer |
| Hard to generate platform-specific pipeline files consistently | Pipeline Config Generator |
| Hard to choose branch policy and workspace mapping consistently | Branch Strategy Wizard |

