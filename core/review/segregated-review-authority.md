# Segregated Review Authority

## Purpose

Use this doctrine whenever implementation, review, correction, or final forensic
closure are part of the same run.

The core rule is simple: the executor cannot be the acceptor of their own work.

## Role Separation

Every non-trivial execution loop has three distinct review authorities:

- `executor`: implements or corrects a bounded task
- `skeptical reviewer`: independently checks the executor's claim against the
  task criteria and evidence
- `orchestrator / final forensic reviewer`: integrates all claims, reviews the
  reviews, distrusts unproven assertions, and owns final closure

The same agent/persona may physically perform multiple activities only in a
documented constrained runtime, but the authority boundaries must remain
separate in the packets. If no independent reviewer is available, closure must
state a review isolation exception and carry residual risk.

## Non-Trust Rule

Self-review is useful but insufficient.

Treat self-review as a disclosure artifact from the executor, not as acceptance
proof. The skeptical reviewer must assume the executor missed something and must
look for:

- missing acceptance criteria
- missing routes/views/states/data cases
- cross-view parity gaps
- stale or pre-fix proof
- optimistic task status
- temporary artifact leftovers
- implementation that satisfies examples but not the general rule

The orchestrator must then distrust the reviewer too: review quality is itself a
review target.

## Required Separation Packet Fields

Packets that close tasks must identify:

- executor identity/role
- reviewer identity/role
- whether executor and reviewer are independent
- review isolation exception, if any
- orchestrator final judgment

## Closure Blockers

Do not close when:

- executor self-review is the only review evidence for a non-trivial task
- reviewer simply repeats the executor's summary without adversarial checks
- orchestrator accepts reviewer conclusions without review-of-review
- final forensic closure does not identify who executed, who reviewed, and who
  integrated
- a review isolation exception exists but residual risk is hidden

## Failure Labels

- `executor-reviewed-own-work`
- `self-review-treated-as-acceptance`
- `reviewer-not-skeptical`
- `orchestrator-trusted-review-unchecked`
- `review-isolation-exception-hidden`
