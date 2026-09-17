# OpenChamber Runtime Adapter Proposal

## Status and decision

This document is an architecture proposal. It does not implement, install,
activate, or qualify an OpenChamber runtime adapter. Repository sources remain
the governing authority; OpenChamber observations recorded here are runtime
evidence, not doctrine. This distinction follows the repository source boundary
in `SKILL.md` and `README.md` and the projection boundary in
`core/control-plane/cross-runtime-bootstrap.md`.

The recommendation is to build a direct native adapter under
`adapters/runtime/openchamber/`, initially register it in the cross-runtime
bootstrap manifest as `staged-only` with `apply_eligible=false`, and fail closed
until its physical session, worktree, fan-in, reviewer-isolation, model-readback,
timeout, and cleanup contracts are qualified. The runtime consumer registry has
a different, closed status vocabulary. Its initial OpenChamber entry MUST be
`legacy-reference` with `projection.mode=reference-only`, not a newly invented
`staged-only` value.

In this document, **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY**
are normative. Headings ending in `: fact` describe current repository or
observed runtime truth. All other architecture, lifecycle, migration, and
qualification sections are proposals unless they explicitly state otherwise.

## Goals and non-goals

### Goals

The adapter SHOULD make OpenChamber a native Accelerate runtime binding for
physical multi-session collaboration while preserving:

- Standing Multi-Agent V2 dispatch before task-owned mutation at `TASKS_READY`;
- bounded executor and reviewer sessions with explicit model and quality intent;
- deterministic isolation for write-bearing assignments;
- root-owned fan-in, integration, review-of-review, promotion, and closure;
- runtime-neutral assignment and receipt semantics;
- fail-closed behavior when runtime truth, readback, or cleanup is incomplete;
- strict separation between runtime dispatch and workflow/issue operations.

### Non-goals

This proposal does not:

- claim that OpenChamber is currently supported, callable for delegation, or
  apply-eligible;
- create an OpenChamber session, worktree, branch, or external mutation;
- make OpenChamber an issue tracker or Plane adapter;
- authorize children to mutate Plane or close work items;
- preserve the current Codex-specific dispatch receipt unchanged;
- define silent or seamless fallback to Codex, a generic physical-agent path,
  virtual packets, or root-owned task execution;
- promote a runtime from documentation or static fixtures alone.

## Authority and current truth

### Repository authority: fact

Accelerate is the root control plane. It owns classification, hardening, issue
topology, lane order, delegation budget, proof order, review, and closure
(`SKILL.md`, `README.md`). Runtime adapters translate capability-level
expectations into concrete tools and evidence but do not own root closure,
issue topology, or authority selection
(`adapters/runtime/adapter-contract.md`). A physical runtime remains subordinate
to Accelerate and cannot own the task ledger, role-family selection,
review-of-review, final forensic closure, or `Done`
(`adapters/runtime/physical-agent/README.md`).

For orchestrated execution, Standing Multi-Agent V2 requires physical dispatch
after `TASKS_READY` and before the first task-owned mutation when a supported,
callable collaboration primitive exists. The root retains hardening, SDD/PRD,
task graph, dispatch, fan-in, integration-only repairs, review-of-review,
promotion, and closure (`SKILL.md`,
`core/control-plane/post-spec-delegation-dispatch-gate.md`, and
`core/control-plane/orchestrator-first-execution-gate.md`). A virtual packet or
single-threaded exception is a blocker, not a substitute for available physical
dispatch.

The common delegation model is runtime-neutral. Its machine schema records the
run, policy, state, budget, assignments, exceptions, fan-in, review,
root ownership, and promotion. Runtime-specific model names and primitives
belong outside the semantic core
(`core/delegation/runtime-neutral-delegation.md` and
`core/delegation/runtime-neutral-delegation.schema.json`).

### Bootstrap and registry status: fact

`adapters/runtime/cross-runtime-bootstrap-manifest.json` currently names Codex
as the sole `supported`, `apply_eligible=true` runtime. OpenHands and Claude are
`export-only`; Hermes is `staged-only`; OpenCode and OpenClaw are
`legacy-reference`. The bootstrap rule permits native physical dispatch only
when the selected adapter is both supported and freshly callable. Every other
status reports itself and stops without silent fallback
(`core/control-plane/cross-runtime-bootstrap.md`).

The separate `adapters/runtime/runtime-consumer-registry.json` is an inventory,
not installation, activation, or callability proof. Its validator currently
accepts only `supported`, `blocked`, `export-only`, and `legacy-reference`, and
its `RUNTIMES` denominator is the closed set `codex`, `openhands`, `hermes`,
`opencode`, `openclaw`, and `claude`
(`scripts/validate-runtime-delegation-semantics.py`). Consequently:

- the bootstrap manifest SHOULD add OpenChamber as `staged-only` and
  `apply_eligible=false` during implementation;
- the consumer registry MUST add OpenChamber as `legacy-reference` with a
  `reference-only` projection, `loader=none`, and proof that explicitly says
  runtime callability is unproven;
- the two files MUST retain their existing vocabularies rather than forcing one
  registry's status into the other;
- both statuses MUST remain non-operational until runtime evidence justifies a
  synchronized promotion.

### OpenChamber runtime observation: fact

