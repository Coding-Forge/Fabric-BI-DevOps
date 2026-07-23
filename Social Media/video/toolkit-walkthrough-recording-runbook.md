# Toolkit Walkthrough Recording Runbook

This runbook explains how to record a professional, detailed instructional walkthrough of the Fabric BI DevOps Accelerator toolkit using Clipchamp and a local web server.

## Purpose

The toolkit walkthrough is designed for two audiences:

1. **Power BI & Fabric practitioners** who want to understand how to use each tool to improve their delivery quality, reduce manual work, and scale governance across their organization.
2. **Workshop facilitators and BI leads** who need to deliver the accelerator in real-world customer environments and want to demonstrate the full value proposition and workflow.

The goal is to produce a detailed, practical video that shows:
- What each tool does and why it matters
- How tools fit together in a BI DevOps workflow
- Real-world use cases and scenarios where each tool adds value
- What artifacts each tool generates and why they're important
- How to handle common questions and edge cases

## Recommended output

| Output | Recommended file | Audience | Length |
|---|---|---|---|
| Full walkthrough (single video) | `Social Media/video/fabric-bi-devops-toolkit-walkthrough.mp4` | Self-taught practitioners | 20–30 minutes |
| Part 1 (Standards) | `Social Media/video/fabric-bi-devops-toolkit-part-1-standards.mp4` | Anyone setting up governance | 8–12 minutes |
| Part 2 (PBIP Review) | `Social Media/video/fabric-bi-devops-toolkit-part-2-review.mp4` | Report authors, reviewers | 10–15 minutes |
| Part 3 (Release & Governance) | `Social Media/video/fabric-bi-devops-toolkit-part-3-release-governance.mp4` | Platform teams, release managers | 10–15 minutes |

## Recording approach

Use Clipchamp to record your screen while you manually walk through the tools in a browser. This approach works because:

- All tools are **static HTML** — they run locally with no backend, authentication, or external dependencies.
- **Starter examples** are built into each tool, so you don't need a complex test environment.
- **Screen recording is repeatable** — if you make a mistake, pause recording and resume from the next step.
- **Video production is fast** — most recordings complete in one or two sessions.

### Recording discipline

- Do **not** try to deeply configure every field in every tool. Focus on the workflow and the value.
- **Mention output artifact names by name** — this helps viewers understand what they can generate and commit.
- **Pause briefly on generated outputs** — show Markdown, JSON, or YAML results so viewers understand what "done" looks like.
- **Use the launchpad to transition** — each part should begin with the launchpad workflow and follow the recommended sequence.
- **Speak to the use case, not the UI** — explain why someone would use this tool, not just which buttons to click.

### Recommended total length

- **Single video**: 20–30 minutes (beginner- to intermediate-friendly; covers full workflow)
- **Three-part series**: 8–12 minutes per part (easier to consume; better for specific job roles)

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

**Start with the problem and the solution:**

Say:

> Power BI and Fabric teams often struggle with the same challenges: how do we maintain quality across many reports, how do we review pull requests efficiently, and how do we scale governance without slowing down delivery? 

> This is the Fabric BI DevOps Accelerator toolkit. These are browser-based tools that help teams solve these problems. They let you define quality standards, review changes, validate deployment readiness, track governance exceptions, and measure adoption—all without hand-editing JSON files.

> The toolkit includes 15 tools that work together. We start with governance and quality standards, then show how to review pull requests and prepare releases, and finish with governance and adoption tracking.

Then say:

> I'm running the toolkit locally from `localhost`, but these are static HTML files. They work from a cloned repo, a workshop package, a GitHub Pages site, or any static web server. There's no backend, no authentication required, and no internet access needed.

> Let me walk you through how to use each tool and how they fit together.

**Timing:** This should take about 30–45 seconds. It establishes the problem your toolkit solves and sets viewer expectations.

## Part 1 — Standards and quality foundation

### Step 1 — Launchpad

Open:

```text
http://localhost:8000/tools/index.html
```

Show:

- Tool Catalog tab
- Workflow tab
- Artifacts tab
- Audience paths tab

Say:

