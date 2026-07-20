# Pipeline Setup Notes

- Platform: Azure DevOps
- Recommended file path: `azure-pipelines.yml`
- Project root: `shared`
- PBIP path: `shared/pbip-local`
- Enabled capabilities: validation, dataset rules, report rules, DAX test metadata, artifact publish, Dev deployment, feature deployment

## Required runners

- Linux runner for PBIP validation, DAX metadata tests, and artifact publishing.
- Windows runner for Tabular Editor, Fab Inspector, and deployment steps.

## Required variables and secrets

- `TenantId`
- `AppId`
- `ClientSecret`
- `DEV_WORKSPACE_NAME`
- `FeatureWorkspacePrefix`

## Review checklist

- Confirm paths match the target repository layout.
- Confirm branch triggers match the team's branching strategy.
- Confirm protected branch policy requires this pipeline before merge.
- Confirm deployment secrets are masked/protected and scoped to approved branches.

