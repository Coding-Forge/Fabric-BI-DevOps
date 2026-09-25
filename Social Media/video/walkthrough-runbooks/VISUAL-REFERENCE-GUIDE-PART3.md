# Visual Reference Guide — Part 3 Platform & Governance Tools

**Use this guide WHILE RECORDING to verify UI element names and sections**

---

## TOOL QUICK REFERENCE

| Tool | Actual UI Title | Key Sections | Status |
|---|---|---|---|
| Pipeline Config Generator | Pipeline Config Generator | Pipeline structure, Stages, Platform config, YAML generation | ✓ Verified |
| Policy Exception Register | Policy Exception Register | Register health, Exception list, Details view, Approval tracking | ✓ Verified |
| Effective Rules Generator | Effective Rules Generator | Effective rule health, Rule merge, Override tracking, Export | ✓ Verified |
| CI/CD Platform Parity Matrix | CI/CD Platform Parity Matrix | Parity health, Capabilities list, Status filters, Details | ✓ Verified |
| Release Readiness Dashboard | Release Readiness Dashboard | Readiness score, Release gates, Timeline, Approval button | ✓ Verified |
| Adoption Metrics Dashboard | Adoption Metrics Dashboard | Adoption health, Project metrics, Platform breakdown, Onboarding time | ✓ Verified |
| Rule Coverage Matrix | Rule Coverage Matrix | Coverage health, Rule categories, Automation breakdown, Enforcement status | ✓ Verified |
| Competitive Differentiation Matrix | Competitive Differentiation Matrix | Feature categories, Capability comparison, Competitor status, Roadmap | ✓ Verified |

---

## SECTION 1: PIPELINE CONFIG GENERATOR

### Key Sections (In order as you scroll)

```
┌─────────────────────────────────────┐
│ PIPELINE STRUCTURE                  │
│ ├─ Pipeline name                    │
│ ├─ Trigger events (PR, merge, etc.) │
│ ├─ Runner OS requirements           │
│ └─ Failure policy (block/warn)      │
│                                     │
│ VALIDATION STAGES                   │
│ ├─ Stage 1: PBIP structure check    │
│ ├─ Stage 2: Quality rules check     │
│ ├─ Stage 3: DAX test check          │
│ ├─ Stage 4: Governance check        │
│ └─ Stage 5: Manual approval gate    │
│                                     │
│ PLATFORM-SPECIFIC CONFIG            │
│ ├─ Azure DevOps runner type         │
│ ├─ Azure DevOps runner version      │
│ ├─ GitHub Actions runner type       │
│ ├─ GitHub Actions runner version    │
│ ├─ GitLab runner type               │
│ └─ GitLab runner version            │
│                                     │
│ PARALLEL EXECUTION                  │
│ ├─ Stages run in sequence           │
│ ├─ OR stages run in parallel        │
│ └─ Set concurrency limit            │
│                                     │
│ ARTIFACTS                           │
│ ├─ Publish test results             │
│ ├─ Publish quality reports          │
│ └─ Retain logs N days               │
└─────────────────────────────────────┘
```

### Buttons to Click During Recording

```
[Back to launchpad]
[Platform dropdown: Azure DevOps]
[Generate pipeline] ← Most important for demo
[Platform dropdown: GitHub Actions]
[Generate pipeline] ← Most important for demo
[Platform dropdown: GitLab CI]
[Generate pipeline] ← Most important for demo
[Use starter example]
[Download YAML]
```

### Tabs to Show

```
[Builder] ← Editing interface
[Azure DevOps YAML] ← Generated code
[GitHub Actions YAML] ← Generated code
[GitLab CI YAML] ← Generated code
```

---

## SECTION 2: POLICY EXCEPTION REGISTER

### Register Health Panel

```
┌─────────────────────────────────────┐
│ REGISTER HEALTH                     │
│ ├─ Active exceptions: N            │  ← Current waivers
│ ├─ Expiring soon (7 days): N       │  ← Follow-up needed
│ ├─ Expired: N                      │  ← Past due
│ ├─ Approval pending: N             │  ← Awaiting sign-off
│ └─ Total exceptions: N             │
└─────────────────────────────────────┘
```

### Exception Fields

