# Part 3 Runbook — Pipeline, Release, Governance, and Adoption

## Goal

Show how the toolkit supports platform teams in generating CI/CD configuration, managing policy exceptions, tracking governance coverage, assessing release readiness, and measuring adoption across the organization.

This part is designed for:
- **Platform teams and DevOps engineers** who set up CI/CD pipelines and governance infrastructure
- **Release managers and BI leads** who coordinate deployments and manage exceptions
- **Governance owners and program officers** who track adoption and measure program success
- **Facilitators** delivering the accelerator at scale

## Recommended length

10–15 minutes (allows for exploring multiple advanced tools and real-world scenarios).

## Tools covered

1. **Pipeline Config Generator** — Generate platform-specific CI/CD YAML
2. **Policy Exception Register** — Track owned, approved, time-bound exceptions
3. **Effective Rules Generator** — Merge baseline rules, overrides, and exceptions
4. **CI/CD Platform Parity Matrix** — Document capability parity across platforms
5. **Release Readiness Dashboard** — Consolidate evidence for release decisions
6. **Adoption Metrics Dashboard** — Measure program success and maturity
7. **Rule Coverage Matrix** — Map policies to automated and manual checks
8. **Competitive Differentiation Matrix** — Position the solution against alternatives

## Key theme

"Scale what works." This part shows how to take a working governance and CI/CD model on one team and scale it to many teams and projects without reinventing anything.

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

> Welcome to Part 3 of the Fabric BI DevOps Accelerator Toolkit walkthrough.

> In Part 1, we defined quality standards and DAX tests. In Part 2, we showed how report authors prepare pull requests and how reviewers assess changes.

> In this final part, we're shifting to the platform team and governance owner perspective: How do we scale this across the organization? How do we generate CI/CD configuration? How do we manage exceptions? How do we track whether the program is actually working?

> These are the tools for building a sustainable, measurable BI DevOps program.

> Let's start.

**Timing:** 45 seconds. Sets context and emphasizes scale and measurement.

## Step 1 — Pipeline Config Generator

Open:

```text
http://localhost:8000/tools/pipeline-config-generator/index.html
```

Say:

> One of the big challenges in multi-platform environments is this: if you support Azure DevOps, GitHub Actions, and GitLab CI, do you write and maintain three separate pipeline definitions? That's a lot of work and creates drift.

> The Pipeline Config Generator takes one delivery profile—one set of decisions about what stages to run, what gates to enforce, what artifacts to publish—and generates platform-specific YAML for all three platforms.

Demo actions:

1. Click **Use starter example** to load a pre-built profile.

2. Show the profile configuration:
   - **Solution name and description**
   - **Pipeline stages** (lint, validate, publish, deploy, etc.)
   - **Enabled checks** (run quality rules? run DAX tests? require approvals?)
   - **Trigger settings** (run on main? run on PRs?)
   - **Publish targets** (where do artifacts go?)
   - **Deployment settings** (Dev/Test/Prod stages, parameters, approvals)

3. Switch between Azure DevOps, GitHub Actions, and GitLab CI tabs.

4. Show the generated YAML for each platform. Pause on each for 2–3 seconds.

5. Show the setup notes Markdown (pipeline-setup-notes.md).

Say:

> Notice how the logic is the same across all three platforms, but the syntax is different. The generator handles that translation. You write the spec once, and the YAML is generated for each platform.

> Can you customize the YAML after generation? Absolutely. But you start with a working, tested template that covers the common cases.

Artifacts to mention:

```text
azure-pipelines.generated.yml
powerbi-ci.generated.yml  (GitHub Actions)
gitlab-ci.generated.yml
pipeline-profile.json
pipeline-setup-notes.md
```

Use-case example:

> Example: Your organization standardizes on GitHub Actions, but one team uses Azure DevOps for legacy reasons. You use the Pipeline Config Generator to create one profile that works for both teams. Each team gets the YAML they need, and they're enforcing the same standards.

Transition:

> Once the pipeline is running, you need a way to manage exceptions. Not every team can follow every rule all the time.

**Timing:** 3–4 minutes.

## Step 2 — Policy Exception Register

Open:

```text
http://localhost:8000/tools/policy-exception-register/index.html
```

Say:

