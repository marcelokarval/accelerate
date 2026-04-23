# `.accelerate/` Executive Plan V3: Broad Local Control Surface

## Purpose

Define the widened local installation of `.accelerate/` once a project needs a
larger persisted control surface.

This version is not the recommended first rollout. It is the natural target
state when local workflow, runtime, profile, and memory concerns become stable
enough to justify more explicit structure.

## Intended Use

Use `V3` when:

- the project already runs regularly under `accelerate`
- onboarding and planning are no longer the only local truths worth persisting
- workflow conventions need explicit local mapping
- runtime capability/proof posture must be persisted
- profile overrides matter
- local accelerate memory must outlive single plans

## Scope

`V3` persists everything from `V2`, plus:

- workflow adapter and conventions
- runtime adapters and capabilities
- active profile and local overrides
- project-local memory artifacts

## Target Shape

```text
.accelerate/
├── README.md
├── state.yaml
├── onboarding/
│   ├── status.yaml
│   ├── discovery.yaml
│   ├── decisions.yaml
│   └── executive-bootstrap-plan.md
├── workflow/
│   ├── adapter.yaml
│   ├── conventions.yaml
│   └── mapping.md
├── profiles/
│   ├── active-profile.yaml
│   └── local-overrides.yaml
├── runtime/
│   ├── adapters.yaml
│   ├── capabilities.yaml
│   └── proof-posture.yaml
├── planning/
│   ├── current-plan.md
│   ├── user-story.md
│   ├── prd-lite.md
│   ├── sdd.md
│   ├── executive-plan.md
│   ├── task-breakdown.md
│   ├── open-questions.md
│   └── history/
├── agents/
│   ├── status.yaml
│   ├── candidates.yaml
│   ├── gaps.yaml
│   └── promotion-readiness.md
└── memory/
    ├── decisions-log.md
    ├── assumptions.md
    └── repo-signals.md
```

## Why This Version Exists

`V3` is the first version where the project-local installation starts to feel
like a real local control surface rather than only a persisted bootstrap layer.

It is useful when the project needs stronger explicit continuity around:

- workflow backend conventions
- runtime and proof posture
- profile and override posture
- historical repository signals

## Additional Layer Contracts

### `workflow/`

This layer persists the selected workflow adapter and local conventions.

It should capture:

- chosen backend
- local mapping for labels or statuses when relevant
- local closure/review markers
- human explanation of that mapping

This is where the architecture of `linear` and `github` as sibling adapters can
be reflected per project.

### `profiles/`

This layer persists:

- active profile
- local deviations from the default profile

It should prevent a future session from assuming the default distribution when
the repo has already diverged from it.

### `runtime/`

This layer persists:

- active runtime adapters
- local capabilities
- proof posture

It is especially valuable when browser truth, persistent regression proof, or
stack-specific command capability cannot remain only implicit.

### `agents/promotion-readiness.md`

This file is for structured local thinking about whether a project is
approaching real promotion territory.

It must not be confused with:

- actual promotion
- installation
- runtime catalog existence

### `memory/`

This layer captures durable local governance memory that should not be
reconstructed from old plans every time.

Use it for:

- decision log
- long-lived assumptions
- recurring repo signals

Do not use it as a raw session dump.

## Trade-Offs

### Strengths

- strongest continuity between sessions
- explicit local control-plane footprint
- best support for long-lived repos
- best substrate for later subagent enforcement

### Costs

- more files to maintain
- greater risk of clutter if contracts are weak
- larger governance burden

## Upgrade Rule

Promote a project from `V2` to `V3` only when at least one of these becomes
recurring:

- workflow convention decisions
- runtime capability/proof decisions
- profile override decisions
- durable local memory needs beyond current planning

## Autonomy Rule

`accelerate` should still be highly autonomous in `V3`, but local constitutional
changes deserve stronger evidence before rewrite.

Examples:

- writing factual runtime capability state is safe
- rewriting historical assumptions should be more conservative
- promotion-readiness claims should be evidence-backed

## Success Criteria

`V3` succeeds when the project-local `.accelerate/` is strong enough that a
fresh session can operate with minimal implicit context, while still remaining
readable and intentionally structured for humans.

Its planning surface should stay aligned with the native standalone ladder:

- user story
- PRD-lite
- SDD
- executive plan
- task breakdown

The V3 difference is wider local control-surface persistence around workflow,
runtime, profiles, and memory, not a different planning model.
