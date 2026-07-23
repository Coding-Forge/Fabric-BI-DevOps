# Part 2 Runbook — PBIP Review and PR Readiness

## Goal

Show how the toolkit helps report authors and reviewers understand whether a PBIP change is ready for pull request review.

## Recommended length

8 to 12 minutes.

## Tools covered

1. Deployment Manifest Builder
2. PBIP Project Readiness Scanner
3. PBIP Diff Viewer
4. Dependency Impact Analyzer
5. PR Quality Summary Generator

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

## Opening narration

Say:

> In this walkthrough, I am going to show how the toolkit helps a team prepare a PBIP change for review. We will create release context, scan readiness, inspect diffs, analyze impact, and generate a PR summary.

## Step 1 — Deployment Manifest Builder

Open:

```text
http://localhost:8000/tools/deployment-manifest-builder/index.html
```

Say:

> The Deployment Manifest Builder creates a release contract. It documents what is being deployed, who owns it, where it goes, what validation gates apply, and how rollback works.

Demo actions:

1. Click **Use starter manifest**.
2. Show solution name and owners.
3. Show environment mapping.
4. Show validation gates and rollback.

Mention outputs:

```text
deployment-manifest.json
deployment-summary.md
```

Transition:

> After we know what the solution is, we need to confirm the PBIP project is ready for review.

## Step 2 — PBIP Project Readiness Scanner

Open:

```text
http://localhost:8000/tools/pbip-readiness-scanner/index.html
```

Say:

> The Readiness Scanner checks whether the PBIP folder has the structure and supporting files needed before a pull request.

Demo actions:

1. Click the folder upload or preview control.
2. Select:

   ```text
   C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local
   ```

3. Show PBIP, report, and semantic model structure findings.
4. Show governance or pipeline asset findings.

Mention outputs:

```text
PBIP-Readiness-Report.md
pbip-readiness-report.json
```

Transition:

> Structure is only one part of review. Reviewers also need to know what changed.

## Step 3 — PBIP Diff Viewer

Open:

```text
http://localhost:8000/tools/pbip-diff-viewer/index.html
```

Say:

> The PBIP Diff Viewer turns raw PBIP JSON and TMDL changes into a reviewer-friendly diff.

Demo actions:

1. Click **Use starter example**.
2. Show added, removed, and changed file counts.
3. Select a changed semantic model or report file.
4. Show review guidance and before/after excerpts.

Mention outputs:

```text
pbip-diff-report.html
pbip-diff-report.md
pbip-diff-report.json
```

Transition:

> A diff tells us what changed. Impact analysis tells us what might be affected by that change.

## Step 4 — Dependency Impact Analyzer

Open:

```text
http://localhost:8000/tools/dependency-impact-analyzer/index.html
```

Say:

> The Dependency Impact Analyzer traces changed model objects to downstream measures, visuals, pages, relationships, tests, and governance assets.

Demo actions:

1. Click **Use starter example**.
2. Show changed objects such as `Sales[Amount]` and `Revenue`.
3. Show impacted measures and visuals.
4. Show generated Markdown or JSON output.

Mention outputs:

```text
dependency-impact-report.html
dependency-impact-report.md
dependency-impact-report.json
```

Transition:

> Now we can package the review evidence into a PR summary.

## Step 5 — PR Quality Summary Generator

Open:

```text
http://localhost:8000/tools/pr-quality-summary-generator/index.html
```

Say:

> The PR Quality Summary Generator creates a concise handoff for reviewers. It combines changed files, validation results, readiness output, DAX context, manifest context, and risks.

Demo actions:

1. Click **Use starter example**.
2. Show changed paths.
3. Show pipeline/readiness/DAX/manifest fields.
4. Show generated Markdown.

Mention outputs:

```text
PR-Quality-Summary.md
pr-quality-summary.json
```

Closing narration:

> This review package gives reviewers the context they need: structure, release intent, diffs, impact, and a PR summary. In the next walkthrough, we will look at pipeline generation, release readiness, exceptions, and adoption tracking.

## Checklist before ending recording

- [ ] Manifest starter shown.
- [ ] PBIP folder scanner shown against demo PBIP.
- [ ] Diff Viewer starter example shown.
- [ ] Dependency Impact Analyzer starter example shown.
- [ ] PR summary generated.
- [ ] Output artifact names mentioned.

