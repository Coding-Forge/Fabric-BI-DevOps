# Dependency Impact Report

Generated from the workshop PBIP project.

- Changed objects: `Revenue`, `Gross Margin %`, `Sales[Amount]`
- Model objects: 14
- Measures: 6
- Visual references: 5
- Impacted items: 8

## Impacted items

- Measure: `Revenue` — direct reference to `Sales[Amount]`; validate non-blank and reconciliation tests.
- Measure: `Gross Margin` — references `Revenue`; validate margin calculation with Finance SME.
- Measure: `Gross Margin %` — references `Gross Margin` and `Revenue`; validate safe division and expected range.
- Relationship: `Sales[CustomerKey] -> Customer[CustomerKey]` — verify relationship still supports regional visuals.
- Visual: `Executive Overview / Revenue KPI` — references `Revenue`; regression review required.
- Visual: `Executive Overview / Margin Trend` — references `Gross Margin %`; regression review required.
- DAX test: `Revenue is not blank for current fiscal year` — update expected filter context if model grain changed.
- Deployment manifest: critical measure list references `Revenue` and `Gross Margin %`; confirm owners and gates.

## Recommended review procedure

1. Validate changed measures in Desktop or semantic-link test execution.
2. Run DAX metadata validation in CI.
3. Review impacted visuals in the feature workspace.
4. Attach this report to the PR or summarize it in the PR Quality Summary Generator.

