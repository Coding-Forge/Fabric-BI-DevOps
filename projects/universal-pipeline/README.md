# Universal Fabric CI Pipeline

A reusable Azure DevOps YAML template for validating, testing, and publishing **Microsoft Fabric PBIP artifacts** across any number of project repos.

## Repository layout

This folder is designed to be hosted as its own ADO Git repository — `fabric-pipeline-templates` — that all Fabric project repos reference.

```
fabric-pipeline-templates/
├── templates/
│   └── fabric-ci.yml            ← parameterized pipeline template
├── scripts/
│   └── Prepare-QualityRules.ps1 ← branch-aware rule preparation
├── tests/
│   ├── validate_pbip_structure.py
│   └── run_dax_tests.py
├── consumer-azure-pipelines.yml ← copy-paste starting point for new repos
└── README.md                    ← this file
```

---

## How it works

Each Fabric project repo contains a small `azure-pipelines.yml` that:

1. Declares a `resources.repositories` reference to this templates repo
2. Uses `extends:` to pull in `templates/fabric-ci.yml`
3. Passes only the parameters that differ from defaults

The template handles three stages: **Validate → Test → Publish**.  
Scripts and tests run from this templates repo so changes propagate to all consumers automatically.

---

## Setting up a new project repo

### 1. Grant repo access in ADO

In Azure DevOps: **Project Settings → Repositories → fabric-pipeline-templates → Security**  
Grant the build service identity for each consumer project **Read** access.

### 2. Copy the consumer stub

Copy `consumer-azure-pipelines.yml` into the root of the project repo and rename it `azure-pipelines.yml`.

### 3. Edit the two required values

```yaml
resources:
  repositories:
    - repository: fabric-pipeline-templates
      type: git
      name: MyOrg/fabric-pipeline-templates   # ← your ADO org/project name
      ref: refs/heads/main                    # ← or pin to refs/tags/v1.0
```

### 4. Set parameters

| Parameter | Default | Purpose |
|---|---|---|
| `pbipPath` | `pbip-local` | Folder where PBIP artifacts live locally (not committed) |
| `projectRoot` | `.` | Repo root offset — change if PBIP rules live in a subfolder |
| `pythonVersion` | `3.11` | Python version for test jobs |
| `rulesDatasetPath` | _(auto)_ | Custom path to `Rules-Dataset.json` if not at repo root |
| `rulesReportPath` | _(auto)_ | Custom path to `Rules-Report.json` if not at repo root |
| `skipDatasetRules` | `false` | Set `true` to skip Tabular Editor validation |
| `skipReportRules` | `false` | Set `true` to skip PBI Inspector validation |
| `skipDaxTests` | `false` | Set `true` to skip DAX unit tests |
| `skipPublish` | `false` | Set `true` to skip artifact publishing |

### 5. Add project-specific rules (optional)

Place `Rules-Dataset.json` and/or `Rules-Report.json` in the project repo root.  
If absent, the pipeline falls back to the community default rule sets automatically.

### 6. Place local PBIP artifacts

PBIP artifacts are **not committed** to project repos. Place them locally under the path configured in `pbipPath` (default: `pbip-local`):

```
my-sales-report/
├── azure-pipelines.yml
├── Rules-Dataset.json
├── Rules-Report.json
└── pbip-local/                  ← gitignored
    ├── MySalesReport.pbip
    ├── MySalesReport.Report/
    └── MySalesReport.SemanticModel/
```

---

## Versioning the template

When introducing breaking changes, tag a release before merging:

```bash
git tag v1.1
git push origin v1.1
```

Consumer repos that have pinned to `refs/tags/v1.0` are unaffected until they opt in.

To update a consumer to the new version, change their `ref:` line:

```yaml
ref: refs/tags/v1.1
```

---

## Minimal consumer example (full file)

```yaml
trigger:
  branches:
    include:
      - main
      - feature/*

pr:
  branches:
    include:
      - main

pool:
  vmImage: 'windows-2022'

resources:
  repositories:
    - repository: fabric-pipeline-templates
      type: git
      name: MyOrg/fabric-pipeline-templates
      ref: refs/tags/v1.0

extends:
  template: templates/fabric-ci.yml@fabric-pipeline-templates
  parameters:
    pbipPath: 'pbip-local'
    skipDaxTests: true           # this project has no DAX tests yet
```

---

## Extending with new Fabric artifact types

To support Fabric items beyond PBIP (Notebooks, Lakehouses, Dataflows Gen2, etc.):

1. Add a new optional parameter to `templates/fabric-ci.yml`, e.g. `validateNotebooks: false`
2. Wrap the new job in a conditional block: `${{ if eq(parameters.validateNotebooks, true) }}`
3. Consumer repos opt in by passing `validateNotebooks: true`

This keeps the template backward-compatible — existing consumers are unaffected.
