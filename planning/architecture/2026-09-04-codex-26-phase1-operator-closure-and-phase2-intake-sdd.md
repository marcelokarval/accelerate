# CODEX-26 — Phase-1 Operator Closure and Phase-2 Intake SDD

## Status

- Owner: Accelerate control plane / root orchestrator
- Date: 2026-09-04
- Source request: proceed after Prompt H; Accelerate, rather than a caller or
  an executor, must produce the prompt-hardening and SDD strategy.
- Source evidence:
  - `planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-h-task-h12-closure-review-go.md`
  - `planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-h-candidate-g3-freeze.json`
- Related issue: Plane `CODEX-26` / `549d5c6e-9066-440c-85a6-973a33b7eefe`
- Active phase: `Design -> Plan`; planning-only
- SDD mode: `critical`

## Prompt Hardening Packet

- level: full
- goal: turn the technically supported Prompt-H result into an explicit,
  operator-owned Phase-1 closure decision and a safe, blocked Phase-2 intake.
- done means: an operator can distinguish the permitted closure decision from
  a later Phase-2 authorization, with a bounded task graph and no implied
  lifecycle mutation.
- success criteria:
  - Prompt H is reconciled as `GO_FOR_OPERATOR_PHASE1_CLOSURE`, not acceptance;
  - Phase-1 closure and Phase-2 authorization are separate decisions;
  - the executive-orchestration policy has an implementation-ready ownership
    boundary without changing runtime behavior in this planning slice;
  - no Plane, runtime, source-promotion, or release action occurs.
- constraints:
  - Plane remains the sole work-item authority and is read/write governed;
  - the current work item remains `In Progress` until an authorized lifecycle
    operation is executed and read back;
  - only a supported/callable runtime adapter may physically dispatch an
    execution task after `TASKS_READY`;
  - `--yolo`/`dangerous` affects interaction friction only; it cannot waive
    authority, scope, proof, or tool-policy gates.
- output:
  - this SDD;
  - the dependency-aware Prompt-I task breakdown;
  - an explicit stopped state pending a separately authorized closure action.
- stop rules:
  - stop after the planning artifacts are persisted;
  - do not transition Plane, accept Phase 1, enter Phase 2, promote a runtime,
    sync a catalog, commit, push, merge, deploy, or release;
  - if an operator asks for closure, first create a closure-specific execution
    packet with exact Plane transition target and fresh provider readback;
  - if an operator asks for Phase 2, require a valid Phase-2 authorization and
    a new SDD/task graph before implementation.
- explicit non-goals:
  - implementing a new executor/reviewer prompt in runtime profiles;
  - correcting Prompt-H code or re-running its completed proof without a
    concrete invalidation signal;
  - assuming a root model identity, a provider model alias, or an adapter
    capability from prose alone;
  - creating or closing a Plane issue.
- risks or ambiguity resolved:
  - `Codex Terra` is a desired role route, not an assertion about the current
    root model. The runtime adapter must issue the effective model receipt.
  - a three-minute silence is a heartbeat trigger, not proof of a hung build.
    Root records meaningful progress, diagnoses once, then interrupts only a
    genuinely stalled worker and preserves durable evidence.
  - cache cleanup is limited to known regenerable paths owned by the active
    task. Reports, structured logs, frozen evidence, and implemented source are
    retained.
- proof required:
  - source/evidence cross-read;
  - task-graph review for authority and dependency separation;
  - no external mutation in this planning slice.
- hardened artifact: present
- Prompt A: "Proceed after Prompt H without relaxing controls. Accelerate must
  create the hardening and SDD strategy for the next work, including the
  requested executor, micro-review, macro-review, loop, heartbeat, and hygiene
  concepts."
- Prompt B: "Create a planning-only, critical SDD and dependency-aware task
  graph that (1) prepares an operator-owned Phase-1 closure decision from the
  frozen Prompt-H GO evidence and (2) keeps Phase-2 intake blocked until a
  separate authorization. Specify the portable executive-orchestration policy
  as a future core/profile design target. Do not mutate Plane, accept Phase 1,
  begin Phase 2, or promote/release/sync source."
- material changes: planning artifacts only
- bounded scope: `planning/architecture/` and `planning/execution/` artifacts
  for CODEX-26 transition planning
