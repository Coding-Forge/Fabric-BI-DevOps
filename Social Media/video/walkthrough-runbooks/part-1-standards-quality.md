# Part 1 Runbook — Standards and Quality Foundation

## Goal

Show how the toolkit helps teams define BI quality standards without hand-editing JSON, tune individual rules for adoption flexibility, and create DAX test metadata that documents measure expectations before CI/CD enforcement.

This part is designed for:
- **BI leads and governance owners** who need to set baseline quality standards
- **Platform teams** who manage the quality rule infrastructure
- **Report creators and model owners** who want to understand what standards will apply to their work
- **Facilitators** delivering the accelerator to customers

## Recommended length

8–12 minutes (allows time for detailed explanations and use-case context).

## Tools covered

1. **Launchpad** — Navigation and workflow orientation
2. **Enterprise Standards Builder** — Define baseline quality policy
3. **Quality Rule Designer** — Tune rules for adoption phases
4. **DAX Test Builder** — Document measure-level business expectations

## Key theme

"Define it once, enforce it everywhere." This part shows how to turn governance policy decisions into automated checks that the CI/CD pipeline enforces on every pull request, without requiring report creators to understand or maintain JSON files.

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

Verify all tools load without errors.

## Opening narration

Say:

> Welcome to Part 1 of the Fabric BI DevOps Accelerator Toolkit walkthrough. In this video, we're going to show how to define quality standards for your Power BI and Fabric environment.

> If you've ever had this problem—you have 50 reports across your organization and you want them all to follow the same visual standards, the same measure naming conventions, and the same semantic model quality rules—but you don't want to ask every report author to hand-edit JSON files—this part is for you.

> We're going to define a baseline quality policy using a guided UI, tune rules for your adoption strategy, and document measure-level tests. By the end of this part, you'll have a set of governance rules that your CI/CD system can enforce automatically.

> Let's start.

**Timing:** 45 seconds. Sets context and value proposition.

## Step 1 — Launchpad

Open:

```text
http://localhost:8000/tools/index.html
```

Show:

- **Tool Catalog tab** — List of all 15 tools
- **Workflow tab** — Three sequences: standards → review → release
- **Artifacts tab** — What each tool generates
- **Audience paths tab** — Role-based navigation

Say:

> The launchpad is the front door to the entire toolkit. Instead of guessing which tool to use first, start here. You'll see how the tools fit together and which roles use which tools.

> Notice there are three workflows: standards and quality foundation, PBIP review and pull request readiness, and governance and adoption. We're starting with standards because everything else depends on clear quality expectations.

Demo actions:

1. Click **Tool Catalog** and read 3–4 tool descriptions aloud to show variety and depth.
2. Click **Workflow** and point out the Standards path in red. Explain that it flows left-to-right: Launchpad → Standards Builder → Rule Designer → DAX Test Builder.
3. Click **Artifacts** and highlight that each tool outputs Markdown, JSON, or YAML that can be committed to your repo.
4. Click **Audience paths** and show that BI leads and governance owners start in the standards workflow.

Say:

> The launchpad prevents overwhelm. You don't need to understand all 15 tools. You need to understand which tools matter for your role, and which ones can wait.

Transition:

> Now let's dive into defining standards.

**Timing:** 2–3 minutes.

## Step 2 — Enterprise Standards Builder

Open:

```text
http://localhost:8000/tools/enterprise-standards-builder/index.html
```

Say:

> The Enterprise Standards Builder is where the magic starts. Think of this as a policy wizard. You're going to make decisions about quality standards—which visual types are allowed, how tables and measures should be named, how DAX should be written—and the tool translates those decisions into automated rules.

> Why is this important? Because if you hand people a JSON file and ask them to edit it, adoption stops. But if you guide them through a UI, they understand the choices and feel ownership.

> The builder comes with three pre-configured profiles that represent different governance maturity levels.

Demo actions:

