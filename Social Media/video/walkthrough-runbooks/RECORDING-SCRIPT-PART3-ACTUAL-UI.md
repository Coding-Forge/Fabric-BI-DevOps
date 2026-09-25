# Part 3 Recording Script — Actual UI Controls (Step-by-Step Demo Narration)

**This script is aligned with the ACTUAL Platform & Governance tools as seen on localhost:8000**

---

## OPENING NARRATION (90 seconds)

> Welcome to Part 3 of the Fabric BI DevOps Accelerator Toolkit.

> If you watched Part 1 and Part 2, you now know how individual teams define standards, prepare pull requests, and structure their code. Good progress.

> But here's where scale happens: The platform team's job is to make that process invisible and automatic. Governance that requires 30 manual steps won't scale. Governance that runs silently in CI/CD pipelines will.

> This part shows how the platform team builds the infrastructure that thousands of teams will depend on. We're going to see how to generate cloud-agnostic CI/CD pipelines that work on Azure DevOps, GitHub, and GitLab simultaneously. How to track exceptions and waivers. How to measure whether your governance is actually working. And how to evolve it over time based on real data.

> This is where governance moves from 'check you did the right thing' to 'the system does the right thing automatically.'

> Let's start with the foundation: How do we generate the CI/CD pipelines that enforce our standards?

---

## STEP 1 — Pipeline Config Generator (3-4 minutes)

### Opening actions
1. Navigate to http://localhost:8000/tools/pipeline-config-generator/index.html
2. Tool loads with empty state

### Narration

> The Pipeline Config Generator creates CI/CD pipeline templates that work across platforms. Instead of maintaining separate Azure DevOps, GitHub Actions, and GitLab CI configurations, you define the workflow once and generate all three platform versions automatically.

> This saves months of maintenance and keeps governance enforcement consistent.

### Demo Action 1: Click "Use starter config"

**Narration:**

> Let me load a starter configuration. You'll see what a complete platform-neutral pipeline looks like.

### Demo Action 2: Show Pipeline Structure section

**UI shows:**
- Pipeline name
- Trigger events (PR opened, PR updated, merge to main, manual)
- Validation stages (structure, quality, security)
- Deployment gates

**Narration:**

> The pipeline starts with structure. You name it, define when it triggers, and list the validation stages. Each stage runs on this platform. For example: Stage 1 validates PBIP structure, Stage 2 runs quality rules, Stage 3 runs DAX tests, Stage 4 checks for governance violations, then it gates to the merge.

### Demo Action 3: Scroll to show validation stage details

**Narration:**

> As I scroll, you see each validation stage. For each stage, you define: What script or tool runs? On what platform? Do you fail the PR if this stage fails?

### Demo Action 4: Show platform-specific configuration section

**Narration:**

> This section says: 'For Azure DevOps, use this runner. For GitHub, use this runner. For GitLab, use this runner.' The same validation runs on all platforms because we're using standard Python and PowerShell scripts that work everywhere.

### Demo Action 5: Select "Azure DevOps" from the Platform dropdown and click "Generate pipeline"

**Narration:**

> Now I select Azure DevOps from the Platform dropdown and click Generate pipeline. The tool creates an azure-pipelines.yml file ready to drop into an Azure DevOps repo.

**Show the generated YAML briefly.**

> This is real pipeline code. You can commit it immediately.

### Demo Action 6: Select "GitHub Actions" from the Platform dropdown and click "Generate pipeline"

**Narration:**

> Same config, GitHub platform. I select GitHub Actions from the dropdown and click Generate pipeline again, and it creates a .github/workflows/ci.yml file.

**Show the generated YAML briefly.**

> Same validation stages, GitHub Actions syntax.

### Demo Action 7: Select "GitLab CI" from the Platform dropdown and click "Generate pipeline"

**Narration:**

> And GitLab. I select GitLab CI from the dropdown and click Generate pipeline, and the tool generates GitLab CI syntax.

**Show the generated YAML briefly.**

> One workflow definition, three platform implementations. No drift, no inconsistency.

### Summary narration

> The key insight: You don't write three separate pipelines. You define the workflow once and generate all three. The platform team maintains one source of truth for validation enforcement.

### Transition

> Now, teams will try to bypass the pipeline. Maybe they say 'Our situation is special—we need an exception to the DAX test requirement.' How do you track that?

---

## STEP 2 — Policy Exception Register (3-4 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/policy-exception-register/index.html
3. Tool loads with empty state

### Narration