> The launchpad is the front door to the entire toolkit. Instead of diving into individual tools, start here. It shows what each tool does, what artifacts it produces, who should use it, and how tools work together.

> You'll see three workflow sequences: standards and quality, PBIP review and readiness, and governance and adoption. The launchpad connects to all 15 tools and helps different roles understand which tool to use first.

Demo actions:

1. Click **Tool Catalog** and read 2–3 tool descriptions aloud to show the variety.
2. Click **Workflow** and point out the three sequences.
3. Click **Artifacts** and show that each tool generates Markdown, JSON, or YAML that can be committed.
4. Click **Audience paths** and show roles like BI leads, report authors, and platform engineers.

**Why this matters:** The launchpad prevents confusion and helps teams adopt the toolkit incrementally instead of trying to use all tools at once.

### Step 2 — Enterprise Standards Builder

Open:

```text
tools/enterprise-standards-builder/index.html
```

Say:

> The Enterprise Standards Builder turns governance decisions into automated quality rules without requiring anyone to hand-edit JSON. This is the most important tool in the kit for most organizations.

> Think about it: you have report creators, model owners, reviewers, and platform teams. If you ask them to hand-edit JSON files, adoption stops. But if they use a guided UI, they understand what they're choosing.

> The builder includes three pre-configured profiles that represent different governance maturity levels: Advisory Adoption (permissive, designed for onboarding), Enterprise Standard (balanced governance), and Strict Enterprise Gate (high control).

> Within each profile, you can customize controls for report usability, visual standards, semantic model quality, DAX standards, and formatting.

Demo actions:

