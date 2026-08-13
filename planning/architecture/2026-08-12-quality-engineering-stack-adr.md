# ADR-CODEX-001: Adopt A Proportional Specification Lifecycle And Selective Quality Stack

## Status

- Decision ID: `ADR-CODEX-001`
- Status: `accepted`
- Date: 2026-08-12
- Owner: Accelerate root/orchestrator
- Governing issue: `CODEX-1`
- Related SDD: `2026-08-12-quality-engineering-stack-sdd.md`
- Selective-adoption evidence:
  `../evidence/dated-proof-appendix/quality-stack-selective-adoption-matrix-2026-08-12.md`
- Supersedes: none
- Superseded by: none

## Context

Accelerate has strong post-code governance but does not uniformly enforce the
pre-code specification/test-design chain. Two upstream repositories contribute
useful techniques, but their runtime assumptions, hooks, personas, metrics, and
code-first/minimal-file biases conflict with the current Codex control plane.

## Decision

Adopt the following durable rules:

1. Every mutation has a semantic SDD mode: `micro`, `standard`, `hierarchical`,
   or `critical`. Physical artifact size is proportional; semantic disposition
   is mandatory.
2. Use `Specification Lifecycle` for the process and `SDD` only for the Software
   Design Document. Use `Source Verification`, `TEST-DESIGN.md`, and `TDD
   Receipt` as distinct concepts.
3. Adapt selected review, security, test-engineering, performance, source, eval,
   and minimalism contracts. Do not import either upstream runtime wholesale.
4. Keep Accelerate as the sole real root orchestrator. Specialists remain
   bounded and cannot own issue topology, integration, external writes,
   review-of-review, acceptance of their own work, or closure.
5. Treat Ponytail-style minimalism as a subordinate post-spec/post-green review
   lens. The smallest acceptable solution is the smallest legible, correct,
   secure, observable, compatible, and testable solution.
6. Promote agent/runtime profiles only after empirical replay. Templates and
   capability contracts may exist before promotion.

## Consequences

Positive:

- pre-code design and proof obligations become explicit and testable;
- small work stays small through Spec Capsules rather than empty documents;
- review findings become evidence- and impact-based;
- specialists gain clear boundaries without creating a second orchestrator;
- skill/eval adoption preserves current context-budget architecture.

Costs:

- new templates, validators, tests, and traceability maintenance;
- additional artifacts for standard, hierarchical, and critical work;
- runtime/profile promotion takes longer because replay remains mandatory.

## Rejected Alternatives

- global startup injection of an upstream meta-skill;
- one universal quality agent;
- a mandatory large SDD for every typo or mechanical edit;
- LOC/file-count/coverage/performance numbers as universal gates;
- physical promotion based only on static config and passing unit tests.

## Verification

- contract tests reject mutating work without a valid SDD mode;
- artifact validators reject incomplete dispositions and broken traceability;
- agent policy rejects closure authority, wildcard capability grants, and
  reviewer/writer authority collapse;
- skill structure/parity tests pass;
- empirical restart-dependent proof remains a separate proof lane; generation
  five later observed it and closed CODEX-1 with governed readback.