> The Policy Exception Register is where you track governance waivers. When a team needs an exception—'We need to ship today and we haven't fixed this quality rule yet'—you don't hide it. You document it: What rule? Why? Who approved? When does it expire?

> This creates visibility. You can see if 80% of exceptions are for the same rule. That tells you the rule might be wrong.

### Demo Action 1: Click "Use starter register"

**Narration:**

> Let me load a starter register with realistic exceptions.

### Demo Action 2: Show Register Health panel

**UI shows:**
- Active exceptions count
- Expiring soon count (within 7 days)
- Expired count

**Narration:**

> The Register Health shows: 12 active exceptions, 3 expiring soon (we should follow up with those teams), 0 already expired.

### Demo Action 3: Show exception entries

**Narration:**

> Each exception shows: What rule? Which team? Which solution? Why? Who approved? When does it expire?

### Demo Action 4: Click on an exception to show details

**Narration:**

> When you click an exception, you see the full context. For example: 'DAX test requirement waived for Risk Analytics Dashboard. Reason: Legacy reporting system, migrating to Fabric. Approved by Carol. Expires Sept 30. Escalation contact: Alice.'

### Demo Action 5: Show expiration tracking

**Narration:**

> You can filter exceptions by status: Active, Expiring Soon, Expired. This helps platform teams know: Which exceptions need follow-up? Which teams are past their waiver date and need to fix the underlying issue?

### Demo Action 6: Click "Download register report"

**Narration:**

> Export the register and share it with governance committees. This creates transparency: 'Here's every policy exception in our organization. Here's why. Here's when it expires. Here's who approved it.'

### Summary narration

> Exception tracking prevents two problems: First, you don't have invisible workarounds. Second, you catch when the same rule is frequently waived—that tells you the rule needs adjustment.

### Transition

> Now that you're tracking exceptions, how do you know if your governance is actually working? You need to measure it.

---

## STEP 3 — Effective Rules Generator (2-3 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/effective-rules-generator/index.html
3. Tool loads with empty state

### Narration

> The Effective Rules Generator tells you what rules are actually in effect across your organization. It merges: Your base rules, your exceptions, your overrides, your local customizations. It answers: What rules is a specific team actually following?

> This is critical because teams customize rules. They layer overrides. You need to know what the 'effective' ruleset is after all the customizations.

### Demo Action 1: Click "Use starter rules"

**Narration:**

> Let me load a starter ruleset that shows how rules are merged.

### Demo Action 2: Show Effective Rule Health

**UI shows:**
- Rules count
- Overrides count
- Exception count
- Coverage percentage

**Narration:**

> You have 47 rules defined. 5 of them have team-specific overrides. 8 of them have active exceptions. That means 34 rules are applied consistently across the organization.

### Demo Action 3: Click "Merge profiles"

**Narration:**

> The Merge profiles button combines multiple rule sources: your enterprise baseline, team-specific adjustments, and temporary overrides. The result is: Here's exactly what rules a specific team must follow, including exceptions and overrides.

### Demo Action 4: Show the merged ruleset

**Narration:**

> After merging, you see the effective ruleset: 47 rules, with these 5 overridden for this team, these 8 waived, these 34 enforced as-is.

### Demo Action 5: Click "Download effective rules"

**Narration:**

> Export the effective ruleset and feed it to your CI/CD pipeline. The pipeline knows: These are the rules to enforce for this team, including their exceptions.

### Summary narration

> Effective rules keep you from enforcing something that's already waived. The pipeline checks against the actual rules that apply, not the base rules.

### Transition

> You've defined rules, tracked exceptions, and calculated effective rules. Now you need to prove that all three platforms—Azure DevOps, GitHub, GitLab—can enforce the same governance.

---

## STEP 4 — CI/CD Platform Parity Matrix (2-3 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/platform-parity-matrix/index.html
3. Tool loads with empty state

### Narration

> The CI/CD Platform Parity Matrix proves that your governance works the same way across all three CI/CD platforms. It tracks five key capabilities: validation, quality, deployment, governance, and scaling. For each capability, it shows: Does Azure DevOps support this? GitHub? GitLab?

> This is your proof that you're not creating a single-platform solution.

### Demo Action 1: Click "Use starter matrix"

**Narration:**

> Let me load the starter matrix.

### Demo Action 2: Show Parity Health

**UI shows (simplified):**
- 5 Capabilities listed
- Support status for each: supported/partial/planned/gap

**Narration:**

> You have 5 capabilities to track. The matrix shows: 4 have full parity across all platforms. 1 has planned parity on GitHub and GitLab but supported on Azure DevOps today.

