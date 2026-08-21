# Accelerate Repository Instructions

This repository is the standalone home of `accelerate`.

`accelerate` is not being treated here as a project-local helper. It is the
product, the control plane, and the subject of the architecture work.

## Self-Contained Authority

`accelerate` must be operationally self-contained.

For governed behavior, use only this repository as source of truth:

- `SKILL.md`
- `README.md`
- `core/`
- `adapters/`
- `profiles/`
- `onboarding/`
- `planning/`
- `skills/`
- `references/`

Do not rely on `~/.claude/skills`, `~/.codex/skills`, `~/.agents/skills`, or any
other user-home catalog as authority for this repository.

Runtime sync/export is allowed only as a generated deployment step from this
repository outward. If external material is useful, first import, adapt,
register, and enforce it inside this repository.

## Root Workflow

Use `accelerate` as the root workflow classifier for engineering work in this
repository.

Do not classify engineering work outside `accelerate`.

For work in this repository, the root must preserve:

- prompt hardening when the request is ambiguous or multi-phase
- root-owned issue topology
- root-owned risk enforcement
- root-owned closure mode
- Standing Multi-Agent V2 delegation discipline

## Standing Multi-Agent V2 Delegation Request

For `execution_route=orchestrated`, when execution was requested,
`TASKS_READY` was reached, and `collaboration.spawn_agent` exists, the root
MUST call `collaboration.spawn_agent` before any task-owned mutation. The user
does not need to repeat the delegation request.

The root MUST NOT execute task-owned scopes assigned to children. It retains
hardening, SDD/PRD/task graph, dispatch, fan-in, integration-only repairs,
review-of-review, promotion, and closure. A virtual packet or a
`single-threaded exception` does not satisfy physical dispatch when
collaboration is available; the exception is a blocking receipt, not
permission to execute.

Only these exceptions may waive the physical-dispatch gate:

- explicit user opt-out;
- collaboration unavailable; or
- spawn failed with operator-authorized degradation.

Planning-only work may stop at `TASKS_READY`. `direct-fast-path` and `scoped`
retain their proportionate rules. Portability without collaboration remains
valid, but is not a silent fallback when V2 collaboration exists.

Every child assignment must state `model`, `reasoning_effort`, and
`fork_turns`; default is `fork_turns=none`; only an explicit integer `1..5`
may override it.
Preserve the effective root selected by the session; Sol/medium is the
recommended root. Route Luna/low to research, Luna/medium to prescribed
mechanical work, Terra/medium to implementation/data/ops/QA/review, and
Sol/high only to high-stakes read-only work with a receipt.

## Cross-Runtime Bootstrap

The semantic delegation core is shared, but each runtime adapter decides its
native primitive, status, and enforcement. At `TASKS_READY`, dispatch physical
work only through an adapter that is both supported and callable. Blocked,
export-only, staged-only, and legacy adapters do not silently fall back. Root
retains fan-in, integration, review-of-review, promotion, and closure; runtime
model/quality classes are adapter mappings with effective receipts. Runtime
mirrors are projections of this repository, never source truth. See
`core/control-plane/cross-runtime-bootstrap.md`.

## Current Stage

This repository is in the standalone capability-portable phase.

The current source-of-truth stack for continuing work is:

1. [SKILL.md](./SKILL.md)
2. [README.md](./README.md)
3. [core/README.md](./core/README.md)
4. [docs/architecture/accelerate-pre-agents-baseline.md](./docs/architecture/accelerate-pre-agents-baseline.md)
5. [docs/architecture/accelerate-control-plane.md](./docs/architecture/accelerate-control-plane.md)
6. [adapters/workflow/README.md](./adapters/workflow/README.md)
7. [adapters/runtime/README.md](./adapters/runtime/README.md)
8. [onboarding/README.md](./onboarding/README.md)
9. [planning/README.md](./planning/README.md)
10. [docs/architecture/accelerate-sdd-v1.md](./docs/architecture/accelerate-sdd-v1.md)
11. [docs/architecture/accelerate-classification-matrix.md](./docs/architecture/accelerate-classification-matrix.md)
12. [docs/architecture/accelerate-migration-plan.md](./docs/architecture/accelerate-migration-plan.md)
13. [docs/architecture/accelerate-onboarding-model.md](./docs/architecture/accelerate-onboarding-model.md)

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

## External Model Lanes

Codex-native collaboration profiles remain on supported Codex model families.
DeepSeek V4 Flash and Gemini 3.7 Flash are governed external lanes defined in
`adapters/runtime/model-lanes/model-lanes.toml`; invoke them through the
repo-owned adapter, never by writing unsupported model IDs into Codex profile
TOML. Prompts travel on stdin, credentials remain runtime-local, and external
lane output returns to the Codex root for review and closure.

Do not weaken the root control plane in the name of flexibility.

## Design-System And Premium Corpus Rule

Design-system extraction, premium UI direction, anti-AI-template review, and
theme generation must use the repo-local design-system skill corpus.

Required local surfaces include:

- `skills/design-system/extract-html-design-system-v2/`
- `skills/design-system/apply-design-system-contract/`
- `skills/design-system/premium-design-benchmark-corpus/`
- `onboarding/local-workspace/check-design-system-artifact-consistency.sh`

Do not use external `popular-web-designs` or user-home premium design skills as
governing inputs. The local benchmark corpus must be the enforced source for
Benchmark Influence Maps, anti-template scoring, and premium/de-AI closure.

Premium design-system artifacts must preserve the `--ds-*` token API, include
`design-system.theme.css`, include `design-system.premium-theme.css` when
premium is in scope, include a Benchmark Influence Map, and prove one active
theme at a time instead of a simultaneous light/dark product composition.

## Workflow Backend Reality

This standalone repository does not yet have a complete implemented remote
workflow adapter stack.

It does have a local workflow adapter for `.accelerate/workflow/` status,
packets, and substitute evidence.

Until complete remote adapters exist:

- planning docs, architecture docs, and the local workflow adapter are the
  governing artifacts
- do not invent fake adapter behavior
- do not assume Linear is the permanent execution backend of this repository

When remote workflow adapters land here, the repo can adopt a stricter remote
issue policy.

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
