---
title: "Lab 5 — PBIP Review, Diff, and Impact Analysis"
lab: 5
duration: "75 minutes"
---

# Lab 5 — PBIP Review, Diff, and Impact Analysis

## Overview

In this lab you will prepare a PBIP change for review. You will create a deployment manifest, scan readiness, compare before/after snapshots, analyze dependency impact, and generate a PR summary.

## Tools used

1. Deployment Manifest Builder
2. PBIP Project Readiness Scanner
3. PBIP Diff Viewer
4. Dependency Impact Analyzer
5. PR Quality Summary Generator

## Scenario

The Sales Performance Analytics team is changing the `Revenue` and `Gross Margin %` measures and updating an executive overview page. Reviewers need to understand what changed, what may be impacted, and whether the PR is ready.

## Part 1 — Create a deployment manifest

1. Open:

   ```text
   tools/deployment-manifest-builder/index.html
   ```

2. Scan the PBIP folder if available, or create a starter manifest manually.
3. Capture:

   | Field | Workshop value |
   |---|---|
   | Solution name | Sales Performance Analytics |
   | Business owner | Sales Operations |
   | Technical owner | BI Platform Team |
   | Dev workspace | `WS-Dev-Sales` |
   | Test workspace | `WS-Test-Sales` |
   | Prod workspace | `WS-Prod-Sales` |
   | Required gates | PBIP validation, report rules, dataset rules, DAX metadata, PR review |
   | Rollback | Revert PR and redeploy last approved artifact |

4. Export:

   ```text
   deployment-manifest.json
   deployment-summary.md
   ```

## Part 2 — Scan PBIP readiness

1. Open:

   ```text
   tools/pbip-readiness-scanner/index.html
   ```

2. Select the PBIP project folder.
3. Review findings for:

   - Exactly one `.pbip` file
   - `.Report` and `.SemanticModel` folders
   - Required `definition.*` files
   - Rule files
   - DAX test metadata
   - Manifest and exception files
   - CI/CD platform files

4. Export:

   ```text
   PBIP-Readiness-Report.md
   pbip-readiness-report.json
   ```

## Part 3 — Compare before and after snapshots

1. Open:

   ```text
   tools/pbip-diff-viewer/index.html
   ```

2. Select the before folder and after folder.
3. Filter by:

   - Semantic model
   - Report page
   - Report visual
   - DAX tests
   - Deployment manifest

4. Confirm the report identifies:

   - Changed measures
   - Changed report page metadata
   - Added or modified governance/test files

5. Export:

   ```text
   pbip-diff-report.html
   pbip-diff-report.md
   pbip-diff-report.json
   ```

## Part 4 — Analyze dependency impact

1. Open:

   ```text
   tools/dependency-impact-analyzer/index.html
   ```

2. Load the PBIP project folder.
3. Enter changed objects:

   ```text
   Revenue
   Gross Margin %
   Sales[Amount]
   ```

4. Review impacted:

   - Measures
   - Relationships
   - Visuals
   - Report pages
   - DAX tests
   - Deployment or governance assets

5. Export:

   ```text
   dependency-impact-report.html
   dependency-impact-report.md
   dependency-impact-report.json
   ```

## Part 5 — Generate a PR quality summary

1. Open:

   ```text
   tools/pr-quality-summary-generator/index.html
   ```

2. Paste:

   - Changed file paths
   - Pipeline or validation log
   - Readiness scanner output
   - DAX test summary
   - Deployment manifest summary
   - Diff and impact analysis notes

3. Generate and export:

   ```text
   PR-Quality-Summary.md
   pr-quality-summary.json
   ```

## Expected result

Your PR package should tell reviewers:

- What changed
- Which validations passed
- Which artifacts are missing or risky
- Which semantic model objects are impacted
- Which report pages and visuals need regression review
- Whether the PR is ready for approval or needs follow-up

Compare your outputs with:

```text
docs/workshops/accelerator-toolkit/reference-output/deployment-manifest.example.json
docs/workshops/accelerator-toolkit/reference-output/pbip-diff-report.example.md
docs/workshops/accelerator-toolkit/reference-output/dependency-impact-report.example.md
docs/workshops/accelerator-toolkit/reference-output/pr-quality-summary.example.md
```

## Validation checklist

- [ ] Deployment manifest captures owners, environments, gates, and rollback
- [ ] Readiness report identifies required PBIP and governance assets
- [ ] Diff report separates added, removed, and changed artifacts
- [ ] Impact report traces changed objects to downstream items
- [ ] PR summary is reviewer-ready and includes risks/checklist items


