---
marp: true
theme: default
paginate: true
style: |
  section {
    font-family: "Segoe UI", sans-serif;
    background-color: #ffffff;
    color: #1a1a1a;
  }
  section.lead {
    background-color: #0f5132;
    color: #ffffff;
    text-align: center;
  }
  section.lead h1, section.lead h2 { color: #ffffff; }
  section.lead p { color: #d1e7dd; }
  h2 { color: #0f5132; border-bottom: 3px solid #0f5132; padding-bottom: 0.2em; }
  table { width: 100%; font-size: 0.80em; }
  th { background-color: #0f5132; color: #ffffff; }
  td { color: #1a1a1a; }
  tr:nth-child(even) td { background-color: #f0f0f0; }
  section.dark th { background-color: #0a3d24; color: #ffffff; }
  section.dark td { color: #e8e8e8; }
  section.dark tr:nth-child(even) td { background-color: rgba(255,255,255,0.1); }
  section.step td { color: #1a1a1a; }
  section.step tr:nth-child(even) td { background-color: #e8e8e8; }
  code { background-color: #f0fff4; color: #1a1a1a; border-radius: 4px; padding: 2px 5px; }
  pre { background-color: #1a1a2e; border-radius: 6px; }
  pre code { background-color: transparent; color: #c9d1d9; font-size: 0.85em; }
  section.dark {
    background-color: #1a1a2e;
    color: #ffffff;
  }
  section.dark h2 { color: #75c99a; border-color: #75c99a; }
  section.step { background-color: #f8f9fa; }
  section.step h2 { color: #0f5132; }
---
<!-- class: lead -->

# 🧪 Lab 2
## CI Pipeline & Workspace Sync for PBIP

**Duration: 60 minutes**
`13:45 – 14:45`

_Validate · Test · Publish · Sync_

---

## Lab 2 Objectives

By the end of this lab you will have:

1. Created `azure-pipelines.yml` in the repo root
2. Configured branch **triggers** for `main` and `feature/*`
3. Added PBIP **schema validation** using `pbi-tools`
4. Added **DAX unit test** execution with JUnit output
5. Published **build artifacts**
6. Set the pipeline as a **required status check** on `main`
7. Synced the Dev workspace using **Approach A** (manual portal)
8. Synced the Dev workspace using **Approach B** (REST API automation)

---

## Pipeline Stages Overview

| Stage | Runs On | Purpose |
|-------|---------|---------|
| **Validate** | Every push / PR | Schema validation + lint |
| **Test** | After Validate | DAX unit tests |
| **Publish** | After Test | Upload `pbip-artifacts` |
| **SyncFabricDev** | `main` only | REST API workspace sync |

---
<!-- class: step -->

## Part 1 — Create the Feature Branch

```bash
git fetch origin
git checkout -b feature/<alias>-lab2 origin/main
git push -u origin feature/<alias>-lab2
```

Or in Azure DevOps:
```
Repos → Branches → New branch
  Name:   feature/<alias>-lab2
  Based on: main
```

Connect your personal workspace (`WS-Dev-<alias>`) to this branch before proceeding.

---
<!-- class: step -->

## Part 2 — Create azure-pipelines.yml

Create `/azure-pipelines.yml` at the **repo root**:

```yaml
trigger:
  branches:
    include:
      - main
      - feature/*

pool:
  vmImage: 'windows-latest'

variables:
  fabricWorkspacePath: 'fabric-workspace'
```

---
<!-- class: dark -->

## Part 2 — Validate Stage

```yaml
stages:
  - stage: Validate
    displayName: 'Validate PBIP'
    jobs:
      - job: ValidatePBIP
        displayName: 'Schema Validation + Lint'
        steps:
          - task: UsePythonVersion@0
            inputs:
              versionSpec: '3.11'

          - script: pip install pbi-tools pbip-lint
            displayName: 'Install tools'

          - script: |
              pbi-tools validate --input $(fabricWorkspacePath)
            displayName: 'pbi-tools validate'

          - script: |
              pbip-lint --path $(fabricWorkspacePath) --config .pbiplintrc.json
            displayName: 'pbip-lint'
```

---
<!-- class: dark -->

## Part 2 — Test & Publish Stages

```yaml
  - stage: Test
    displayName: 'DAX Unit Tests'
    dependsOn: Validate
    jobs:
      - job: DaxTests
        steps:
          - script: |
              python tests/run_dax_tests.py --model-path $(fabricWorkspacePath)
            displayName: 'Run DAX tests'

          - task: PublishTestResults@2
            inputs:
              testResultsFormat: 'JUnit'
              testResultsFiles: '**/test-results.xml'

  - stage: Publish
    dependsOn: Test
    jobs:
      - job: PublishArtifacts
        steps:
          - task: PublishBuildArtifacts@1
            inputs:
              pathToPublish: '$(fabricWorkspacePath)'
              artifactName: 'pbip-artifacts'
```

---
<!-- class: dark -->

## Part 2 — SyncFabricDev Stage

```yaml
  - stage: SyncFabricDev
    displayName: 'Sync Fabric Dev Workspace'
    dependsOn: Publish
    condition: >
      and(succeeded(),
          eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - job: TriggerFabricSync
        steps:
          - task: AzureKeyVault@2
            inputs:
              azureSubscription: 'fabric-keyvault-connection'
              KeyVaultName: 'kv-fabricci'
              SecretsFilter: 'FABRIC-SP-ID,FABRIC-SP-SECRET,FABRIC-TENANT-ID,FABRIC-WORKSPACE-ID'

          - script: python scripts/sync_fabric_workspace.py
            displayName: 'Call Fabric updateFromGit API'
            env:
              SP_ID: $(FABRIC-SP-ID)
              SP_SECRET: $(FABRIC-SP-SECRET)
              TENANT_ID: $(FABRIC-TENANT-ID)
              WORKSPACE_ID: $(FABRIC-WORKSPACE-ID)
```

---
<!-- class: step -->

## Part 3 — Create the Pipeline in Azure DevOps

1. Go to **Pipelines → New pipeline**
2. Choose **Azure Repos Git**
3. Select your repository
4. Choose **Existing Azure Pipelines YAML file**
5. Path: `/azure-pipelines.yml`
6. Click **Run** — the pipeline should trigger and run all stages

> ✅ Checkpoint: All 4 stages show green in ADO Pipelines.

---
<!-- class: step -->

## Part 4 — Set Pipeline as a Required Status Check

1. Go to **Repos → Branches** → find `main` → **Branch policies**
2. Under **Build validation**, click **+ Add build policy**
3. Select your new pipeline
4. Set: **Required** (not optional)
5. Trigger: **Automatic**
6. Policy requirement: **Must pass**
7. Save

> From now on, PRs targeting `main` cannot be merged until the CI pipeline passes.

---
<!-- class: step -->

## Part 5A — Workspace Sync (Manual Portal)

After merging a PR to `main`:

1. Open `WS-Dev-<team>` in the Fabric portal
2. Click the **Source control icon** (Git icon, top right toolbar)
3. In the Source control panel, review incoming commits
4. Click **Update all**
5. Fabric pulls the latest `main` and updates all workspace items

> ✅ Checkpoint: Reports and models in `WS-Dev-<team>` reflect the latest `main`.

---
<!-- class: step -->
<!-- _style: "font-size: 0.76em; line-height: 1.35" -->

## Part 5B — Workspace Sync (Automated API)

The `SyncFabricDev` stage calls:

```python
# scripts/sync_fabric_workspace.py
import os, requests, msal

app = msal.ConfidentialClientApplication(
    client_id=os.environ["SP_ID"],
    client_credential=os.environ["SP_SECRET"],
    authority=f"https://login.microsoftonline.com/{os.environ['TENANT_ID']}"
)
token = app.acquire_token_for_client(
    scopes=["https://api.fabric.microsoft.com/.default"]
)
requests.post(
    f"https://api.fabric.microsoft.com/v1/workspaces/{os.environ['WORKSPACE_ID']}/git/updateFromGit",
    headers={"Authorization": f"Bearer {token['access_token']}"},
    json={"workspaceHead": {"sourceControlSystem": "Git"}}
)
```

Runs automatically after every merge to `main`. No human action required.

---

## Lab 2 — Validation Checklist

- [ ] `azure-pipelines.yml` committed to repo root
- [ ] All 4 pipeline stages run and pass (green) in Azure DevOps
- [ ] DAX test results visible in **Tests** tab of the pipeline run
- [ ] `pbip-artifacts` published in **Artifacts** tab
- [ ] Pipeline set as required status check on `main` branch policy
- [ ] Approach A: Dev workspace manually synced via Source control panel
- [ ] Approach B: `SyncFabricDev` stage triggered by a merge to `main`

---
<!-- class: lead -->

# ☕ Break

### 14:45 – 15:00

**Lab 3 starts at 15:00**
_Fabric Deployment Pipelines: Dev → Test → Prod_
