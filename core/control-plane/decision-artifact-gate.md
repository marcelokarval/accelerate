# Decision Artifact Gate

## Purpose

Make every adjacent design and delivery artifact an explicit disposition rather
than an operator-memory assumption.

## Required Dispositions

Every Engineering Artifact Manifest records:

- ADR;
- DESIGN;
- Test Design;
- agents;
- rollout;
- rollback;
- observability;
- AGENTS/docs.

Allowed statuses are `separate`, `existing`, `consolidated`,
`not-applicable`, `required`, and `deferred`. Every status carries a substantive
reason. `separate` and `existing` carry a locator.

Critical mode additionally requires a threat-model disposition and requires
ADR, threat model, Test Design, and rollback to be separate artifacts.
Structural UI work requires DESIGN to be separate or existing. A durable
one-way decision must not hide inside a consolidated or omitted ADR.

## Distinct Authorities

- ADR records a durable decision and consequences.
- DESIGN records product UI or interaction structure.
- Test Design records pre-code test strategy.
- TDD Receipt records observed execution history.
- Rollout and rollback record transition and reversal.
- Observability records how state and failure become visible.

No artifact above substitutes for another. Consolidation means its required
content has a named owner and location inside another accepted artifact; it
does not mean the concern was skipped.

## Ownership And Blocking

Accelerate root accepts dispositions. A specialist may recommend them but may
not accept its own artifact. Missing status, missing substantive reason,
missing locator, critical consolidation, or silent structural-DESIGN omission
blocks implementation.