1. Point out the three profile buttons:
   - **Advisory Adoption** (permissive, designed for onboarding teams that are new to governance)
   - **Enterprise Standard** (balanced, the most common choice)
   - **Strict Enterprise Gate** (high control, for regulated environments)

2. Click **Enterprise Standard** (best middle-ground for demonstration).

3. Scroll through the report usability settings and explain 2–3 controls:
   - "Restrict old visual types": Why you'd want this (custom visuals can be harder to manage and maintain)
   - "Require naming convention for measures": Why it matters (makes them easier to find and understand)
   - "Restrict deprecated functions": Why it's important (DAX evolves, and some functions are less efficient)

4. Scroll through semantic model and DAX settings and point out key ones:
   - Measure and column naming standards
   - Relationship validation
   - Aggregate function restrictions
   - DAX complexity thresholds

5. Click **Generate Rules** or **Summary** and show the output.

6. Pause on the generated JSON/Markdown for 2–3 seconds so viewers can see what's being created.

Say:

> Notice what happened. You didn't write any rules yourself. You made policy decisions through a UI, and the tool generated the JSON rules that the CI/CD system will enforce.

Artifacts to mention and pause on:

```text
Rules-Report.json    → Report rules, their severities, and enabled flags
Rules-Dataset.json   → Semantic model and DAX rules
enterprise-policy-profile.json  → Your choices, stored for reuse or sharing
Policy-Summary.md    → Human-readable summary of what you've enabled
```

Say:

> These files get committed to your repo. Every time a report creator opens a pull request, the CI/CD system reads these rules and runs validation. If a report violates a rule, the PR check fails and the reporter gets feedback on what to fix.

> The key insight: you define governance once, and it applies everywhere, automatically.

Use-case example:

> For example, imagine your organization is moving 30 legacy reports to Power BI. You're worried about quality inconsistency. So you use this tool to define standards, commit the rules, and configure the pipeline. From that point forward, every report must pass these checks before it can be reviewed. That's enforcement at scale without asking reviewers to be lint tools.

Transition:

> Sometimes, though, you need flexibility. Maybe a rule is too strict during the early adoption phase. That's where the Rule Designer comes in.

**Timing:** 3–4 minutes.

## Step 3 — Quality Rule Designer

Open:

```text
http://localhost:8000/tools/rule-designer/index.html
```

Say:

> The Quality Rule Designer is for the platform team or advanced admins who need to tune individual rules. Maybe you're rolling out governance in phases, or maybe you need to author a custom rule that's specific to your business.

> The designer is safe—you're not editing JSON by hand. You're using a guided interface to change rule properties.

Demo actions:

1. Click **Use starter examples** to load pre-built rules.

2. Select one report rule (e.g., a visual type restriction or naming convention rule).

3. Show and explain:
   - **Rule ID** (internal identifier, helps with tracking)
   - **Name and description** (what does this rule enforce?)
   - **Severity** (error = blocking, warning = advisory, info = informational)
   - **Enabled flag** (can turn rules on/off without deleting them)
   - **Logic** (the actual rule expression)

4. If you have time, show how to change the severity of one rule (e.g., from error to warning). Explain why you'd do this:
   - "During adoption phase, we set rules to warning. Existing reports don't break. After 6 months, we promote warnings to errors."

5. Show a dataset rule (semantic model side) to demonstrate variety.

6. Show the generated Rules-Report.json and Rules-Dataset.json files.

Say:

> This flexibility is critical for real-world adoption. Governance doesn't have to be all-or-nothing. You can start permissive and tighten over time as teams get comfortable.

> You can also disable noisy rules. If a rule is generating too many false positives and slowing down development, you can disable it, give the team time to remediate, and then re-enable it later.

Artifacts to mention:

```text
Rules-Report.json
Rules-Dataset.json
```

Use-case example:

> Example: Your team is on-boarding 50 reports. The Enterprise Standards Builder sets 20 rules to error. But one rule about table naming is creating too much churn. So the platform team uses the Rule Designer to set that rule to warning for the dev branch. On main, it stays error. This gives teams time to adapt without being blocked.