### Demo Action 3: Click on a capability to show details

**Narration:**

> Let me click on 'Artifact publication'. It shows: Azure DevOps—supported, GitHub—supported, GitLab—supported. Implementation details: Artifact storage differs by platform but all can store and retrieve artifacts.

### Demo Action 4: Show capability categories

**Narration:**

> Capabilities are grouped by category: Validation, Quality, Release, Scale. This helps leadership understand: 'We can validate on all platforms today. We can deploy on all platforms today. Reusable templates are coming to GitHub and GitLab.'

### Demo Action 5: Click "Download parity report"

**Narration:**

> Export this and include it in your multi-platform business case. It proves: You're not locked into Azure DevOps. Your governance enforcement works identically on any cloud CI/CD platform.

### Summary narration

> This matrix is credibility. It says: 'We tested this on all platforms. Here's what works the same. Here's what's coming soon. Here's what might differ slightly, and here's why.'

### Transition

> Platforms matter for deployment. Next, we need to show that solutions are actually ready for release.

---

## STEP 5 — Release Readiness Dashboard (2-3 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/release-readiness-dashboard/index.html
3. Tool loads with empty state

### Narration

> The Release Readiness Dashboard tracks whether a solution is actually ready to deploy. It combines signals: Are all quality rules passed? Is the readiness score above threshold? Are there blocking exceptions? Are all approvals signed off?

> This dashboard becomes your release gate. Before you deploy to production, you check this dashboard.

### Demo Action 1: Click "Use sample dashboard"

**Narration:**

> Let me load a sample that shows a solution approaching release.

### Demo Action 2: Show Readiness Score section

**UI shows:**
- Overall readiness percentage
- Days to go until target release
- Blocking issues count
- Ready to release? Yes/No

**Narration:**

> The dashboard shows: Cost Management Reports is 92% ready. Target release is 3 days away. 0 blocking issues. Status: Ready to release.

### Demo Action 3: Show release gates

**Narration:**

> Scroll down to see the release gates. This solution must have: Quality rules passed (✓), readiness score above 80 (✓), no blocking exceptions (✓), approvals signed off (✓). All four gates are green.

### Demo Action 4: Show solution timeline

**Narration:**

> The timeline shows: When was the solution created? When was it last updated? How long has it been in pilot? When do we release to production?

### Demo Action 5: Click "Approve for release"

**Narration:**

> When all gates are green, the release manager clicks Approve for release. This updates the deployment manifest and triggers the production pipeline.

### Demo Action 6: Click "Download release summary"

**Narration:**

> Export the release summary for your release notes. 'Cost Management Reports. Version 3.2. Includes 8 new measures, 5 policy updates, 0 breaking changes. All quality gates passed. Released by Carol on Sept 15.'

### Summary narration

> The Release Readiness Dashboard is your objective release gate. You're not guessing if it's ready. The dashboard shows all four gates in one place.

### Transition

> You've tracked readiness, but how do you know if releases are actually successful? You need to measure adoption.

---

## STEP 6 — Adoption Metrics Dashboard (2-3 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/adoption-metrics-dashboard/index.html
3. Tool loads with empty state

### Narration

> The Adoption Metrics Dashboard measures whether your toolkit and governance are actually working. It tracks: How many projects are using the toolkit? Are they in pilot or production? What's their readiness score? How long does onboarding take? Are exceptions aging or expiring?

> This is your program health dashboard.

### Demo Action 1: Click "New project"

**Narration:**

> When a team onboards to the toolkit, you create a new project record. You capture: Project name, domain, platform (Azure DevOps, GitHub, or GitLab), status (candidate, pilot, active, scaled), owner, toolkit profile (minimal, standard, workshop, custom).

### Demo Action 2: Fill out sample project

**Narration:**

> Let's add Cost Management. Domain: FinOps. Platform: Azure DevOps. Status: Active (in production). Owner: Finance Team. Toolkit profile: Standard.

### Demo Action 3: Show metrics for that project

**Narration:**

> Once you save, the dashboard shows metrics for this project: Onboarded Sept 15. Time to onboard: 8 days. Current readiness: 87/100. Active exceptions: 2. Last release: Sept 28. This team is healthy.

### Demo Action 4: Show adoption summary

**Narration:**

> Scroll to the top of the dashboard. It shows: 47 total projects. 12 are in active/production. Average readiness: 82. Average onboarding: 11 days. This tells you: We've onboarded 47 teams. 12 are in full production. Most are ready.

### Demo Action 5: Click "Download adoption report"

**Narration:**

