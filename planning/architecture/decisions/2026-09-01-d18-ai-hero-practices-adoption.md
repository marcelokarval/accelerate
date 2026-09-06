# D18 — Selective AI Hero Practices Adoption

- Status: accepted doctrine; source-only implementation
- Date: 2026-09-01
- Governing proposal SHA-256: `79473c41e77c626a0c849d0ff385be7c140e7f66cfbf047e55ba5ccfe05cd067`
- Evaluated sources: [`ai-hero-dev/ai-hero` at `8a2ab404cba5c70731edd3c2e919fea917f843aa`](https://github.com/ai-hero-dev/ai-hero/tree/8a2ab404cba5c70731edd3c2e919fea917f843aa) and [`mattpocock/skills` at `6654f6b60cd9d5be8b54c6fafe44346dabeb3b76`](https://github.com/mattpocock/skills/tree/6654f6b60cd9d5be8b54c6fafe44346dabeb3b76), inspected 2026-09-01.

## Decision

Adopt the following practices only when they fit Accelerate's existing
authority model:

- use a decision frontier: decide explicitly when a request must become an ADR
  or hardened specification; allow a bounded prototype escape hatch only with
  scope, expiry, non-production boundary, and later disposition;
- keep a shared vocabulary and ADRs, use seam-first specifications, build
  vertical tracer bullets, and apply TDD at seams;
- constrain work to a fixed diff/candidate; review Standards and Spec as
  orthogonal dimensions; make testability and side effects explicit;
- run deterministic evaluations before model judges, set an explicit
  agentic--deterministic dial per task, and grant tools by least privilege.

## Rejections and boundaries

The following are explicitly rejected: automatic commits; any tracker other
than Plane; slash-command or donor-runtime assumptions; treating same-run
review as independence; and marketing/performance claims without local,
reproducible evidence. External repositories are references, not a source of
runtime authority, profile identity, permissions, installation, or promotion.

## Adoption gates

Each future practice implementation must name the governing vocabulary/ADR,
affected seam and side effects, deterministic evaluator and negative cases,
fixed candidate/diff, minimum tool permissions, and independent review receipt.
Model judging is allowed only as an explicitly advisory or separately
validated complement after deterministic evaluation; it may not erase a
deterministic failure. Prototype escape requires an expiry and cannot close or
silently graduate into production.

This decision does not install or copy either source, add commands, configure
agents, mutate Plane, commit changes, or authorize a runtime assumption.
