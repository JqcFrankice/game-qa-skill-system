---
name: generate-testcase
description: Generate game QA test cases or test-point outlines from feature documents, OpenSpec artifacts, Excel files, configs, or existing cases. Use when the user requests detailed cases, P0 cases, smoke points, regression coverage, or XMind output.
---

# Generate Game QA Test Cases

## Load The Rules

Before generating content, read:

1. `qa/04_流程与工具能力/T08_测试用例生成规范.md`
2. `测试用例标准与示例汇总/测试用例标准.md`
3. `.claude/skills/generate-testcase/SKILL.md` as the full cross-platform workflow specification

If a required file is absent, report the missing path instead of silently replacing its rules.

## Select The Output Route

- For detailed executable cases, use T08. If XMind or Markdown import is requested, also use `testcase-xmind-format`.
- For smoke test points, review mind maps, regression-scope maps, or `S/A/B` grading, read and follow `qa/04_流程与工具能力/T10_XMind测试点书写规范.md`.
- Do not mix detailed `TC -> steps -> expected -> P0/P1/P2` leaves with smoke `test point -> S/A/B` leaves in one artifact.

## Execute The Workflow

1. Identify whether the source is a planning/config document or an OpenSpec proposal/design set.
2. For Excel input, create raw Markdown and normalized Markdown before analysis.
3. Load the relevant business and specialist QA documents from `qa/`.
4. Follow the staged confirmation workflow. On the first response, output only the feature decomposition tree unless the smoke-point route explicitly defines a narrower deliverable.
5. Never invent missing configuration values. Record them as pending confirmations.
6. Save completed artifacts under `testcases/` unless the user specifies another path.

Use available Codex planning, file, and terminal tools in place of tool names mentioned by another platform's workflow specification. Preserve all behavioral constraints.
