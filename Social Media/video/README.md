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
| `narration.README.txt` | Placeholder instructions for creating `narration.wav` |
| `narration.wav` | Recorded narration audio; not included until you create it |
| `enterprise-bi-devops-demo-narrated.mp4` | Final narrated video; generated after audio is added |
| `toolkit-walkthrough-recording-runbook.md` | Clipchamp recording runbook and narration script for walking through all toolkit tools |
| `walkthrough-runbooks/` | Focused runbooks for recording the toolkit walkthrough as a three-part video series |
| `Build-EnterpriseBIDevOpsVideo.ps1` | Local build script for frames and MP4 |
| `Add-NarrationToVideo.ps1` | Adds a recorded narration track to the MP4 |

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

The current scene deck contains 19 scenes covering standards, rule tuning, DAX metadata, deployment manifests, PBIP readiness, PBIP diffing, dependency impact, pipeline generation, PR summaries, exceptions, effective rules, platform parity, release readiness, adoption metrics, governance coverage, differentiation, and the call to action.

When updating scene frames, confirm that the right-side screenshot or image is visibly rendered in each affected frame. A frame is not valid if it only shows a blank rectangle, broken image placeholder, or border where the screenshot should appear. For local captures, generate frames from a path that preserves relative image references and handles spaces in `Social Media` paths correctly.

## Toolkit walkthrough recording

For a live instructional recording of all browser tools, use:

```text
Social Media/video/toolkit-walkthrough-recording-runbook.md
```

The runbook explains how to start localhost, record with Clipchamp, use starter examples, and narrate each tool in workflow order.

For shorter recordings, use the focused runbooks:

```text
Social Media/video/walkthrough-runbooks/
```

## Add narration

`narration.wav` is not created automatically. Create it by recording the narration script:

```text
Social Media/video/enterprise-bi-devops-script.md
```

Save the recorded audio as:

```text
Social Media/video/narration.wav
```

### Option 1: Record with Windows Voice Recorder

1. Open `enterprise-bi-devops-script.md`.
2. Open **Windows Voice Recorder** or another audio recording app.
3. Read the script aloud.
4. Save or export the recording.
5. Convert/export it as WAV if needed.
6. Place it here:

   ```text
   Social Media/video/narration.wav
   ```

### Option 2: Record with PowerPoint or Clipchamp

1. Import `enterprise-bi-devops-demo.mp4`.
2. Record voiceover directly in PowerPoint or Clipchamp.
3. Export a narrated MP4.

This option does not require `Add-NarrationToVideo.ps1`.

### Option 3: Add an existing audio file to the generated MP4

After `narration.wav` exists, run this from the repository root:

```powershell
.\Social` Media\video\Add-NarrationToVideo.ps1 `
  -VideoPath "Social Media/video/enterprise-bi-devops-demo.mp4" `
  -AudioPath "Social Media/video/narration.wav" `
  -OutputPath "Social Media/video/enterprise-bi-devops-demo-narrated.mp4"
```

Then play the narrated output:

```powershell
Start-Process "Social Media/video/enterprise-bi-devops-demo-narrated.mp4"
```

If the narration is longer than the visual-only video, use:

```powershell
.\Social` Media\video\Add-NarrationToVideo.ps1 `
  -VideoPath "Social Media/video/enterprise-bi-devops-demo.mp4" `
  -AudioPath "Social Media/video/narration.wav" `
  -OutputPath "Social Media/video/enterprise-bi-devops-demo-narrated.mp4" `
  -LoopVideoToAudio
```

## Current expected file state

Before narration is recorded:

```text
enterprise-bi-devops-demo.mp4              exists
narration.wav                              missing until recorded
enterprise-bi-devops-demo-narrated.mp4     missing until generated
```

After narration is added:

```text
enterprise-bi-devops-demo.mp4
narration.wav
enterprise-bi-devops-demo-narrated.mp4
```

