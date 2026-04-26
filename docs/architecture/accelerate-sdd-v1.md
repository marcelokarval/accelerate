# Accelerate SDD v1

## Document Status

- status: draft baseline
- phase: post-bootstrap architecture definition
- source inputs:
  - `docs/bootstrap/context-and-origin.md`
  - `docs/bootstrap/decisions-and-final-state.md`
  - `docs/bootstrap/prd-initial-platform-foundation.md`
  - `docs/bootstrap/sdd-handoff.md`
- date: 2026-04-15

## Purpose

This document is the first software design document for the standalone
`accelerate` repository.

Its job is to define how the existing mature system should be extracted from
the Prop4You incubation environment into a layered standalone platform without
losing the opinionated defaults and root laws that already make it valuable.

## Scope

This SDD covers:

- target repository architecture
- platform layer boundaries
- migration strategy
- onboarding system shape
- planning system shape
- workflow adapter shape
- runtime adapter shape
- stack profile shape
- agent-factory shape
- documentation architecture

This SDD does not yet implement those layers.

## Design Drivers

The design is constrained by the following accepted truths:

1. `accelerate` is already more than a local skill bundle.
2. The root control plane must remain explicit and strong.
3. Agents are optional and subordinate.
4. Extraction must be layered, not mirrored.
5. Strong defaults are part of the product value.
6. Greenfield onboarding is first-class.

## Architectural Thesis

`accelerate` should be designed as an opinionated platform with these layers:

- `core`
- `workflow adapters`
- `runtime adapters`
- `stack profiles`
- `agent factory`
- `onboarding`
- `planning`
- `project overlays`

The dominant default distribution can remain deeply aligned with the current
stack while still allowing the system to adapt to another project through
guided onboarding.

## Target Repository Shape

```text
accelerate/
├── README.md
├── SKILL.md
├── docs/
│   ├── bootstrap/
│   └── architecture/
├── core/
│   ├── control-plane/
│   ├── hardening/
│   ├── issue-topology/
│   ├── lanes/
│   ├── risk/
│   ├── closure/
│   └── runtime-packets/
├── adapters/
│   ├── workflow/
│   │   ├── linear/
│   │   └── github/
│   ├── runtime/
│   │   ├── python-uv/
│   │   ├── node/
│   │   ├── chrome-devtools/
│   │   └── playwright/
│   └── docs/
│       └── docusaurus/
├── profiles/
│   ├── django-inertia-react/
│   ├── nextjs-tailwind/
│   ├── nextjs-prisma/
│   ├── nextjs-drizzle/
│   └── nextjs-adonis-adminjs/
├── agents/
│   ├── doctrine/
│   ├── envelopes/
│   ├── templates/
│   └── promotion/
├── onboarding/
│   ├── aq/
│   ├── discovery/
│   └── recommendations/
├── planning/
│   ├── executive/
│   ├── architecture/
│   ├── migration/
│   ├── onboarding/
│   └── promotion/
└── overlays/
    └── prop4you/
```

This shape should be treated as the architectural target for extraction and
package growth, not as an immediate filesystem requirement in one batch.

## Layer Responsibilities

### 1. Core

The core is where the non-negotiable laws of the platform live.

The core owns:

- root orchestration
- classification rules
- prompt-hardening gate
- issue topology model
- manager-lane model
- risk-enforcement model
- root closure mode
- runtime packet schemas
- proof ordering
- agent optionality

The core must remain:

- project-agnostic
- stack-aware
- opinionated

The core must not own:

- vendor-specific workflow APIs
- raw repo-specific command strings
- project business overlays

### 2. Workflow Adapters

Workflow adapters implement the same orchestration concepts for different issue
or ticket backends.

Every workflow adapter should support the same conceptual model:

- issue bootstrap
- issue topology
- metadata hygiene
- lifecycle state transitions
- AI review reporting
- traceable closure
- task ledger linking
- requested-vs-implemented review surfaces
- defect ledger updates
- correction/reproof evidence
- final forensic reconciliation

Initial adapters:

- `linear`
- `github`

### 3. Runtime Adapters

Runtime adapters translate capability-level execution expectations into
concrete toolchains.

Examples:

- `python-uv`
- `node`
- `chrome-devtools`
- `playwright`

The platform should speak in capabilities first, such as:

- run Python management checks
- run frontend type validation
- capture browser truth
- capture persistent regression proof

The runtime adapter maps those capabilities to concrete commands.

### 4. Stack Profiles

Stack profiles bundle opinionated defaults for a technology posture.

A profile may define:

- dominant stack assumptions
- recommended skills
- default proof stack
- common reviewers
- contract expectations
- default runtime adapters

