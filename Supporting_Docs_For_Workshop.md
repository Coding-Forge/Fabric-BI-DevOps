
---
title: "Supporting Documents for Fabric + Git Workshop"
description: "Mapped reference materials, resource links, and detailed topic-by-topic support for the Fabric + Git Version Control Workshop."
author: Brandon Campbell
version: 1.0
---

# Supporting Documents for Fabric + Git Workshop
This document provides a **topic‑by‑topic mapping** of supporting resources, internal references, lab materials, and guides used throughout the **Fabric + Git Version Control Workshop**.

It acts as a companion index to the main workshop plan, ensuring you can quickly attach the correct internal documents and reference material to each session.

---

# 1. Workshop Topics & Supporting Documents Table

| Agenda Topic & Time | Key Supporting Documents / Resources |
|---------------------|---------------------------------------|
| **Kickoff, Objectives, Roles, Prerequisites**<br>(09:00–09:20) | Workshop Overview (agenda, objectives); Governance deck; Connect Fabric Workspaces to ADO prereqs |
| **Version Control in Fabric & PBIP**<br>(09:20–10:15) | Git integration overview; PBIP basics; Branching & workspace separation guides |
| **Lab #1 — Connect Workspace to Git**<br>(10:30–11:30) | Lab Guide for Git connection; Boeing‑branded slides; CI/CD architecture diagrams |
| **Collaboration Patterns & Best Practices**<br>(11:30–12:15) | DataOps deck; Governance essentials; RACI examples; Go‑Live assessment |
| **Deployment Strategy: Dev→Test→Prod**<br>(13:00–13:45) | CI/CD Delivery Guide; Enterprise‑scale Power BI Dev examples; Deployment pipeline docs |
| **Lab #2 — Build CI Pipeline for PBIP**<br>(13:45–14:45) | CI lab guide (YAML examples, PBIP validation); ADO test integration; MS Learn pipeline tutorials |
| **Dashboard Design Solving Session**<br>(15:00–16:00) | Visualization best practices; Persona & decision frameworks; Wireframe examples |
| **Publishing Artifacts & Release Checklist**<br>(16:00–16:30) | Release checklist; Prod readiness; RLS/CLS validation; Sensitivity labels guidance |
| **Power BI Embedded POC + Communication Plan**<br>(16:30–17:00) | Embedded analytics deck; Service principal setup guide; Comms plan templates |

---

# 2. Detailed Topic‑by‑Topic Resource Breakdown

## 2.1 Kickoff, Objectives, Roles & Prerequisites
Supporting resources:
- **Workshop Overview Doc**  
  Includes agenda, workshop objectives, and success criteria.
- **Fabric Governance Workshop Deck**  
  Provides RBAC roles (Admin, Member, Contributor, Viewer) and tenant-level governance.
- **Connect Fabric Workspaces to Azure DevOps Guide**  
  Contains full prerequisite checklist:
  - Fabric workspace access  
  - Repo access  
  - PAT or service principal  
  - Admin toggle validation  

Use these materials to ensure all participants are technically ready before entering Lab 1.

---

## 2.2 Version Control in Fabric & PBIP; Git with ADO/GitHub

Key references:
- **PBIP Format Overview**  
  Explains the structure of `.pbip` (TMDL, JSON, YAML).
- **Git Integration in Fabric (Admin + UX)**  
  Covers enabling Git integration and setting repo/branch mappings.
- **Branching Strategy Guidance**  
  Concepts:
  - Trunk‑based dev  
  - Short-lived feature branches  
  - Workspace branching (“branch → new workspace”)  
  - Avoid editing directly in shared workspaces  
- **Microsoft Learn — Git Integration**  
  Baseline fundamentals for participants who are new to Git in Fabric.

These resources help attendees understand *why* Git matters and *how* Fabric synchronizes workspace items.

---

## 2.3 Lab #1 — Connect a Fabric Workspace to Git

Documents:
- **Lab #1 Guide — Connect Fabric Workspace to Azure DevOps**  
  Walks through:
  - Selecting Git provider  
  - Mapping workspace → repo → branch  
  - Initial sync  
  - Verifying Git icons  
  - Creating feature branches  
  - Submitting a PR
- **Boeing‑Branded Slide Pack**  
  Step‑by‑step visuals: Git setup, PR demo.
- **Architecture diagrams** for Git integration & PR flow

Validation checklist (end of lab):
- Workspace shows Git‑connected status  
- No pending changes  
- PR merged → synced back to Fabric  

---

## 2.4 Collaboration Patterns & Best Practices

Foundational references:
- **Power BI DataOps Deck**  
  Themes:
  - Dev/Test/Prod separation  
  - Pipelines  
  - Approval gates  
  - Change review patterns
