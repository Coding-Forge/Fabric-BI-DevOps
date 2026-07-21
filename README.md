# Enterprise BI DevOps with Microsoft Fabric

> **Version:** 1.1 | **Author:** Brandon Campbell | **Updated:** July 2026

Enterprise BI DevOps with Microsoft Fabric helps teams turn Power BI and Fabric delivery into a governed, repeatable engineering practice. It combines CI/CD patterns, quality gates, deployment guidance, no-code governance tools, and workshop-ready reference material for Microsoft Fabric and Power BI PBIP projects.

This repository is intentionally **platform-neutral**. The same BI DevOps approach can be run with Azure DevOps, GitHub Actions, or GitLab CI/CD.

## What this solution provides

| Area | Purpose |
|---|---|
| PBIP validation | Validate source-controlled Power BI project structure before merge or deployment |
| Quality gates | Run report and semantic model quality rules through PBI Inspector/Fab Inspector and Tabular Editor BPA |
| DAX test metadata | Define test cases for critical measures and publish CI-friendly results |
| Deployment automation | Deploy validated Fabric and Power BI artifacts to Dev or feature workspaces |
| Governance tooling | Generate and tune rule files, deployment manifests, readiness reports, and policy metadata |
| Workshop material | Provide labs, diagrams, and reference docs for adoption and enablement |

## Platform setup guides

Choose the CI/CD platform that matches your organization:

| Platform | Start here | Pipeline entry point |
|---|---|---|
| Azure DevOps | [azdo/README.md](azdo/README.md) | `azdo/azure-pipelines.yml` or `azdo/azure-pipelines_ci.yml` |
| GitHub Actions | [.github/GITHUB_ACTIONS_SETUP.md](.github/GITHUB_ACTIONS_SETUP.md) | `.github/workflows/powerbi-ci.yml` |
| GitLab CI/CD | [gitlab/README.md](gitlab/README.md) | `gitlab/gitlab-ci.yml` |
| Reusable Azure DevOps template | [shared/universal-pipeline/README.md](shared/universal-pipeline/README.md) | `shared/universal-pipeline/templates/fabric-ci.yml` |

Each platform follows the same core pattern:

```text
Validate PBIP structure
Prepare branch-aware quality rules
Run dataset and report quality checks
Run DAX test metadata
Publish validated artifacts
Deploy to Dev or feature workspaces when configured
```

## No-code accelerator tools

The `tools/` folder contains static browser tools that help teams manage BI DevOps artifacts without hand-editing JSON.

| Tool | Path | Purpose |
|---|---|---|
| Fabric BI DevOps Accelerator Launchpad | `tools/index.html` | Central entry point for all no-code tools |
| Enterprise Standards Builder | `tools/enterprise-standards-builder/index.html` | Generate report and dataset rule files from policy profiles |
| Quality Rule Designer | `tools/rule-designer/index.html` | Tune individual PBI Inspector/Fab Inspector and Tabular Editor BPA rules |
| DAX Test Builder | `tools/dax-test-builder/index.html` | Create measure-level DAX test metadata |
| Deployment Manifest Builder | `tools/deployment-manifest-builder/index.html` | Create readable deployment contracts for review and release |
| PBIP Project Readiness Scanner | `tools/pbip-readiness-scanner/index.html` | Scan a project before opening a pull request |
| PBIP Diff Viewer | `tools/pbip-diff-viewer/index.html` | Compare before/after PBIP snapshots and generate reviewer-friendly diff reports |
| Dependency Impact Analyzer | `tools/dependency-impact-analyzer/index.html` | Trace changed model objects to impacted measures, relationships, visuals, pages, tests, and governance assets |
| Pipeline Config Generator | `tools/pipeline-config-generator/index.html` | Generate Azure DevOps, GitHub Actions, or GitLab CI YAML from one PBIP delivery profile |
| PR Quality Summary Generator | `tools/pr-quality-summary-generator/index.html` | Create reviewer-friendly pull request summaries from validation and quality signals |
| Policy Exception Register | `tools/policy-exception-register/index.html` | Track rule exceptions with owner, reason, expiration, approval, artifact, and mitigation |
| Effective Rules Generator | `tools/effective-rules-generator/index.html` | Generate branch-aware effective rule files from baselines, overrides, and approved exceptions |
| CI/CD Platform Parity Matrix | `tools/platform-parity-matrix/index.html` | Compare Azure DevOps, GitHub Actions, and GitLab CI/CD support and gaps |
| Release Readiness Dashboard | `tools/release-readiness-dashboard/index.html` | Aggregate release evidence into a readiness score and release recommendation |
| Adoption Metrics Dashboard | `tools/adoption-metrics-dashboard/index.html` | Track adoption, platform usage, rule maturity, readiness scores, and time-to-onboard |
| Rule Coverage Matrix | `tools/rule-coverage-matrix/index.html` | Map governance policies to automated rules and manual checks |
| Competitive Differentiation Matrix | `tools/competitive-differentiation-matrix/index.html` | Score this solution against generic CI/CD samples, decks, accelerators, and public alternatives |

