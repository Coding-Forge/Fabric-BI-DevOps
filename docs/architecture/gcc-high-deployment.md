# GCC High deployment behavior

This accelerator supports Azure DevOps and GitHub Actions CI/CD for Power BI PBIP projects in commercial Fabric and GCC High, but the deployment behavior is intentionally different.

## Critical behavior difference

**GCC High does not use Fabric PBIP definition deployment in this accelerator. GCC High validates the PBIP source, then deploys a checked-in PBIX with the older Power BI REST `imports` API using `CreateOrOverwrite`.**

Commercial Fabric deployment keeps the native PBIP path:

```text
PBIP source -> validation gates -> Fabric REST create/update semantic model and report
```

GCC High deployment uses the guarded PBIX path:

```text
PBIP source -> validation gates -> manifest validation -> Power BI REST PBIX import/overwrite
```

## Why GCC High is different

In GCC High tenants, service-principal calls to Fabric semantic model item APIs may return `PrincipalTypeNotSupported`, including create/update operations such as:

```text
POST https://api.high.powerbigov.us/v1/workspaces/{workspaceId}/semanticModels/{semanticModelId}/updateDefinition
```

The Power BI REST import endpoint is the supported fallback pattern for this accelerator:

```text
POST https://api.high.powerbigov.us/v1.0/myorg/groups/{workspaceId}/imports
```

## Required GCC High artifacts

**For GCC High, users must commit all three artifacts together:**

1. **PBIP source files** under the configured PBIP path.
2. **The matching PBIX file** saved from Power BI Desktop.
3. **`deployment-manifest.json`** generated after the PBIX is saved.

The manifest must sit next to the PBIX and PBIP source, for example:

```text
shared/pbip-local/
|-- <project>.pbip
|-- <project>.Report/
|-- <project>.SemanticModel/
|-- <project>.pbix
`-- deployment-manifest.json
```

Generate the manifest with:

```powershell
.\shared\scripts\New-PbixDeploymentManifest.ps1 `
  -PbipPath .\shared\pbip-local `
  -PbixFile .\shared\pbip-local\<project>.pbix
```

The manifest uses the same toolkit deployment-manifest schema produced by the Deployment Manifest Builder. The hash script creates the manifest if it does not exist, or updates the PBIX/hash fields in an existing toolkit manifest. The required GCC High fields live under `artifacts`:

```json
{
  "version": 1,
  "solution": {
    "name": "<project>",
    "criticality": "medium"
  },
  "artifacts": {
    "pbipFile": "<project>.pbip",
    "reportPath": "<project>.Report",
    "semanticModelPath": "<project>.SemanticModel",
    "pbixFile": "<project>.pbix",
    "pbixSha256": "<PBIX file hash>",
    "pbipSourceSha256": "<PBIP source hash>",
    "pbixGeneratedUtc": "<UTC timestamp>",
    "pbixGeneratedBy": "Power BI Desktop"
  }
}
```

You can load this same `deployment-manifest.json` in `tools/deployment-manifest-builder/index.html` to complete ownership, environment, approval, rollback, and release metadata. Rerun `New-PbixDeploymentManifest.ps1` after saving a new PBIX; it preserves the broader toolkit manifest and refreshes the hash fields.

## Pipeline enforcement

**GCC High deployment fails before import if the manifest is missing, stale, points to a missing PBIX, or the PBIX/source hashes do not match.**

The pipeline enforces this before calling the Power BI REST import API:

```powershell
.\shared\scripts\New-PbixDeploymentManifest.ps1 `
  -PbipPath .\shared\pbip-local `
  -ValidateOnly
```

## Endpoint variables

For GCC High, configure the deployment variables with the GCC High endpoint set:

```text
AuthorityHost=https://login.microsoftonline.us
FabricApiBaseUri=https://api.high.powerbigov.us/v1
FabricApiScope=https://high.analysis.usgovcloudapi.net/powerbi/api/.default
```

The script derives the older Power BI REST base URI from `FabricApiBaseUri`:

```text
https://api.high.powerbigov.us/v1.0/myorg
```

## Summary

| Cloud target | Validated source | Deployed artifact | Deployment API |
|---|---|---|---|
| Commercial Fabric | PBIP | PBIP definitions | Fabric REST item APIs |
| GCC High | PBIP | PBIX from manifest | Power BI REST imports API |

**Do not assume GCC High pushes PBIP definitions directly. For GCC High, PBIP is the governed source and PBIX is the deployable package.**
