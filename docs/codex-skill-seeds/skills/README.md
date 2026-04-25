# Repo-Managed Skill Seeds

This directory is the historical seed source for governed Codex skills that
belong to the standalone `accelerate` ecosystem.

The active authoring source is now:

- `../../../skills/`

It is not the operational control-plane layer.

Operational doctrine for when a skill is used belongs under native Accelerate
layers such as `core/`, `agents/`, `adapters/`, `profiles/`, or `references/`.

Changes should not land here first anymore. They should land in root
`skills/`, then be exported to a runtime target only when export is explicitly
in scope.

Before a skill becomes mandatory in branch routing, persona routing, agent
envelopes, or proof lanes, register it in:

- `../../../skills/_registry/manifest.md`

## Current Skills

| Skill | Purpose | Operational module | Active local path |
| --- | --- | --- | --- |
| `extract-html-design-system-v2` | Extract a URL, local HTML file, raw HTML reference, or existing web app into `docs/reference/design-system.html`, `design-system.contract.md`, and implementable `design-system.theme.css` with stable `--ds-*` tokens; when premium improvement or humanization is in scope, extend the package with `design-system.slop-audit.md`, `design-system.premium-direction.md`, `design-system.premium-direction.html`, and `design-system.premium-theme.css`. Premium direction must use the repo-local benchmark corpus, include a Benchmark Influence Map, include broad component-gallery proof, prove one active theme at a time when themes exist, and remain theme-generator-ready when the local stack exposes shadcn/Radix-style primitives. | `core/review/html-design-system-extraction.md` | `../../../skills/design-system/extract-html-design-system-v2/` |
| `premium-design-benchmark-corpus` | Provide the self-contained anti-AI-template benchmark corpus for premium/de-AI design work, requiring benchmark choices to affect tokens, component families, state rules, layout rules, or forbidden patterns instead of acting as moodboard names. | `core/review/premium-interface-production.md` | `../../../skills/design-system/premium-design-benchmark-corpus/` |
| `apply-design-system-contract` | Apply existing `docs/reference/design-system*` artifacts as implementation law for new screens, UI correction, premium recomposition, proposals, and theme generation. The skill forces contract-first reading, source-vs-premium separation, generated theme CSS adoption, component mapping, anatomy/token separation, runtime proof, and residual drift registration so agents do not treat the design-system package as a loose moodboard. | `core/review/design-system-contract-application.md` | `../../../skills/design-system/apply-design-system-contract/` |

The former duplicated `SKILL.md` bodies in this transition directory were
removed after root `skills/` became authoritative. Use the active local paths
above or git history if the old transitional copies are needed for comparison.

## Operating Rule

Do not introduce global-only governed skills for this repository.

When a skill becomes part of branch routing, proof expectations, or visual
contract extraction, update the relevant control-plane catalog in the same
mutation package.
