---
title: "Lab 4 — Standards, Rules, and Policy Authoring"
lab: 4
duration: "75 minutes"
---

# Lab 4 — Standards, Rules, and Policy Authoring

## Overview

In this lab you will create the policy and quality-rule foundation for a PBIP solution. You will define an enterprise quality posture, tune one rule, create DAX test metadata, and map governance policies to automated and manual checks.

## Tools used

1. Enterprise Standards Builder
2. Quality Rule Designer
3. DAX Test Builder
4. Rule Coverage Matrix

## Scenario

Your team is onboarding a PBIP solution named **Sales Performance Analytics**. The BI lead wants a standard policy profile that starts with enforceable basics while leaving advanced cleanup advisory until the team has remediated existing reports.

## Part 1 — Create an enterprise policy profile

1. Open:

   ```text
   tools/enterprise-standards-builder/index.html
   ```

2. Choose the **Enterprise standard** profile.
3. Set the policy intent:

   | Area | Workshop value |
   |---|---|
   | Report usability | Enforce readable page names and reasonable visual density |
   | Visual standards | Warn on missing axis titles and inconsistent theme usage |
   | Semantic model quality | Enforce hidden technical keys and safe relationship data types |
   | DAX standards | Warn on unsafe division and missing format strings |
   | Lifecycle posture | Advisory for pilot branches, stricter for protected branches |

4. Export or copy the policy profile and rule files.
5. Save participant outputs as:

   ```text
   enterprise-policy-profile.json
   Rules-Report.json
   Rules-Dataset.json
   ```

## Part 2 — Tune a specific quality rule

1. Open:

   ```text
   tools/rule-designer/index.html
   ```

2. Load the generated `Rules-Report.json`.
3. Find or create a visual density rule.
4. Set the workshop behavior:

   | Field | Value |
   |---|---|
   | Rule ID | `report-page-visual-density` |
   | Severity | `warning` on feature branches |
   | Protected branch severity | `error` |
   | Rationale | High visual density increases review and accessibility risk |

5. Export the updated rule file.
6. Record why the severity is appropriate for a pilot team.

## Part 3 — Define DAX test metadata

1. Open:

   ```text
   tools/dax-test-builder/index.html
   ```

2. Create test metadata for the following measures:

   | Measure | Test intent | Assertion |
   |---|---|---|
   | `Revenue` | Critical KPI should not return blank for the current fiscal year | `notBlank` |
   | `Gross Margin %` | Margin percentage should stay within a valid business range | `between 0 and 1` |
   | `Order Count` | Reconciliation count should be non-negative | `greaterThanOrEqual 0` |

3. Assign an owner and severity to each test.
4. Export:

   ```text
   dax-tests.json
   dax-test-catalog.md
   ```

## Part 4 — Map policy coverage

1. Open:

   ```text
   tools/rule-coverage-matrix/index.html
   ```

2. Add at least six policy rows:

   | Policy | Coverage type |
   |---|---|
   | Report pages must use business-readable names | Automated report rule |
   | Critical KPI measures must have DAX test metadata | Automated DAX metadata check |
   | Production semantic models must have an owner | Manual release check |
   | Exceptions must expire | Automated exception register review |
   | Dataset technical keys should be hidden | Automated dataset rule |
   | Visual density must be reviewed before release | Automated report rule plus manual UX review |

3. Export:

   ```text
   rule-coverage-matrix.json
   rule-coverage-matrix.md
   ```

## Expected result

Your lab output should explain:

- What the team's enterprise quality posture is
- Which rules are advisory vs blocking
- Which DAX measures have test metadata
- Which policies are automated and which still require manual review

Compare your outputs with:

```text
docs/workshops/accelerator-toolkit/reference-output/enterprise-policy-profile.example.json
docs/workshops/accelerator-toolkit/reference-output/rule-coverage-matrix.example.json
```

## Validation checklist

- [ ] Policy profile exists and has a clear enforcement posture
- [ ] At least one rule was tuned and rationale was recorded
- [ ] DAX test metadata includes owner, severity, expected behavior, and measure name
- [ ] Rule coverage matrix distinguishes automated checks from manual checks
- [ ] Outputs are saved in the participant working folder


