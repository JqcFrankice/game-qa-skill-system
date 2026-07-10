---
name: openspec-explore
description: Explore ideas, requirements, architecture, risks, and unknowns before or during an OpenSpec change. Use when the user wants investigation or clarification rather than immediate implementation.
---

# Explore An OpenSpec Change

Read `.claude/skills/openspec-explore/SKILL.md` as the exploration workflow specification and adapt its tool names to Codex.

On Windows PowerShell, run all CLI examples with `openspec.cmd`; use `openspec` on other shells.

## Codex Adaptation

- Inspect the repository and relevant OpenSpec artifacts before forming conclusions.
- Separate known facts, inferences, risks, and open questions.
- Use diagrams or decision tables only when they clarify a real design choice.
- Do not implement changes unless the user explicitly transitions from exploration to implementation.
- When exploration resolves into a concrete change, recommend the appropriate propose or apply workflow.

Keep the result decision-oriented and grounded in repository evidence.