```
BASIC INFO:
├─ Exception ID (auto-generated)
├─ Solution/project name
├─ Team owner
└─ Exception date

EXCEPTION DETAILS:
├─ Rule that's waived
├─ Category (governance/quality/deployment)
├─ Criticality (low/medium/high)
└─ Business justification

APPROVAL:
├─ Requested by (team lead)
├─ Approved by (governance lead)
├─ Approval date
├─ Approval notes
└─ Review frequency (monthly/quarterly)

TIMING:
├─ Start date
├─ Expiration date (hard stop)
├─ Renewal plan
└─ Escalation contact
```

### Buttons During Recording

```
[Back to launchpad]
[New exception] ← Creates new record
[Add or update] ← Edit existing
[Delete selected] ← Remove (use carefully)
[Load exceptions.json]
[Use starter register] ← Load pre-built example
[Download register] ← PDF or Markdown
[Download CSV] ← For analysis
[Send expiration reminders] ← Email alerts to teams
```

### Tabs

```
[Register] ← List view
[Exception details] ← Edit form
[Approval status] ← Who approved what
[Expiration tracking] ← Timeline view
[Team breakdown] ← Count by team
```

---

## SECTION 3: EFFECTIVE RULES GENERATOR

### Effective Rule Health Panel

```
┌─────────────────────────────────────┐
│ EFFECTIVE RULE HEALTH               │
│ ├─ Rules defined: N                │
│ ├─ Overrides: N                    │
│ ├─ Exceptions: N                   │
│ ├─ Enforced: N                     │
│ └─ Coverage: XX%                   │
│                                     │
│ SOURCE PROFILES                     │
│ ├─ Enterprise baseline: X rules    │
│ ├─ Team customization: Y rules     │
│ └─ Temporary overrides: Z rules    │
└─────────────────────────────────────┘
```

### Input Section

```
SELECT PROFILES TO MERGE:
[Enterprise baseline ▼] ← Base rules
  ├─ Minimal profile
  ├─ Standard profile
  ├─ Advanced profile
  └─ Custom profile

[Overrides profile ▼] ← Team customization
[Exceptions to apply ▼] ← Current waivers
```

### Output Section

```
MERGED RULE LIST:
├─ Rule ID
├─ Rule name
├─ Category
├─ Source (baseline/override/exception)
├─ Status (enabled/disabled/conditional)
├─ Enforcement (automated/manual)
└─ Notes (why this override exists)
```

### Buttons During Recording

```
[Back to launchpad]
[Load rules profile] ← Pick a profile
[Merge profiles] ← Calculate effective rules
[Add rule override]
[Remove rule override]
[Apply exceptions]
[Use starter rules] ← Load pre-built example
[Download effective rules]
[Download as JSON]
[Export to pipeline]
```

---

## SECTION 4: CI/CD PLATFORM PARITY MATRIX

### Parity Health Panel

```
┌─────────────────────────────────────┐
│ PARITY HEALTH                       │
│ ├─ Total capabilities: 5           │
│ ├─ Full parity: 4                  │
│ ├─ Partial/planned: 1              │
│ ├─ Gaps: 0                         │
│ └─ Parity score: 92%               │
└─────────────────────────────────────┘
```

### Capability Status Legend

```
🟢 SUPPORTED
   = Works identically on all platforms
   = No special handling needed

🟡 PARTIAL
   = Works on some platforms, not others
   = Platform-specific workarounds exist

🟠 PLANNED
   = Committed but not yet shipped
   = Target date provided

🔴 GAP
   = Not supported on any platform
   = Workaround required or deferral
```

### Capabilities List Structure

```
CAPABILITY DETAIL:
├─ Capability name
├─ Category (Validation/Quality/Release/Scale)
├─ Description
│
├─ PLATFORM STATUS:
│  ├─ Azure DevOps: [Status]
│  ├─ GitHub Actions: [Status]
│  └─ GitLab CI/CD: [Status]
│
└─ IMPLEMENTATION NOTES
   ├─ Runner requirements
   ├─ Setup differences
   ├─ Known limitations
   └─ Workarounds (if any)
```

### Buttons During Recording

```
[Back to launchpad]
[New capability] ← Add new row
[Add or update] ← Edit existing
[Delete selected]
[Load platform-parity-matrix.json]
[Use starter matrix] ← Load pre-built example
[Download JSON]
[Download Markdown]
```

