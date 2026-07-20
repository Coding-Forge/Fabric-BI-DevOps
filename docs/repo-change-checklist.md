# Repository Change Checklist

Use this checklist for every repository change, regardless of whether the change is made by a person, an AI agent, an IDE, or a command-line workflow.

## Required checks for every change

- [ ] Confirm the change has a clear purpose and does not modify unrelated files.
- [ ] Review the current Git status before editing so existing unrelated changes are not overwritten.
- [ ] Update all relevant documentation for the change.
- [ ] Update `docs/index.html` when the GitHub Pages landing page should expose the change.
- [ ] Update `docs/index.md` when the documentation hub should expose the change.
- [ ] Update `README.md` when the root landing page, tool inventory, generated artifacts, or setup guidance changes.
- [ ] Update `tools/index.html` when a tool is added, removed, renamed, or repositioned.
- [ ] Update `tools/README.md` when a tool or generated artifact changes.
- [ ] Update `docs/governance/power-bi-governance-tools.md` when governance tooling changes.
- [ ] Update `TODO.md` when roadmap status, priorities, completed tools, or planned tools change.
- [ ] Update sparse clone scripts when new files or folders must be included for toolkit, platform, minimal, standard, or workshop profiles.
- [ ] Validate that existing tools still work and that new tools do not duplicate, obscure, or conflict with existing tools.
- [ ] Validate that generated files, rule files, scripts, and browser tools work as expected.
- [ ] Check that no secrets, tenant-specific IDs, tokens, customer data, or private PBIP artifacts were committed.
- [ ] Check that links point to the renamed repository and current GitHub Pages paths where applicable.
- [ ] Check that Markdown, HTML, JSON, YAML, and PowerShell files remain well-formed.
- [ ] Commit changes with a clear message so the repository can be rolled back if needed.

## Tooling changes

When adding or changing a tool:

- [ ] Add or update the tool under `tools/<tool-name>/`.
- [ ] Add or update the tool card in `tools/index.html`.
- [ ] Preserve the launchpad's tabbed navigation and avoid making the page require excessive scrolling.
- [ ] Add the tool to `tools/README.md`.
- [ ] Add the tool to the root `README.md` tool table.
- [ ] Add the tool to `docs/governance/power-bi-governance-tools.md`.
- [ ] Add generated artifacts to `tools/index.html`, `README.md`, and any relevant docs.
- [ ] Move the tool from planned to completed in `TODO.md` when it is working.
- [ ] Validate the tool locally in a browser.
- [ ] Confirm there are no browser console errors or warnings.

## Documentation changes

When adding or changing docs:

- [ ] Link new docs from `docs/index.md`.
- [ ] Link public or hosted docs from `docs/index.html` when useful for GitHub Pages visitors.
- [ ] Add root `README.md` links when the content is part of the core solution.
- [ ] Keep workshop material separate from toolkit material unless the change is explicitly workshop-related.
- [ ] If the change affects hosted/blog material, regenerate HTML and PDF outputs.
- [ ] If the change affects social material, use the most widely supported content format for the target platform.
- [ ] If the change affects screenshots, tool visuals, or video frames, regenerate the affected PNG/MP4 assets and verify the images are visibly rendered, not just that files were created.

## CI/CD and script changes

When changing pipelines or scripts:

- [ ] Validate PowerShell parsing for changed `.ps1` files.
- [ ] Run available local smoke tests for scripts.
- [ ] Confirm Azure DevOps, GitHub Actions, and GitLab implications are documented.
- [ ] Update platform-specific README files when setup, variables, runners, triggers, or behavior changes.
- [ ] Update `docs/sparse-clone-guide.md` if sparse clone behavior changes.
- [ ] Confirm branch-aware behavior still works for feature branches and protected branches.

## Sparse clone changes

When adding files, folders, tools, or docs that should be available in sparse clones:

- [ ] Decide whether the asset belongs in `Minimal`, `Standard`, `IncludeWorkshop`, or a platform-specific profile.
- [ ] Update `shared/scripts/Clone-SparseToolkitProfile.ps1` when the toolkit sparse clone should include the asset.
- [ ] Update platform-specific sparse clone scripts if their original behavior should include the asset.
- [ ] Re-test sparse clone behavior for at least:
  - [ ] `-Platform AzDo -Profile Minimal`
  - [ ] `-Platform AzDo`
  - [ ] `-Platform AzDo -IncludeWorkshop`
- [ ] Confirm workshop files are not included in toolkit-only clones unless `-IncludeWorkshop` is passed.

## Quality-rule changes

When changing rules or rule preparation:

- [ ] Confirm source rules and effective rules use the correct expected result shape.
- [ ] Confirm report rule `logType` behavior is intentional.
- [ ] Confirm protected branch promotion behavior is documented.
- [ ] Confirm dataset severity filtering is intentional.
- [ ] Update rule designer behavior if manual tool edits could corrupt rule output.
- [ ] Update exception and effective-rule documentation if override behavior changes.

## Publishing and hosted material changes

When changing blog or hosted social content:

- [ ] Update the Markdown source.
- [ ] Regenerate the hosted HTML and PDF outputs.
- [ ] Confirm generated assets are written to date-stamped folders.
- [ ] Confirm GitHub Pages links still resolve.
- [ ] Commit both the source and generated outputs.

## Video and screenshot changes

When changing video frames, scene decks, screenshots, or visual walkthrough assets:

- [ ] Regenerate screenshots for any new or changed tools.
- [ ] Regenerate affected video frames under `Social Media/video/scenes/frames/`.
- [ ] Confirm each updated frame shows the intended right-side screenshot/image, not a blank rectangle, broken image icon, or placeholder border.
- [ ] When rebuilding video from frames, confirm the MP4 uses the corrected frames.
- [ ] For frame captures from local HTML, use paths/URIs that preserve relative image resolution, especially for folders with spaces such as `Social Media`.
- [ ] Spot-check a contact sheet or representative frames before reporting completion.

## Final review before commit

- [ ] Run `git status` and review all changed files.
- [ ] Review diffs for unrelated changes.
- [ ] Confirm new files are intentionally tracked.
- [ ] Confirm deleted or renamed files are intentional.
- [ ] Commit with a message that explains the user-visible outcome.