- next branch or route: planning-only; stop at `TASKS_READY` for decision
  preparation, not physical execution
- full artifact location: this file

## Design Problem

Prompt H supplied technically reviewed closure-preparation evidence, while the
only next lifecycle action is explicitly operator-owned. The user also supplied
an executive loop preference: Accelerate authors hardening/SDD/task strategy;
an implementation lane produces bounded work; an independent micro-reviewer
checks each task; a macro reviewer is used at a completed Wave; heartbeats and
cleanup prevent unobserved stalls and residual noise.

The design must preserve that useful control shape without falsely turning a
preference into a provider guarantee, blurring tester/QA responsibilities, or
letting a session directive bypass the root control plane.

## Constraints And Drivers

- Product constraints: preserve a portable, harness-agnostic Accelerate core.
- Workflow constraints: Plane is authoritative; this repository's local
  workflow surfaces are evidence/projections, not a substitute lifecycle API.
- Runtime constraints: model/provider selection is adapter-resolved and
  receipted. A current session cannot claim a fixed `Codex Terra` identity just
  because a policy names that class.
- Governance constraints: Prompt H is a technical recommendation only. Its
  `In Progress` Plane readback and `completed_at: null` are not closure.
- Hygiene constraints: cleanup must be narrow and recoverable; immutable proof
  artifacts and audit reports are retained.

## Target Architecture

### Closure decision boundary

```text
Prompt-H frozen candidate + root closure review
                    |
                    v
       operator-specific closure packet
                    |
       exact authorized Plane action + readback
                    |
                    v
      accepted/closed Phase-1 receipt (if approved)
                    |
                    v
 separate Phase-2 authorization -> Phase-2 SDD -> TASKS_READY
```

Neither arrow is implicit. A Phase-1 closure receipt is evidence for, but not
authorization of, Phase 2.

### Executive-orchestration policy target

The reusable policy belongs in the repo's control-plane doctrine plus an
adapter/profile mapping, rather than in a user-home prompt or an executor-only
skill:

| Concern | Target owner | Rule |
| --- | --- | --- |
| Hardening, SDD, Wave/task graph, fan-in and closure | `core/control-plane/` | Root-owned; executor cannot rewrite its own scope or acceptance. |
| Role taxonomy and permitted capabilities | `core/delegation/` | `executor`, `tester`, `qa`, `micro-reviewer`, and `macro-reviewer` are separate roles, each bounded by receipts. |
| Provider/model selection and process invocation | `adapters/runtime/` | Adapter resolves callable lane and effective model/effort; names in policy are preferences, not authority. |
| Project-specific defaults | `profiles/` | A profile may request Agy-like implementation and Terra/Sol-like review lanes only when the adapter can prove them. |
| Status, heartbeat, artifacts and cleanup | `core/runtime-packets/`, `core/task-graph/` | Observation cannot advance state; cleanup never deletes proof. |

### Role separation

```text
root / Accelerate
  -> specification + task graph + dispatch + review-of-review
executor
  -> bounded implementation and self-proof
tester (adversarial)
  -> actively tries to break the changed domain and its seams
micro-reviewer (independent per task)
  -> verifies scope, proof, defects and correction result
QA (independent product/proof lane)
  -> validates acceptance and regression evidence without the debate history
macro-reviewer (per completed Wave)
  -> architectural, security and cross-task coherence review
```

`tester` is not a synonym for `qa`: testing is adversarial failure discovery;
QA is independent acceptance/proof assessment. Either role can be specialized
by domain (backend, frontend, API, integrations, data, browser), but ownership
and evidence stay distinct.

### Loop and heartbeat policy to implement later

- Each task has at most three material executor-to-micro-review correction
  attempts. On the third failure, mark that task blocked with its evidence and
  advance only dependency-safe work; root returns the blocked decision to the
  operator.
- A tester can join a task's local loop when its domain risk requires active
  attack/failure discovery. It never approves its own correction.
- QA receives the original requirement, final candidate, and proof artifacts;
  it does not inherit the executor/tester debate transcript.
- Macro review occurs only after a Wave's eligible tasks have passed their
  local gates; its failure routes only affected tasks to successor loops.
- After three minutes without meaningful output, root emits a heartbeat record.
  It checks worker/process status and durable artifact delta before interrupting.
  A second stalled interval allows a bounded interrupt/restart from the last
  valid checkpoint. This is monitoring, not an authorization or state advance.

