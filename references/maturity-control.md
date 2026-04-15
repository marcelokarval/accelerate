# Maturity Control

Use this module when the question is how the workflow itself should evolve,
shrink, or stay governable.

## Workflow Telemetry And Self-Observation

Observe the workflow itself.

Ask:

- which gates fail most often?
- where does re-entry happen?
- which profiles create too many follow-ups?
- where is orchestration cost too high?

This is governance with evidence, not gut feeling.

## Simplification And De-Escalation

When the process is heavier than the slice deserves:

- collapse unnecessary phases
- stop generating artifacts that add no decision value
- avoid delegation that only creates review drag
- cut investigation early when the branch already has enough proof

Simplification is a discipline, not an omission.

## Domain Operating Playbooks

Prefer repeatable playbooks for recurring domains such as:

- billing and financial truth
- auth and anti-abuse
- visual artifact implementation
- repo hygiene
- Inertia runtime persistence
- query-heavy backend work

Playbooks keep domain behavior consistent without bloating the core file.

## Autoresearch And Self-Evolution

When workflow failures are repeated, structural, or high-impact, do not leave
the learning trapped in commentary. Promote it through the autoresearch
protocol in `autoresearch-and-self-evolution.md`.

If the proposed promotion mutates workflow truth, also run
`workflow-change-approval-gate.md` before treating the promotion as fully
authorized.

## Durable Memory Promotion Policy

Promote learnings when they are:

- repeated
- cross-session
- high-impact
- worth preserving as rule, playbook, or constitution

Do not promote one-off session noise into durable guidance.

## Legibility And Teachability

The workflow must stay learnable.

Use:

- quick maps
- short decision tables
- operator-mode summaries
- strong pointers to deeper references

If the system is right but unreadable, it will be misused.

## Evidence Precedence Model

When evidence conflicts, prefer the strongest directly relevant proof.

Typical precedence:

1. live runtime evidence when the claim is runtime behavior
2. code and contract evidence when the claim is integration truth
3. tests when the claim is deterministic logic
4. issue text or narrative only when stronger proof does not exist

Never let weak narrative outrank strong evidence.

## Theory-Vs-Practice Adherence Audit

Check whether the written workflow still matches how sessions are actually
using it.

If a rule is never used, always ignored, or consistently too expensive, it may
need redesign or relocation.

## Meta-Governance And Promotion Boundaries

Decide carefully what belongs in:

- `accelerate`
- child skills
- domain playbooks
- docs vivas
- the stack constitution

Do not let the root orchestrator absorb everything.

When a mutation would change the root orchestrator or adjacent workflow truth,
the proposal requires explicit human approval and a visible evidence packet.

## Accelerate Scope Control

When a concern becomes too detailed or domain-specific, move it out of the
core skill and keep a pointer.

The root file should remain a control plane, not a monolith.

## Quick Reference / Operator Mode

Maintain a lightweight operating mode that helps an operator answer quickly:

- what phase am I in?
- what branch am I in?
- what proof is missing?
- what review still blocks closure?
