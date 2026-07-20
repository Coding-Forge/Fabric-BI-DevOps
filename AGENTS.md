# Agent Instructions

Any AI agent, IDE assistant, or automation making changes in this repository must follow the [Repository Change Checklist](docs/repo-change-checklist.md).

Key requirements:

- Do not overwrite unrelated user changes.
- Keep toolkit and workshop material separate unless the task explicitly touches both.
- Update documentation and navigation surfaces when adding or changing tools.
- Update `docs/index.html` when GitHub Pages should expose the change.
- Update sparse clone scripts when new assets must be included in cloned toolkit profiles.
- Validate changed scripts and browser tools before reporting completion.
- When changing screenshots or video frames, verify the intended images are visibly rendered in the generated frame or screenshot, not just that the PNG or MP4 file exists.
- Do not commit secrets, tenant-specific IDs, customer data, or private PBIP artifacts.
- Leave the repository in a state that can be committed and rolled back cleanly.