Initial observation successfully exercised OpenChamber `models.list` and
`projects.list`; `projects.list` found the project `accelerate`. Subsequent
empirical dispatch telemetry established a narrower but critical binding fact:
passing `model` and `variant` to `session.create` can still allow the session's
default agent preset to select its configured model, while passing both fields
explicitly in `session.send` overrides that preset. A three-second telemetry
readback confirmed execution on the model and reasoning variant requested in
the send payload. This proves the send-time binding behavior observed in that
test; it does not by itself qualify the full lifecycle, isolation, cleanup, or
promotion contract.

The visible OpenChamber surface advertises:

- `session.create`;
- `session.send`;
- `session.fork`;
- `session.status`;
- `session.messages`;
- optional worktree and branch creation during `session.create`;
- immediate return from dispatch by default;
- blocking fan-in through
  `session.messages(wait=true,lastAssistant=true)`.

Except for the observed send-time model and variant override, these are
candidate mappings pending qualification, not proof of lifecycle correctness,
isolation, bounded parallel execution, write-scope enforcement, timeout
handling, cleanup, or closure safety. In particular, the advertised surface
does not include cancellation or session deletion. That absence is a material
blocker to fully supported write-bearing orchestration unless an equivalent
containment and retention contract is qualified.

## Recommended architecture

### Direct native adapter

OpenChamber SHOULD be represented by a dedicated adapter rather than hidden
inside another runtime. The proposed boundary is:

```text
Accelerate root control plane
  -> runtime-neutral assignment and quality class
  -> OpenChamber adapter preflight and role binding
  -> OpenChamber project/session/worktree primitives
  -> runtime-neutral dispatch and return receipts
  -> root fan-in, integration, independent review, and closure
```

The adapter MUST translate Accelerate semantics into OpenChamber calls and
translate OpenChamber readback into repository-owned receipts. It MUST NOT move
OpenChamber-specific tool names, session identifiers, or model identifiers into
`core/delegation/runtime-neutral-delegation.schema.json`.

### Proposed adapter artifacts

The initial implementation SHOULD add the following repository-owned artifacts:

| Artifact | Responsibility |
| --- | --- |
| `adapters/runtime/openchamber/README.md` | Authority boundary, lifecycle, preconditions, mappings, blockers, and cleanup contract. |
| `adapters/runtime/openchamber/capabilities.yaml` | Registry-contract fields, supported candidate primitives, suppressed root capabilities, proof artifacts, and privacy boundary. |
| `adapters/runtime/openchamber/role-policy.json` | Semantic role and quality mapping, model-selection constraints, concurrency cap, session/worktree policy, and reviewer independence. |
| `adapters/runtime/openchamber/delegation-contract.md` | Static projection used while the consumer registry remains reference-only. |
| `adapters/runtime/openchamber/openchamber-dispatch-receipt.schema.json` | Adapter-specific extension fields for session, project, worktree, readback, terminal state, and cleanup. |
| `scripts/validate-openchamber-runtime-adapter.py` | Static policy, receipt, fixture, and fail-closed validation without external mutation. |
| `tests/test_openchamber_runtime_adapter.py` | Fake-adapter contract and negative tests. |
| `tests/fixtures/openchamber-runtime/` | Non-sensitive preflight, create-preset fallback, send-time binding, fan-in, mismatch, timeout, partial dispatch, review, and cleanup fixtures. |

The adapter-specific receipt SHOULD compose with a new runtime-neutral dispatch
receipt rather than fork core semantics. The exact executable packaging MAY
change, but responsibility MUST remain inside `adapters/runtime/openchamber/`
and supporting repository scripts/tests.

### Capability and authority boundary

The capability manifest MUST satisfy
`adapters/runtime/adapter-registry-contract.md`: `name`, `type`, `status`,
`authority_boundary`, `allowed_tools`, `suppressed_capabilities`,
`validation_command`, `proof_artifacts`, and `privacy_notes`. Initial adapter
status SHOULD be `planned` under that contract because static material alone is
not an operational runtime.

The manifest MUST suppress at least:

- run classification;
- issue topology and task-ledger authority;
- role-family selection;
- external workflow mutation;
- review-of-review;
- promotion;
- root closure and `Done`;
- unbounded nested delegation.

Tool, skill, and MCP restrictions MUST be described honestly. If OpenChamber
does not technically enforce them per session, the adapter MUST call them
`assignment-contract-only` or `prompt-contract-only`, never host-enforced
isolation. Wildcard grants MUST be prohibited, consistent with the bounded
Codex pattern in `adapters/runtime/codex-collaboration/`.

## Runtime-truth preflight

Every run that proposes OpenChamber dispatch MUST perform a fresh, read-only
preflight before `DISPATCH_REQUIRED`. Cached observations are insufficient.
Preflight MUST return a durable non-secret receipt and MUST verify:

1. OpenChamber is reachable and its required read primitives are callable.
2. The intended OpenChamber project resolves uniquely to `accelerate`, with a
   stable project identifier or equivalent readback.
3. The canonical target directory resolves to the intended repository and does
   not escape it.
4. The requested model identifiers are present in the fresh model catalog.
5. The runtime can return effective model and variant telemetry or equivalent
   binding readback after `session.send`; if it cannot, binding fidelity remains
   unproven.
6. Required session primitives are advertised with the expected argument and
   response shapes. The OpenChamber schema accepts `model` and `variant` as
   optional `session.send` fields, while the Accelerate adapter can and will
   populate them alongside required `prompt` and `sessionId` fields.
7. Runtime capacity telemetry is recorded as observed or unknown. Unknown MUST
   remain `null`, not zero, as required by the runtime-neutral schema.
8. Worktree creation is available when any assignment has a write scope.
9. Session status and message readback can distinguish active, terminal,
   failed, and nonterminal states.
