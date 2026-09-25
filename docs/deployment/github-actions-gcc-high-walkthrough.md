# GitHub Actions deployment walkthrough for commercial Fabric and GCC High

This walkthrough shows how to deploy a PBIP project from GitHub Actions using the accelerator workflow.

**Critical permission requirement:** **The service principal must be added to the target Power BI/Fabric workspace as Admin or Member. It must have write permissions to the workspace. Viewer is not sufficient.**

## Deployment behavior by cloud

| Target cloud | Validated source | Deployed artifact | API path |
|---|---|---|---|
| Commercial Fabric | PBIP | PBIP semantic model/report definitions | Fabric REST APIs |
| GCC High | PBIP | Checked-in PBIX | Power BI REST `imports` API |

**GCC High caveat:** **GCC High validates PBIP but deploys PBIX. Commit the PBIP, matching PBIX, and `deployment-manifest.json` together.**

## 1. Create the GitHub project repo

Create or open the test clone made with the GitHub sparse profile.

Expected folders:

```text
.github\
shared\
docs\
tools\
images\
```

The GitHub sparse profile should include only this workflow:

```text
.github\workflows\powerbi-ci.yml
```

Add your GitHub repo as `origin` if needed:

```powershell
git remote add origin https://github.com/<org>/<repo>.git
git push -u origin main
```

## 2. Add the PBIP project

Place the Power BI Project under:

```text
shared\pbip-local\
```

Expected shape:

```text
shared\pbip-local\
  <ProjectName>.pbip
  <ProjectName>.Report\
  <ProjectName>.SemanticModel\
```

## 3. For GCC High, save the PBIX beside the PBIP

Open the PBIP in Power BI Desktop and save a PBIX into the same folder:

```text
shared\pbip-local\<ProjectName>.pbix
```

Commercial Fabric does not require this PBIX for PBIP definition deployment.

## 4. For GCC High, generate or refresh the manifest

Run this after saving the PBIX:

```powershell
.\shared\scripts\New-PbixDeploymentManifest.ps1 `
  -PbipPath .\shared\pbip-local `
  -PbixFile .\shared\pbip-local\<ProjectName>.pbix
```

Validate it:

```powershell
.\shared\scripts\New-PbixDeploymentManifest.ps1 `
  -PbipPath .\shared\pbip-local `
  -ValidateOnly
```

The script writes `shared\pbip-local\deployment-manifest.json` and refreshes:

```json
"artifacts": {
  "pbixFile": "<ProjectName>.pbix",
  "pbixSha256": "...",
  "pbipSourceSha256": "...",
  "pbixGeneratedUtc": "...",
  "pbixGeneratedBy": "Power BI Desktop"
}
```

You can also open `tools\deployment-manifest-builder\index.html`, load the manifest, complete owner/environment metadata, and use **Save in place**.

## 5. Commit the project artifacts

For commercial:

```powershell
git add shared\pbip-local
git commit -m "Add PBIP project"
```

For GCC High:

```powershell
git add shared\pbip-local
git commit -m "Add GCC High PBIP and PBIX deployment package"
```

**For GCC High, do not commit PBIP changes without committing the matching PBIX and `deployment-manifest.json`.**

## 6. Confirm the workflow

The workflow must exist at:

```text
.github\workflows\powerbi-ci.yml
```

It runs:

```text
Validate PBIP -> Dataset rules -> Report rules -> DAX tests -> Publish artifacts -> Deploy
```

## 7. Configure GitHub Actions secrets

In GitHub:

```text
Settings -> Secrets and variables -> Actions -> Secrets
```

Required secrets:

```text
TENANT_ID
APP_ID
CLIENT_SECRET
DEV_WORKSPACE_ID
```

Recommended for Dev deployment:

```text
DEV_WORKSPACE_ID=<workspace GUID>
```

`DEV_WORKSPACE_NAME` is optional when `DEV_WORKSPACE_ID` is set.

## 8. Configure GitHub Actions variables

In GitHub:

```text
Settings -> Secrets and variables -> Actions -> Variables
```

Optional commercial defaults:

```text
AUTHORITY_HOST=https://login.microsoftonline.com
FABRIC_API_BASE_URI=https://api.fabric.microsoft.com/v1
FABRIC_API_SCOPE=https://api.fabric.microsoft.com/.default
```

GCC High:

```text
AUTHORITY_HOST=https://login.microsoftonline.us
FABRIC_API_BASE_URI=https://api.high.powerbigov.us/v1
FABRIC_API_SCOPE=https://high.analysis.usgovcloudapi.net/powerbi/api/.default
```

Optional skip variables:

```text
PBIP_CI_SKIP_DATASET_RULES=false
PBIP_CI_SKIP_REPORT_RULES=false
PBIP_CI_SKIP_DAX_TESTS=false
PBIP_CI_SKIP_PUBLISH=false
```

## 9. Confirm service principal workspace access

Before running deployment, add the service principal to the target workspace.

**Required:** **Admin or Member role. The service principal must have write permissions to create/update/import content. Viewer is not sufficient.**

For GCC High PBIX import, using `DEV_WORKSPACE_ID` avoids workspace-name lookup and is preferred.

## 10. Run the workflow

Push to `main`, or run manually:

```text
Actions -> Power BI CI/CD -> Run workflow
```

Commercial success signals:

```text
GCC High deployment: False
Deploying PBIP project from: ...
Fabric PBIP deployment completed.
```

GCC High success signals:

```text
GCC High deployment: True
Deploying PBIX artifact from: ...
Power BI PBIX deployment completed.
```

## Troubleshooting

| Symptom | Resolution |
|---|---|
| `AADSTS900023` | `TENANT_ID` is not a valid tenant GUID/domain. Use the raw tenant GUID. |
| `Gitleaks` runs in a project repo | Remove unrelated parent workflows; only `.github/workflows/powerbi-ci.yml` should be present. |
| Dataset rules fail on sample numeric columns | Ensure `shared\Rules-Dataset.json` is committed. |
| GCC High uses Fabric REST instead of PBIX import | Confirm the GCC High endpoint variables are set exactly. |
| Manifest validation fails | Regenerate `deployment-manifest.json` after saving the PBIX. |
| Workspace write fails | Confirm the service principal is Admin or Member in the workspace. |
