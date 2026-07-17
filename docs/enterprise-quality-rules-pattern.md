# Enterprise Quality Rules Pattern

This document captures the recommended long-term pattern for organizations that want consistent Power BI and Fabric quality rules across many projects while still allowing controlled exceptions.

The current toolkit can remain project-controlled. Each project may keep its own `Rules-Report.json` and `Rules-Dataset.json` while teams learn the rule set, tune thresholds, and build confidence. The enterprise pattern below is the suggested ultimate goal for mature organizations.

## Recommended end state

The optimal enterprise model is a centrally governed rules package with local override layers.

```text
Enterprise baseline rules
        +
Business unit or domain overrides
        +
Project-specific exceptions
        =
Effective rules used by CI
```

In this model, projects do not copy and independently edit the complete enterprise rule files. Instead, they consume a versioned baseline and declare narrow, auditable exceptions.

## Suggested repository structure

```text
quality-rules/
  baseline/
    Rules-Report.json
    Rules-Dataset.json
  profiles/
    advisory.json
    standard.json
    strict.json
  schemas/
    quality-rules.override.schema.json

project-repo/
  quality-rules.override.json
```

The enterprise baseline should live in a central repository owned by the BI platform, governance, or Fabric enablement team. Project repositories should contain only project-specific override metadata.

## Rule resolution flow

The CI pipeline should prepare the effective rules before validation:

```text
Resolve enterprise baseline
Apply selected profile
Apply approved domain overrides
Apply project exceptions
Write Rules-Report.effective.json and Rules-Dataset.effective.json
Run PBI Inspector and Tabular Editor BPA
```

The generated effective files are the only files passed to validation tools. Source baseline files remain untouched.

## Example project override file

```json
{
  "profile": "standard",
  "reportRuleOverrides": [
    {
      "id": "REDUCE_OBJECTS_WITHIN_VISUALS",
      "owner": "finops-bi-team",
      "reason": "Certified FinOps matrix visuals require many projected fields.",
      "expiresOn": "2026-12-31",
      "changes": {
        "threshold": 100
      }
    },
    {
      "id": "ENSURE_THEME_COLOURS",
      "owner": "finops-bi-team",
      "reason": "Legacy report migration; theme cleanup is tracked separately.",
      "expiresOn": "2026-09-30",
      "changes": {
        "logType": "warning"
      }
    }
  ],
  "disabledRules": [
    {
      "id": "ACTIVE_PAGE",
      "owner": "finops-bi-team",
      "reason": "Not reliable for generated PBIP exports.",
      "expiresOn": "2026-09-30"
    }
  ]
}
```

Project overrides should be declarative. They should describe the intended exception, not duplicate the entire rule JSON.

## Governance controls

Enterprise pipelines should enforce basic controls around exceptions:

- Every override must include an owner, reason, and expiration date.
- Expired exceptions should fail the pipeline or revert to the enterprise baseline.
- Critical rules should not be disabled without approval metadata.
- Override files should be schema validated.
- The pipeline should publish the effective rules and exception summary as build artifacts.
- Pull request summaries should call out new, changed, or expired exceptions.

## Versioned consumption

Projects should consume the central rule package by version. For Azure DevOps, a project pipeline could reference a central rules or templates repository:

```yaml
resources:
  repositories:
    - repository: fabricQuality
      type: git
      name: Enterprise/Fabric-Quality-Rules
      ref: refs/tags/v1.3.0
```

This lets governance publish new standards while project teams upgrade intentionally.

## Tooling direction

The HTML tooling should eventually separate two experiences:

| Tool | Audience | Purpose |
|---|---|---|
| Enterprise Rules Designer | Governance and platform owners | Maintain baseline rules, profiles, and promotion behavior |
| Project Exception Designer | Project teams | Create narrow override files with owner, reason, expiration, and approval metadata |

The current project-level tools remain useful. The enterprise pattern should be treated as a future maturity step, not a required starting point.

## Why this pattern is preferred

This approach gives organizations:

- Consistent baseline standards across projects.
- Central ownership of rule intent and severity.
- Project flexibility for legitimate special cases.
- Versioned adoption instead of surprise rule changes.
- Auditable exceptions with expiration.
- Cleaner project repositories that do not fork the entire ruleset.
- A path to stricter enforcement as teams mature.