> In the real world, not every artifact can follow every rule all the time. Sometimes there's a business need that conflicts with a governance standard. When that happens, you need a way to approve, track, and eventually resolve the exception.

> The Policy Exception Register is your exception management system. It makes exceptions visible, owned, approved, mitigated, and time-bound.

> Without this tool, exceptions become invisible—they live in Slack messages, email threads, or pull request comments. They're never tracked and never resolved.

Demo actions:

1. Click **Use starter examples** to load pre-built exceptions.

2. Open an approved exception and show:
   - **Rule ID** (which governance rule is the exception for?)
   - **Affected artifact** (which report, dataset, or solution is affected?)
   - **Owner** (who requested the exception?)
   - **Approver** (who is responsible for approving it?)
   - **Reason** (why is the exception necessary? business context matters.)
   - **Mitigation** (what's the plan to get back to compliance?)
   - **Expiration date** (when must this be resolved or explicitly extended?)

3. Show the generated summary Markdown.

Say:

> Each exception is visible. If you want to know which rules have been bypassed and why, you read this register.

> Each exception has an owner and approver. Everyone knows who's responsible.

> Each exception expires. If an exception is still needed, it must be explicitly re-approved. If it expires without action, it becomes a CI blocker until someone reviews it.

Artifacts to mention:

```text
policy-exceptions.json
policy-exceptions-summary.md
```

Use-case example:

> Example: A legacy report has a naming convention that doesn't match new standards. It would take weeks to refactor it. The team files an exception: 'We need to keep the old naming on this report for backward compatibility. We'll rename it when we decommission it in Q2.' The exception is approved until Q2. When Q2 arrives, the team either removes the report, renames it, or requests another extension. The governance owner can see exactly what's exempted, why, and for how long.

Transition:

> Exceptions and branch policy affect what the CI system actually enforces. The Effective Rules Generator shows you exactly what that is.

**Timing:** 3–4 minutes.

## Step 3 — Effective Rules Generator

Open:

```text
http://localhost:8000/tools/effective-rules-generator/index.html
```

Say:

> Here's the complexity: you have baseline enterprise rules. You might have project-specific overrides. You might have approved exceptions. The CI/CD system needs to know: what am I actually enforcing on this branch, in this project, right now?

> The Effective Rules Generator answers that by merging all three sources—baseline, overrides, and exceptions—into a single set of rules that the pipeline uses.

Demo actions:

1. Click **Use starter example** to load a pre-configured scenario.

2. Show the inputs:
   - **Baseline rules** (enterprise-wide standards from Part 1)
   - **Project overrides** (customizations for this team or project)
   - **Approved exceptions** (temporary bypasses from the exception register)
   - **Source branch** (which branch are we coming from?)
   - **Target branch** (which branch are we merging into?)

3. Click **Generate Effective Rules**.

4. Show the output files:
   - Rules-Report.effective.json
   - Rules-Dataset.effective.json
   - effective-rules-summary.md

5. Pause on the summary for 2–3 seconds.

Say:

> This is the source of truth for enforcement. The CI/CD system reads this file and enforces exactly what's here. No guessing, no surprises.

Artifacts to mention:

```text
Rules-Report.effective.json
Rules-Dataset.effective.json
effective-rules-summary.md
```

Use-case example:

> Example: Your enterprise baseline has a 'strict' set of rules. The Sales team's project needs to be slightly more permissive during onboarding, so they have project overrides that lower severity on two rules for the dev branch. Plus, they have one approved exception. The Effective Rules Generator shows: on the dev branch, enforce these 18 rules strictly and these 2 with warnings. On main, enforce all 20 strictly. The CI system reads this and applies the right rules to the right branches.

Transition:

> Now you know what you're enforcing. But here's a question: are your governance rules applicable across all three CI/CD platforms equally?

**Timing:** 3–4 minutes.

## Step 4 — CI/CD Platform Parity Matrix

Open:

```text
http://localhost:8000/tools/platform-parity-matrix/index.html
```

Say:

> One of the core value propositions of this accelerator is that it's platform-neutral—you can use it with Azure DevOps, GitHub Actions, or GitLab CI. But let's be honest: there are differences across platforms.

> The Platform Parity Matrix documents exactly what works the same, what requires workarounds, what's in progress, and what's not available yet.

> This is critical information for platform teams making deployment decisions.

Demo actions:

1. Click **Use starter matrix** to load the comparison.

2. Show the matrix with columns for:
   - Azure DevOps
   - GitHub Actions
   - GitLab CI

3. Point out the legend:
   - ✅ Supported (same across all platforms)
   - ⚠️ Partial (different implementations or limitations)
   - 🔄 Planned (coming soon)
   - ❌ Gap (not available or significant workaround needed)

4. Scroll through and explain 3–4 row examples (e.g., "branch policies", "PR comments", "artifact storage").

Say:

> This matrix answers the question: 'If I choose GitLab CI, what trade-offs am I making?' Teams can make informed platform decisions instead of discovering parity issues after they've already started.

Artifacts to mention:

```text
platform-parity-matrix.json
platform-parity-matrix.md
```

Transition:

> Okay, the platform is set up, exceptions are managed, rules are effective. The last big question is: are we ready to release?

**Timing:** 2–3 minutes.

## Step 5 — Release Readiness Dashboard

Open:

```text
http://localhost:8000/tools/release-readiness-dashboard/index.html
```

Say:

> Release decisions are often made on gut feel or hope. The Release Readiness Dashboard changes that by consolidating all the evidence—validation, quality, tests, manifest, exceptions, adoption metrics—into one recommendation.

Demo actions:

1. Click **Use starter example** to load a pre-built assessment.

2. Show:
   - **Overall readiness score** (percentage ready, as a number)
   - **Blockers** (failures that prevent release)
   - **Warnings** (concerns that should be reviewed before release)
   - **Evidence sources** (where did each signal come from? validation logs, quality rules, DAX tests, etc.)
   - **Recommendation** (Ready, Ready with Review, or Do Not Release)

3. Show how different signal types contribute to the score.

Say:

> A release manager reads this and sees: 'Quality checks passed 95%, DAX tests passed 100%, deployment manifest is complete, exceptions are managed, adoption metrics show similar projects succeed 90% of the time. Recommendation: Ready.'

> That's evidence-based decision-making.

Artifacts to mention:

```text
release-readiness-dashboard.html
release-readiness-summary.md
release-readiness-report.json
```

Transition:

> Releases happen. The question after that is: are we actually improving over time?

**Timing:** 2–3 minutes.

## Step 6 — Adoption Metrics Dashboard

Open:

```text
http://localhost:8000/tools/adoption-metrics-dashboard/index.html
```

Say:

> Governance programs are usually measured by compliance: 'Are people following the rules?' But that's backward-looking. The Adoption Metrics Dashboard is forward-looking: 'How many teams have we onboarded? How mature are they? Are they getting faster?'

> This is what program officers use to argue for continued investment.

Demo actions:

1. Click **Use starter metrics** to load pre-built metrics.

2. Show:
   - **Projects onboarded** (by platform, by team, by status)
   - **Readiness scores** (average, by project, distribution)
   - **Rule maturity** (how many rules are enabled? how many issues are they catching?)
   - **Exception aging** (are exceptions being resolved or extending indefinitely?)
   - **Time-to-onboard** (how long does it take a new team to be productive?)
   - **Velocity improvement** (are review times improving? are rework cycles decreasing?)

3. Show the generated CSV and Markdown.

Say:

> Example metrics: 'We've onboarded 40 projects. Average readiness is 82%. Exceptions are being resolved on-time. Time-to-onboard has decreased from 3 weeks to 2 weeks.' That's evidence of program success.

Artifacts to mention:

```text
adoption-metrics.json
adoption-metrics.csv
adoption-metrics.md
```

Transition:

> One more thing: when you define governance, you should track coverage. Are you governing everything you said you would?

**Timing:** 2–3 minutes.

## Step 7 — Rule Coverage Matrix

Open:

```text
http://localhost:8000/tools/rule-coverage-matrix/index.html
```

Say:

> The Rule Coverage Matrix maps your governance policies to implementation: which are automated rules, which are manual checks, and which are gaps you still need to fill.

> It's a completeness check on your governance program.

Demo actions:

1. Click **Use starter matrix** to load a pre-built coverage map.

2. Show columns like:
   - **Policy area** (data quality, naming standards, versioning, etc.)
   - **Automated rule** (is there a PBI Inspector or Tabular Editor rule?)
   - **Manual check** (do code reviewers verify this?)
   - **Owner** (who's responsible?)
   - **Status** (complete, partial, or planned?)

3. Point out a few rows that show complete coverage, partial coverage, and gaps.

Say:

> This matrix answers: 'Are we really governing everything we committed to?' It highlights gaps and helps prioritize which rules to automate next.

Artifacts to mention:

```text
rule-coverage-matrix.json
rule-coverage-matrix.md
```

Transition:

> Finally, let's talk about why this matters.

**Timing:** 2 minutes.

## Step 8 — Competitive Differentiation Matrix

Open:

```text
http://localhost:8000/tools/competitive-differentiation-matrix/index.html
```

Say:

> A lot of people ask: 'Is this just a pipeline? Or is it really something more?'

> The Competitive Differentiation Matrix answers that by comparing this accelerator to alternatives: generic CI/CD samples, best-practice decks, home-grown solutions, and public competitors.

Demo actions:

1. Click **Use starter matrix** to load the comparison.

2. Show rows for capabilities like:
   - PBIP-native understanding
   - Power BI/Fabric specific
   - No custom code required
   - Multi-platform support
   - Governance integration
   - Adoption tracking

3. Point out where this accelerator is differentiated and where alternatives are stronger (be honest).

Say:

> The point isn't that this is the only way. The point is that it's purpose-built for Power BI and Fabric, it doesn't require custom development, and it covers the full operating model from standards through adoption.

Artifacts to mention:

```text
competitive-differentiation-matrix.json
competitive-differentiation-matrix.md
```

**Timing:** 2–3 minutes.

## Closing narration

Say:

> Let's recap the full journey.

> **Part 1 (Standards):** Define policy once, enforce everywhere. Use the Enterprise Standards Builder, Quality Rule Designer, and DAX Test Builder to create the baseline. Commit these files to your repo.

> **Part 2 (Review):** Move from code review to context-aware review. Use the Deployment Manifest, Readiness Scanner, PBIP Diff Viewer, Dependency Impact Analyzer, and PR Summary Generator to give reviewers all the context they need.

> **Part 3 (Platform & Governance):** Scale consistently across teams and platforms. Use the Pipeline Config Generator for multi-platform support, exception tracking for flexibility, effective rules for transparency, release readiness for evidence-based decisions, and adoption metrics for program accountability.

> The magic is in the combination. Standards alone don't work. Automation alone doesn't work. Review alone doesn't work. But standards + automation + smart review + governance + platform consistency + adoption tracking = a sustainable BI DevOps operating model.

> Teams can start small—one PBIP, one set of rules, one pipeline. Then they scale. They add more projects, more teams, more exceptions, more metrics. Every team is enforcing the same standards, every reviewer has the same tools, every release is evidence-based.

> That's the point of this accelerator.

> Thank you for watching all three parts. We hope the toolkit helps you build a better BI DevOps program for your organization.

**Timing:** 2–3 minutes.

## Checklist before ending recording

- [ ] Pipeline YAML generated for all three platforms.
- [ ] Policy exception example shown and explained.
- [ ] Effective rules generated from baseline + overrides + exceptions.
- [ ] Platform parity shown with examples of supported/partial/gap items.
- [ ] Release readiness dashboard shown; recommendation visible.
- [ ] Adoption metrics shown with realistic example numbers.
- [ ] Rule coverage matrix shown with complete/partial/gap rows.
- [ ] Differentiation matrix shown; comparison explained.
- [ ] All artifact names mentioned explicitly.
- [ ] Transitions tie together all three parts.
- [ ] Opening and closing narration emphasize scale and sustainability.

## Audio/video quality checklist

- [ ] Microphone audio is clear and consistent volume.
- [ ] No background noise or echo.
- [ ] Browser is at 100% zoom; tools are readable.
- [ ] Mouse movements are deliberate and easy to follow.
- [ ] Pauses on generated outputs are adequate (2–3 seconds).
- [ ] This is the longest part; ensure no long pauses or rambling.

## Production notes for this part

This part covers the most complex and abstract tools. Focus on:

- **Why**, not just **how**. Viewers need to understand the business problem each tool solves.
- **Use cases**. Give real-world examples that show the tool's value.
- **Integration**. Show how tools work together, not in isolation.
- **Scalability**. Emphasize that the toolkit is designed to grow from 1 project to 100.