- **Governance Essentials — Workspace & Role Governance**  
  Includes:
  - RACI matrix  
  - Naming conventions  
  - Workspace lifecycle guidance
- **Fabric Go‑Live Assessment Guide**  
  Production governance readiness:
  - RLS/CLS validation  
  - Endorsements  
  - Monitoring & auditing
- **Workshop Plan — Best Practices Section**  
  Reinforces:
  - Branching standards  
  - PR templates  
  - RLS consistency  
  - Review gates  

---

## 2.5 Deployment Strategy: Dev → Test → Prod

Materials:
- **CI/CD Delivery Guide**  
  Provides the end‑to‑end CI/CD model for PBIP-based development.
- **Knowledge Transfer (Enterprise-Scale Dev) PDF**  
  Contains:
  - Real YAML examples  
  - REST API automation  
  - Deployment pipeline synchronization  
- **Microsoft Learn — Deployment Pipelines**  
  Covers:
  - Stages  
  - Workspace binding  
  - Selective deployment  
  - Automation via APIs

Key messages:
- Every merge to main triggers validations  
- Environment-specific configs (via parameters, Key Vault)  
- No manual promotion to production  

---

## 2.6 Lab #2 — CI Pipeline for PBIP & Automated Validations

Primary references:
- **Lab #2 Guide — CI for PBIP**  
  Includes YAML patterns for:
  - PBIP schema validation  
  - DAX unit tests  
  - Lint rules  
  - Publishing artifacts
- **AzureDevOps Deep Dive**  
  Shows integration with dashboards and test plans.
- **Microsoft Learn — CI/CD Tutorial**  
  Mirrors the steps of building a working PBIP validation pipeline.

Lab #2 Outcomes:
- Working CI pipeline  
- PR branch policies enforced  
- PBIP validation occurs automatically  

---

## 2.7 Solving Session: Dashboard Pages & Semantic Model Design

Resources:
- **Visualization Best Practices Guide**  
  Principles:
  - Clarity  
  - Minimalism  
  - Accessibility  
  - Chart selection patterns
- **Persona & Decision Frameworks** (AA Module 4.1)  
  Helps identify key decisions dashboards must enable.
- **Design Jam Examples (Wireframes)**  
  Show real-world design workshop artifacts:
  - Job stories  
  - UX flows  
  - Page layouts

Activities:
- Define personas  
- Sketch 2–3 dashboard pages  
- Evaluate model gaps  
- Convert sketches into backlog items  

---

## 2.8 Publishing Artifacts & Release Checklist

Supporting documents:
- **Workshop Overview — Release Checklist**  
  Items include:
  - CI green  
  - Schema diff validated  
  - Dev → Test promotion  
  - RLS check  
  - App publishing
- **Production Deployment Oversight — Security & Compliance**  
  Covers:
  - Gateways  
  - Conditional Access  
  - Security principals  
  - Logging & audit
- **Fabric Warehouse Governance Guide**  
  Provides:
  - Endorsement rules  
  - Sensitivity labels  
  - OLS/RLS governance

Checklist also applies to:
- Notebooks  
- Dataflows  
- Pipelines  

---

## 2.9 SDA Webapp Team POC — Power BI Embedded & Comms Plan

Supporting documents:
- **Embedded Analytics Deck**  
  Explains:
  - Embed for your org vs. Embed for your customers  
  - Service principal authentication  
  - Token issuance flow
- **Demo Instructions — Service Principal Setup**  
  Steps:
  - Azure AD App Registration  
  - Assign API permissions  
  - Enable SP in Power BI Admin Portal  
  - Acquire tokens via backend  
- **QualityHub Requirements Document**  
  Rules for embedded experiences:
  - Performance SLAs  
  - Approved visuals  
  - Security controls  
- **Communications Plan Template**  
  Guidance:
  - Teams channel structure  
  - Weekly touchpoints  
  - Decision log  
  - PR review workflow  

---

# 3. Best Practices Summary

### Governance
- Enforce workspace separation  
- Require PR-based development  
- Centralize RLS/CLS rules  
- Standardize naming conventions  

### Git Integration
- Keep branches small  
- Protect `main`  
- Use Workspace → Git sync workflows  

### CI/CD
- Automate schema validation  
- Treat PBIP artifacts as code  
- Use Key Vault for secrets  

### Embedded Analytics
- Prefer **App Owns Data** for external apps  
- Use service principals exclusively  
- Validate RLS interactions with embedding  

---

# 4. Appendix: Suggested Folder Structure

```text
/docs
  /workshop-plan
    Fabric_Git_Workshop_Plan.md
    Supporting_Documents_for_Workshop.md
  /labs
    lab1-connect-git.md
    lab2-ci-pipeline.md
  /governance
    governance-checklist.md
  /architecture
    cicd-architecture.md
