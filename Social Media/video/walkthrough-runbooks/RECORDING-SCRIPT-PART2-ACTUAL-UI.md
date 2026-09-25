# Part 2 Recording Script — Actual UI Controls (Step-by-Step Demo Narration)

**This script is aligned with the ACTUAL PBIP Review tools as seen on localhost:8000**

---

## OPENING NARRATION (60 seconds)

> Welcome to Part 2 of the Fabric BI DevOps Accelerator Toolkit walkthrough.

> If you just watched Part 1, you now understand how to define governance standards and quality rules. Good. Those rules are the safety net.

> But here's the reality: rules and automation only get you halfway. Real people still need to review code. And code review is slow when reviewers have to decode raw JSON to understand what changed.

> This part is about moving from 'code review is tedious' to 'code review is actually fast because I have the context I need.'

> We're going to show how report authors prepare pull requests using readiness scanners, how reviewers understand changes without reading JSON, and how you document what's being deployed and why.

> By the end, you'll see a pull request workflow that typically takes 30 minutes of back-and-forth compress down to 5 minutes of clear assessment.

> Let's start.

---

## STEP 1 — Deployment Manifest Builder (3-4 minutes)

### Opening actions
1. Navigate to http://localhost:8000/tools/deployment-manifest-builder/index.html
2. Tool loads with empty state
3. Solution identity section visible

### Narration

> Every change that flows through a pull request is eventually deployed somewhere. Before the PR, you need to answer: What is being deployed? Who owns it? Where does it go? What governance checks must pass?

> The Deployment Manifest Builder creates a release contract. It documents all of this in one place.

> This manifest is the source of truth for the release team. It's also read by reviewers to understand deployment context.

### Demo Action 1: Click "Use starter manifest"

**Narration:**

> Let me click on "Use starter manifest" to load a pre-built example. This shows you what a complete deployment manifest looks like.

### Demo Action 2: Show Solution Identity section

**UI shows:**
- Solution name
- Domain
- Criticality (dropdown)
- Business owner
- Technical owner

**Narration:**

> The manifest starts with Solution Identity. You fill in the solution name, domain (like Sales or Finance), criticality level, and the business owner and technical owner. This answers: What is being deployed and who's responsible?

### Demo Action 3: Scroll to show Ownership section

**Narration:**

> As I scroll down, you see Ownership section with Creator, Approver, and Release Manager. This clarifies the governance roles. Who created this solution? Who must approve changes? Who pulls the trigger at release time?

### Demo Action 4: Show Artifacts list

**Narration:**

> Next, the Artifacts section. This lists which reports, semantic models, and dashboards are part of this solution. It prevents surprises like 'Oh, I didn't know that report was in this deployment.'

### Demo Action 5: Show Deployment Stages

**Narration:**

> The Deployment Stages section defines the path from dev to prod. What environments will this flow through? Development, test, staging, production?

### Demo Action 6: Show Validation Gates section

**Narration:**

> And here's the critical part: Validation Gates. What checks must pass before this can be deployed? Must the readiness score be above 50? Must DAX tests pass? Does someone have to manually approve it?

### Demo Action 7: Click "Download manifest summary"

**Narration:**

> When I click Download manifest summary, it exports a Markdown file that's human-readable. This goes in your PR description so reviewers understand the release contract from the start.

**Timing: Pause 2 seconds**

> This manifest is a contract. It says to the team: 'Here's exactly what's being deployed, here's who can approve it, here's what checks it must pass, and here's how we roll back if needed.'

### Use-case example

