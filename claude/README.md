# claude

Claude Code skills, stowed into `~/.claude/skills/` (global: every repo).

| Skill | From | Invocation |
| --- | --- | --- |
| `grill-me` | Matt Pocock | `/grill-me` (manual) |
| `grilling` | Matt Pocock | auto, used by the grill skills |
| `grill-with-docs` | Matt Pocock | `/grill-with-docs` (manual) |
| `domain-modeling` | Matt Pocock | auto (glossary, ADRs) |
| `tdd` | Matt Pocock | auto (test-first) |
| `codebase-design` | Matt Pocock | auto (deep modules) |
| `improve-codebase-architecture` | Matt Pocock | `/improve-codebase-architecture` (manual) |
| `setup-matt-pocock-skills` | Matt Pocock | `/setup-matt-pocock-skills` (manual, once per repo) |
| `pr-quiz` | mine, after Geoffrey Litt | `/pr-quiz` (manual) |

Pocock's skills are copied unmodified from [mattpocock/skills](https://github.com/mattpocock/skills) at commit `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d` (MIT, see `LICENSE-mattpocock-skills`). Edit them freely; to update, re-copy from his repo and diff.

Heads-up: `/setup-matt-pocock-skills` edits the repo's `CLAUDE.md`/`AGENTS.md` and adds `docs/agents/`; `domain-modeling` adds `GLOSSARY.md` and ADRs. Both ask first.
