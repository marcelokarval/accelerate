# Onboarding

Onboarding is a first-class layer of the standalone platform.

Its job is to help `accelerate` land in a repository with little or no prior
setup by discovering:

- workflow backend
- stack profile
- runtime adapters
- docs posture
- recommended skills
- future agent candidates

## Current Stage

The onboarding layer is already native in the `standalone pre-agents` phase.

That means onboarding is no longer only an architecture idea. It already has a
defined operating surface, and the first native implementation surface for the
project-local `.accelerate/` workspace now lives under:

- `local-workspace/`

## What Onboarding Must Already Do

At the current phase, onboarding must already be able to:

- frame discovery as a control-plane concern, not as an install wizard
- ask only the minimum questions that materially affect adapter/profile choice
- run deterministic repo-signal detection before asking humans or LLMs to infer
- produce an executive bootstrap plan
- recommend skills, adapters, profiles, and future agent candidates
- work in repos that still have no promoted agents

## What Onboarding Must Not Pretend Yet

At the current phase, onboarding must not pretend that it already has:

- a final persistence format
- a mandatory interactive wizard implementation
- a fully enforced workflow backend
- automatic agent promotion

The current layer is operationally real, but still architecturally conservative.

It now hands off explicitly into the native `planning/` layer rather than
ending inside onboarding itself.

## Operational Reading Order

For a fresh session using onboarding as an active layer, read in this order:

1. `../AGENTS.md`
2. `../SKILL.md`
3. `README.md`
4. `aq/question-set.md`
5. `discovery/discovery-contract.md`
6. `local-workspace/README.md`
7. `../planning/executive/README.md`
8. `../planning/executive/bootstrap-plan-template.md`
9. `recommendations/recommendation-model.md`

If the repo still needs wider rationale, continue into:

- `../docs/architecture/accelerate-onboarding-model.md`

Native pre-agents reading order:

1. `aq/question-set.md`
2. `discovery/discovery-contract.md`
3. `../planning/executive/bootstrap-plan-template.md`
4. `recommendations/recommendation-model.md`

## Current Output Contract

The onboarding layer should currently leave enough truth behind for another
session to continue without reconstructing first principles.

The minimum output is:

- discovered repo signals
- unresolved high-impact ambiguities
- selected or recommended workflow adapter
- selected or recommended runtime adapters
- selected or recommended stack profile
- selected or recommended docs posture
- recommended adjacent skills
- recommended future agent candidates
- executive bootstrap plan

That bootstrap plan is now canonically owned by:

- `../planning/executive/bootstrap-plan-template.md`

The first native product surface for emitting the project-local `.accelerate/`
workspace is:

- `local-workspace/`

The local-workspace surface now carries the minimum deterministic loop:

- emit
- detect signals
- classify
- reconcile reentry
- validate

## Root Consumption Contract

When a governed target repository is in scope, the root should read local
workspace truth in this order:

1. `.accelerate/state.yaml`
2. `.accelerate/onboarding/status.yaml`
3. `.accelerate/onboarding/decisions.yaml`
4. `.accelerate/planning/current-plan.md`
5. `.accelerate/agents/status.yaml`

The root should call the local-workspace reconciliation surface when:

- `.accelerate/` is absent and first local install is required
- onboarding truth is stale
- `reentry_status` is not clean
- stack, workflow, docs posture, or runtime posture changed materially

## Re-entry Rule

Onboarding is re-runnable.

Re-enter it when:

- the stack changes
- the workflow backend changes
- the docs posture changes
- the repo moves from pre-agents toward real agent promotion
- the current bootstrap assumptions are no longer honest

The architecture doc remains the wider design source:

- `docs/architecture/accelerate-onboarding-model.md`
