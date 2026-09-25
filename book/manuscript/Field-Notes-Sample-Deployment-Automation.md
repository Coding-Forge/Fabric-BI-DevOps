# Chapter: Deployment Automation
## Illustrative Scenario: The Gateway That Didn't Follow the Promotion

<!-- EDITORIAL: relabeled from "Field Notes" to "Illustrative Scenario" per your instruction to apply the same honest labeling used in the other 8 chapters; this scenario is likewise a composite built from documented Fabric deployment-rule behavior, not a claim of one witnessed incident. -->

> **ILLUSTRATIVE SCENARIO — The Gateway That Didn't Follow the Promotion**
>
> The failure never showed up in Dev, and it never showed up in Test. It showed up at 6 a.m.
> the morning after a Prod promotion, when the first scheduled refresh on the newly promoted
> semantic model failed with a generic "data source credentials could not be validated" error —
> the kind of message that tells you nothing and costs you an hour anyway.
>
> The model hadn't changed. The report hadn't changed. What had changed was the environment
> underneath it: Dev, Test, and Prod each route through a different on-premises gateway cluster,
> each bound to its own SQL Server and database (`GW-Dev` / `SalesDB_Dev`, `GW-Test` /
> `SalesDB_Test`, `GW-Prod` / `SalesDB_Prod`). Fabric Deployment Pipeline gateway rules exist
> specifically to rebind that connection automatically at promotion time — server name, database
> name, and gateway data source all swapped in one step, no manual edit required.
>
> The rule was configured. It just wasn't configured for *this* semantic model — a second dataset
> had been added to the workspace after the original rule was authored, and deployment rules in
> Fabric are scoped per-artifact, not per-workspace. The pipeline promoted the artifact cleanly.
> It just kept pointing the new dataset at `sql-dev-01`, from Prod.
>
> Nothing in the validation stage caught it, because structural validation — the PBIP checks, the
> quality gates, the DAX metadata tests — has no visibility into deployment-pipeline rule
> bindings. That layer runs *after* everything this book has spent its earlier chapters
> hardening. It is a different trust boundary, and it needs its own verification step, not an
> assumption that "the pipeline handled it last time."
>
> **What changed after this:** a post-promotion smoke check — confirm the promoted dataset's
> active connection matches the expected gateway/server/database for that stage — became a
> required step before a Prod promotion is marked complete, not an optional nice-to-have.

**The pattern to take away:** deployment automation removes manual rebinding work, but it does
not remove the need to verify the rebinding happened for *every* artifact in the workspace, not
just the ones the rule was written against on day one. Any time a new dataset, report, or
dataflow is added to a workspace under an existing deployment pipeline, treat its gateway rule
coverage as a checklist item — not an inherited guarantee.

**Cross-reference:** see `docs/architecture/gateway-deployment-pipeline.md` for the full
environment inventory and rule configuration reference, and `docs/Troubleshooting.md` for the
broader "pipeline behaves differently per branch/stage" failure family this belongs to.
