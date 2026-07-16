# Fabric BI DevOps Accelerator Tools

This repository includes two no-code browser tools that help teams turn enterprise Power BI standards into CI/CD quality gates without asking report authors to hand-edit JSON.

Use these tools to support:

- Enterprise Power BI onboarding
- Governance workshops
- Report factory enablement
- Pull request quality standards
- Reusable policy profiles for departments, domains, or solution teams

## Value Proposition

Enterprise Power BI quality standards often fail when they live only in documents. These tools make standards actionable by converting policy decisions into the same rule files used by the pipeline:

- `shared/Rules-Report.json` for PBI Inspector report checks
- `shared/Rules-Dataset.json` for Tabular Editor BPA dataset checks

The result is a governance workflow that is easier to explain, easier to adopt, and easier to enforce through Git-based delivery.

## Tool Overview

Start from the central launchpad:

```text
tools/index.html
```

| Tool | Primary Audience | Use Case | Output |
|---|---|---|---|
| **Fabric BI DevOps Accelerator Launchpad** | All users | Pick the right tool and follow the recommended workflow | Tool links, workflow guidance, artifact map |
| **Enterprise Standards Builder** | BI leads, governance owners, report creators | Select enterprise policies and generate standard rule files | `Rules-Report.json`, `Rules-Dataset.json`, policy profile, summary |
| **Quality Rule Designer** | Platform team, advanced BI developers | Tune individual rules or create custom report/dataset checks | Updated rule JSON files |
| **DAX Test Builder** | BI developers, semantic model owners | Define measure-level DAX test metadata consumed by the pipeline runner | `dax-tests.json`, test catalog Markdown |
| **PBIP Project Readiness Scanner** | Report creators, platform team | Scan a local PBIP repo or project folder before PR | Readiness Markdown report, JSON report |

## Enterprise Standards Builder

Open:

```text
tools/enterprise-standards-builder/index.html
```

The Enterprise Standards Builder is the recommended starting point for most teams. It lets users choose a governance posture, adjust policy controls, and generate pipeline-ready quality rules.

![Enterprise Standards Builder](../../images/Enterprise-standards-builder.png)

### What It Helps Users Do

- Choose a policy profile: **Advisory adoption**, **Enterprise standard**, **Strict enterprise gate**, or **Custom**
- Configure report usability standards such as page count, visual density, page names, and vertical scrolling
- Configure visual standards such as theme colors and axis titles
- Configure semantic model and DAX standards such as format strings, safe division, hidden foreign keys, and relationship data types
- Preserve custom rules already present in existing rule files
- Export an auditable policy profile and summary for review

### Best Fit

Use this tool when the conversation starts with questions like:

- "What should our enterprise Power BI standard be?"
- "How strict should our CI checks be?"
- "How do we make report teams follow governance policies?"
- "How do we generate baseline rules for a new solution?"

## Quality Rule Designer

Open:

```text
tools/rule-designer/index.html
```

The Quality Rule Designer is the advanced companion tool. It is useful when a team needs to modify one rule, create a custom rule, or inspect the generated JSON before committing it.

![Guided Rule Builder](../../images/GuidedRuleBuilder.png)

### What It Helps Users Do

- Load existing `Rules-Report.json` and `Rules-Dataset.json` files
- Create report rules from guided templates
- Create dataset rules from Tabular Editor BPA templates
- Create custom PBI Inspector report rules
- Create custom Tabular Editor BPA dataset rules
- Preview generated JSON and diffs before download
- Preview PBIP report folder structure for page and visual counts

### Best Fit

Use this tool when the conversation starts with questions like:

- "Can we tune this one rule?"
- "Can we add a custom report check?"
- "Why is this rule failing?"
- "Can we lower the severity while the team cleans up violations?"

## DAX Test Builder

Open:

```text
tools/dax-test-builder/index.html
```

