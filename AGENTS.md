# Accelerate Repository Instructions

This repository is the standalone home of `accelerate`.

`accelerate` is not being treated here as a project-local helper. It is the
product, the control plane, and the subject of the architecture work.

## Root Workflow

Use `accelerate` as the root workflow classifier for engineering work in this
repository.

Do not classify engineering work outside `accelerate`.

For work in this repository, the root must preserve:

- prompt hardening when the request is ambiguous or multi-phase
- root-owned issue topology
- root-owned risk enforcement
- root-owned closure mode
- agent optionality

## Current Stage

This repository is in the standalone pre-agents phase.

The current source-of-truth stack for continuing work is:

1. [README.md](./README.md)
2. [docs/architecture/accelerate-pre-agents-baseline.md](./docs/architecture/accelerate-pre-agents-baseline.md)
3. [core/README.md](./core/README.md)
4. [adapters/workflow/README.md](./adapters/workflow/README.md)
5. [adapters/runtime/README.md](./adapters/runtime/README.md)
6. [onboarding/README.md](./onboarding/README.md)
7. [planning/README.md](./planning/README.md)
8. [docs/architecture/accelerate-sdd-v1.md](./docs/architecture/accelerate-sdd-v1.md)
9. [docs/architecture/accelerate-classification-matrix.md](./docs/architecture/accelerate-classification-matrix.md)
10. [docs/architecture/accelerate-migration-plan.md](./docs/architecture/accelerate-migration-plan.md)
11. [docs/architecture/accelerate-onboarding-model.md](./docs/architecture/accelerate-onboarding-model.md)

## Migration Rule

Do not mirror upstream material blindly.

Before structural migration or refactor, classify material as:

- core
- workflow adapter
- runtime adapter
- stack profile
- agent factory
- overlay

The current imported tree is intentionally close to the mature upstream shape.
That is a transition baseline, not proof that the current layout is the final
architecture.

## Root File Rule

`SKILL.md` belongs at repository root.

Do not bury the root skill under deeper package folders.

`README.md` is the richer operational guide.

`references/` preserve inherited doctrine and should remain readable while the
repo is being reorganized.

## Platform Direction

The accepted target architecture is layered:

- core
- workflow adapters
- runtime adapters
- stack profiles
- agent factory
- onboarding
- planning
- overlays

Preserve strong defaults while moving toward that architecture.

Do not weaken the root control plane in the name of flexibility.

## Workflow Backend Reality

This standalone repository does not yet have its own implemented workflow
adapter stack.

Until that exists:

- planning docs and architecture docs are the governing artifacts
- do not invent fake adapter behavior
- do not assume Linear is the permanent execution backend of this repository

When workflow adapters land here, the repo can adopt a stricter issue policy.

## Napkin Policy

Track only the durable repository napkin in:

- `.claude/napkin.md`

Do not commit temporary transition napkins.

Development-stage or migration-stage tactical notes belong in untracked dev
artifacts, not in the canonical napkin.

## Commit Discipline

Prefer bounded commits that reflect one architectural or migration slice.

When moving inherited doctrine:

- preserve traceability
- avoid mixing architecture, migration, and unrelated cleanup
- keep the repo teachable for a fresh session
