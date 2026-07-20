---
title: "Governance Checklist — Enterprise BI DevOps with Microsoft Fabric"
description: "Pre-go-live and ongoing governance checklist for Microsoft Fabric workspaces using Git-based lifecycle management."
---

# Governance Checklist

Use this checklist at each stage of the development lifecycle to ensure Fabric workspaces and PBIP artifacts meet governance, security, and quality standards before promotion or release.

---

## How to Use

- Work through each section at the appropriate lifecycle stage (noted in each heading).  
- Check off every item before proceeding to the next environment.  
- For items marked **[BLOCK]** — the deployment must be halted until resolved.  
- Assign an owner to any item that is not yet complete.  
- Use `tools/enterprise-standards-builder/index.html` to define the project quality policy and generate the rule JSON used by CI.
- Use `tools/rule-designer/index.html` to tune individual report or dataset rules when exceptions or custom checks are needed.

---

## 1. Workspace Setup *(one-time, at project start)*

### 1.1 Workspace Configuration

- [ ] Workspace is assigned to a **Fabric capacity** (F2+) or PPU license  
- [ ] Workspace name follows the naming convention: `WS-{Env}-{Team}` **[BLOCK]**  
- [ ] Workspace description is filled in (purpose, owning team, contact)  
- [ ] The correct **capacity region** is used (data residency requirements met)  

### 1.2 Permission Model

- [ ] Roles assigned following least-privilege model (see [Workspace Strategy](../architecture/workspace-strategy.md))  
- [ ] No personal accounts hold Admin or Member in **Prod** other than the team lead **[BLOCK]**  
- [ ] **Service principal** is created and assigned for CI/CD operations; human credentials are not embedded in pipelines **[BLOCK]**  
- [ ] OneLake data access model reviewed for lakehouses, warehouses, shortcuts, and item shares (see [OneLake Security Guidance](onelake-security.md))  
- [ ] Access reviewed and approved by the BI Lead or IT Security  

### 1.3 Git Integration

- [ ] Git integration enabled and connected to the correct repo and branch  
- [ ] Only the **Dev** workspace is Git-connected (Test and Prod are not) **[BLOCK]**  
- [ ] Branch policies are enabled on `main`:
  - [ ] Minimum 1 reviewer required  
  - [ ] CI build passing required  
  - [ ] Comment resolution required  
- [ ] Service principal has **Contributor** (Code) access on the repo  

---

## 2. Pre-PR / Code Review *(every pull request)*

### 2.1 Code Quality

- [ ] `tests/validate_pbip_structure.py` passes before opening the PR  
- [ ] Dataset and report quality rule checks pass in CI  
- [ ] `shared/Rules-Dataset.json` and `shared/Rules-Report.json` align to the approved Enterprise Standards Builder policy profile  
- [ ] No hardcoded connection strings, passwords, or keys in PBIP JSON/YAML/TMDL  
- [ ] Measure and column descriptions added for all new model objects (or waived by BI Lead)  

### 2.2 Design Standards

- [ ] Report pages follow the agreed **theme file** (colors, fonts, logo)  
- [ ] All visuals are accessible: sufficient contrast, alt-text on images, tooltips are descriptive  
- [ ] No "placeholder" test pages or hidden pages committed  
- [ ] Page navigation is consistent with the UX standard  

### 2.3 Semantic Model

- [ ] No duplicate measures (check via Tabular Editor BPA output in CI)  
- [ ] Relationship cardinality is correct — no unintentional many-to-many relationships  
- [ ] All date tables are marked as *Date Table* with the correct date column  
- [ ] Import vs DirectQuery mode is intentional and documented in the PR description  

---

## 3. Dev → Test Promotion

### 3.1 CI/CD Gates **[BLOCK if any item fails]**

- [ ] CI pipeline is **green** on `main` at the commit being promoted  
- [ ] All three CI stages (Validate, Test, Publish) passed  
- [ ] JUnit test results show 0 failures  
- [ ] Schema diff reviewed — no unintentional structural changes  

### 3.2 Data Validation

- [ ] Dataset refresh completed successfully in the **Dev** workspace  
- [ ] Row counts are within expected ranges (compare to previous refresh)  
- [ ] No refresh errors in the activity log  

### 3.3 Deployment Pipeline

