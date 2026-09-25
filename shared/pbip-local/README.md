# Local PBIP Folder (Not Committed)

Place your own Power BI Project artifacts in this folder when running the workshop locally.

Examples of local files/folders you can place here:
- <your-project>.pbip
- <your-project>.pbix
- <your-project>.Report/
- <your-project>.SemanticModel/

These artifacts are project-specific. Keep this parent toolkit folder lightweight, and commit PBIP/PBIX artifacts in the consuming project repo when that repo is intended to run deployment. For GCC High PBIX import deployment, save the PBIX next to the PBIP project, generate `deployment-manifest.json` with `shared/scripts/New-PbixDeploymentManifest.ps1`, and commit the PBIP, PBIX, and manifest together in the consuming repo.

The parent repository keeps reusable CI assets only:
- `Rules-Dataset.json`
- `Rules-Report.json`
- `scripts/`
- `tests/`
- `azdo/azure-pipelines.yml`
