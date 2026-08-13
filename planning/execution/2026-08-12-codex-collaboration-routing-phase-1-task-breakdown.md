# Codex Collaboration Routing Phase 1 Task Breakdown

## Status

- Owner: Accelerate root/orchestrator
- Date: 2026-08-12
- Source request: implement the approved bounded adaptations from the complete
  `oh-my-opencode-slim` agent review.
- Active phase: `Execute`
- Related issue: `CODEX-1`

## Scope And Non-Goals

This phase separates bounded research from architecture, makes every Codex
collaboration profile reachable, renders policy-aware spawn packets, specializes
return evidence, and governs reuse/interruption of shared agent sessions.

It does not add process profiles, native tool/MCP isolation, designer, observer,
council, ACP wrappers, or new model allocations. Root retains issue topology,
external writes, integration, review-of-review, and closure.

## Task List

| ID | Task | Acceptance | Proof | Status |
| --- | --- | --- | --- | --- |
| T1 | Add RED contract tests | Covers orphan profiles, research bindings, spawn mismatches, write mode, receipts, lifecycle, and ten-line packet limit | focused shell tests fail for the intended missing behavior | completed |
| T2 | Implement role and topology changes | `research` binds exactly `explorer` and `librarian`; logical research no longer impersonates architecture | policy and topology validators | completed |
| T3 | Implement policy-aware spawn packet | Explicit route, role, profile, model/effort, assignment contracts, scope, proof owner, return fields, and root boundary | valid and invalid CLI scenarios | completed |
| T4 | Implement return and lifecycle doctrine | Role-specific returns plus reuse, no duplicate lane, interruption-not-rollback, and partial-write reconciliation | static contract tests | completed |
| T5 | Reconcile and review | Focused and full suites pass; independent review has no unresolved blocking finding | test receipts, diff review, reviewer packet | completed |

## Dependency Order

1. T1 establishes the executable contract.
2. T2-T4 implement the smallest coherent behavior.
3. T5 revalidates the integrated repository and records governed progress.

## Proof And Stop Rules

- Focused proof: collaboration policy, logical topology, spawn packet, and
  virtual assignment tests.
- Final proof: `bash tests/all.sh`, `git diff --check`, and tracked-tree review.
- Stop if the implementation would require a new Codex `-p` profile or claims
  host enforcement of skills, tools, MCPs, credentials, or filesystem scope.
- Do not close `CODEX-1`; the separate Plane MCP hardening lane remains open.

## Residual Risks

- Native `collaboration.spawn_agent` still receives assignment text and explicit
  model/effort, not a logical Codex process profile.
- Assignment allowlists remain auditable contracts, not host enforcement.
- Interruption can leave shared filesystem changes; root reconciliation is a
  mandatory operational boundary, not an automatic rollback.

## Execution And AI Review Result

- TDD: focused tests were observed failing for the missing lifecycle,
  policy-aware renderer, research role, and return-field behavior before the
  implementation made them green.
- Focused proof: collaboration policy, logical topology, spawn packet, virtual
  assignment, runtime sync, global mirror stage, host export, and diff checks
  passed.
- Integrated proof: `bash tests/all.sh` completed with `all tests passed` after
  the final adversarial corrections.
- AI Review Report: no current P0-P3 finding. During review, invalid policy,
  invalid topology, unsupported write mode, wrong return contract, and wildcard
  scopes were reproduced; each now fails closed with a semantic regression test.
- Scope reconciliation: no new process profile, designer, observer, council, or
  host-isolation claim was introduced.
- Closure posture: Phase 1 is acceptable for source integration and global
  runtime sync. `CODEX-1` remains open for its separate Plane MCP hardening lane.
