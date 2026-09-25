# Introduction

*Platform Development*
*For Enterprise Power BI and Microsoft Fabric*

## The claim this book makes

BI DevOps with Fabric is the best default model for delivering Power BI and Fabric content
because it turns report and semantic model changes into a governed, evidence-backed release
process — the same rigor *Platform Ops* applies to infrastructure, applied one layer up to the
content that runs on it.

That is a falsifiable claim, not a topic. This book will show you what breaks when content
ships without that rigor, the operating model that prevents the break, and how to build it with
tools you can actually run today — against Azure DevOps, GitHub Actions, or GitLab CI/CD, as
equals.

## Why content needs its own trust chain

A governed platform answers questions like: which subscription, which workspace, which
identity, which network boundary. None of those questions tell you whether the semantic model a
report author just changed still passes its DAX tests, whether the PBIP folder structure is
valid, or whether the person who approved the Prod promotion can see *what* changed and *why*.

That's a different trust chain — one built from PBIP validation, quality gates, DAX testing,
deployment automation, and release evidence — and it's the subject of this book. Chapter by
chapter, it builds toward one continuous chain: **right structure → right quality → right
evidence → right release**, so that a promotion to Prod is never a leap of faith.

## Who this book is for

Two personas run through every chapter:

- **The report/model author** — works in Power BI Desktop, owns PBIP structure, DAX, and
  semantic model design. Cares about quality gates that catch problems before a pull request,
  not after a Prod incident.
- **The DevOps/platform engineer** — owns the pipeline, the workspace topology, RBAC, and the
  release evidence that makes a promotion auditable. Cares about parity across CI/CD platforms
  and about not being the last line of defense against bad content.

Most teams have both roles, sometimes in the same person. Each chapter marks which persona a
given section speaks to, especially where their concerns diverge.

## How each chapter is built

Every chapter in this book follows the same seven-part argument spine established in
*Platform Ops* — a claim, a failure mode, an operating model, a real implementation example,
trade-offs and lighter alternatives, evidence, and a reader decision checklist — plus four
additions specific to this book:

- **Illustrative Scenarios** — a narrated failure tied to the chapter's failure mode, reconstructed
  from the solution repo's own documented troubleshooting patterns and cross-referenced back to
  them; each is flagged as a composite, not a claim that one specific incident occurred exactly as
  written.

<!-- EDITORIAL: renamed "Field Notes" to "Illustrative Scenarios" and corrected the description from "a first-hand incident" to "reconstructed... composite," per your instruction to relabel these callouts across the book so the framing matches what they actually are. -->
- **Tool tie-in** — the specific no-code tool in the solution's `tools/` folder built to address
  that chapter's failure mode.
- **Platform-neutrality check** — every claim and example is verified against Azure DevOps,
  GitHub Actions, and GitLab CI/CD, or explicitly scoped when it isn't universal.
- **Freshness flag** — a "last verified" note on anything tied to fast-moving Fabric surface
  area, so preview features are never presented as settled fact.

## What you'll be able to do by the end

By the close of this book, you should be able to answer, for your own environment: is a report
or semantic model change validated, tested, and evidenced *before* it reaches Prod — and can you
prove it, after the fact, to someone who wasn't in the room when it happened. That's the bar
every chapter is building toward.



