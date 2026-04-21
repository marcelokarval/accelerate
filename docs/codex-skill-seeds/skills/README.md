# Repo-Managed Skill Seeds

This directory is the repo-owned seed source for governed Codex skills that
belong to the standalone `accelerate` ecosystem.

It is not the operational control-plane layer.

Operational doctrine for when a skill is used belongs under native Accelerate
layers such as `core/`, `agents/`, `adapters/`, `profiles/`, or `references/`.

Changes should land here first and then be synchronized into:

- `~/.codex/skills/`

## Current Skills

| Skill | Purpose | Operational module | Runtime mirror |
| --- | --- | --- | --- |
| `extract-html-design-system-v2` | Extract a URL, local HTML file, raw HTML reference, or existing web app into `docs/reference/design-system.html` plus `docs/reference/design-system.contract.md`; when premium improvement or humanization is in scope, extend the package with `design-system.slop-audit.md`, `design-system.premium-direction.md`, and `design-system.premium-direction.html`. Premium direction must include component coverage and a broad component gallery when the local stack exposes shadcn/Radix-style primitives, so agents preserve source truth while improving weak AI-shaped design. | `core/review/html-design-system-extraction.md` | `~/.codex/skills/extract-html-design-system-v2/` |

## Operating Rule

Do not introduce global-only governed skills for this repository.

When a skill becomes part of branch routing, proof expectations, or visual
contract extraction, update the relevant control-plane catalog in the same
mutation package.
