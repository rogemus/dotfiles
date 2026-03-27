# Objective

Analyze the most recently added commit on the current Git branch and generate
a concise, high‑quality summary of its changes.

The output MUST be formatted in Bitbucket Markdown and follow the structure
defined below.

# Context

This repository uses commit‑based summaries to document architectural and
behavioral changes. The summary will be consumed by humans and automated
systems, so it must be:

- Accurate
- High‑level (intent over implementation detail)
- Deterministic
- Free of speculation

Only the latest commit should be analyzed.

# Inputs

- Git repository (current branch)
- Last added commit (`HEAD`)

# Instructions

1. Inspect the latest commit and its diff.
2. Identify:
   - The problem being solved
   - The motivation for the change
   - The impact on behavior, build, or runtime
3. Extract a short list of concrete changes (files, configuration, behavior).
4. Ignore formatting-only or whitespace-only changes unless they affect behavior.
5. Do NOT include commit hashes, author names, or timestamps.

# Output Format

Produce **only** the following Markdown structure.

All content MUST be written in Bitbucket Markdown.

```md
## Summary

<High-level explanation of what changed and why.
Explain the intent and system impact in 2–4 sentences.>

### Changes:

- <Specific, actionable change 1>
- <Specific, actionable change 2>
- <Specific, actionable change 3>
  <Continue as needed>

<If relevant, include a short explanatory section clarifying behavior,
deployment, or asset flows. Use plain paragraphs or bullet points.>

### Preview

<Optional. Include links to dashboards, previews, cloud resources,
or artifacts introduced by the change.>
```
