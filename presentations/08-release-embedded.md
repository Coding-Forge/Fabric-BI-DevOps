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
    background-color: #1a1a2e;
    color: #ffffff;
    text-align: center;
  }
  section.lead h1, section.lead h2 { color: #ffffff; }
  section.lead p { color: #adbdcc; }
  h2 { color: #1a1a2e; border-bottom: 3px solid #1a1a2e; padding-bottom: 0.2em; }
  table { width: 100%; font-size: 0.82em; }
  th { background-color: #1a1a2e; color: #ffffff; }
  td { color: #1a1a1a; }
  tr:nth-child(even) td { background-color: #f0f0f0; }
  section.dark th { background-color: #0a0a1a; color: #ffffff; }
  section.dark td { color: #e8e8e8; }
  section.dark tr:nth-child(even) td { background-color: rgba(255,255,255,0.1); }
  section.green th { background-color: #166534; color: #ffffff; }
  section.green td { color: #1a1a1a; }
  section.green tr:nth-child(even) td { background-color: #d4edda; }
  code { background-color: #f0f4ff; color: #1a1a1a; border-radius: 4px; padding: 2px 5px; }
  pre { background-color: #1a1a2e; border-radius: 6px; }
  pre code { background-color: transparent; color: #c9d1d9; }
  section.dark {
    background-color: #0f172a;
    color: #ffffff;
  }
  section.dark h2 { color: #7dd3fc; border-color: #7dd3fc; }
  section.green {
    background-color: #f0fdf4;
  }
  section.green h2 { color: #166534; border-color: #166534; }
  section.green th { background-color: #166534; }
---
<!-- class: lead -->

# Publishing Artifacts
## Release Checklist & Power BI Embedded

`16:00 – 17:00`

---

## The Release Checklist — Why It Exists

> A pipeline can be green and a report can still be wrong.

CI validates _code quality_. The release checklist validates _business readiness_.

Before any production deployment, an owner works through the checklist to confirm:

- Data is correct and complete
- Security controls are in place and tested
- The content matches stakeholder expectations
- Nothing breaks when real users open it

---
<!-- class: green -->

## Release Checklist — CI/CD Gates

These must be **green** before the Deployment Pipeline runs:

- [ ] CI pipeline passing on `main` — all 3 stages (Validate, Test, Publish)
- [ ] JUnit test results: **0 failures**
- [ ] No `pbip-lint` errors
- [ ] `pbip-artifacts` published to ADO and downloadable
- [ ] Dev workspace synced to latest `main` (Approach A or B)
- [ ] Deployment rules verified for Test **and** Prod

---
<!-- class: green -->

## Release Checklist — Content Quality

- [ ] All report pages follow the agreed **theme file** (colors, fonts, logo)
- [ ] Visuals accessible: sufficient contrast, alt-text on images, descriptive tooltips
- [ ] No placeholder or test pages committed or published
- [ ] Page navigation consistent with UX standard
- [ ] No duplicate measures (validated via `pbi-tools` output or Tabular Editor BPA)
- [ ] All new model objects have descriptions (or waived by BI Lead)
- [ ] Dataset refresh in Test: **succeeded**

---
<!-- class: green -->

## Release Checklist — Security & Governance

- [ ] RLS roles tested with representative test user accounts
- [ ] No hardcoded connection strings or credentials in PBIP files
- [ ] Service principal used for all CI/CD operations (no human creds in pipelines)
- [ ] Sensitivity labels applied to semantic models containing PII or confidential data
- [ ] Column-level security validated for sensitive columns
- [ ] Workspace permissions reviewed — no over-privileged accounts in Prod

---
<!-- class: green -->

## Release Checklist — Final Approval

- [ ] UAT sign-off from designated stakeholder
- [ ] BI Lead manual approval in Deployment Pipeline (Test → Prod gate)
- [ ] Release note committed to repo: `CHANGELOG.md` or PR description
- [ ] Release tagged in Git: `vYYYY.MM.DD`
- [ ] Prod deployment logged in Deployment Pipeline audit trail
- [ ] Post-deployment refresh succeeded in **Prod** workspace
- [ ] Monitoring dashboard checked: no error spikes after release

---

## Publishing Artifacts — What Gets Published

From the CI pipeline `Publish` stage:

```
pbip-artifacts/
  fabric-workspace/
    SalesReport.Report/         ← validated report PBIP
    SalesModel.SemanticModel/   ← validated model PBIP
  test-results/
    test-results.xml            ← JUnit DAX test output
  validation-report.json        ← pbi-tools schema results
```

These artifacts are stored in **Azure DevOps Pipelines** and can be:
- Downloaded for audit purposes
- Used as inputs to downstream CD stages
- Referenced in the release notes

---
<!-- class: dark -->

## Power BI Embedded — App-Owns-Data

Used when embedding reports in **custom web applications** (external-facing or internal portals).

```
Custom Web App  →  Backend API  →  Azure AD  →  Fabric Workspace
     ↑                               ↓
     └──────── Embed Token ──────────┘
```

The backend acts as a **token broker** — credentials never reach the browser.

---

## App-Owns-Data — Authentication Flow

1. Web app requests a report via the backend
2. Backend authenticates as a **service principal**
3. Service principal gets an access token from Microsoft Entra ID
4. Backend calls Fabric API to generate an **embed token**
5. Embed token is returned to the frontend
6. Frontend loads the report using the **Power BI JavaScript SDK**

---

<!-- _style: "font-size: 0.84em; line-height: 1.4" -->

## Power BI Embedded — Service Principal Setup

1. **Register an app** in Azure Active Directory (App Registration)
2. Add API permissions: `Power BI Service → Report.ReadAll`, `Dataset.ReadAll`
3. Enable service principals in the **Fabric Admin Portal**:
   `Admin → Tenant settings → Developer settings → Allow service principals`
4. Add the service principal as a **Member** on the Fabric workspace
5. Store the app credentials in **Azure Key Vault**:
   - `SP-CLIENT-ID`
   - `SP-CLIENT-SECRET`
   - `SP-TENANT-ID`

> 🚫 Never hard-code service principal credentials in application code.

---

## Power BI Embedded — Security Considerations

| Concern | Mitigation |
|---------|-----------|
| Token leakage | Short-lived embed tokens (default: 1 hour); rotate regularly |
| Over-permissioned SP | Scope permissions to minimum required; use dedicated SP per app |
| RLS bypass | Validate `EffectiveIdentity` is set in token generation for RLS models |
| Content injection | Sanitize all `reportId` / `datasetId` inputs; never accept from user input |
| Audit trail | Log all token generation events; review Fabric activity logs |

---

## Communications Plan — Key Elements

When rolling out Git-based workflows to a team:

| Element | Detail |
|---------|--------|
| **Teams channel** | `#fabric-git-releases` for deployment notifications |
| **Weekly touchpoints** | 15 min standup — branch status, blockers, upcoming PRs |
| **Decision log** | Record branching strategy decisions in a shared doc |
| **PR review SLA** | PRs reviewed within 1 business day |
| **On-call rotation** | Assign someone for post-deployment monitoring each release |
| **Training plan** | Onboarding checklist for new team members |

---

## Workshop Summary — What You Built Today

| Capability | Tool |
|-----------|------|
| Source-controlled BI content | Fabric Git Integration + PBIP |
| Isolated feature development | Branch-out workspaces |
| Automated quality validation | Azure DevOps CI Pipeline |
| Automated Dev workspace sync | Fabric REST API |
| Environment promotion | Fabric Deployment Pipelines |
| Connection isolation per env | Deployment Rules |
| Production approval gate | Manual approval in Deployment Pipeline |
| Embedded analytics | Power BI Embedded + Service Principal |

---
<!-- class: lead -->

# 🎉 Workshop Complete

**Thank you for attending**
_Fabric + Git Essentials_

---

<!-- _style: "font-size: 0.84em; line-height: 1.4" -->

## Next Steps

- Apply the **branch-out pattern** to your next report development task
- Set up the CI pipeline in your team's ADO project
- Create the three-workspace (Dev / Test / Prod) environment
- Review the [Governance Checklist](../docs/governance/governance-checklist.md) with your BI Lead
- Explore [Lab guides](../docs/workshop-plan/labs/) for reference

**Resources:**
- [Workshop Repo README](../README.md)
- [Architecture Diagrams](../docs/architecture/fabric-git-integration.md)
- [Microsoft Learn — Fabric Git Integration](https://learn.microsoft.com/fabric/cicd/git-integration/intro-to-git-integration)
- [Microsoft Learn — Deployment Pipelines](https://learn.microsoft.com/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines)
