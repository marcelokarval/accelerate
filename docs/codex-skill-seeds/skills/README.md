# Repo-Managed Skill Seeds

This directory is the historical seed source for governed Codex skills that
belong to the standalone `accelerate` ecosystem.

The active authoring source is now:

- `../../../skills/`

It is not the operational control-plane layer.

Operational doctrine for when a skill is used belongs under native Accelerate
layers such as `core/`, `agents/`, `adapters/`, `profiles/`, or `references/`.

Changes should not land here first anymore. They should land in root
`skills/`, then be synchronized into:

- `~/.codex/skills/`

Before a skill becomes mandatory in branch routing, persona routing, agent
envelopes, or proof lanes, register it in:

- `../../../skills/_registry/manifest.md`

## Current Skills

| Skill | Purpose | Operational module | Runtime mirror |
| --- | --- | --- | --- |
| `extract-html-design-system-v2` | Extract a URL, local HTML file, raw HTML reference, or existing web app into `docs/reference/design-system.html` plus `docs/reference/design-system.contract.md`; when premium improvement or humanization is in scope, extend the package with `design-system.slop-audit.md`, `design-system.premium-direction.md`, and `design-system.premium-direction.html`. Premium direction must include component coverage, broad component-gallery proof, light/dark token-sibling proof when themes exist, and theme-generator readiness when the local stack exposes shadcn/Radix-style primitives, so agents preserve source truth while improving weak AI-shaped design. | `core/review/html-design-system-extraction.md` | `../../../skills/design-system/extract-html-design-system-v2/` |
| `apply-design-system-contract` | Apply existing `docs/reference/design-system*` artifacts as implementation law for new screens, UI correction, premium recomposition, proposals, and theme generation. The skill forces contract-first reading, source-vs-premium separation, component mapping, anatomy/token separation, runtime proof, and residual drift registration so agents do not treat the design-system package as a loose moodboard. | `core/review/design-system-contract-application.md` | `../../../skills/design-system/apply-design-system-contract/` |

## Operating Rule

Do not introduce global-only governed skills for this repository.

When a skill becomes part of branch routing, proof expectations, or visual
contract extraction, update the relevant control-plane catalog in the same
mutation package.
