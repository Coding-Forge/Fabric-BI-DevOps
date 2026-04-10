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
  table { width: 100%; font-size: 0.82em; }
  th { background-color: #0f5132; color: #ffffff; }
  td { color: #1a1a1a; }
  tr:nth-child(even) td { background-color: #f0f0f0; }
  section.step td { color: #1a1a1a; }
  section.step tr:nth-child(even) td { background-color: #e8e8e8; }
  code { background-color: #f0fff4; color: #1a1a1a; border-radius: 4px; padding: 2px 5px; }
  pre { background-color: #1a1a2e; border-radius: 6px; }
  pre code { background-color: transparent; color: #c9d1d9; }
  section.step {
    background-color: #f8f9fa;
  }
  section.step h2 { color: #0f5132; }
  .badge {
    display: inline-block;
    background: #0f5132;
    color: white;
    border-radius: 50%;
    width: 1.8em;
    height: 1.8em;
    text-align: center;
    line-height: 1.8em;
    font-weight: bold;
    margin-right: 0.3em;
  }
---
<!-- class: lead -->

# 🧪 Lab 1
## Connect a Fabric Workspace to Git

**Duration: 60 minutes**
`10:30 – 11:30`

_Branch · Sync · PR · Merge_

---

## Lab 1 Objectives

By the end of this lab you will have:

1. Connected a Fabric workspace to an Azure DevOps or GitHub repo
2. Completed the initial **workspace → repo sync**
3. Created a **feature branch** from `main`
4. Made a report or model change in an isolated workspace
5. Committed and pushed the change
6. Opened a **pull request**, had it reviewed, and merged it

---

## Your Lab Environment

| Item | Value |
|------|-------|
| Workspace | `WS-Dev-<team>` assigned to you by facilitator |
| Git provider | Azure DevOps or GitHub (as configured) |
| Repo | `fabric-git-essentials-<team>` |
| Branch policy | PR required; 1 reviewer; CI check (after Lab 2) |
| PBIP starter | Pre-cloned in your assigned workspace folder |

> ⚠️ Do **not** work directly in `WS-Dev-<team>`. You will create your own feature workspace in Part 2.

---
<!-- class: step -->

## Part 1 — Connect the Shared Dev Workspace

**Workspace → Settings → Git integration**

1. Open `WS-Dev-<team>` in the Fabric portal
2. Click **⋯ → Workspace settings → Git integration**
3. Choose your provider (Azure DevOps / GitHub)
4. Authenticate when prompted
5. Fill in the connection fields:

| Field | Value |
|-------|-------|
| Organization | Your org name |
| Repository | `fabric-git-essentials-<team>` |
| Branch | `main` |
| Folder path | `/fabric-workspace` |

6. Click **Connect and sync**

---
<!-- class: step -->

## Part 1 — Verify the Sync

After connecting, Fabric exports all workspace items to the repo.

**In the Fabric portal:**
- Workspace items show **Git status indicators** (green check = committed)
- The Source control panel shows "0 pending changes"

**In the repo (Azure DevOps / GitHub):**
- Navigate to `Repos → Files → /fabric-workspace`
- You should see PBIP folders for each report and semantic model

> ✅ Checkpoint: If you can see the files in the repo, Part 1 is complete.

---
<!-- class: step -->

## Part 2 — Create Your Feature Branch

**In Azure DevOps:**
```
Repos → Branches → New branch
  Name:   feature/<your-alias>-lab1
  Based on: main
```

**Or using Git CLI:**
```bash
git fetch origin
git checkout -b feature/<your-alias>-lab1 origin/main
git push -u origin feature/<your-alias>-lab1
```

---
<!-- class: step -->

## Part 2 — Provision Your Personal Feature Workspace

> You work in your **own workspace** — never directly in the shared one.

1. In the Fabric portal, click **+ New workspace** (left nav)
2. Name it: `WS-Dev-<your-alias>` (e.g., `WS-Dev-bcampbell`)
3. Assign it to the **same Fabric capacity** as `WS-Dev-<team>`
4. Open **Workspace settings → Git integration**
5. Connect to your **feature branch** (not `main`):
   - Branch: `feature/<your-alias>-lab1`
   - Folder: `/fabric-workspace`
6. Click **Connect and sync**

Your personal workspace is now isolated from the shared one. ✅

---
<!-- class: step -->

## Part 3 — Make a Change

In your personal workspace (`WS-Dev-<alias>`):

1. Open the **SalesReport** report → click **Edit**
2. Add a new text box on Page 1: `Lab 1 — <your alias>`
3. Save the report
4. In the **Source control** panel (Git icon, top right):
   - Review the changed files
   - Add a commit message: `feat: lab1 change by <alias>`
   - Click **Commit**
5. The change is now pushed to `feature/<alias>-lab1` in the repo

---
<!-- class: step -->

## Part 4 — Open a Pull Request

**In Azure DevOps / GitHub:**

1. Navigate to the repo → **Pull Requests → New PR**
2. Set:
   - **Source branch:** `feature/<your-alias>-lab1`
   - **Target branch:** `main`
3. Title: `Lab 1: initial workspace sync — <alias>`
4. Description: briefly describe the change
5. Assign the person next to you as **reviewer**
6. Click **Create**

---
<!-- class: step -->

## Part 4 — Review the PR

**As reviewer:**
1. Open the PR → review the **Files changed** tab
2. Look at the JSON diff — can you see the text box change?
3. Leave a comment: ✅ or request a change
4. Click **Approve**

---
<!-- class: step -->

## Part 4 — Merge & Verify

**As author:**
1. Once approved, click **Complete / Merge**
2. Choose **Squash merge** (keeps history clean)
3. Delete the feature branch after merging

**Verify:** Open `WS-Dev-<team>` → **Source control → Update all** to sync the merged change into the shared workspace.

---

## Lab 1 — Validation Checklist

- [ ] `WS-Dev-<team>` shows Git-connected status ✅
- [ ] Initial sync complete — PBIP files visible in repo
- [ ] Feature branch created: `feature/<alias>-lab1`
- [ ] Personal feature workspace created and connected
- [ ] Change committed from the Fabric Source control panel
- [ ] PR opened with at least 1 reviewer assigned
- [ ] PR reviewed and merged to `main`
- [ ] Shared Dev workspace reflects the merged change

---
<!-- class: lead -->

# ✅ Lab 1 Complete

**Next: Collaboration Patterns & Governance**
`11:30 – 12:15`

Lunch at 12:15 — see you back at 13:00 for **Deployment Strategy**
