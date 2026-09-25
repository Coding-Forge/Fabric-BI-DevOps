# Visual Reference Guide — Part 2 PBIP Review Tools

**Use this guide WHILE RECORDING to verify UI element names and sections**

---

## TOOL QUICK REFERENCE

| Tool | Actual UI Title | Key Sections | Status |
|---|---|---|---|
| Deployment Manifest Builder | Deployment Manifest Builder | Solution identity, Ownership, Artifacts, Stages, Gates, Rollback | ✓ Verified |
| PBIP Project Readiness Scanner | PBIP Project Readiness Scanner | Readiness score, Blockers/Warnings/Passed, Findings tab, Inventory | ✓ Verified |
| PBIP Diff Viewer | PBIP Diff Viewer | Diff health, Changed/Added/Removed counts, Artifact filter, Review focus | ✓ Verified |
| Dependency Impact Analyzer | Dependency Impact Analyzer | Model object inventory, Changed objects input, Impact type filter, Impacts output | ✓ Verified |
| PR Quality Summary Generator | PR Quality Summary Generator | Summary health, Changed files/Errors/Warnings/Risks, PR inputs, Generated Markdown | ✓ Verified |

---

## SECTION 1: DEPLOYMENT MANIFEST BUILDER

### Key Sections (In order as you scroll)

```
┌─────────────────────────────────────┐
│ SOLUTION IDENTITY                   │
│ ├─ Solution name                    │
│ ├─ Domain                           │
│ ├─ Criticality (low/medium/high)    │
│ ├─ Business owner                   │
│ └─ Technical owner                  │
│                                     │
│ OWNERSHIP                           │
│ ├─ Creator                          │
│ ├─ Approver                         │
│ └─ Release Manager                  │
│                                     │
│ ARTIFACTS                           │
│ ├─ Reports (list)                   │
│ ├─ Semantic models (list)           │
│ └─ Dashboards (list)                │
│                                     │
│ DEPLOYMENT STAGES                   │
│ ├─ Development                      │
│ ├─ Test                             │
│ ├─ Staging                          │
│ └─ Production                       │
│                                     │
│ PARAMETERS                          │
│ ├─ Environment variables            │
│ └─ Connection strings               │
│                                     │
│ VALIDATION GATES                    │
│ ├─ Readiness score minimum          │
│ ├─ DAX tests must pass              │
│ └─ Approvals required               │
│                                     │
│ ROLLBACK STRATEGY                   │
│ └─ Recovery time estimate           │
└─────────────────────────────────────┘
```

### Buttons to Click During Recording

```
[Back to launchpad]
[Load deployment-manifest.json]
[Scan PBIP folder]
[Download deployment-manifest.json]
[Download manifest summary] ← Most important for demo
[Use starter manifest] ← Load pre-built example
```

### Tabs to Show

```
[Builder] ← Editing interface
[Review] ← Human-readable summary
[JSON] ← Machine-readable format
[Markdown] ← Export format
```

---

## SECTION 2: PBIP PROJECT READINESS SCANNER

### Readiness Score Panel

```
┌─────────────────────────────────────┐
│ READINESS SCORE                     │
│ ├─ Overall score: XX%              │
│ ├─ Blockers: N                     │  ← Stop signs
│ ├─ Warnings: N                     │  ← Yellow flags
│ ├─ Passed: N                       │  ← Green checks
│ └─ Files scanned: N                │
└─────────────────────────────────────┘
```

### Findings Categories

**When you click "Findings" tab, you'll see:**

```
STRUCTURE VALIDATION
├─ PBIP structure valid
├─ Report files detected
└─ Dataset files detected

GOVERNANCE ASSETS
├─ Rules-Report.json found
├─ Rules-Dataset.json found
├─ enterprise-policy-profile.json found
├─ dax-tests.json found
└─ Policy-Summary.md found

CI/CD CONFIGURATION
├─ Deployment manifest found
└─ .github or .azdo configuration found

HYGIENE CHECKS
├─ No binary files in PBIP
├─ JSON is valid format
└─ Required metadata present
```

### Buttons During Recording

```
[Back to launchpad]
[Scan folder] ← Opens file picker
[Use sample scan] ← Load pre-built example
[Download Markdown report]
[Download JSON report]
```

### Tabs

```
[Findings] ← Validation results
[Inventory] ← Files and asset count
[PR summary] ← Ready-to-paste content
[JSON report] ← Machine-readable
```

---

## SECTION 3: PBIP DIFF VIEWER

### Diff Health Panel

