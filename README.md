# Accelerate

`accelerate` is being extracted into its own repository as an opinionated
agentic control-plane platform.

This repository is currently in the bootstrap planning phase. The goal of this
phase is not implementation yet. The goal is to preserve enough context,
decisions, and product direction that another session can continue the
extraction without depending on chat history.

## Current Status

- Local repository created at `~/Backup/Projetos/accelerate`
- Git initialized with branch `main`
- GitHub repository created at `marcelokarval/accelerate`
- Bootstrap planning documents established here before any structural
  extraction work

## Why This Repository Exists

`accelerate` grew beyond the shape of a local workflow skill.

It now acts as:

- root control plane
- issue topology engine
- manager-lane model
- risk-enforcement engine
- runtime packet system
- bounded-agent doctrine
- agent promotion and parity protocol
- onboarding and executive planning entrypoint

The strategic conclusion is that `accelerate` should be treated as a platform
with:

- core laws
- workflow adapters
- stack profiles
- runtime adapters
- onboarding logic
- agent-factory capabilities
- project overlays

## Bootstrap Reading Order

Read in this order:

1. [`docs/bootstrap/context-and-origin.md`](./docs/bootstrap/context-and-origin.md)
2. [`docs/bootstrap/decisions-and-final-state.md`](./docs/bootstrap/decisions-and-final-state.md)
3. [`docs/bootstrap/prd-initial-platform-foundation.md`](./docs/bootstrap/prd-initial-platform-foundation.md)
4. [`docs/bootstrap/sdd-handoff.md`](./docs/bootstrap/sdd-handoff.md)

## Bootstrap Deliverables

This repository now contains a bootstrap pack with:

- origin context from the Prop4You incubation path
- the sequence of already-completed stabilization batches
- final architectural decisions accepted so far
- the initial PRD for `accelerate` as a standalone platform
- an explicit handoff for generating the SDD next

## Source Of Truth At Bootstrap Time

At the moment this repository was created, the most mature authoring source of
truth still lived in the Prop4You workspace and its promoted runtime mirror.

Bootstrap-time upstream locations:

- sandbox source:
  - `/home/marcelo-karval/Backup/Projetos/prop4you/prop4you-inertia/docs/codex-skill-seeds/skills/accelerate/`
- canonical architecture:
  - `/home/marcelo-karval/Backup/Projetos/prop4you/prop4you-inertia/docs/architecture/accelerate-control-plane.md`
- promoted runtime mirror:
  - `/home/marcelo-karval/.codex/skills/accelerate/`

This repository exists to become the new first-class home of that system, but
the extraction should happen deliberately and in layers.

## Immediate Next Step

Generate the SDD from the PRD and decisions already captured here.

Do not start copying the full old tree into this repository blindly. The next
phase should classify what becomes:

- `core`
- `workflow adapter`
- `stack profile`
- `runtime adapter`
- `project overlay`

## Non-Goals Of This Bootstrap Pack

- no full extraction yet
- no blind file mirroring from Prop4You
- no `*.toml` agent generation yet
- no premature generalization that removes the current opinionated defaults