10. Cancellation, deletion, or an approved equivalent containment/retention
    mechanism is available for the requested risk class.

Preflight MUST produce `BLOCKED` for any write-bearing orchestrated run when
item 10 is absent. A controlled read-only qualification MAY proceed under an
explicit retention disposition because it does not create a write-bearing
child workspace, but it MUST NOT be used to claim full support.

## Role, model, and quality mapping

Accelerate's semantic quality classes remain authoritative. OpenChamber model
IDs are runtime bindings selected from fresh `models.list` output; this proposal
does not hard-code unobserved model names. Each assignment receipt MUST record
both requested and effective bindings.

| Accelerate role/profile | Quality class | Default work mode | OpenChamber binding rule |
| --- | --- | --- | --- |
| Explorer or bounded researcher | `research-low` | Read-only | Select an approved low-cost research model from the fresh catalog; no worktree required. |
| Mechanical fixer | `mechanical-medium` | Bounded write | Select an approved medium mechanical model; isolated worktree required. |
| Executor | `implementation-medium` | Bounded write | Select an approved medium implementation model; isolated worktree required. |
| Runtime or skeptical reviewer | `review-medium` | Read-only | Create a fresh independent session against the frozen candidate; no inherited conversation. |
| High-stakes reviewer | `high-stakes-review` | Read-only | Select an approved high-reasoning model only with the existing reasoning decision receipt. |
| Root orchestrator | `root-orchestration` | Root-owned integration only | Preserve the effective root session model; OpenChamber children never become root. |

The adapter MUST NOT infer success from the requested model. It MUST compare the
requested model and quality intent with effective readback. Missing readback or
a mismatch is a blocking `model mismatch` failure until explicitly adjudicated;
it MUST NOT be silently accepted as equivalent.

### Model & Variant Binding Rule

**Observed fact.** `session.create` is not an authoritative model-binding
surface. Even when its creation request includes `model` and `variant`, the
OpenCode/OpenChamber workspace can apply the session's default agent preset and
run a different model. In the observed test, explicitly repeating `model` and
`variant` in `session.send` overrode that preset and the telemetry readback
matched the requested binding.

#### Schema permissiveness versus governance strictness

**OpenChamber schema level.** `model` and `variant` are technically optional in
`session.send`. Omitting them does not make the tool call invalid; OpenChamber
can inherit the agent preset or a previous session binding. That permissive
schema behavior is runtime capability, not dispatch policy and not evidence of
the Master's intent.

**Accelerate governance policy level.** Accelerate adopts "explicit is better
than implicit." The Master MUST NOT dispatch with an unresolved or inherited
binding. The adapter MUST treat `session.create` as session, project, directory,
branch, and worktree establishment only. Before each work-bearing
`session.send`, the Master MUST resolve the target model and variant, and the
adapter MUST inject both values directly into the payload for initial
assignment, continuation, and correction sends. Under Accelerate governance,
omitting either schema-optional field is a dispatch-contract failure because it
permits silent inheritance from the agent preset or prior session state.

#### Master resolution precedence

The Master MUST resolve exactly one model/variant pair in this order:

1. **Explicit operator override.** A bounded operator instruction such as
   `terra/medium` or `gemini-3.8-flash/low` takes precedence when the requested
   model and variant exist in the fresh catalog and are allowed for the role and
   risk class. An invalid or disallowed override fails closed; it MUST NOT fall
   through silently.
2. **Accelerate reasoning policy.** Without an operator override, apply the
   repository-owned role policy: Luna/low for research, Terra/medium for
   execution and QA, and Sol/high for architecture or other qualified
   high-stakes read-only work. Runtime-specific identifiers MUST be resolved
   from the fresh catalog rather than inferred from aliases alone.
3. **OpenChamber catalog default.** Only when the request and Accelerate policy
   are neutral MAY the Master choose the default returned or unambiguously
   resolved from fresh `models.list` evidence. If no unique default and variant
   can be established, dispatch is `BLOCKED`; the adapter MUST NOT delegate the
   choice implicitly to the agent preset.

The dispatch receipt MUST record the winning precedence source as
`operator_override`, `accelerate_reasoning_policy`, or
`openchamber_catalog_default`, together with the source evidence. This makes the
binding decision deterministic and auditable before runtime execution and makes
cost and latency expectations explicit rather than preset-dependent.

The canonical call envelope is:

```json
{
  "action": "session.send",
  "parameters": {
    "sessionId": "<openchamber-session-id>",
    "prompt": "<immutable-assignment-packet-or-authorized-follow-up>",
    "model": "<providerID/modelID>",
    "variant": "<reasoning-variant>"
  }
}
```

For example, a valid binding can use
`model="google-agy/gemini-3.8-flash"` and `variant="medium"`. The model value
MUST use OpenChamber's `providerID/modelID` format, and the variant MUST be the
master-selected reasoning variant admitted by the current model catalog and
role policy.

The dispatch receipt MUST bind the requested `model` and `variant`, their
precedence source, the target `sessionId`, and a non-secret hash of the exact
prompt/send payload. Post-send telemetry MUST record the effective model and
variant. Missing telemetry, creation-preset fallback, or any
requested/effective mismatch MUST block acceptance as `model mismatch`; the
adapter MUST NOT silently retry with a different binding or accept the agent
preset as equivalent.

## Session, worktree, and branch identity

### Session identity

Each assignment MUST have one newly created session identity bound to exactly
one run, wave, assignment, role, packet hash, and issue context. A recommended
human-readable title is:

```text
accelerate/<run-id>/w<wave>/<assignment-id>/<role>
```

The runtime session ID returned by OpenChamber is the canonical physical
identity. Titles are descriptive and MUST NOT substitute for session IDs.
Session reuse is prohibited unless a retained session is resumed intentionally
for the same assignment and the receipt records the prior terminal/readback
state and authorization.

### Worktree and branch identity

Every write-bearing executor MUST receive a dedicated worktree and branch. A
deterministic convention SHOULD be:

```text
worktree: acc-oc-<run-slug>-w<wave>-<assignment-slug>-<hash8>
branch:   accelerate/openchamber/<run-slug>/w<wave>/<assignment-slug>-<hash8>
```

`<hash8>` SHOULD be the first eight hexadecimal characters of the immutable
assignment packet SHA-256. Slugs MUST be lowercase ASCII, path-safe, bounded in
length, and derived from stable IDs rather than free-form titles. Preflight MUST
reject an existing worktree or branch unless its receipt matches the same run,
assignment, and packet hash. Dirty or ambiguous integration state is a blocker.

Read-only research MAY use the canonical repository directory without a
worktree if the session cannot mutate it. Independent review SHOULD inspect the
frozen integrated candidate through a read-only directory binding or a
deterministic review worktree. In either case, the reviewer MUST receive the
candidate hash and MUST NOT inherit executor conversation.

### Independent review

Independent reviewers MUST use a fresh `session.create`. `session.fork` MUST
NOT be used for independent review because it inherits context and violates the
isolation requirement in `README.md` and
`core/control-plane/orchestrator-first-execution-gate.md`.

`session.fork` MAY be considered only for bounded continuation or correction of
the same assignment after its inheritance, model, identity, and receipt
behavior are separately qualified. A fork MUST retain the same authority
boundary, MUST be linked to its parent session, and MUST NOT manufacture a new
independent-review identity.

## Bounded parallelism and root write lock

The adapter MUST enforce the route budget before dispatch:

- `direct-fast-path`: zero OpenChamber sessions;
- `scoped`: zero or one read-only discovery/proof session; the sidecar cannot
  perform hidden task-owned implementation;
- `orchestrated`: two or three physical bindings, including independent review,
  with no more than three active physical assignments.

Write scopes MUST be non-overlapping. After the first orchestrated physical
dispatch, the root MUST activate an `orchestrated-dispatched-scope-lock` over
the exact child write scopes and MUST NOT perform task-owned writes there. The
root MAY perform integration-only repairs after fan-in and reproof. This
preserves `core/control-plane/post-spec-delegation-dispatch-gate.md` and the
current dispatch receipt's root lock semantics.

Nested delegation is unsupported by this adapter. OpenChamber child sessions
MUST NOT create or restaff sessions. Any future support first requires an
explicit amendment to the core dispatch contract and its validator. That
amendment MUST preserve the currently authorized shape: one root-authorized
Terra-to-Luna mechanical leaf, exact physical budget of three, explicit parent
and delegation references, disjoint scopes, and an independent reviewer. An
adapter-local contract alone MUST NOT broaden that core rule.

## Lifecycle and guards

The proposed OpenChamber lifecycle maps the repository state machine to concrete
session operations without changing root ownership.

| Phase | Runtime action | Entry guard | Exit guard |
| --- | --- | --- | --- |
| `bootstrap/preflight` | Call read-only project/model/runtime discovery. | Repository authority and requested route are known. | Fresh receipt proves exact project, directory, candidate models, primitive shapes, capacity posture, and cleanup posture. |
| `TASKS_READY` | No runtime mutation. | Hardening, spec, and task graph references and SHA-256 hashes are frozen. | Execution requested and route selected, or planning stops here. |
| `role packet compilation` | Translate semantic role/quality into an OpenChamber assignment. | Issue context, scopes, proof, prohibited authority, model intent, and reviewer are known. | Immutable packet hash and deterministic session/worktree identities are recorded. |
| `dispatch` | Use `session.create` for identity and optional worktree establishment, then always use `session.send` with explicit `sessionId`, `prompt`, `model`, and `variant` for the assignment. | Preflight passes; write scopes are disjoint; root write lock can be installed; send-time binding fields match the immutable packet. | Each accepted dispatch returns a unique session ID; post-send telemetry matches the requested model and variant; partial acceptance is recorded, never hidden. |
| `active tracking` | Poll `session.status` or equivalent readback. | Dispatch receipt exists. | Every required session is terminal or a classified timeout/nonterminal failure is recorded. |
| `fan-in` | Use `session.messages(wait=true,lastAssistant=true)` for bounded blocking collection, then preserve output/evidence references. | Required sessions exist and timeout policy is explicit. | Root has a terminal classification and readable output for each required assignment. |
| `integration` | Root inspects returns, integrates selected worktrees, runs seam proof, and records integration-only repairs. | Executor returns are accepted for integration; branch/worktree state is clean and candidate-bound. | Frozen integrated candidate and proof references exist. |
| `independent review` | Create a fresh reviewer session and send only spec, candidate, proof, and review packet. | Candidate hash is frozen; reviewer has a distinct session ID and no inherited context. | Review return is read back, evidence-bound, and classified; findings trigger correction plus fresh reproof. |
| `closure/cleanup` | Root performs review-of-review, issue/workflow reconciliation, and runtime cleanup or retention recording. | Fan-in, integration, review, and reproof are complete. | All sessions/worktrees have a proved cleanup or containment disposition; root alone may close. |