Transition:

> So far we've defined structural quality: visual standards, naming conventions, model structure. The last piece is business logic quality. That's where DAX tests come in.

**Timing:** 2–3 minutes.

## Step 4 — DAX Test Builder

Open:

```text
http://localhost:8000/tools/dax-test-builder/index.html
```

Say:

> So far we've defined structural quality: how reports should look, how models should be organized. But structure alone doesn't guarantee correctness.

> Imagine you have a measure called Revenue that's used in 20 reports and dashboards. Someone changes the formula. The structure might still be correct—the measure is still there, the relationships are intact—but the calculation is wrong. Nobody would catch that at pull request time.

> That's where DAX tests come in. These are essentially unit tests for measures. You define what a measure should calculate and what the acceptable result is. If someone changes the measure and breaks the calculation, the test fails and catches it.

> The DAX Test Builder makes it easy to define these tests without writing DAX code yourself.

Demo actions:

1. Click **Use starter examples** to load pre-built measure tests.

2. Select one test case and show:
   - **Measure name** (which measure is being tested?)
   - **Owner** (who wrote this test? who should maintain it?)
   - **Scenario description** (e.g., "Total sales for Q4 2024 with no filters")
   - **Expected result** (e.g., "$1.2M")
   - **Acceptable tolerance** (e.g., ±0.1%; allows for rounding)
   - **Severity** (blocking = PR fails if test fails, warning = just warn, info = informational)
   - **Tags** (e.g., "revenue", "forecast", "critical"; helps organize tests)

3. Show the generated Markdown catalog (dax-test-catalog.md) so viewers see what the output looks like.

4. Explain the enablement flag: these tests start disabled because measure names, expected values, and filter contexts must be customized for each semantic model.

Say:

> The tests are disabled by default because you need to adapt them to your specific data. Once you've confirmed they're correct and they're passing, you enable them. From that point on, the CI/CD system runs them on every PR and reports pass/fail.

Artifacts to mention and pause on:

```text
dax-tests.json
dax-test-catalog.md
```

Use-case example:

> Example: Your Financial Controller says, 'I need to know if revenue is ever calculated incorrectly.' So your semantic model owner uses the DAX Test Builder to define tests for the key revenue measures—total revenue, revenue by region, revenue by product. They enable those tests in the CI/CD pipeline. Now, any change to revenue measures automatically runs the test and verifies correctness before the PR is approved.

## Closing narration

Say:

> At this point, we have a complete quality foundation:
>
> 1. **Enterprise standards** — Policy decisions about how reports and models should be structured and written.
> 2. **Tuned rules** — The ability to adjust severity and toggle rules based on adoption phase.
> 3. **Measure tests** — Automated checks for calculation correctness.
>
> All three get committed to your repo and consumed by CI/CD. Every PR validates against all of them automatically.

> In the next part of this walkthrough, we'll see how these standards work in practice when a report author prepares a pull request for review. We'll use PBIP diff tools, dependency analyzers, and PR summary generators to make review faster and more accurate.

> Thank you for watching Part 1. Let's move to Part 2.

**Timing:** 2–3 minutes.

## Checklist before ending recording

- [ ] Launchpad workflow shown; three sequences explained.
- [ ] Standards Builder profile shown; generated rules examined.
- [ ] Rule Designer starter example shown; severity and enablement explained.
- [ ] DAX Test Builder starter example shown; test metadata examined.
- [ ] All artifact names mentioned explicitly.
- [ ] At least one use-case example given for each major tool.
- [ ] Transitions between tools are smooth and natural.
- [ ] Opening and closing narration are recorded clearly.

## Audio/video quality checklist

- [ ] Microphone audio is clear and at consistent volume.
- [ ] No background noise or echo.
- [ ] Browser is at 100% zoom; tools are readable.
- [ ] No unrelated notifications or popups during recording.
- [ ] Mouse movements are deliberate and easy to follow.
- [ ] Pauses on generated outputs are 2–3 seconds (not too long, not too short).



