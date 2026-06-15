---
marp: true
theme: default
paginate: false
style: |
  section {
    font-family: "Segoe UI", sans-serif;
    background: linear-gradient(135deg, #f4fbf6 0%, #ffffff 60%);
    color: #1a1a1a;
    padding: 48px;
  }
  h1 {
    color: #0f5132;
    border-bottom: 3px solid #0f5132;
    padding-bottom: 0.2em;
    margin-bottom: 0.4em;
  }
  h2 {
    color: #0f5132;
    margin-top: 0.5em;
    margin-bottom: 0.3em;
  }
  ul {
    margin-top: 0.2em;
  }
  code {
    background: #e8f3ec;
    color: #103b2b;
    border-radius: 4px;
    padding: 2px 6px;
  }
---

# Lab 2 Facilitator Briefing (Quick Readout)

## What Changed
- Lab 2 now uses the existing pipeline at `projects/azure-pipelines.yml`
- The core flow is now **Validate -> Test -> Publish -> Deploy**
- `main` and `develop` deploy to Dev; `feature/*` deploys to a prefixed feature workspace
- Deployment uses `projects/scripts/deploy-dynamic.ps1` and service principal variables
- Legacy examples (`pbi-tools`, `pbip-lint`, `SyncFabricDev`) were removed from participant instructions
- Path examples were normalized to `/projects`
- PBIP artifacts are not committed in this repo; participants bring their own local PBIP files

## What Participants Must Do
- Create pipeline from existing YAML: `/projects/azure-pipelines.yml`
- Verify stage order and green status: Validate, Test, Publish, then Deploy_Dev or Deploy_Feature
- Check `pbip-drop` in the Artifacts tab
- Confirm deployment logs end with `Fabric PBIP deployment completed.`
- Set this pipeline as required build validation for `main`

## 30-Second Script
"In this lab, we are using the pipeline already in the repo instead of creating a new one. Point Azure DevOps to `projects/azure-pipelines.yml`, run it, confirm Validate, Test, Publish, and the branch deploy stage are green, then make that pipeline required on `main`."