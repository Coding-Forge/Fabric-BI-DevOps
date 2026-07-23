# Part 2 Runbook — PBIP Review and PR Readiness

## Goal

Show how the toolkit helps report authors prepare pull requests for review and helps reviewers understand changes efficiently. This part demonstrates the end-to-end workflow from development readiness through PR summary generation.

This part is designed for:
- **Report authors and semantic model owners** who are preparing their changes for pull request
- **PR reviewers and BI leads** who need to assess changes efficiently
- **Platform teams** who want to reduce PR review time and improve quality
- **Facilitators** delivering the accelerator to customers

## Recommended length

10–15 minutes (allows for exploring multiple tools and real-world scenarios).

## Tools covered

1. **Deployment Manifest Builder** — Define the release contract and deployment context
2. **PBIP Project Readiness Scanner** — Pre-PR quality checkpoint for report authors
3. **PBIP Diff Viewer** — Translate raw PBIP changes into reviewer-friendly categories
4. **Dependency Impact Analyzer** — Identify downstream impact of semantic model changes
5. **PR Quality Summary Generator** — Create an executive handoff for reviewers

## Key theme

"Context matters more than code." This part shows how to move from code review (reading JSON) to context-aware review (understanding business impact). The tools translate technical changes into business language.

## Recording setup

Start localhost:

```powershell
cd C:\Projects\Fabric-BI-DevOps-Demo
python -m http.server 8000
```

Open:

```text
http://localhost:8000/tools/index.html
```

Use this PBIP folder when a folder upload is needed:

```text
C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local
```

Verify the folder exists and the scanner can access it.

## Opening narration

Say:

> Welcome to Part 2 of the Fabric BI DevOps Accelerator Toolkit walkthrough.

> In Part 1, we defined quality standards: enterprise policies, tuned rules, and measure tests. Those standards are enforced by CI/CD on every pull request.

> But standards and automation only get you halfway. Code review still matters. And code review is slow when reviewers have to read raw JSON to understand what changed and why.

> In this part, we're going to show how the toolkit makes code review faster and more effective. We'll show how report authors prepare pull requests, how reviewers understand changes, and how the team documents deployment intent and risk.

> By the end of this part, you'll see a complete PR workflow that takes hours of manual review and compresses it into minutes of context-aware assessment.

> Let's start.

**Timing:** 60 seconds. Sets context and emphasizes speed and understanding.

## Step 1 — Deployment Manifest Builder

Open:

```text
http://localhost:8000/tools/deployment-manifest-builder/index.html
```

Say:

> Every change that flows through a pull request is eventually deployed somewhere. Before the PR, you need to answer: What is being deployed? Who owns it? Where does it go? What governance checks must pass?

> The Deployment Manifest Builder creates a release contract. It documents all of this in one place.

> This manifest is the source of truth for the release team. It's also read by reviewers to understand deployment context.

Demo actions:

1. Click **Use starter manifest** to load a pre-built example.

2. Show and explain:
   - **Solution name and description** (what are we deploying?)
   - **Owners** (who is responsible? creator, approver, release manager)
   - **Artifacts list** (which reports, models, dashboards are in scope?)
   - **Environment stages** (dev → test → staging → prod?)
   - **Parameters** (what configurable values change between environments?)
   - **Validation gates** (what checks must pass before release? readiness score, DAX tests, manual approvals?)
   - **Rollback strategy** (if something goes wrong, how do we get back to the previous version? how long does it take?)

3. Scroll through the full manifest to show its depth.

4. Pause on the generated Markdown summary (deployment-summary.md) for 2–3 seconds.

Say:

> This manifest is a contract. It says to the team: 'Here's exactly what's being deployed, here's who can approve it, here's what checks it must pass, and here's how we roll back if needed.'

> This prevents surprises at release time. No 'Oh, I didn't know that artifact was in this deployment' or 'I thought Carol was approving this, not Bob.'

Artifacts to mention:

```text
deployment-manifest.json
deployment-summary.md
```

Use-case example:

