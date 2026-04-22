# Using Superpowers Replacement Audit

## Decision

`using-superpowers` is not promoted into the standalone Accelerate skill tree.

## Reason

The global skill is a runtime-specific bootstrap discipline. It assumes a Skill
tool invocation model and a mandatory pre-response ritual that conflicts with
Accelerate's own root classifier, proportional workflow selection, and explicit
runtime packets.

## Replacement

Standalone Accelerate replaces it with:

- root `SKILL.md` as the classifier and operating entrypoint
- `skills/_registry/manifest.md` as the governed skill catalog
- `skills/_registry/sync-policy.md` as repo-first mirror policy
- `docs/codex-skill-seeds/skill-dependency-manifest.md` as migration audit trail

## Rule

Do not make `using-superpowers` a mandatory dependency for Accelerate. If a
future runtime needs compatibility with that behavior, implement it as a runtime
adapter overlay instead of a core skill.
