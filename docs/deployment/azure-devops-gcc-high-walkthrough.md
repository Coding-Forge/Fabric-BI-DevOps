# Azure DevOps deployment walkthrough for commercial Fabric and GCC High

This walkthrough shows how to deploy a PBIP project from Azure DevOps using the accelerator pipeline.

**Critical permission requirement:** **The service principal must be added to the target Power BI/Fabric workspace as Admin or Member. It must have write permissions to the workspace. Viewer is not sufficient.**

## Deployment behavior by cloud

| Target cloud | Validated source | Deployed artifact | API path |
|---|---|---|---|
| Commercial Fabric | PBIP | PBIP semantic model/report definitions | Fabric REST APIs |
| GCC High | PBIP | Checked-in PBIX | Power BI REST `imports` API |

**GCC High caveat:** **GCC High validates PBIP but deploys PBIX. Commit the PBIP, matching PBIX, and `deployment-manifest.json` together.**

## 1. Create the Azure DevOps project repo

Create or open the test clone made with the Azure DevOps sparse profile.

Expected folders:

```text
azdo/
shared/
docs/
tools/
images/
```

Add your Azure DevOps repo as `origin` if needed:

```powershell
git remote add origin https://dev.azure.com/<org>/<project>/_git/<repo>
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

## 6. Create the Azure DevOps pipeline

Create a new Azure DevOps pipeline using:

```text
azdo/azure-pipelines.yml
```

The pipeline runs:

```text
Validate -> Test -> Publish -> Deploy_Dev or Deploy_Feature
```

## 7. Configure variable group

Create or update the variable group:

```text
pbip-shared-secrets
```

Required values:

```text
TenantId
AppId
ClientSecret
DevWorkspaceId
FeatureWorkspacePrefix
```

Recommended for Dev deployment:

```text
DevWorkspaceId=<workspace GUID>
```

`DevWorkspaceName` is optional when `DevWorkspaceId` is set.

## 8. Configure cloud endpoint variables

Commercial Fabric can use defaults:

```text
AuthorityHost=https://login.microsoftonline.com
FabricApiBaseUri=https://api.fabric.microsoft.com/v1
FabricApiScope=https://api.fabric.microsoft.com/.default
```

GCC High:

```text
AuthorityHost=https://login.microsoftonline.us
FabricApiBaseUri=https://api.high.powerbigov.us/v1
FabricApiScope=https://high.analysis.usgovcloudapi.net/powerbi/api/.default
```

## 9. Confirm service principal workspace access

Before running deployment, add the service principal to the target workspace.

**Required:** **Admin or Member role. The service principal must have write permissions to create/update/import content. Viewer is not sufficient.**

For GCC High PBIX import, using `DevWorkspaceId` avoids workspace-name lookup and is preferred.

## 10. Run the pipeline

Run the full pipeline from `main`.

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
| `AADSTS900023` | `TenantId` is not a valid tenant GUID/domain. Use the raw tenant GUID. |
| Dataset rules fail on sample numeric columns | Ensure `shared\Rules-Dataset.json` is committed. |
| GCC High uses Fabric REST instead of PBIX import | Confirm the GCC High endpoint variables are set exactly. |
| Manifest validation fails | Regenerate `deployment-manifest.json` after saving the PBIX. |
| Workspace write fails | Confirm the service principal is Admin or Member in the workspace. |
