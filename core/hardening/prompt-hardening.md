# Prompt Hardening

## Purpose

This document is the native core home for the prompt-hardening gate.

## Gate Rule

Every engineering run needs outcome clarity before execution.

Use two levels:

- **Micro-hardening** for trivial bounded work.
- **Full prompt hardening** for non-trivial, ambiguous, or drift-prone work.

### Micro-Hardening

Use micro-hardening when the task is clearly bounded, low-risk, and
single-objective.

The run must be able to state:

- `goal`
- `done means`
- `material constraints`, when any exist

Do not expand trivial work into a heavy prompt artifact unless the trivial shape
is false or unstable.

### Full Prompt Hardening

Run full prompt hardening before execution when the request is:

- long
- ambiguous
- multi-objective
- multi-phase
- architecture-heavy
- likely to drift into issue work, planning, runtime proof, or cross-surface
  execution
- security-, billing-, auth-, data-, or external-side-effect-sensitive
- governance-, workflow-, or runtime-behavior-changing
- visually/product-sensitive enough that acceptance criteria are not obvious

## Output Contract

When full prompt hardening is active, the run must visibly expose an
outcome-first hardened prompt:

- `goal`
- `success criteria`
- `constraints`
- `output`
- `stop rules`
- `explicit non-goals`
- `risks or ambiguity resolved`
- `proof required`

If preserving prompt transformation traceability matters, also expose:

- `Prompt A`
- `Prompt B`
- material changes
- bounded scope
- next branch or persona route

## Important Clarification

Prompt size and workflow size are not the same thing.

A run may still become trivial after hardening. That does not make the gate
optional.

A trivial run does not need full hardening, but it still needs micro-hardening.
If `goal` and `done means` cannot be stated plainly, the run is not ready to
execute as trivial.

## Authority

The detailed legacy reference still lives in:

- `references/prompt-hardening-gate.md`