Use the Enterprise Standards Builder first for governance policy setup, then use the Quality Rule Designer for advanced tuning.

## Repository layout

```text
/
|-- azdo/                         Azure DevOps pipeline entry points and setup guide
|-- .github/                      GitHub Actions workflow and setup guide
|-- gitlab/                       GitLab CI/CD pipeline and setup guide
|-- shared/                       Platform-neutral CI/CD assets, scripts, tests, and rule files
|-- shared/universal-pipeline/    Optional reusable Azure DevOps template pattern
|-- tools/                        Static browser tools for governance and readiness artifacts
|-- docs/                         Architecture, governance, workshop, and adoption documentation
|-- presentations/                Workshop presentation source
`-- README.md                     Solution landing page
```

## Key documentation

| Topic | Link |
|---|---|
| Documentation hub | [docs/index.md](docs/index.md) |
| Workshop catalog | [docs/workshops/README.md](docs/workshops/README.md) |
| Workshop datasheet | [docs/delivery/workshop-datasheet.md](docs/delivery/workshop-datasheet.md) |
| Delivery guide | [docs/delivery/workshop-delivery-guide.md](docs/delivery/workshop-delivery-guide.md) |
| Core Fabric Git workshop | [docs/workshops/core-fabric-git/README.md](docs/workshops/core-fabric-git/README.md) |
| Toolkit workshop | [docs/workshops/accelerator-toolkit/README.md](docs/workshops/accelerator-toolkit/README.md) |
| Synthetic DIB sample data | [docs/workshops/sample-data/dib-supply-chain/README.md](docs/workshops/sample-data/dib-supply-chain/README.md) |
| Repository change checklist | [docs/repo-change-checklist.md](docs/repo-change-checklist.md) |
| CI/CD architecture | [docs/architecture/cicd-architecture.md](docs/architecture/cicd-architecture.md) |
| Branching strategy | [docs/architecture/branching-strategy.md](docs/architecture/branching-strategy.md) |
| Workspace strategy | [docs/architecture/workspace-strategy.md](docs/architecture/workspace-strategy.md) |
| Governance checklist | [docs/governance/governance-checklist.md](docs/governance/governance-checklist.md) |
| Accelerator tools overview | [docs/governance/power-bi-governance-tools.md](docs/governance/power-bi-governance-tools.md) |
| Tool walkthrough | [docs/tool-walkthrough.md](docs/tool-walkthrough.md) |
| Enterprise quality rules pattern | [docs/enterprise-quality-rules-pattern.md](docs/enterprise-quality-rules-pattern.md) |
| Differentiation scorecard | [docs/differentiation-scorecard.md](docs/differentiation-scorecard.md) |
| Sparse clone guide | [docs/sparse-clone-guide.md](docs/sparse-clone-guide.md) |
| Workshop support materials | [Supporting_Docs_For_Workshop.md](Supporting_Docs_For_Workshop.md) |
| Social/blog publishing assets | [Social Media/README.md](Social%20Media/README.md) |
| Published blog article | [docs/blog/2026-07-17-enterprise-bi-devops-with-microsoft-fabric/index.html](docs/blog/2026-07-17-enterprise-bi-devops-with-microsoft-fabric/index.html) |

## PBIP artifact guidance

PBIP artifacts are intentionally not committed in this reference repository. Bring your own PBIP files locally under:

```text
shared/pbip-local/
```

Keep reusable CI/CD assets in source control:

```text
shared/Rules-Report.json
shared/Rules-Dataset.json
shared/dax-tests.json
shared/platform-parity-matrix.json
shared/adoption-metrics.json
shared/rule-coverage-matrix.json
shared/competitive-differentiation-matrix.json
pbip-diff-report.html
pbip-diff-report.md
pbip-diff-report.json
dependency-impact-report.html
dependency-impact-report.md
dependency-impact-report.json
pipeline-profile.json
pipeline-setup-notes.md
shared/scripts/
shared/scripts/New-EffectiveQualityRules.ps1
shared/tests/
```

## Sparse clone presets

Use the sparse clone scripts when you want only the folders needed for a specific CI/CD platform:

| Profile | Script | Included folders |
|---|---|---|
| Azure DevOps | `shared/scripts/Clone-SparseAzDoProfile.ps1` | `azdo`, `shared`, `docs`, `tools`, `images` |
| GitHub Actions | `shared/scripts/Clone-SparseGitHubProfile.ps1` | `.github`, `shared`, `docs`, `tools`, `images` |
| GitLab CI/CD | `shared/scripts/Clone-SparseGitLabProfile.ps1` | `gitlab`, `shared`, `docs`, `tools`, `images` |
| Toolkit | `shared/scripts/Clone-SparseToolkitProfile.ps1` | Platform-specific folders plus either standard toolkit assets or minimal CI/CD assets. Workshop files are excluded unless `-IncludeWorkshop` is passed. |
| PowerShell UI | `shared/scripts/Start-SparseCloneUI.ps1` | Form-based Windows UI for running toolkit or platform-specific sparse clone scripts |

The clone scripts use sparse checkout only during setup. They finish by disabling sparse checkout and removing all source remotes, leaving a normal standalone repository. Create a new empty remote repository, then attach it with `git remote add origin <new-repo-url>`.

For detailed sparse clone scenarios, see [Sparse Clone Guide](docs/sparse-clone-guide.md).

To use a form-based Windows UI instead of typing arguments manually:

```powershell
.\shared\scripts\Start-SparseCloneUI.ps1
```

The UI lets users choose the destination parent folder and enter a new repo folder name separately, then runs the selected sparse clone script with the combined final path.

Example:

```powershell
.\shared\scripts\Clone-SparseAzDoProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination Fabric-AzDo
```

Toolkit-only clone with Azure DevOps pipeline assets and no workshop material:

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination Fabric-AzDo-Toolkit `
  -Platform AzDo `
  -Profile Minimal
```

