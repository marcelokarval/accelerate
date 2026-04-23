# Accelerate Onboarding Model

## Purpose

This document defines the onboarding architecture for the standalone
`accelerate` platform.

The onboarding system is responsible for helping `accelerate` enter a project
that does not yet have a mature local ecosystem.

## Product Goal

`accelerate` should be able to help bootstrap:

- itself
- the project's workflow adapter choice
- the stack profile choice
- runtime adapter selection
- documentation adapter selection
- recommended skills
- candidate future agents

This must work even in projects that begin with little structure.

## Core Onboarding Thesis

Onboarding is not a one-time installer wizard.

It is an executive planning and discovery loop that can be re-entered whenever
the project evolves.

That means the onboarding system must be:

- dynamic
- re-runnable
- state-aware
- recommendation-oriented

## Onboarding Inputs

The onboarding flow should discover or ask about:

- repository type
- main language(s)
- web/backend/runtime stack
- workflow backend preference
- package/runtime wrappers
- documentation system
- browser/E2E posture
- desire for bounded agents now vs later
- current project maturity

## Onboarding Outputs

The onboarding flow should produce:

- selected default stack profile
- selected workflow adapter
- selected runtime adapters
- selected documentation adapter
- recommended companion skills
- recommended future agent candidates
- executive bootstrap plan

## Onboarding Phases

### Phase 1. Discovery

Collect explicit and inferred signals from the repository.

Sources may include:

- repository layout
- existing tool configs
- existing package files
- existing CI/docs structures
- explicit user answers

Discovery should prefer deterministic repo scanning before LLM inference.

The initial standalone implementation should treat these as first-class signal
families:

- language and manifest signals
- framework and runtime signals
- package-manager signals
- workflow-tool signals
- docs-posture signals
- proof-runtime signals
- repo-shape notes

These belong in local onboarding discovery state before the recommendation
layer derives stronger decisions.

### Phase 2. A&Q

Ask the minimum questions needed to resolve uncertainty that materially affects
the chosen profile or adapters.

Examples:

- issue backend preference
- preferred web stack if not yet established
- preferred runtime wrappers
- docs publication preference

### Phase 3. Executive Planning

Generate a bootstrap plan that explains:

- chosen defaults
- why they were chosen
- what remains optional
- what follow-up setup is recommended

### Phase 4. Recommendation Layer

Recommend:

- skills
- adapters
- profile
- future agent paths

### Phase 5. Re-entry

Allow onboarding to be re-run later when:

- stack changes
- workflow backend changes
- docs adapter changes
- agent needs become clearer

## Selection Hierarchy

The onboarding system should choose in this order:

1. core laws are fixed
2. workflow adapter
3. runtime adapters
4. stack profile
5. documentation adapter
6. skill recommendations
7. future agent recommendations

The core laws are not negotiable through onboarding.

Everything else is selected around them.

## Default Distribution

Until more adapters and profiles exist, the default distribution should remain
close to the current mature ecosystem:

- workflow adapter:
  - `linear`
- runtime adapters:
  - `python-uv`
  - `node`
  - `chrome-devtools`
  - `playwright`
- stack profile:
  - `django-inertia-react`
- docs adapter:
  - `docusaurus`

This is a default distribution, not a universal lock.

## Skill Recommendation Model

Onboarding should recommend adjacent skills based on the selected profile and
adapters.

Examples:

- if Python + Django stack:
  - Python and Django-oriented skills
- if frontend-heavy React stack:
  - frontend structure and runtime review skills
- if workflow backend is GitHub:
  - GitHub workflow skills

The system should also recommend:

- `napkin`
- `using-superpowers`

as operating companions, while preserving the rule that `accelerate` does not
depend on them semantically.

## Agent Recommendation Model

Onboarding may surface future bounded-agent candidates when repeated missing
specialties are already obvious.

The onboarding system must preserve the distinction between:

- recommending a family shape
- creating a real runtime agent

## Persistence Model

The current pre-agents persistence model for governed target repositories is
the `.accelerate/` V2 local workspace.

The current implementation surface lives under:

- `onboarding/local-workspace/`

That V2 model is intentionally small and useful. Broader local persistence
remains a later concern, but onboarding output persistence itself is no longer
undefined.

The current V2 persistence set now also includes a minimal local status layer
for:

- readiness dashboard
- continuity timeline
- durable operational learnings

This remains intentionally smaller than a full V3 runtime registry.

## Failure Modes

### Failure Mode 1. Over-questioning

The onboarding asks too many questions and loses momentum.

Mitigation:

- only ask questions that materially change adapter/profile choices
- prefer deterministic detection plus explicit confidence before asking

### Failure Mode 2. Over-inference

The onboarding assumes too much from weak repo signals.

Mitigation:

- keep A&Q for high-impact ambiguities

### Failure Mode 3. Fake flexibility

The onboarding becomes so generic that the platform loses its opinionated
defaults.

Mitigation:

- preserve the default distribution until a better fit is actually chosen

## Initial Implementation Guidance

When onboarding is first implemented, start with:

1. discovery inputs
2. deterministic signal scanner
2. A&Q schema
3. executive planning output
4. recommendation output

Do not start with full persistence or automation breadth first.
