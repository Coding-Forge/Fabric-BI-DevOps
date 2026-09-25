---
title: "GitHub Best Practices for Fabric Git Integration"
description: "Recommended GitHub repository policies, branching strategy, workspace topology, and team collaboration practices for Microsoft Fabric workspaces connected to GitHub."
---

# GitHub Best Practices for Fabric Git Integration

Use this guide when a Microsoft Fabric workspace is connected to a GitHub repository. The goal is to keep GitHub as the system of record, keep Fabric workspaces aligned to branch intent, and prevent unfinished report or semantic model changes from leaking into shared team workspaces.

This guidance assumes PBIP-style report and semantic model artifacts are stored in GitHub and validated by GitHub Actions or another CI/CD pipeline before merge or deployment.

---

## Recommended Operating Model

Use GitHub for source control and review. Use Fabric workspaces for live authoring, preview, and validation.

| Area | Recommendation |
|---|---|
| Source of truth | GitHub repository, protected `main` branch |
| Shared team workspace | Connected to `main` or an integration branch such as `develop` |
| Feature development | One short-lived branch plus one isolated Fabric feature workspace |
| Review gate | Pull request with required GitHub Actions checks |
| Promotion | Validate in GitHub first, then promote with Fabric deployment pipelines or controlled deployment automation |

Do not treat a shared Fabric workspace as the place for experimental work. If a change is not ready for review, it belongs in a feature branch and a feature workspace.

---

## Repository Structure

Keep the repository layout predictable so Fabric workspace Git settings, GitHub Actions, and local validation all point to the same content.

Recommended pattern:

```text
repo-root/
|-- .github/
|   |-- CODEOWNERS
|   |-- pull_request_template.md
|   `-- workflows/
|       `-- powerbi-ci.yml
|-- docs/
|-- shared/
|   |-- <project>.pbip
|   |-- <project>.Report/
|   |-- <project>.SemanticModel/
|   |-- Rules-Dataset.json
|   |-- Rules-Report.json
|   |-- scripts/
|   `-- tests/
`-- README.md
```

Best practices:

- Use one clear folder path for Fabric Git integration, such as `/projects`.
- Keep the same folder path across `main`, `develop`, and feature branches.
- Keep reusable validation assets in source control: rules, tests, scripts, and workflow YAML.
- Do not commit local caches, temporary exports, secrets, personal connection files, or tenant-specific values that belong in GitHub secrets or environment configuration.
- Prefer PBIP/TMDL artifacts for reviewable text diffs. Avoid using binary PBIX files as the primary collaboration format.

---

## GitHub Branching Strategy

Use a simple trunk-based model with short-lived feature branches.

Recommended branches:

| Branch | Purpose | Fabric workspace |
|---|---|---|
| `main` | Protected, deployable team baseline | Shared Dev workspace or release baseline |
| `develop` | Optional integration branch for teams that need a pre-main staging line | Shared integration workspace |
| `feature/<alias>-<topic>` | Isolated authoring and review | Personal or scoped feature workspace |
| `hotfix/<alias>-<topic>` | Urgent fix from `main` | Temporary hotfix workspace |

Branch naming examples:

```text
feature/bcampbell-sales-ytd
feature/jsmith-rls-update
feature/team-model-refactor
hotfix/bcampbell-refresh-error
```

Keep feature branches small. Large report redesigns, model refactors, and RLS changes should be split into reviewable increments when possible.

---

## Fabric Workspace Strategy for GitHub Branches

Each active branch should have a workspace that matches the branch's purpose.

Recommended workspace mapping:

| Workspace | Connected branch | Usage |
|---|---|---|
| `WS-Dev-<team>` | `main` or `develop` | Shared validated team baseline |
| `WS-Dev-<alias>` | `feature/<alias>-<topic>` | Personal feature development |
| `WS-Dev-<team>-<feature>` | `feature/<team>-<topic>` | Team feature or larger model change |
| `WS-Test-<team>` | Not usually Git-connected | Promotion target from Dev |
| `WS-Prod-<team>` | Not usually Git-connected | Production promotion target |

