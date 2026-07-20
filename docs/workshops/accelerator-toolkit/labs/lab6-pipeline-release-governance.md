---
title: "Lab 6 — Pipeline, Release, Exceptions, and Adoption"
lab: 6
duration: "90 minutes"
---

# Lab 6 — Pipeline, Release, Exceptions, and Adoption

## Overview

In this lab you will complete the operating model around a PBIP release. You will generate CI/CD YAML, record policy exceptions, produce effective rules, compare platform parity, assess release readiness, track adoption, and position the solution.

## Tools used

1. Pipeline Config Generator
2. Policy Exception Register
3. Effective Rules Generator
4. CI/CD Platform Parity Matrix
5. Release Readiness Dashboard
6. Adoption Metrics Dashboard
7. Competitive Differentiation Matrix

## Scenario

The Sales Performance Analytics pilot is ready to move from individual authoring to team CI/CD. The platform team needs a pipeline, the governance owner needs exception control, and the BI lead needs a release recommendation.

## Part 1 — Generate CI/CD configuration

1. Open:

   ```text
   tools/pipeline-config-generator/index.html
   ```

2. Select **Azure DevOps** for the workshop baseline.
3. Configure:

   | Field | Workshop value |
   |---|---|
   | Project root | `shared` |
   | PBIP path | `shared/pbip-local` |
   | Python version | `3.11` |
   | Deploy script path | `shared/scripts/deploy-dynamic.ps1` |
   | Branches | `main`, `develop`, `feature/*` |
   | Enabled stages | Validation, dataset rules, report rules, DAX tests, publish artifact, Dev deployment |

4. Review setup notes for:

   - Windows runner requirement
   - Linux runner jobs
   - Required deployment secrets
   - Branch policy recommendation

5. Export:

   ```text
   azure-pipelines.generated.yml
   pipeline-profile.json
   pipeline-setup-notes.md
   ```

## Part 2 — Register a policy exception

1. Open:

   ```text
   tools/policy-exception-register/index.html
   ```

2. Create one temporary exception:

   | Field | Workshop value |
   |---|---|
   | Exception ID | `EXC-SALES-001` |
   | Rule ID | `report-page-visual-density` |
   | Status | `approved` |
   | Owner | Sales BI Lead |
   | Approver | Governance Owner |
   | Affected artifact | `Sales.Report/Executive Overview` |
   | Expiration | 45 days from workshop date |
   | Mitigation | Redesign page and split dense visuals into detail pages |

3. Export:

   ```text
   policy-exceptions.json
   policy-exceptions-summary.md
   ```

## Part 3 — Generate effective rules

1. Open:

   ```text
   tools/effective-rules-generator/index.html
   ```

2. Load:

   - `Rules-Report.json`
   - `Rules-Dataset.json`
   - Optional override JSON
   - `policy-exceptions.json`

3. Set source branch:

   ```text
   feature/sales-quality-pilot
   ```

4. Set target branch:

   ```text
   main
   ```

5. Export:

   ```text
   Rules-Report.effective.json
   Rules-Dataset.effective.json
   effective-rules-summary.md
   ```

## Part 4 — Compare CI/CD platform parity

1. Open:

   ```text
   tools/platform-parity-matrix/index.html
   ```

2. Compare:

   - PBIP validation
   - Dataset rules
   - Report rules
   - DAX metadata tests
   - Artifact publishing
   - Dev deployment
   - Feature workspace deployment

3. Mark each platform as supported, partial, planned, or gap.
4. Export:

   ```text
   platform-parity-matrix.json
   platform-parity-matrix.md
   ```

## Part 5 — Assess release readiness

1. Open:

   ```text
   tools/release-readiness-dashboard/index.html
   ```

2. Paste or summarize:

   - Pipeline log
   - PR quality summary
   - PBIP readiness output
   - Deployment manifest
   - Policy exceptions
   - Effective rules
   - DAX test summary

3. Generate the readiness recommendation.
4. Export:

   ```text
   release-readiness-dashboard.html
   release-readiness-dashboard.md
   release-readiness-dashboard.json
   ```

## Part 6 — Track adoption and differentiation

1. Open:

   ```text
   tools/adoption-metrics-dashboard/index.html
   ```

2. Add one project row for Sales Performance Analytics.
3. Track:

   - Platform
   - Owner
   - Readiness score
   - Rule maturity
   - Exceptions
   - Time-to-onboard

4. Open:

   ```text
   tools/competitive-differentiation-matrix/index.html
   ```

5. Score this solution against:

   - Generic CI/CD sample
   - Best-practice deck
   - Internal one-off accelerator
   - Enterprise BI DevOps with Microsoft Fabric

## Expected result

Your release package should provide:

- A platform-specific pipeline file
- Required setup/secrets guidance
- Exception register
- Effective rules output
- Platform parity notes
- Release recommendation
- Adoption metrics
- Differentiation evidence

Compare your outputs with:

```text
docs/workshops/accelerator-toolkit/reference-output/azure-pipelines.generated.example.yml
docs/workshops/accelerator-toolkit/reference-output/pipeline-profile.example.json
docs/workshops/accelerator-toolkit/reference-output/policy-exceptions.example.json
docs/workshops/accelerator-toolkit/reference-output/effective-rules-summary.example.md
docs/workshops/accelerator-toolkit/reference-output/platform-parity-matrix.example.json
docs/workshops/accelerator-toolkit/reference-output/release-readiness-dashboard.example.md
docs/workshops/accelerator-toolkit/reference-output/adoption-metrics.example.json
docs/workshops/accelerator-toolkit/reference-output/competitive-differentiation-matrix.example.json
```

## Validation checklist

- [ ] Pipeline YAML includes validation, quality, test, publish, and deploy stages
- [ ] Required secrets and runner requirements are documented
- [ ] Policy exception has owner, approver, expiration, and mitigation
- [ ] Effective rules reflect branch policy and approved exceptions
- [ ] Release readiness recommendation is evidence-based
- [ ] Adoption and differentiation outputs support executive or program review