The DAX Test Builder captures measure-level validation scenarios in a structured `dax-tests.json` file. A starter catalog is available at `shared/dax-tests.json` with generally accepted DAX test patterns such as non-blank critical measures, non-negative totals, percentage ranges, reconciliation checks, time-intelligence sanity checks, and no-data slice behavior. The repository DAX runner reads this catalog, validates enabled test metadata, and emits JUnit results. Actual DAX query execution is still represented as skipped until semantic-link-labs, XMLA, or Tabular Editor scripting is wired in.

The starter tests are disabled by default because every semantic model has different measure names, table names, filter contexts, and expected values. Teams should customize and enable them as part of model onboarding.

### What It Helps Users Do

- Define measure test cases with owner, scenario, filter context, expected result, assertion type, severity, and tags
- Generate a DAX query preview for each test case
- Bulk import simple test shells from CSV
- Load and customize the starter `shared/dax-tests.json` catalog
- Export `dax-tests.json` for future CI integration
- Export a Markdown test catalog for PR and governance review

### Best Fit

Use this tool when the conversation starts with questions like:

- "What measure outcomes should we validate before release?"
- "Can we define DAX unit tests without editing Python?"
- "Can we document test coverage for certified semantic models?"
- "Can we make DAX validation portable across Azure DevOps, GitHub, and GitLab?"

## PBIP Project Readiness Scanner

Open:

```text
tools/pbip-readiness-scanner/index.html
```

The PBIP Project Readiness Scanner checks a local repository or PBIP project folder before a pull request. It runs entirely in the browser and does not upload files anywhere.

### What It Helps Users Do

- Confirm exactly one `.pbip` file is present
- Detect `.Report` and `.SemanticModel` folders
- Validate key report and semantic model references such as `definition.pbir`, `definition/report.json`, `definition.pbism`, and `definition/model.tmdl`
- Check for governance assets such as `Rules-Report.json`, `Rules-Dataset.json`, `dax-tests.json`, policy profiles, and exception registers
- Check for Azure DevOps, GitHub Actions, or GitLab CI pipeline files
- Export a Markdown PR-readiness report and a machine-readable JSON report

### Best Fit

Use this tool when the conversation starts with questions like:

- "Is this PBIP project ready for PR?"
- "What is missing before CI runs?"
- "Can a report author self-check before pushing?"
- "Do we have the governance and pipeline assets wired up?"

## Recommended Governance Workflow

1. Define the enterprise posture in the **Enterprise Standards Builder**.
2. Download the generated `Rules-Report.json`, `Rules-Dataset.json`, and policy profile.
3. Review the generated policy summary with the BI lead or governance owner.
4. Use the **Quality Rule Designer** only for advanced tuning or custom checks.
5. Use the **DAX Test Builder** to define measure-level tests for critical business calculations.
6. Run the **PBIP Project Readiness Scanner** before opening the PR.
7. Commit the final rule files and `dax-tests.json` under `shared/`.
8. Validate the prepared effective rules locally or through CI.
9. Promote stricter settings after false positives and adoption gaps are resolved.

## Marketing Positioning

Use the following summary in presentations, internal announcements, or workshop collateral:

> The Fabric BI DevOps Accelerator turns standards into action. Instead of asking report creators to read policy documents and hand-edit JSON, teams can choose enterprise-ready settings in a browser, generate the exact rule files used by CI/CD, and enforce consistent report and semantic model quality through Git-based delivery.

## Suggested Demo Flow

1. Open the Enterprise Standards Builder.
2. Switch between **Advisory**, **Enterprise standard**, and **Strict** profiles to show how enforcement changes.
3. Adjust a visible setting such as maximum report pages or maximum visuals per page.
4. Show the generated report and dataset JSON.
5. Download the policy summary and explain how it can be attached to a PR or governance review.
6. Open the Quality Rule Designer and show how an advanced user can tune one rule.
7. Open the DAX Test Builder and show how a semantic model owner can define a critical measure test.
8. Open the PBIP Project Readiness Scanner and show the PR-ready Markdown report.

## Related Docs

- [Rules Authoring Guide](../Rules-Authoring-Guide.md)
- [Governance Checklist](governance-checklist.md)
- [Local Validation Guide](../Local-Validation-Guide.md)
- [CI/CD Architecture](../architecture/cicd-architecture.md)

