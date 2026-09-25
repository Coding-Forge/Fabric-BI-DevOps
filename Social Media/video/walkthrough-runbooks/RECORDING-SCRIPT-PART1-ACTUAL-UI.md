# Part 1 Recording Script — Actual UI Controls (Step-by-Step Demo Narration)

**This script is aligned with the ACTUAL Enterprise Standards Builder UI as seen on localhost:8000**

Use this script when recording to ensure your narration matches what viewers see on screen.

---

## STEP 1 — Launchpad (2-3 minutes)

### Opening actions
1. Open http://localhost:8000/tools/index.html in browser
2. Maximize window to 1920x1080
3. Browser zoom at 100%

### Narration

> Welcome to Part 1 of the Fabric BI DevOps Accelerator Toolkit walkthrough. In this video, we're going to show how to define quality standards for your Power BI and Fabric environment.

> If you've ever had this problem—you have 50 reports across your organization and you want them all to follow the same visual standards, the same measure naming conventions, and the same semantic model quality rules—but you don't want to ask every report author to hand-edit JSON files—this part is for you.

> We're going to define a baseline quality policy using a guided UI, tune rules for your adoption strategy, and document measure-level tests. By the end of this part, you'll have a set of governance rules that your CI/CD system can enforce automatically.

> Let's start. You're looking at the Fabric BI DevOps Accelerator Launchpad. This is the front door to all 16 tools.

### Demo Action 1: Click "Tool Catalog"

**UI shows:** Cards for each tool grouped into 3 sections
- Build and tune standards (top section)
- Review and release (middle)
- Governance and adoption (bottom)

**Narration:**

> Here you see the Tool Catalog. All 16 tools are organized into three business workflows. We're starting with the top section: Build and tune standards. You can see the Enterprise Standards Builder, the Quality Rule Designer, the DAX Test Builder, and the Effective Rules Generator. These tools work together to turn governance policy into CI/CD rules.

> If I scroll down, I see the Review and Release section with tools for authors and reviewers: Deployment Manifest Builder, PBIP Project Readiness Scanner, Diff Viewer, Dependency Impact Analyzer, and PR Quality Summary Generator. These tools compress pull request review from 30 minutes down to 5 minutes.

> And at the bottom is Governance and Adoption: Platform Parity Matrix, Release Readiness Dashboard, Adoption Metrics Dashboard, Rule Coverage Matrix, and Competitive Differentiation Matrix. These tools help platform teams scale what works.

### Demo Action 2: Click "Workflow"

**UI shows:** A numbered 16-step sequence

**Narration:**

> Now click on the Workflow tab. This shows the complete 16-step recommended sequence. Each step builds on the previous one. In Part 1, we're focusing on steps 1 through 3: Define standards, tune rules, and add DAX tests. This is the foundation. Part 2 covers steps 4 through 6: deployment, readiness scanning, and change analysis. Part 3 covers steps 7 through 16: pipeline generation, exception tracking, metrics, and adoption measurement. Everything flows left to right.

### Demo Action 3: Click "Artifacts"

**UI shows:** List of file types (JSON, Markdown, YAML)

**Narration:**

> The Artifacts tab shows what each tool produces. JSON files for rules and configuration, Markdown reports for governance documentation, and YAML for CI/CD pipelines. These files get committed to your repository and become the enforcement mechanism.

### Demo Action 4: Click "Audience paths"

**UI shows:** Role-based navigation

**Narration:**

> The Audience Paths tab shows which tools matter for which roles. If you're a BI lead, you'll start with standards definition. If you're a report author, you'll focus on the readiness scanner before opening a pull request. If you're on the platform team, you'll use the pipeline generator and adoption metrics. This organization prevents overwhelm.

### Transition narration

> The launchpad prevents confusion. You don't need to understand all 16 tools at once. You need to understand which tools matter for your role, and which ones can wait.

> Now let's dive into the Enterprise Standards Builder. This is where the magic starts.

---

## STEP 2 — Enterprise Standards Builder (3-4 minutes)