### Tabs

```
[Builder] ← Editing interface
[Matrix] ← Visual grid view
[Markdown] ← Export format
[JSON] ← Machine-readable
```

---

## SECTION 5: RELEASE READINESS DASHBOARD

### Readiness Score Section

```
┌─────────────────────────────────────┐
│ READINESS SCORE                     │
│ ├─ Current: 92%                    │
│ ├─ Target: 85% minimum             │
│ ├─ Days to release: 3              │
│ ├─ Days in pilot: 8                │
│ ├─ Blocking issues: 0              │
│ └─ STATUS: Ready to release ✓      │
└─────────────────────────────────────┘
```

### Release Gates (ALL must be green)

```
🟢 Quality rules: PASSED
   └─ X rules enforced, 0 failing

🟢 Readiness score: 92% (above 85% minimum)
   └─ Automation: 87% covered
   └─ Manual checks: 100% complete

🟢 No blocking exceptions
   └─ 2 active exceptions (both non-blocking)
   └─ 0 expired exceptions

🟢 Approvals signed off
   └─ Technical approver: Approved
   └─ Business approver: Approved
   └─ Security approver: Approved
   └─ Deployment approver: Pending (1 of 4)
```

### Solution Timeline

```
┌──────────────────────────────────┐
│ Created:       Sept 1            │
│ First PR:      Sept 5            │
│ Entered pilot: Sept 8            │
│ Pilot duration: 7 days           │
│ Production target: Sept 20       │
│ Days remaining: 3 days           │
└──────────────────────────────────┘
```

### Buttons During Recording

```
[Back to launchpad]
[New solution] ← Track new release
[Add or update] ← Edit existing
[Delete selected]
[Load release-readiness.json]
[Use sample dashboard] ← Load pre-built example
[Approve for release] ← Gate keeper action
[Defer release]
[Download release summary]
[Download release notes template]
```

---

## SECTION 6: ADOPTION METRICS DASHBOARD

### Adoption Health Panel

```
┌─────────────────────────────────────┐
│ ADOPTION HEALTH                     │
│ ├─ Total projects: 47             │
│ ├─ Active/pilot/scaled: 12        │
│ ├─ Avg readiness: 82/100          │
│ ├─ Avg onboard days: 11           │
│ ├─ Active exceptions: 34          │
│ ├─ Expired exceptions: 2          │
│ └─ TREND: Healthy ↑               │
└─────────────────────────────────────┘
```

### Project Metrics Form

```
BASIC INFO:
├─ Project name
├─ Domain (FinOps, Sales, HR, etc.)
├─ Business owner
└─ Technical owner

PLATFORM INFO:
├─ CI/CD Platform (AzDO/GitHub/GitLab/Mixed)
├─ Status (candidate/pilot/active/scaled/paused)
├─ Toolkit profile (minimal/standard/workshop/custom)
└─ Start environment

READINESS TRACKING:
├─ Onboarded on (date)
├─ Go-live target (date)
├─ Time to onboard (days)
├─ Rules enabled (count)
├─ Rules blocking (count)
└─ Readiness score (0-100)

GOVERNANCE TRACKING:
├─ Active exceptions (count)
├─ Expired exceptions (count)
├─ Last release decision (date)
└─ Release cadence (weekly/bi-weekly/monthly)

METRICS BREAKDOWN:
├─ Active exceptions by rule
├─ Expired exceptions trending
├─ Platform breakdown (AzDO/GitHub/GitLab/Mixed)
└─ Readiness distribution
```

### Buttons During Recording

```
[Back to launchpad]
[New project] ← Onboard new team
[Add or update] ← Edit existing
[Delete selected]
[Load adoption-metrics.json]
[Use starter metrics] ← Load pre-built example
[Export CSV] ← For analysis
[Export Markdown] ← For reporting
[Export JSON] ← For pipelines
[Send onboard survey] ← Email team
```

---

## SECTION 7: RULE COVERAGE MATRIX

### Coverage Health Panel

```
┌─────────────────────────────────────┐
│ COVERAGE HEALTH                     │
│ ├─ Total rules: 62                │
│ ├─ Automated: 54                  │
│ ├─ Manual: 8                      │
│ ├─ Not enforced: 0                │
│ └─ Automation coverage: 87%        │
└─────────────────────────────────────┘
```

