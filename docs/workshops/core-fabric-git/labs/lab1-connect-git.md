---
title: "Lab 1 — Connect a Fabric Workspace to Git"
description: "Step-by-step lab guide for connecting a Microsoft Fabric workspace to an Azure DevOps or GitHub repository, creating feature branches, and submitting a pull request."
lab: 1
duration: "60 minutes"
---

# Lab 1 — Connect a Fabric Workspace to Git

## Overview

In this lab you will connect a Microsoft Fabric workspace to a Git repository hosted in **Azure DevOps** or **GitHub**. You will perform an initial sync, create a feature branch, make a small change to a report, and submit a pull request back to `main`.

By the end of the lab your workspace will be under full source control and every future change will be tracked as a Git commit.

---

## Objectives

1. Enable and configure **Git integration** on a Fabric workspace  
2. Perform the initial **workspace → repo sync**  
3. Create a **feature branch** from `main`  
4. Make a report or semantic model change  
5. Commit and push the change  
6. Open a **pull request**, request a review, and merge  

---

## Prerequisites

| Requirement | Detail |
|---|---|
| Fabric workspace | Capacity-backed (F2 or higher); you need **Contributor** or higher role |
| Git repo | An Azure DevOps project **or** a GitHub repository you can push to |
| Permissions | Ability to create branches and open PRs in the repo |
| Fabric admin toggle | **Users can synchronize workspace items with their Git repositories** — must be enabled in the Fabric Admin portal |
| Authentication | OAuth (default) **or** a Personal Access Token (PAT) scoped to `Code (Read & Write)` |
| Sample project | PBIP starter project cloned locally (provided by facilitator) |

---

## Part 1 — Enable Git Integration on Your Workspace

### 1.1 Open Workspace Settings

1. Navigate to your assigned **Dev workspace** in the Microsoft Fabric portal.  
2. Click the **ellipsis (…)** next to the workspace name in the left nav, then choose **Workspace settings**.  
3. Select the **Git integration** tab.

### 1.2 Connect to Your Git Provider

1. Under **Connect to Git**, choose your provider:
   - **Azure DevOps** — or —  
   - **GitHub**

2. Sign in with your organizational account when prompted.

3. Fill in the connection fields:

   | Field | Value |
   |---|---|
   | Organization | Your Azure DevOps org **or** GitHub org/user |
   | Project | *(Azure DevOps only)* Your project name |
   | Repository | The repo designated for this workshop |
   | Branch | `main` |
   | Folder path | `/projects` *(or as directed by facilitator)* |

4. Click **Connect and sync**.

> **Tip:** If OAuth is blocked by a Conditional Access policy, generate a PAT in Azure DevOps under **User Settings → Personal Access Tokens** with `Code (Read & Write)` scope and paste it when prompted.

---

## Part 2 — Verify the Initial Sync

After connecting, Fabric performs an initial synchronization and exports all workspace items as text-based PBIP artifacts to the configured repo folder.

### 2.1 Confirm Git Status in Fabric

1. Return to the workspace view.  
2. Each item (reports, semantic models, dataflows) now shows a **Git status badge** — look for a green check ✔ (synced) or an orange indicator (uncommitted changes).  
3. All badges should show **Synced** at this point.

### 2.2 Confirm Artifacts in the Repo

1. Open your repo in Azure DevOps or GitHub.  
2. Navigate to the folder path you specified (e.g., `/projects`).  
3. Verify the PBIP folder structure exists:

```
shared/
   <your-project>.pbip
   <your-project>.Report/
      definition.pbir
      definition/report.json
   <your-project>.SemanticModel/
      definition.pbism
      definition/model.tmdl
```

---

## Part 3 — Create a Feature Branch

Working directly on `main` is prohibited by branch policy. All changes must go through a short-lived feature branch.

### 3.1 Create the Branch in Your Git Provider

**Azure DevOps:**
1. Go to **Repos → Branches**.  
2. Click **New branch**.  
3. Name it `feature/<your-alias>-lab1` (e.g., `feature/bcampbell-lab1`).  
4. Base it on `main`.  
5. Click **Create**.

**GitHub:**
1. Go to the repository and open the **Branch** drop-down.  
2. Type `feature/<your-alias>-lab1` and click **Create branch**.

### 3.2 Switch the Workspace to Your Feature Branch

1. Back in the Fabric workspace, open **Workspace settings → Git integration**.  
2. Under **Branch**, click **Switch branch** (or **Checkout branch**).  
3. Select your newly created `feature/<your-alias>-lab1` branch.  
4. Click **Update**.

Fabric re-syncs the workspace to your feature branch. The status bar at the top of the workspace now shows your branch name.

---

## Part 4 — Make a Change

### 4.1 Edit a Report in the Fabric Portal

