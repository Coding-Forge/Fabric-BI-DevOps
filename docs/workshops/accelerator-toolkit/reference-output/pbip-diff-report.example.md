# PBIP Diff Report

Generated from the workshop PBIP before/after snapshots.

- Before files: 42
- After files: 45
- Changed files: 5
- Added files: 3
- Removed files: 0

## Category summary

- Semantic model: 2 changed
- Report page: 1 changed
- Report visual: 2 changed
- DAX tests: 1 added
- Deployment manifest: 1 added
- Governance asset: 1 added

## Review focus

### Sales Performance.SemanticModel/definition/model.tmdl

- Status: changed
- Category: Semantic model
- Review `Revenue`, `Gross Margin`, and `Gross Margin %` with the semantic model owner.
- Confirm safe division is used for percentage measures.
- Confirm changed measures are covered by DAX test metadata.

### Sales Performance.Report/definition/pages/Executive Overview/page.json

- Status: changed
- Category: Report page
- Review page title, visual density, navigation, filters, and mobile layout.

### shared/dax-tests.json

- Status: added
- Category: DAX tests
- Confirm test owners, expected values, severity, and enabled state.

### shared/deployment-manifest.json

- Status: added
- Category: Deployment manifest
- Confirm workspace names, approval gates, and rollback plan.