Immediate return from `session.create` or `session.send` means only that dispatch
was accepted. It MUST NOT be treated as task completion. Terminal success
requires status plus output readback and evidence classification.

## Assignment packets and immutable issue context

Each child packet MUST include:

- run, task, wave, assignment, and role identifiers;
- semantic quality class and requested model, variant, and quality;
- model/variant precedence source and its operator, policy, or catalog evidence;
- explicit `reasoning_effort` and `fork_turns`, where `fork_turns=none` is the
  default and only a separately qualified bounded continuation MAY use an
  integer from `1` through `5`;
- canonical project ID and directory;
- session/worktree/branch intent;
- bounded read and write scopes;
- immutable issue context: backend, work-item ID, human locator, lifecycle state,
  and captured update/version time when available;
- hardening, spec, task graph, and assignment packet references and hashes;
- dependencies and expected return contract;
- required proof and prohibited authority;
- timeout and cleanup expectations;
- an explicit statement that the child MUST NOT mutate Plane or any workflow
  backend.

Issue context is evidence for execution, not delegated workflow authority.
Children MUST return proposed workflow observations to the root rather than
posting comments, changing state, creating issues, or closing work.

## Runtime-neutral receipts and readback

### Receipt evolution

`core/runtime-packets/delegation-dispatch-receipt.schema.json` is currently
coupled to `collaboration.spawn_agent`, Codex model enums, `agent_id`, `call_id`,
and Codex fork semantics. OpenChamber MUST NOT emit an inaccurate receipt that
pretends `session.create` is `collaboration.spawn_agent`.

Implementation SHOULD introduce a runtime-neutral successor, for example
`core/runtime-packets/runtime-delegation-dispatch-receipt.schema.json`, with:

- a runtime-neutral primitive name and adapter identity;
- portable physical assignment and invocation IDs;
- requested/effective binding objects rather than Codex-only model enums;
- adapter extension references for OpenChamber session/worktree fields;
- the existing artifact hashes, route, bounded budget, fan-in owner,
  exceptions, and root write-lock invariants.

The existing Codex receipt SHOULD become a validated projection of that common
shape or remain versioned for Codex while migration is completed. Compatibility
MUST be explicit; the system MUST NOT broaden the old schema until it accepts
semantically false values.

### Required fields

For every OpenChamber assignment and lifecycle transition, receipts/readback
MUST record at least:

- receipt and adapter contract versions;
- run, task, wave, assignment, and role identifiers;
- requested and effective model;
- requested and effective variant and quality/reasoning level;
- binding precedence source and resolution evidence;
- canonical `session.send` payload hash and prompt hash;
- OpenChamber session ID;
- OpenChamber project ID or stable project identity;
- canonical directory;
- worktree name/path and branch, or explicit `not-applicable` reason;
- workflow backend and immutable issue binding;
- assignment packet reference and SHA-256 hash;
- created, dispatched, observed, terminal, fan-in, and cleanup timestamps;
- runtime status and state history;
- output, message, test, artifact, and evidence references;
- return/terminal classification;
- cleanup or retention disposition;
- timeout policy and observed timeout state;
- degradation authorization, including authorizer, scope, reason, proof, and
  compensating control, or explicit `none`;
- root write-lock mode and exact dispatched write scopes.

Sensitive transcripts, credentials, tokens, and private provider payloads MUST
NOT be committed. Durable receipts SHOULD contain non-secret hashes and bounded
locators.

## Fan-in and return classification

The root owns fan-in. For each session, the adapter SHOULD:

1. preserve the dispatch acceptance response;
2. track status until a terminal state or timeout;
3. call `session.messages(wait=true,lastAssistant=true)` only with a bounded
   wait and a declared timeout policy;
4. bind the returned output to the session ID and assignment packet hash;
5. verify required evidence references and actual model/quality readback;
6. classify the return as `accepted-for-integration`, `needs-review`,
   `needs-correction`, `conflicts-with-other-return`,
   `rejected-out-of-scope`, or `blocked`, following
   `adapters/runtime/physical-agent/README.md`;
7. preserve residual risk and cleanup disposition.

An assistant's final text is evidence input, not acceptance. The root MUST
inspect the actual worktree/branch, run the required proof, reconcile sibling
returns, and freeze the integrated candidate before independent review.

## Plane and workflow separation

OpenChamber is the runtime authority for project/session/worktree operations.
Plane, when selected and qualified, is the workflow/issue authority. Neither
substitutes for the other.

Children receive immutable issue context but MUST never mutate Plane. The root
alone performs governed Plane reads, comments, state transitions, and closure,
with explicit idempotency, provider readback, and visible partial-result handling.
Plane failures MUST be classified as workflow failures, not OpenChamber session
failures, even when they block overall closure.

The current repository does not have a complete remote workflow adapter stack.
The local `.accelerate/workflow/` adapter is the first concrete substitute and
governs local identity and lifecycle when no complete remote adapter is selected
(`adapters/workflow/README.md`, `adapters/workflow/local/README.md`, and
`adapters/workflow/local/capabilities.yaml`). The issue stack requires an active
implemented workflow adapter or native planning artifacts and runtime packets
(`core/issue-topology/issue-driven-mutation-stack.md`).

`workflow_backend_detected: plane` is permitted as detection metadata by
`onboarding/local-workspace/validate-dogfood-v2-subset.sh`; it is not proof that
a complete Plane adapter exists, is selected, can write, or can recover. The
anti-fake-adapter and fail-closed rules in
`adapters/workflow/adapter-contract.md` still apply.

