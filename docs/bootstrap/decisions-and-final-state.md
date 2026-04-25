# Decisions And Final State

## Purpose

This document records the decisions that were explicitly discussed and accepted
before the standalone `accelerate` repository began implementation.

Treat this as bootstrap historical provenance. Current authority lives in
`AGENTS.md`, `README.md`, `SKILL.md`, `core/`, `skills/`, and the active
architecture docs.

## Final Position

`accelerate` should be developed as an opinionated platform, not merely as a
repo-local skill bundle.

It should start with a strong default distribution and still be able to adapt
to a project's reality through onboarding, adapters, and profiles.

## Accepted Decisions

### D1. `accelerate` remains opinionated

The platform should not be value-neutral.

It should ship with a strong default opinion about:

- workflow discipline
- issue-first mutation
- root-owned closure
- risk enforcement
- proof ordering
- bounded-agent optionality

The goal is not to become generic sludge.

### D2. `accelerate` must remain agent-optional

The platform must be fully functional when:

- no governed agents exist
- the user disables agents
- the pool has no honest fit
- root-only execution is cleaner than delegation

Agents are a governed capability, not a structural dependency.

### D3. Agent suggestion is not agent promotion

The platform may conclude that a future agent should exist.

That does not mean the platform should automatically create or install it.

There must remain a distinction between:

- `gap detection`
- `agent suggestion`
- `agent promotion`
- runtime installation or sync

### D4. Root authority must stay explicit

The root owns:

- classification
- prompt hardening decisions
- issue topology
- lane opening
- staffing shape
- delegation budget
- risk enforcement
- root closure mode
- final `Done`

Bounded agents must not inherit orchestration authority.

### D5. Workflow backends are adapters

The platform should support multiple workflow backends under one architectural
model.

Current intended direction:

- `linear` adapter
- `github` adapter

Both should express the same orchestration concepts:

- issue bootstrap
- parent/child hygiene
- labels and status conventions
- AI review report
- traceable closure

### D6. Runtime execution should use adapters and wrappers

The platform should express execution at the capability level, then let runtime
adapters translate it into concrete commands.

Current example:

- Python projects should think in terms of a wrapper discipline
- the current dominant wrapper is `uv`

This means the platform should not hardcode a single repo-specific command path
as universal truth.

### D7. Strong stack defaults should become profiles

The current dominant stack is a valid default profile, not a universal lock.

Examples of strong default profile material:

- Django
- Inertia
- React
- shadcn/ui
- Tailwind
- Chrome DevTools
- Playwright

The long-term system should support other opinionated profiles such as a
Next.js + Tailwind profile without diluting the control-plane laws.

### D8. Documentation systems are optional adapters

Docusaurus may remain a recommended documentation adapter, but it should not be
modeled as a mandatory dependency of the platform.

### D9. `codex-agents` should evolve into platform-native agent factory logic

The current `codex-agents` material should be treated as evidence that the
platform already owns:

- ontology
- pooling
- authority boundaries
- staffing rules
- risk enforcement
- gap detection
- skill envelopes

This should evolve into a proper `agent-factory` area in the standalone
platform.

### D10. Greenfield onboarding is first-class

The platform should be able to enter a repository with little or no prior setup
and help determine:

- stack profile
- workflow backend
- runtime adapters
- documentation adapter
- recommended skills
- future agent candidates

The onboarding flow should use A&Q plus executive planning.

### D11. Extraction should be layered, not mirrored

The platform should not be extracted by copying the full Prop4You source layout
as-is.

The extraction should first classify material into:

- core
- workflow adapter
- stack profile
- runtime adapter
- overlay

### D12. Source-of-truth migration should be deliberate

At bootstrap time, the mature source of truth still lived in the Prop4You
sandbox and promoted runtime mirror.

This was true at bootstrap time only. The standalone repository is now the
authoring source for governed Accelerate behavior.

This new repository should become the new long-term home, but only after:

- classification
- SDD
- initial target structure
- migration plan

## Current Target Architecture

The accepted target model is:

```text
accelerate/
  core/
  adapters/
    workflow/
    runtime/
    docs/
  profiles/
  agents/
  onboarding/
  overlays/
```

This is a target model, not yet an implemented directory commitment.

## Decisions Explicitly Rejected

### R1. Blindly moving the existing tree into a new repository

Rejected because it preserves accidental coupling and delays the real
architectural separation.

### R2. Making `accelerate` generic and stack-neutral

Rejected because the opinionated default posture is part of the value of the
system.

### R3. Treating multi-agent execution as the mandatory identity of the system

Rejected because root-only execution remains a legitimate posture.

### R4. Treating Prop4You-specific language as the core extraction boundary

Rejected because the better boundary is functional layering, not brand text.

## Open Questions To Resolve In The SDD

- exact package and directory structure
- whether `SKILL.md` remains the root interface or becomes generated from core
  docs
- what the first supported workflow adapters are
- what the first supported stack profiles are
- how runtime adapters should expose command contracts
- how onboarding stores or projects its discovered configuration
- how the platform should version and test agent-factory outputs

## Final State At The End Of This Bootstrap Round

The final state after this planning round is:

- new standalone repository exists
- no implementation extraction has happened yet
- the extraction framing is accepted
- the next correct artifact is an SDD derived from the PRD and this decisions
  document