```
┌─────────────────────────────────────┐
│ DIFF HEALTH                         │
│ ├─ Changed: N                      │
│ ├─ Added: N                        │
│ ├─ Removed: N                      │
│ └─ Review focus: N                 │
│                                     │
│ FILE COUNTS                         │
│ ├─ Before: N files                 │
│ ├─ After: N files                  │
│ └─ Visible: N changes              │
└─────────────────────────────────────┘
```

### Filters and Search

```
Filter by artifact type:
[All artifacts ▼]
- All artifacts
- Report pages
- Semantic model
- Governance rules
- DAX tests
- Metadata

Search changed paths:
[Search textbox] ← Type: page.json, model.tmdl, etc.
```

### Buttons

```
[Back to launchpad]
[Load before folder]
[Load after folder]
[Use starter example]
[Download HTML]
[Download Markdown]
[Download JSON]
```

---

## SECTION 4: DEPENDENCY IMPACT ANALYZER

### Model Object Inventory Panel

```
┌─────────────────────────────────────┐
│ MODEL OBJECT INVENTORY              │
│ ├─ Objects: N                      │
│ ├─ Measures: N                     │
│ ├─ Visual refs: N                  │
│ ├─ Impacts: N                      │
│                                     │
│ FILE SUMMARY                        │
│ ├─ Text files loaded: N            │
│ ├─ Pages: N                        │
│ ├─ Relationships: N                │
│ └─ Governance assets: N            │
└─────────────────────────────────────┘
```

### Input Section

```
Changed objects, one per line:
[Textbox] ← Example: Revenue, Sales[Amount], Customer[Region]

Filter object inventory:
[Search textbox]

Impact type filter:
[All impact types ▼]
- All impact types
- Measure
- Visual
- Report page
- Relationship
- Governance asset
```

### Buttons

```
[Back to launchpad]
[Load PBIP folder]
[Use starter example]
[Download HTML]
[Download Markdown]
[Download JSON]
```

---

## SECTION 5: PR QUALITY SUMMARY GENERATOR

### Summary Health Panel

```
┌─────────────────────────────────────┐
│ SUMMARY HEALTH                      │
│ ├─ Changed files: N                │
│ ├─ Errors: N                       │
│ ├─ Warnings: N                     │
│ └─ Review risks: N                 │
│                                     │
│ SIGNALS                             │
│ ├─ No errors detected              │
│ ├─ No warnings detected            │
│ ├─ No readiness output             │
│ └─ No manifest context             │
└─────────────────────────────────────┘
```

### Input Fields (Fill these in order)

```
BASIC INFO:
├─ PR title
├─ Source branch
└─ Target branch

OWNERSHIP:
├─ Author / owner
└─ Deployment target

ARTIFACTS:
├─ Changed paths (one per line)
├─ Pipeline log or quality output
├─ PBIP readiness report
├─ Deployment manifest
└─ DAX test summary
```

### Generated Output (Tabs)

```
Generated Markdown ← Use this in PR body
├─ PR Quality Summary heading
├─ Recommendation (Ready/Caution/Do not merge)
├─ Pull request context table
├─ Validation signals table
├─ Changed file summary
├─ Failed quality rules section
├─ Review risks list
└─ Reviewer checklist

Generated JSON ← Machine-readable version
```

### Buttons

```
[Back to launchpad]
[Generate summary] ← Auto-generates from inputs
[Use starter example]
[Copy Markdown]
[Download Markdown]
[Download JSON]
```

---

## RECORDING CHECKLIST — PART 2

- [ ] All 5 Part 2 tools load correctly at localhost:8000
- [ ] Deployment Manifest Builder shows Solution Identity section
- [ ] Readiness Scanner shows Blockers/Warnings/Passed counts
- [ ] Diff Viewer shows Changed/Added/Removed counts
- [ ] Impact Analyzer shows Objects/Measures/Visual refs counts
- [ ] PR Summary Generator shows Summary Health panel
- [ ] All "Use starter example" buttons work
- [ ] All "Download" buttons appear in headers
- [ ] Tabs are visible (Builder/Review/JSON, Findings/Inventory, etc.)
- [ ] Browser at 100% zoom, 1920x1080

---

## COMMON TERMS USED IN PART 2

