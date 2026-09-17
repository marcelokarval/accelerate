# Zero-Waste Dispatch and Readiness Pipeline

## Status and decision

This document records the approved architecture for reducing duplicate repository
discovery across master, worker, and subagent sessions.

Zero-Waste Dispatch is a composed prerequisite of the existing post-spec
delegation dispatch gate. It prepares bounded, source-grounded context before a
physical assignment is dispatched. It is not a new lifecycle, scheduler,
approval authority, or closure authority.

The governing dispatch sequence remains unchanged:

```text
HARDENING
  -> SPEC_READY
  -> TASKS_READY
  -> ROUTE_SELECTED
  -> DISPATCH_REQUIRED
  -> DISPATCHED
  -> EXECUTING
  -> FAN_IN
  -> INDEPENDENT_REVIEW
  -> ROOT_REVIEW_OF_REVIEW
  -> CLOSURE
```

The four-stage pipeline starts after `TASKS_READY` and continues through the
worker return. Its pre-dispatch readiness portion consists of Stage 0, Stage 1,
and the entry checks of Stage 2. Those checks satisfy a prerequisite inside the
existing
[Post-Spec Delegation Dispatch Gate](../../core/control-plane/post-spec-delegation-dispatch-gate.md).
Stage 2 then performs and records physical dispatch, while Stage 3 records
post-execution return evidence. The pipeline does not insert a
`ZERO_WASTE_READY` state or create a competing gate.

## Problem statement

Multi-session execution can waste tokens and latency when every new worker
repeats broad discovery that the root or repository already completed. That
duplicate discovery also increases the chance that workers select different
authorities, infer different boundaries, or act on stale repository state.

The solution is not to prohibit source inspection. The solution is to make the
root prepare the assignment's authoritative starting context, bind that context
to dispatch, and require the worker to stop and request reanalysis when material
contradictions appear.

Success means less repeated discovery with unchanged governance and proof
strength. It does not mean zero uncertainty, zero verification, or blind trust
in cached summaries.

## Authority and invariants

This architecture composes with these existing repository authorities:

- [Runtime-neutral Delegation Semantic Core](../../core/delegation/runtime-neutral-delegation.md)
  and its [machine schema](../../core/delegation/runtime-neutral-delegation.schema.json)
  define portable delegation meaning before runtime projection.
- [Assignment Ontology](../../core/delegation/assignment-ontology.md) defines
  authority, work, verification, review, scope, domain, proof, and physical
  identity boundaries.
- [Subagent Model](../../core/delegation/subagent-model.md) keeps planning,
  dispatch, fan-in, integration, review-of-review, and closure root-owned.
- The current [Delegation Dispatch Receipt](../../core/runtime-packets/delegation-dispatch-receipt.schema.json)
  governs physical dispatch, budget, reviewer binding, and the root write lock.
- The [Task Graph](../../core/task-graph/README.md) is planning-only and cannot
  authorize dispatch or closure.
- The [Heartbeat and Reanalysis Contract](../../core/task-graph/heartbeat-reanalysis-contract.md)
  governs post-dispatch observation, staleness, and reanalysis.
- The [Agent Return Packet](../../core/runtime-packets/agent-return-packet.md)
  and [Runtime Packet Templates](../../core/runtime-packets/templates.md) keep
  worker claims separate from independent acceptance and root closure.

Zero-Waste Dispatch must preserve all existing invariants:

- no more than three active physical assignments under the current policy;
- independent reviewer identity and call isolation;
- non-overlapping executor write scopes;
- an exact root lock over dispatched executor scopes;
- root-owned fan-in, integration, external mutation, review-of-review, and
  closure;
- no task-owned mutation before required physical dispatch;
- no provider observation promoted into repository authority by implication;
- no worker self-review accepted as independent review.

## Acyclic contract lineage

Preparation, dispatch, observation, and return evidence must form a one-way
lineage:

```text
dispatch preparation -> planning and source artifacts
dispatch receipt      -> dispatch preparation
heartbeat             -> dispatch receipt
worker return         -> assignment + preparation + resulting candidate
```

Preparation must not depend on a future dispatch receipt or heartbeat. A
heartbeat binds physical assignment, agent, call, candidate, and dispatch
receipt identifiers after dispatch. Reversing either dependency would create a
validation cycle or require mutating an already digest-bound artifact.

