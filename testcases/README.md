# Testcase artifact manifest

Generated assets are retained for comparison, but only artifacts marked `candidate` should be considered for promotion to a reviewed final asset.

| Artifact | Format | Status | Related output | Notes |
| --- | --- | --- | --- | --- |
| `彩虹锦鲤测试用例_阶段2.md` | Detailed TC Markdown | draft | `彩虹锦鲤测试用例生成稿.xmind` | Historical generation draft; contains pre-current anti-merge patterns |
| `新版攻城战P0测试点.md` | P0 outline | intermediate | - | Planning list only; not a valid T08 or T10 final artifact |
| `新版攻城战P0测试点_XMind.md` | Detailed TC Markdown | draft | `新版攻城战P0测试点.xmind` | Structurally importable; requires anti-merge and wording review |
| `新版攻城战_S级测试点_T10_XMind.md` | T10 smoke Markdown | candidate | `新版攻城战_S级测试点_T10_XMind.xmind` | Current candidate for S-level smoke coverage |
| `新版攻城战_XMind测试点.md` | T10 smoke Markdown | legacy | - | Full historical extraction with S/A/B leaves |
| `新版攻城战_XMind测试点_S.md` | T10 smoke Markdown | legacy | - | Historical S-only filter before T10 refinement |

## Promotion rules

1. Detailed final assets must follow `TC -> step -> expected -> P0/P1/P2` and pass anti-merge review.
2. Smoke final assets must follow `test point -> S/A/B` and contain no detailed TC nodes.
3. A Markdown/XMind pair must be regenerated together after content changes.
4. Promote a candidate by changing its manifest status to `final` only after review and format validation.
5. Do not delete legacy artifacts until their replacement and lineage are recorded here.