> Export this as CSV or Markdown for your stakeholder updates. 'This quarter: 8 new project onboards. All achieved production within 10 days. Average readiness: 82. We're tracking exceptions aging—3 expire next week.'

### Summary narration

> This dashboard answers executive questions: Is the toolkit being adopted? Are teams successful? Are we reducing time-to-production? Is governance working?

### Transition

> You've measured adoption. Now you need to show how comprehensive your rule coverage is.

---

## STEP 7 — Rule Coverage Matrix (2-3 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/rule-coverage-matrix/index.html
3. Tool loads with empty state

### Narration

> The Rule Coverage Matrix shows which rules are actually being enforced across your organization. It tracks: How many data governance rules? How many quality rules? How many deployment rules? Which rules are enforced on all platforms? Which are still missing?

> This is a maturity assessment. Rules that exist in documentation but aren't enforced don't matter.

### Demo Action 1: Click "Use starter coverage"

**Narration:**

> Let me load a starter rule coverage matrix.

### Demo Action 2: Show Rule Coverage Health

**UI shows:**
- Total rules defined
- Rules enforced (automated)
- Rules manual (require human verification)
- Coverage percentage

**Narration:**

> You have 62 total rules defined. 54 are automated (they run in your CI/CD pipeline). 8 are manual (you check them in code review). Your automation coverage is 87%.

### Demo Action 3: Show rule categories

**Narration:**

> The rules are grouped by category: Data governance (16 rules, 14 automated), quality assurance (28 rules, 26 automated), deployment automation (18 rules, 14 automated). You can see where your automation is strongest and where you need more work.

### Demo Action 4: Click on a category to show details

**Narration:**

> Click on Data Governance. You see each rule: 'Require naming convention for measures'—automated, enforced. 'Require semantic model owner documentation'—manual, enforced. 'Restrict deprecated DAX functions'—automated, enforced. This shows you exactly which rules are covered.

### Demo Action 5: Click "Download coverage report"

**Narration:**

> Export the coverage matrix. Use it to identify gaps. 'We have rules for 87% of quality requirements, but we're not automating them yet. Here's a roadmap to automate the remaining 13%.'

### Summary narration

> This matrix shows your governance maturity. Not coverage—the percentage of rules actually enforced, not just documented.

### Transition

> Finally, how do you differentiate your platform from competitors? That's where competitive positioning comes in.

---

## STEP 8 — Competitive Differentiation Matrix (2-3 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/competitive-differentiation-matrix/index.html
3. Tool loads with empty state

### Narration

> The Competitive Differentiation Matrix is where you position your Fabric BI DevOps toolkit against other platforms and solutions. What capabilities do you have that competitors don't? What's coming soon? What are gaps?

> This matrix is not for marketing alone. It helps you prioritize roadmap: 'We're behind on this capability—let's close the gap.'

### Demo Action 1: Click "Use starter matrix"

**Narration:**

> Let me load the starter matrix comparing Fabric BI DevOps against competing approaches.

### Demo Action 2: Show Feature categories

**UI shows:**
- Capability categories (Data governance, CI/CD automation, quality, scaling, etc.)
- Your platform: Supported/partial/planned/gap
- Competitors: Supported/partial/planned/gap

**Narration:**

> You see capability categories. For each, the matrix shows: Fabric BI DevOps status, Competitor A status, Competitor B status. This gives you a quick look at your strengths and gaps.

### Demo Action 3: Click on a capability where you lead

**Narration:**

> Let me click on 'Multi-cloud CI/CD parity'. Fabric BI DevOps: Supported on all three platforms. Competitor A: Azure DevOps only. Competitor B: Only proprietary platform. This is a clear differentiator.

### Demo Action 4: Click on a capability where you're behind

**Narration:**

> Now let me click on 'Real-time data governance'. Fabric BI DevOps: Planned for next quarter. Competitor A: Supported. Competitor B: Supported. This is a gap to close.

### Demo Action 5: Show roadmap section

**Narration:**

> The bottom section shows roadmap: What are you committing to in the next quarter? What's beyond that? This helps sales teams know what's coming and helps product teams focus priorities.

### Demo Action 6: Click "Download competitive summary"

**Narration:**

> Export this for your sales team, stakeholders, and your own product roadmap. It's clarity on where you stand and where you're going.

### Summary narration

> This matrix keeps you honest. You can't hide gaps. You can't overstate capabilities. You have a clear-eyed view of your competitive position.

### Use-case example

