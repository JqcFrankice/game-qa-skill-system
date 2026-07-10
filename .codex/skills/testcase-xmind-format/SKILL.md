---
name: testcase-xmind-format
description: Format or validate game QA assets as XMind-importable Markdown. Use for detailed test cases with steps and expected results, or smoke test-point maps graded with S, A, and B.
---

# Format XMind Test Assets

## Choose One Format

### Detailed Test Cases

Read `.claude/skills/testcase-xmind-format/SKILL.md` and preserve its strict hierarchy:

```text
# feature
## module
### category
TC -> step -> expected result -> P0/P1/P2
```

Do not add a separate precondition node. Put the scenario condition into each step.

### Smoke Test Points

Read `qa/04_流程与工具能力/T10_XMind测试点书写规范.md` and preserve its hierarchy:

```text
# feature
## module
### category
test point -> S/A/B
```

Do not add steps, expected results, `TC-` identifiers, or P0 nodes to the smoke format.

## Validate Before Saving

- Keep one semantic node type at each level.
- Ensure every leaf has exactly one valid priority node for the selected format.
- Split different states, phases, pages, and validation targets into separate test points.
- Reject vague results such as "normal", "correct", or "as expected" in detailed cases.
- Save the Markdown under `testcases/` unless another output path is requested.