1. Open **SalesReport** (or the report provided by the facilitator).  
2. Add a new **text box** to the first page with the text: `Updated by <your name> — Lab 1`.  
3. Save the report (**Ctrl + S** or the Save button).

### 4.2 Review Uncommitted Changes

1. In the workspace view, the report item now shows a **pencil / modified** Git badge.  
2. Click **Source control** (the Git icon in the top-right corner of the portal) to open the **Pending changes** panel.  
3. Verify your change appears in the diff.

### 4.3 Commit and Push

1. In the **Pending changes** panel:
   - Provide a **commit message**: `feat: add lab1 text box to SalesReport`  
   - Leave all changed items checked.  
2. Click **Commit**.  
3. Fabric commits the change to your feature branch in the remote repo.

---

## Part 5 — Open a Pull Request

### 5.1 Create the PR

**Azure DevOps:**
1. Go to **Repos → Pull Requests → New pull request**.  
2. Set **Source** = `feature/<your-alias>-lab1` and **Target** = `main`.  
3. Add a meaningful title: `[Lab 1] Add lab1 text box to SalesReport`.  
4. Add a description, link any work items if applicable.  
5. Add at least one reviewer (your lab partner or the facilitator).  
6. Click **Create**.

**GitHub:**
1. Navigate to the repository and click **Compare & pull request** when the branch prompt appears.  
2. Set the base to `main` and the compare to your feature branch.  
3. Fill in the title and description, assign a reviewer.  
4. Click **Create pull request**.

### 5.2 Review and Merge

1. The reviewer approves the PR.  
2. Confirm branch policies (if configured) pass — e.g., status checks, required reviewers.  
3. Click **Complete / Merge pull request** using **Squash merge** (recommended).  
4. Delete the feature branch after merge.

### 5.3 Sync Fabric Workspace Back to `main`

1. In Workspace settings → Git integration, switch the branch back to `main`.  
2. Click **Update**.  
3. Confirm all items show **Synced** status.

---

## Validation Checklist

Use this checklist to confirm you have completed the lab successfully:

- [ ] Workspace is connected to the Git repo and shows Git status badges  
- [ ] Initial sync completed — PBIP artifacts are visible in the repo  
- [ ] Feature branch created and workspace switched to it  
- [ ] A change was made, committed, and pushed from the Fabric portal  
- [ ] Pull request opened with a reviewer assigned  
- [ ] PR approved and merged to `main`  
- [ ] Workspace switched back to `main` and shows **Synced**  

---

## Troubleshooting

| Issue | Resolution |
|---|---|
| "Git integration not available" in settings | Confirm the Fabric admin toggle is enabled for your tenant. Contact your Fabric Admin. |
| OAuth sign-in fails | Use a PAT instead. Scope: `Code (Read & Write)`, expiry ≥ workshop date. |
| Items show "Conflict" status | Another team member may have pushed a change. Pull the latest, resolve conflicts in the portal, then recommit. |
| Repo folder appears empty after sync | Check that the folder path is correct and has no leading slash issues. Re-attempt sync. |
| Branch switch fails | Ensure you have at least **Contributor** role on the workspace and **Write** access to the repo. |

---

## Extension — Branch-Out Strategy (Personal Feature Workspace)

In this lab you connected a workspace to `main` and switched it to a feature branch. In real team development, the recommended pattern goes one step further: each feature branch gets its own **dedicated personal workspace** — you never work directly in the shared team workspace.

### Why branch out?

- Your in-progress work (broken measures, experimental layouts) is invisible to teammates in the shared workspace  
- You can iterate freely without risk of disrupting others  
- Reviewers can connect to your feature workspace to see live rendered reports, not just file diffs  
- Deleting the feature workspace and branch is a complete, clean rollback  

### How to set up a personal feature workspace

1. Click **+ New workspace** in the Fabric portal left nav.  
2. Name it `WS-Dev-<your-alias>` (e.g., `WS-Dev-bcampbell`).  
3. Assign it to the same Fabric capacity as the shared team workspace.  
4. Go to **Workspace settings → Git integration** and connect it to the same repo — but set the **Branch** to your feature branch, not `main`.  
5. Click **Connect and sync**. The workspace loads from your feature branch.  
6. Work in this personal workspace for the duration of the feature.  
7. After your PR merges, **delete this workspace** — its branch is gone and so is the workspace.

For the complete workflow, topology diagrams, naming conventions, and anti-patterns, see the [Branching Strategy](../../architecture/branching-strategy.md) architecture document.

---

## Next Steps

Proceed to **[Lab 2 — CI/CD Pipeline for PBIP](lab2-ci-pipeline.md)** to automate validation, artifact publication, and workspace deployment for the artifacts you just pushed to your repository.

