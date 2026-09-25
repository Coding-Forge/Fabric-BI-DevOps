# Platform Development

*For Enterprise Power BI and Microsoft Fabric*

This folder contains the working book project for the follow-up to *Platform Ops for Enterprise
Data and Analytics*, built from the `Fabric-BI-DevOps` solution.

## Current artifacts

- `assets/Platform-Enablement-Book-Cover-Designer.svg` / `.png`
  - **Current cover.** Vector rendition of the Microsoft Designer cover concept (icon badges,
    trust-chain layout), editable and print-safe at any size.
- `assets/Platform-Enablement.png`
  - Original Microsoft Designer raster concept this vector cover is based on.
- `assets/Platform-Enablement-BI-DevOps-Book-Cover.svg` / `.png`
  - Earlier cover concept, kept as a fallback.
- `assets/Fabric-BI-DevOps-Book-Cover.svg` / `.png`
  - Original cover concept, kept as a fallback.
- `manuscript/Field-Notes-Sample-Deployment-Automation.md`
  - Sample Illustrative Scenario callout for the Deployment Automation chapter.
- `manuscript/Preface.md`
  - Book preface.
- `manuscript/Introduction.md`
  - Book introduction.
- `manuscript/Table-of-Contents.md`
  - Draft table of contents (no page numbers yet).
- `manuscript/Chapter-01-*.md` through `manuscript/Chapter-09-*.md`
  - Chapter source drafts with Illustrative Scenarios, implementation walkthroughs, code samples,
    illustrations, platform comparisons, evidence, and decision checklists.
- `manuscript/docx/`
  - One styled Word document per chapter.
- `manuscript/pdf/`
  - One print-ready PDF per chapter; every chapter is at least 12 pages.

The existing cover concepts retain the earlier working-title artwork and should be retitled
before publication.

## Working title

**Platform Development**
*For Enterprise Power BI and Microsoft Fabric*


## Thesis

BI DevOps with Fabric is the best default model for delivering Power BI and Fabric content
because it turns report and semantic model changes into a governed, evidence-backed release
process — the same rigor Platform Ops applies to infrastructure, applied one layer up to the
content that runs on it.

## Manuscript approach

This book uses the shared chapter framework in [`../../WRITING-GUIDE.md`](../../WRITING-GUIDE.md),
plus the Book 2 additions: Illustrative Scenarios, tool tie-ins, platform-neutrality checks, freshness
flags, and the report-author/platform-engineer audience split. Read the writing guide before
drafting a chapter.

See [`manuscript/Preface.md`](manuscript/Preface.md), [`manuscript/Introduction.md`](manuscript/Introduction.md),
and [`manuscript/Table-of-Contents.md`](manuscript/Table-of-Contents.md) for the current
front-matter drafts.

## Proposed chapter list (draft)

1. PBIP Validation & Structure
2. Branching & Environment Strategy
3. Quality Gates (PBI Inspector / Tabular Editor BPA)
4. DAX Testing
5. Deployment Automation
6. Workspace & RBAC Governance
7. CI/CD Platform Parity (Azure DevOps / GitHub Actions / GitLab)
8. Release Evidence & Rollback
9. Adoption & Workshop Delivery

Illustrative Scenario source material largely already exists in the `Fabric-BI-DevOps-Demo` solution repo
(`docs/Troubleshooting.md`, `docs/faq.md`, `docs/architecture/*`, `docs/governance/*`) — most
chapters need narrative framing, not new raw content.


