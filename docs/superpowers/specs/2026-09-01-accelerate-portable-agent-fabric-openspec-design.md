# Accelerate Portable Agent Fabric + OpenSpec Composition

## Document status

- proposal version: `0.3`
- date: 2026-09-01
- Plane authority: `CODEX-17`
- status: proposal persisted; approved recommendations incorporated; implementation not authorized
- decision gate: awaiting the operator's next analysis
- governing repository: standalone `accelerate`

## Executive summary

This proposal evolves `accelerate` into a portable, runtime-agnostic control
plane for governed engineering work. It preserves Codex as the strongest and
first implementation target while defining contracts that can be adapted to
other LLM, AI, and harness runtimes without pretending that their execution,
isolation, model, or tool semantics are equivalent.

The proposed system combines five distinct layers:

1. **Accelerate** is the control plane and final authority for classification,
   hardening, task topology, delegation, gates, evidence, and closure.
2. **Plane** is the sole work-item and lifecycle authority.
3. **OpenSpec Core** is an optional specification-artifact engine.
4. **Accelerate Portable Agent Fabric (APAF)** materializes governed agent
   profiles, assignments, runtime instances, and return packets.
5. **OpenSpec WebUI** is an observer and navigation surface, exposed on the
   authorized private LAN with `--host 0.0.0.0` and explicit compensating
   controls.

OpenSpec Plus is not adopted as a runtime dependency. Its best process ideas
are absorbed as Accelerate doctrine, normalized to the local authority model,
and enforced through concise skills, schemas, adapters, validators, and proof
packets.

The central architectural rule is:

> A skill is a reusable capability contract. An agent profile is a persistent
> identity and authority contract. An assignment is bounded work. A runtime
> instance is the live worker. Evidence is what permits a gate to advance.

None of these objects substitutes for another.

## Problem statement

The existing `accelerate` corpus already contains mature orchestration,
classification, proof, risk, review, and closure doctrine. Its current shape,
however, still mixes several concerns:

- root control-plane policy;
- long operational procedures;
- stack-specific knowledge;
- agent-role descriptions;
- runtime-specific dispatch details;
- project overlays;
- specification and task artifacts.

The earlier discussion with Agy exposed a useful opportunity and a dangerous
ambiguity. A persistent subagent is not simply a skill. Treating it that way
collapses identity, permissions, runtime isolation, assignment scope, and
evidence into a Markdown package that has no intrinsic execution authority.

The target architecture must therefore make persistence and runtime execution
explicit, machine-readable, testable, and adapter-owned.

## Goals

This proposal must:

- keep Codex/root as the primary technical control plane;
- remain semantically portable across capable LLM and harness runtimes;
- preserve strong rules in both the root and specialist agent bodies;
- distinguish skills, profiles, assignments, instances, and evidence;
- support sequential and parallel multi-agent execution without hidden
  authority changes;
- require independent review and bounded correction loops;
- make specification state machine-readable and resumable;
- reconcile OpenSpec artifacts with Plane without creating dual authority;
- expose a useful LAN WebUI without pretending that upstream provides an
  authentication boundary;
- preserve source, installed package, active runtime, configuration, and
  authorized promotion as different evidence classes.

## Non-goals

This proposal does not authorize:

- installing or promoting OpenSpec, OpenSpec Plus, or OpenSpec WebUI;
- starting a WebUI process or opening a firewall;
- changing the global `~/.codex/skills/` mirror;
- implementing new agents, adapters, schemas, or services;
- replacing Plane as tracker authority;
- making OpenSpec validation equivalent to delivery acceptance;
- importing donor prompts, hooks, wildcard grants, wrappers, or runtime
  authority verbatim;
- assuming that another harness provides Codex-equivalent isolation,
  background execution, model selection, worktrees, or messaging.

## Architectural principles

### One authority per concern

| Concern | Authority |
| --- | --- |
| Run classification and route | Accelerate root |
| Objective, scope, risk, and non-goals | Hardened execution packet |
| Work item and lifecycle state | Plane |
| Specification artifacts and deltas | OpenSpec adapter |
| Agent identity and permissions | APAF agent registry |
| Runtime dispatch semantics | Selected runtime adapter |
| Acceptance and closure | Accelerate proof stack + root |
| LAN access boundary | Operator-owned deployment policy |

