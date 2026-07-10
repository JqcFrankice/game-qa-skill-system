---
name: openspec-propose
description: Create an implementation-ready OpenSpec change with proposal, design, specifications, and tasks. Use when the user wants to define a new feature or change before implementation.
---

# Propose An OpenSpec Change

Read `.claude/skills/openspec-propose/SKILL.md` as the workflow specification, then execute it with the tools available in Codex.

On Windows PowerShell, run all CLI examples with `openspec.cmd`; use `openspec` on other shells.

## Codex Adaptation

- Use `update_plan` for progress tracking where the source workflow names a task-list tool.
- Ask the user only when a critical requirement cannot be inferred safely.
- Use `openspec status` and `openspec instructions` as structured sources; do not infer artifact order.
- Create every artifact required by `applyRequires` and verify each output path.
- Keep OpenSpec context and rules as authoring constraints, not artifact content.

Finish by reporting the change path, created artifacts, and readiness for implementation.
