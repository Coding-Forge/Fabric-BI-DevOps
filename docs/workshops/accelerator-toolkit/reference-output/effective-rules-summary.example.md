# Effective Rules Summary

## Branch context

- Source branch: `feature/sales-quality-pilot`
- Target branch: `main`
- Enforcement posture: strict target branch with one approved temporary report exception

## Inputs

- Baseline report rules: `Rules-Report.json`
- Baseline dataset rules: `Rules-Dataset.json`
- Exceptions: `policy-exceptions.json`
- Overrides: none for this lab

## Effective report rules

- `report-page-business-name`: enabled, severity `error`
- `report-page-visual-density`: enabled, severity `warning` for `Sales Performance.Report/Executive Overview` due to `EXC-SALES-001`
- `report-axis-title-required`: enabled, severity `warning`

## Effective dataset rules

- `dataset-hide-technical-keys`: enabled, severity `error`
- `dataset-relationship-data-types`: enabled, severity `error`
- `dax-safe-division`: enabled, severity `warning`
- `measure-format-string`: enabled, severity `warning`

## Governance notes

- The visual density exception must expire on or before `2026-09-03`.
- No expired exceptions are allowed for promotion to Prod.
- Protected branches should fail on report or dataset `error` severity findings.