### Rule Categories

```
DATA GOVERNANCE (16 total)
├─ Naming conventions (automated)
├─ Semantic model ownership (manual)
├─ Data lineage documentation (manual)
├─ PII protection (automated)
└─ ...others

QUALITY ASSURANCE (28 total)
├─ DAX test coverage (automated)
├─ Visual count limits (automated)
├─ Measure documentation (manual)
├─ Performance thresholds (automated)
└─ ...others

DEPLOYMENT AUTOMATION (18 total)
├─ Artifact publishing (automated)
├─ Release gate validation (automated)
├─ Approval workflow (manual)
├─ Rollback procedures (manual)
└─ ...others
```

### Rule Detail Fields

```
FOR EACH RULE:
├─ Rule ID
├─ Rule name
├─ Category
├─ Description
├─ Enforcement:
│  ├─ Automated (runs in pipeline)
│  └─ Manual (code review check)
├─ Impact if failed (warn/block/gate)
├─ Implementation status
├─ Last updated (date)
└─ Owner (person/team)
```

### Buttons During Recording

```
[Back to launchpad]
[New rule] ← Add to matrix
[Add or update] ← Edit existing
[Delete selected]
[Load rule-coverage-matrix.json]
[Use starter coverage] ← Load pre-built example
[Automate rule] ← Mark for pipeline implementation
[Add to roadmap]
[Export coverage report]
[Export implementation roadmap]
```

---

## SECTION 8: COMPETITIVE DIFFERENTIATION MATRIX

### Feature Categories

```
DATA GOVERNANCE
├─ Your platform: Supported
├─ Competitor A: Supported
├─ Competitor B: Partial

CI/CD AUTOMATION
├─ Your platform: Supported
├─ Competitor A: Azure only
├─ Competitor B: Supported

QUALITY ENFORCEMENT
├─ Your platform: Supported
├─ Competitor A: Supported
├─ Competitor B: Planned

SCALING CAPABILITIES
├─ Your platform: Supported
├─ Competitor A: Partial
├─ Competitor B: Gap

...more capabilities
```

### Status Legend for Comparisons

```
✓ SUPPORTED = Production-ready on all platforms
◐ PARTIAL = Works on some platforms or with workarounds
◑ PLANNED = Committed for next 2 quarters
✗ GAP = Not supported; workaround required
? UNKNOWN = Not yet evaluated
```

### Roadmap Section

```
THIS QUARTER (Q4 2024):
├─ Multi-platform pipeline templates
├─ Real-time exception notifications
└─ Adoption metrics enhanced

NEXT QUARTER (Q1 2025):
├─ AI-powered rule recommendations
├─ Cross-platform deployment dashboards
└─ Advanced impact analysis

BEYOND (Q2 2025+):
├─ Automated remediation
├─ Predictive governance
└─ Industry-standard compliance templates
```

### Buttons During Recording

```
[Back to launchpad]
[New capability] ← Add to matrix
[Add or update] ← Edit existing
[Delete selected]
[Load competitive-matrix.json]
[Use starter matrix] ← Load pre-built example
[Add competitor]
[Update roadmap]
[Export competitive analysis]
[Export for sales team]
```

---

## RECORDING CHECKLIST — PART 3

- [ ] All 8 Part 3 tools load correctly at localhost:8000
- [ ] Pipeline Config Generator shows stages and platform config sections
- [ ] Policy Exception Register shows active/expiring/expired counts
- [ ] Effective Rules Generator shows rules/overrides/exceptions counts
- [ ] CI/CD Platform Parity Matrix shows 5 capabilities with status indicators
- [ ] Release Readiness Dashboard shows score and 4 release gates
- [ ] Adoption Metrics Dashboard shows projects/active/avg readiness counts
- [ ] Rule Coverage Matrix shows total/automated/manual/coverage %
- [ ] Competitive Differentiation Matrix shows capability categories and roadmap
- [ ] All "Use starter example" buttons work
- [ ] All "Download" buttons appear in headers
- [ ] Tabs are visible (Builder/Azure/GitHub/GitLab, etc.)
- [ ] Browser at 100% zoom, 1920x1080

