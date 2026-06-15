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
  h2 { color: #0078D4; border-bottom: 3px solid #0078D4; padding-bottom: 0.2em; }
  table { width: 100%; font-size: 0.85em; }
  section th { background-color: #004f8e; color: #ffffff; }
  section td { color: #1a1a1a; background-color: #ffffff; }
  section td code { background-color: #e0e7f1; color: #0a0a0a; padding: 2px 5px; border-radius: 4px; }
  section tr:nth-child(even) td { background-color: #f0f0f0; }
  section.dark th { background-color: #003a6c; color: #ffffff; }
  section.dark td { color: #ffffff; background-color: #1a1a2e; }
  section.dark td code { background-color: #2d2d4a; color: #ffffff; padding: 2px 5px; border-radius: 4px; }
  section.dark tr:nth-child(even) td { background-color: #2a2a42; }
  code { background-color: #f0f4ff; color: #1a1a1a; border-radius: 4px; }
  pre { background-color: #1a1a2e; border-radius: 6px; }
  pre code { background-color: transparent; color: #c9d1d9; }
  section.dark {
    background-color: #1a1a2e;
    color: #ffffff;
  }
  section.dark h2 { color: #50b8f8; border-color: #50b8f8; }
  .callout {
    background: #e8f4fd;
    border-left: 4px solid #0078D4;
    padding: 0.5em 1em;
    border-radius: 0 6px 6px 0;
  }
---
<!-- class: lead -->

# Version Control in Fabric & PBIP
## Git with Azure DevOps / GitHub

`09:20 – 10:15`

---

## Why Version Control for BI?

**Software teams have solved this for decades. BI is catching up.**

| Traditional BI | Git-backed BI |
|----------------|---------------|
| Edit directly in shared workspace | Work in isolated feature branches |
| No change history | Every change is a dated, authored commit |
| "Who broke the report?" — unknown | Git blame + PR history |
| Manual promotion steps | Automated CI/CD pipeline |
| One person deploys to prod | PR approval + status checks required |

---

## The PBIP File Structure

```
projects/
├── <your-project>.pbip
├── <your-project>.Report/
│   ├── definition.pbir
│   ├── definition/
│   │   └── report.json
│   └── StaticResources/
│       └── SharedResources/
└── <your-project>.SemanticModel/
  ├── definition.pbism
  └── definition/
    ├── tables/
    │   ├── Sales.tmdl
    │   └── Date.tmdl
    └── relationships.tmdl
```

All files are **plain text** → diffable, reviewable, mergeable.

---
<!-- class: dark -->

## What TMDL Looks Like

```
table Sales
    measure [Total Sales] =
        SUMX(Sales, Sales[Quantity] * Sales[Unit Price])
        formatString: "$#,##0"
        displayFolder: "Revenue"

    measure [YTD Sales] =
        TOTALYTD([Total Sales], 'Date'[Date])
        formatString: "$#,##0"
        displayFolder: "Revenue"
```

A measure change shows up in a PR as a **3-line diff** — not a binary blob.

---

## Git Integration in Fabric — How It Works

1. **Admin enables toggle** in Fabric Admin Portal
   → *"Users can synchronize workspace items with their Git repositories"*

2. **Developer connects workspace** to a repo + branch

3. Fabric exports all workspace items as PBIP text artifacts to the repo folder

4. From that point, **every save** can be committed; **every pull** brings in reviewed changes

5. Git status icons appear on items in the workspace view

---

## Recommended Branching Strategy

**Trunk-based development:**

```
main  ←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←
  ↑                        ↑                    ↑
  PR + CI ✅               PR + CI ✅           PR + CI ✅
  │                        │                    │
feature/bcampbell-ytd   feature/jsmith-rls   feature/ateam-refactor
```

- `main` is **always deployable**
- Feature branches are **short-lived** (< 5 days)
- **No direct commits** to `main` — PRs only
- Releases tagged: `vYYYY.MM.DD`

---

## The Branch-Out Pattern — Feature Workspaces

> One feature branch = one dedicated Fabric workspace

| Workspace | Branch | Purpose |
|-----------|--------|---------|
| `WS-Dev-<team>` | `main` | Shared — reflects latest reviewed state |
| `WS-Dev-<alias>` | `feature/<alias>-*` | Personal — fully isolated |
| `WS-Dev-<team>-<feature>` | `feature/<team>-*` | Scoped — multi-dev collaboration |

**Why it matters:**
- In-progress work is never visible in the shared workspace
- Reviewers can open the feature workspace and **preview live reports** before approving the PR
- Delete the branch + workspace → instant rollback

---

## Branch Naming Convention

```
feature/<alias>-<short-description>
```

| Example | What It Does |
|---------|-------------|
| `feature/bcampbell-sales-ytd` | Add YTD sales measure |
| `feature/jsmith-rls-update` | Update RLS role bindings |
| `feature/ateam-model-refactor` | Refactor semantic model |
| `fix/bcampbell-date-table` | Fix a broken date relationship |

---

## Git Workflow — Day-to-Day

```
1. git checkout -b feature/<alias>-<task> origin/main
2. git push -u origin feature/<alias>-<task>

3. Connect new Fabric workspace to this branch
4. Make changes in Power BI Desktop or Fabric portal
5. Commit + push

6. Open Pull Request → assign reviewers
7. CI/CD pipeline runs automatically
8. Reviewer previews report in feature workspace
9. PR approved → merge to main
10. Validated content deploys to Dev automatically
```

---

## Connecting a Workspace to Git

**Workspace → Settings → Git integration**

1. Choose provider: **Azure DevOps** or **GitHub**
2. Authenticate (OAuth or PAT)
3. Fill in: Organization / Project / Repository / Branch / Folder
4. Click **Connect and sync**
5. Fabric exports all items → repo folder populated
6. Workspace items show Git status indicators

> 💡 If OAuth is blocked by Conditional Access, use a PAT scoped to `Code (Read & Write)`

---

## What Gets Synced?

| Fabric Item | Synced? | Format |
|-------------|---------|--------|
| Reports | ✅ | PBIP JSON / report.json |
| Semantic Models | ✅ | TMDL or model.bim |
| Notebooks | ✅ | .ipynb JSON |
| Dataflows Gen2 | ✅ | JSON |
| Pipelines | ✅ | JSON |
| Lakehouses | ⚠️ Metadata only | JSON |
| Warehouses | ⚠️ Metadata only | JSON |
| Dashboards | ❌ | Not supported |

---
<!-- class: lead -->

# ☕ Break

### 10:15 – 10:30

**Lab 1 starts at 10:30**
Come back with your environment ready ✅
