# Toolkit Walkthrough Recording Runbook

This runbook explains how to record an instructional walkthrough of the Fabric BI DevOps Accelerator toolkit using Clipchamp and a local web server.

The goal is to produce a practical video that shows users what the toolkit is for, how each tool fits into the BI DevOps workflow, and what artifacts each tool creates.

## Recommended output

| Output | Recommended file |
|---|---|
| Full recording | `Social Media/video/fabric-bi-devops-toolkit-walkthrough.mp4` |
| Optional Part 1 | `Social Media/video/fabric-bi-devops-toolkit-part-1-standards.mp4` |
| Optional Part 2 | `Social Media/video/fabric-bi-devops-toolkit-part-2-review.mp4` |
| Optional Part 3 | `Social Media/video/fabric-bi-devops-toolkit-part-3-release-governance.mp4` |

## Recording approach

Use Clipchamp to record your screen while you manually walk through the tools in a browser. Do not try to deeply configure every field in every tool. The goal is to show the workflow and the value of each generated artifact.

Recommended total length:

- Single video: 15 to 25 minutes
- Three-part series: 6 to 10 minutes per part

If you prefer the three-part series, use the focused runbooks under:

```text
Social Media/video/walkthrough-runbooks/
```

- [Part 1 — Standards and Quality Foundation](walkthrough-runbooks/part-1-standards-quality.md)
- [Part 2 — PBIP Review and PR Readiness](walkthrough-runbooks/part-2-pbip-review.md)
- [Part 3 — Pipeline, Release, Governance, and Adoption](walkthrough-runbooks/part-3-release-governance.md)

## Part A — Prepare the environment

### 1. Start a local web server

From the repo root:

```powershell
cd C:\Projects\Fabric-BI-DevOps-Demo
python -m http.server 8000
```

Open:

```text
http://localhost:8000/tools/index.html
```

If port `8000` is busy:

```powershell
python -m http.server 8080
```

Then open:

```text
http://localhost:8080/tools/index.html
```

### 2. Prepare the browser

- Use Edge or Chrome.
- Maximize the browser window.
- Set browser zoom to 100%.
- Close unrelated tabs.
- Mute notifications.
- Open the launchpad before starting the recording.
- Keep this runbook open on a second monitor if available.

### 3. Prepare sample files

Use the workshop PBIP and sample data from the demo clone:

```text
C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local
C:\Projects\Fabric-BI-DevOps-Demo\docs\workshops\sample-data\dib-supply-chain
```

For tools that require folder upload, use:

```text
C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local
```

For reference outputs, use:

```text
C:\Projects\Fabric-BI-DevOps-Demo\docs\workshops\accelerator-toolkit\reference-output
```

## Part B — Record with Clipchamp

1. Open **Clipchamp**.
2. Select **Create a new video**.
3. Select **Record & create**.
4. Choose **Screen**.
5. Select the browser window showing `http://localhost:8000/tools/index.html`, or select the full screen if you need to switch between browser/File Explorer.
6. Start recording.
7. Follow the demo script below.
8. Stop recording.
9. Trim mistakes or long pauses.
10. Add a title card if desired.
11. Export as **1080p MP4**.
12. Save to:

```text
Social Media/video/
```

## Part C — Demo script

### Opening

Say:

> In this walkthrough, I am going to show the Fabric BI DevOps Accelerator toolkit. These are browser-based tools that help Power BI and Fabric teams create standards, quality rules, DAX test metadata, deployment manifests, readiness checks, PBIP diffs, dependency impact reports, pipeline configuration, PR summaries, release readiness evidence, and governance outputs without hand-editing JSON.

Then say:

> I am running the toolkit locally from `localhost`, but the tools are static HTML files. They can be used from a cloned repo, a workshop package, or a hosted static site.

## Part 1 — Standards and quality foundation

### Step 1 — Launchpad

Open:

```text
http://localhost:8000/tools/index.html
```

Show:

- Tool Catalog
- Workflow
- Artifacts
- Audience paths

Say:

> The launchpad is the front door. It groups tools by job-to-be-done: standards, review and release, and governance and adoption. I recommend starting here instead of opening individual tools directly.

### Step 2 — Enterprise Standards Builder

Open:

```text
tools/enterprise-standards-builder/index.html
```

Show:

- Policy profile choices
- Report usability standards
- Semantic model and DAX standards
- Generated report and dataset rule outputs

Say:

> The Enterprise Standards Builder turns policy decisions into CI-ready rule files. This is how a governance owner or BI lead defines the baseline quality posture without asking every report creator to hand-edit JSON.

Demo action:

1. Choose an enterprise or strict profile.
2. Scroll through report and semantic model controls.
3. Show generated JSON or summary output.

Artifact to mention:

```text
Rules-Report.json
Rules-Dataset.json
enterprise-policy-profile.json
```