No adapter is allowed to claim authority outside its row.

### Explicit state beats prose inference

Every material transition has a packet, schema, validator, and readback. A
sentence saying "done" never constitutes proof of completion.

### Strong defaults, bounded escape hatches

The default route is opinionated. Degraded execution is allowed only through a
named, visible exception with an owner and consequence. Silent fallback is a
workflow defect.

### Portability without false parity

The semantic contracts are portable. Physical capabilities are adapter facts.
An adapter may be `supported`, `staged-only`, `export-only`, `blocked`, or
`unavailable`. It must never simulate a successful physical dispatch.

## Correct ontology

### Skill

A skill is a progressively disclosed capability package:

- concise `SKILL.md` activation and routing contract;
- one-hop `references/` for long procedures and policy;
- `scripts/` for deterministic executable helpers;
- `assets/` for templates, schemas, fixtures, and static resources.

A skill can be loaded by root or by an agent. It does not become a process and
does not intrinsically grant permissions.

### Agent profile

An agent profile is a persistent, runtime-neutral role declaration. It owns:

- identity and purpose;
- allowed and forbidden scopes;
- required and optional skills;
- tool capability classes;
- write and mutation authority;
- escalation conditions;
- expected input and output packet schemas;
- default quality/model class rather than a hard-coded vendor model;
- independence requirements;
- nesting and delegation permissions.

### Assignment

An assignment is an immutable per-task envelope containing:

- Plane work-item reference;
- objective and non-goals;
- exact files, domains, or surfaces owned;
- frozen denominator where applicable;
- input artifacts and accepted source set;
- allowed mutations and forbidden operations;
- expected proof;
- timeout, retry, and correction budget;
- return packet schema;
- integration owner.

### Runtime instance

A runtime instance is a live execution created by an adapter. It receives the
resolved profile, assignment, model/quality mapping, workspace policy, and
tool policy. Its transcript, status, messaging, and isolation are runtime
facts, not portable assumptions.

### Evidence packet

Evidence is a typed receipt tied to an assignment, candidate, commit, artifact
digest, environment, and time. Evidence may prove implementation, static
validation, runtime behavior, review, browser truth, persistent regression, or
forensic closure. Evidence never inherits across a changed candidate unless
explicitly reconciled.

## Target layered architecture

```text
operator
  |
  v
Accelerate root control plane
  |-- hardened execution packet
  |-- Plane workflow adapter
  |-- specification lifecycle router
  |     `-- OpenSpec Core adapter
  |-- APAF agent factory
  |     |-- portable profile registry
  |     |-- assignment compiler
  |     `-- runtime adapters
  |-- proof and review lanes
  `-- forensic closure

OpenSpec WebUI -- read/observe --> OpenSpec workspace artifacts
Plane          -- authority --> work items and lifecycle
```

The proposed repository growth is:

```text
accelerate/
├── core/
│   ├── specification-lifecycle/
│   ├── agent-fabric/
│   ├── task-graph/
│   ├── review-loops/
│   └── evidence/
├── adapters/
│   ├── specification/
│   │   └── openspec/
│   ├── workflow/
│   │   └── plane/
│   └── runtime/
│       ├── codex/
│       └── <future-runtime>/
├── agents/
│   ├── registry/
│   ├── constitutions/
│   ├── assignments/
│   └── return-packets/
├── schemas/
│   ├── accelerate-governed/
│   └── agent-fabric/
└── skills/
    └── openspec-sdd-adapter/
