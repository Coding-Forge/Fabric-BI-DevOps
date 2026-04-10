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
    background-color: #4b0082;
    color: #ffffff;
    text-align: center;
  }
  section.lead h1, section.lead h2 { color: #ffffff; }
  section.lead p { color: #e9d8fd; }
  h2 { color: #4b0082; border-bottom: 3px solid #4b0082; padding-bottom: 0.2em; }
  table { width: 100%; font-size: 0.82em; }
  th { background-color: #4b0082; color: #ffffff; }
  td { color: #1a1a1a; }
  tr:nth-child(even) td { background-color: #f0f0f0; }
  section.dark th { background-color: #3a0063; color: #ffffff; }
  section.dark td { color: #e8e8e8; }
  section.dark tr:nth-child(even) td { background-color: rgba(255,255,255,0.1); }
  section.warning td { color: #1a1a1a; }
  section.warning tr:nth-child(even) td { background-color: #f5ead0; }
  code { background-color: #f5f0ff; color: #1a1a1a; border-radius: 4px; padding: 2px 5px; }
  section.dark {
    background-color: #1a1a2e;
    color: #ffffff;
  }
  section.dark h2 { color: #c8a8f9; border-color: #c8a8f9; }
  section.warning {
    background-color: #fff8e6;
  }
  section.warning h2 { color: #5c4400; border-color: #5c4400; }
---
<!-- class: lead -->

# Collaboration Patterns
## & Governance Best Practices

`11:30 – 12:15`

---

## The Problem With Shared Workspaces

> "I didn't know anyone else was editing that report"

Common failure modes without governance:

- Two developers edit the same semantic model simultaneously → last-save wins
- Someone deploys a broken measure directly to the workspace
- No one knows whose job it is to approve a change before it goes to prod
- RLS role bindings are inconsistent across Dev, Test, and Prod

**Governance is the policy layer that makes Git workflows stick.**

---

## Workspace Strategy

```
WS-Dev-<team>       ← Git-connected to main
WS-Dev-<alias>      ← Git-connected to feature branch (personal)
WS-Test-<team>      ← NOT Git-connected; populated by Deployment Pipeline
WS-Prod-<team>      ← NOT Git-connected; populated by Deployment Pipeline
```

**Rules:**
- Only the **Dev workspace** is Git-connected
- Test and Prod are **only ever updated via Deployment Pipelines** — never manually
- Personal feature workspaces are **ephemeral** — created per branch, deleted after merge

---

## Permission Model (Least Privilege)

| Role | Dev Workspace | Test Workspace | Prod Workspace |
|------|--------------|----------------|----------------|
| **Admin** | BI Lead, IT Sec | BI Lead | BI Lead only |
| **Member** | Senior BI Devs | QA leads | ❌ |
| **Contributor** | BI Developers | QA Testers | ❌ |
| **Viewer** | ❌ | Stakeholders | Report Consumers |

> 🚫 No human accounts hold Admin or Member in Prod other than the BI Lead.
> 🤖 CI/CD operations run as a **service principal** — never human credentials.

---

## Naming Conventions

| Object | Pattern | Example |
|--------|---------|---------|
| Workspaces | `WS-{Env}-{Team}` | `WS-Dev-FinanceBI` |
| Feature workspaces | `WS-Dev-{alias}` | `WS-Dev-bcampbell` |
| Feature branches | `feature/{alias}-{task}` | `feature/bcampbell-ytd` |
| Fix branches | `fix/{alias}-{description}` | `fix/jsmith-date-table` |
| Release tags | `v{YYYY.MM.DD}` | `v2026.04.10` |
| Semantic models | `{Domain}Model` | `SalesModel` |
| Reports | `{Audience}-{Topic}` | `Exec-SalesDashboard` |

---

## Pull Request Standards

Every PR to `main` must include:

- **Title:** `<type>: <short description>` (`feat:`, `fix:`, `refactor:`)
- **Description:** what changed, why, and any testing notes
- **Linked work item** (if using Azure Boards)
- **Minimum 1 reviewer** assigned
- **CI checks passing** (after Lab 2)
- **No unresolved comments** before merge

> 💡 Create a PR template at `.azuredevops/pull_request_template.md` to enforce this automatically.

---
<!-- class: dark -->

## RLS / CLS Governance

**Row-level security must be consistent across all environments.**

```
# In TMDL — committed to Git, reviewed in PRs
role 'RegionManagers'
    tablePermission Sales = [Region] = USERPRINCIPALNAME()
```

Before any promotion:
- [ ] All RLS roles verified in current environment
- [ ] Test RLS by signing in as a representative user
- [ ] No `*` (all rows) roles in Test or Prod unless explicitly approved
- [ ] CLS (Column-level security) validated for sensitive columns (salary, PII)

---

## RACI Matrix

| Activity | Responsible | Accountable | Consulted | Informed |
|----------|-------------|-------------|-----------|----------|
| Model changes | Data Engineer | BI Lead | Security, DBA | Stakeholders |
| Report pages | BI Developer | BI Lead | UX, SMEs | Stakeholders |
| CI/CD pipeline | DevOps | BI Lead | CSA, IT | Team |
| Workspace permissions | Admin | IT Security | CSA | Team |
| Production promotion | DevOps | BI Lead | IT Sec | Stakeholders |
| RLS review | BI Developer | IT Security | Compliance | BI Lead |

---
<!-- class: warning -->

## Common Anti-Patterns to Avoid

| Anti-Pattern | Why It's a Problem | Better Approach |
|---|---|---|
| Editing directly in `WS-Dev-<team>` | In-progress work visible to everyone | Use feature workspace |
| Direct commits to `main` | Bypasses review and CI | Require PRs + branch policies |
| Shared credentials in pipelines | Security risk, audit failure | Service principal + Key Vault |
| Only one workspace for all envs | No isolation, no safe testing | Dev / Test / Prod separation |
| Manual production deployments | Undocumented, unrepeatable | Deployment Pipelines only |

---

<!-- _style: "font-size: 0.78em; line-height: 1.4" -->
## Governance Checklist — Key Gates

| Gate | Checks |
|------|--------|
| **Before PR** | `pbi-tools validate` passes · No hardcoded credentials · New measures have descriptions |
| **Dev → Test** | CI pipeline green on `main` · JUnit: 0 failures · Dev workspace refresh succeeded |
| **Test → Prod** | RLS roles tested with representative users · Dataset refresh succeeded in Test · BI Lead manual approval |

---
<!-- class: lead -->

# 🍽️ Lunch

### 12:15 – 13:00

**Back at 13:00 for Deployment Strategy**
