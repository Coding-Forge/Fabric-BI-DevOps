# Rules Authoring Guide for Reports and Datasets

This guide explains how to create, tune, and maintain quality rules for this PBIP repository.
It covers both rule engines used in CI:

- Dataset rules: `Rules-Dataset.json` (Tabular Editor BPA format)
- Report rules: `Rules-Report.json` (PBI Inspector format)

## Why This Matters

Good rules make quality checks consistent across pull requests, reduce production defects, and keep reports usable at scale.

In this repo, rules are automatically applied in `azure-pipelines.yml` during the `Validate` stage.

## Quick Start

1. For enterprise policy setup, open `tools/enterprise-standards-builder/index.html` and choose the standards profile to generate rule JSON.
2. For individual rule editing, open `tools/rule-designer/index.html` and load the existing rule JSON files.
3. Copy an existing rule or use a designer template instead of starting from scratch.
4. Keep each rule focused on one concern.
5. Start as non-blocking (`warning` / lower severity), then promote after cleanup.
6. Validate changes in a branch before promoting strictness on `main`.

## No-Code Governance Tools

This repository includes two static HTML tools under `tools/`.

| Tool | Best For | When to Use |
|---|---|---|
| `tools/enterprise-standards-builder/index.html` | BI leads, governance owners, report creators | Start here when defining enterprise settings, guides, and policies. It generates `Rules-Report.json`, `Rules-Dataset.json`, a reusable policy profile, and a review summary. |
| `tools/rule-designer/index.html` | Platform team and advanced BI developers | Use this when tuning a specific rule, creating a custom PBI Inspector report rule, or creating a custom Tabular Editor BPA dataset rule. |

For screenshots, demo flow, and positioning language, see [Fabric BI DevOps Accelerator Tools](governance/power-bi-governance-tools.md).

Recommended governance workflow:

1. Use the Enterprise Standards Builder to select the policy posture: advisory, standard, or strict.
2. Download the generated report and dataset rule files.
3. Review the generated JSON in a branch.
4. Use the Quality Rule Designer only for advanced customizations or exceptions.
5. Commit the final `Rules-Report.json` and `Rules-Dataset.json` under `shared/`.

## Dataset Rules (`Rules-Dataset.json`)

Dataset rules are a JSON array where each object is one BPA rule.

### Recommended Rule Shape

```json
{
  "ID": "UPPER_SNAKE_CASE_ID",
  "Name": "[Category] Human-friendly title",
  "Category": "Performance",
  "Description": "One sentence: what this catches and why.",
  "Severity": 2,
  "Scope": "Measure, CalculatedColumn",
  "Expression": "boolean expression returning true when violated",
  "FixExpression": "optional automatic fix",
  "CompatibilityLevel": 1200
}
```

### Dataset Fields and Guidance

- `ID`: Stable unique identifier. Never recycle IDs for different behavior.
- `Name`: Put category in brackets for readability in tool output.
- `Category`: Grouping for triage and reporting.
- `Description`: Explain business impact, not just technical behavior.
- `Severity`: Higher number is stricter in this repo's pipeline filter.
- `Scope`: Comma-separated object types where the expression should run.
- `Expression`: Return `true` when the rule should trigger.
- `FixExpression`: Optional auto-remediation when safe and deterministic.
- `CompatibilityLevel`: Keep at `1200` unless your model/tooling requires change.

### Severity Strategy for Dataset Rules

Pipeline behavior is branch-aware via `scripts/Prepare-QualityRules.ps1`:

- On `main` and `develop`: rules with `Severity >= 2` are enforced.
- On feature branches: only `Severity >= 3` are enforced.

Practical usage:

- Use `3` for must-fix, high-confidence issues.
- Use `2` for important standards you want enforced on protected integration branches.
- Use `1` for advisory or gradual adoption.

## Report Rules (`Rules-Report.json`)

Report rules are an object with a top-level `rules` array.

### Recommended Rule Shape

```json
{
  "id": "UPPER_SNAKE_CASE_ID",
  "name": "Human-friendly title",
  "description": "One sentence: what this protects and why.",
  "logType": "warning",
  "itemType": "Report",
  "part": "Pages",
  "disabled": false,
  "test": [
    { "<=": [ { "count": [ { "part": "Pages" } ] }, 6 ] },
    {},
    true
  ]
}
```

### Report Fields and Guidance

- `id`: Stable unique identifier.
- `name`: Short action-oriented phrase.
- `description`: Include user-impact language.
- `logType`: `warning` or `error`.
- `itemType`: Usually `Report` in this repository.
- `part`: Optional context segment (`Pages`, `Visuals`, `ReportExtensions`, etc.).
- `disabled`: Keep `true` for experimental/noisy rules.
- `test`: JSON logic expression with expected result.

### Branch-Aware Behavior for Report Rules

The preparation script applies policy by branch:

- Ensures every rule has `logType` (defaults to `warning` if missing).
- Promotes selected warning rules to `error` on `main` and `develop`.
- Keeps those same rules as `warning` on feature branches.

This supports progressive hardening without blocking early cleanup work.

## Authoring Patterns That Work Well

### 1) Keep Rules Atomic

Write one rule per concern.

Good:

- "Visible measures must have format strings"
- "Pages should not exceed six"

Avoid:

- "All formatting and naming standards" in one rule

### 2) Prefer Deterministic Logic

Rules should produce the same result for the same artifact every run.
Avoid checks that rely on unstable strings or generated IDs unless necessary.

### 3) Minimize False Positives

Use scoped filters and explicit exclusions (for example textboxes, hidden pages, or helper visuals) where appropriate.

### 4) Add Safe Auto-Fixes Carefully

Use `FixExpression` only when the change is always safe and reversible.
Do not auto-fix semantic choices that require modeler intent.

## Naming Conventions

Use these conventions for consistency:

- Dataset `ID`: `UPPER_SNAKE_CASE`
- Dataset `Name`: `[Category] Message`
- Report `id`: `UPPER_SNAKE_CASE`
- Categories: reuse existing buckets (`Performance`, `Error Prevention`, `DAX Expressions`, `Formatting`) unless a new one is clearly needed.

## Suggested Rule Lifecycle

1. Draft rule as advisory (`Severity: 1` or `logType: warning`).
2. Run pipeline and review noise/false positives.
3. Refine scope/logic.
4. Promote strictness (`Severity: 2+` or `logType: error`) once clean.
5. Document rationale in pull request notes.

## Validation Workflow in This Repo

- Structural validation: `tests/validate_pbip_structure.py`
- Dataset rule execution: Tabular Editor in `azure-pipelines.yml`
- Report rule execution: PBI Inspector in `azure-pipelines.yml`
- DAX test metadata validation: `tests/run_dax_tests.py` reads `dax-tests.json` and emits JUnit results

If you want to test quickly before pushing:

```powershell
python tests/validate_pbip_structure.py --pbip-path "."
```

## Review Checklist for New or Changed Rules

- Rule has a stable and unique ID.
- Description explains the business impact.
- Scope is tight enough to avoid noise.
- Severity/log type matches intended enforcement level.
- Rule passes with expected output in CI.
- Any disabled rule has a reason and follow-up owner.

## Common Pitfalls

- Over-broad regex that catches valid expressions.
- Blocking too early before backlog cleanup.
- Mixing multiple concerns into one complicated rule.
- Depending on report internals that change frequently.

## Example Promotion Plan

Use a staged rollout for a new quality standard:

1. Add rule as advisory.
2. Fix most violations in active artifacts.
3. Keep temporary exceptions disabled with comments in PR.
4. Promote to blocking on `main`.

This keeps quality direction clear without stopping delivery.