```

This is a target structure, not authorization to create every directory in a
single migration.

## OpenSpec Core: what to adopt

OpenSpec Core contributes a useful artifact engine because it separates a
change into inspectable, filesystem-backed objects and provides machine-readable
CLI contracts.

### Adopt: change-scoped artifact graph

Use a change directory as the bounded specification workspace. The minimum
Accelerate schema should materialize:

1. `proposal` — objective, context, scope, non-goals, affected capabilities;
2. `specs` — behavioral requirements and scenarios;
3. `design` — architecture, decisions, alternatives, risks, and migrations;
4. `test-design` — proof obligations and lowest-effect validation plan;
5. `tasks` — vertical slices, dependencies, owners, gates, and evidence;
6. `delegation-plan` — agent profile, runtime class, isolation, and return
   contract for every dispatchable slice.

The custom schema is named `accelerate-governed`. It extends OpenSpec instead
of reshaping Accelerate around the default schema.

### Adopt: dependency-aware artifact readiness

Artifact readiness is computed from declared dependencies. A downstream
artifact becomes editable only when its prerequisite artifacts are present and
structurally valid. This supports pause/resume and prevents task execution from
starting on an incomplete design.

OpenSpec's file-existence status is insufficient by itself, so Accelerate adds
semantic states:

```text
missing
  -> materialized
  -> structurally-valid
  -> independently-reviewed
  -> planning-approved
  -> plane-projected
  -> execution-ready
```

`planning-approved` means that the artifact set is approved as an input to
planning and dispatch readiness. It is not product, delivery, or closure
acceptance. Only `execution-ready` may contribute tasks to `TASKS_READY`.

### Adopt: custom schemas and templates

The schema and its templates should be repo-owned. Templates must produce
bounded, reviewable artifacts and avoid giant embedded prompts. Long guidance
belongs in directly linked references and validators.

### Adopt: JSON command contracts

Prefer machine-readable commands for status, instructions, validation, and
archive operations. The adapter captures:

- command and immutable tool version;
- workspace and change identifier;
- exit status;
- parsed JSON;
- artifact digests;
- adapter verdict;
- timestamp and environment class.

Human terminal text is supplementary evidence, never the integration API.

### Adopt: delta specifications

Change-scoped spec deltas are valuable for explicit additions, modifications,
and removals. Accelerate should preserve the delta and the resulting canonical
spec so reviewers can compare intent, change, and final state.

### Adopt: archive as a lifecycle operation

Archive moves a completed change into durable history. It must occur only
after:

- artifacts are structurally valid;
- implementation and proof are frozen;
- independent review passes;
- root review-of-review passes;
- Plane reconciliation succeeds;
- operator acceptance is present when required.

Archive is not closure by itself and must not auto-close Plane.

### Adapt: validation

OpenSpec validation is structural specification evidence. It can prove that
required sections, syntax, and references are coherent. It cannot prove:

- code correctness;
- tests passing;
- runtime behavior;
- visual truth;
- security posture;
- acceptance;
- absence of regression.

The adapter must label this evidence `structural-spec-validation`, never
`delivery-proof`.

### Adapt: verify-change

Heuristic change verification can be used as an advisory reviewer. Any result
based on keyword matching or inference remains a non-authoritative signal. It
may open findings; it may not close a gate without corroborating evidence.

## OpenSpec Plus: what to absorb

OpenSpec Plus contributes valuable execution doctrine, especially in its
Apply workflow. These ideas should become native Accelerate process contracts,
not a direct installation of the upstream skill bundle.

### Five-lens discovery

Before planning, inspect the task through five lenses:

1. product intent and user value;
2. domain and behavioral contract;
3. architecture and integration boundaries;
4. testability and proof strategy;
5. delivery, operation, and rollback risk.

The output feeds the hardened execution packet and the OpenSpec proposal,
rather than becoming an unstructured research transcript.

### What before how

Specifications own observable behavior and acceptance. Design owns mechanism,
structure, trade-offs, and migration. Tasks own execution order and proof. A
single artifact should not silently mix these authorities.

### Testable scenarios

Every material requirement must have one or more scenarios with:

- precondition or initial state;
- action or event;
- expected observable result;
- proof class;
- owner;
- risk level.

Gherkin is allowed but not mandatory. The contract is testability, not a
specific prose syntax.

### Alternatives before a material design decision

For ADR-worthy choices, design presents two or three credible alternatives,
their trade-offs, and the selection rationale. Rejected alternatives remain in
the decision record so a later agent does not reopen the same question without
new evidence.

### Incremental approval gates

Large changes should allow explicit approval after proposal, design, test
design, and task graph. Approval is recorded as a digest-bound receipt. Editing
an approved upstream artifact invalidates dependent approvals.

### Vertical slices

Tasks should deliver thin, end-to-end behavior with local proof whenever
possible. Layer-only task decomposition is permitted only when a real
dependency or migration boundary requires it.

## Governed Apply protocol

The strongest contribution from OpenSpec Plus is its Apply logic. Accelerate
should adopt the intent with stricter authority and evidence boundaries.

### Apply preconditions

Apply is blocked unless all are true:

- canonical Plane issue exists and is execution-ready;
- a planning-approved OpenSpec artifact set is identified;
- proposal, specs, design, test-design, tasks, and delegation-plan satisfy the
  selected proportional depth;
- unresolved decisions are empty or explicitly deferred outside scope;
- task denominator and dependency graph are frozen;
- runtime adapter capability is fresh and callable;
- worktree or workspace isolation policy is resolved;
- rollback and stop conditions are explicit;
- `TASKS_READY` is reached.

### Apply state machine

```text
APPLY_REQUESTED
  -> PREFLIGHTED
  -> DENOMINATOR_FROZEN
  -> DAG_VALIDATED
  -> TASKS_READY
  -> DISPATCHED
  -> SLICE_IMPLEMENTED
  -> SPEC_REVIEWED
  -> QUALITY_REVIEWED
  -> SLICE_PROVEN
  -> INTEGRATED
  -> WHOLE_CHANGE_REVIEWED
  -> CLOSURE_READY
