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
- agent optionality

## OMO-Slim Provenance Map

The current Codex agent topology selectively adapts the useful role boundaries
from [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim).
This is provenance, not delegated authority and not a claim that the two
runtimes are identical.

The machine-readable authority is
[`adapters/runtime/codex/logical-agent-topology.toml`](./adapters/runtime/codex/logical-agent-topology.toml).
Update that TOML and its validator first; keep this table as the compact human
view.

| Codex agent | Represents in OMO-Slim | Local adaptation |
| --- | --- | --- |
| `orchestrator` | `orchestrator` + absorbed `council` | Root orchestrates and closes; bounded independent reviewers supply council behavior. |
| `python-backend` | specialized `fixer` | Bounded Python/Django implementation. |
| `nextjs-frontend` | `fixer` + partial `designer` | Frontend implementation; design behavior requires accepted design authority. |
| `research` | `librarian` + `explorer` | Current-source research plus read-only repository discovery. |
| `reviewer` | `oracle` + bounded `council` | Skeptical review; root retains review-of-review. |
| `qa` | partial `observer` + `oracle` | Visual/media evidence inspection plus skeptical review; broader QA/runtime/browser proof is Codex-native. |
| `data-db` | specialized `fixer` | Bounded database design and SQL implementation. |
| `integrations-ops` | specialized `fixer` | Bounded MCP, integration, cache, payment, and operational implementation. |

There is intentionally no standalone local `designer`, `observer`, or
`council`. Their useful behavior is contained in the named specialists and root
governance. OMO-Slim prompts, hooks, wrappers, wildcard grants, and runtime
authority are not imported.

## Current Stage

This repository is in the standalone pre-agents phase.

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