1. Choose the **Enterprise Standard** profile (best middle ground for demo).
2. Scroll through the report usability settings and explain 1–2 controls (e.g., why you'd want to restrict old visual types or enforce naming conventions).
3. Scroll through semantic model and DAX settings and point out a few key ones (e.g., aggregate functions, measure naming).
4. Click **Generate Rules** or **Summary** and show the output.

Artifacts to mention and pause on:

```text
Rules-Report.json    → Report rules, severities, and enabled flags
Rules-Dataset.json   → Semantic model rules
enterprise-policy-profile.json  → Your choices, stored for reuse
Policy-Summary.md    → Human-readable guide to what you've enabled
```

Say:

> These files get committed to your repo. The CI/CD pipeline reads them and runs PBI Inspector and Tabular Editor to enforce your choices on every pull request. No more surprises in PR review.

**Why this matters:** This is where governance becomes scalable. You define it once, and the pipeline enforces it everywhere.

### Step 3 — Quality Rule Designer

Open:

```text
tools/rule-designer/index.html
```

Say:

> Sometimes the baseline profile isn't enough. Maybe you need to lower the severity of a rule while you're onboarding teams. Maybe you need to disable a noisy rule temporarily. Or maybe you have a custom governance requirement that isn't in the builder.

> That's where the Rule Designer fits. It's for tuning individual rules safely.

Demo actions:

1. Click **Use starter examples**.
2. Select one report rule (e.g., a visual type or naming convention rule).
3. Show the rule ID, severity (error, warning, info), enabled flag, and the logic behind it.
4. Explain that you can change severity independently—start rules as warnings during adoption, promote to errors later.
5. If time permits, show a dataset rule (semantic model side).

Say:

> The Rule Designer also lets you write custom logic if you need to. You can use PBI Inspector DSL or Tabular Editor BPA syntax to express your unique business rules.

Artifacts to mention:

```text
Rules-Report.json
Rules-Dataset.json
```

Say:

> Once you've tuned your rules, these files replace the ones from the Standards Builder. Commit them, and the CI/CD pipeline uses your updated rules.

**Why this matters:** Governance needs flexibility. You can start permissive and tighten over time. This tool makes that easy.

### Step 4 — DAX Test Builder

Open:

```text
tools/dax-test-builder/index.html
```

Say:

> Quality rules validate report and model structure. But structure alone doesn't guarantee correctness. For that, we need DAX test metadata.

> The DAX Test Builder lets semantic model owners document expected business behavior for critical measures. It captures the scenario, expected result, acceptable tolerance, and severity for each test.

> Think of it as unit testing for measures. If someone changes a measure formula, these tests tell the CI/CD system whether the results are still correct.

Demo actions:

1. Click **Use starter examples**.
2. Select one test case.
3. Show:
   - Measure name and owner
   - Scenario description (e.g., "Total sales for Q4 2024")
   - Expected result (e.g., "$1.2M")
   - Acceptable tolerance (e.g., ±0.1%)
   - Severity (blocking, warning, info)
   - Tags (e.g., "revenue", "forecast")
4. Show the generated Markdown catalog so viewers know what the output looks like.

Say:

> These tests start disabled because measure names, expected values, and filter contexts must be customized for your semantic model. But once you enable them, the CI/CD system runs them on every pull request and reports pass/fail.

Artifacts to mention:

```text
dax-tests.json
dax-test-catalog.md
```

**Why this matters:** Structural quality is necessary but not sufficient. DAX tests ensure measures work correctly and catch regressions early.

Closing narration:

> At this point we have a quality foundation: enterprise standards, tuned rules, and measure test metadata. This is what gets committed to the repo and consumed by CI/CD. In the next part of this walkthrough, we'll show how to use the toolkit to prepare a PBIP change for review.

## Part 2 — PBIP review and pull request readiness

### Step 5 — Deployment Manifest Builder

Open:

```text
tools/deployment-manifest-builder/index.html
```

Say:

> Now we shift perspective. We've defined quality standards. The next question is: how does a change flow through the organization?

> The Deployment Manifest Builder creates a release contract. It answers: What is being deployed? Who owns it? Where does it go? What must pass before it ships? Who approves it? How does rollback work?

> This manifest becomes the source of truth for the release team, the CI/CD pipeline, and reviewers.

Demo actions:

1. Click **Use starter manifest**.
2. Show:
   - Solution name and description
   - Owners (creator, approver, release manager)
   - Artifact list (which reports, models, dashboards, etc.)
   - Environment stages (dev → test → prod)
   - Parameters and their defaults
   - Validation gates (readiness checks, DAX tests, manual approvals)
   - Rollback strategy
3. Pause on the generated summary Markdown to show what a human-readable release plan looks like.

Say:

> This manifest is a contract. It says: 'This deployment is owned by Alice and Bob, uses these three reports, must pass readiness checks and DAX tests, requires approval from Carol before prod, and can be rolled back in under 30 minutes.'

Artifacts to mention:

```text
deployment-manifest.json
deployment-summary.md
```

**Why this matters:** Deployments without explicit contracts lead to confusion, missed approvals, and incidents. The manifest makes everyone's responsibilities clear.

### Step 6 — PBIP Project Readiness Scanner

Open:

```text
tools/pbip-readiness-scanner/index.html
```

Say:

> Before opening a pull request, the report author should ask: 'Is my PBIP project ready for review?' That's what the Readiness Scanner does.

> It checks whether the PBIP has the right folder structure, includes governance files like the quality rules and DAX tests, and has CI/CD configuration in place. It's a pre-PR checkpoint that catches problems early.

Demo actions:

1. Click the folder upload or preview control.
2. Select:

```text
C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local
```

3. Show:
   - PBIP structure findings (is `.report` folder present, are models in place, etc.)
   - Report and semantic model structure checks
   - Governance asset findings (do the rules and DAX test files exist?)
   - CI/CD wiring findings (is the pipeline configured?)
4. Scroll through any warnings and explain what they mean.
5. Show the generated Markdown report.

Say:

> If the scan passes, the author knows the PR will likely succeed. If there are warnings, the author can fix them before asking reviewers to spend time.

Artifacts to mention:

```text
pbip-readiness-report.md
pbip-readiness-report.json
```

**Why this matters:** Reviewers shouldn't waste time on structural problems. The scanner catches them early and unblocks the author to fix them quickly.

### Step 7 — PBIP Diff Viewer

Open:

```text
tools/pbip-diff-viewer/index.html
```

Say:

> Once the PR is open, reviewers need to understand what changed. But PBIP projects are expressed as hundreds of JSON and TMDL files. Asking reviewers to read raw JSON is not practical.

> The PBIP Diff Viewer translates raw file changes into business terms. Instead of 'this JSON property changed', it says 'a measure was added to the Sales table' or 'this report page now has a new visual'.

Demo actions:

1. Click **Use starter example**.
2. Show the summary: how many files added, changed, removed.
3. Select a changed semantic model file and show the review guidance (what changed, what to check, risks).
4. Select a changed report page and show which visuals were affected.
5. Show the generated review-friendly Markdown output.

Say:

> This Markdown gets attached to the PR or pasted in a PR comment. It tells reviewers exactly what changed and what to focus on. No need to read raw TMDL or JSON.

Artifacts to mention:

```text
pbip-diff-report.html
pbip-diff-report.md
pbip-diff-report.json
```

**Why this matters:** Code review moves faster when reviewers can understand changes without decoding JSON. The diff viewer is a translator.

### Step 8 — Dependency Impact Analyzer

Open:

```text
tools/dependency-impact-analyzer/index.html
```

Say:

> The diff viewer shows what changed. The Impact Analyzer answers the second question: if this semantic model object changed, what downstream report pages, visuals, tests, and governance assets may be affected?

> This is critical for risk assessment. Changing a measure that appears on 30 report pages is much riskier than changing one that's only used in a single table visual.

Demo actions:

1. Click **Use starter example**.
2. Show changed objects like `Sales[Amount]` and `Revenue`.
3. For each changed object, show:
   - Impacted measures (what other measures depend on this?)
   - Impacted visuals (what visuals use these?)
   - Impacted report pages (what pages have affected visuals?)
   - Impacted relationships and validation rules
   - Impacted governance assets (rules or tests that reference this object)
4. Show the generated HTML and Markdown reports.

Say:

> The Impact Analyzer helps the reviewer answer: 'If this measure changes, what might break?' It also helps the author plan their testing and identifies areas that might need extra attention.

Artifacts to mention:

```text
dependency-impact-report.html
dependency-impact-report.md
dependency-impact-report.json
```

**Why this matters:** You can't review pull requests responsibly without understanding the blast radius of changes. This tool quantifies risk.

### Step 9 — PR Quality Summary Generator

Open:

```text
tools/pr-quality-summary-generator/index.html
```

Say:

> We've scanned readiness, inspected diffs, and analyzed dependencies. Now we need to tie it all together into a handoff for reviewers.

> The PR Quality Summary Generator creates a comprehensive pull request summary that includes changed files, validation results, readiness findings, DAX test context, dependency impact, and deployment context. The author pastes this into the PR, and reviewers have all the context they need.

Demo actions:

1. Click **Use starter example**.
2. Show inputs:
   - Changed files (what's in the PR)
   - Validation output (did the code pass quality checks?)
   - Readiness output (is the project structure ready?)
   - DAX test context (what tests apply to this change?)
   - Dependency impact (what's the blast radius?)
   - Deployment context (what deployment manifest applies?)
3. Show the generated PR-ready Markdown.

Say:

> This is what goes into the PR description. It says: 'Here's what I changed, here's what passed validation, here's what reviewers should focus on, and here's the deployment plan.' It moves PR review from questions and back-and-forth to clarity and context.

Artifacts to mention:

```text
PR-Quality-Summary.md
pr-quality-summary.json
```

**Why this matters:** Great PR summaries eliminate back-and-forth and let reviewers make better decisions. This tool creates that summary automatically.

## Part 3 — Pipeline, release, governance, and adoption

### Step 10 — Pipeline Config Generator

Open:

```text
tools/pipeline-config-generator/index.html
```

Say:

> Now we shift to the platform team perspective. We've defined quality standards and prepared individual PRs. The next question is: how do we automate all of this across our CI/CD platform?

> The Pipeline Config Generator takes one delivery profile and generates platform-specific YAML for Azure DevOps, GitHub Actions, and GitLab CI. This lets platform teams bootstrap CI/CD consistently without writing YAML by hand for each platform.

Demo actions:

1. Click **Use starter example**.
2. Show:
   - Solution name and profile
   - Enabled stages (lint, validate, publish, deploy)
   - Trigger settings (branch, PR filter)
   - Approval gates
3. Switch between Azure DevOps, GitHub Actions, and GitLab CI tabs.
4. Show the generated YAML for each platform.
5. Show the setup notes Markdown.

Say:

> Notice how the logic is the same across platforms, but the YAML syntax is different. The generator handles that translation. Platform teams can customize the YAML once it's generated, but they start with a working template.

Artifacts to mention:

```text
azure-pipelines.generated.yml
powerbi-ci.generated.yml  (GitHub Actions)
gitlab-ci.generated.yml
pipeline-profile.json
pipeline-setup-notes.md
```

**Why this matters:** YAML syntax is error-prone. Starting with generated templates reduces mistakes and accelerates platform setup.

### Step 11 — Policy Exception Register

Open:

```text
tools/policy-exception-register/index.html
```

Say:

> In reality, not every report can follow every rule all the time. Sometimes there's a business need that conflicts with a governance standard. When that happens, exceptions happen. The question is: do you track them or let them accumulate undocumented?

> The Policy Exception Register makes exceptions visible, owned, approved, and time-bound. It's your control against 'shadow exceptions' that live in pull requests and Slack messages.

Demo actions:

1. Click **Use starter examples**.
2. Open an approved exception.
3. Show:
   - Rule ID (which governance rule is the exception for?)
   - Affected artifact (which report or dataset?)
   - Owner and approver (who requested it, who approved it?)
   - Reason (why is the exception necessary?)
   - Expiration date (when must this be resolved?)
   - Mitigation (what's the plan to get back to compliance?)
4. Show the generated summary Markdown.

Say:

> Every exception is visible and time-bound. If an exception expires without action, it becomes a blocker in the pipeline until someone reviews it or extends it.

Artifacts to mention:

```text
policy-exceptions.json
policy-exceptions-summary.md
```

**Why this matters:** Exceptions are inevitable. Tracking them prevents governance from becoming theater.

### Step 12 — Effective Rules Generator

Open:

```text
tools/effective-rules-generator/index.html
```

Say:

> Here's the complexity: you have baseline enterprise rules, you might have branch-specific policy overrides, and you might have approved exceptions. The Effective Rules Generator merges all three into one set of rules that the CI/CD pipeline actually enforces.

> This is the source of truth for what the pipeline is checking on this branch, in this project, right now.

Demo actions:

1. Click **Use starter example**.
2. Show inputs:
   - Baseline rules (enterprise-wide standards)
   - Project overrides (customizations for this team)
   - Approved exceptions (temporary bypasses)
   - Source branch (main, dev, feature branches)
   - Target branch (what are we merging into?)
3. Show the generated effective rule files (Rules-Report.effective.json, Rules-Dataset.effective.json).
4. Show the summary Markdown.

Say:

> The beauty of this is that the pipeline doesn't have to guess. It reads the effective rules file and enforces exactly what's configured. No surprises.

Artifacts to mention:

```text
Rules-Report.effective.json
Rules-Dataset.effective.json
effective-rules-summary.md
```

**Why this matters:** Transparency about enforcement rules prevents disputes and surprises during PR review.

### Step 13 — CI/CD Platform Parity Matrix

Open:

```text
tools/platform-parity-matrix/index.html
```

Say:

> One of the core claims of this accelerator is that it's platform-neutral. You can use it with Azure DevOps, GitHub Actions, or GitLab CI. But let's be honest: there are capabilities that vary across platforms.

> The Platform Parity Matrix documents exactly what works the same way across all three platforms, what requires workarounds, what's partial, and what's not available.

Demo actions:

1. Click **Use starter matrix**.
2. Show the matrix with Azure DevOps, GitHub Actions, and GitLab CI columns.
3. Point out capabilities marked as:
   - ✅ Supported (same across platforms)
   - ⚠️ Partial (different implementations)
   - 🔄 Planned (coming soon)
   - ❌ Gap (not available or workaround needed)
4. Scroll through a few rows to show the variety.

Say:

> If a team is choosing a platform and governance is important, this matrix shows what the trade-offs are. Teams can make informed decisions instead of guessing.

Artifacts to mention:

```text
platform-parity-matrix.json
platform-parity-matrix.md
```

**Why this matters:** Multi-platform support claims need evidence. This matrix backs them up.

### Step 14 — Release Readiness Dashboard

Open:

```text
tools/release-readiness-dashboard/index.html
```

Say:

> At release time, many signals matter: validation passed, quality rules passed, DAX tests passed, the deployment manifest is complete, exceptions are managed, and the team is confident. The Release Readiness Dashboard consolidates all of those into a single recommendation: Ready to Release, Ready with Review, or Do Not Release.

> This dashboard is the release team's executive summary.

Demo actions:

1. Click **Use starter example**.
2. Show:
   - Overall readiness score (% ready)
   - Blockers (failures that prevent release)
   - Warnings (things to review before release)
   - Evidence sources (where did each check come from?)
   - Recommendation (the dashboard's go/no-go call)
3. Point out how different signal types contribute to the score.

Say:

> Release teams can use this to make faster, more confident decisions. Instead of reading dozens of validation logs, they read one dashboard and see whether conditions are met.

Artifacts to mention:

```text
release-readiness-dashboard.html
release-readiness-summary.md
release-readiness-report.json
```

**Why this matters:** Release decisions should be evidence-based, not gut-feel. This dashboard provides the evidence.

### Step 15 — Adoption Metrics Dashboard

Open:

```text
tools/adoption-metrics-dashboard/index.html
```

Say:

> Okay, we've delivered the toolkit to one team. Now the question is: how do we show value across the organization? How many projects have we onboarded? How mature are they? Are we spending time on the right things?

> The Adoption Metrics Dashboard turns the accelerator into a measurable enablement program. It shows adoption, platform usage, rule maturity, exception aging, readiness scores, and time-to-onboard.

Demo actions:

1. Click **Use starter metrics**.
2. Show:
   - Number of projects onboarded
   - Projects by platform (Azure DevOps vs GitHub Actions vs GitLab)
   - Average readiness scores by team
   - Exception aging (are old exceptions expiring or being extended?)
   - Average time to onboard
   - Rule coverage (what % of policies are automated?)
3. Show the generated CSV and Markdown outputs.

Say:

> Program officers use this to argue for more investment. 'We've onboarded 25 projects, average readiness is 88%, and we've cut PR review time by 40%.'

Artifacts to mention:

```text
adoption-metrics.json
adoption-metrics.csv
adoption-metrics-dashboard.md
```

**Why this matters:** What you measure, you can improve. Adoption metrics let you justify governance investments with data.

### Step 16 — Rule Coverage Matrix

Open:

```text
tools/rule-coverage-matrix/index.html
```

Say:

> Finally, let's talk about governance completeness. When you define enterprise policies, not every policy can be automated. Some require manual checks. Some are still gaps.

> The Rule Coverage Matrix connects each governance policy to implementation: which are automated rules, which are manual checks, and which are still to-do items.

Demo actions:

1. Click **Use starter matrix**.
2. Show:
   - Policy statement (what's the requirement?)
   - Automated rule (is there a PBI Inspector or Tabular Editor rule?)
   - Manual check (do reviewers need to verify this?)
   - Owner (who's responsible?)
   - Status (complete, partial, or planned?)
3. Scroll through to show variety.

Say:

> This matrix answers the question: 'Are we really governing everything we said we would?' It highlights gaps and helps prioritize which rules to automate next.

Artifacts to mention:

```text
rule-coverage-matrix.json
rule-coverage-matrix.md
```

**Why this matters:** Coverage gaps are easy to miss. This matrix makes them visible and traceable.

### Step 17 — Competitive Differentiation Matrix

Open:

```text
tools/competitive-differentiation-matrix/index.html
```

Say:

> Let me end with a question: why is this accelerator different from just using Azure Pipelines, GitHub Actions, or any other CI/CD system?

> The Competitive Differentiation Matrix compares this operating model against alternatives: generic CI/CD samples, best-practice decks, internal accelerators, and public solutions.

Demo actions:

1. Click **Use starter matrix**.
2. Show the comparison grid:
   - This accelerator's features (governance, PBIP awareness, multi-platform, no code, etc.)
   - How alternatives stack up
   - What's unique here
3. Point out key differentiators (PBIP-native, no custom code required, etc.).

Say:

> The point isn't that this is the only way. The point is that it's designed specifically for Power BI and Fabric teams, it doesn't require custom development, and it covers the full operating model from standards through release and adoption tracking.

> If you're starting from CI/CD basics and building your own, this accelerator gives you a working, tested starting point.

Artifacts to mention:

```text
competitive-differentiation-matrix.json
competitive-differentiation-matrix.md
```

**Why this matters:** Teams making platform decisions need to understand their options. This matrix articulates the value proposition clearly.

## Closing script

Say:

> We've just walked through 15 tools that cover the entire BI DevOps operating model. Here's the through-line:
>
> - **First**, you define quality standards using the Enterprise Standards Builder. This is the policy layer.
>
> - **Second**, report authors and reviewers use the PBIP Diff Viewer, Dependency Impact Analyzer, and PR Summary Generator to understand what changed and what to focus on.
>
> - **Third**, the platform team uses the Pipeline Config Generator to turn your profile into CI/CD YAML for any platform—Azure DevOps, GitHub Actions, or GitLab CI.
>
> - **Fourth**, release teams use the Release Readiness Dashboard to decide whether conditions are met for production.
>
> - **Finally**, program offices use adoption metrics to track progress and show ROI.
>
> This isn't just governance and it isn't just CI/CD. It's an **operating model for repeatable, governed Power BI and Fabric delivery**. Teams can start with one PBIP project, one profile, one set of rules, and one pipeline. Then they can scale horizontally to more projects and more teams without reinventing everything.
>
> If you're responsible for BI quality, delivery velocity, or platform enablement, this toolkit gives you a tested starting point. No custom development required.
>
> For workshop delivery, start with the launchpad, use the DIB sample data if a customer solution isn't available, follow the toolkit labs in the workshop materials, and use the reference outputs to show what 'done' looks like.
>
> The toolkit is open-source and available on GitHub. The documentation includes detailed runbooks for workshop facilitators, a deployment checklist, and FAQ.
>
> Thank you for watching. Good luck with your BI governance journey.

**Timing:** This should take about 60–90 seconds. It ties the tools together narratively and reinforces the value proposition.

## Production tips and best practices

### Before you start

- **Test your environment.** Start the local server and verify all tools load without errors.
- **Test Clipchamp.** Do a 30-second practice recording and export to MP4. Confirm audio and video quality are acceptable.
- **Close unnecessary programs.** This reduces distractions and keeps CPU load down during recording.
- **Mute notifications.** No Slack pings, email notifications, or system alerts during recording.
- **Set browser zoom to 100%.** Non-standard zoom makes text hard to read in the video.
- **Maximize the browser.** Show the tools full-screen for maximum visibility.
- **Have this runbook open on a second monitor** if possible, or memorize the transitions.
- **Test microphone audio.** Speak at normal volume and confirm it's being captured clearly.

### During recording

- **Speak clearly and at a moderate pace.** You're teaching, not rushing. Aim for 120–150 words per minute.
- **Pause briefly on each generated output.** Let viewers read JSON, Markdown, or YAML before moving on (2–3 seconds per output).
- **Use mouse clicks deliberately.** Slow down when clicking buttons so viewers can follow.
- **Narrate what you're doing.** Don't just click; explain why you're clicking and what outcome to expect.
- **Pause before transitions** between tools (1–2 seconds of silence is fine; you can edit it later).
- **If you make a mistake:** pause recording, wait a few seconds, then resume. You'll edit it out later.
- **Mention artifact names explicitly.** Don't say "the output file"; say "Rules-Report.json" by name.
- **Don't apologize for mistakes during recording.** Just pause and resume. Edit out the mistake in post-production.

### After recording

- **Import into Clipchamp or your video editor.**
- **Trim mistakes, long pauses, and stumbles.** Even a 20-minute recording typically edits down from 25–30 minutes of raw video.
- **Check volume levels.** Normalize audio so it's consistent throughout.
- **Add a title card** at the start (toolkit name, description, duration, channel/host).
- **Add chapter markers** in the video description for multi-part series:
  ```
  0:00 – Opening and problem statement
  1:30 – Launchpad walkthrough
  4:00 – Enterprise Standards Builder
  6:30 – Quality Rule Designer
  etc.
  ```
- **Add YouTube/platform-specific captions** if possible (auto-generated captions from your platform work, but review for accuracy).
- **Fade audio/video in and out** at transitions to smooth the editing.
- **Export at 1080p MP4** for broad compatibility. 4K is not necessary and increases file size.

### Video metadata (YouTube/LinkedIn/social)

When uploading to YouTube, LinkedIn, or other platforms:

- **Title:** Examples:
  - "Fabric BI DevOps Accelerator Toolkit Walkthrough (Full Demo)"
  - "How to Use Power BI Governance Tools: Complete Toolkit Demo"
  - "BI DevOps Toolkit for Power BI & Fabric – 15 Tools in 30 Minutes"

- **Description:** Start with the problem, mention the toolkit value, and include:
  ```
  🔗 Resources:
  • GitHub: [link]
  • Documentation: [link]
  • Workshop materials: [link]
  • Toolkit launchpad: [link]

  ⏰ Timestamps:
  0:00 – Introduction
  1:30 – Launchpad
  ... (list all major sections)

  📌 What you'll learn:
  • How to define quality standards without hand-editing JSON
  • How to review PBIP changes efficiently
  • How to automate CI/CD across Azure DevOps, GitHub, and GitLab
  • How to track governance and adoption
  ```

- **Tags:** "Power BI", "Fabric", "DevOps", "CI/CD", "governance", "quality", "tutorial", "Microsoft"

- **Thumbnail:** Create a custom thumbnail with:
  - The toolkit logo or a screenshot of the launchpad
  - High contrast (e.g., bright background, dark text)
  - Large, readable text (25pt or bigger)
  - A visual that stands out in search results

### Common issues and solutions

| Issue | Solution |
|---|---|
| Tools won't load | Verify `python -m http.server` is still running. Check that the port (8000) is correct. Look for error messages in the browser console (F12). |
| Video is too dark | Check monitor brightness. Adjust Clipchamp display settings. Ensure room lighting is adequate. |
| Audio is hard to hear or distorted | Speak closer to your microphone. Reduce background noise. Adjust microphone volume in Clipchamp (aim for -18dB to -12dB in audio settings). |
| Mouse cursor is hard to see | Use Windows dark cursor (default is fine). Slow down mouse movements so viewers can follow. Consider using a cursor highlighter tool. |
| Recording has long pauses | Edit ruthlessly in post-production. Any pause over 3–4 seconds should be cut. Use fade transitions to smooth cuts. |
| Tools appear too small | Use browser zoom to 110–125% before recording. OR increase your monitor resolution during recording and zoom the camera/Clipchamp view. |
| Accidental minimization or tab switch | This is easy to edit out. Pause recording, click the right window, resume. Then edit the mistake out later. |

## Recording workflow checklist

Use this checklist to guide your recording session:

- [ ] **Setup phase**
  - [ ] Start local web server
  - [ ] Verify toolkit loads at localhost
  - [ ] Verify sample PBIP folder exists
  - [ ] Mute notifications
  - [ ] Close unrelated programs
  - [ ] Open this runbook on second screen (or memorize flow)
  - [ ] Set browser to 100% zoom, maximized window
  - [ ] Do a 30-second test recording to check audio/video quality

- [ ] **Recording phase**
  - [ ] Start Clipchamp and begin screen recording
  - [ ] Record opening narration (30–45 seconds)
  - [ ] Follow the demo script for each tool (Steps 1–17)
  - [ ] Pause on each generated output (2–3 seconds)
  - [ ] Mention artifact names explicitly
  - [ ] If you make a mistake: pause, wait, resume (edit later)
  - [ ] Stop recording after closing script
  - [ ] Export as 1080p MP4

- [ ] **Post-production phase**
  - [ ] Trim mistakes and long pauses
  - [ ] Normalize audio levels
  - [ ] Add title card
  - [ ] Add chapter markers/timestamps
  - [ ] Review captions/subtitles
  - [ ] Add fade transitions at cuts
  - [ ] Export final video



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