### Step 3 — Quality Rule Designer

Open:

```text
tools/rule-designer/index.html
```

Demo action:

1. Click **Use starter examples**.
2. Select a report or dataset rule.
3. Explain severity, enabled state, and custom logic.

Say:

> The Rule Designer is for advanced tuning. If a team needs to change one threshold, disable a noisy rule temporarily, or author a custom check, they can do that here instead of editing the full rule file by hand.

### Step 4 — DAX Test Builder

Open:

```text
tools/dax-test-builder/index.html
```

Demo action:

1. Click **Use starter examples**.
2. Open one test case.
3. Show measure name, owner, scenario, expected behavior, severity, and generated documentation.

Say:

> The DAX Test Builder creates metadata for measure-level validation. It helps semantic model owners document expectations for critical measures before those checks become part of CI.

Artifact to mention:

```text
dax-tests.json
dax-test-catalog.md
```

## Part 2 — PBIP review and pull request readiness

### Step 5 — Deployment Manifest Builder

Open:

```text
tools/deployment-manifest-builder/index.html
```

Demo action:

1. Click **Use starter manifest**.
2. Show owners, artifacts, environments, validation gates, approvals, and rollback.

Say:

> The Deployment Manifest Builder creates a release contract. It answers what is being deployed, who owns it, where it goes, what must pass, who approves it, and how rollback works.

Artifact to mention:

```text
deployment-manifest.json
deployment-summary.md
```

### Step 6 — PBIP Project Readiness Scanner

Open:

```text
tools/pbip-readiness-scanner/index.html
```

Demo action:

1. Click the folder upload/preview control.
2. Select:

```text
C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local
```

3. Show structure, governance assets, references, and pipeline findings.

Say:

> The Readiness Scanner gives authors a pre-PR checkpoint. It catches missing PBIP structure, missing governance files, missing DAX test metadata, or missing CI/CD wiring before reviewers spend time on the PR.

### Step 7 — PBIP Diff Viewer

Open:

```text
tools/pbip-diff-viewer/index.html
```

Demo action:

1. Click **Use starter example**.
2. Show added, removed, and changed files.
3. Select a changed semantic model or report page.
4. Show review guidance and Markdown/JSON outputs.

Say:

> The PBIP Diff Viewer translates raw PBIP JSON and TMDL changes into review-friendly categories. Instead of forcing reviewers to read raw metadata, it highlights what changed and where to focus.

### Step 8 — Dependency Impact Analyzer

Open:

```text
tools/dependency-impact-analyzer/index.html
```

Demo action:

1. Click **Use starter example**.
2. Show changed objects such as `Sales[Amount]` and `Revenue`.
3. Show impacted measures, visuals, pages, relationships, and governance assets.

Say:

> The Dependency Impact Analyzer helps answer the question: if this measure, column, or table changes, what downstream report pages, visuals, tests, and governance files may be affected?

### Step 9 — PR Quality Summary Generator

Open:

```text
tools/pr-quality-summary-generator/index.html
```

Demo action:

1. Click **Use starter example**.
2. Show changed files, validation output, readiness output, DAX notes, and deployment context.
3. Show generated PR Markdown.

Say:

> The PR Quality Summary Generator turns validation evidence and changed files into a reviewer-ready handoff. This is what a report author can paste into the pull request.

Artifact to mention:

```text
PR-Quality-Summary.md
pr-quality-summary.json
```

## Part 3 — Pipeline, release, governance, and adoption

### Step 10 — Pipeline Config Generator

Open:

```text
tools/pipeline-config-generator/index.html
```

Demo action:

1. Click **Use starter example**.
2. Switch between Azure DevOps, GitHub Actions, and GitLab CI.
3. Show validation, quality, DAX, publish, and deploy toggles.
4. Show generated YAML and setup notes.

Say:

> The Pipeline Config Generator turns one delivery profile into platform-specific YAML. This helps platform teams bootstrap CI/CD consistently across Azure DevOps, GitHub Actions, or GitLab.

### Step 11 — Policy Exception Register

Open:

```text
tools/policy-exception-register/index.html
```

Demo action:

1. Click **Use starter examples**.
2. Open an approved exception.
3. Show owner, approver, affected artifact, expiration, reason, and mitigation.

Say:

> The Policy Exception Register makes exceptions visible, owned, approved, and time-bound. This prevents exceptions from becoming permanent undocumented bypasses.

### Step 12 — Effective Rules Generator

Open:

```text
tools/effective-rules-generator/index.html
```

Demo action:

1. Click **Use starter example**.
2. Show baseline rules, overrides, exceptions, source branch, and target branch.
3. Generate effective rule files.

Say:

> The Effective Rules Generator shows what CI will actually enforce after branch policy, project overrides, and approved exceptions are applied.

### Step 13 — CI/CD Platform Parity Matrix

Open:

