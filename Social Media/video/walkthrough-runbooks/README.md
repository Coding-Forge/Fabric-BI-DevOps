# Toolkit Walkthrough Runbooks

Use these runbooks when recording the toolkit walkthrough as a short video series instead of one long recording.

## Recommended sequence

| Part | Runbook | Output video | Focus |
|---:|---|---|---|
| 1 | [Standards and Quality Foundation](part-1-standards-quality.md) | `fabric-bi-devops-toolkit-part-1-standards.mp4` | Launchpad, Enterprise Standards Builder, Quality Rule Designer, DAX Test Builder |
| 2 | [PBIP Review and PR Readiness](part-2-pbip-review.md) | `fabric-bi-devops-toolkit-part-2-review.mp4` | Deployment Manifest Builder, PBIP Readiness Scanner, PBIP Diff Viewer, Dependency Impact Analyzer, PR Quality Summary Generator |
| 3 | [Pipeline, Release, Governance, and Adoption](part-3-release-governance.md) | `fabric-bi-devops-toolkit-part-3-release-governance.mp4` | Pipeline Config Generator, exceptions, effective rules, platform parity, release readiness, adoption, coverage, differentiation |

## Shared setup

Before recording any part:

1. Start localhost from the repo root:

   ```powershell
   cd C:\Projects\Fabric-BI-DevOps-Demo
   python -m http.server 8000
   ```

2. Open:

   ```text
   http://localhost:8000/tools/index.html
   ```

3. Prepare the sample PBIP folder for scanner demos:

   ```text
   C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local
   ```

4. Open Clipchamp and choose **Record & create → Screen**.
5. Record the browser window or the full screen.
6. Export as 1080p MP4.

## Recording principles

- Keep each part focused and short.
- Use starter examples where available.
- Mention output artifacts by name.
- Do not explain every field.
- Use the launchpad workflow to transition between tools.
- Pause briefly on generated Markdown/JSON/YAML outputs.

