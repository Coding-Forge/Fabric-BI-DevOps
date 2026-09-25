# Preface

*Platform Development*
*For Enterprise Power BI and Microsoft Fabric*

*Platform Ops for Enterprise Data and Analytics* argued that infrastructure without an
operating model is just a pile of resources with a bill attached. This book makes the same
argument one layer up — for the reports, semantic models, and dataflows that actually run on
that platform.

I wrote *Platform Ops* out of the landing zones, RBAC boundaries, and release pipelines that
kept a data platform trustworthy. I wrote this book out of a different, more personal failure
mode: watching a well-governed platform get undone by a Power BI report published straight from
Desktop to Prod, with no validation, no test, and no record of what changed or why. The
platform was fine. The content running on it wasn't.

**Platform Development** exists because that gap — between a governed
platform and ungoverned content — is where most Fabric and Power BI programs actually lose
trust. Landing zones and RBAC solve *where* data and reports live. They don't solve *whether*
the report someone just promoted to Prod is structurally sound, tested, and traceable back to
an approved change. That's a separate discipline, and it deserves its own book instead of a
footnote in the first one.

This book is built directly from the `Fabric-BI-DevOps-Demo` solution — a working reference
implementation, not a hypothetical. Every pattern argued here is one I've implemented, broken,
and fixed. Where a chapter tells an Illustrative Scenario, that scenario is a composite built
from the repository's own documented troubleshooting patterns, not a claim that one incident
happened exactly as narrated; the fix that follows it is the fix the repository ships.

<!-- EDITORIAL: reworded from "that story happened" to describe Illustrative Scenarios as composites built from documented patterns, per your instruction to relabel Field Notes across the book and keep the Preface's claims consistent with that honesty standard. -->

Two readers will find themselves in these pages, often in the same chapter: the **report or
model author**, who lives in Power BI Desktop and cares about PBIP structure and quality gates,
and the **DevOps or platform engineer**, who owns the pipeline, the workspaces, and the release
evidence. I've tried to be explicit about which one a given section is written for, because
their failure modes — and their fixes — are rarely the same.

If *Platform Ops* was about earning trust in a platform, this book is about earning trust in
what runs on it, one governed release at a time.

— Brandon Campbell