Workspace rules:

- Do not author directly in the shared Dev workspace unless the change is intentionally owned by the team and immediately committed.
- Connect feature workspaces to the feature branch, not to `main`.
- Use the same repository folder path in every workspace connection.
- Keep workspace names aligned to branch names so reviewers can find the live preview quickly.
- Delete or repurpose feature workspaces after the pull request is merged and the branch is deleted.
- Assign feature workspaces to the correct Fabric capacity and confirm capacity impact with the workspace owner for long-running work.

---

## GitHub Repository Policies

Use GitHub rulesets or branch protection rules for `main` and any long-lived integration branch.

Recommended branch protection:

- Require a pull request before merging.
- Require at least one reviewer approval; require two for semantic model, RLS, security, or production-impacting changes.
- Require approval from CODEOWNERS for owned areas such as semantic models, deployment scripts, or governance docs.
- Require status checks to pass before merge. At minimum, require the Power BI/Fabric validation workflow.
- Require branches to be up to date before merge when the project has frequent model or report conflicts.
- Require conversation resolution before merge.
- Require linear history or squash merge to keep `main` readable.
- Block direct pushes to protected branches.
- Block force pushes and branch deletion on protected branches.
- Dismiss stale approvals when new commits are pushed to the PR.

Recommended optional policies:

- Require signed commits if your organization already uses commit signing.
- Use required deployments or GitHub Environments if GitHub Actions deploys to Fabric workspaces.
- Restrict who can bypass branch protection.
- Enable secret scanning and push protection.
- Enable Dependabot alerts for workflow dependencies and helper tooling.

---

## Pull Request Standards

Every Fabric PR should be reviewable both as code and as a live workspace preview.

PR description should include:

- Summary of what changed and why.
- Link to the Fabric feature workspace.
- Screenshots for report layout or visual changes.
- Notes for semantic model changes, including measures, relationships, RLS roles, calculation groups, or data source changes.
- Testing performed, including GitHub Actions run, local validation, refresh check, and visual spot checks.
- Deployment or promotion notes, if the change affects Test or Prod.

Reviewer checklist:

- Confirm GitHub Actions validation passed.
- Review PBIP/TMDL diffs for unintended changes.
- Open the feature workspace and test the report experience.
- Check model changes for naming, format strings, descriptions, relationships, RLS, and refresh impact.
- Confirm no secrets, tenant IDs, workspace IDs, or personal paths were committed accidentally.
- Confirm the branch can be deleted and the feature workspace can be cleaned up after merge.

---

## Team Collaboration Practices

Use Fabric Source control deliberately. Workspace changes are live assets, so the team needs a rhythm for committing and reviewing them.

Recommended practices:

- Commit small, coherent changes from Fabric Source control with descriptive messages.
- Review outgoing changes before committing from a workspace.
- Pull incoming changes into the feature workspace after updating the branch from `main`.
- Coordinate before two people edit the same report page, semantic model table, measure group, or dataflow.
- Use issues or project boards to track ownership of report pages, model areas, and deployment tasks.
- Use PR comments for review feedback and GitHub Issues for follow-up work that should not block the current change.
- Keep `main` deployable. If a change is not ready, keep it in a feature branch.

For report-heavy work, assign page ownership during a sprint. For model-heavy work, assign table or subject-area ownership. This reduces noisy PBIP conflicts and makes review easier.

---

## Managing Conflicts

PBIP files are text-based, but conflicts can still happen when multiple people edit the same report page, model object, or metadata file.

Conflict guidance:

- Pull from `main` frequently into long-running feature branches.
- Resolve conflicts in GitHub or locally, then update the Fabric feature workspace from Source control.
- Prefer smaller PRs over large report rewrites.
- Avoid parallel edits to the same report page when possible.
- For semantic models, coordinate changes to shared measures, relationships, roles, and calculation groups.
- After resolving conflicts, open the feature workspace and verify the report and model still load correctly.

