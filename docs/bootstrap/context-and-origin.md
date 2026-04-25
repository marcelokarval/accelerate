# Context And Origin

## Purpose

This document captures the origin story and the already-completed work that led
to the creation of this repository.

This is historical provenance only. It is not current authority when it conflicts
with `AGENTS.md`, `README.md`, `SKILL.md`, `core/`, `skills/`, or other native
Accelerate surfaces.

It exists so a future session can answer:

- what `accelerate` already is
- what was already stabilized before extraction
- why a dedicated repository now makes sense
- which architectural framing was accepted before the extraction began

## Origin

`accelerate` started as the root orchestration skill for engineering work in
the Prop4You ecosystem.

It gradually evolved from a branch classifier into a visible control plane
responsible for:

- classifying trivial vs non-trivial work
- deciding whether prompt hardening is required
- choosing honest issue topology
- opening manager lanes
- deciding staffing shape and delegation budget
- governing bounded-agent optionality
- enforcing risk and proof ordering
- entering root-owned closure mode before `Done`

The maturity threshold was crossed when `accelerate` began to own not only the
run classification but also:

- agent ontology
- pooling model
- root vs bounded-agent authority boundaries
- issue topology policy
- risk-enforcement matrix
- promotion/parity protocol for runtime mirrors

At that point, treating it as "just another local skill" stopped being a good
fit.

## Why A Dedicated Repository Now Makes Sense

The decision to create this repository was based on the conclusion that
`accelerate` is better modeled as an opinionated platform than as a local
project artifact.

The most important insight was this:

- the right separation is not `Prop4You` vs `not Prop4You`
- the right separation is `core laws + adapters + profiles + overlays`

That means `accelerate` can keep a strong opinionated default stack while still
being adaptable to another project through onboarding, adapters, and profiles.

## Bootstrap-Time Upstream Sources

When this repository was created, the most mature source material lived in the
Prop4You workspace.

The paths below are origin records, not live dependencies. Do not use them as
governed inputs unless the material has been imported and adapted into this
repository.

Primary upstream locations:

```text
/home/marcelo-karval/Backup/Projetos/prop4you/prop4you-inertia/docs/codex-skill-seeds/skills/accelerate/
/home/marcelo-karval/Backup/Projetos/prop4you/prop4you-inertia/docs/architecture/accelerate-control-plane.md
/home/marcelo-karval/.codex/skills/accelerate/
```

Important upstream modules at bootstrap time included:

- root `SKILL.md`
- root `README.md`
- `references/codex-agents/*`
- `references/autoresearch-and-self-evolution.md`
- `references/prompt-hardening-gate.md`
- `references/issue-stack.md`
- `references/subagent-model.md`
- `references/executive-operating-matrix.md`
- `references/current-enforcement-surfaces.md`

## Stabilization Batches Already Completed

The following batches were completed before extraction planning started.

### P4Y-1162

- commit: `cab7399d`
- purpose:
  - formalize the macro operating protocol for `accelerate`
- result:
  - created the explicit macro-control-plane references for agent governance,
    issue topology, execution contracts, staffing, return contracts, and
    macro replay

### P4Y-1163

- commit: `6da662f2`
- purpose:
  - harden the macro control plane
- result:
  - closure semantics were made root-owned
  - design-contract lane ownership was clarified
  - risk enforcement was consolidated through a matrix model

### P4Y-1164

- commit: `bc19a967`
- purpose:
  - align the sandbox root `SKILL.md` with the new control-plane doctrine
- result:
  - added explicit agent optionality, pools, root-vs-future-agent rule,
    root-owned issue topology, risk enforcement, and root closure mode

### P4Y-1165

- commit: `982baf53`
- purpose:
  - create the sandbox `accelerate` README
- result:
  - established a living operational guide above the short root skill

### P4Y-1166

- commit: `35a87f08`
- purpose:
  - harden README doctrine
- result:
  - made prompt hardening and issue-driven mutation stack explicit
  - harmonized subagent doctrine with agent optionality
  - removed old public `MULTI-AGENT DEFAULT` drift

### P4Y-1167

- commit: `93cbb475`
- purpose:
  - harmonize remaining summary doctrine
- result:
  - removed remaining mandatory multi-agent wording from summary references
  - aligned public closure wording with root-owned closure mode

### P4Y-1168

- commit: `194eb71f`
- purpose:
  - promote sandbox `accelerate` into the runtime global mirror
- result:
  - sandbox and `~/.codex/skills/accelerate` reached parity
  - `accelerate-control-plane.md` was aligned with the hardened doctrine

## Accepted Architectural Reframing

The discussion that triggered this new repository produced a clearer framing
for extraction.

`accelerate` should be modeled as:

- `accelerate-core`
- `workflow-adapters`
- `stack-profiles`
- `runtime-adapters`
- `agent-factory`
- `onboarding`
- `project-overlays`

This is stronger than a narrow "move the skill into another repo" framing.

## Key Accepted Insights

### 1. Workflow backends are adapters

`linear` should not be treated as the only supported workflow backend.

The correct target is:

- same orchestration architecture
- same issue/state/label conventions at the conceptual level
- different operational adapters for systems such as:
  - `linear`
  - `github`
  - future `jira`

### 2. Runtime commands need an adapter layer

The important stable opinion is not the literal command text. The stable truth
is the capability and wrapper discipline.

Example:

- Python execution should think in terms of the project's runtime wrapper
- in the current dominant stack that wrapper is `uv`

### 3. Stack opinions are valid, but should be modeled as profiles

`accelerate` may be born strongly opinionated for a stack such as:

- Django
- Inertia
- React
- shadcn/ui
- Tailwind

That is not a contradiction with adaptability.

The opinion should live in default stack profiles, not in hardcoded platform
limits.

### 4. Documentation systems are optional adapters

The system may use Docusaurus opinionatedly, but Docusaurus should not be a
mandatory universal dependency of the platform.

### 5. Agent design is part of the platform

The current `codex-agents` module proves that `accelerate` already thinks about:

- when a future agent makes sense
- what families should exist
- what skill envelopes they should carry
- when a gap should remain only a suggestion

This capability should remain native to the platform.

### 6. Greenfield onboarding is a first-class capability

The platform should be able to land in a nearly empty repository and bootstrap:

- discovery
- A&Q
- executive planning
- recommended adapters
- recommended stack profile
- recommended runtime adapters
- recommended skills

This is not an afterthought. It is part of the product direction.

## What Has Not Happened Yet

This section records bootstrap-time state. It is intentionally stale relative to
the current standalone repository and must not be read as current status.

The following work has not yet happened inside this new repository:

- no actual extraction of upstream files
- no standalone package layout
- no adapter implementations
- no stack-profile directory structure
- no onboarding engine
- no SDD yet

This repository currently holds planning and transition context only.

## Constraint For The Next Phase

The next phase should not treat the Prop4You source tree as something to mirror
blindly.

The next phase must classify material into:

- core
- adapter
- profile
- overlay

That classification is the bridge from this context document into the SDD.
