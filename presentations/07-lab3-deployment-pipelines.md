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
    background-color: #0078D4;
    color: #ffffff;
    text-align: center;
  }
  section.lead h1, section.lead h2 { color: #ffffff; }
  section.lead p { color: #cce4ff; }
  h2 { color: #0078D4; border-bottom: 3px solid #0078D4; padding-bottom: 0.2em; }
  table { width: 100%; font-size: 0.82em; }
  th { background-color: #004f8e; color: #ffffff; }
  td { color: #1a1a1a; }
  tr:nth-child(even) td { background-color: #f0f0f0; }
  section.dark th { background-color: #003a6c; color: #ffffff; }
  section.dark td { color: #e8e8e8; }
  section.dark tr:nth-child(even) td { background-color: rgba(255,255,255,0.1); }
  section.step td { color: #1a1a1a; }
  section.step tr:nth-child(even) td { background-color: #e8e8e8; }
  code { background-color: #f0f4ff; color: #1a1a1a; border-radius: 4px; padding: 2px 5px; }
  section.dark {
    background-color: #1a1a2e;
    color: #ffffff;
  }
  section.dark h2 { color: #50b8f8; border-color: #50b8f8; }
  section.step { background-color: #f8f9fa; }
  section.step h2 { color: #0078D4; }
  section.warn {
    background-color: #fff8e6;
  }
  section.warn h2 { color: #5c4400; border-color: #5c4400; }
---
<!-- class: lead -->

# 🧪 Lab 3
## Fabric Deployment Pipelines
### Dev → Test → Prod

**Duration: 60 minutes**
`15:00 – 16:00`

---

## Lab 3 Objectives

By the end of this lab you will have:

1. Created a three-stage **Fabric Deployment Pipeline**
2. Bound `WS-Dev`, `WS-Test`, and `WS-Prod` to their stages
3. Configured **deployment rules** to swap data source connections per environment
4. Reviewed the **comparison diff** before promoting
5. Promoted **Dev → Test** and verified the deployment
6. Completed the **UAT checklist** (RLS, refresh, rules)
7. Gated **Test → Prod** with a manual approval
8. Verified Prod workspace content and confirmed refresh

---

<!-- _style: "font-size: 0.82em; line-height: 1.4" -->

## Prerequisites Check

Before starting:

- [ ] Lab 1 ✅ — Dev workspace is Git-connected, PBIP content committed
- [ ] Lab 2 ✅ — CI pipeline is passing on `main`
- [ ] Three workspaces exist on Fabric capacity (F2+):
  - `WS-Dev-<team>`
  - `WS-Test-<team>`
  - `WS-Prod-<team>`
- [ ] You have **Admin** role on all three workspaces
- [ ] Fabric Admin toggle enabled: **Users can create and use deployment pipelines**
- [ ] Semantic model uses Power Query parameters for server and database name

---

## Key Concept: Deployment Pipelines vs. CI Pipelines

| | Azure DevOps Pipeline | Fabric Deployment Pipeline |
|---|---|---|
| **Where** | Azure DevOps / GitHub | Microsoft Fabric portal |
| **What** | Validates code (text artifacts) | Promotes workspace content (live items) |
| **Trigger** | Git push / PR | Manual (or REST API) |
| **Output** | Green/red status check | Items copied across workspaces |
| **Rules** | Branch policies | Deployment rules (connection swaps) |

They complement each other. CI validates — Deployment Pipeline promotes.

---

## Concept: Deployment Rules

> Same artifact, different connection per environment.

The semantic model in Dev points to `SalesDB_Dev`.
When you promote to Test, deployment rules **automatically** swap it to `SalesDB_Test`.

```
Deployment rule (Test stage):
  Parameter: ServerName  →  test-sql.database.windows.net
  Parameter: DatabaseName →  SalesDB_Test
```

No manual editing of connection strings. No risk of Prod pointing at Dev data.

---
<!-- class: step -->

## Part 1 — Create the Deployment Pipeline

1. In the Fabric portal, click **Deployment pipelines** in the left nav
   *(or: Create → Deployment pipeline)*
2. Click **Create pipeline**
3. Name it: `DP-<team>` (e.g., `DP-FinanceBI`)
4. Click **Create**

You will see the three-stage canvas:

```
[  Development  ]  →  [    Test    ]  →  [  Production  ]
```

---
<!-- class: step -->

## Part 2 — Assign Workspaces to Stages

**Development stage:**
1. Click **Assign a workspace** under Development
2. Select `WS-Dev-<team>` → **Assign**

**Test stage:**
1. Click **Assign a workspace** under Test
2. Select `WS-Test-<team>` → **Assign**

**Production stage:**
1. Click **Assign a workspace** under Production
2. Select `WS-Prod-<team>` → **Assign**

> ✅ Checkpoint: All three stages show workspace names and item counts.

---
<!-- class: step -->

## Part 3 — Configure Deployment Rules (Test)

1. Click **⋯** on the **Test stage** header → **Deployment rules**
2. Select the **SalesModel** semantic model
3. Under **Data source rules**, click **+ Add rule**

| Parameter | Dev Value | Test Value |
|-----------|-----------|------------|
| `ServerName` | `dev-sql.database.windows.net` | `test-sql.database.windows.net` |
| `DatabaseName` | `SalesDB_Dev` | `SalesDB_Test` |

4. Click **Save**

---
<!-- class: step -->

## Part 3 — Configure Deployment Rules (Prod)

Repeat for the **Production stage**:

| Parameter | Prod Value |
|-----------|------------|
| `ServerName` | `prod-sql.database.windows.net` |
| `DatabaseName` | `SalesDB_Prod` |

> 💡 **Gateway rules:** If your model uses a gateway for on-premises sources, add a **gateway rule** alongside the data source rule to redirect to the correct gateway for each environment.

---
<!-- class: step -->
<!-- _style: "font-size: 0.82em; line-height: 1.4" -->

## Part 4 — Review the Comparison Diff

**Always review what will change before promoting.**

1. Click the **diff count** between Development and Test stages
   (e.g., "3 different")
2. The comparison panel shows:
   - Items only in **Dev** → will be added to Test
   - Items only in **Test** → will be removed from Test
   - Items that are **different** → will be updated
   - Items that are **identical** → no action

3. Expand any item to see which properties changed
4. Confirm this matches your recent commits before proceeding

---
<!-- class: step -->

## Part 5 — Promote Dev → Test

1. Click **Deploy** between the Development and Test stages
2. Review the deployment panel — all changed items pre-selected
3. Add a deployment note: `Lab 3 — initial Dev → Test promotion`
4. Click **Deploy**

Fabric promotes all selected items to `WS-Test-<team>`, applying the deployment rules.

**After deployment:**
1. Click **View deployment details** — review the promotion log
2. Open `WS-Test-<team>` in a new tab
3. Confirm reports and semantic models are present

---
<!-- class: step -->

## Part 6 — UAT Checklist (Test Validation)

Work through this with your lab partner before promoting to Prod:

- [ ] Report visuals display correct Test data
- [ ] RLS tested: sign in as an RLS test user and confirm row filtering works
- [ ] No placeholder or developer-only pages visible
- [ ] Dataset refresh completed successfully in Test workspace
- [ ] Deployment rules confirmed: Test semantic model points to Test database, not Dev
- [ ] Schema diff (Test → Prod) reviewed — changes match expectations
- [ ] Stakeholder (lab partner) sign-off given

---
<!-- class: step -->

## Part 7 — Configure the Approval Gate

1. Click **⋯** on the **Production stage** header → **Deployment settings**
2. Enable **Manual approval required**
3. Add the BI Lead (or your lab facilitator) as the approver
4. Click **Save**

The next promotion to Production will **pause** until the approver reviews and accepts.

---
<!-- class: step -->

## Part 7 — Trigger the Prod Promotion

**Trigger the deployment:**
1. Click **Deploy** between Test and Production
2. Add a note: `Lab 3 — initial Test → Prod promotion`
3. Click **Deploy** — the pipeline pauses for approval

**As approver (BI Lead):**
1. Open the approval request notification
2. Review the deployment details
3. Click **Approve**

---
<!-- class: step -->

## Part 7 — Verify Prod

After approval and deployment:

1. Open `WS-Prod-<team>` in a new tab
2. Confirm the report and semantic model are present
3. Trigger a **manual dataset refresh**:
   - Click the semantic model → **Refresh now**
   - Confirm the refresh succeeds against the **Prod database**
4. Open the report → verify it renders against Prod data

> ✅ Checkpoint: Prod workspace has content, refresh is green, data is correct.

---

## Lab 3 — Validation Checklist

- [ ] Deployment Pipeline `DP-<team>` created with all three stages bound
- [ ] Deployment rules configured for Test and Prod environments
- [ ] Comparison diff reviewed before promoting
- [ ] Dev → Test promotion completed and logged
- [ ] UAT checklist completed; lab partner sign-off given
- [ ] Manual approval gate configured on the Production stage
- [ ] Test → Prod promotion completed after approval
- [ ] Prod workspace verified: content present, refresh succeeded

---
<!-- class: lead -->

# ✅ Lab 3 Complete

**Next: Publishing Artifacts & Release Checklist**
`16:00 – 16:30`
