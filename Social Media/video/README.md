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