> Example: Your team is deploying three new reports and updating one shared semantic model. The manifest documents that Alice is the report owner, Bob owns the semantic model, Carol must approve changes to the semantic model (because it's shared), and the deployment requires 50+ readiness score and passing DAX tests. This manifest is visible to everyone on the PR.

### Transition

> Now that we know what's being deployed, we need to check: Is the PBIP project actually ready for review?

---

## STEP 2 — PBIP Project Readiness Scanner (2-3 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/pbip-readiness-scanner/index.html
3. Tool loads with empty state

### Narration

> The PBIP Project Readiness Scanner is a pre-PR quality checkpoint. Report authors run this on their local PBIP folder to catch missing structure or governance assets BEFORE opening the PR.

> If something is missing—governance rules files, DAX tests, readiness documentation—the scanner tells you. No surprises at review time.

### Demo Action 1: Click "Use sample scan"

**Narration:**

> Let me load a sample scan to show you what this looks like. The scanner analyzes your PBIP structure, checks for required governance assets, and gives you a readiness score.

### Demo Action 2: Show Readiness Score section

**UI shows (after sample loads):**
- Overall readiness score
- Blockers count
- Warnings count
- Passed checks count

**Narration:**

> Look at the Readiness Score panel on the left. You see the total score, the number of blockers (stop signs—you can't open a PR until these are fixed), warnings (be careful about these), and passed checks (good news).

### Demo Action 3: Click "Findings" tab

**Narration:**

> Click on the Findings tab. This shows all the validation checks: PBIP structure validation, governance assets found, quality rules present, DAX tests documented, and CI/CD configuration readiness.

### Demo Action 4: Show findings by category

**Narration:**

> The findings are grouped by category. Some are blockers—missing critical files. Some are warnings—things you should fix before opening the PR. And some are informational—good practices you've followed.

### Demo Action 5: Click "Download Markdown report"

**Narration:**

> When you click Download Markdown report, it exports a comprehensive readiness report that you can attach to your PR. This tells reviewers: 'I've run the readiness checks. Here's what passed and what needs attention.'

**Timing: Pause 2 seconds**

> The key insight: The scanner catches 80% of PR review delays before the PR is even opened. Missing files, incomplete governance documentation, configuration issues—all caught upfront.

### Transition

> So now you have a manifest documenting what you're deploying, and a readiness score proving your PBIP is ready for review. Next, reviewers need to understand what changed.

---

## STEP 3 — PBIP Diff Viewer (2-3 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/pbip-diff-viewer/index.html
3. Tool loads with empty state

### Narration

> The PBIP Diff Viewer is where reviewers stop decoding JSON and start understanding context. Instead of looking at raw PBIP file diffs, reviewers see: What reports were added? What measures changed? What governance assets were updated?

### Demo Action 1: Click "Use starter example"

**Narration:**

> Let me load a starter example that shows a realistic before-and-after PBIP change.

### Demo Action 2: Show Diff Health summary

**UI shows:**
- Changed artifacts count
- Added count
- Removed count
- Review focus count

**Narration:**

> The Diff Health panel shows: 5 artifacts changed, 2 added, 0 removed. This gives reviewers a quick sense of scope. Is this a tiny change or a large refactor?

### Demo Action 3: Click on a change to show details

**Narration:**

> When you click on a changed artifact, the viewer shows what changed and why it matters. For example, if a measure changed, you see the old DAX and the new DAX side-by-side with an explanation like 'Measure logic updated to fix performance issue.'

### Demo Action 4: Show different artifact types

**Narration:**

> As you scroll through the changes, you see different types: report page changes, semantic model updates, rule file updates, DAX test changes. Each is categorized so reviewers know what kind of risk they're evaluating.

### Demo Action 5: Click "Download Markdown"

**Narration:**

> Click Download Markdown to export a reviewer-friendly diff report. This becomes part of the PR body. Instead of 'Hey, I changed 47 files', reviewers see a structured summary of what changed and why.

**Timing: Pause 2 seconds**

> This is the power move. Raw PBIP diffs are unreadable JSON. This viewer translates it into business language. Reviewers spend 5 minutes understanding instead of 30 minutes decoding.

### Transition

> But there's one more thing reviewers need: downstream impact analysis. If I changed a measure, which reports and visuals are affected?

---

## STEP 4 — Dependency Impact Analyzer (2-3 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/dependency-impact-analyzer/index.html
3. Tool loads with empty state

### Narration

> The Dependency Impact Analyzer answers a critical question: If I change this measure, what downstream artifacts are affected? Which visuals will break? Which reports need re-testing?

> This prevents the nightmare scenario: You deploy a measure change that looks safe, but it breaks five reports in production because no one traced the dependencies.

### Demo Action 1: Click "Use starter example"

**Narration:**

> Let me load a starter example with a realistic semantic model and its dependencies.

### Demo Action 2: Show Model Object Inventory

**UI shows:**
- Objects count
- Measures count
- Visual references count
- Impacts count

**Narration:**

> The Model Object Inventory panel shows what's in the semantic model: 23 objects, 8 measures, 42 visual references across reports. This gives scope.

### Demo Action 3: Enter a changed object

**Narration:**

> Now let's say you changed a measure called 'Revenue'. I'll type that in the 'Changed objects' field.

### Demo Action 4: Show impact calculation

**Narration:**

> The analyzer instantly calculates: If Revenue changed, these 7 visuals are impacted, these 3 reports need re-testing, these 2 measures depend on it. Reviewers know exactly what to test.

### Demo Action 5: Click "Download Markdown"

**Narration:**

> Download the impact report and include it in your PR. Reviewers now have a testing roadmap: 'I changed Revenue. Here are the 10 places that might be affected. These are the ones I tested.'

**Timing: Pause 2 seconds**

> This is risk mitigation. You're not asking reviewers to guess what might break. You're showing them exactly what needs testing.

### Transition

> Now we have everything a reviewer needs: What's being deployed (manifest), is it ready (readiness scan), what changed (diff viewer), and what's affected (impact analysis). One more tool pulls this all together for the PR.

---

## STEP 5 — PR Quality Summary Generator (2-3 minutes)

### Opening actions
1. Click "Back to launchpad"
2. Navigate to http://localhost:8000/tools/pr-quality-summary-generator/index.html
3. Tool loads with empty state

### Narration

> The PR Quality Summary Generator is the final handoff. It takes all the signals—readiness score, impact analysis, quality rule results, deployment manifest—and creates one concise summary for reviewers.

> Instead of reviewers hunting through five different files and tools, everything is in one place.

### Demo Action 1: Click "Use starter example"

**Narration:**

> Let me load a pre-filled example showing a complete PR quality summary.

### Demo Action 2: Show Summary Health

**UI shows:**
- Changed files count
- Errors count
- Warnings count
- Review risks count

**Narration:**

> The Summary Health panel gives reviewers a 10-second assessment: 12 files changed, 0 errors, 2 warnings, 1 review risk. This is your risk traffic light: green, yellow, or red.

### Demo Action 3: Scroll through generated summary

**Narration:**

> The Generated Markdown shows the complete PR summary: pull request context, validation signals, changed file categories, failed quality rules (if any), review risks, and a reviewer checklist.

> This is what goes in the PR body. One page. Reviewers scan it in 2 minutes and know exactly what they're looking at.

### Demo Action 4: Show recommendation

**Narration:**

> At the top, there's a recommendation: 'Ready to merge', 'Review before merging', or 'Do not merge'. This comes from the aggregate of all the signals. If readiness is below threshold or there are failed quality rules, the recommendation is clear.

### Demo Action 5: Click "Download Markdown"

**Narration:**

> Click Download Markdown to export this summary for your PR body. Include it when you open the pull request.

### Summary narration

> You've just seen the complete Part 2 workflow: author prepares with manifest and readiness scanner, reviewer understands changes with diff viewer and impact analyzer, and everyone sees the summary in one place. What used to take 30 minutes of 'I don't understand what you changed' now takes 5 minutes of 'I know exactly what you changed and what might break.'

### Use-case example

> Example: Your team changes a shared revenue measure used by 15 reports. Old workflow: PR sits for days because reviewers don't know what's affected. New workflow: Author runs readiness scanner (passed), uploads impact analysis showing 8 affected measures, uploads diff viewer output showing the change, and generates PR summary. Reviewers spend 5 minutes reviewing instead of 30 minutes investigating.

### Transition to Part 3

> So far, you've learned how individuals and teams handle governance and review. Now the platform team's job begins: How do we automate this at scale? How do we generate CI/CD pipelines? How do we track exceptions? How do we measure program success?

> That's Part 3.

---

## TIMING CHECKLIST

- Opening narration: 1 minute
- Step 1 (Deployment Manifest): 3-4 minutes
- Step 2 (Readiness Scanner): 2-3 minutes
- Step 3 (Diff Viewer): 2-3 minutes
- Step 4 (Impact Analyzer): 2-3 minutes
- Step 5 (PR Summary): 2-3 minutes
- Transition: 1 minute

**Total: 13-18 minutes** (Allows 1-2 min editing overhead)

---

## PRODUCTION NOTES

- **Zoom level:** 100% for clarity
- **Browser:** Edge or Chrome
- **Resolution:** 1920x1080 (1080p)
- **Pause timing:** 2–3 seconds when showing generated Markdown or downloaded artifacts
- **Narration pacing:** Slightly slower than normal (reviewers will rewatch)
- **Screen actions:** Deliberate and obvious (don't rush scrolling or clicking)
- **File loading:** Make sure sample data loads before demo

---

## KEY POINTS TO EMPHASIZE

1. **Manifest = Release Contract**: "This prevents surprises."
2. **Readiness Scanner = Pre-PR Quality Gate**: "Catch issues before reviewers see them."
3. **Diff Viewer = Business Language**: "JSON becomes insight."
4. **Impact Analyzer = Risk Mitigation**: "Know what testing is needed."
5. **PR Summary = Single Source of Truth**: "Everything in one page."

---

## WHAT NOT TO SAY

❌ "Let me look at the raw JSON diff" (that's not the point)
❌ "Review this manifest if you understand it" (clarity is the goal)
❌ "I can't tell what tests will fail" (impact analysis shows this)
❌ "Reviewers need to figure out the scope" (diff viewer shows this)

---

## WHAT TO SAY

✅ "The manifest creates a release contract"
✅ "The readiness scanner prevents PR delays"
✅ "The diff viewer translates JSON into business language"
✅ "The impact analyzer shows what needs testing"
✅ "The PR summary is everything reviewers need in one place"
