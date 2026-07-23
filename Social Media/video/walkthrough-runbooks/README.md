# Toolkit Walkthrough Runbooks

These runbooks provide detailed, step-by-step guidance for recording the Fabric BI DevOps Accelerator toolkit as a professional video walkthrough or series.

**Who should use these:** Anyone recording educational content about the toolkit—whether for YouTube, internal training, customer workshops, or company documentation.

**Why use these runbooks:** Each runbook includes:
- Detailed narration scripts with business context, not just "click here"
- Realistic use-case scenarios that show why each tool matters
- Explanation of why each tool exists and what problem it solves
- Production tips for audio, video, and pacing
- Timing guidance to keep videos at optimal length
- Comprehensive checklists to ensure all key points are covered

## Recommended sequence

Record these in order. Each part assumes viewers have seen the previous part(s).

| Part | Runbook | Output video | Length | Focus |
|---:|---|---|---|---|
| 1 | [Standards and Quality Foundation](part-1-standards-quality.md) | `fabric-bi-devops-toolkit-part-1-standards.mp4` | 8–12 min | Enterprise policy, quality rules, DAX tests |
| 2 | [PBIP Review and PR Readiness](part-2-pbip-review.md) | `fabric-bi-devops-toolkit-part-2-review.mp4` | 10–15 min | Readiness checks, diffs, impact analysis, PR summaries |
| 3 | [Pipeline, Release, Governance, and Adoption](part-3-release-governance.md) | `fabric-bi-devops-toolkit-part-3-release-governance.mp4` | 10–15 min | CI/CD setup, exceptions, release readiness, metrics |

**Alternative:** Record as a single 20–30 minute video instead of a three-part series. See [toolkit-walkthrough-recording-runbook.md](../toolkit-walkthrough-recording-runbook.md) for full guidance.

## Before you start recording

### 1. Review the main runbook

Before recording any part, review the [main toolkit walkthrough runbook](../toolkit-walkthrough-recording-runbook.md) for:
- Environment setup
- Clipchamp recording process
- Post-production guidance
- Audio/video quality tips
- Troubleshooting common issues

### 2. Set up your environment

1. Start a local web server:

   ```powershell
   cd C:\Projects\Fabric-BI-DevOps-Demo
   python -m http.server 8000
   ```

2. Verify the toolkit loads at:

   ```text
   http://localhost:8000/tools/index.html
   ```

3. Prepare the sample PBIP folder for scanner demos:

   ```text
   C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local
   ```

4. Open Clipchamp and choose **Record & create → Screen**.

### 3. Prepare yourself

- **Read through the entire runbook** before recording. Memorize the flow, not the script.
- **Test your microphone** and speaker volume.
- **Mute notifications** (email, Slack, Teams, calendar alerts).
- **Close unrelated programs** to reduce distractions and CPU load.
- **Have the runbook open** on a second monitor for reference, or print it.

## Recording principles (applies to all parts)

### Narration

- **Speak to the problem, not the UI.** Don't say "click this button." Say "Now we need to define quality standards."
- **Use realistic language.** You're teaching practitioners, not reading a script. Be natural and conversational.
- **Explain the why, not just the how.** "This tool exists because governance needs flexibility during adoption" is better than "This tool lets you change rule severity."
- **Give use-case examples.** Real-world scenarios help viewers understand when and why to use each tool.
- **Mention artifact names explicitly.** "The generated Rules-Report.json file" instead of "the output file."

### Pacing

- **Slow down for important parts.** When you're explaining a key concept, take your time. Viewers will pause if they need to.
- **Pause on generated outputs.** Let viewers read Markdown, JSON, or YAML for 2–3 seconds before moving on.
- **Pause before transitions.** A 1–2 second pause between tools makes the edit smoother.
- **Don't apologize for mistakes.** If you stumble, pause recording, wait, and resume. Edit out the mistake later.

### Demo actions

- **Use starter examples where available.** Don't waste time configuring fields. Use "Use starter example" buttons to load pre-built data.
- **Don't explain every field.** Focus on the key fields that matter for the use case. Skip optional or advanced fields.
- **Show the output.** Always pause on generated Markdown, JSON, or YAML so viewers see what "done" looks like.
- **Use the launchpad to transition** between tools. This helps viewers understand how tools relate.

## After recording

1. **Import into your editor.** Clipchamp, Adobe Premiere, DaVinci Resolve, CapCut, or iMovie all work.

2. **Edit for pacing:**
   - Trim long pauses (over 3–4 seconds).
   - Cut out stumbles, corrections, or false starts.
   - Speed up slow parts if needed.

3. **Normalize audio** so volume is consistent throughout.

4. **Add transitions** at cuts to smooth the flow.

5. **Add a title card** at the start with the part name and duration.

6. **Add chapter markers** in the video description (timestamps for each major tool).

7. **Export as 1080p MP4** for broad compatibility.

## Video metadata template

When uploading to YouTube, LinkedIn, or other platforms:

```
Title: Fabric BI DevOps Accelerator Toolkit – Part [X]: [Part Name]

Description:
[Problem statement]

In this video, we walk through [list of tools] and show how they help with [use case].

⏰ Timestamps:
0:00 – Opening
1:30 – [Tool 1]
...

🔗 Resources:
• GitHub: [link to repo]
• Full documentation: [link]
• Main walkthrough: [link if this is part 2 or 3]

📌 What you'll learn:
• [key learning 1]
• [key learning 2]
• [key learning 3]

Tags: Power BI, Fabric, DevOps, CI/CD, governance, quality, tutorial
```

## Checklist for each part

Each runbook includes detailed checklists. Before ending your recording session, verify:

- [ ] All tools demonstrated
- [ ] Starter examples used
- [ ] Output artifacts shown and named
- [ ] Use-case scenarios explained
- [ ] Transitions are smooth
- [ ] Audio is clear
- [ ] Pacing is even (no long pauses, not rushed)
- [ ] Closing narration ties back to opening

## Troubleshooting

| Issue | Solution |
|---|---|
| Tools won't load | Verify `python -m http.server 8000` is still running and the port is correct. Check browser console for errors. |
| Sample PBIP not found | Verify the folder exists at `C:\Projects\Fabric-BI-DevOps-Demo\shared\pbip-local`. Adjust path if your clone is in a different location. |
| Audio is hard to hear | Increase microphone volume in Clipchamp settings. Speak closer to the microphone. Reduce background noise. |
| Video is hard to read | Ensure browser zoom is 100%. Use a higher monitor resolution if available. Slow down mouse movements. |
| Recording has long pauses | This is normal. Edit ruthlessly in post-production. Remove any pause over 3–4 seconds. |

## Additional resources

- [Main toolkit walkthrough runbook](../toolkit-walkthrough-recording-runbook.md) — Full guidance for single-video walkthrough
- [Toolkit README](../../tools/README.md) — Overview of all 15 tools
- [Power BI governance documentation](../../docs/governance/power-bi-governance-tools.md) — Deeper governance concepts

## Questions or suggestions?

If you record using these runbooks and have feedback or suggestions, please open an issue or submit a PR. Your experience helps improve these guides for the next person.