### Opening actions
1. Click "Open Enterprise Standards Builder" button (or navigate to http://localhost:8000/tools/enterprise-standards-builder/index.html)
2. Wait for tool to load
3. You should see the left sidebar with profile selection

### Narration

> The Enterprise Standards Builder is where the magic starts. Think of this as a policy wizard. You're going to make decisions about quality standards—which visual types are allowed, how tables and measures should be named, how DAX should be written—and the tool translates those decisions into automated rules.

> Why is this important? Because if you hand people a JSON file and ask them to edit it, adoption stops. But if you guide them through a UI, they understand the choices and feel ownership.

> Look at the left sidebar. At the very top is a dropdown labeled "Profile". The builder comes with pre-configured profiles that represent different governance maturity levels, plus a custom option if you need to build your own.

### Demo Action 1: Point out profile dropdown

**UI shows:** Dropdown with 4 options
- Advisory adoption
- Enterprise standard (currently selected)
- Strict enterprise gate
- Custom

**Narration:**

> Here are your options. Advisory adoption is permissive—designed for onboarding teams that are new to governance. You can be flexible early and tighten later. Enterprise standard is balanced—this is the most common choice and the one we'll use today. Strict enterprise gate is for high-control environments like financial institutions or regulated industries. And custom lets you mix and match rules.

> Let's make sure Enterprise standard is selected. (Verify it's selected in dropdown.)

### Demo Action 2: Show policy profile fields

**UI shows (as you scroll down in left sidebar):**
- "Policy set name" textbox (shows: "Enterprise Power BI Standard")
- "Owner / approver" textbox (shows: "BI Governance Team")
- "Notes for reviewers" textbox

**Narration:**