## Failure taxonomy and recovery policy

Every failure MUST preserve the last confirmed runtime and workflow states.
Failures MUST NOT be collapsed into generic child failure when a more precise
classification is available.

| Failure | Required disposition |
| --- | --- |
| `unavailable primitive` | Block before dispatch; record missing or uncallable primitive and preflight evidence. |
| `preflight mismatch` | Block; record project, directory, catalog, capability, or version mismatch. |
| `dispatch rejection` | Record the rejected assignment and provider response; do not create a synthetic session ID. |
| `partial dispatch` | Freeze further task-owned mutation; record accepted and rejected assignments separately; contain accepted sessions. |
| `stuck/nonterminal session` | Mark blocked after bounded timeout; retain status history and attempt no unapproved replay. |
| `child failure` | Preserve terminal state, output, evidence, and residual work; root decides correction or rejection. |
| `output/readback failure` | Block fan-in even if status says complete; completion without readable output is insufficient. |
| `model mismatch` | Block acceptance; record requested/effective model and variant, including creation-preset fallback, and do not silently substitute quality. |
| `worktree collision/dirty integration` | Block dispatch or integration; preserve conflicting identity and dirty-state evidence. |
| `reviewer independence violation` | Reject the review; create a fresh reviewer session only after explicit root action. |
| `fan-in timeout` | Block the affected wave; preserve elapsed time, outstanding sessions, and partial evidence. |
| `Plane mutation/readback failure` | Preserve prior workflow state and attempted operation; block closure until root reconciles traceably. |
| `cleanup unavailable` | Mark cleanup blocked or retained-with-reason; block full write-bearing support and closure where containment is insufficient. |

There MUST be no automatic retry, replay, compensation, session fork, branch
replacement, Plane write, or cleanup mutation without explicit authorization
and proof of the prior attempt's terminal or contained state. Idempotency keys
MUST bind authorized external mutations. A retry MUST create a new attempt
receipt linked to the original; it MUST NOT overwrite history.

The detailed failure taxonomy is not an expansion of the Standing Multi-Agent
V2 degradation exception enum. Operational failures MUST be recorded in
runtime-neutral `failure_code`, terminal classification, state history, and
evidence fields. Only `explicit_user_opt_out`, `collaboration_unavailable`, and
`spawn_failed_operator_authorized` MAY authorize a degraded dispatch path. For
example, an unavailable primitive MAY support a
`collaboration_unavailable` exception when its preflight evidence proves that
condition; a dispatch rejection remains blocked unless an operator explicitly
authorizes `spawn_failed_operator_authorized`. Timeouts, child failures, model
mismatches, dirty worktrees, review violations, readback failures, Plane
failures, and cleanup failures do not authorize degradation by themselves.

The absence of cancellation/session deletion is especially significant. Until
OpenChamber proves an equivalent containment/retention contract, the adapter
MUST NOT be promoted to fully supported write-bearing orchestration. Merely
letting a session become idle or leaving a worktree behind does not satisfy the
cleanup rules in `core/control-plane/orchestrator-first-execution-gate.md` or
`adapters/runtime/physical-agent/README.md`.

## Alternatives considered

### 1. Direct OpenChamber native adapter: recommended

This option gives OpenChamber a truthful primitive map, session/worktree
identity, model readback, lifecycle, and cleanup contract while preserving the
runtime-neutral core. It minimizes semantic loss and makes runtime-specific
failures diagnosable. Its cost is a dedicated adapter and qualification suite.

### 2. Generic physical-agent-first binding

OpenChamber could initially be hidden behind
`adapters/runtime/physical-agent/`. This reuses lifecycle vocabulary but is not
sufficient as the final binding: the generic adapter is `planned`, has no
implemented command, and does not model OpenChamber session IDs, projects,
worktrees, immediate dispatch, message fan-in, model readback, or absent
cancellation/deletion. It MAY inform the common contract, but SHOULD NOT replace
the dedicated adapter.

### 3. Wrap OpenChamber behind Codex collaboration

This option is rejected. `adapters/runtime/codex-collaboration/` explicitly
binds `collaboration.spawn_agent`, Codex model families, Codex fork semantics,
and Codex agent/call identifiers. Pretending OpenChamber uses those primitives
would produce false receipts and obscure runtime ownership. OpenChamber MAY host
sessions that run Codex-compatible models, but model compatibility does not make
the runtime primitive Codex collaboration.

### Fallback decision

No option permits silent fallback. A non-callable or failed OpenChamber adapter
MUST stop as `BLOCKED`. It MAY emit an allowed, evidenced exception only when a
specifically authorized degraded path is requested and the corresponding core
exception preconditions are satisfied. Degradation to virtual packets, another
runtime, or root-owned task execution requires explicit operator authorization
under the repository's exception contract and does not retroactively qualify
OpenChamber.

## Manifest and contract migration

The implementation MUST update synchronized declarations and tests in one
bounded migration. Likely changes are:

### Files to add

- `adapters/runtime/openchamber/README.md`
- `adapters/runtime/openchamber/capabilities.yaml`
- `adapters/runtime/openchamber/role-policy.json`
- `adapters/runtime/openchamber/delegation-contract.md`
- `adapters/runtime/openchamber/openchamber-dispatch-receipt.schema.json`
- `scripts/validate-openchamber-runtime-adapter.py`
- `tests/test_openchamber_runtime_adapter.py`
- `tests/fixtures/openchamber-runtime/`
- `core/runtime-packets/runtime-delegation-dispatch-receipt.schema.json` or an
  equivalently named versioned runtime-neutral successor