> Example: You're in a proposal against a competitor. They claim full AI governance automation. Your matrix shows: They have a generic framework, you have Fabric-specific enforcement. Their 'full automation' is 60% automated. Yours is 87% automated. The matrix helps you explain why.

### Transition

> That's the last tool. Let's recap what you've built.

---

## CLOSING NARRATION (2 minutes)

> You've now seen the complete Fabric BI DevOps Accelerator toolkit. 16 tools across three workflows.

> Part 1 was standards. Part 2 was review. Part 3 was scale.

> Part 1 tools—Enterprise Standards Builder, Rule Designer, DAX Test Builder, Quality Dashboard—these define what governance actually means. What are we checking for? What does quality look like?

> Part 2 tools—Deployment Manifest, Readiness Scanner, Diff Viewer, Impact Analyzer, PR Summary—these help teams move fast. Instead of hours of back-and-forth, code review becomes clear and quick.

> Part 3 tools—Pipeline Config, Exception Register, Effective Rules, Platform Parity, Release Readiness, Adoption Metrics, Rule Coverage, Competitive Differentiation—these make it scale. Governance that works for one team needs to work for 100 teams. These tools make that possible.

> But here's the real insight: None of these tools enforce anything by themselves. The enforcement happens in your CI/CD pipeline, in your code review process, in your release gates. The tools just make the process visible and fast.

> That visibility and speed compound. After six months, you realize: We're releasing 40% faster. We're catching issues earlier. We're onboarding teams in 10 days instead of 30. We're moving teams from 'we can't deploy safely' to 'we deploy every day.'

> That's the promise of integrated governance automation.

> Thank you for walking through the toolkit with us. We hope it sparks ideas for how you govern your Fabric BI platform.

---

## TIMING CHECKLIST

- Opening narration: 1.5 minutes
- Step 1 (Pipeline Config): 3-4 minutes
- Step 2 (Exception Register): 3-4 minutes
- Step 3 (Effective Rules): 2-3 minutes
- Step 4 (Platform Parity): 2-3 minutes
- Step 5 (Release Readiness): 2-3 minutes
- Step 6 (Adoption Metrics): 2-3 minutes
- Step 7 (Rule Coverage): 2-3 minutes
- Step 8 (Competitive Differentiation): 2-3 minutes
- Closing narration: 2 minutes

**Total: 22-28 minutes** (Allows 2-3 min editing overhead if needed, or can cut to 18-22 without closing examples)

---

## PRODUCTION NOTES

- **Zoom level:** 100% for clarity
- **Browser:** Edge or Chrome
- **Resolution:** 1920x1080 (1080p)
- **Pause timing:** 2–3 seconds when showing generated Markdown or comparison details
- **Narration pacing:** Slightly slower than normal (this part has more concepts to absorb)
- **Screen actions:** Deliberate and obvious (don't rush scrolling or clicking)
- **File loading:** Make sure sample data loads before demo

---

## KEY POINTS TO EMPHASIZE

1. **Pipeline Config = Multi-platform parity**: "One workflow, three platform implementations."
2. **Exception Register = Transparent waivers**: "We don't hide exceptions—we track them."
3. **Effective Rules = Reality check**: "These are the rules actually in effect, including exceptions."
4. **Platform Parity = No vendor lock-in**: "Governance works on any CI/CD platform."
5. **Release Readiness = Objective gate**: "All four gates green? Release to production."
6. **Adoption Metrics = Program health**: "Are teams succeeding? How fast are we onboarding?"
7. **Rule Coverage = Maturity assessment**: "87% automated coverage—where do we need to improve?"
8. **Competitive Differentiation = Strategic clarity**: "Here's our advantage. Here's our gap. Here's our roadmap."

---

## WHAT NOT TO SAY

❌ "All three platforms are identical" (they're different, we handle that)
❌ "No exceptions allowed" (exceptions are tracked, not forbidden)
❌ "Rules are static" (rules merge and override based on context)
❌ "Readiness score is the only gate" (it's one of four gates)
❌ "Adoption rate is the success metric" (it's one of many metrics)
❌ "We automate 100% of governance" (87% is realistic and excellent)
❌ "We dominate the competitor" (we lead on some capabilities, they lead on others)

---

## WHAT TO SAY

✅ "Three platforms, one governance model"
✅ "Exceptions are tracked and visible"
✅ "Rules change based on team context and waivers"
✅ "Release requires all four gates to be green"
✅ "Adoption rate, readiness, onboarding speed, and exception aging tell the full story"
✅ "87% automated governance is enterprise-grade"
✅ "We lead here, they lead there, and here's our roadmap for the gaps"
