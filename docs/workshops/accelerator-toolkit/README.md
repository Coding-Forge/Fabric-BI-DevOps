---
title: "Fabric BI DevOps Accelerator Toolkit Workshop"
description: "Hands-on workshop for using the no-code accelerator tools to create policies, rules, review artifacts, pipeline configuration, release evidence, and governance outputs."
---

# Fabric BI DevOps Accelerator Toolkit Workshop

This workshop teaches teams how to use the browser-based accelerator tools in `tools/` to create the operational artifacts needed for governed PBIP delivery.

The workshop complements the core Fabric Git workshop. The core workshop teaches workspace Git integration, branching, CI/CD, and deployment pipeline fundamentals. This toolkit workshop teaches how to use the accelerator tools to produce rules, policies, review evidence, pipeline setup, and governance outputs that support that operating model.

## Who should attend

| Role | Why attend |
|---|---|
| BI lead | Define standards, release expectations, certification readiness, and adoption goals |
| Report creator | Self-check PBIP readiness, understand diffs, and prepare PR handoffs |
| Semantic model owner | Define DAX tests, inspect dependency impact, and document model risk |
| Platform engineer | Generate CI/CD YAML and validate platform parity |
| Governance owner | Track policy coverage, exceptions, adoption, and differentiation |
| Release manager | Create manifests, readiness evidence, and promotion recommendations |

## Workshop outcomes

By the end of the workshop, participants will have created a complete starter package for a sample PBIP solution:

- Enterprise policy profile and rule files
- Tuned report/dataset rule example
- DAX test metadata
- Deployment manifest
- PBIP readiness report
- PBIP diff report
- Dependency impact report
- Generated CI/CD pipeline profile and YAML
- PR quality summary
- Policy exception register
- Effective rules summary
- Platform parity matrix
- Release readiness recommendation
- Adoption metrics
- Rule coverage matrix
- Competitive differentiation matrix

Use the files under [`reference-output/`](reference-output/README.md) as the final product to compare participant work against.

## Recommended agenda

| Module | Duration | Lab | Focus |
|---|---:|---|---|
| 1 | 75 min | [Lab 4 — Standards, Rules, and Policy Authoring](labs/lab4-standards-rules-policy.md) | Enterprise Standards Builder, Quality Rule Designer, DAX Test Builder, Rule Coverage Matrix |
| 2 | 75 min | [Lab 5 — PBIP Review, Diff, and Impact Analysis](labs/lab5-review-readiness-impact.md) | Deployment Manifest Builder, PBIP Readiness Scanner, PBIP Diff Viewer, Dependency Impact Analyzer, PR Quality Summary Generator |
| 3 | 90 min | [Lab 6 — Pipeline, Release, Exceptions, and Adoption](labs/lab6-pipeline-release-governance.md) | Pipeline Config Generator, Policy Exception Register, Effective Rules Generator, Platform Parity Matrix, Release Readiness Dashboard, Adoption Metrics Dashboard, Competitive Differentiation Matrix |
| 4 | 30 min | Reference review | Compare participant outputs against `reference-output/` |

## Setup

1. Clone or open this repository locally.
2. Open the tool launchpad:

   ```text
   tools/index.html
   ```

3. Use a local PBIP sample project. For demos, the existing walkthrough assumes:

   ```text
   C:\Projects\Enterprise-Fabric\shared
   ```

4. Keep generated workshop files in a participant working folder, for example:

   ```text
   C:\Temp\Fabric-BI-DevOps-Workshop\<alias>\
   ```

5. Compare your outputs with:

   ```text
   docs/workshops/accelerator-toolkit/reference-output/
   ```

## Facilitation guidance

- Have participants work in pairs: one BI-focused participant and one platform/governance-focused participant.
- Treat generated artifacts as reviewable source files, not throwaway exports.
- Encourage participants to explain why they chose each rule severity, exception status, branch policy, and release recommendation.
- End each lab with a comparison against the reference outputs and a short discussion of what would change for the participant's real environment.

## Tool-to-artifact map

| Tool | Workshop artifact |
|---|---|
| Enterprise Standards Builder | `enterprise-policy-profile.example.json`, generated rule files |
| Quality Rule Designer | tuned rule entry or override rationale |
| DAX Test Builder | DAX test catalog entry |
| Deployment Manifest Builder | `deployment-manifest.example.json` |
| PBIP Project Readiness Scanner | readiness findings and remediation list |
| PBIP Diff Viewer | `pbip-diff-report.example.md` |
| Dependency Impact Analyzer | `dependency-impact-report.example.md` |
| Pipeline Config Generator | `pipeline-profile.example.json`, `azure-pipelines.generated.example.yml` |
| PR Quality Summary Generator | `pr-quality-summary.example.md` |
| Policy Exception Register | `policy-exceptions.example.json` |
| Effective Rules Generator | effective rules summary |
| CI/CD Platform Parity Matrix | platform parity notes |
| Release Readiness Dashboard | `release-readiness-dashboard.example.md` |
| Adoption Metrics Dashboard | `adoption-metrics.example.json` |
| Rule Coverage Matrix | `rule-coverage-matrix.example.json` |
| Competitive Differentiation Matrix | `competitive-differentiation-matrix.example.json` |