### Files to change

- `adapters/runtime/cross-runtime-bootstrap-manifest.json`: add
  `openchamber` as `staged-only`, `apply_eligible=false`, with a
  runtime-truth-required loader and repository projection.
- `adapters/runtime/runtime-consumer-registry.json`: add a
  `legacy-reference`, `reference-only`, `loader=none` entry until callability is
  independently proven.
- `adapters/runtime/README.md`: register the adapter and reading order.
- `core/control-plane/cross-runtime-bootstrap.md`: document OpenChamber's staged
  posture without weakening the supported-and-callable gate.
- `core/control-plane/runtime-adapter-maturity-dashboard.md`: add proof,
  blocker, promotion, demotion, and cleanup cells.
- `scripts/validate-runtime-delegation-semantics.py`: add `openchamber` to the
  closed `RUNTIMES` set and preserve the consumer-registry status rules.
- `tests/test_runtime_delegation_semantics.py`: synchronize the runtime
  denominator, runtime-neutral forbidden-name check, and registry assertions.
- `tests/runtime-delegation-semantics.sh` and
  `tests/fixtures/runtime-delegation-semantics/`: add any synchronized registry
  and negative fixtures needed for OpenChamber status and projection drift.
- `scripts/sync-runtime-bootstrap.py`: update the closed `EXPECTED` manifest and
  registry cross-validation while keeping OpenChamber apply blocked.
- `tests/cross-runtime-bootstrap.sh`: add OpenChamber to the explicitly rejected
  non-apply runtime loop and add staged-only invariants.
- `scripts/validate-harness-catalog.py`: update canonical registry digests if
  the hash-pinned inputs remain part of the harness validator.
- `tests/test_harness_catalog.py`: synchronize registry fixtures and identity
  checks; add a catalog/reference entry only if OpenChamber is intentionally
  admitted to that separate harness catalog.
- `tests/test_other_runtime_adapters.py`: synchronize non-Codex adapter policy
  and status expectations if OpenChamber is added to the auxiliary adapter
  policy denominator.
- `core/runtime-packets/README.md`: register the new runtime-neutral dispatch
  packet with its trigger, required fields, owner/gate, and test coverage as
  required by the packet index maintenance rule.
- `core/control-plane/post-spec-delegation-dispatch-gate.md` and receipt tests:
  route the gate through the runtime-neutral successor while retaining current
  write-lock, budget, reviewer, and exception invariants.
- `tests/delegation-dispatch-receipt.sh` and
  `tests/fixtures/delegation-dispatch/`: add runtime-neutral and OpenChamber
  positive/negative receipt projections.

The implementation SHOULD avoid changing the runtime-neutral delegation schema
unless a genuinely portable field is missing. Runtime names, session IDs, and
OpenChamber primitives MUST remain adapter-side.

## Phased implementation

### Phase 0: static contract and non-operational registration

Add the adapter documents, capability manifest, role policy, static receipt
schema, validators, and fixtures. Register bootstrap `staged-only` and consumer
`legacy-reference`. Keep `apply_eligible=false`, `loader=none` in the consumer
registry, and no dispatch authorization.

Exit requires schema, registry, doctrine, and fake-adapter tests passing. It
does not establish runtime support.

### Phase 1: live read-only preflight

Implement only project/model/capability discovery and non-secret receipt
readback. Prove exact project selection, directory binding, model catalog
resolution, unknown-capacity handling, status vocabulary, and zero external
mutation.

Exit permits controlled read-only qualification, not write-bearing dispatch.

### Phase 2: controlled read-only session

Create one fresh read-only session, then dispatch its immutable packet through
the canonical `session.send` payload with explicit `model` and `variant`.
Observe immediate dispatch acceptance, confirm requested/effective binding by
telemetry, track status, collect terminal output with bounded
`session.messages(wait=true,lastAssistant=true)`, and record cleanup/retention
disposition.

Exit requires repeatable status and output readback plus a truthful containment
record. The bootstrap status remains `staged-only`.

### Phase 3: isolated mutating worktree

Entry requires a previously qualified cancellation mechanism or equivalent
containment and retention contract for the requested risk class. Without that
entry evidence, Phase 3 remains blocked and no write-bearing session may be
created.

With the entry guard satisfied, create one bounded executor session in a
deterministic worktree/branch, verify scope, inspect the actual diff, integrate
through the root, and prove dirty and collision failure paths. No Plane mutation
is allowed from the child. Exit revalidates the containment and retention
contract under write-bearing conditions; Phase 3 does not manufacture that
prerequisite by running an otherwise prohibited experiment.

### Phase 4: parallel fan-out/fan-in and independent review

Run two bounded executors with disjoint scopes and one fresh reviewer session,
never exceeding three physical assignments. Prove partial dispatch, timeout,
model mismatch, fan-in, candidate freeze, reviewer independence, correction,
fresh reproof, and root review-of-review.

Exit requires deterministic receipts for every assignment and no unmanaged
session or worktree.

### Phase 5: root-only workflow integration and end-to-end closure

Bind immutable issue context, prove that children cannot or do not mutate Plane,
and perform all workflow reads/comments/transitions through the root with
idempotency and readback. Exercise local `.accelerate/workflow/` as the governing
substitute when no qualified remote Plane adapter exists.

Exit requires an end-to-end `TASKS_READY` through root closure proof with
workflow and runtime failures classified separately.

### Phase 6: promotion