`Minimal` includes only `README.md`, `shared/`, and the selected platform folder. It excludes `tools/`, `images/`, `docs/`, `presentations/`, `powerpoint/`, and workshop support files.

Standard toolkit clone with Azure DevOps assets, tools, screenshots, and governance docs, but no workshop material:

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination Fabric-AzDo-Toolkit `
  -Platform AzDo
```

`Standard` includes `README.md`, `shared/`, `tools/`, `images/`, selected governance/docs assets, and the selected platform folder. It excludes workshop folders unless `-IncludeWorkshop` is used.

Platform clone that also includes workshop material:

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination Fabric-AzDo-Workshop `
  -Platform AzDo `
  -IncludeWorkshop
```

`-IncludeWorkshop` adds `Supporting_Docs_For_Workshop.md`, `docs/workshops/`, delivery docs, architecture docs, workshop FAQ/reference docs, `presentations/`, and `powerpoint/`.

Toolkit clone with no CI/CD platform folder:

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination Fabric-Toolkit `
  -Platform None
```

Each sparse clone script removes the source `origin` remote after checkout so a team can add its own project repository remote before pushing.

## Contributing

Contributions are welcome when they improve the solution, clarify adoption guidance, or make the examples easier to adapt in real Fabric and Power BI environments.

Before making or submitting changes, follow the [Repository Change Checklist](docs/repo-change-checklist.md).

Good contributions include documentation fixes, safer validation rules, reusable pipeline improvements, clearer lab steps, and examples that help teams adopt the pattern on Azure DevOps, GitHub Actions, or GitLab CI/CD.

Do not commit tenant-specific IDs, secrets, tokens, real customer data, exported PBIP files that should remain local, or environment-specific values that belong in secure CI/CD configuration.

## Disclaimer

This repository contains workshop material and example automation code. The YAML pipelines, PowerShell scripts, validation rules, tests, and deployment examples are reference implementations and starting points only.

Before using any code from this repository in your own environment, review and adapt it for your tenant, workspace topology, security model, naming conventions, branch policies, and deployment process. Validate everything with non-production workspaces and test data first.



