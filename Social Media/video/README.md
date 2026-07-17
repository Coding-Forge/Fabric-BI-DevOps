# Video Package

This folder contains video production assets for **Enterprise BI DevOps with Microsoft Fabric**.

## Files

| File or folder | Purpose |
|---|---|
| `enterprise-bi-devops-storyboard.md` | Scene-by-scene storyboard |
| `enterprise-bi-devops-script.md` | Narration script |
| `scenes/index.html` | HTML scene deck used to capture frames |
| `scenes/frames/` | Generated PNG frames |
| `enterprise-bi-devops-demo.mp4` | Generated video output |
| `Build-EnterpriseBIDevOpsVideo.ps1` | Local build script for frames and MP4 |

## Build

From the repository root:

```powershell
.\Social` Media\video\Build-EnterpriseBIDevOpsVideo.ps1
```

The script starts from the HTML scene deck, captures each scene as a PNG frame, and uses Python video tooling to create the MP4 when available.

If Node.js/Playwright is not available, the script reuses existing frames under:

```text
Social Media/video/scenes/frames/
```

The generated MP4 is a visual-only video. Use `enterprise-bi-devops-script.md` for narration, voiceover, or speaker notes when producing a final version in PowerPoint, Clipchamp, Stream, or another video editor.

