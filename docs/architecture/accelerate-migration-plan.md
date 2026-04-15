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

## Phase 4. Extract agent-factory doctrine

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

## Phase 5. Define the default stack profile

Take the dominant current stack and formalize it as the first profile.

Initial profile:

- `django-inertia-react`

Goal:

- preserve today’s opinionated value without leaking framework assumptions into
  core laws

## Phase 6. Define workflow adapters

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

## Phase 7. Define runtime adapters

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

## Phase 8. Build onboarding

Create the onboarding system once the first adapters and profile exist.

Onboarding should be able to answer:

- what workflow backend should be used
- what stack profile should be used
- what runtime adapters should be active
- what publication adapter should be active
- what future agent gaps already exist

## Phase 9. Re-express Prop4You as overlay

Move project-specific residue into overlay form.

Examples:

- naming
- local publishing conventions
- extra workflow rules beyond shared architecture

Goal:

- the old repo becomes a deployment overlay, not the hidden source of truth

## First Extraction Batches Recommended

### Batch A

- create architecture shell
- extract root docs

### Batch B

- extract core governance doctrine

### Batch C

- extract agent factory

### Batch D

- create first stack profile
- create first runtime adapter contracts

### Batch E

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
