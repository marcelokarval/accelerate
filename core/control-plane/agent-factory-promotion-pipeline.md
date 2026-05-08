# Agent Factory Promotion Pipeline

This pipeline defines how candidate agent roles or capabilities can be promoted
inside Accelerate. It is a governance and proof loop only: this cycle does not create an autonomous runtime. RC4/RC5/RC6 do not create a persistent agent
runtime, do not start persistent agents, and does not promote unproven role execution.

## Promotion Status Vocabulary

| Status | Meaning | Honest-use boundary |
| --- | --- | --- |
| `candidate` | A role idea exists and has an intake packet or task rationale. | May be discussed and shaped; must not be selected as an available agent. |
| `scaffolded` | Role instructions, skill envelope, and boundaries are drafted. | May be reviewed; cannot execute outside bounded proof replay. |
| `proof-replay` | The role has replayed representative tasks against fixtures or durable packets. | Proof is bounded to the replay fixtures and must name residuals. |
| `runtime-bound` | The role has an approved runtime binding and cleanup/idle-agent rules. | Requires actual runtime proof; not achieved by this cycle. |
| `available` | The role may be selected under documented gates. | Requires root acceptance, proof locator, demotion rule, and monitoring. |
| `demoted` | The role was removed from availability or returned to draft. | Must name the failed condition and cleanup performed. |
| `blocked` | A blocker prevents safe role promotion. | Must not be used as an operational agent. |

## Pipeline Stages

| Stage | Required content | Proof locator | Promotion gate | Demotion trigger | Cleanup / idle-agent handling |
| --- | --- | --- | --- | --- | --- |
| Candidate role intake | Role name, purpose, non-goals, allowed write scope, forbidden scope, owner lane, reviewer lane, and risk classification. | Task ledger, planning packet, or `core/delegation/` pointer. | Intake is accepted only when the role is bounded and does not bypass root control. | Demote to `blocked` if scope is unbounded or conflicts with repo authority. | Retire stale drafts; close idle task records with residuals. |
| Skill envelope | Required repo-local skills, source-of-truth docs, runtime/tools allowed, provider boundaries, and status vocabulary. | `skills/README.md`; `core/control-plane/skill-sync-topology.md`; relevant skill dirs. | Every mandatory skill exists locally or is recorded as a migration gap before replay. | Demote if the role depends on user-home catalogs or unregistered skills. | Remove unregistered skill references; keep only repo-local envelopes. |
| Proof replay | Golden tasks, negative fixtures, requested-vs-implemented review, self-forensic review, and root review-of-review. | Tests under `tests/`; replay packets under approved planning evidence if non-sensitive. | Replay passes positive and negative checks without optimistic status promotion. | Demote if replay misses residuals, invents proof, or changes forbidden files. | Delete generated transcripts unless approved; preserve only durable proofs. |
| Runtime binding | Runtime adapter, invocation contract, process lifecycle, cleanup trap, provider write boundaries, monitoring, idle detection, demotion route, and root acceptance checklist. | `core/control-plane/runtime-adapter-maturity-dashboard.md`; adapter manifests; runtime packets; bounded candidate proof appendices. | Binding is promoted only after actual bounded runtime proof; this cycle provides criteria and fixture checks only. | Demote if binding lacks cleanup, leaves processes idle, omits idle detection, lacks root acceptance, or claims unavailable runtime. | Kill unmanaged processes; record idle-agent closure; clean temp files and private outputs. |
| Availability decision | Root acceptance, proof locator, owner, demotion criteria, maintenance cadence, and rollback path. | Situation dashboard and capability/maturity dashboards. | `available` requires durable proof, root review, and status-honesty tests. | Demote if proof expires, drift is detected, or maintenance owner disappears. | Update dashboards; remove selection routes; archive obsolete role docs. |

## Current Pipeline Inventory

| Candidate / capability | Status | Proof locator | Blocker | Next proof condition | Owner lane |
| --- | --- | --- | --- | --- | --- |
| Bounded subagent task executor/reviewer | `linked` | `core/delegation/subagent-model.md`; recursive plan and task ledger for RC1..RC6 | Synchronous delegated subagent use exists as a workflow pattern, not an autonomous runtime. | Keep task-level requested-vs-implemented, self-review, and root review-of-review in every delegated task. | root orchestrator + delegation governance |
| Agent factory role promotion | `proof-replay` | This file; `core/delegation/agent-factory-promotion-pipeline.md`; `agents/promotion/bounded-proof-auditor-replay.md`; `planning/evidence/dated-proof-appendix/agent-factory-replay-2026-05-08.md`; `tests/promotion-replay-fixtures.sh` | Replay is fixture-scoped; no runtime binding or autonomous agent runtime proof exists in this cycle. | Keep positive/negative fixtures, cleanup, demotion, and root acceptance checks passing; runtime binding remains a separate future proof. | agent-factory governance |
| Autonomous runtime agent | `blocked` | `core/control-plane/runtime-adapter-maturity-dashboard.md` | No implemented autonomous runtime; no persistent agent monitor; no runtime binding proof. | Implement and prove runtime binding, lifecycle monitoring, cleanup, demotion, and safety gates before promotion. | runtime adapter + root final review |

## Runtime-Bound Candidate Checklist

`runtime-bound` is a runtime status, not a planning aspiration. A candidate role
may be described as a runtime-bound candidate only when a packet names each item
below and keeps any unmet item as a blocker:

1. invocation boundary: command, adapter, permitted inputs, forbidden side
   effects, provider boundaries, and transcript/privacy handling;
2. lifecycle monitor: start signal, heartbeat or equivalent progress signal,
   completion signal, timeout, and owner lane for corrective action;
3. idle detection: criteria for distinguishing healthy long-running work from an
   idle/stalled candidate, plus the root interaction required before replacement;
4. cleanup: owned processes, temp directories, caches, transcripts, private
   provider payloads, and generated outputs are removed or explicitly archived as
   approved evidence;
5. demotion route: exact failed conditions that return the candidate to
   `blocked` or `proof-replay`, including unsupported availability claims;
6. root acceptance: root review-of-review records requested-vs-implemented,
   proof locators, residuals, process cleanup, and status-honesty before any
   selection route is opened.

For RC16, `bounded-proof-auditor` satisfies this checklist only as documented
fixture criteria. It remains `proof-replay`; no autonomous runtime binding or
availability is claimed.

## Required Review Questions

Before any promotion, the reviewer must answer:

1. Does candidate role intake define allowed and forbidden scope?
2. Does the skill envelope use repo-local source-of-truth skills only?
3. Did proof replay include both positive and negative fixtures?
4. Is the runtime binding real, bounded, monitored, and cleaned up?
5. Are cleanup/idle-agent handling rules explicit?
6. Are demotion criteria stronger than the promotion claim?
7. Does the packet avoid claiming autonomous runtime availability without proof?
8. Are residual risks and next steps named?

## Demotion Criteria

Demote a role or capability immediately when:

- proof locators are missing, stale, or substitute-only;
- user-home skills are treated as authority;
- runtime binding is planned but described as available;
- cleanup traps or idle-agent handling are absent;
- task-level review omits requested-vs-implemented or self-forensic review;
- a role edits outside allowed scope without escalation;
- root review-of-review rejects the proof.

## Cleanup Rules

- Close or explicitly mark idle agents; no unmanaged background process may remain
  after a proof replay.
- Remove selection routes for demoted roles.
- Delete generated transcripts, caches, and private provider outputs unless they
  are approved evidence artifacts.
- Keep durable promotion packets and tests in the repository only when they are
  non-sensitive and reproducible.
