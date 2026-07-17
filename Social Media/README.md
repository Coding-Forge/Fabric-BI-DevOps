# Social Media

This folder stores reusable marketing blurbs and short-form content for the Enterprise BI DevOps with Microsoft Fabric solution.

## Blog publishing

`Blog-Post.md` is the source of truth for the long-form blog article.

Blog posts use front matter for stable, date-stamped output:

```yaml
---
title: How Microsoft Fabric Teams Can Deliver Analytics Faster Without Losing Control
publishedDate: 2026-07-17
slug: enterprise-bi-devops-with-microsoft-fabric
---
```

Generate the Teams-friendly HTML page and PDF snapshot with:

```powershell
.\Social` Media\scripts\Publish-BlogPost.ps1
```

The generated files are written to:

```text
docs/blog/<publishedDate>-<slug>/
```

The generated folder includes:

```text
index.html
<slug>.pdf
assets/
```

Use `index.html` as the primary Teams/channel link when hosted through GitHub Pages or SharePoint. Use the PDF as a point-in-time attachment when a static artifact is needed.

Whenever `Blog-Post.md` or its images change, regenerate and commit the published HTML/PDF output. The `Publish Social Blog` GitHub Actions workflow checks that the committed generated output is current.

## Included Assets
- Blog-Post.md
- LinkedIn-Blurb.md
- LinkedIn-Post.txt
- Solution-Blurb.md
- Bluesky-Post.txt
- DevTo-Article.md
- HackerNews-Submission.txt
- Mastodon-Post.txt
- Medium-Article.md
- Microsoft-Tech-Community-Post.md
- Product-Hunt-Launch.txt
- Reddit-Post.md
- X-Thread.txt
- YouTube-Demo-Description.txt
- images/