## Four-stage readiness and execution pipeline

### Stage 0: Cartography

The root constructs the smallest sufficient repository map for the requested
work. Repository sources are always sufficient to build the minimum map;
external or persistent providers are optional accelerators.

Required output:

- the full delta baseline: HEAD, parents, branch or detached state, upstream
  divergence, staged paths, unstaged paths, untracked paths, fingerprints, and
  active Git operation or conflict state;
- governing source locators and verified SHA-256 digests;
- relevant contracts, symbols, dependencies, call paths, and integration seams;
- authority classification for every source used;
- explicit coverage, exclusions, known unknowns, and unsafe assumptions;
- provider provenance and freshness when an optional provider contributes.

Cartography answers what relevant structures and relationships are observed. It
does not decide assignment authority, approve a scope, authorize mutation, or
close a gate.

### Stage 1: Master Preparation

The root compiles one bounded context manifest for every assignment. The
manifest contains the facts the worker needs to begin from an informed state,
without embedding full transcripts or an unbounded repository dump.

Each manifest must identify:

- run, task, wave, assignment, and role identifiers;
- objective, acceptance criteria, explicit non-goals, and stop conditions;
- quality class, requested model, reasoning effort, and `fork_turns`;
- dependencies and readiness of predecessor assignments;
- bounded read, write, and forbidden scopes;
- exact pre-read sources, anchors, locators, and verified digests;
- applicable contracts, seams, risks, and proof lanes;
- required positive, negative, and boundary verification;
- expected return and evidence shape;
- independent reviewer binding;
- prohibited authority, including workflow mutation and closure;
- context gaps that still require bounded worker verification.

Preparation fails closed when authority is unresolved, required sources cannot
be verified, the baseline is stale, scopes conflict, a reviewer is missing, or
the selected runtime is unsupported or not freshly callable.

### Stage 2: Dense Dispatch

Dense Dispatch sends the curated context manifest with the assignment and binds
both to the physical dispatch receipt. Dense means precise, bounded, and
traceable; it does not mean verbose or transcript-complete.

The dispatch binding must prove:

- the exact `dispatch-preparation` artifact and digest;
- the exact per-assignment context manifest and digest;
- agreement among task identity, dependencies, scopes, proof requirements, and
  reviewer identity across preparation and dispatch;
- requested and effective physical runtime bindings where the adapter can
  provide them;
- the unchanged budget, reviewer independence, and root write-lock invariants.

Dispatch may proceed only after the preparation artifact and all referenced
bytes are resolved safely and their digests are verified. A digest-shaped
string without file resolution and byte verification is not an integrity proof.

### Stage 3: Direct Evidence Profile

The worker returns minimal, direct, mechanically verifiable evidence. The
informal label `Caveman Evidence` refers only to this concise reporting posture;
it is not a new packet authority, review role, or acceptance mechanism.

The Direct Evidence Profile extends the existing Agent Return Packet during a
future implementation. It must include:

- assignment, context-manifest, baseline, and resulting candidate bindings;
- changed paths and the actual scope touched;
- commands or procedures executed, working directory, timestamps, and exit
  status;
- bounded captured output or a safe locator plus verified digest;
- positive, negative, and boundary check results;
- requested-versus-implemented reconciliation;
- skipped checks and their reasons;
- artifacts produced and their digests;
- residual risks, unsupported claims, and reanalysis requests;
- worker self-review and self-forensic review.

Statements such as `implemented successfully` or `tests pass` are not sufficient
without direct evidence. Direct evidence remains an input to independent review
and root review-of-review; it cannot approve or close its own assignment.

## Dispatch-preparation contract

The first implementation slice should add one runtime-neutral preparation
contract rather than separate cartography, context, and evidence schemas. Its
proposed machine authority is:

```text
core/runtime-packets/dispatch-preparation.schema.json
```

The closed contract should contain:

- `contract_version`;
- run and route identity;
- hardening, specification, task-graph, and authority-set bindings;
- the complete delta baseline and observation time;
- source cartography with locators, digests, coverage, and gaps;
- optional observational provider records;
- per-assignment context manifests;
- freshness and invalidation rules;
- readiness state and typed blocking reasons.

The schema must use closed objects, deterministic ordering where required, safe
repository-relative locators, lowercase SHA-256 digests, and explicit enum
vocabularies. Semantic validation must verify referenced bytes, assignment/task
membership, dependencies, scope agreement, reviewer binding, and baseline
currentness. Schema validation alone is insufficient.

