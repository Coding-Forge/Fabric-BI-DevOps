---
title: "FAQ — Enterprise BI DevOps with Microsoft Fabric"
description: "Frequently asked questions and resolutions covering Git integration, CI/CD pipelines, Fabric Deployment Pipelines, on-premises gateways, governance, and common lab issues."
---

# FAQ — Enterprise BI DevOps with Microsoft Fabric

This document covers the most common questions and issues encountered across the labs and supporting CI/CD setup. Questions are grouped by topic area. Each answer references the relevant lab or architecture document where applicable.

---

## Contents

1. [Git Integration & Workspace Setup](#1-git-integration--workspace-setup)
2. [Feature Branches & Pull Requests](#2-feature-branches--pull-requests)
3. [Azure DevOps CI Pipeline](#3-azure-devops-ci-pipeline)
4. [Universal / Shared Pipeline Template](#4-universal--shared-pipeline-template)
5. [Fabric Deployment Pipelines](#5-fabric-deployment-pipelines)
6. [On-Premises Data Gateways](#6-on-premises-data-gateways)
7. [Deployment Rules & Bindings](#7-deployment-rules--bindings)
8. [Permissions & Governance](#8-permissions--governance)
9. [Semantic Model & PBIP Artifacts](#9-semantic-model--pbip-artifacts)
10. [Refresh Failures](#10-refresh-failures)

---

## 1. Git Integration & Workspace Setup

### Q: "Git integration" is not visible in my workspace settings. How do I enable it?

The **Users can synchronize workspace items with their Git repositories** admin toggle must be turned on at the tenant level.

1. Open the **Fabric Admin Portal** → **Tenant settings**.
2. Search for "Git repositories" or navigate to **Integration settings**.
3. Enable **Users can synchronize workspace items with their Git repositories**.
4. Scope the setting to **The entire organization** or the relevant security group.

If the toggle is already on but you still cannot see the option, confirm that your workspace is on a **Fabric capacity (F2 or higher)** or PPU. Workspaces on shared (Pro-only) capacity do not support Git integration.

> See also: [Lab 1 — Connect a Fabric Workspace to Git](workshop-plan/labs/lab1-connect-git.md), Part 1.

---

### Q: OAuth sign-in fails when connecting the workspace to Azure DevOps. What should I do?

OAuth is blocked by a Conditional Access policy in many enterprise tenants. Use a **Personal Access Token (PAT)** instead:

1. In Azure DevOps, go to **User Settings (top-right avatar) → Personal Access Tokens**.
2. Click **+ New Token**.
3. Set **Scopes** to `Code (Read & Write)`.
4. Set an expiry date past the workshop date.
5. Copy the token.
6. In Fabric workspace settings → Git integration, choose **Azure DevOps** and paste the PAT when prompted.

> See also: [Lab 1](workshop-plan/labs/lab1-connect-git.md), Part 1.2 Tip.

---

### Q: The repo folder appears empty after the initial sync. No PBIP files are visible.

Check these in order:

1. **Folder path** — the path configured in Git integration must exactly match the folder in the repo. Avoid a leading `/` if the UI doesn't expect one, or confirm the folder already exists.
2. **Empty repo** — if the repo has no commits, Fabric cannot push to it. Add a `README.md` to the repo first, then re-connect.
3. **Branch mismatch** — the workspace is connected to a branch that does not contain the PBIP files. Switch to the correct branch in workspace settings.
4. **Pending sync** — click **Source control** → **Update all** to force a push of all workspace items.

> See also: [Lab 1](workshop-plan/labs/lab1-connect-git.md), Part 2.2.

---

### Q: Items show "Conflict" status in the workspace after someone else pushed a change.

A conflict means the remote branch has changes that differ from the workspace state. Resolve it in Fabric:

1. Open **Source control** → **Pending changes**.
2. Items with a conflict indicator are listed. For each:
   - Click the item → **Resolve conflict**.
   - Choose **Accept remote** (take what's in Git) or **Keep workspace** (overwrite Git with the workspace version).
3. After resolving all conflicts, click **Commit**.

To avoid this in team work, each developer should use a **personal feature workspace** connected to their own feature branch rather than all working in the same shared workspace.

> See also: [Branching Strategy](architecture/branching-strategy.md) — Core Concepts.

---

### Q: Only certain workspace item types have Git status badges. Why are some items not tracked?

Not all Fabric item types are currently supported for Git sync. Supported item types include: **Reports (PBIP format), Semantic Models (TMDL), Dataflows Gen2, Notebooks, and Spark Job Definitions**. Items such as Lakehouses, Warehouses, Data Pipelines, and Eventstreams are not yet exportable via Git sync (as of April 2026 — check Microsoft's release notes for updates).

For unsupported types, track configuration and metadata manually or through the Fabric REST API.

---

### Q: My workspace is not on Fabric capacity. Can I still use Git integration?

No. Git integration requires the workspace to be assigned to a **Fabric capacity (F2 or higher)** or a **Premium Per User (PPU)** license. Pro-licensed workspaces do not support Git integration. Contact your Fabric Admin to assign the workspace to an available capacity.

> See also: [Workspace Strategy](architecture/workspace-strategy.md) — Workspace Topology.

---

## 2. Feature Branches & Pull Requests

### Q: I created a feature branch but the workspace still shows `main`. How do I switch?

1. Open the workspace → **Workspace settings → Git integration**.
2. Under **Branch**, click **Switch branch** (or **Checkout branch**).
3. Select your feature branch from the list.
4. Click **Update**.

If your branch is not listed, confirm it has been pushed to the remote repo (not just created locally) and refresh the dropdown.

> See also: [Lab 1](workshop-plan/labs/lab1-connect-git.md), Part 3.2.

---

### Q: The branch switch fails with a permissions error.

You need **at least Contributor** on the workspace *and* **Write** access on the repository. Have a workspace Admin verify:

- Your role in **Workspace settings → Access**.
- Your repo permissions in **Azure DevOps → Repos → {repo} → Security** or the GitHub repo collaborators list.

---

### Q: Should I work directly in the shared Dev workspace (`WS-Dev-<team>`) on my feature branch?

No — this is an anti-pattern. The recommended approach is to create a **personal feature workspace** (`WS-Dev-<alias>`) connected to your feature branch. This keeps your in-progress, potentially broken work invisible to teammates.

Steps:
1. Create a new Fabric workspace named `WS-Dev-<alias>`.
2. Assign it to the same Fabric capacity.
3. Connect it via Git integration to the **same repo** but set the branch to your feature branch.
4. Work in this personal workspace.
5. After your PR merges, delete the personal workspace.

> See also: [Branching Strategy](architecture/branching-strategy.md) and [Lab 1](workshop-plan/labs/lab1-connect-git.md) — Extension section.

---

### Q: My PR is stuck waiting for a required reviewer but there is no one to approve. What are my options?

For the workshop, your lab partner can act as the reviewer. For production use:

- Ensure branch policies are scoped correctly — do not require external team approvals for workshop exercises.
- A facilitator can act as the approver for all workshop PRs.
- If policy blocks self-approval, the facilitator (as workspace Admin) can bypass the policy as a one-off.

> See also: [Governance Checklist](governance/governance-checklist.md), Section 1.3 — Branch policies.

---

### Q: After the PR merges, the shared Dev workspace still shows my feature branch content. How do I sync back to `main`?

1. Open **Workspace settings → Git integration**.
2. Switch the branch back to `main`.
3. Click **Update**.
4. The workspace re-syncs to the merged state on `main`.
5. All items should show **Synced** status.

> See also: [Lab 1](workshop-plan/labs/lab1-connect-git.md), Part 5.3.

---

## 3. Azure DevOps CI Pipeline

### Q: The pipeline fails with `No .pbip file found`. What is wrong?

The validation script (`validate_pbip_structure.py`) looks for PBIP artifacts under the path set by the `PBIP_PATH` variable (default: `pbip-local`). PBIP files are **not committed to the repo** — they must be placed locally on the build agent.

For the workshop pipeline (`azdo/azure-pipelines.yml`):

1. Confirm your PBIP project files exist under `shared/pbip-local/` in the repo **or** are placed there during the pipeline run.
2. If running against your own project, place the `.pbip` file and its associated report/model folders under `shared/pbip-local/` before running.
3. Check the pipeline variable `PBIP_PATH` — if your folder is named differently, update the variable in the YAML.

> See also: [Lab 2 — CI Pipeline](workshop-plan/labs/lab2-ci-pipeline.md), Part 1. [shared/pbip-local/README.md](../shared/pbip-local/README.md).

---

### Q: The Dataset Quality Rules job fails. How do I read the failure output?

1. Open the failing job in the Azure DevOps pipeline run.
2. Expand the **Run Dataset Quality Rules** step.
3. Look for lines beginning with `[Error]` or rule IDs (e.g., `BPA_001`). Each failed rule has an ID, severity, and description.
4. Cross-reference the rule ID against `shared/Rules-Dataset.json` — the `name` and `description` fields explain what the rule enforces.
5. Fix the semantic model violation (e.g., add a measure description, remove a many-to-many relationship) and re-push.

If the rule is a false positive or does not apply to your project, use `tools/enterprise-standards-builder/index.html` to adjust the approved policy profile, or use `tools/rule-designer/index.html` to tune an individual dataset rule. Avoid editing JSON by hand unless you are authoring advanced Tabular Editor BPA logic.

> See also: [Lab 2](workshop-plan/labs/lab2-ci-pipeline.md), Part 2 — Validate Stage. [shared/Rules-Dataset.json](../shared/Rules-Dataset.json). [Rules Authoring Guide](Rules-Authoring-Guide.md).

---

### Q: The Report Quality Rules job fails. Where do report rules come from?

Report rules are defined in `shared/Rules-Report.json`. The job uses **PBI Inspector** to evaluate these rules against the `.Report/definition/` folder of the PBIP artifact. Use `tools/enterprise-standards-builder/index.html` for policy-level settings and `tools/rule-designer/index.html` for individual report-rule changes.

Common rule failures and fixes:

| Rule | Typical Cause | Fix |
|---|---|---|
| Page background color contrast | Background color fails accessibility ratio | Adjust theme or set a white/neutral background |
| Visual has no title | A visual's title is blank or hidden | Add a descriptive title to the visual |
| Tooltip is empty | Custom tooltip page is blank | Fill in tooltip content or remove the tooltip assignment |
| Image alt-text missing | An image visual has no alt-text | Add alt-text via the visual's accessibility options |

> See also: [shared/Rules-Report.json](../shared/Rules-Report.json). [Rules Authoring Guide](Rules-Authoring-Guide.md).

---

### Q: DAX test results are not appearing in the Azure DevOps Tests tab.

The `PublishTestResults@2` task requires that the JUnit XML file exists **before the task runs**. Check:

1. The `run_dax_tests.py` script outputs a JUnit file — confirm the output path matches the path configured in `PublishTestResults@2` (`testResultsFiles` field).
2. If the test stage failed early (Python error before any test ran), no XML is produced. Check the script logs for Python exceptions.
3. Confirm `testResultsFormat` is set to `JUnit` in the YAML task.
4. If tests pass but results still don't show, add a `condition: always()` to the `PublishTestResults` task so it runs even when the test script exits with a non-zero code.

> See also: [Lab 2](workshop-plan/labs/lab2-ci-pipeline.md), Part 3 — Test Stage.

---

### Q: The pipeline runs on pushes but does NOT trigger on pull requests. What is misconfigured?

The `pr:` trigger in `azure-pipelines.yml` must list the target branch:

```yaml
pr:
  branches:
    include:
      - main
```

Additionally, for the pipeline to act as a **required check**, you must configure a **Build Validation** branch policy on `main`:

1. Go to **Azure DevOps → Repos → Branches**.
2. Click the `...` next to `main` → **Branch policies**.
3. Under **Build validation**, click **+**.
4. Select the pipeline definition.
5. Set **Trigger** to **Automatic** and **Policy requirement** to **Required**.
6. Save.

Without the branch policy, the `pr:` trigger fires the pipeline as an informational check only — it will not block merges.

> See also: [Lab 2](workshop-plan/labs/lab2-ci-pipeline.md), Part 6 — Set Required Branch Policy.

---

### Q: The pipeline runs on every commit to every branch, causing noise. How do I restrict it?

Update the `trigger:` section to only run on the branches you care about:

```yaml
trigger:
  branches:
    include:
      - main
      - feature/*
  paths:
    include:
      - shared/**
```

The `paths` filter ensures the pipeline only triggers when files under `shared/` change, avoiding spurious runs from documentation-only commits.

---

### Q: Can I use a Linux build agent instead of Windows?

The pipeline defaults to `windows-2022` because **Tabular Editor** (used for dataset quality rules) and **PBI Inspector** (report rules) are Windows executables. If you need a Linux agent, skip those jobs:

```yaml
# In the consumer YAML (universal pipeline pattern):
parameters:
  skipDatasetRules: true
  skipReportRules: true
```

The PBIP structure validation (`validate_pbip_structure.py`) and DAX tests (`run_dax_tests.py`) are Python-based and run on Linux without modification.

> See also: [shared/universal-pipeline/README.md](../shared/universal-pipeline/README.md) — Parameters table.

---

## 4. Universal / Shared Pipeline Template

### Q: What is the difference between the project-local pipeline and the universal pipeline?

| | Project-local (`azdo/azure-pipelines.yml`) | Universal (`shared/universal-pipeline/`) |
|---|---|---|
| **Location** | Lives inside this workshop repo | Intended to live in a separate `fabric-pipeline-templates` ADO repo |
| **Best for** | Single repo, self-contained workshop | Multiple Fabric repos sharing one CI definition |
| **Maintenance** | Update YAML per repo | Update the template once; all consumers pick up changes automatically |
| **Parameters** | Hardcoded YAML variables | Passed as `extends` parameters from each consumer YAML |

For the workshop, use the project-local pipeline. For production multi-repo setups, see the universal pipeline.

> See also: [shared/universal-pipeline/README.md](../shared/universal-pipeline/README.md).

---

### Q: The consumer pipeline fails with "Repository resource not found" when referencing the template repo.

1. Confirm the `fabric-pipeline-templates` repo exists in Azure DevOps with the correct organization and project name.
2. In the consumer YAML, verify the `name:` field matches `{OrgName}/{ProjectName}` (not just the repo name).
3. Grant the **build service identity** of the consumer project **Read** access to `fabric-pipeline-templates`:
   - **Project Settings → Repositories → fabric-pipeline-templates → Security**
   - Find `{ProjectName} Build Service ({OrgName})` and set **Read** to **Allow**.

> See also: [shared/universal-pipeline/README.md](../shared/universal-pipeline/README.md) — Step 1: Grant repo access.

---

### Q: I want to skip the Tabular Editor step for a specific project repo. How?

In the consumer `azure-pipelines.yml`, pass the skip parameter:

```yaml
extends:
  template: templates/fabric-ci.yml@fabric-pipeline-templates
  parameters:
    pbipPath: 'pbip-local'
    skipDatasetRules: true
```

Available skip flags: `skipDatasetRules`, `skipReportRules`, `skipDaxTests`, `skipPublish`.

> See also: [shared/universal-pipeline/README.md](../shared/universal-pipeline/README.md) — Parameters table.

---

## 5. Fabric Deployment Pipelines

### Q: The "Assign workspace" button is greyed out. I cannot bind a workspace to a stage.

You need **Admin** on the target workspace. Confirm:

1. Open the target workspace → **Workspace settings → Access**.
2. Your account must show **Admin**. Contributor and Member roles cannot assign a workspace to a deployment pipeline stage.
3. Also confirm the workspace is on Fabric capacity (F2+). Shared-capacity workspaces cannot be assigned to deployment pipeline stages.

> See also: [Lab 3](workshop-plan/labs/lab3-deployment-pipelines.md) — Troubleshooting.

---

### Q: How do I create a Deployment Pipeline if I don't see the option in the portal?

The **Users can create and use deployment pipelines** admin toggle must be enabled:

1. Open the **Fabric Admin Portal → Tenant settings**.
2. Search for "deployment pipelines".
3. Enable **Users can create and use deployment pipelines**.
4. Scope it to the appropriate security group or the entire organization.

> See also: [Lab 3](workshop-plan/labs/lab3-deployment-pipelines.md) — Prerequisites.

---

### Q: The deployment comparison shows many unexpected differences. Should I still promote?

**No — stop and investigate.** The comparison view (diff) is the last gate before content changes environments. Common causes of unexpected diffs:

- Someone made a manual change directly in the Test or Prod workspace outside the pipeline (bypassing the process).
- A previous promotion was partial (some items were promoted, others were not).
- Deployment rules are different from a previous run (e.g., someone updated a rule).

Review each item in the diff. If you cannot explain a difference, roll back by promoting from a known-good stage or by re-binding the workspace to a fresh state. Never promote if you cannot account for all differences.

> See also: [Lab 3](workshop-plan/labs/lab3-deployment-pipelines.md), Part 4 — Review the Comparison. [Governance Checklist](governance/governance-checklist.md), Section 3.

---

### Q: Content was promoted to Test but the report still shows Dev data. What happened?

This is almost always a missing or misconfigured deployment rule. Check in order:

1. **Data source parameter rules** — open **Deployment rules** for the Test stage and confirm `ServerName` and `DatabaseName` (or equivalent parameters) are overridden to Test values.
2. **Gateway rule** — if the source is on-premises, confirm the gateway rule is set to `GW-Test / DS-SQL-Test`. Without it, refreshes route through the Dev gateway to the Dev database.
3. **Refresh not triggered** — the deployment copies the semantic model but does not automatically refresh it. Trigger a manual refresh in the Test workspace after promotion.
4. **Import mode cache** — if the model is Import mode, the data is baked in from the last Dev refresh. Trigger a Test refresh to pull from the Test database.

> See also: [Lab 3](workshop-plan/labs/lab3-deployment-pipelines.md), Part 3 and Part 3b. [On-Premises Gateway Architecture](architecture/gateway-deployment-pipeline.md) — Complete Rules Summary.

---

### Q: How do I automate the Test → Prod promotion instead of clicking in the UI?

Use the **Fabric REST API** via PowerShell in an Azure DevOps release pipeline stage with a manual approval gate:

```powershell
$pipelineId = "<your-pipeline-id>"
$body = @{
    sourceStageOrder = 1   # 0=Dev, 1=Test, 2=Prod
    isBackwardDeployment  = $false
    newWorkspace          = $null
    note                  = "Automated promotion via REST API"
    options = @{
        allowOverwriteTargetArtifact = $true
        allowCreateArtifact          = $true
    }
} | ConvertTo-Json -Depth 5

Invoke-PowerBIRestMethod `
    -Url "v1.0/myorg/pipelines/$pipelineId/deploy" `
    -Method Post `
    -Body $body `
    -ContentType "application/json"
```

In production, replace `Connect-PowerBIServiceAccount` with service principal authentication using credentials from **Azure Key Vault**.

> See also: [Lab 3](workshop-plan/labs/lab3-deployment-pipelines.md), Part 8 — Automate via REST API. [CI/CD Architecture](architecture/cicd-architecture.md).

---

### Q: Can I promote only selected items rather than the entire workspace?

Yes — use **Selective deployment**. When you click **Deploy** in the pipeline canvas, the deployment panel opens with all changed items pre-selected. Uncheck any items you do not want to promote. Only checked items are moved to the target stage.

This is useful when a workspace contains multiple projects at different stages of readiness, or when a hotfix needs to go to Prod before the rest of a feature is complete.

> See also: [Lab 3](workshop-plan/labs/lab3-deployment-pipelines.md) — Background: Key Concepts.

---

## 6. On-Premises Data Gateways

### Q: The gateway data source does not appear in the deployment rule dropdown.

The dropdown only shows gateway data sources that:

1. Are registered on a gateway cluster visible to the current user.
2. Match the data source type of the semantic model (e.g., SQL Server).
3. Are accessible to the user configuring the rule (you must be a **gateway admin** or listed as a **User** on the data source).

To fix:
- Open the **Power Platform admin center → Data (preview) → On-premises data gateways**.
- Confirm the data source exists on the target gateway (e.g., `DS-SQL-Test` on `GW-Test`).
- Confirm your account has **Admin** or at least **Can use** access on the gateway.

> See also: [On-Premises Gateway Architecture](architecture/gateway-deployment-pipeline.md) — Gateway Prerequisites.

---

### Q: The gateway shows "Offline" in the admin portal. What should I do?

1. RDP or remote into the gateway host (e.g., `gw-test-01.corp.local`).
2. Open **Windows Services** and locate **On-premises data gateway service**.
3. If the service is stopped, start it.
4. If it fails to start, check the Windows Event Log (Application) for errors — common causes are expired service account passwords or certificate expiry.
5. Verify the gateway host has outbound HTTPS (port 443) connectivity to `*.servicebus.windows.net` and `*.powerbi.com`.

After the service restarts, wait ~60 seconds and refresh the admin portal — the status should return to **Online**.

> See also: [On-Premises Gateway Architecture](architecture/gateway-deployment-pipeline.md) — Troubleshooting.

---

### Q: The gateway rule is set correctly, but the refresh still fails with "Unable to connect to the data source".

Work through this checklist:

- [ ] The gateway data source **credentials** are correct and not expired. Edit the data source in the admin portal and re-enter credentials.
- [ ] The gateway **service account** (`svc-gw-<env>@corp.local`) has at least `db_datareader` on the target database.
- [ ] The gateway host can **reach the SQL Server** — run `Test-NetConnection sql-test-01.corp.local -Port 1433` from the gateway host.
- [ ] If SQL Server uses a **named instance**, include the instance name in the server field: `sql-test-01.corp.local\INSTANCE`.
- [ ] Firewall rules on the SQL Server allow inbound connections from the gateway host's IP.

> See also: [On-Premises Gateway Architecture](architecture/gateway-deployment-pipeline.md) — Troubleshooting.

---

### Q: Why do I need to set both a gateway rule AND data source parameter rules? Isn't one enough?

They serve different purposes:

| Rule Type | What it controls |
|---|---|
| **Gateway rule** | *Which physical gateway and registered data source* Fabric uses for the refresh connection |
| **Data source parameter rule** | *The connection string values* embedded in the Power Query M code (server name, database name) |

Without the **gateway rule**, the refresh routes through the Dev gateway to the Dev database — even if the M query parameters say "Test". Without the **parameter rules**, the M query still has Dev server/database values embedded, and queries will target the wrong database even though the gateway is correct.

Both rules must be set together for on-premises connections that use Power Query parameters.

> See also: [On-Premises Gateway Architecture](architecture/gateway-deployment-pipeline.md) — Test Stage Deployment Rules (Why both rules?). [Lab 3](workshop-plan/labs/lab3-deployment-pipelines.md), Part 3b — Complete Rules at a Glance.

---

## 7. Deployment Rules & Bindings

### Q: Deployment rules are not saving. I click Save but the values reset.

- Confirm the semantic model uses **Power Query parameters** for the server and database name. Hard-coded connection strings (e.g., `Sql.Database("server", "db")` with literal strings) cannot be overridden by deployment rules — the parameter field will not appear.
- In Power BI Desktop, define named parameters under **Home → Transform data → Manage Parameters** and use those parameter names in the data source step.
- After adding parameters, re-publish the model to the Dev workspace and re-open Deployment Rules.

> See also: [On-Premises Gateway Architecture](architecture/gateway-deployment-pipeline.md) — Semantic Model: Power Query Parameter Definitions.

---

### Q: The "Original gateway data source" for the Prod stage should match the Dev source, not Test. Is that correct?

Yes — this is intentional. The "original" binding in any stage's rule always refers back to the **Dev artifact's binding**, regardless of what other stages override. Fabric resolves the rule chain automatically:

- Dev → default binding (`GW-Dev / DS-SQL-Dev`)
- Test → override: replace Dev binding with `GW-Test / DS-SQL-Test`
- Prod → override: replace Dev binding with `GW-Prod / DS-SQL-Prod`

Do not set the Prod gateway rule's "original" to the Test data source — this will cause the rule to not match and the Prod workspace will inherit the Test binding.

> See also: [On-Premises Gateway Architecture](architecture/gateway-deployment-pipeline.md) — Production Stage: Gateway Rule Note.

---

### Q: I have multiple semantic models in the pipeline. Do I need separate rules for each?

Yes. Deployment rules are configured **per artifact (semantic model)**. You must open Deployment Rules, select each semantic model, and configure gateway and parameter rules independently for each one.

If you have many models, consider managing rules via the **Fabric REST API** to avoid tedious UI work at scale.

> See also: [On-Premises Gateway Architecture](architecture/gateway-deployment-pipeline.md) — REST API: Set Gateway and Data Source Rules.

---

## 8. Permissions & Governance

### Q: A developer accidentally edited a report directly in the Prod workspace. What should we do?

This is a governance violation — Prod should only ever receive changes through the Deployment Pipeline.

**Immediate remediation:**
1. Promote the last known-good Test content to Prod via the Deployment Pipeline to overwrite the manual change.
2. Verify the pipeline canvas shows no differences after re-promotion.

**Process remediation:**
1. Remove the developer's **Member** role from the Prod workspace and downgrade to **Viewer** or **Contributor** (Contributor cannot publish in Prod — set it to Viewer for non-admins).
2. Confirm only the BI Lead holds **Admin** on Prod.
3. Log a retro item so the team revisits access policies.

> See also: [Governance Checklist](governance/governance-checklist.md), Section 1.2 — Permission Model. [Workspace Strategy](architecture/workspace-strategy.md) — Permission Model.

---

### Q: Should the Test and Prod workspaces be Git-connected?

**No.** Only the Dev workspace should be Git-connected. Test and Prod receive content exclusively through the **Fabric Deployment Pipeline**. Connecting Test or Prod to Git creates a pathway for unreviewed changes to bypass the pipeline and enter controlled environments.

This is a **[BLOCK]** item on the governance checklist — if Test or Prod is Git-connected, disconnect it immediately.

> See also: [Governance Checklist](governance/governance-checklist.md), Section 1.3 — Git Integration.

---

### Q: How do I enforce that no one pushes directly to `main`?

Configure **branch policies** on `main` in Azure DevOps:

1. **Repos → Branches → `main` → Branch policies**
2. Enable:
   - **Require a minimum number of reviewers** (minimum: 1)
   - **Check for comment resolution** — all comments must be resolved before merge
   - **Build validation** — link the CI pipeline and set it to **Required, Automatic**
   - *(Optional)* **Require a merge strategy** → Squash merge to keep history clean

With these policies active, `git push origin main` will be rejected, and direct commits via the Fabric portal Source control panel to `main` will also be blocked.

> See also: [Governance Checklist](governance/governance-checklist.md), Section 1.3. [Lab 2](workshop-plan/labs/lab2-ci-pipeline.md), Part 6.

---

### Q: Where should secrets (passwords, connection strings, service principal credentials) be stored?

Never embed secrets in:
- YAML pipeline files
- PBIP JSON/TMDL artifacts
- Deployment rule fields (these are visible to workspace members)

Use **Azure Key Vault**:
- Store database passwords, service principal secrets, and PATs in Key Vault.
- In Azure DevOps pipelines, link Key Vault as a variable group (**Pipelines → Library → + Variable group → Link secrets from Azure Key Vault**).
- Reference them as pipeline variables: `$(my-secret-name)`.
- For gateway data source credentials in Fabric, use Windows authentication (Kerberos/NTLM) with a dedicated service account rather than SQL auth to avoid storing passwords.

This is a **[BLOCK]** item on the governance checklist.

> See also: [Governance Checklist](governance/governance-checklist.md), Section 3.3 and 4.3.

---

### Q: What is the minimum role required to run a Fabric Deployment Pipeline promotion?

| Action | Minimum Role Required |
|---|---|
| View pipeline content and comparison | Pipeline Viewer |
| Deploy (promote content) between stages | Pipeline Contributor (and at least **Contributor** on the target workspace) |
| Configure deployment rules | Pipeline Admin (or workspace Admin on the target stage) |
| Assign workspaces to stages | Pipeline Admin AND workspace **Admin** on the workspace being assigned |

For the workshop, all participants are assigned **Admin** on their workspaces and **Admin** on the pipeline to avoid permission friction.

> See also: [Workspace Strategy](architecture/workspace-strategy.md) — Permission Model.

---

## 9. Semantic Model & PBIP Artifacts

### Q: What does the PBIP folder structure look like and what does each file do?

```
<project>.pbip               ← pointer file that opens the project in Power BI Desktop
<project>.Report/
  definition.pbir            ← report metadata (format version, target model)
  definition/
    report.json              ← report page and visual definitions
    pages/
      <page-name>/
        page.json
<project>.SemanticModel/
  definition.pbism           ← semantic model metadata
  definition/
    model.tmdl               ← TMDL: tables, measures, relationships, roles
    tables/
      <table>.tmdl
```

All files are text-based and human-readable, making them diff-able in Git pull requests.

> See also: [Lab 1](workshop-plan/labs/lab1-connect-git.md), Part 2.2.

---

### Q: Power BI Desktop opened my file in "legacy" format instead of PBIP. How do I convert?

1. Open the `.pbix` file in Power BI Desktop (November 2023 build or later).
2. Go to **File → Save as**.
3. Change the file type to **Power BI Project (*.pbip)**.
4. Save to the `shared/pbip-local/` folder.
5. The `.pbip` pointer file and the `.Report/` and `.SemanticModel/` folders are created.

Confirm the TMDL format is used (not legacy JSON model) by checking whether `definition/model.tmdl` exists.

---

### Q: The CI pipeline validates structure but there are no DAX measures in the model. Why does `run_dax_tests.py` still run?

The DAX test script runs regardless of whether the model has measures because it also validates model presence and `dax-tests.json` metadata. If no catalog is found, the catalog check is skipped and structure checks still run. If `shared/dax-tests.json` exists, disabled tests appear as skipped in JUnit until they are customized and enabled.

If you want to skip DAX tests entirely for a project without measures (e.g., a report-only workspace), set `skipDaxTests: true` in the consumer pipeline parameters.

> See also: [shared/universal-pipeline/README.md](../shared/universal-pipeline/README.md) — Parameters.

---

## 10. Refresh Failures

### Q: The semantic model refresh fails immediately after a Dev → Test or Test → Prod promotion.

Work through this checklist before escalating:

- [ ] **Deployment rules applied?** Check the pipeline run details — confirm rules were applied during promotion (not skipped due to a configuration error).
- [ ] **Parameter rules correct?** Open the promoted model in the Test/Prod workspace → **Settings → Parameters** and confirm `ServerName` and `DatabaseName` reflect the correct environment values.
- [ ] **Gateway online?** Open the Power Platform admin center and confirm the gateway for the target stage is **Online**.
- [ ] **Gateway data source credentials valid?** Re-enter the credentials on the data source if in doubt — they do not expire automatically but can be invalidated by password rotation.
- [ ] **Network access?** The gateway host must be able to reach the SQL Server on TCP 1433. Run `Test-NetConnection` from the gateway host to verify.
- [ ] **Firewall rules?** SQL Server firewall and any intervening network firewalls must permit the gateway host's IP.

> See also: [On-Premises Gateway Architecture](architecture/gateway-deployment-pipeline.md) — Troubleshooting. [Lab 3](workshop-plan/labs/lab3-deployment-pipelines.md) — Troubleshooting.

---

### Q: Refresh succeeds but the data looks stale — it matches what was in Dev before promotion.

The semantic model is in **Import mode**. The content promoted to Test is a copy of the Dev model artifact — including the last-imported data snapshot. The data does not update until a **refresh is triggered in the target workspace**.

After every promotion:
1. Open the target workspace.
2. Click the semantic model → **Refresh now**.
3. Confirm the refresh completes against the correct data source (check the refresh history for the connection used).

For automated workflows, add a post-promotion step to the Azure DevOps release pipeline that calls the Fabric REST API to trigger a refresh:

```powershell
$workspaceId = "<target-workspace-id>"
$datasetId   = "<semantic-model-id>"

Invoke-PowerBIRestMethod `
    -Url "v1.0/myorg/groups/$workspaceId/datasets/$datasetId/refreshes" `
    -Method Post
```

> See also: [Lab 3](workshop-plan/labs/lab3-deployment-pipelines.md), Part 5.3 and 7.3.

---

### Q: Scheduled refresh is configured in Dev but not in Test or Prod after promotion.

Scheduled refresh settings are **not promoted** by the Fabric Deployment Pipeline. They must be configured independently in each workspace after the initial promotion:

1. Open the target workspace → semantic model → **Settings**.
2. Expand **Scheduled refresh**.
3. Configure the schedule (frequency, time, timezone).
4. Set **Send refresh failure notifications** to the workspace admin or a shared mailbox.

Consider scripting this via the Power BI REST API if you manage many models.

> See also: [Governance Checklist](governance/governance-checklist.md), Section 4.4 — Operational Readiness.

---

*For issues not covered here, check the [Microsoft Fabric documentation](https://learn.microsoft.com/fabric/) or raise a question in the workshop Teams channel.*


