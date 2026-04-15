# SDD Handoff

## Purpose

This document tells the next session exactly how to turn the bootstrap pack
into the first SDD for the standalone `accelerate` platform.

## Mandatory Reading Before Writing The SDD

Read in this order:

1. [`../../README.md`](../../README.md)
2. [`./context-and-origin.md`](./context-and-origin.md)
3. [`./decisions-and-final-state.md`](./decisions-and-final-state.md)
4. [`./prd-initial-platform-foundation.md`](./prd-initial-platform-foundation.md)

Then consult the upstream authoring sources from the Prop4You workspace.

## Core Question The SDD Must Answer

How should the existing mature `accelerate` system be extracted into this new
repository as a layered platform without losing:

- opinionated defaults
- root laws
- agent optionality
- onboarding capacity
- future multi-adapter growth

## Mandatory SDD Outputs

The SDD should produce at least:

1. target repository architecture
2. classification matrix:
   - source artifact
   - destination layer
   - migration notes
3. initial package/directory layout
4. migration plan in phases
5. onboarding architecture
6. adapter architecture
7. profile architecture
8. agent-factory architecture
9. documentation architecture

## Recommended Initial Layer Definitions

Use these as the starting frame unless fresh analysis proves otherwise.

### Core

- root laws
- control plane
- prompt hardening
- issue topology
- manager lanes
- risk enforcement
- root closure mode
- runtime packets

### Workflow Adapters

- `linear`
- `github`

### Runtime Adapters

- `python-uv`
- `node-*`
- `chrome-devtools`
- `playwright`
- optional documentation adapters

### Stack Profiles

- `django-inertia-react`
- future additional profiles

### Agent Factory

- ontology
- pooling
- fit scoring
- authority boundaries
- promotion criteria

### Onboarding

- A&Q
- executive planning
- capability discovery
- recommended configuration

### Overlays

- project-specific deployment assumptions
- public docs generation conventions
- local workflow conventions

## Recommended First SDD Artifacts

The next session should likely create:

- `docs/architecture/accelerate-target-architecture.md`
- `docs/architecture/accelerate-classification-matrix.md`
- `docs/architecture/accelerate-migration-plan.md`
- `docs/architecture/accelerate-onboarding-model.md`

## Migration Constraints

Do not:

- mirror the entire old tree as the first move
- treat the current Prop4You layout as the target package structure
- weaken root authority to make adapters easier
- reintroduce mandatory multi-agent doctrine

Do:

- preserve strong defaults
- preserve root-owned closure
- preserve agent optionality
- preserve the distinction between suggestion and promotion
- preserve the distinction between core and project overlay

## Practical Continuation Note

At bootstrap time, this repository contains planning only.

That is intentional.

The correct continuation is:

1. derive the SDD
2. define target structure
3. build migration phases
4. extract in slices

Do not start by copying files just because the upstream source is mature.