- [ ] Fabric Deployment Pipeline configured with Dev, Test, and Prod stages  
- [ ] Connection string parameters swapped for the **Test** data source  
- [ ] Secrets retrieved from **Azure Key Vault** (not embedded in pipeline config) **[BLOCK]**  

---

## 4. Test → Prod Promotion *(pre-release)*

### 4.1 UAT Sign-Off

- [ ] Stakeholder UAT completed with documented sign-off  
- [ ] All UAT-raised defects resolved or formally deferred with owner and date  
- [ ] Acceptance criteria from the Sprint/Release backlog met  

### 4.2 Security & Compliance **[BLOCK if any item fails]**

- [ ] **RLS (Row-Level Security)** rules validated for all defined roles  
  - [ ] Each persona tested with `USERPRINCIPALNAME()` or role membership  
  - [ ] No row data leaks across role boundaries  
- [ ] **CLS (Column-Level Security)** reviewed — sensitive columns hidden from non-privileged roles  
- [ ] **OneLake security roles** reviewed for lakehouses and data items; Viewer users receive only intended table, folder, row, and column access  
- [ ] Lakehouse `DefaultReader` roles reviewed, modified, or removed where broad ReadAll access is not appropriate  
- [ ] OneLake shortcuts reviewed for source ownership, data classification, and effective access  
- [ ] **Sensitivity labels** applied to datasets and reports per data classification policy  
- [ ] No PII or confidential data in report titles, tooltips, or visible measure strings  

### 4.3 Prod Workspace Verification

- [ ] Prod workspace permissions follow the production role matrix (Viewer for all non-admins)  
- [ ] Prod connection parameters point to the **production data source** **[BLOCK]**  
- [ ] Azure Key Vault references updated for Prod environment  
- [ ] Previous Prod content backed up (or version in Git is sufficient as rollback)  

### 4.4 Operational Readiness

- [ ] Dataset scheduled refresh configured and tested in Prod  
- [ ] Failure notifications configured (email or Teams alert on refresh failure)  
- [ ] Monitoring: Fabric capacity metrics and workspace activity logs reviewed  
- [ ] Data dictionary / report documentation published or linked from the report  

---

## 5. Post-Release *(within 48 hours of Prod promotion)*

- [ ] Prod dataset refreshed at least once on the new schedule without errors  
- [ ] End-user spot check: 3–5 users confirm key visuals are correct  
- [ ] Release tag created in Git: `vYYYY.MM.DD` pointing to the merge commit  
- [ ] Release notes published (what changed, known issues, support contact)  
- [ ] Retro item logged if any **[BLOCK]** items were triggered during this cycle  

---

## 6. Ongoing Governance *(quarterly review)*

- [ ] Workspace access review — remove stale users and service principals  
- [ ] Branch policies still enforced on `main`  
- [ ] CI pipeline is still running and all steps are current (tool versions, Python version)  
- [ ] Sensitivity labels reviewed against current data classification standards  
- [ ] Capacity usage within budget; resize if trend shows sustained overuse  
- [ ] Endorsement status reviewed: only **Certified** datasets used in Prod reports  
- [ ] Audit log reviewed for anomalous access patterns  

---

## RACI Reference

| Activity | Responsible | Accountable | Consulted | Informed |
|---|---|---|---|---|
| Model changes | Data Engineer | BI Lead | DBA, Security | Stakeholders |
| Report pages | BI Developer | BI Lead | UX, SMEs | Stakeholders |
| CI/CD pipeline | DevOps / BI Dev | BI Lead | IT/CSA | Team |
| Workspace permissions | IT Admin | IT Security | BI Lead | Team |
| RLS/CLS validation | BI Developer | BI Lead | Security | Stakeholders |
| Prod promotion | BI Lead | Product Owner | IT Security | Stakeholders |

---

## Related Documents

- [Workspace Strategy](../architecture/workspace-strategy.md)  
- [OneLake Security Guidance](onelake-security.md)  
- [CI/CD Architecture](../architecture/cicd-architecture.md)  
- [Rules Authoring Guide](../Rules-Authoring-Guide.md)  
- [Lab 1 — Connect Workspace to Git](../workshops/core-fabric-git/labs/lab1-connect-git.md)  
- [Lab 2 — CI/CD Pipeline for the Power BI Project](../workshops/core-fabric-git/labs/lab2-ci-pipeline.md)

