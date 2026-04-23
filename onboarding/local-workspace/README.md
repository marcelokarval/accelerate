# Local Workspace

This module is the first native implementation surface for the project-local
`.accelerate/` workspace.

Its job is not to make `.accelerate/` part of the standalone product repo.

Its job is to define, template, and emit the `.accelerate/` workspace into
governed target repositories.

## Current Stage

In the current `standalone pre-agents` phase, this module owns:

- the canonical V2 materialization surface
- the generation shape of the emitted `.accelerate/`
- drift-reconciliation rules between summary and detailed local state

It does not yet own:

- a V3 local control surface
- a native workflow adapter backend
- a runtime persistence registry
- a full automatic installer

## Reading Order

For the first real `.accelerate/` implementation, read in this order:

1. `../../AGENTS.md`
2. `../../SKILL.md`
3. `../../docs/architecture/accelerate-project-local-workspace-executive-plan-v2-small-and-useful.md`
4. `../../docs/architecture/accelerate-project-local-workspace-v2-contract.md`
5. `README.md`
6. `v2-materialization-contract.md`
7. `v2-drift-reconciliation.md`
8. `v2-template/.accelerate/README.md`
9. `emit-v2.sh`
10. `validate-v2.sh`

## Module Rule

This directory is the product-side definition of the local workspace.

The emitted `.accelerate/` tree belongs in governed target repositories.

Do not treat `onboarding/local-workspace/v2-template/.accelerate/` as a second
live source of truth for the standalone repo itself.

It is a materialization template.

## First Entrypoint

Use:

- `./onboarding/local-workspace/emit-v2.sh /path/to/target-repo`
- `./onboarding/local-workspace/validate-v2.sh /path/to/target-repo`

This emits the canonical V2 tree into a governed target repository without
pretending that onboarding decisions have already been filled.

The validator checks:

- required V2 files
- minimum key presence
- summary drift between `state.yaml` and detailed authorities
- local planning artifact ladder coherence