| Term | What It Means | Example |
|---|---|---|
| **Manifest** | Release contract documenting what/who/where | "deployment-manifest.json" |
| **Readiness Score** | Pre-PR quality checkpoint | "75/100 ready for review" |
| **Blockers** | Stop signs - must fix before PR | "Missing Rules-Dataset.json" |
| **Warnings** | Yellow flags - should fix | "DAX tests incomplete" |
| **Diff** | Before-and-after changes | "5 changed, 2 added, 0 removed" |
| **Impact** | Downstream effects of changes | "Revenue measure affects 7 visuals" |
| **Review focus** | Items needing careful review | "Semantic model changes (high risk)" |

---

## WHAT REVIEWERS SEE (Example Output)

### Deployment Manifest Summary (Markdown)
```
# Deployment Manifest

**Solution:** Cost Management Reports
**Owner:** Finance Team
**Domain:** FinOps
**Criticality:** High
**Deployment Path:** Dev → Test → Staging → Prod

## Validation Gates
- Readiness score: ≥75
- DAX tests: Must pass
- Approver: Carol (Data Governance)
```

### Readiness Report (Markdown)
```
# PBIP Readiness Report

## Score: 87/100 ✓ Ready for PR

### Blockers: 0 (All fixed)
### Warnings: 2 (Review these)
- DAX test ownership incomplete
- Deployment manifest missing approver

### Passed Checks: 14
- PBIP structure valid
- Rules files present
- Governance metadata current
```

### Diff Report (Markdown)
```
# PBIP Changes Summary

## Overview
- Changed: 3 artifacts
- Added: 2 artifacts
- Removed: 0 artifacts

## Changed
- `Cost-Management.Report/definition/pages/Summary/page.json`
- `Cost-Management.SemanticModel/definition/database.tmdl`
- `shared/Rules-Report.json` (updated policy)
```

### Impact Report (Markdown)
```
# Dependency Impact Analysis

## Changed Object: Revenue Measure

### Impacted Visuals (7 total)
- Summary.Total Revenue Card
- Trends.Revenue by Month Chart
- Forecast.Revenue Projection
- (4 more)

### Affected Report Pages (2 total)
- Executive Summary
- Finance Dashboard
```

### PR Quality Summary (Markdown)
```
# PR Quality Summary: Cost Management Q3 Update

**Recommendation:** ✓ Ready to merge

| Field | Value |
|---|---|
| Owner | Finance Team |
| Deployment Target | Prod |
| Changed Files | 5 |
| Errors | 0 |
| Warnings | 2 |
| Readiness Score | 87/100 |

## Reviewer Checklist
- [x] PBIP structure valid
- [x] Quality rules passed
- [x] DAX tests passing
- [ ] Performance impact reviewed
- [ ] Cross-team dependencies checked
```

---

## DEMO FLOW DURING RECORDING

```
Deployment Manifest Builder
  └─ Show Solution Identity section
  └─ Click "Use starter manifest"
  └─ Scroll to Ownership, Artifacts, Stages
  └─ Show Validation Gates
  └─ Click "Download manifest summary"
  └─ Pause 2 seconds on download
  
→ PBIP Readiness Scanner
  └─ Click "Use sample scan"
  └─ Show Readiness Score (XX%, Blockers, Warnings, Passed)
  └─ Click "Findings" tab
  └─ Show categories (Structure, Governance, CI/CD, Hygiene)
  └─ Click "Download Markdown report"
  
→ PBIP Diff Viewer
  └─ Click "Use starter example"
  └─ Show Diff Health (Changed, Added, Removed)
  └─ Show artifact filter dropdown
  └─ Show search box for file paths
  └─ Click a changed item to show detail
  └─ Click "Download Markdown"
  
→ Dependency Impact Analyzer
  └─ Click "Use starter example"
  └─ Show Model Object Inventory
  └─ Type a changed object (e.g., "Revenue")
  └─ Show calculated impacts
  └─ Show Impact Type filter
  └─ Click "Download Markdown"
  
→ PR Quality Summary Generator
  └─ Click "Use starter example"
  └─ Show Summary Health panel
  └─ Scroll through Generated Markdown
  └─ Show Recommendation
  └─ Show Reviewer Checklist
  └─ Click "Download Markdown"
```

---

## QUICK REFERENCE — WHAT TO SAY

| When... | Say... |
|---|---|
| Showing Deployment Manifest | "This is the release contract - who, what, where, when" |
| Showing Readiness Score | "Zero blockers means we're ready for review" |
| Showing Diff changes | "5 artifacts changed - reviewers know the scope immediately" |
| Showing Impact analysis | "Revenue is used in 7 visuals - here's what needs testing" |
| Showing PR Summary | "Everything in one page - reviewers can review in 5 minutes" |