If conflict resolution is risky, create a fresh feature workspace from the resolved branch and validate the PBIP project there before requesting final review.

---

## GitHub Actions and Validation

Use GitHub Actions as the minimum quality gate for GitHub-hosted Fabric projects.

Recommended checks:

- PBIP structure validation.
- Dataset quality rules.
- Report quality rules.
- DAX or semantic model unit tests where available.
- Artifact publication for traceability.
- Optional deployment to a non-production workspace when your GitHub workflow is approved for deployment automation.

Branch-aware validation is recommended:

- Feature branches should get fast feedback without blocking every advisory issue.
- PRs targeting `main` or `develop` should enforce stricter rules.
- Protected branches should require all relevant status checks to pass.

Store secrets in GitHub Actions secrets or GitHub Environments. Do not place tenant IDs, app secrets, connection strings, or workspace-specific values directly in PBIP files or workflow YAML unless they are intentionally non-sensitive examples.

---

## Security and Access Control

GitHub and Fabric permissions should reinforce each other.

Recommended controls:

- Use GitHub teams for repository access rather than granting permissions to individuals one by one.
- Grant least privilege in Fabric workspaces. Developers need Contributor or Member only where they author; reviewers may only need Viewer or Member depending on preview needs.
- Use service principals for automation, not personal accounts.
- Store service principal secrets in GitHub Secrets or environment-scoped secrets.
- Rotate secrets on a schedule and after team membership or automation ownership changes.
- Keep production workspace access limited and separate from feature workspace access.
- Use sensitivity labels and endorsement policies consistently across promoted workspaces.

For GitHub Enterprise environments, align repository visibility, audit logging, SSO, and organization rulesets with your Fabric governance model.

---

## Recommended CODEOWNERS Pattern

Use CODEOWNERS to route reviews to the right people.

Example:

```text
# Semantic model and dataset governance
/shared/**/*.SemanticModel/ @org/bi-model-owners
/shared/**/Rules-Dataset.json @org/bi-governance

# Report design
/shared/**/*.Report/ @org/report-reviewers
/shared/**/Rules-Report.json @org/bi-governance

# Automation and deployment
/.github/workflows/ @org/devops-owners
/shared/scripts/ @org/devops-owners
/shared/tests/ @org/devops-owners

# Documentation
/docs/ @org/bi-enablement
```

Adjust teams and paths to match your repository layout.

---

## Pull Request Template Example

Use a PR template to make Fabric reviews predictable.

```markdown
## Summary
- 

## Fabric Workspace Preview
- Feature workspace:
- Branch:

## Changed Areas
- [ ] Report pages or visuals
- [ ] Semantic model tables, measures, or relationships
- [ ] RLS/OLS/security
- [ ] Data source or refresh behavior
- [ ] Pipeline, script, or validation rule
- [ ] Documentation only

## Validation
- [ ] GitHub Actions passed
- [ ] Feature workspace updated from branch
- [ ] Report opened and spot-checked
- [ ] Semantic model refresh or test completed, if applicable
- [ ] No secrets, tenant-specific IDs, or local paths committed

## Screenshots or Notes

```

---

## Cleanup Checklist

After merge:

- Squash merge the PR into `main`.
- Delete the feature branch.
- Delete or reset the feature workspace.
- Confirm the shared Dev workspace is updated from `main` or from the validated deployment artifact.
- Confirm downstream deployment pipeline promotion is ready for Test or Prod.
- Close related issues or create follow-up issues for deferred work.

---

## Summary Recommendations

- Protect `main` and require PRs.
- Pair every feature branch with an isolated Fabric feature workspace.
- Require GitHub Actions validation before merge.
- Use CODEOWNERS for model, report, governance, and automation ownership.
- Keep workspace folder paths consistent across branches.
- Keep secrets and tenant-specific configuration out of source control.
- Review both the Git diff and the live Fabric workspace before approving.
- Clean up branches and workspaces after merge.
