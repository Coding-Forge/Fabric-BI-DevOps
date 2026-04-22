---
title: "Lab 2 Facilitator Change Log"
description: "Facilitator summary of updates made to Lab 2 materials so attendees follow the current Power BI project and Azure pipeline files."
updated: "2026-04-22"
---

# Lab 2 Facilitator Change Log

## Purpose

Use this quick brief before Lab 2 so participants follow the current repository implementation and not older examples.

## What Changed

1. Lab 2 now points to the existing pipeline file at `projects/azure-pipelines.yml`.
2. Lab 2 now teaches the current 3-stage flow: Validate -> Test -> Publish.
3. References to legacy examples (`pbi-tools`, `pbip-lint`, and `SyncFabricDev`) were removed from Lab 2 materials.
4. Folder path examples were normalized to `/projects`.
5. Repository now excludes PBIP artifacts by design; participants bring their own PBIP locally.
6. Validation guidance now matches existing scripts and rule files:
   - `projects/tests/validate_pbip_structure.py`
   - `projects/tests/run_dax_tests.py`
   - `projects/scripts/Prepare-QualityRules.ps1`
   - `projects/Rules-Dataset.json`
   - `projects/Rules-Report.json`

## Facilitator Talk Track (2-3 minutes)

"For this workshop, we are not creating a new YAML pipeline from scratch. We are using the pipeline that already exists in the repo at projects/azure-pipelines.yml. Your goal in Lab 2 is to register and run that pipeline, verify the Validate, Test, and Publish stages, and enforce it as a required PR check on main."

## What Participants Should Actually Do

1. Select existing YAML file path: `/projects/azure-pipelines.yml` when creating the pipeline.
2. Confirm stage sequence: Validate -> Test -> Publish.
3. Review test output in the pipeline Tests tab.
4. Verify `pbip-artifacts` in the Artifacts tab.
5. Add pipeline as required build validation on `main`.

## Common Questions and Answers

1. Q: "Why don't we install pbi-tools in this lab anymore?"
   A: "The workshop now mirrors the real pipeline implementation in this repo, which uses PBIP structure checks plus dataset/report quality rule execution."

2. Q: "Where are the Power BI project files expected by the pipeline?"
   A: "Participants add their own PBIP locally under `projects` or `projects/pbip-local`. The repo stores reusable assets only: tests, scripts, rules, and pipeline YAML."

3. Q: "Are we doing automatic workspace sync in Lab 2?"
   A: "Not in the core lab flow. Lab 2 is focused on CI validation and artifact publication."

## Updated Materials

- `docs/workshop-plan/labs/lab2-ci-pipeline.md`
- `presentations/06-lab2-ci-pipeline.md`
- `docs/workshop-plan/Fabric_Git_Workshop_Plan.md`
- `Supporting_Docs_For_Workshop.md`
- `README.md`
- `docs/workshop-plan/labs/lab1-connect-git.md`
- `presentations/03-lab1-connect-git.md`
- `presentations/05-deployment-strategy.md`
- `docs/governance/governance-checklist.md`
- Architecture references aligned for consistency:
  - `docs/architecture/branching-strategy.md`
  - `docs/architecture/cicd-architecture.md`
  - `docs/architecture/fabric-git-integration.md`
  - `presentations/01-kickoff-overview.md`
  - `presentations/04-collaboration-governance.md`
  - `presentations/08-release-embedded.md`
