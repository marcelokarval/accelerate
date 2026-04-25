# Design-System Skills

This category owns the visual-design-system pipeline used by standalone
`accelerate`.

Current skills:

| Skill | Role |
| --- | --- |
| `extract-html-design-system-v2` | Extract URL/HTML/app visual evidence into a reusable local design-system package. |
| `apply-design-system-contract` | Apply an existing design-system package as implementation law for UI work. |
| `premium-design-benchmark-corpus` | Provide the repo-local anti-AI-template benchmark corpus and influence-map rules for premium UI work. |

The native operating modules are:

- `../../core/review/html-design-system-extraction.md`
- `../../core/review/design-system-contract-application.md`

Design-system work must be self-contained. Do not make governed extraction,
premiumization, or application depend on `~/.claude/skills`, `~/.codex/skills`,
or any other user-home skill catalog. Runtime exports may be generated from this
tree, but they are deployment artifacts, not authority.
