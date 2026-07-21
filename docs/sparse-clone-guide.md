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

## Commit-safe clone behavior

The sparse clone scripts use a normal Git clone followed by sparse checkout. They intentionally do **not** use partial clone blob filtering such as `--filter=blob:none`.

This keeps the resulting workshop or toolkit working directory commit-safe after the script removes the source `origin` remote. If blob filtering is used and the source remote is removed, Git may be unable to resolve missing blob objects when users make their first commit in the sparse-cloned repo.

## Platform argument

| Platform value | Includes |
|---|---|
| `AzDo` | `azdo/` |
| `GitHub` | `.github/` |
| `GitLab` | `gitlab/` |
| `All` | `azdo/`, `.github/`, `gitlab/` |
| `None` | No CI/CD platform folder |

## Profile argument

| Profile | Includes | Excludes |
|---|---|---|
| `Minimal` | `README.md`, `shared/`, selected platform folder | `tools/`, `images/`, `docs/`, `presentations/`, `powerpoint/`, workshop support files |
| `Standard` | `README.md`, `shared/`, `tools/`, `images/`, selected governance/docs assets, selected platform folder | Workshop folders unless `-IncludeWorkshop` is passed |

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

All sparse clone scripts remove the source `origin` remote after checkout.

Add your project repository remote before pushing:

```powershell
git remote add origin <new-project-repo-url>
git push -u origin main
```


