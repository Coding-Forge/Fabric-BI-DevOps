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
    background-color: #c55a11;
    color: #ffffff;
    text-align: center;
  }
  section.lead h1, section.lead h2 { color: #ffffff; }
  section.lead p { color: #fce4d6; }
  h2 { color: #c55a11; border-bottom: 3px solid #c55a11; padding-bottom: 0.2em; }
  table { width: 100%; font-size: 0.82em; }
  th { background-color: #7a3510; color: #ffffff; }
  td { color: #1a1a1a; }
  tr:nth-child(even) td { background-color: #f0f0f0; }
  section.dark th { background-color: #5c2809; color: #ffffff; }
  section.dark td { color: #e8e8e8; }
  section.dark tr:nth-child(even) td { background-color: rgba(255,255,255,0.1); }
  code { background-color: #fff5f0; color: #1a1a1a; border-radius: 4px; padding: 2px 5px; }
  pre { background-color: #1a1a2e; border-radius: 6px; }
  pre code { background-color: transparent; color: #c9d1d9; }
  section.dark {
    background-color: #1a1a2e;
    color: #ffffff;
  }
  section.dark h2 { color: #f4a261; border-color: #f4a261; }
  section.dark table th { background-color: #5c2809; }
---
<!-- class: lead -->

# Deployment Strategy
## Dev → Test → Prod

`13:00 – 13:45`

---

## Two Complementary Pipeline Systems

| System | Purpose | Trigger |
|--------|---------|---------|
| **Azure DevOps CI Pipeline** | Validate PBIP artifacts — schema, lint, tests | Every push / PR |
| **Fabric Deployment Pipeline** | Promote workspace content across environments | Manual (with approval) or automated |

They work together:
- **CI ensures quality** before anything merges to `main`
- **Deployment Pipeline ensures consistency** when content moves to Test or Prod

---

## End-to-End Flow

```
Developer → feature branch → PR → CI ✅ → merge to main
                                              ↓
                                     Dev Workspace (Git sync)
                                              ↓
                              Fabric Deployment Pipeline: Dev → Test
                                              ↓
                                     UAT + Approval Gate
                                              ↓
                              Fabric Deployment Pipeline: Test → Prod
                                              ↓
                                       Prod Workspace ✅
```

---

## CI Pipeline — 4 Stages

| Stage | Trigger | What It Does |
|-------|---------|-------------|
| **Validate** | Every push / PR | `pbi-tools validate` + `pbip-lint` |
| **Test** | After Validate | DAX unit tests → JUnit XML |
| **Publish** | After Test | Upload `pbip-artifacts` to ADO |
| **SyncFabricDev** | `main` merges only | REST API call → sync Dev workspace |

All 4 stages must be **green** before any workspace promotion happens.

---
<!-- class: dark -->

## CI Pipeline YAML — Key Structure

```yaml
trigger:
  branches:
    include: [main, feature/*]

stages:
  - stage: Validate
    jobs:
      - job: ValidatePBIP
        steps:
          - script: pip install pbi-tools pbip-lint
          - script: pbi-tools validate --input fabric-workspace
          - script: pbip-lint --path fabric-workspace

  - stage: Test
    dependsOn: Validate
    jobs:
      - job: DaxTests
        steps:
          - script: python tests/run_dax_tests.py

  - stage: SyncFabricDev
    condition: eq(variables['Build.SourceBranch'], 'refs/heads/main')
    jobs:
      - job: TriggerFabricSync
        steps:
          - script: python scripts/sync_fabric_workspace.py
```

---

## Approach A — Manual Workspace Sync (Portal)

1. Open `WS-Dev-<team>` in Fabric
2. Click the **Source control icon** (top right toolbar)
3. Review incoming commits in the side panel
4. Click **Update all**

Good for: individual developers, on-demand pulls after a merge.

---

## Approach B — Automated Workspace Sync (REST API)

- The `SyncFabricDev` pipeline stage calls the Fabric `updateFromGit` REST endpoint
- Dev workspace updated automatically on every merge to `main`
- Credentials stored in **Azure Key Vault** → surfaced via ADO variable group
- No human action required after a PR merges

Good for: teams that want a fully automated inner loop.

---

## Fabric Deployment Pipelines

A **Fabric-native** feature (separate from Azure DevOps) that promotes workspace content between environments without re-publishing manually.

```
[Development]  →  [Test]  →  [Production]
 Promote ↗          Promote ↗
   (+ rules)           (+ approval)
```

**What it does at promotion time:**
- Copies reports, semantic models, dataflows, notebooks from one workspace to the next
- Applies **deployment rules** to swap data source connections per environment
- Shows a **diff view** so you know exactly what will change

---

## Deployment Rules — Why They Matter

Same PBIP artifact, different database per environment:

| Parameter | Dev | Test | Prod |
|-----------|-----|------|------|
| `ServerName` | `dev-sql.database.windows.net` | `test-sql.database.windows.net` | `prod-sql.database.windows.net` |
| `DatabaseName` | `SalesDB_Dev` | `SalesDB_Test` | `SalesDB_Prod` |

Deployment rules apply these overrides automatically at promotion time.
**No manual connection editing. No risk of accidentally pointing Prod at Dev data.**

---

## Validation Gates — Dev → Test

Before triggering the Dev → Test promotion:

- [ ] CI pipeline green on `main` — all 3 stages passed
- [ ] JUnit: 0 test failures
- [ ] Dev workspace refresh succeeded
- [ ] Deployment rules configured for the Test environment

---

## Validation Gates — Test → Prod

Before triggering the Test → Prod promotion:

- [ ] UAT complete — stakeholder sign-off
- [ ] RLS roles tested with representative user accounts
- [ ] Refresh succeeded against Test database
- [ ] Schema diff reviewed — no unexpected changes
- [ ] **Manual approval** from BI Lead received

---

## What Gets Promoted by the Deployment Pipeline

| Item | Promoted? |
|------|-----------|
| Reports | ✅ |
| Semantic Models | ✅ |
| Notebooks | ✅ |
| Dataflows Gen2 | ✅ |
| Data Pipelines | ✅ |
| Lakehouses | ⚠️ Schema only |
| Warehouses | ⚠️ Schema only |
| Gateway connections | ✅ (via deployment rules) |

> 💡 Use **selective deployment** to promote only the items that changed — faster and safer for hotfixes.

---

## Key Principles

1. **`main` is always deployable** — CI enforces this
2. **Dev is the only Git-connected workspace** — Test and Prod are promoted-only
3. **No manual prod deployments** — Deployment Pipeline only
4. **Secrets stay in Key Vault** — never in pipeline YAML or PBIP files
5. **Every promotion is logged** — Deployment Pipeline audit trail + ADO build history

---
<!-- class: lead -->

# 🧪 Lab 2 up next

**CI Pipeline for PBIP**
`13:45 – 14:45`