The runtime-neutral delegation schema should not receive provider names,
provider commands, session identifiers, or vendor-specific payloads as part of
this slice.

## Dispatch receipt evolution

The current receipt contract remains `v1.0`. A future `v1.1` must be an
explicitly selected, closed schema and validator branch rather than an implicit
additive interpretation.

`v1.1` adds:

- a verified locator and digest for `dispatch-preparation`;
- a manifest identifier and digest for every physical assignment;
- cross-contract checks binding assignments to the prepared task, scopes,
  dependencies, proof, and reviewer.

Compatibility rules:

- valid `v1.0` receipts remain valid under the frozen legacy branch;
- `v1.0` receipts cannot claim Zero-Waste compliance;
- a run selected for Zero-Waste cannot downgrade to `v1.0` silently;
- mixed `v1.0` and `v1.1` shapes fail closed;
- unknown versions fail closed;
- readers and validators must support `v1.1` before producers emit it;
- making `v1.1` the default or retiring `v1.0` requires separate operator
  approval.

This decision does not generalize the existing Codex-coupled receipt into a
universal runtime receipt. That compatibility migration remains a separate
architectural slice.

## Observational provider boundary

Graph and memory tools may reduce discovery cost, but they do not replace
repository authority. Every optional provider is fail-closed and must report
its identity, artifact kind, locator, digest, generation time, subject baseline,
coverage, known limitations, and invalidation conditions.

Current repository posture at the time of this decision:

| Provider | Current posture | Permitted role |
| --- | --- | --- |
| Graphify | No `graphify-out/` artifact was present during planning; no repo-owned core adapter is established. | Optional observation after capability and freshness proof. |
| Archify | The [Archify boundary](../../core/control-plane/archify-visual-adapter.md) is source-only and visualization-only; it is not repository extraction or runtime truth. | Render validated typed IR without becoming authority. |
| Reversa | No repo-owned adapter or contract is present. | Unavailable until separately imported, adapted, registered, and validated. |
| `codebase-memory-mcp` | No repo-owned adapter or contract is present. | Unavailable until separately imported, adapted, registered, and validated. |

A missing provider never blocks source-based cartography. A declared provider
whose output is stale, unverifiable, contradictory, or outside its proved
coverage cannot contribute to readiness. No provider may authorize scope,
mutation, dispatch, acceptance, promotion, or closure.

Provider implementations belong behind repository-owned adapters. Core consumes
only typed, provenance-bound observations and never imports provider-specific
binaries, commands, credentials, or network clients.

## Blind archaeology and legitimate verification

Blind archaeology is broad, unguided discovery performed because the worker was
not told what it owns, which authorities govern it, or where the relevant seams
are. Dense Dispatch prohibits assigning implementation work in that shape.

The prohibition does not prevent a worker from:

- reading the source files inside its declared scope;
- following bounded dependencies needed to validate the supplied context;
- checking current types, callers, tests, and runtime behavior;
- identifying stale, contradictory, or incomplete preparation;
- requesting reanalysis when the assignment no longer matches repository truth.

If verification reveals material scope drift, an authority conflict, stale
inputs, or an undeclared seam, the worker must stop task-owned mutation and
return a typed reanalysis request. The root then reconciles the task graph and
preparation artifact. The worker must not resolve global ambiguity by expanding
its own scope.

## Freshness and invalidation

Preparation binds the same complete delta-baseline vocabulary used by the task
graph. Freshness is not represented by HEAD alone or by a preparation timestamp.

Before dispatch, validation compares the prepared baseline with a fresh
repository observation. Relevant Git, specification, scope, contract, runtime
capability, or review/evidence change invalidates readiness. Active conflicts
that overlap a write scope block the run.

After dispatch, the existing heartbeat contract binds physical identifiers and
the dispatch receipt. Preparation cannot renew a heartbeat, grant a lease,
repair Git, or waive reanalysis. Executor changes are reconciled through
root-owned fan-in and candidate-freeze checkpoints rather than being excluded
from staleness rules.

## Readiness checklist

Zero-Waste Dispatch is ready only when every applicable item is true:

- [ ] The run has reached `TASKS_READY` with frozen hardening, specification,
      and task-graph artifacts.