Initial intended profiles:

- `django-inertia-react`
- `nextjs-tailwind`

Current expanded profiles:

- `nextjs-prisma`
- `nextjs-drizzle`
- `nextjs-adonis-adminjs`

Profiles must own concrete stack proof without leaking raw framework command
strings into core. Prisma and Drizzle must not be treated as equal baseline data
authorities in the same profile.

### 5. Agent Factory

The agent factory formalizes the parts of the current system that already think
about bounded agents.

It should own:

- ontology
- capability matrix
- pooling model
- fit scoring
- gap detection
- authority boundary
- execution contract
- skill envelopes
- promotion criteria

It must preserve the distinction between:

- gap detection
- suggestion
- promotion
- runtime installation

### 6. Onboarding

Onboarding is the system that lets `accelerate` land in a repository with
little prior setup.

It should determine:

- workflow backend
- stack profile
- runtime adapters
- docs adapter
- recommended skills
- candidate future agents

It should use:

- A&Q
- executive planning
- capability discovery
- explicit defaults and overrides

Onboarding must emit an executive bootstrap plan rather than stopping at raw
discovery.

### 7. Planning

Planning formalizes the artifact layer that bridges discovery and execution.

It should own:

- executive plans
- architecture plans
- migration plans
- onboarding bootstrap plans
- promotion planning

Planning is a platform layer, not just a docs habit.

### 8. Overlays

Overlays capture project-specific deployment truth that should not leak into
the reusable core.

Examples of overlay material:

- local status policies that extend the shared workflow model
- public docs generation conventions
- project-specific wrappers or commands
- domain-specific guidance

## Root Interface

The root interface should remain `SKILL.md`.

Design decision:

- `SKILL.md` remains the compact constitutional entrypoint
- `README.md` remains the richer operational guide
- deep behavior continues to live in architecture docs and submodules

Rationale:

- preserves continuity with current runtime usage
- keeps the root interface compact
- avoids forcing every session to consume the full architecture set

## Documentation Architecture

The documentation system should adopt a three-tier model:

1. root entry documents
   - `README.md`
   - `SKILL.md`
2. architecture documents
   - system design, migration, onboarding, planning, adapters
3. submodule doctrine
   - agent factory
   - profile-specific guidance
   - workflow adapter specifics

The platform may support doc adapters such as Docusaurus, but those should be
optional publication layers, not the primary design authority.

## Initial Migration Model

Migration should happen in phases.

### Phase 1. Freeze and classify

Create the destination classification matrix for upstream artifacts.

### Phase 2. Establish core shell

Create the initial target directory skeleton and move core doctrine first.

### Phase 3. Extract root documents

Move or rewrite:

- `SKILL.md`
- root `README.md`
- canonical control-plane architecture

### Phase 4. Institute the planning layer

Create the native planning layer and connect onboarding outputs to executive
plans before deeper rehome continues.

### Phase 5. Extract agent-factory doctrine

Move the current `codex-agents` module into the `agents/` area with the new
platform vocabulary preserved.

### Phase 6. Extract onboarding and self-evolution guidance

Move and adapt:

- onboarding-facing logic
- self-evolution / autoresearch rules
- recommendation pathways

### Phase 7. Introduce adapters and profiles

Create the first workflow adapters, runtime adapters, and stack profiles.

### Phase 8. Build overlays

Re-express Prop4You-specific material as overlay instead of source-of-truth.

## Cross-Cutting Constraints

The design must preserve:

- root-owned closure
- root-owned topology
- agent optionality
- strong opinionated defaults
- layered extraction

The design must avoid:

- blind file mirroring
- weakening the root to make adapters easier
- reintroducing mandatory multi-agent doctrine
- mixing profiles and overlays

## Testing Strategy For The Platform Architecture

At architecture time, proof is documentation and migration coherence.

The first validation pass should verify:

- every target layer has a clear responsibility
- every major upstream artifact can be classified
- no target layer requires contradictory authority
- onboarding can select adapters/profiles without weakening core laws

Later implementation phases should add:

- doc-based consistency checks
- adapter conformance checks
- profile selection tests
- agent-factory promotion tests

## Out-Of-Scope Decisions Deferred

The following remain intentionally deferred:

- packaging and publishing strategy
- installation CLI
- CI pipeline
- exact config file formats for onboarding outputs
- exact runtime adapter invocation API

## Next Artifacts

This SDD is not complete by itself.

It depends on the following companion docs:

- `accelerate-classification-matrix.md`
- `accelerate-migration-plan.md`
- `accelerate-onboarding-model.md`

Together, these documents define the first extraction-ready architecture set.
