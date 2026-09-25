# Sparse Clone Guide

Use sparse clone profiles when you want to create a smaller project repository from Enterprise BI DevOps with Microsoft Fabric.

The recommended script for new project repos is:

```text
shared/scripts/Clone-SparseToolkitProfile.ps1
```

If you prefer a form-based experience on Windows, use:

```text
shared/scripts/Start-SparseCloneUI.ps1
```

It opens a PowerShell UI where users can fill in repository URL, destination, branch, platform, profile, and workshop inclusion before running the appropriate sparse clone script.

If you are on Linux, macOS, or WSL and prefer an interactive prompt instead of typing script arguments, use the bash equivalent:

```text
shared/scripts/start-sparse-clone-ui.sh
```

It asks the same questions (clone mode, repository URL, destination, branch, platform, profile, workshop inclusion), previews the resulting settings, and performs the sparse clone directly with `git`. It does not require PowerShell and reproduces the same profile/platform path selection logic as `Clone-SparseToolkitProfile.ps1` and the legacy platform scripts.

The UI separates:

- **Destination folder**: the parent folder where the new repo folder should be created.
- **New repo folder name**: the folder name for the sparse-cloned repository.
- **Final clone path**: the combined path passed to the sparse clone script.

It lets you choose:

- The CI/CD platform folder to include.
- Whether to use a minimal or standard toolkit profile.
- Whether to include workshop material.

## Toolkit script

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination <destination-folder> `
  -Platform AzDo `
  -Profile Standard
```

## PowerShell UI

Run the UI from the repository root:

```powershell
.\shared\scripts\Start-SparseCloneUI.ps1
```

The UI can run:

- `Clone-SparseToolkitProfile.ps1`
- `Clone-SparseAzDoProfile.ps1`
- `Clone-SparseGitHubProfile.ps1`
- `Clone-SparseGitLabProfile.ps1`

Use **Toolkit** mode when you want platform, profile, and workshop options. Use the platform-specific modes when you want the original platform profile behavior.

## Bash wizard (Linux / macOS / WSL)

Run the interactive wizard from the repository root:

```bash
./shared/scripts/start-sparse-clone-ui.sh
```

It mirrors the PowerShell UI's flow (clone mode, repository URL, destination, branch, platform, profile, workshop inclusion), shows a settings preview before running, and then performs the sparse clone natively with `git` — no PowerShell required. It follows the same rules as the underlying scripts:

- **Toolkit** mode applies the `Platform`/`Profile`/`IncludeWorkshop` selection logic from `Clone-SparseToolkitProfile.ps1`.
- **Azure DevOps**, **GitHub**, and **GitLab** modes reproduce the legacy platform-specific scripts' folder selections.
- The destination is left as a normal, non-sparse, standalone Git repository with a fresh initial commit and no source remote, exactly like the PowerShell scripts.

## Commit-safe clone behavior

The sparse clone scripts use sparse checkout only as a temporary file selection mechanism.

The final working directory is left as a **normal, non-sparse Git repository** containing only the selected profile files:

- Sparse checkout is used only to materialize the selected files.
- The temporary source clone metadata is removed.
- A fresh Git repository is initialized in the destination.
- The selected files are staged and committed as a new initial commit when Git identity is configured.
- No active remote points back to the parent repository.
- Users should create their own empty remote repo and add it with `git remote add origin <new-repo-url>`.

If Git `user.name` or `user.email` is not configured, the scripts leave the selected files staged so the user can make the initial commit after configuring Git identity.

The scripts also intentionally do **not** use partial clone blob filtering such as `--filter=blob:none`. This keeps the resulting workshop or toolkit working directory commit-safe after the source remotes are removed. If blob filtering is used and the source remote is removed, Git may be unable to resolve missing blob objects when users make their first commit in the cloned repo.

## Platform argument

| Platform value | Includes |
|---|---|
| `AzDo` | `azdo/` |
| `GitHub` | `.github/workflows/powerbi-ci.yml`, `.github/GITHUB_ACTIONS_SETUP.md` |
| `GitLab` | `gitlab/` |
| `All` | `azdo/`, `.github/workflows/powerbi-ci.yml`, `.github/GITHUB_ACTIONS_SETUP.md`, `gitlab/` |
| `None` | No CI/CD platform folder |

## Profile argument

| Profile | Includes | Excludes |
|---|---|---|
| `Minimal` | `README.md`, `shared/`, `docs/deployment/`, GCC High behavior doc, selected platform folder | `tools/`, `images/`, most `docs/`, `presentations/`, `powerpoint/`, workshop support files |
| `Standard` | `README.md`, `shared/`, `tools/`, `images/`, deployment walkthroughs, selected governance/docs assets, selected platform folder | Workshop folders unless `-IncludeWorkshop` is passed |

`Standard` is the default profile.

## Workshop material

Workshop material is excluded by default from the toolkit script.

Pass `-IncludeWorkshop` when you want to include the workshop docs, sample data, supporting reference docs, and slide material:

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination Fabric-AzDo-Workshop `
  -Platform AzDo `
  -IncludeWorkshop
```

`-IncludeWorkshop` adds:

```text
Supporting_Docs_For_Workshop.md
docs/workshops/
docs/delivery/
docs/architecture/
docs/faq.md
docs/Rules-Authoring-Guide.md
docs/sparse-clone-guide.md
presentations/
powerpoint/
```

## Common scenarios

### Minimal Azure DevOps toolkit repo

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination Fabric-AzDo-Toolkit `
  -Platform AzDo `
  -Profile Minimal
```

### Standard GitHub toolkit repo

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination Fabric-GitHub-Toolkit `
  -Platform GitHub
```

### GitLab toolkit repo with workshop material

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination Fabric-GitLab-Workshop `
  -Platform GitLab `
  -IncludeWorkshop
```

### Toolkit only, no CI/CD platform folder

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination Fabric-Toolkit `
  -Platform None
```

### All CI/CD platform folders

```powershell
.\shared\scripts\Clone-SparseToolkitProfile.ps1 `
  -RepoUrl <source-repo-url> `
  -Destination Fabric-All-Platforms `
  -Platform All
```

## Legacy platform scripts

The original platform-specific scripts remain available:

```text
shared/scripts/Clone-SparseAzDoProfile.ps1
shared/scripts/Clone-SparseGitHubProfile.ps1
shared/scripts/Clone-SparseGitLabProfile.ps1
```

Use those when you want the original platform profile behavior. Use `Clone-SparseToolkitProfile.ps1` when you want explicit control over toolkit profile, platform folders, and workshop material.

## Remote behavior

All sparse clone scripts create a fresh standalone repo with no source `origin` remote after checkout. The new repo contains only the selected files for the chosen profile.

Add your project repository remote before pushing:

```powershell
git remote add origin <new-project-repo-url>
git push -u origin main
```