- [ ] The route and delegation budget are explicit.
- [ ] The full repository delta baseline is captured and current.
- [ ] Governing sources resolve safely and their bytes match recorded digests.
- [ ] Source-based cartography covers every assignment's relevant surface and
      seam.
- [ ] Optional provider evidence is provenance-bound, fresh, within coverage,
      and classified as observational.
- [ ] Every assignment has one bounded context manifest.
- [ ] Objectives, acceptance criteria, non-goals, and stop conditions are
      explicit.
- [ ] Read, write, and forbidden scopes are explicit.
- [ ] Executor write scopes are non-overlapping.
- [ ] Dependencies and waves are valid and ready.
- [ ] Required positive, negative, boundary, and seam proof is named.
- [ ] Every executor has an independent reviewer.
- [ ] The physical budget does not exceed the current maximum of three.
- [ ] The exact root write lock can be installed over executor scopes.
- [ ] Runtime capability and callability are freshly proven.
- [ ] No unresolved authority conflict, stale input, unsafe assumption, or
      blocking context gap remains.
- [ ] Dispatch `v1.1` can bind the preparation artifact and every assignment
      manifest without mixed-version fields.
- [ ] The worker return contract requires the Direct Evidence Profile.
- [ ] Fan-in, independent review, review-of-review, and closure remain root-owned.

## Six-step implementation plan

### 1. Establish doctrine and ownership

Extend the existing post-spec dispatch gate and ownership/index surfaces to
define the composed prerequisite, four stages, blind-archaeology boundary,
blocking rules, and acyclic lineage. Do not add a lifecycle state or competing
gate.

### 2. Implement the preparation contract

Add `dispatch-preparation.schema.json`, a fail-closed validator, positive
fixtures, and negative fixtures. Cover missing source cartography, malformed or
unsafe locators, digest tampering, stale baselines, unknown fields, unresolved
gaps, assignment mismatch, and unsupported readiness claims.

### 3. Bind preparation to dispatch `v1.1`

Add the explicit `v1.1` schema and validator branch while freezing `v1.0`
behavior. Bind the preparation artifact and each assignment manifest. Preserve
all existing budget, physical identity, reviewer, scope, exception, fan-in, and
root-lock checks.

### 4. Extend the Agent Return Packet

Add the Direct Evidence Profile to the existing return contract and packet
index. Test candidate/context binding, changed-scope disclosure, command or
procedure results, exit status, evidence locators and digests, skipped checks,
requested-versus-implemented reconciliation, and residual risks. Do not create
a new acceptance authority.

### 5. Integrate freshness and reanalysis

Reuse the task graph's full delta baseline and typed invalidation model. Add
cross-contract tests for Git changes, active operations, specification or scope
changes, capability drift, preparation tampering, and post-dispatch heartbeat
lineage. Preserve fail-closed behavior and root-owned reconciliation.

### 6. Roll out and verify

Run focused schema, validator, dispatch, task-graph, packet, and doctrine tests,
then the aggregate suite. Introduce Zero-Waste `v1.1` as explicit opt-in or
shadow validation first. Collect compatibility evidence across supported
runtime projections. Default activation, provider activation, promotion of any
external observation into doctrine, and removal of `v1.0` each require a
separate operator decision.

## Acceptance criteria

The architecture is implemented successfully when:

- repository-only cartography works without any optional provider;
- stale or unverifiable observations fail closed;
- preparation locators and digests are resolved and verified against bytes;
- every dispatched assignment is bound to one immutable context manifest;
- legitimate bounded worker verification remains possible;
- material contradictions stop mutation and trigger reanalysis;
- physical budget, reviewer independence, write-scope separation, and exact
  root locking remain unchanged;
- `v1.0` compatibility is preserved without allowing Zero-Waste claims;
- selected `v1.1` runs cannot dispatch without valid preparation;
- worker narrative without direct evidence cannot support fan-in acceptance;
- independent review and root closure remain mandatory;
- focused and aggregate repository validation pass.

## Non-goals

This decision does not:

- implement a cartography provider or memory engine;
- qualify Graphify, Archify, Reversa, or `codebase-memory-mcp` as callable;
- install or invoke an external dependency;
- change runtime support or promotion status;
- generalize the current dispatch receipt across all runtimes;
- authorize child workflow or Plane mutation;
- eliminate worker verification or independent review;
- modify the task graph into a scheduler or dispatch authority.
