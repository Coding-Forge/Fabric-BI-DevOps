# Writing Guide: How We Build a Sound Chapter

This is the shared argument standard for every book in this series. Book 1 (*Platform Ops for
Enterprise Data and Analytics*) established the base framework. Book 2 (*Platform Enablement: BI
DevOps with Fabric*)
adds to it. Future books should start here, use everything that still applies, and extend the
list — don't fork a new standard from scratch.

---

## The base framework (established in Book 1)

Every chapter argues one strong default, not universal dogma. The house style is: **make a
claim, show what breaks without it, show the model that prevents the break, prove it with a
real example, admit where it doesn't apply, back it with evidence, and hand the reader a
decision they can act on.**

A chapter is a complete argument only when it contains all seven parts, in this order:

1. **A claim** — the specific, falsifiable position this chapter is arguing for. Not a topic
   ("workspace governance") — a claim ("workspace ownership must be assigned to a person or
   team, not a platform").
2. **A failure mode** — what actually goes wrong without this claim in place. Concrete, not
   hypothetical.
3. **The operating model** — the pattern, process, or structure that prevents the failure mode.
   This is the reusable part the reader takes away.
4. **An implementation example** — a real, specific instance of the model applied. Code,
   config, a diagram, a walkthrough — something a reader could actually build from.
5. **Trade-offs and lighter alternatives** — where the strong default is overkill, what a
   smaller team or lower-risk context should do instead. This is what keeps the book honest and
   out of "one true way" territory.
6. **Evidence** — why the claim holds. Vendor documentation, first-hand outcomes, or
   documented incidents. Not just assertion.
7. **A reader decision checklist** — the concrete question(s) the reader should now be able to
   answer for their own environment.

**Verification requirement:** any claim tied to a specific platform behavior, API, licensing
tier, or compliance boundary (e.g., commercial vs. GCC High) must be checked against current
vendor documentation before publication — the underlying platforms move fast enough that
first-hand experience alone can go stale between drafting and print.

---

## Additions for Book 2 (*Platform Enablement: BI DevOps with Fabric*)

Book 2 sits closer to a living, actively maintained solution repo (`Fabric-BI-DevOps-Demo`) than
Book 1 did. That changes what "evidence" and "implementation example" need to include, and adds
new argument components.

8. **Illustrative Scenarios** — a narrated failure callout tied directly to the chapter's failure
   mode (see `books/fabric-bi-devops/manuscript/Field-Notes-Sample-Deployment-Automation.md` for
   the template). These are composites reconstructed from documented patterns, not accounts of a
   single witnessed incident, and must say so explicitly in-text; the raw factual/troubleshooting
   content they draw from stays single-sourced in the solution repo's `docs/Troubleshooting.md`,
   `docs/faq.md`, and `docs/architecture/*`. The book adds story and framing on top — it does not
   fork a second copy of the technical detail, and it does not claim first-hand evidentiary weight
   the underlying material doesn't support.

<!-- EDITORIAL: renamed "Field Notes" to "Illustrative Scenarios" and corrected "a first-hand incident callout" to describe these as composites that must disclose their reconstructed nature, per your instruction to relabel these callouts book-wide and per every chapter reviewer independently flagging this as the guide's least-honored requirement. -->

9. **Tool tie-in** — every chapter should name the specific no-code tool in the solution's
   `tools/` folder that addresses the failure mode being argued (e.g., the Dependency Impact
   Analyzer exists because of a specific rollback failure). This is both a differentiation
   argument and a way to keep the book grounded in something a reader can actually go run.

10. **Platform-neutrality check** — the solution explicitly supports Azure DevOps, GitHub
    Actions, and GitLab CI/CD as equals. Any claim or example must either hold across all three,
    or be explicitly scoped ("this pattern is universal; this YAML is Azure DevOps-specific, see
    the parity matrix for the GitHub/GitLab equivalent"). Never let one platform's syntax stand
    in silently for "how this works everywhere."

11. **Freshness flag** — Fabric's product surface changes quickly (preview features, API and
    licensing shifts). Each chapter carries a "last verified" note, and anything still in
    preview/GA-pending is labeled as such rather than presented as settled fact.

12. **Audience split** — Book 1's reader was a platform/infra engineer end to end. Book 2 has
    two readers in the same book: the **report/model author** (works in Power BI Desktop, cares
    about PBIP structure and quality gates) and the **DevOps/platform engineer** (owns the
    pipeline, workspaces, and release evidence). Each chapter should be explicit about which
    persona a given section is written for, especially where their concerns diverge (e.g., a
    report author doesn't need gateway-cluster networking detail, a platform engineer doesn't
    need PBIP folder-structure basics).

---

## Quick chapter checklist (use before calling a chapter "done")

- [ ] Claim is specific and falsifiable, not a topic label
- [ ] Failure mode is concrete (ideally sourced from a real incident or documented pattern)
- [ ] Operating model is reusable, not one-off advice
- [ ] Implementation example is buildable, not illustrative-only
- [ ] Trade-offs/lighter-path section exists and isn't an afterthought
- [ ] Evidence cites vendor docs, first-hand outcomes, or incidents — not just assertion
- [ ] Reader decision checklist is concrete and answerable
- [ ] *(Book 2+)* Illustrative Scenario callout present, labeled as a composite, and
      cross-referenced to the solution repo
- [ ] *(Book 2+)* Relevant tool(s) named

<!-- EDITORIAL: updated the checklist to drop the "real Field Note" phrasing and require the Illustrative Scenario callout to explicitly disclose that it's a composite, per your instruction to relabel these callouts and keep the checklist consistent with the new terminology. -->
- [ ] *(Book 2+)* Platform-neutrality confirmed or explicitly scoped
- [ ] *(Book 2+)* Freshness/preview status noted
- [ ] *(Book 2+)* Audience (report author vs. platform engineer) is clear per section