```

Any failing gate moves the affected slice to `CORRECTION_REQUIRED`. A changed
candidate invalidates downstream evidence and returns to the lowest affected
gate.

### Preflight

The root verifies:

- current repository and dirty-worktree truth;
- governing instructions and accepted sources;
- Plane issue and lifecycle state;
- OpenSpec change status and artifact digests;
- selected runtime adapter status;
- model/quality mapping availability;
- exact target surfaces;
- secrets and destructive-action boundaries;
- proof commands and external dependencies.

### Execution-mode selection

Apply chooses one visible mode:

- `direct-fast-path` for truly bounded, low-risk work;
- `scoped` for one contained lane with at most one auxiliary agent;
- `orchestrated` for non-trivial work with a physical task graph and independent
  review.

When `orchestrated`, execution was requested, `TASKS_READY` was reached, and a
callable collaboration primitive exists, physical dispatch is mandatory before
task-owned mutation.

### Dependency DAG and parallelism

Tasks become DAG nodes with explicit inputs, outputs, owned surfaces, proof,
and integration order. Parallel execution is permitted only when nodes:

- have no dependency edge between them;
- do not share mutable files or runtime state;
- do not depend on an unfrozen shared contract;
- have an explicit fan-in owner;
- can be independently validated.

The root records why parallelism is safe. Mere task count is not enough.

### Per-slice execution

For every ready slice, root compiles an immutable assignment and dispatches the
smallest capable agent profile. The implementer may mutate only its assigned
surface. It returns code/artifacts plus a Subagent Return Packet; it does not
declare the overall task complete.

### Per-slice review order

Each implementation passes two distinct reviews:

1. **Specification compliance review** asks whether the candidate satisfies
   the accepted requirement and did not expand scope.
2. **Quality and risk review** asks whether the solution is correct, secure,
   maintainable, minimal, and aligned with the stack.

Both review functions must be independent of the implementer for every slice.
For an explicitly low-risk slice, one independent reviewer instance may perform
the two logically distinct reviews and must return separate verdicts. Use two
distinct reviewer instances for authentication, authorization, billing,
permissions, migrations, destructive data behavior, secrets, externally
irreversible effects, or another risk class selected by the root. After a
correction, each affected review function runs again independently against the
new candidate.

### Per-slice proof

The slice runs the lowest-effect proof that can falsify its claim, followed by
the applicable stack gates. Evidence is bound to the exact candidate digest.

### Fan-in and integration

Root owns integration. It verifies overlapping assumptions, applies only
integration repairs, reruns invalidated proof, and records the integrated
candidate. Root must not quietly finish work that belonged to a child
assignment.

### Whole-change review

After fan-in, a reviewer examines the complete change against proposal, specs,
design, task denominator, non-goals, and proof plan. This catches individually
correct slices that fail as a system.

### Bounded correction loop

Each failing slice has at most three autonomous correction cycles:

```text
review finding
  -> root classifies and routes
  -> implementer corrects
  -> proof reruns
  -> independent reviewer re-reviews
