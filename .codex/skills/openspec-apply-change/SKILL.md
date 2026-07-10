---
name: openspec-apply-change
description: Implement tasks from an existing OpenSpec change. Use when the user asks to start or continue implementation, complete change tasks, or apply an approved proposal.
---

# Apply An OpenSpec Change

Read `.claude/skills/openspec-apply-change/SKILL.md` as the workflow specification, then execute it with Codex tools.

On Windows PowerShell, run all CLI examples with `openspec.cmd`; use `openspec` on other shells.

## Codex Adaptation

- Determine the target change from the request or `openspec status`; do not guess when multiple active changes are ambiguous.
- Read all required artifacts and task instructions before editing.
- Use `update_plan` to track implementation progress.
- Implement tasks in dependency order, preserve unrelated user changes, and mark only completed tasks as done.
- Run focused verification after each meaningful group of changes and broader verification before completion.

Stop and report concrete blockers when required inputs or external dependencies are unavailable.
