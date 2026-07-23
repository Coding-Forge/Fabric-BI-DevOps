# Part 1 Runbook — Standards and Quality Foundation

## Goal

Show how the toolkit helps teams define BI quality standards, tune individual rules, and create DAX test metadata before CI/CD enforcement.

## Recommended length

6 to 10 minutes.

## Tools covered

1. Launchpad
2. Enterprise Standards Builder
3. Quality Rule Designer
4. DAX Test Builder

## Recording setup

Start the local server:

```powershell
cd C:\Projects\Fabric-BI-DevOps-Demo
python -m http.server 8000
```

Open:

```text
http://localhost:8000/tools/index.html
```

## Opening narration

Say:

> In this first walkthrough, I am going to show how the Fabric BI DevOps Accelerator helps a team define quality standards, tune rules, and document DAX test expectations before those checks become part of CI/CD.

## Step 1 — Launchpad

Open:

```text
http://localhost:8000/tools/index.html
```

Show:

- Tool Catalog
- Workflow tab
- Artifacts tab
- Audience paths tab

Say:

> The launchpad is the starting point. It organizes the toolkit by job-to-be-done and helps different roles understand which tool to use first.

Demo actions:

1. Click **Tool Catalog**.
2. Point out the three groups: standards, review/release, governance/adoption.
3. Click **Workflow**.
4. Point out that standards and DAX metadata come before PR and release review.

Transition:

> We start with standards because the rest of the operating model depends on clear quality expectations.

## Step 2 — Enterprise Standards Builder

Open:

```text
http://localhost:8000/tools/enterprise-standards-builder/index.html
```

Say:

> The Enterprise Standards Builder turns governance decisions into report and semantic model rule files. This avoids asking every report creator to hand-edit JSON.

Demo actions:

1. Choose an enterprise or strict profile.
2. Scroll through report usability settings.
3. Scroll through semantic model and DAX settings.
4. Show the generated rule output or summary.

Mention outputs:

```text
Rules-Report.json
Rules-Dataset.json
enterprise-policy-profile.json
```

Narration:

> These files can be committed to the repo and consumed by Azure DevOps, GitHub Actions, or GitLab CI.

Transition:

> Sometimes a team needs to tune just one rule, and that is where the Rule Designer fits.

## Step 3 — Quality Rule Designer

Open:

```text
http://localhost:8000/tools/rule-designer/index.html
```

Say:

> The Quality Rule Designer is for advanced tuning. It lets the platform team inspect, create, or modify individual report and dataset rules safely.

Demo actions:

1. Click **Use starter examples**.
2. Select one report rule.
3. Show the rule ID, severity, enabled state, and logic.
4. Explain that teams can lower severity during adoption and promote to blocking later.

Mention outputs:

```text
Rules-Report.json
Rules-Dataset.json
```

Transition:

> Quality rules validate report and model structure. DAX tests document business expectations for important measures.

## Step 4 — DAX Test Builder

Open:

```text
http://localhost:8000/tools/dax-test-builder/index.html
```

Say:

> The DAX Test Builder creates structured metadata for critical measures. It helps a semantic model owner document expected behavior before release.

Demo actions:

1. Click **Use starter examples**.
2. Select one test.
3. Show measure name, owner, scenario, expected result, severity, and tags.
4. Show the generated DAX preview or Markdown catalog.

Mention outputs:

```text
dax-tests.json
dax-test-catalog.md
```

Closing narration:

> At this point we have a quality foundation: enterprise standards, tuned rules, and measure test metadata. In the next walkthrough, we will use the toolkit to prepare a PBIP change for review.

## Checklist before ending recording

- [ ] Launchpad workflow shown.
- [ ] Standards Builder profile shown.
- [ ] Rule Designer starter example shown.
- [ ] DAX Test Builder starter example shown.
- [ ] Output artifact names mentioned.

