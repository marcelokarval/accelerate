# Design-System Rollout Entry Gate

## Purpose

Use this gate when a design-system package already exists and the next step is
not extraction, but rollout planning or real UI implementation.

This gate closes the workflow gap between:

- design-system extraction / premium generation
- executive planning
- implementation handoff

## Rule

Do not treat an executive rollout plan as a self-sufficient UI implementation
entrypoint.

If a session is expected to start implementation from a rollout plan, that plan
must explicitly declare:

- the required pre-read artifact set
- the immutable contract authority
- the primary implementation driver
- any secondary macro direction artifact
- the execution slicing artifact

If any of those are implicit, the handoff is incomplete.

## Required Declaration Set

For design-system rollout work, the handoff entrypoint must name:

1. `contract authority`
   - usually `docs/reference/design-system.contract.md`
2. `source-truth visual evidence`
   - usually `docs/reference/design-system.html`
3. `primary implementation driver`
   - the artifact that should drive actual mutation
4. `secondary macro direction`
   - optional, but mandatory when a broader premium or aesthetic direction also
     constrains the implementation
5. `execution slicing artifact`
   - the sprint/task artifact that turns strategy into bounded implementation

## Acceptance Test

The rollout entrypoint is valid only when a fresh session can open one file and
learn, without guesswork:

- which other artifacts must be read before mutation
- which artifact is implementation law
- which artifact is the primary implementation driver
- which artifact is only macro direction
- which artifact controls bounded rollout order

## Failure Modes

Treat the handoff as invalid when:

- the executive plan references premium work but does not name the primary
  implementation artifact
- the contract exists but is not declared as a mandatory pre-read
- the premium artifacts exist but their role is left ambiguous
- a sprint plan exists but the entrypoint does not name it as the bounded
  execution surface
- a new session would have to infer which file to trust for actual mutation

## Closure Rule

Do not claim design-system rollout readiness until this gate is satisfied.