```

The loop stops early when:

- the same blocker repeats without new evidence;
- correction requires a scope or architecture decision;
- a destructive or externally irreversible operation is required;
- the agent reaches its authority boundary;
- evidence becomes ambiguous;
- the third correction fails.

Stopping produces a blocking receipt and returns control to root/operator. It
never converts failure into acceptance.

### Pause and resume

Apply must be resumable from committed state, not conversation memory. The
resume packet contains:

- Plane issue and state readback;
- OpenSpec change and artifact digests;
- frozen denominator and DAG version;
- completed, active, blocked, and pending nodes;
- candidate commit/digest per node;
- accepted and invalidated evidence;
- correction count;
- next legal transition.

On resume, every external or runtime fact is refreshed before dispatch.

### Failure discipline

Apply never ignores a failing test, reviewer finding, incomplete task, missing
agent return, ambiguous mutation, stale evidence, or adapter capability gap.
It classifies the failure, records impact, and either corrects, defers outside
scope with authority, or blocks.

## Agent model

### Base constitution

Every agent receives a small common constitution:

- obey root and assignment authority;
- preserve user work and secrets;
- do not expand scope;
- do not claim unverified completion;
- stop at destructive or authorization boundaries;
- report exact evidence and residuals;
- do not delegate unless the profile and assignment permit it;
- do not mutate Plane unless explicitly assigned through an authorized
  adapter;
- return control rather than inventing missing capabilities.

### Role contract

The initial portable catalog is:

| Role | Primary authority | Default mutation posture |
| --- | --- | --- |
| `orchestrator` | route, task graph, fan-in, closure | integration only |
| `research-explorer` | source and repository discovery | read-only |
| `implementation-worker` | bounded implementation | assigned surfaces only |
| `test-engineer` | test design and test implementation | tests/fixtures only unless assigned |
| `mechanical-fixer` | prescribed deterministic correction | exact files only |
| `independent-reviewer` | spec and quality findings | read-only |
| `qa-runtime-reviewer` | runtime/browser/proof assessment | read-only by default |
| `high-stakes-reviewer` | security, data, auth, billing review | read-only |

Runtime-specific names such as `python-backend`, `nextjs-frontend`, `data-db`,
and `integrations-ops` are specialization overlays over these portable roles.

### Profile composition

A resolved profile is built in this order:

```text
base constitution
  + role contract
  + specialization overlay
  + runtime policy
  + project profile
  + immutable assignment
