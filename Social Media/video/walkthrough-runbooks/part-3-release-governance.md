# Part 3 Runbook — Pipeline, Release, Governance, and Adoption

## Goal

Show how the toolkit supports platform setup, policy exceptions, effective rules, release readiness, adoption tracking, governance coverage, and solution positioning.

## Recommended length

8 to 12 minutes.

## Tools covered

1. Pipeline Config Generator
2. Policy Exception Register
3. Effective Rules Generator
4. CI/CD Platform Parity Matrix
5. Release Readiness Dashboard
6. Adoption Metrics Dashboard
7. Rule Coverage Matrix
8. Competitive Differentiation Matrix

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

## Opening narration

Say:

> In this walkthrough, I am going to show the platform and governance side of the toolkit. We will generate CI/CD configuration, manage exceptions, preview effective rules, assess release readiness, and track adoption.

## Step 1 — Pipeline Config Generator

Open:

```text
http://localhost:8000/tools/pipeline-config-generator/index.html
```

Say:

> The Pipeline Config Generator converts one PBIP delivery profile into platform-specific YAML.

Demo actions:

1. Click **Use starter example**.
2. Switch between Azure DevOps, GitHub Actions, and GitLab CI.
3. Show branch triggers and enabled stages.
4. Show generated YAML and setup notes.

Mention outputs:

```text
azure-pipelines.generated.yml
powerbi-ci.generated.yml
gitlab-ci.generated.yml
pipeline-profile.json
pipeline-setup-notes.md
```

Transition:

> Once the pipeline exists, governance owners need a way to manage exceptions.

## Step 2 — Policy Exception Register

Open:

```text
http://localhost:8000/tools/policy-exception-register/index.html
```

Say:

> The Policy Exception Register keeps exceptions owned, approved, mitigated, and time-bound.

Demo actions:

1. Click **Use starter examples**.
2. Open an approved exception.
3. Show rule ID, owner, approver, affected artifact, expiration, reason, and mitigation.

Mention outputs:

```text
policy-exceptions.json
policy-exceptions-summary.md
```

Transition:

> Exceptions and branch policy affect what CI should actually enforce.

## Step 3 — Effective Rules Generator

Open:

```text
http://localhost:8000/tools/effective-rules-generator/index.html
```

Say:

> The Effective Rules Generator shows the final rule files that CI should use after branch policy, project overrides, and approved exceptions are applied.

Demo actions:

1. Click **Use starter example**.
2. Show report rules, dataset rules, overrides, and exceptions.
3. Generate effective rules.

Mention outputs:

```text
Rules-Report.effective.json
Rules-Dataset.effective.json
effective-rules-summary.md
```

## Step 4 — CI/CD Platform Parity Matrix

Open:

```text
http://localhost:8000/tools/platform-parity-matrix/index.html
```

Say:

> The Platform Parity Matrix documents which capabilities are supported across Azure DevOps, GitHub Actions, and GitLab CI.

Demo actions:

1. Click **Use starter matrix**.
2. Point out supported, partial, planned, and gap statuses.
3. Show generated Markdown or JSON.

Mention outputs:

```text
platform-parity-matrix.json
platform-parity-matrix.md
```

## Step 5 — Release Readiness Dashboard

Open:

```text
http://localhost:8000/tools/release-readiness-dashboard/index.html
```

Say:

> The Release Readiness Dashboard consolidates validation evidence into a release recommendation.

Demo actions:

1. Click **Use starter example**.
2. Show score, blockers, warnings, evidence sources, and recommendation.

Mention outputs:

```text
release-readiness-dashboard.html
release-readiness-dashboard.md
release-readiness-dashboard.json
```

## Step 6 — Adoption Metrics Dashboard

Open:

```text
http://localhost:8000/tools/adoption-metrics-dashboard/index.html
```

Say:

> The Adoption Metrics Dashboard helps program owners measure rollout, readiness, rule maturity, exceptions, and time-to-onboard.

Demo actions:

1. Click **Use starter metrics**.
2. Select a project.
3. Show readiness score, platform, rule maturity, exceptions, and onboarding time.

Mention outputs:

```text
adoption-metrics.json
adoption-metrics.csv
adoption-metrics.md
```

## Step 7 — Rule Coverage Matrix

Open:

```text
http://localhost:8000/tools/rule-coverage-matrix/index.html
```

Say:

> The Rule Coverage Matrix maps governance policies to automated rules and manual checks.

Demo actions:

1. Click **Use starter matrix**.
2. Show policy area, coverage status, automated rules, manual checks, and owner.

Mention outputs:

```text
rule-coverage-matrix.json
rule-coverage-matrix.md
```

## Step 8 — Competitive Differentiation Matrix

Open:

```text
http://localhost:8000/tools/competitive-differentiation-matrix/index.html
```

Say:

> The Competitive Differentiation Matrix helps explain why this is more than a generic CI/CD sample or best-practice deck.

Demo actions:

1. Click **Use starter matrix**.
2. Show the comparison between Enterprise BI DevOps and simpler alternatives.
3. Point out maturity scores.

Mention outputs:

```text
competitive-differentiation-matrix.json
competitive-differentiation-matrix.md
```

## Closing narration

Say:

> Across these tools, the accelerator supports the full operating model: source control, CI/CD, quality gates, review evidence, release readiness, governance, and adoption. Teams can start with one PBIP project and grow toward enterprise BI DevOps over time.

## Checklist before ending recording

- [ ] Pipeline YAML generated.
- [ ] Policy exception example shown.
- [ ] Effective rules generated.
- [ ] Platform parity shown.
- [ ] Release readiness recommendation shown.
- [ ] Adoption metrics shown.
- [ ] Rule coverage shown.
- [ ] Differentiation matrix shown.
- [ ] Output artifact names mentioned.