## Data, Contracts, And Surfaces

- Closure contract: exact Plane issue identity, frozen candidate digest,
  authorized lifecycle target, caller/authority, provider response, and fresh
  post-write readback.
- Phase-2 entry contract: a separate current, non-revoked authorization plus
  accepted Phase-1 receipt, selected scope, risk class, SDD, task graph,
  adapter receipt, and proof plan.
- Task contract: task ID, domain path (for example
  `backend -> financial -> gateway -> refund`), goal, non-goals, owner,
  dependency, tester/micro-review/QA applicability, accepted evidence, and
  three-attempt budget.
- Heartbeat contract: candidate/task-bound delta baseline, timestamp, worker
  state, meaningful-progress indicator, and next diagnostic action. It cannot
  close a task, renew authority, or trigger a lifecycle transition.

## Workflow And Runtime Adapters

- Workflow backend: governed Plane MCP for actual lifecycle reads/writes.
- Local planning persistence: repository-local `planning/` artifacts.
- Runtime adapter: selected only through a supported/callable adapter receipt.
- No-adapter rule: a requested external lane that is unavailable remains
  blocked/export-only; root does not silently replace it with an unreviewed
  provider or perform executor-owned work.

## Security, Privacy, And Abuse Posture

- Testers receive least-privilege, bounded workspace/tool scope.
- Independent review uses a clean context with only the requirement, bounded
  candidate, and necessary evidence.
- Secrets never enter task prompts, logs, or evidence packets.
- Adversarial testing is authorized only against the local/approved target
  scope; no production or third-party attack activity is inferred.

## Alternatives Considered

| Option | Benefit | Cost | Decision |
| --- | --- | --- | --- |
| Immediately close Phase 1 and start Phase 2 | Fastest apparent path | Bypasses separate authority and stale-state risk | Rejected |
| Treat the supplied executive prompt as global runtime law now | Simple wording | Assumes models/adapters and weakens repo-owned ownership | Rejected |
| Persist planning-only closure/intake design | Keeps momentum and makes the next decision executable | Does not itself change lifecycle state | Accepted |
| Make tester and QA one role | Fewer agents | Loses adversarial/independent distinction | Rejected |

## Migration And Rollout

1. Operator separately chooses whether to execute Phase-1 closure.
2. Root performs fresh governed preflight and creates a closure-specific
   execution packet with the exact Plane transition operation.
3. Only after successful provider readback is the Phase-1 acceptance receipt
   eligible as input to a distinct Phase-2 intake.
4. Phase 2 first implements/tests the repo-owned executive policy, adapters,
   and role contracts through its own SDD and bounded Waves.

## Test And Proof Strategy

- Planning proof: cross-read Prompt-H closure result, freeze digest and the
  task graph; verify no planning text claims acceptance or Phase-2 entry.
- Closure proof (future): governed preflight, exact mutation receipt, and
  fresh post-write Plane readback.
- Policy implementation proof (future): static role/adapter validators,
  deterministic loop/attempt tests, heartbeat-negative tests, and artifact
  retention tests.
- Runtime proof (future): a bounded Wave with independent tester, micro review,
  QA, macro review and root review-of-review.

## Acceptance To Tasks

- Architecture acceptance: closure and Phase-2 authority are non-transitive;
  policy ownership is core + adapter/profile, not a hidden session prompt.
- Required implementation slices: only after Phase-2 authorization.
- Dependencies: operator closure decision precedes any closure mutation;
  accepted closure plus a separate Phase-2 authorization precede Phase-2 work.
- Known risks: desired provider lanes may be unsupported or unavailable; exact
  Plane target state is not assumed from `In Progress`.

## Handoff Decision

- Ready for executive plan: yes
- Ready for task breakdown: yes, planning-only
- Ready for Phase-1 closure execution: no; separate operator authorization and
  exact lifecycle operation are required
- Ready for Phase-2 execution: no; separate authorization and Phase-2 SDD are
  required
- Issue bootstrap required: no new issue is inferred; `CODEX-26` remains the
  governing read-only reference until an operator authorizes an issue action
- Residual design ambiguity: which supported runtime adapters can satisfy the
  preferred executor/micro/macro lane mapping is a Phase-2 discovery task.
