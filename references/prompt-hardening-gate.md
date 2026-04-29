# Prompt Hardening Gate

Use this module when the question is not only whether the prompt is long, but
whether execution should be blocked until the request is bounded enough to trust.

## Core Rule

Prefer running `prompt-hardening` before beginning work unless the prompt is
already clearly bounded, low-ambiguity, and single-objective.

## Mandatory Triggers

Run `prompt-hardening` when any of these are true:

- the prompt is long
- the prompt is ambiguous
- the prompt is multi-objective
- the prompt is multi-phase
- the prompt allows several reasonable execution interpretations
- the prompt is architecture-heavy
- the prompt may turn into issue creation, planning, runtime proof, or
  multi-surface work even if it initially looks small

## Important Clarification

Prompt size and workflow size are not the same thing.

A branch may still end up trivial after hardening.

That does not make the gate unnecessary.

## Output Requirement

When the gate is active, the run should visibly expose:

- `Prompt A`
- `Prompt B`
- what changed materially
- bounded scope now
- explicit non-goals
- next branch or persona route

## Approval-Boundary Variant

When the user asks to improve a prompt and then wait for approval before running
it, use `core/control-plane/prompt-upgrade-approval-gate.md`.

That variant is stricter than ordinary prompt hardening: the upgraded prompt must
be presented first, and execution must wait for explicit approval.

## Anti-Failure Rule

Do not let the run jump from weak prompt -> implementation merely because the
operator believes they already understand the intent.