---

## COMMON TERMS USED IN PART 3

| Term | What It Means | Example |
|---|---|---|
| **Platform parity** | Same governance works on all three CI/CD systems | "87% parity—all platforms support these rules" |
| **Exception** | Waiver from a governance rule (tracked and expiring) | "Revenue rule waived until Sept 30" |
| **Effective rule** | What rules actually apply after exceptions and overrides | "52 rules enforced including 3 team overrides" |
| **Release gate** | A checkpoint that must pass before production deployment | "Readiness score must be ≥85" |
| **Automation coverage** | Percentage of rules enforced by pipeline vs. manual review | "87% automated, 13% manual" |
| **Adoption rate** | % of teams using toolkit and moving to production | "25% of organization in active production" |
| **Differentiation** | What makes your solution stand out vs. competitors | "Multi-cloud parity is our advantage" |

---

## DEMO FLOW DURING RECORDING

```
Pipeline Config Generator
  └─ Show Pipeline Structure section
  └─ Click "Use starter example"
  └─ Show Validation Stages (5 stages)
  └─ Show Platform-Specific Config
  └─ Select "Azure DevOps" from Platform dropdown and click "Generate pipeline" (show briefly)
  └─ Select "GitHub Actions" from Platform dropdown and click "Generate pipeline" (show briefly)
  └─ Select "GitLab CI" from Platform dropdown and click "Generate pipeline" (show briefly)
  └─ Pause 2 seconds
  
→ Policy Exception Register
  └─ Click "Use starter register"
  └─ Show Register Health (Active, Expiring, Expired)
  └─ Click on an exception to show detail
  └─ Show expiration tracking
  └─ Click "Download register report"
  
→ Effective Rules Generator
  └─ Click "Use starter rules"
  └─ Show Effective Rule Health
  └─ Click "Merge profiles"
  └─ Show merged ruleset with overrides highlighted
  └─ Click "Download effective rules"
  
→ CI/CD Platform Parity Matrix
  └─ Click "Use starter matrix"
  └─ Show Parity Health (5 capabilities, 4 full parity, 1 partial)
  └─ Show capability categories
  └─ Click on a capability to show platform status
  └─ Click "Download parity report"
  
→ Release Readiness Dashboard
  └─ Click "Use sample dashboard"
  └─ Show Readiness Score (92%)
  └─ Show all 4 Release Gates (all green)
  └─ Show Solution Timeline
  └─ Click "Approve for release" (demonstrate gate keeper action)
  └─ Click "Download release summary"
  
→ Adoption Metrics Dashboard
  └─ Click "Use starter metrics" OR click "New project"
  └─ Show Adoption Health (47 projects, 12 active)
  └─ Fill in sample project metrics
  └─ Show calculated metrics for that project
  └─ Show Platform breakdown and Onboarding time
  └─ Click "Download adoption report"
  
→ Rule Coverage Matrix
  └─ Click "Use starter coverage"
  └─ Show Coverage Health (62 rules, 54 automated, 87% coverage)
  └─ Show Rule Categories (Data Governance, Quality, Deployment)
  └─ Click on a category to expand
  └─ Show individual rule details
  └─ Click "Download coverage report"
  
→ Competitive Differentiation Matrix
  └─ Click "Use starter matrix"
  └─ Show Feature Categories and competitor comparison
  └─ Click on capability where you lead
  └─ Click on capability where you're behind
  └─ Show Roadmap section
  └─ Click "Download competitive summary"
```

---

## QUICK REFERENCE — WHAT TO SAY

| When... | Say... |
|---|---|
| Showing Pipeline Config generations | "One workflow, three platform implementations—no drift" |
| Showing Exception Register | "Exceptions are tracked and visible—we don't hide them" |
| Showing Effective Rules merge | "Rules change based on context—this is what actually applies" |
| Showing Platform Parity status | "87% parity—we prove governance works on all platforms" |
| Showing Release gates (all green) | "All four gates green—this solution is ready for production" |
| Showing Adoption metrics | "47 projects onboarded, 12 in production, average onboarding: 11 days" |
| Showing Rule Coverage 87% | "87% automated governance—that's enterprise-grade" |
| Showing competitive gaps | "We lead here, they lead there, and here's our roadmap to close the gap" |