```text
tools/platform-parity-matrix/index.html
```

Demo action:

1. Click **Use starter matrix**.
2. Show Azure DevOps, GitHub Actions, and GitLab CI columns.
3. Point out supported, partial, planned, and gap statuses.

Say:

> The Platform Parity Matrix makes the platform-neutral claim measurable. It shows what works consistently across Azure DevOps, GitHub Actions, and GitLab CI, and where extra work is needed.

### Step 14 — Release Readiness Dashboard

Open:

```text
tools/release-readiness-dashboard/index.html
```

Demo action:

1. Click **Use starter example**.
2. Show score, blockers, warnings, evidence sources, and recommendation.

Say:

> The Release Readiness Dashboard consolidates evidence into a release recommendation. It helps teams decide whether to release, release with review, or stop.

### Step 15 — Adoption Metrics Dashboard

Open:

```text
tools/adoption-metrics-dashboard/index.html
```

Demo action:

1. Click **Use starter metrics**.
2. Show projects, platforms, readiness scores, exceptions, and onboarding time.

Say:

> The Adoption Metrics Dashboard turns the accelerator into a measurable enablement program. It helps program owners show how many projects are onboarded and how mature they are.

### Step 16 — Rule Coverage Matrix

Open:

```text
tools/rule-coverage-matrix/index.html
```

Demo action:

1. Click **Use starter matrix**.
2. Show policies, automated rules, manual checks, owner, and coverage status.

Say:

> The Rule Coverage Matrix connects policy to implementation. It shows which governance requirements are automated, which require manual checks, and which are still gaps.

### Step 17 — Competitive Differentiation Matrix

Open:

```text
tools/competitive-differentiation-matrix/index.html
```

Demo action:

1. Click **Use starter matrix**.
2. Show comparison against generic CI/CD samples, decks, and internal accelerators.

Say:

> The Competitive Differentiation Matrix helps explain why this solution is more than a pipeline. It compares the full operating model against simpler alternatives.

## Closing script

Say:

> The key idea is that Enterprise BI DevOps with Microsoft Fabric is not just governance and not just CI/CD. It is an operating model for governed, repeatable Power BI and Fabric delivery. Teams can start with one PBIP project, generate the right artifacts, validate changes through CI, prepare better pull requests, and grow toward enterprise governance over time.

Then say:

> For workshop delivery, start with the launchpad, use the DIB sample data if a customer solution is not available, and follow the toolkit workshop labs and reference outputs.

## Starter-example inventory

| Tool | Starter/example available | Recording guidance |
|---|---|---|
| Launchpad | Not needed | Show tabs and workflow |
| Enterprise Standards Builder | Built-in policy profiles | Choose a profile and show generated rules |
| Quality Rule Designer | Yes | Click **Use starter examples** |
| DAX Test Builder | Yes | Click **Use starter examples** |
| Deployment Manifest Builder | Yes | Click **Use starter manifest** |
| PBIP Project Readiness Scanner | Uses actual folder | Select `C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local` |
| PBIP Diff Viewer | Yes | Click **Use starter example** |
| Dependency Impact Analyzer | Yes | Click **Use starter example** |
| Pipeline Config Generator | Yes | Click **Use starter example** |
| PR Quality Summary Generator | Yes | Click **Use starter example** |
| Policy Exception Register | Yes | Click **Use starter examples** |
| Effective Rules Generator | Yes | Click **Use starter example** |
| CI/CD Platform Parity Matrix | Yes | Click **Use starter matrix** |
| Release Readiness Dashboard | Yes | Click **Use starter example** |
| Adoption Metrics Dashboard | Yes | Click **Use starter metrics** |
| Rule Coverage Matrix | Yes | Click **Use starter matrix** |
| Competitive Differentiation Matrix | Yes | Click **Use starter matrix** |

## Recording checklist

Before recording:

- [ ] Local server is running.
- [ ] Launchpad opens at `http://localhost:8000/tools/index.html`.
- [ ] Browser zoom is 100%.
- [ ] Browser window is maximized.
- [ ] Notifications are muted.
- [ ] DIB sample PBIP exists at `C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local`.
- [ ] This runbook is open on a second screen or printed.
- [ ] Clipchamp is ready to record screen/window.

During recording:

- [ ] Keep each tool focused on one or two key points.
- [ ] Do not read every field.
- [ ] Mention the output artifact for each tool.
- [ ] Pause briefly after generated outputs so viewers can see them.
- [ ] If a file picker appears, explain what folder/file you are selecting.

After recording:

- [ ] Trim mistakes or long pauses.
- [ ] Add title card: "Fabric BI DevOps Accelerator Toolkit Walkthrough".
- [ ] Export as 1080p MP4.
- [ ] Save under `Social Media/video/`.
- [ ] Update `Social Media/video/README.md` if the walkthrough becomes part of the repo.

