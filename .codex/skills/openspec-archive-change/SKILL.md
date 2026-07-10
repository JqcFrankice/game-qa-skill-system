---
name: openspec-archive-change
description: Validate and archive a completed OpenSpec change. Use when the user asks to finalize a finished change, confirm completion, or move it into the archive.
---

# Archive An OpenSpec Change

Read `.claude/skills/openspec-archive-change/SKILL.md` as the workflow specification, then execute it with Codex tools.

On Windows PowerShell, run all CLI examples with `openspec.cmd`; use `openspec` on other shells.

## Codex Adaptation

- Identify the exact change and inspect its status, artifacts, and task completion.
- Run the required validation before archiving.
- Surface incomplete tasks, invalid specs, or unsynchronized changes instead of archiving prematurely.
- Use the OpenSpec CLI archive command defined by the source workflow.
- Verify the archived location and final status after the command completes.

Report what was archived and any residual validation risk.
