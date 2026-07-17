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
| Branch-aware rule enforcement | Rare | Conceptual | Sometimes | Yes |
| Report quality rules | Sometimes | Conceptual | Sometimes | Yes |
| Dataset quality rules | Sometimes | Conceptual | Sometimes | Yes |
| DAX test metadata | Rare | No | Rare | Yes |
| Deployment manifest | Rare | Conceptual | Rare | Yes |
| Pre-PR readiness scanner | Rare | No | Rare | Yes |
| No-code rule/tool builders | Rare | No | Rare | Yes |
| Toolkit-only sparse clone | Rare | No | Rare | Yes |
| Workshop delivery materials | Rare | Yes | Sometimes | Yes |
| Social/adoption content | No | Sometimes | Sometimes | Yes |
| Published HTML/PDF article package | No | Sometimes | Rare | Yes |
| Enterprise rules override model | Rare | Conceptual | Rare | Planned/documented |

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
| CI/CD behavior parity documented across platforms | Needs improvement |
| Automated tests prove parity across platforms | Future backlog |

**Growth metric:** number of supported CI/CD platforms with documented and tested parity.

### 2. BI-specific quality gates

| Metric | Current target |
|---|---|
| PBIP structure validation | Yes |
| Report quality rules | Yes |
| Dataset quality rules | Yes |
| Branch-aware severity/promotion | Yes |
| Rule exception register | Future backlog |
| Rule coverage matrix | Future backlog |

**Growth metric:** percentage of governance policies covered by automated rules or documented manual checks.

### 3. No-code governance tooling

| Metric | Current target |
|---|---|
| Enterprise Standards Builder | Complete |
| Quality Rule Designer | Complete |
| DAX Test Builder | Complete |
| Deployment Manifest Builder | Complete |
| PBIP Readiness Scanner | Complete |
| Project Exception Designer | Future backlog |

**Growth metric:** number of governance artifacts a non-developer can generate without editing JSON.

### 4. Release readiness and reviewability

| Metric | Current target |
|---|---|
| Deployment manifest | Complete |
| Readiness scanner | Complete |
| PR quality summary | Future backlog |
| Release readiness dashboard | Future backlog |
| Dependency impact analyzer | Future backlog |

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
| Effective rules generator | Future backlog |
| Exception expiration enforcement | Future backlog |

**Growth metric:** number of projects using governed baseline + exception model without forking full rule files.

### 7. Evidence and telemetry

| Metric | Current target |
|---|---|
| Generated artifacts | Yes |
| Pipeline pass/fail results | Yes |
| Adoption metrics dashboard | Future backlog |
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
| Platform neutrality | 3 | Three platform folders and setup guides exist | Add parity tests and support matrix |
| BI-specific quality gates | 3 | PBIP validation, report rules, dataset rules, branch-aware prep | Add rule coverage matrix and exception register |
| No-code governance tooling | 4 | Five static tools exist | Add project exception designer |
| Release readiness and reviewability | 3 | Manifest builder and readiness scanner exist | Add PR summary and release dashboard |
| Enterprise adoption model | 4 | Datasheet, delivery guide, sparse clone guide, social assets | Add adoption portal |
| Enterprise governance maturity | 2 | Central rules pattern documented | Add override schema and effective rules generator |
| Evidence and telemetry | 1 | Pipeline outputs exist | Add adoption metrics and quality trend dashboard |

## Recommended implementation sequence

The next roadmap items should prioritize features that strengthen the clearest differentiators: reviewer productivity, enterprise governance, platform neutrality, and measurable adoption.

| Priority | Recommendation | Why it matters |
|---:|---|---|
| 1 | PR Quality Summary Generator | Turns pipeline output into a reviewer-friendly artifact and makes the solution feel complete during pull request review |
| 2 | Policy Exception Register | Adds enterprise-grade exception lifecycle management with owner, reason, approval, and expiration |
| 3 | Effective Rules Generator | Implements the central baseline + profile + project override model and prevents projects from forking full rule files |
| 4 | CI/CD Platform Parity Matrix | Makes platform-neutrality measurable across Azure DevOps, GitHub Actions, and GitLab CI/CD |
| 5 | Release Readiness Dashboard | Consolidates validation, rules, tests, manifest, exceptions, and deployment target into a release-facing view |
| 6 | Adoption Metrics Dashboard | Provides growth metrics for projects onboarded, rule maturity, exception aging, and time-to-onboard |
| 7 | Rule Coverage Matrix | Connects enterprise policies to automated rules and manual checks, strengthening governance credibility |
| 8 | Competitive Differentiation Matrix | Makes external and internal comparison explicit for sellers, delivery leads, and stakeholders |

After these items, the roadmap can shift toward deeper analysis tools such as PBIP diffing, dependency impact, semantic model inventory, and measure documentation.

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