> Example: Your team is deploying three new reports and updating one shared semantic model. The manifest documents that Alice is the report owner, Bob owns the semantic model, Carol must approve changes to the semantic model (because it's shared), and the deployment requires 50+ readiness score and passing DAX tests. This manifest is visible to everyone on the PR.

Transition:

> Now that we know what's being deployed, we need to check: Is the PBIP project actually ready for review?

**Timing:** 3–4 minutes.

## Step 2 — PBIP Project Readiness Scanner

Open:

```text
http://localhost:8000/tools/pbip-readiness-scanner/index.html
```

Say:

> Before opening a pull request, the report author should ask: 'Is my project ready for review?' The PBIP Readiness Scanner answers that question automatically.

> The scanner checks whether the PBIP has the right folder structure, includes governance files (quality rules and DAX tests), has proper CI/CD configuration, and doesn't have any structural problems that reviewers will have to complain about.

> It's a pre-PR checkpoint that saves time by catching problems before reviewers see them.

Demo actions:

1. Click the folder upload or preview control.

2. Select the sample PBIP:

   ```text
   C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local
   ```

3. Show the scan results:
   - **PBIP structure findings** (is `.report` folder present? are models in the right place?)
   - **Report structure** (do reports have proper page configuration?)
   - **Semantic model structure** (do tables have proper properties? are relationships configured?)
   - **Governance assets** (do the quality rules file and DAX test file exist and are valid?)
   - **CI/CD wiring** (is the deployment manifest present? are pipeline files in place?)

4. Point out the severity levels (error, warning, info). Explain that errors block, warnings suggest improvement, info is informational.

5. Show the generated Markdown report.

Say:

> If the scan passes, the author knows the PR will likely succeed. If there are warnings or errors, the author can fix them right now before asking reviewers to spend time. This is self-service quality control.

Artifacts to mention and pause on:

```text
pbip-readiness-report.md
pbip-readiness-report.json
```

Use-case example:

> Example: A junior report author creates their first PBIP report and runs the scanner before opening a PR. The scanner warns that the measurement table is missing key metadata. The author sees the warning, fixes it in the PBIP editor, runs the scanner again, and now it passes. They open the PR confident that at least the structure is sound. Reviewers can focus on logic and design, not structure problems.

Say:

> This is how you scale quality. You automate structural checks so reviewers focus on business logic and design decisions, not linting.

Transition:

> Okay, structure is good. Now reviewers need to know: What changed?

**Timing:** 3–4 minutes.

## Step 3 — PBIP Diff Viewer

Open:

```text
http://localhost:8000/tools/pbip-diff-viewer/index.html
```

Say:

> Here's the hard truth about PBIP review: if you ask reviewers to read the raw JSON and TMDL diffs, they'll go slow and miss things. JSON is not human-readable, especially for non-developers.

> The PBIP Diff Viewer translates raw PBIP changes into human-readable categories. Instead of 'line 47 of model.tmdl changed', it says 'a measure named Revenue was modified' or 'the relationship between Tables A and B changed from one-to-many to many-to-many'.

Demo actions:

1. Click **Use starter example** to load a pre-configured before/after scenario.

2. Show the summary:
   - How many files added, changed, removed
   - Breakdown by type (report pages, semantic model objects, etc.)

3. Select a changed semantic model object (e.g., a measure or column) and show:
   - **What changed** (the specific change in business terms)
   - **Review guidance** (what should reviewers focus on? what are the risks?)
   - **Before and after** (snippets showing the old and new versions)

4. Select a changed report page and show which visuals were affected.

5. Pause on the generated Markdown (pbip-diff-report.md) for 2–3 seconds.

Say:

> This is what goes into the PR or a comment. It tells reviewers exactly what changed in business terms. No need to decode JSON. They can read this and immediately understand what they're reviewing.

Artifacts to mention:

```text
pbip-diff-report.html
pbip-diff-report.md
pbip-diff-report.json
```

Say:

> The HTML version is great for sharing broadly (anyone can read it in a browser). The Markdown is perfect for pasting into PR comments. The JSON is for systems that need to parse it programmatically.

Use-case example:

> Example: A BI developer changes the Sales semantic model to add a new measure and update a relationship. They run the diff viewer. It shows that 'Revenue measure modified', 'New measure added: Gross Margin', and 'Relationship changed: Orders to Products'. Reviewers see this report and immediately know to check whether Revenue is still calculating correctly and whether Gross Margin is being used on any reports.

Transition:

> Knowing what changed is useful. But reviewers also need to know: How far does this change ripple through the organization?

**Timing:** 3–4 minutes.

## Step 4 — Dependency Impact Analyzer

Open:

```text
http://localhost:8000/tools/dependency-impact-analyzer/index.html
```

Say:

> The Dependency Impact Analyzer is critical for risk assessment. It answers the question: if this semantic model object changes, what downstream report pages, visuals, tests, and governance assets might be affected?

> Consider this: if you change a measure that appears on 2 reports, that's low risk. But if you change a measure that appears on 30 reports and is used in 10 calculations, that's high risk. Reviewers need to know the difference.

> The Impact Analyzer quantifies this by showing all downstream dependencies.

Demo actions:

1. Click **Use starter example** to load a pre-built scenario.

2. Show the changed objects (e.g., `Sales[Amount]`, `Revenue` measure).

3. For each changed object, show:
   - **Impacted measures** (what other measures reference this?)
   - **Impacted visuals** (what visuals use this measure?)
   - **Impacted report pages** (which pages have affected visuals?)
   - **Impacted relationships** (what other model objects connect to this?)
   - **Impacted validation rules** (are any quality rules or DAX tests affected?)
   - **Impacted governance assets** (do governance definitions reference this object?)

4. Point out the severity scoring—if a change affects many objects, the risk score goes up.

5. Pause on the generated report (dependency-impact-report.md or .html) for 2–3 seconds.

Say:

> This report tells reviewers: 'You're changing this measure, which impacts these 5 other measures, which appear on these 12 report pages. Here's the full blast radius. Make sure you've tested it all.'

Artifacts to mention:

```text
dependency-impact-report.html
dependency-impact-report.md
dependency-impact-report.json
```

Use-case example:

> Example: A developer wants to change the OrderDate column in the Orders table to use a different data type. The Impact Analyzer shows that this column is used in 8 relationships, 23 calculated columns, and 45 visuals across 18 report pages. The developer sees this and realizes 'Okay, I need to test comprehensively and coordinate this change.' The risk is now visible.

Say:

> Without this tool, reviewers would spot the change and think, 'Hmm, is this safe?' and spend time hunting for dependencies. The analyzer does that hunting automatically.

Transition:

> Now we have readiness, diffs, and impact. The last step is to package all of this evidence into a pull request summary that reviewers can digest quickly.

**Timing:** 3–4 minutes.

## Step 5 — PR Quality Summary Generator

Open:

```text
http://localhost:8000/tools/pr-quality-summary-generator/index.html
```

Say:

> All right, we've gathered evidence: readiness, diffs, impact analysis. Now we need to package that evidence into one clean handoff for reviewers.

> The PR Quality Summary Generator creates a Markdown summary that combines all the signals: what changed, what passed validation, what the deployment plan is, what the impact is, and what DAX tests are relevant.

> The report author copies this summary and pastes it into the PR description. Reviewers read one document and have all the context they need.

Demo actions:

1. Click **Use starter example** to load a pre-built summary scenario.

2. Show the input fields:
   - **Changed files** (what's in this PR?)
   - **Validation output** (did the PBIP pass all quality checks?)
   - **Readiness output** (what does the readiness scanner say?)
   - **DAX test context** (what measure tests are affected?)
   - **Dependency impact** (what's the blast radius?)
   - **Deployment manifest** (what's the release intent and rollback plan?)

3. Show how you fill in each section (using starter examples).

4. Pause on the generated Markdown (PR-Quality-Summary.md) for 2–3 seconds.

Say:

> Look at this. A reviewer reads this and immediately knows: what's changing, what validation it passed, whether there are risks, what the deployment plan is, and how to roll back if needed. No questions to ask. No back-and-forth.

> This is the difference between slow code review and fast code review. Context and clarity.

Artifacts to mention:

```text
PR-Quality-Summary.md
pr-quality-summary.json
```

Use-case example:

> Example: A report author creates a new report with a shared semantic model connection. They run all the tools—readiness scanner (passes), diff viewer (shows 3 new report pages), dependency impact (shows the new report appears on 1 page), compile check (passes). They use the PR Summary Generator to create a handoff: 'Here's what changed, here's what passed, here's the impact.' They paste it into the PR. The reviewer reads the summary in 2 minutes and approves. Without these tools, the review would have taken 20 minutes and required back-and-forth.

## Closing narration

Say:

> Let's recap what we just saw:

> 1. **Deployment Manifest** — The release contract. Everyone knows what's being deployed, who owns it, and what conditions must be met.

> 2. **Readiness Scanner** — Pre-PR checkpoint. Authors catch structural problems before reviewers see them.

> 3. **PBIP Diff Viewer** — Translate raw changes into business language. Reviewers understand what changed without decoding JSON.

> 4. **Dependency Impact Analyzer** — Quantify the blast radius. Reviewers assess risk without hunting for dependencies.

> 5. **PR Summary Generator** — Package all evidence into one document. Reviewers get context without asking questions.

> Together, these tools compress hours of manual review into minutes. More importantly, they move review from 'Does this look okay?' to 'Is this safe and does it fit the deployment plan?'

> In the next part of this walkthrough, we'll see the platform team perspective: pipeline generation, governance and exception tracking, and adoption measurement.

> Thank you for watching Part 2.

**Timing:** 2–3 minutes.

## Checklist before ending recording

- [ ] Manifest starter shown; all major sections explained.
- [ ] PBIP folder scanner shown and executed against sample PBIP.
- [ ] Diff Viewer starter example shown; at least one changed object explained.
- [ ] Dependency Impact Analyzer starter example shown; downstream impacts displayed.
- [ ] PR summary generated; final Markdown paused on and discussed.
- [ ] All artifact names mentioned explicitly.
- [ ] At least one realistic use-case scenario discussed for each major tool.
- [ ] Transitions between tools are smooth and logical.
- [ ] Opening and closing narration emphasize speed, context, and clarity.

## Audio/video quality checklist

- [ ] Microphone audio is clear and consistent volume.
- [ ] No background noise or echo.
- [ ] Browser is at 100% zoom; tools are readable.
- [ ] Sample PBIP folder exists and scanner runs without error.
- [ ] Mouse movements are deliberate and easy to follow.
- [ ] Pauses on generated outputs are adequate (2–3 seconds).