Only after the qualification matrix passes with durable, non-sensitive runtime
evidence may maintainers consider changing the bootstrap status to `supported`
and `apply_eligible=true` or the consumer registry to `supported`. Promotion
MUST include verified install/apply behavior, readback, rollback, demotion, and
cleanup evidence. Promotion is a separate decision, not an automatic result of
implementation.

## Qualification matrix

| Qualification lane | Required proof | Promotion effect |
| --- | --- | --- |
| Schemas and registries | Adapter manifest validates; bootstrap and consumer vocabularies remain distinct; closed denominators and paths are synchronized; runtime-neutral schema contains no `openchamber` identifier. | Required for Phase 0 only. |
| Doctrine integrity | Standing Multi-Agent V2, root ownership, issue stack, proof order, and fail-closed rules remain intact across `SKILL.md`, `README.md`, control-plane gates, and dashboards. | Blocks any promotion on drift. |
| Fake adapter contract tests | Deterministic fake proves operator/policy/catalog precedence, invalid-override blocking, create-preset fallback rejection, mandatory send-time model/variant injection, dispatch acceptance, status transitions, output readback, mismatch handling, worktree identity, failure taxonomy, and receipts without external calls. | Necessary but not runtime proof. |
| Live read-only preflight | Fresh `models.list`, `projects.list`, exact `accelerate` project binding, primitive availability, effective model/readback capability, and zero-write audit. | Allows controlled qualification only. |
| Controlled read-only session | Fresh `session.create`; canonical `session.send` with explicit `sessionId`, `prompt`, `model`, and `variant`; matching post-send telemetry; terminal `session.status`; bounded `session.messages(wait=true,lastAssistant=true)`; output binding; and retention/cleanup disposition. | May prove bounded read-only availability. |
| Isolated mutating worktree | Deterministic worktree/branch, bounded change, scope audit, root integration, collision/dirty rejection, containment, and cleanup/readback. | Required for write-bearing consideration. |
| Parallel executor fan-out/fan-in | Two disjoint executors, cap no greater than three, immediate-dispatch receipts, active tracking, terminal output, partial dispatch handling, and root fan-in. | Required for orchestrated support. |
| Independent review | Fresh `session.create`, distinct session ID, no fork/inherited context, frozen candidate/spec hashes, skeptical evidence, correction, and fresh reproof. | Required for closure claims. |
| Model and variant enforcement | Schema optionality is distinguished from governance requirements; operator override, Accelerate policy, and catalog default precedence is proved; creation-time binding is non-authoritative; every work-bearing `session.send` carries explicit `model` and `variant`; requested/effective binding is captured for every role; missing telemetry or mismatch fails closed; high-stakes review has a reasoning receipt. | Required before model-routed support. |
| Timeout and partial dispatch | Bounded fan-in timeout, stuck/nonterminal classification, accepted/rejected assignment separation, no automatic retry, and contained surviving sessions. | Required before orchestration. |
| Root-only Plane integration | Immutable child issue context; no child Plane writes; root idempotency/readback for reads/comments/transitions; local workflow fallback remains explicit and truthful. | Required for issue-driven closure. |
| Cleanup and retention | Cancellation/deletion or qualified equivalent containment; worktree disposition; no unmanaged session/process; retained-with-reason evidence and demotion path. | Material blocker to full write-bearing support. |
| End-to-end `TASKS_READY` closure | Preflight, packet compilation, physical dispatch before writes, root lock, tracking, fan-in, integration, fresh independent review, review-of-review, workflow reconciliation, cleanup, and root closure. | Required for `supported`; still needs explicit promotion. |

Live tests MUST use bounded, non-sensitive fixtures and MUST NOT rely on private
transcript contents as repository proof. Failed qualification MUST demote or
retain the conservative status; it MUST NOT be explained away as equivalent.

## Promotion criteria

OpenChamber MUST NOT be promoted to `supported` before all of the following are
true:

1. Repository schemas, registries, validators, fixtures, and doctrine tests pass.
2. Fresh runtime preflight proves exact project, directory, primitive, model,
   variant, and capacity truth.
3. Read-only and write-bearing sessions have durable status and output readback.
4. Deterministic worktree isolation, collision rejection, dirty-state handling,
   integration, and cleanup are proven.
5. Parallel fan-out/fan-in respects the cap and handles partial dispatch and
   timeouts without silent fallback or automatic replay.
6. Every reviewer is a fresh independent session created with `session.create`;
   `session.fork` is not used as independent review evidence.
7. The Master proves operator/policy/catalog precedence before every
   work-bearing `session.send`, explicitly binds model and variant, records the
   resolution source, obtains reliable requested/effective model, variant, and
   quality readback, and fails closed on missing telemetry or mismatch.
8. Cancellation/session deletion or an equivalent containment/retention
   contract is qualified for write-bearing work.
9. Plane/workflow operations remain root-only, idempotent, read back, and
   separately classified from runtime operations.
10. An end-to-end `TASKS_READY` through closure run proves the root write lock,
    fan-in, integration-only repair, independent review, review-of-review,
    promotion evidence, cleanup, and root-only `Done`.
11. Install/apply, readback, rollback, demotion, and privacy behavior have
    durable proof locators.
12. A separate maintainer promotion decision updates all status surfaces
    consistently.

Until then, OpenChamber remains a proposed or staged runtime mapping. The
successful `models.list` and `projects.list` observations and the empirical
send-time model/variant override are useful bounded evidence, but they are not
full child-lifecycle, worktree, fan-in, cleanup, or write-bearing orchestration
proof.
