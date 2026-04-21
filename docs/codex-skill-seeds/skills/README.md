# Repo-Managed Skill Seeds

This directory is the repo-owned source of truth for governed Codex skills that
belong to the standalone `accelerate` ecosystem.

Changes should land here first and then be synchronized into:

- `~/.codex/skills/`

## Current Skills

| Skill | Purpose | Runtime mirror |
| --- | --- | --- |
| `extract-html-design-system-v2` | Extract a URL, local HTML file, or raw HTML reference into `docs/reference/design-system.html` so UI correction, recreation, or premium visual convergence can reuse concrete design-system evidence instead of inferred style. | `~/.codex/skills/extract-html-design-system-v2/` |

## Operating Rule

Do not introduce global-only governed skills for this repository.

When a skill becomes part of branch routing, proof expectations, or visual
contract extraction, update the relevant control-plane catalog in the same
mutation package.