> Below the profile dropdown, you see three fields. Policy set name (this one says "Enterprise Power BI Standard"), Owner or approver (who's accountable for these rules?), and Notes for reviewers (why did you choose these settings?). These fields document your governance decisions. This is important—six months from now, someone will ask why you enforced a particular rule, and you'll have context right here.

### Demo Action 3: Show rule counts

**UI shows (in the "Policy profile" section):**
- "7" Report rules
- "11" Dataset rules
- "16" Enabled policies
- "0" Preserved custom

**Narration:**

> And look at these counts. 7 report rules, 11 dataset rules, 16 enabled policies. This profile generates 18 total rules—they're not handcrafted, they're generated from your policy choices.

### Demo Action 4: Click "Policy controls" tab (should already be visible)

**UI shows:** List of checkboxes for each control, grouped by category

**Narration:**

> Now let's look at the actual policy controls. These are the decisions that drive the rules. Notice they're organized by category: Report usability, semantic model integrity, DAX best practices, and so on.

### Demo Action 5: Scroll and explain 3-4 key controls

**When you scroll, you'll see checkboxes for controls like:**

**First control:** "Keep reports concise and navigable" (checkbox checked)
- Field: "Maximum report pages" (shows "6")
- Description: "Limits report page count so users can find content quickly"

**Narration:**

> This first control, Keep reports concise and navigable, limits report pages. The Enterprise Standard profile sets a maximum of 6 pages. Why? Because if your report has 30 pages, users will get lost. A shorter report with clear navigation is better. This isn't arbitrary—it's based on usability research.

**Scroll to next control:** "Limit visible visuals per page" (checkbox checked)

**Narration:**

> This one limits visible visuals per page. Too many charts on one screen overwhelms users and degrades performance. The Enterprise Standard limits this based on common practice.

**Scroll to another control:** "Prevent vertical page scrolling" (checkbox checked)

**Narration:**

> Here's another one: Prevent vertical page scrolling. This enforces a consistent canvas height. No hidden content at the bottom of the page. Everything that's important fits on screen.

**Scroll to show more controls:**

**Narration:**

> As I scroll, you can see more controls: Require chart axis titles (so every chart is self-documenting), Use enterprise theme colors (enforces brand consistency), Require meaningful page names (helps users navigate quickly), Remove auto-date tables (prevents duplicate date hierarchies in DAX), and Discourage report-level local measures (pushes developers toward shared semantic model measures).

### Demo Action 6: Click "Review summary" tab

**UI shows:** A summary of the selected profile

**Narration:**

> Now let's look at what this policy profile produces. Click on the "Review summary" tab. This shows a human-readable summary of the Enterprise Standard profile: which rules are enabled, what the thresholds are, and the rationale for each.

### Demo Action 7: Click "Report JSON" tab

**UI shows:** JSON code block

**Narration:**

> Click on "Report JSON". This is what the tool generated from your policy decisions. It's PBI Inspector BPA JSON format—the CI/CD system reads this file and validates reports against these rules. Notice you didn't write this JSON by hand. You made policy decisions through a UI, and the tool generated the technical artifact.

### Demo Action 8: Click "Download summary" button

**UI shows:** Button in the header

**Narration:**

> Now let's download the artifacts. Click the "Download summary" button at the top. This gives you a Markdown file documenting your governance policy. This file goes into your repository so everyone can see what rules are being enforced.

**Timing: Pause 2 seconds while file downloads**

> You'll get a file called Policy-Summary.md. Save it to your repo.

### Demo Action 9: Click "Download report rules" button

**UI shows:** Button in the header

**Narration:**

> Now click "Download report rules". This generates the Rules-Report.json file. This is the PBI Inspector rules file that the CI/CD system will use to validate reports.

**Timing: Pause 2 seconds**

> Notice what happened. You didn't write any rules yourself. You made policy decisions through a UI, and the tool automatically generated the JSON rules that the CI/CD system will enforce. You get three downloads: report rules, dataset rules, and a policy profile that documents your choices.

### Demo Action 10: Click "Download dataset rules" button

**UI shows:** Button in the header

**Narration:**

> Click "Download dataset rules". This generates the Rules-Dataset.json file. This is the Tabular Editor BPA rules file that the CI/CD system uses to validate the semantic model.

### Summary narration

> Here's the key insight: you define governance once, and it applies everywhere, automatically. You make policy decisions through a UI. The tool generates JSON rules that your CI/CD system enforces on every pull request. If a report violates a rule, the PR check fails and the reporter gets feedback on what to fix.

> For example, imagine your organization is moving 30 legacy reports to Power BI. You're worried about quality inconsistency. So you use this tool to define standards, commit the rules to your repo, and configure the pipeline. From that point forward, every report must pass these checks before it can be reviewed. That's enforcement at scale without asking reviewers to be lint tools.

### Transition narration

> Sometimes, though, you need flexibility. Maybe a rule is too strict during the early adoption phase. Maybe you need a rule that's specific to your business. That's where the Quality Rule Designer comes in.

---

## STEP 3 — Quality Rule Designer (2-3 minutes)

### Opening actions
1. Click "Back to launchpad" button
2. Navigate to http://localhost:8000/tools/rule-designer/index.html
3. Tool loads with empty state

### Narration

> The Quality Rule Designer is for the platform team or advanced admins who need to tune individual rules. Maybe you're rolling out governance in phases, or maybe you need to author a custom rule that's specific to your business.

> The designer is safe—you're not editing JSON by hand. You're using a guided interface to change rule properties.

### Demo Action 1: Click "Use starter examples"

**UI shows:** Pre-built rules load into the gallery

**Narration:**

> Click "Use starter examples". Now you see a gallery of pre-built rules. These are templates you can customize. Each rule has an ID, a name, a description, and settings for what it checks.

### Demo Action 2: Select a rule

**Narration:**

> Let me click on one of these rules to show how you edit it. The rule builder on the right shows all the properties: the rule file type (report or dataset), the template it's based on, the ID, name, description, severity, and what part of the file it checks.

### Demo Action 3: Show how to edit a threshold

**Narration:**

> For example, this rule limits pages per report. The max is set to 6. If you want to be more permissive during early adoption, you could change this to 10 or 15. Or if you want to be stricter, set it to 4. All without editing JSON.

### Summary narration

> This is the beauty of the Rule Designer. If the pre-built rules don't fit your needs perfectly, you tune them here. You can change thresholds, create custom rules, and even import your own rule definitions. But it's all done through a guided UI, not by hand-editing JSON.

---

## STEP 4 — DAX Test Builder (2-3 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/dax-test-builder/index.html
3. Tool loads with empty state

### Narration

> The DAX Test Builder is where you document measure-level business expectations. Instead of guessing whether a DAX measure is correct, you define what "correct" means—then the CI/CD system runs these tests on every deployment.

### Demo Action 1: Click "Use starter examples"

**UI shows:** Sample tests load

**Narration:**

> Click "Use starter examples" to load some sample tests. Each test has an ID, a measure name, a business scenario (why does this test matter?), and an assertion (what's the expected result?).

### Demo Action 2: Show test properties

**Narration:**

> Look at the test builder on the right. You define the measure being tested, the table it lives in, the owner, and the business scenario. Then you set an assertion—equals, greater than, between, etc.—and an expected value. You can also add filter context (test this measure with a specific calendar filter, for example).

### Demo Action 3: Show "Download dax-tests.json"

**Narration:**

> Click "Download test catalog" to export your tests as JSON. This JSON file goes into your repo and becomes part of your CI/CD validation. When someone commits a change to a measure, the pipeline runs these DAX tests and reports whether the measure still produces the expected values.

### Summary narration

> This is the safety net. DAX is easy to write incorrectly. By documenting business expectations upfront, you catch breaking changes before they reach production.

---

## CLOSING NARRATION (1 minute)

### Narration

> You've just seen Part 1 of the Fabric BI DevOps Accelerator Toolkit: Standards and Quality Foundation. You learned how to:

> 1. Define enterprise governance policy using the Enterprise Standards Builder
> 2. Tune individual rules using the Quality Rule Designer
> 3. Document measure expectations using the DAX Test Builder

> These three tools generate four governance artifacts: Rules-Report.json, Rules-Dataset.json, dax-tests.json, and enterprise-policy-profile.json. These files are committed to your repo and become the enforcement mechanism for your entire organization.

> In Part 2, we'll show how authors and reviewers use these rules. We'll demonstrate how to scan a project before opening a pull request, how to understand changes without reading JSON, and how to move PR review from 30 minutes of confusion to 5 minutes of clarity.

> Thanks for watching. To get started with the toolkit, go to [GitHub URL or local path].

---

## TIMING CHECKLIST

- Step 1 (Launchpad): 2–3 minutes ✓
- Step 2 (Standards Builder): 3–4 minutes ✓
- Step 3 (Rule Designer): 2–3 minutes ✓
- Step 4 (DAX Test Builder): 2–3 minutes ✓
- Closing: 1 minute ✓

**Total: 10–14 minutes** (Allows 1–2 min editing overhead)

---

## PRODUCTION NOTES

- **Zoom level:** 100% for clarity
- **Browser:** Edge or Chrome
- **Resolution:** 1920x1080 (1080p)
- **Pause timing:** 2–3 seconds when showing generated JSON or downloaded artifacts
- **Narration pacing:** Slightly slower than normal speech (reviewers will rewatch)
- **Screen actions:** Deliberate and obvious (don't rush mouse movements)
- **Clicking:** Audibly click buttons so the viewer hears action confirmation

---

## WHAT NOT TO SAY

❌ "Restrict old visual types" (this control doesn't exist)
❌ "Require naming convention for measures" (this isn't what the tool does)
❌ "Restrict deprecated functions" (not a control in the UI)
❌ "Click the three profile buttons" (it's a dropdown, not buttons)
❌ "Click Generate Rules button" (it's "Download" buttons)
❌ "There are 15 tools" (it's 16)

---

## WHAT TO SAY

✅ "Keep reports concise and navigable" (actual control name)
✅ "Limit visible visuals per page" (actual control name)
✅ "Select from the profile dropdown" (correct UI element)
✅ "Click Download report rules" (actual button)
✅ "All 16 tools in the toolkit" (correct count)
