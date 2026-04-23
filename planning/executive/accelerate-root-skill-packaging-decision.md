# Accelerate Root Skill Packaging Decision

## Decision

Do not duplicate the root Accelerate skill under `skills/root/accelerate/`.

## Reason

This repository is the standalone home of Accelerate. Its root `SKILL.md` is the
product entrypoint and must remain at repository root. Copying it into the
generic skill catalog would create two apparent authorities for the control
plane.

## Packaging Model

- Root control plane: `SKILL.md`
- Portable global runtime bundle source: `global-runtime/accelerate/`
- Reusable governed skills: `skills/<category>/<skill>/`
- Historical migration manifest: `docs/codex-skill-seeds/skill-dependency-manifest.md`
- Runtime mirror: generated from repo-owned sources into `~/.codex/skills/`

## Rule

The root Accelerate skill is a root-native exception, not a missing local seed.
Changes to root workflow behavior should mutate root `SKILL.md` and supporting
core/references docs, then update the portable runtime bundle in
`global-runtime/accelerate/` and sync the generated mirror separately.
