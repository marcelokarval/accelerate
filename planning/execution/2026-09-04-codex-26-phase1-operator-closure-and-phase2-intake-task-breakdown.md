# CODEX-26 — Prompt I Planning-Only Task Breakdown

## Status

- Owner: Accelerate root control plane
- Date: 2026-09-04
- Source request: proceed after Prompt H, with Accelerate authoring prompt
  hardening and SDD/task strategy
- Source SDD:
  `planning/architecture/2026-09-04-codex-26-phase1-operator-closure-and-phase2-intake-sdd.md`
- Source evidence:
  `planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-h-task-h12-closure-review-go.md`
- Active phase: `Plan`; planning-only
- Related issue: Plane `CODEX-26` (read-only reference; current known state:
  `In Progress`)

## Source Artifact Sufficiency

- Product value clear: yes — preserve a trustworthy transition from validated
  Phase 1 to a separately authorized Phase 2.
- Acceptance clear: yes for decision preparation; no for Plane mutation or
  Phase-2 implementation.
- Technical ownership clear: yes — root/core owns strategy; adapters own
  effective provider mapping.
- Dependencies clear: yes.
- Proof lane clear: planning cross-read now; provider readback only in a future
  authorized lifecycle run.
- Missing artifact or blocker: exact operator authority and exact Plane target
  state for closure; separate Phase-2 authorization.

## Task List

| ID | Task | Goal | Owner or lane | Dependencies | Files or surfaces | Acceptance | Proof | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TASK-I01 | Reconcile and freeze closure decision inputs | Bind Prompt-H GO evidence, freeze and current lifecycle posture into an operator decision packet. | Root, governed Plane read route | Prompt H closure review | closure packet + Plane issue | Exact target operation, authority, candidate digest and readback requirements are explicit. | Fresh governed read before any write; no write in planning. | PASS: decision packet frozen |
| TASK-I02 | Execute Phase-1 closure gate | Perform only the explicitly authorized Plane lifecycle operation and record fresh provider readback. | Root; no executor | I01 + explicit operator action | governed Plane MCP | Provider result and readback prove intended state; otherwise no closure claim. | Mutation receipt + readback + closure packet. | NO-GO: current Plane v3 contract/catalog cannot form a legal closure path; no write occurred |
| TASK-I03 | Create Phase-2 authorization and intake | Form a new bounded Phase-2 source request, authority receipt, PRD-lite/SDD as needed, and task graph. | Root | I02 accepted + separate operator authorization | Plane + `planning/` | Phase-2 scope, non-goals, adapters, risk and proof plan are accepted before `TASKS_READY`. | Fresh authority and SDD review. | BLOCKED: Phase 1 unaccepted |
| TASK-I04 | Discover/reconcile executable lane mappings | Determine which supported adapters can satisfy requested executor, tester, micro-review, QA and macro-review roles. | Read-only research specialist if Phase 2 is authorized | I03 | `adapters/runtime/`, `core/delegation/`, profiles | Effective capability/model/effort receipts replace assumptions. | Adapter contract and negative unavailable-lane proof. | BLOCKED: Phase 2 intake |
| TASK-I05 | Implement portable executive-orchestration policy | Add core doctrine, role contracts, bounded-loop/heartbeat/hygiene enforcement and tests. | Physical implementation worker + independent review, after TASKS_READY | I04 + Phase-2 execution authorization | `core/`, `adapters/`, `profiles/`, tests | Tester, QA, review, attempt budget and heartbeat semantics are separately enforced. | Unit/static + Wave proof + review-of-review. | BLOCKED: Phase 2 authorization |

## Dependency Order

```text
Prompt H GO evidence
        |
        v
TASK-I01 closure-decision packet
        |
 explicit operator authorization
        v
TASK-I02 governed Phase-1 closure + readback
        |
 separate Phase-2 authorization
        v
TASK-I03 Phase-2 SDD/intake -> TASKS_READY
        |
        v
TASK-I04 adapter capability receipts
        |
        v
TASK-I05 physical implementation + tester/micro/QA/macro/root gates
```

## Execution Batches

- Batch 0 (complete): Prompt-I hardening, SDD and planning-only task graph.
- Batch 1 (operator-gated): TASK-I01 then TASK-I02. This is a lifecycle run,
  not a delegation run; it cannot be started by a generic "proceed".
- Batch 2 (separately authorized): TASK-I03 through TASK-I05. After
  `TASKS_READY`, physical child dispatch is mandatory when collaboration is
  available.

## Issue Mapping

- Parent issue: `CODEX-26`, read-only reference in this planning slice.
- Child issues: none created or inferred.
- No-backend exception: not applicable to lifecycle authority; Plane is the
  sole backend.
- Required workflow state: no state change in this artifact-only batch.

## Verification Plan

- Static planning proof: SDD/task graph citation and explicit separation of
  Phase-1 closure from Phase-2 authorization.
- Lifecycle proof: future exact Plane write receipt plus fresh readback.
- Policy proof: future role, loop-budget, heartbeat, cleanup-retention and
  adapter-negative tests.
- Forensic closure: future root review-of-review after the relevant Wave.

## Risks And Blockers

- Risk: conflating `GO_FOR_OPERATOR_PHASE1_CLOSURE` with an accepted/closed
  lifecycle state. Mitigation: only TASK-I02 may make a closure claim.
- Risk: treating provider/model labels as portable behavior. Mitigation:
  TASK-I04 requires adapter receipts.
- Risk: destructive broad cleanup or premature process interruption.
  Mitigation: candidate-bound cleanup and diagnose-before-interrupt contract.
- Blocker: no exact lifecycle action or Phase-2 authorization has been given.

## Definition Of Done

- Implementation complete: not applicable in Batch 0.
- Required proof attached: Prompt-H cross-read and this SDD/task graph.
- Residual risks registered: yes.
- Follow-up issues created or explicitly deferred: deferred; creation is not
  inferred without operator direction.

## Handoff

- Ready for execution: `TASKS_READY` only for preparing the decision packet;
  not ready for a lifecycle mutation or Phase-2 implementation.
- Recommended execution skill or workflow: `accelerate` -> governed `plane`
  lifecycle gate for TASK-I02; then a new Phase-2 Accelerate hardening run.
- Single-threaded exception: planning-only; no task-owned implementation work
  was dispatched or performed.
