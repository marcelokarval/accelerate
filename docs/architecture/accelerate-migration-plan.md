# Accelerate Migration Plan

## Purpose

This document defines the phased migration path from the Prop4You incubation
environment into the standalone `accelerate` repository.

It follows the classification matrix rather than a raw file-copy strategy.

## Migration Principles

1. classify before moving
2. preserve root laws first
3. preserve strong defaults
4. do not weaken the core for adapter convenience
5. migrate by layer, not by old directory shape

## Phase 0. Bootstrap

Completed already.

Outputs:

- bootstrap context
- accepted decisions
- PRD
- SDD

## Phase 1. Establish the architecture shell

Create the top-level target directories without yet porting every artifact.

Phase outputs:

- initial `core/`
- initial `agents/`
- initial `adapters/`
- initial `profiles/`
- initial `onboarding/`
- initial `planning/`
- initial `overlays/`

Goal:

- make the extraction destination explicit before moving material

## Phase 2. Extract root doctrine

Extract the platform-wide root documents first.

Priority material:

- root `SKILL.md`
- root `README.md`
- canonical control-plane architecture
- prompt-hardening gate
- issue stack
- runtime packet references

Goal:

- the standalone repo can already explain itself as a platform

## Phase 3. Extract core governance doctrine

Move the manager-lane, topology, risk, and closure documents that define the
non-negotiable laws.

Priority material:

- manager lane map
- lane governance model
- issue topology policy
- risk enforcement model
- risk enforcement matrix
- closure blockers and escalation

Goal:

- root law stops depending on the old repo

## Phase 4. Institute the planning layer

Create the native planning layer that owns executive plans and planning
artifacts.

Priority material:

- executive bootstrap plan template
- architecture planning posture
- migration planning posture
- onboarding-to-plan handoff
- promotion planning posture

Goal:

- planning becomes a first-class product layer instead of an implicit docs
  habit

## Phase 5. Extract agent-factory doctrine

Move and rename the current `codex-agents` material into the `agents/` layer.

Priority material:

- agents README
- ontology
- capability matrix
- pooling model
- selection policy
- gap detection
- skill envelopes
- execution contract
- replay

Goal:

- bounded-agent design can evolve independently inside the new platform

## Phase 6. Define the default stack profile

Take the dominant current stack and formalize it as the first profile.

Initial profile:

- `django-inertia-react`

Goal:

- preserve today’s opinionated value without leaking framework assumptions into
  core laws

## Phase 7. Define workflow adapters

Start with the workflow backends already implied by the current discussions.

Initial adapters:

- `linear`
- `github`

Each adapter should define:

- issue bootstrap mapping
- lifecycle state mapping
- label/tag mapping
- parent/child mapping
- AI review report placement
- closure traceability

## Phase 8. Define runtime adapters

Create adapters for the concrete execution environments.

Initial adapters:

- `python-uv`
- `node`
- `chrome-devtools`
- `playwright`

Each adapter should define:

- capability inventory
- command mapping
- evidence shape
- failure handling

## Phase 9. Build onboarding

Create the onboarding system once the first adapters and profile exist.

Onboarding should be able to answer:

- what workflow backend should be used
- what stack profile should be used
- what runtime adapters should be active
- what publication adapter should be active
- what future agent gaps already exist
- what executive plan should govern the next bounded slices

## Phase 10. Re-express project residue as overlay

Move project-specific residue into overlay form.

Examples:

- naming
- local publishing conventions
- extra workflow rules beyond shared architecture

Goal:

- the old repo becomes a deployment overlay, not the hidden source of truth

## Phase 11. Close legacy-to-local operational gaps

Move the remaining methodological surfaces that still give the legacy/global
runtime an operational advantage into native local layers.

Priority material:

- branch enforcement matrix
- current enforcement surfaces
- QA / proof stack
- subagent model
- workflow catalog
- operational calibration
- autoresearch and self-evolution
- maturity control
- workflow-change approval gate
- product-critical surface discipline

Goal:

- the standalone repo becomes superior or equal in operational value to the
  legacy distribution, ignoring the future-agent layer

Acceptance artifact:

- `docs/architecture/accelerate-legacy-to-local-gap-matrix.md`

Status:

- native surfaces landed in the local repo; comparative retesting is still
  narrowing residual workflow-governance compression before a true parity claim

Outputs:

- `core/control-plane/branch-enforcement-matrix.md`
- `core/control-plane/quick-invocation-map.md`
- `core/control-plane/workflow-change-approval-gate.md`
- `core/risk/enforcement-surfaces.md`
- `core/runtime-packets/qa-proof-stack.md`
- `core/delegation/subagent-model.md`
- `core/workflows/catalog.md`
- `core/workflows/operational-calibration.md`
- `core/workflows/self-evolution.md`
- `core/workflows/maturity-control.md`
- `core/review/product-critical-surfaces.md`
- `agents/doctrine/empirical-replay.md`
- `core/review/premium-interface-production.md`

## First Extraction Batches Recommended

### Batch A

- create architecture shell
- extract root docs

### Batch B

- extract core governance doctrine

### Batch C

- institute planning layer
- connect onboarding to planning

### Batch D

- extract agent factory

### Batch E

- create first stack profile
- create first runtime adapter contracts

### Batch F

- create workflow adapters
- create onboarding architecture

## Risks

### Risk: accidental mirror extraction

Mitigation:

- enforce the classification matrix before moving files

### Risk: adapter-first drift

Mitigation:

- core doctrine must land before adapter implementation

### Risk: weakening defaults

Mitigation:

- create the first stack profile early

### Risk: platform bloat

Mitigation:

- preserve the distinction between core, profile, adapter, and overlay

## Definition Of Migration Success

Migration succeeds when:

- the new repository becomes the design authority
- core laws no longer depend on the old repo
- the dominant stack is expressed as a profile
- workflow and runtime integrations are modeled as adapters
- Prop4You-specific residue is explicitly overlay material