```

Later layers may narrow authority but may not silently widen an earlier
boundary.

### Model and reasoning classes

Portable profiles request quality classes, for example:

- `fast-readonly-research`;
- `mechanical-prescribed`;
- `standard-implementation`;
- `independent-review`;
- `high-stakes-readonly`.

Each runtime adapter maps these classes to models and reasoning effort it
actually supports and returns the effective mapping. Unsupported mappings
block or require explicit operator-authorized degradation.

### Subagent Return Packet

Every child returns:

- assignment and Plane references;
- resolved profile and effective runtime/model receipt;
- owned surfaces;
- requested versus delivered;
- files/artifacts changed;
- commands and proof results;
- findings and decisions;
- assumptions;
- blockers and residuals;
- candidate commit/digest;
- recommended next gate;
- explicit statement of what it did not verify.

Root validates the packet against repository truth before accepting it.

## Plane and OpenSpec reconciliation

Plane and OpenSpec serve different purposes and must not compete.

### Authority rules

- Plane issue creation/readback precedes OpenSpec artifact mutation for
  mutating work.
- Every OpenSpec change stores the immutable Plane project, issue ID, and URL
  reference in adapter metadata.
- Every dispatchable task references its Plane issue or child issue.
- OpenSpec task checkboxes are projections of execution state, not tracker
  authority or proof.
- Agents never mark projected tasks complete merely because implementation
  returned.
- Root reconciles child evidence, OpenSpec task status, and Plane state.
- OpenSpec archive cannot auto-close Plane.
- Plane closure requires the normal AI Review Report, proof stack, forensic
  closure, lifecycle packet, and provider readback.

### Reconciliation table

| OpenSpec state | Plane meaning | Allowed action |
| --- | --- | --- |
| artifact materialized | planning evidence exists | continue artifact gates |
| artifact valid | structural validation passed | independent review |
| tasks ready | execution graph accepted | dispatch if runtime capable |
| task checked | projected candidate delivered | validate evidence, do not close |
| change complete | implementation denominator materialized | whole-change review |
| change archived | durable spec history | eligible for Plane closure checks |

### Drift handling

If Plane scope changes, root updates the hardened packet first, then produces a
new OpenSpec artifact revision and invalidates dependent approvals. If an
OpenSpec artifact changes without Plane authority, execution fails closed until
reconciled.

## Proof architecture

The required proof order remains:

1. implementation proof;
2. backend/frontend QA proof;
3. browser truth through Chrome DevTools;
4. persistent regression proof through Playwright;
5. forensic closure.

OpenSpec contributes planning and structural evidence before this stack. It
does not replace any lane.

For each proof, store:

- claim;
- proof class;
- exact command or observation method;
- candidate digest;
- environment;
- result;
- timestamp;
- owner;
- invalidation triggers.

## WebUI decision: authorized LAN exposure

The OpenSpec WebUI is intentionally allowed to bind to all host interfaces:

```bash
openspec-webui --host 0.0.0.0 --port <configured-port>
```

This is an accepted deployment requirement, not a finding to be "fixed" back
to loopback. Binding to `0.0.0.0` changes the trust boundary: it does not, by
itself, make the service Internet-authorized.

### Intended role

The WebUI is a read-oriented observer for:

- project navigation;
- change and artifact inspection;
- OpenSpec CLI availability and version visibility;
- validation visibility;
- operator discussion and review.

It is not:

- Plane authority;
- an Accelerate control plane;
- an acceptance engine;
- an agent dispatcher;
- a security boundary;
- proof that an artifact is approved.

### Upstream security reality

The source snapshot inspected for this proposal provides a Fastify/Svelte
interface and supports the requested host binding. The inspection did not find
an application-level authentication, authorization, CSRF, origin-enforcement,
or rate-limit boundary. These are version-bound proposal inputs, not runtime
proof: the frozen candidate must be re-audited with reproducible source paths
and an inspection receipt before deployment.

Its browsing and project-registration surfaces may reveal filesystem paths and
artifact contents available to the process. Therefore, process privileges and
network placement are part of the data boundary.

### Mandatory controls for `0.0.0.0`

Before a general LAN deployment, require:

- bind only on the authorized private-LAN host;
- no public Internet exposure, public NAT, or broad ingress rule;
- host firewall allowlist or a dedicated trusted VLAN;
- reverse-proxy authentication and TLS when the reachable audience is broader
  than a tightly controlled lab LAN;
- application origin/session protection through a governed wrapper or fork if
  browser clients are not fully trusted;
- non-root service account;
- explicit allowlist of OpenSpec project roots;
- least filesystem permissions for the service account;
- configurable, reserved port;
- no secret-bearing repositories in the accessible denominator;
- outbound update/version checks treated as advisory, preferably disabled or
  blocked in controlled deployments;
- structured access and error logs without artifact or secret leakage;
- startup receipt showing immutable package version, command, host, port,
  service user, project allowlist digest, and active configuration digest;
- socket proof that the expected process is listening on the expected port;
- remote LAN canary from an authorized client;
- negative canary from a disallowed network or host where practical;
- documented stop, rollback, and residual-process checks.

If authentication or the project-root allowlist cannot be added before the
first canary, exposure is limited to an isolated lab LAN. General LAN promotion
remains blocked until those controls exist.

### Recommended integration shape

Do not patch upstream directly in place. Add an Accelerate deployment adapter
that can choose one of two modes:

1. `trusted-lab-lan`: upstream WebUI, strict host firewall/VLAN, explicit
   project roots, no Internet ingress;
2. `authenticated-lan`: immutable upstream payload behind a governed reverse
   proxy or a maintained wrapper/fork that adds identity, origin protection,
   path allowlisting, and auditability.

The adapter owns deployment receipts and proof. The WebUI remains an observer.

## Source adoption matrix

| Source behavior | Decision | Accelerate adaptation |
| --- | --- | --- |
| OpenSpec change artifacts | adopt | custom `accelerate-governed` schema |
| Custom schemas/templates | adopt | repo-owned and validator-backed |
| JSON CLI contracts | adopt | adapter consumes structured output |
| Spec deltas | adopt | preserve delta plus canonical result |
| Structural validation | adapt | planning evidence only |
| Heuristic verify-change | adapt | advisory reviewer only |
| Archive | adapt | gated history operation, no auto-close |
| Plus five-lens discovery | adopt | hardened packet inputs |
| Plus What-before-How | adopt | artifact authority separation |
| Plus testable scenarios | adopt | syntax-neutral proof mapping |
| Plus alternatives | adopt | ADR-worthy decisions only |
| Plus vertical slices | adopt | task graph default |
| Plus Apply workflow | adopt/adapt | governed state machine and physical dispatch |
| Plus max-three correction loops | adopt | root-routed and evidence-bound |
| Plus pause/resume | adopt | committed resume packet |
| Plus giant embedded prompts | reject | progressive-disclosure skills |
| Plus moving-main updater | reject | immutable release governance |
| Plus copy/overwrite install | reject | transactional adapter promotion |
| Checkbox equals completion | reject | projected state only |
| Automatic archive/closure | reject | root and Plane gates |
| Universal strict TDD | reject | proportional test-design and lowest-effect proof |
| Reviewer self-correction | reject | correction returns to implementer, then re-review |
| Optional subagent after TASKS_READY | reject | physical dispatch mandatory when available |
| Silent inline fallback | reject | explicit blocked/degraded receipt |

## Dependency and release governance

OpenSpec components are external dependencies. Before any installation:

- verify official source and license;
- resolve an immutable published version/tag;
- record source commit and package provenance;
- compare required Node/runtime versions with the active service environment;
- create a recoverable backup of affected configuration and artifacts;
- stage in an isolated test root;
- validate CLI JSON contracts against fixtures;
- validate schema behavior against a compatibility matrix;
- prove rollback;
- promote through a repo-owned adapter;
- read back installed, configured, active, callable, and authorized states
  separately.

Moving `main`, `master`, or an updater's `--latest` choice is never stable
release authority.

The source snapshot used for this proposal was:

- OpenSpec Core package release `v1.11.0`, tag commit
  `a0ddb60d040c61f4907436a9d91310934b1dda63`;
- OpenSpec Core inspected main commit
  `d0071d7326689a0269332a500c8f56b3f2218ba9`;
- OpenSpec Plus inspected main commit
  `7358841abdade7629a7b6bcb3fc02bc760e064f9`, with repository `VERSION`
  reporting `1.4.1` and no immutable tag observed in the inspection;
- OpenSpec WebUI release `v1.3.0`, commit
  `ce3ed35a98613f3949062acc83fe77a7868fd6fa`.

These locators are analysis evidence, not authorization to install.

## Skills strategy

### Keep `accelerate` concise and authoritative

`SKILL.md` remains the activation and root-routing layer. It should reference
the new architecture rather than absorb the full procedure.

### Add one focused OpenSpec adapter skill

The first new skill candidate is `openspec-sdd-adapter`. It activates when work
needs OpenSpec artifact discovery, custom-schema operation, status/validation,
Plane reconciliation, or governed archive.

It should not own:

- root classification;
- task execution;
- agent dispatch;
- acceptance;
- Plane mutation authority;
- WebUI deployment.

### Agent profiles reference skills

Profiles list mandatory and conditional skills. Skills never contain hidden
authority to instantiate a worker. Dispatch decisions remain explicit in the
task graph and runtime adapter.

### WebUI deployment belongs in an adapter

LAN exposure, process identity, firewall/proxy expectations, health, canaries,
and rollback are operational deployment concerns. They belong in a runtime or
deployment adapter plus a concise operating skill, not in the OpenSpec SDD
skill.

## Machine-readable contracts to implement later

Future implementation should define schemas for:

- `hardened-execution-packet`;
- `openspec-change-binding`;
- `artifact-acceptance-receipt`;
- `task-graph`;
- `agent-profile`;
- `agent-assignment`;
- `runtime-capability-receipt`;
- `subagent-return-packet`;
- `review-finding`;
- `correction-cycle`;
- `proof-receipt`;
- `resume-packet`;
- `webui-lan-deployment-receipt`;
- `closure-packet`.

Every schema must have positive fixtures, negative fixtures, and a validator.

## Proposed delivery phases

### Phase 0 — Architecture acceptance

- review this proposal;
- resolve open decisions;
- record operator acceptance or requested changes;
- do not implement.

### Phase 1 — OpenSpec adapter spike

- freeze an immutable OpenSpec Core release;
- add fixture-only adapter experiments;
- create the `accelerate-governed` schema draft;
- prove status, instructions, validation, and archive behavior in a test root;
- produce an ADR and compatibility receipt.

### Phase 2 — Specification lifecycle integration

- add repo-owned OpenSpec adapter contracts;
- add Plane/OpenSpec binding and drift validation;
- add `openspec-sdd-adapter` under the Agent Skills standard;
- add structural tests and docs.

### Phase 3 — APAF registry and assignment compiler

- materialize portable profile schemas;
- compile profiles from constitution, role, overlay, runtime policy, and
  assignment;
- validate authority narrowing;
- add return-packet validators.

### Phase 4 — Codex runtime adapter

- map quality classes to supported Codex collaboration profiles;
- enforce physical dispatch at `TASKS_READY`;
- prove worktree/shared-workspace behavior and fan-in;
- add independent review and bounded correction-loop tests.

### Phase 5 — Governed Apply

- implement the task DAG and Apply state machine;
- add pause/resume and evidence invalidation;
- add whole-change review and forensic closure integration;
- dogfood on a bounded change.

### Phase 6 — WebUI LAN observer

- freeze an immutable WebUI release;
- choose `trusted-lab-lan` or `authenticated-lan` mode;
- implement project-root allowlisting and deployment receipts;
- start with `--host 0.0.0.0` only after firewall/proxy preflight;
- run socket, authorized-client, negative-access, log, stop, and rollback proof;
- keep it observer-only.

### Phase 7 — Additional runtime adapters

- add one runtime at a time;
- declare real primitive and capability status;
- prove model mapping, tools, isolation, messaging, and return contracts;
- never claim parity from prompt similarity alone.

## Acceptance criteria for the architecture

The architecture is ready for an implementation plan only when:

- the ontology is accepted;
- Plane/OpenSpec authority boundaries are accepted;
- custom OpenSpec schema artifact order is accepted;
- Apply state machine and correction budget are accepted;
- initial agent catalog and profile composition are accepted;
- WebUI LAN modes and mandatory controls are accepted;
- source-adoption matrix is accepted;
- implementation phases and promotion boundaries are accepted;
- open decisions below are resolved or explicitly deferred.

## Open decisions for the next analysis

1. Should the first OpenSpec integration be embedded as a Node CLI dependency,
   invoked as an external immutable CLI, or wrapped behind a small local
   service adapter?
2. Should the custom schema remain compatible with vanilla OpenSpec WebUI
   rendering without a fork, or may the WebUI gain Accelerate-specific panels?
3. Is `authenticated-lan` required for the first WebUI canary, or is an
   isolated `trusted-lab-lan` canary acceptable first?
4. Which existing Accelerate agents become the first canonical APAF profiles,
   and which remain project overlays?
5. Should OpenSpec artifacts live in the target product repository, an
   Accelerate-managed sidecar workspace, or support both through policy?

## Recommendation

Proceed with this architecture, but begin implementation only after the next
operator analysis resolves the deployment and compatibility decisions above.

The recommended first executable slice is deliberately small: a fixture-only
OpenSpec Core adapter spike using an immutable release, a draft
`accelerate-governed` schema, and no WebUI or global runtime promotion. That
slice will test whether the proposed composition works before the agent fabric
and governed Apply machinery are materialized.
