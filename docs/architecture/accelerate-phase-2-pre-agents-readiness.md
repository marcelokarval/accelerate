# Accelerate Phase 2 Pre-Agents Readiness

## Status

- status: completed one-shot slice
- date: 2026-04-15
- intent: move the standalone repository from architecture shell to native
  pre-agents baseline

## Objective

This slice had three concrete goals:

1. normalize workflow adapters as first-class platform concepts
2. create the first native onboarding surface
3. perform the first real rehome from imported `references/` into native
   `core/`, `adapters/`, and `onboarding/`

## What This Slice Completed

- the repo now has native core docs for:
  - root laws
  - prompt hardening
  - issue-driven mutation stack
  - topology policy
  - manager lanes
  - risk enforcement
  - authority boundary
  - runtime packet templates and cadence
- the repo now has native workflow adapter docs for:
  - shared adapter contract
  - Linear as current default backend
  - GitHub as planned peer backend
- the repo now has native runtime adapter docs for:
  - Python via `uv`
  - Node
  - Chrome DevTools
  - Playwright
- the repo now has native onboarding docs for:
  - A&Q
  - discovery
  - executive bootstrap planning
  - recommendation model
- `README.md` and `AGENTS.md` now route readers first through the native
  pre-agents baseline instead of treating imported references as the primary
  center of gravity

## What Pre-Agents Ready Means Now

The standalone repo is now considered pre-agents ready because it already has:

- a native standalone control-plane baseline
- native adapter contracts
- native onboarding contracts
- a root-only-complete operating model
- explicit distinction between recommendation, promotion, and future agent work

## What Still Remains

- continue rehoming imported doctrine out of `references/`
- formalize the first profile in deeper detail
- evolve `references/codex-agents/` into the native `agents/` layer
- later decide when the platform is ready for real promoted agents

## Recommended Next Slice

1. first deep rehome of `references/codex-agents/` into `agents/doctrine/`
2. first detailed profile package under `profiles/django-inertia-react/`
3. first executable onboarding artifact or manifesto format
