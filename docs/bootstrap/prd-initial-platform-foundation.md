# PRD: Accelerate Initial Platform Foundation

## Document Status

- status: draft baseline accepted for SDD generation
- phase: platform bootstrap
- repository: `marcelokarval/accelerate`
- date: 2026-04-15

## Product Name

Accelerate

## Product Summary

`accelerate` is an opinionated agentic control-plane platform for engineering
work.

It should provide:

- root orchestration
- planning and prompt hardening discipline
- issue-driven mutation discipline
- manager-lane governance
- risk enforcement
- proof ordering
- root-owned closure
- optional bounded-agent collaboration
- onboarding for new projects
- extensibility through adapters and profiles

## Problem Statement

`accelerate` matured inside a single project context until it gained enough
surface area that:

- it stopped fitting well as a local-only skill bundle
- it began to own architecture that should be reusable
- it began to accumulate doctrine that should be versioned as a product
- future agent and onboarding capabilities started to depend on a cleaner
  platform boundary

Without a dedicated platform home, the system risks:

- accidental coupling to one monorepo
- unclear separation between core laws and project overlays
- harder onboarding for other projects
- brittle growth of agents, adapters, and profiles

## Product Vision

Create a standalone platform that remains strongly opinionated while being able
to adapt to a project's workflow backend, runtime tooling, documentation
adapter, and stack profile through guided onboarding.

## Primary Users

### 1. Root operator

The human or session using `accelerate` as the control plane for real
engineering work.

Needs:

- clear laws
- clear execution path
- clear closures and blockers
- bounded delegation rules

### 2. Platform maintainer

The person evolving `accelerate` itself.

Needs:

- clean architecture
- explicit core vs adapter vs overlay boundaries
- safe promotion rules
- reusable documentation

### 3. Project adopter

Someone introducing `accelerate` into a different project.

Needs:

- onboarding
- clear defaults
- configurable adapters/profiles
- confidence that the system works before any custom agents exist

### 4. Future bounded-agent designer

Someone creating governed runtime agents from `accelerate` doctrine.

Needs:

- clear agent-factory model
- promotion criteria
- authority boundaries
- skill-envelope logic

## Goals

### G1. Establish `accelerate` as a standalone platform

The repository should become the first-class home for the system.

### G2. Preserve the opinionated core

The control-plane laws should remain strong and explicit.

### G3. Separate platform layers cleanly

The system should distinguish:

- core laws
- workflow adapters
- stack profiles
- runtime adapters
- onboarding
- agent factory
- overlays

### G4. Support agent-optional operation

The platform must remain fully useful without runtime agents.

### G5. Support greenfield onboarding

The platform must help a new project determine its own configuration and
execution posture.

### G6. Make future extraction and implementation predictable

The first implementation phase should be driven by an SDD, not by ad hoc file
copying.

## Non-Goals

- fully implementing adapters in this bootstrap phase
- extracting every historical reference immediately
- supporting every possible stack from day one
- making the platform framework-neutral
- generating runtime `*.toml` agents in the bootstrap phase

## Product Principles

1. Opinionated by default
2. Project-agnostic at the core
3. Stack-aware through profiles
4. Workflow-aware through adapters
5. Agents are optional
6. Root authority remains explicit
7. Risk becomes enforcement, not narration
8. Onboarding is first-class, not an afterthought

## Functional Requirements

### FR1. Root control plane

The platform must provide a root layer that can:

- classify the run
- decide prompt hardening
- choose issue topology
- open lanes
- decide staffing and delegation budget
- enforce risk and proof ordering
- own final closure

### FR2. Workflow adapter abstraction

The platform must support multiple workflow backends under one shared
orchestration model.

Initial target direction:

- Linear adapter
- GitHub adapter

### FR3. Runtime adapter abstraction

The platform must express command and tool expectations through runtime
adapters rather than repo-specific raw commands.

Initial target direction:

- Python via `uv`
- Node ecosystem via project-selected package manager
- browser truth via Chrome DevTools
- persistent regression via Playwright

### FR4. Stack profiles

The platform must support strong opinionated stack profiles.

Initial target direction:

- `django-inertia-react`
- future `nextjs-tailwind`

### FR5. Agent-factory capability

The platform must preserve and eventually formalize:

- agent ontology
- pooling model
- fit scoring
- authority boundaries
- gap detection
- promotion rules

### FR6. Onboarding system

The platform must support onboarding for projects with little prior setup.

The onboarding must be able to determine:

- project workflow backend
- stack profile
- runtime adapters
- documentation adapter
- recommended skills
- candidate future agent families

### FR7. Planning-first extraction

The platform must use the PRD -> SDD -> implementation path for its own
bootstrap.

## Non-Functional Requirements

### NFR1. Teachability

The system must remain understandable to a new session through explicit docs
and reading order.

### NFR2. Modularity

Core, adapters, profiles, and overlays must be separable.

### NFR3. Strong defaults

The platform must remain opinionated enough to be useful without long setup.

### NFR4. Safe growth

New adapters, profiles, and agents must not silently weaken root laws.

### NFR5. Documentation durability

The repository must support living docs that stay useful across sessions.

## Initial Scope For The First SDD

The SDD generated from this PRD should focus on:

1. repository target architecture
2. classification of existing upstream material into platform layers
3. initial directory/package structure
4. migration strategy from Prop4You source-of-truth
5. onboarding model
6. adapter model
7. profile model
8. agent-factory model
9. initial documentation architecture

## Out Of Scope For The First SDD

- implementing all adapters
- building full onboarding automation
- publishing packages
- cross-project installation tooling
- broad CI/CD automation

## Success Criteria

The initial platform foundation is successful when:

- another session can continue from this repository alone
- the SDD can be generated without relying on chat history
- the system boundary is clear enough to start extraction in layers
- the default opinionated distribution is preserved
- root-only and agent-optional posture remain first-class

## Risks

### Risk 1. Over-generalization

The platform may become abstract and lose the opinionated value it already has.

### Risk 2. Blind mirroring

The extraction may copy accidental project coupling into the new repository.

### Risk 3. Layer confusion

Core, adapters, profiles, and overlays may be mixed again.

### Risk 4. Premature implementation

Work may jump into extraction before the target architecture is fixed.

## Mitigations

- keep strong default distribution
- classify before migrating
- derive the SDD before extraction work
- preserve root laws as non-negotiable

## Inputs Required For The SDD

The SDD must consume:

- this PRD
- `docs/bootstrap/decisions-and-final-state.md`
- `docs/bootstrap/context-and-origin.md`
- the upstream Prop4You `accelerate` tree and canonical architecture docs

## Final Requirement

The first implementation work in this repository must not begin until the SDD
exists and the initial classification matrix is explicit.
