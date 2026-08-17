# Accelerate Contract v1 Software Design Document

## Document Status

- status: accepted implementation contract
- contract version: `1`
- date: 2026-07-20
- scope: documentation and implementation design only
- target repository: `/home/marcelo-karval/Backup/Projetos/accelerate`
- authority boundary: repository-local authorities only
- import candidate reviewed: `/home/marcelo-karval/.hermes/skills/productivity/accelerate`
- acceptance: `ACV1-A001`, 2026-07-21

This SDD defines the implementation target for a versioned, portable, machine-
validated Accelerate execution contract. It does not make the analyzed Hermes
bundle authoritative, install anything into a user-home runtime, or change the
current runtime contract by itself.

Normative keywords `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` have
their RFC 2119 meanings within this design.

## Executive Decision

Accelerate Contract v1 will be a repository-owned contract with:

- a strict lifecycle: `create -> classify -> execute -> invalidate -> validate -> close`;
- a strict operational mode enum: `single | parallel | wave | incident`;
- descriptive work classes that never substitute for mode;
- adaptive, portable core gates classified exactly once per activated run;
- optional extension gates selected by runtime and workflow adapters;
- typed, immutable evidence records and an explicit invalidation graph;
- prospective validation and transactional closure;
- deterministic validators plus behavioral evals;
- generated portable runtime exports sourced only from this repository.

The design adopts useful concepts observed in the Hermes bundle only after
restating them in repo-native terms. Hermes paths, Thor task-stack behavior,
Hermes profiles, gateway state, SessionDB, and Hermes-specific operational
machinery remain excluded from the portable core.

## Goals

1. Give Accelerate one versioned contract that humans, validators, adapters,
   runtime packets, and evals can share.
2. Preserve the root laws in `core/control-plane/root-laws.md` and the authority
   hierarchy established by `AGENTS.md`.
3. Make classification, execution authorization, proof freshness, and closure
   mechanically testable rather than dependent on prose or operator memory.
4. Separate descriptive task complexity (`class`) from operational scheduling
   and recovery shape (`mode`).
5. Keep the core portable while allowing Codex, OpenCode, Claude, Hermes, local
   workspace, browser, workflow-provider, and future adapters to add bounded
   extension gates.
6. Fail closed for missing authority, ambiguous side effects, stale evidence,
   incomplete review, unsafe runtime mutation, or non-transactional close.
7. Support zero-agent execution while retaining bounded parallel delegation.
8. Preserve proof order and root-owned final judgment across all modes.
9. Define exact target paths and interfaces suitable for implementation plans.
10. Support migration from the current prose-first and wave-only runtime bundle
    without silently reinterpreting historical artifacts.

## Non-Goals

1. This SDD does not implement schemas, validators, adapters, or runtime state.
2. It does not replace `SKILL.md` as the root interface.
3. It does not turn Accelerate into an implementation skill or autonomous swarm.
4. It does not require agents, remote issue providers, Linear, GitHub, or any
   particular model runtime.
5. It does not make all engineering work use `wave` mode.
6. It does not prescribe stack-specific commands in portable core.
7. It does not replace repository policy, stack profiles, or domain authorities.
8. It does not import the Hermes bundle wholesale or preserve Hermes file layout.
9. It does not guarantee compatibility with unversioned historical packet text.
10. It does not define a network service, database, dashboard, or hosted control
    plane for v1.

## Authority And Source Of Truth

### Authority order

For this design and its future implementation, authority is resolved in this
order:

1. `AGENTS.md` for repository governance and self-containment.
2. Root `SKILL.md` and `README.md` for repository-local control-plane entry.
3. Native doctrine under `core/`, especially `core/control-plane/`,
   `core/risk/`, `core/review/`, `core/runtime-packets/`, and `core/closure/`.
4. Versioned machine contract files proposed under `core/contracts/v1/` after
   they are implemented and explicitly promoted.
5. `docs/architecture/accelerate-control-plane.md` for canonical architecture.
6. `docs/architecture/accelerate-sdd-v1.md` for target layering and extraction
   direction.
7. Repo-owned adapters, profiles, onboarding, planning, skills, and references.
8. Generated `global-runtime/accelerate/` export artifacts, which are downstream
   deployment products and never authority.

Items 1-7 are resolved according to their governing/supporting/decision/backend
roles. Item 8 is listed only as the final downstream parity subject and cannot
resolve an authority conflict.

The machine manifest will be authoritative for finite enums, gate IDs, allowed
skip codes, lifecycle transitions, schema versions, and outcome IDs. Human
doctrine will remain authoritative for intent and judgment. A mismatch between
the two is a contract defect and MUST fail release validation; it MUST NOT be
resolved by choosing whichever representation permits execution.

### Generated export rule

`global-runtime/accelerate/` is the repo-governed portable export source, but it
MUST be generated or synchronized from canonical repository contract surfaces.
User-home copies are deployments, never upstream authority. Runtime export
verification remains downstream of repository validation.

### Hermes import-candidate rule

The analyzed bundle at
`/home/marcelo-karval/.hermes/skills/productivity/accelerate` is an import
candidate and comparative fixture only. Its useful candidate concepts include:

- the six-phase lifecycle;
- canonical four-mode vocabulary;
- adaptive gate classification;
- typed evidence categories;
- evidence invalidation and narrow reruns;
- risk-derived review levels;
- transactional closure;
- post-merge, late-worker, and cleanup reconciliation.

No Hermes file, command, schema ID, task-stack rule, or runtime assumption may
be cited as governing Accelerate behavior. A concept becomes authoritative only
after it is adapted into the target repository, reviewed against repo doctrine,
registered, tested, and exported from the repository outward.

## Current State And Gaps

The repository already has strong prose doctrine, a portable runtime bundle,
wave packets, `wave_gate_report.py`, local workspace closure scripts, runtime
adapters, review doctrine, and focused shell contract tests. Contract v1 closes
the following gaps.

| Gap | Current consequence | v1 requirement |
| --- | --- | --- |
| No canonical machine contract | prose and scripts can drift | versioned manifest plus JSON Schemas |
| `wave-gated` appears as a mode label | class, mode, and workflow pattern are conflated | canonical mode is `wave`; `wave-gated` is a legacy alias only during migration |
| Current top-level classification is coarse | scheduling cannot be inferred safely | separate class from exactly one mode |
| Portable bundle mainly models wave execution | `parallel` and `incident` lack equal contracts | define invariants for all four modes |
| Evidence is often free-form text | freshness, ownership, and reproducibility are not machine-checkable | typed evidence objects with identity and provenance |
| Invalidation is prose-driven | closure can rely on stale proof | explicit evidence dependency graph and invalidation ledger |
| Closure scripts produce artifacts but no shared atomic state model | partial close can disagree across files | prospective closure transaction and readback |
| Gate sets are distributed | skipped obligations can disappear | complete core gate partition with coded skips |
| Codex/local-workspace doctrine is mixed into portable guidance | runtimes may inherit unsupported assumptions | extension namespaces and adapter-owned gates |
| Existing evals are mostly trigger examples | mode, gates, safety outcomes, and transitions are under-tested | structural, fixture, behavioral, and mutation evals |
| Current wave reporter accepts broad status synonyms and weak proof strings | false coverage is possible | schema-bound targets, unique IDs, typed proof, validators, and zero-residual policy |
| Late worker and post-merge behavior are not core contract surfaces | historical output can corrupt closure truth | formal reconciliation events and selective invalidation |
| Cleanup proof is branch-specific | passing tests can leave unsafe residue | resource ledger and cleanup gate when resources are opened |
| No explicit contract compatibility policy | consumers may silently reinterpret artifacts | `contract_version`, schema versioning, migration tooling, and rejection rules |

## Architectural Principles

1. **Repository first.** The repository is the only governance source.
2. **One root, bounded adapters.** Accelerate owns global classification, risk,
   proof order, and closure; adapters cannot weaken those decisions.
3. **Complete partition.** Every portable core gate is represented exactly once
   as `run` or `skip` for an activated run.
4. **Evidence before claims.** Completion claims reference immutable evidence.
5. **Freshness is transitive.** A mutation invalidates evidence and every verdict
   derived from it through an explicit graph.
6. **Selective reproof.** Only affected gates rerun, but every affected gate
   must rerun.
7. **Prospective close.** Validate the proposed final state before publishing any
   terminal state.
8. **Fail closed.** Unknown enums, gates, extensions, skip codes, schemas, or
   state transitions deny advancement.
9. **Capabilities before commands.** Core asks for proof capabilities; runtime
   adapters select concrete commands.
10. **Agents are optional.** Parallel mode describes independent lanes, not a
    requirement for promoted agents.
11. **Historical evidence is immutable.** Corrections supersede; they do not
    rewrite old receipts.
12. **Smallest valid workflow.** Contract activation does not imply maximal
    ceremony.

## System Context

```text
User or governing issue
        |
        v
Root SKILL.md / control plane
        |
        +--> Contract engine: lifecycle, class, mode, gates, outcomes
        +--> Policy engine: repo doctrine, risk, review, proof order
        +--> Adapter registry
        |      +--> workflow adapters
        |      +--> runtime adapters
        |      +--> stack profiles
        |      +--> host extensions (Codex/OpenCode/Claude/Hermes)
        +--> Evidence store and invalidation graph
        +--> Validators and evals
        +--> Transactional closure coordinator
        |
        v
Repo-local runtime packets and optional generated global-runtime export
```

The contract engine is a deterministic policy layer. Language-model judgment
may propose classification, risks, or review findings, but deterministic
validation decides whether a run artifact conforms and whether closure is
eligible.

## Class Versus Mode

### Class

`class` describes work scope and orchestration complexity. It is useful for
defaults, observability, and budgeting, but it does not determine concurrency or
recovery semantics by itself.

Canonical v1 classes are:

- `conversational-noop`: no governed engineering execution; Accelerate may
  return `answer-without-accelerate`.
- `trivial-bounded`: narrow read-only or low-risk bounded engineering work.
- `orchestrated-nontrivial`: multi-surface, risk-sensitive, planning-sensitive,
  runtime-sensitive, or otherwise governed work.

Optional `class_tags` MAY preserve descriptive refinements such as
`trivial-mutation`, `bounded-slice`, `orchestrated-mission`, and
`runtime-incident`. Tags MUST NOT be accepted as mode values or alter mandatory
gates without an explicit trigger.

### Mode

`mode` controls execution topology. An activated governed run MUST select
exactly one:

| Mode | Use when | Required invariant | Not implied by |
| --- | --- | --- | --- |
| `single` | one lane or tightly coupled target | one owner and one integration boundary | small size |
| `parallel` | two or more genuinely independent lanes | bounded concurrency, lane ownership, seam and integration proof | multiple checklist items alone |
| `wave` | repeatable or multi-target frozen denominator | unique target IDs, frozen denominator, threshold, residual accounting, wave-by-wave advancement | large size alone |
| `incident` | active live degradation, failed cutover, or controlled recovery | preserve pre-mutation runtime evidence, command authority, readback, recovery and handoff | urgency or routine production work |

### Selection rules

1. A conversational no-op has no mode and exits with
   `answer-without-accelerate`.
2. Every other activated run has exactly one mode.
3. Default to `single` unless independence, a repeatable denominator, or a live
   incident is proven.
4. `parallel` requires at least two independent lane IDs and a declared merge or
   seam boundary.
5. `wave` requires a non-empty frozen denominator before target mutation.
6. `incident` requires an active degradation or recovery assertion tied to
   runtime evidence.
7. Mode changes are classification mutations. They invalidate budget, mode,
   lane, wave, and review decisions and require reclassification.
8. `wave-gated` is not a valid v1 mode. During migration it maps to `wave` with
   a recorded compatibility warning.

## Lifecycle State Machine

The canonical lifecycle is:

```text
create -> classify -> execute -> invalidate -> validate -> close
                    ^             |
                    |             |
                    +-------------+
                 correction/reproof
```

Every phase appears exactly once in the current run state. Historical attempts
are append-only events, not duplicate current phase rows. Valid phase statuses
are `pending`, `active`, `done`, `not-applicable`, `failed`, and `blocked`.
`not-applicable` is valid only where the phase or contract explicitly permits
it; for v1, only `invalidate` may complete as `not-applicable`.

### Create

Entry: Accelerate activation has been requested or detected.

Required persisted fields:

- run ID and contract version;
- goal and acceptance criteria;
- owner and authority set;
- repository identity and initial revision when available;
- class and mode candidates;
- mutation boundary and side-effect declaration;
- rollback boundary;
- initial resource and secret-handling posture.

Exit: the run identity is durable and enough scope exists to classify. Missing
foundational owner, target, or authority yields `scope-required`.

### Classify

Entry: `create` is `done`.

Required actions:

- select final class and exactly one mode for an activated run;
- classify every portable core gate exactly once;
- discover applicable extension gates from adapters;
- freeze denominator, lanes, budget, and review level as applicable;
- determine required evidence capabilities and proof order;
- record valid coded skips for non-triggered gates;
- produce an execution authorization outcome.

Exit: all required gate decisions are valid and the outcome permits execution,
or the run stops with a non-executable outcome.

### Execute

Entry: `classify` is `done` and outcome is executable.

Required actions:

- perform only authorized work within scope, budget, lane, and side-effect
  bounds;
- capture typed evidence as work occurs;
- maintain resources, defects, corrections, residuals, and delegation ledgers;
- preserve proof order;
- stop on an unclassified side effect, authority conflict, or budget breach.

Exit: authorized work is complete or explicitly partial; every material claim
has evidence or a named residual.

### Invalidate

Entry: `execute` is complete or any mutation occurs after evidence exists.

Required actions:

- compare mutation subjects with evidence dependency subjects;
- mark directly and transitively affected evidence `stale`;
- invalidate gate verdicts, reviews, and closure candidates derived from stale
  evidence;
- enqueue the narrowest sufficient reruns in proof order;
- reconcile post-merge events, late workers, cleanup changes, and review
  corrections;
- record `not-applicable` only when no prior evidence could have become stale.

Exit: there is no unprocessed invalidation event and all required reruns have
fresh results, or the run is blocked.

### Validate

Entry: `invalidate` is `done` or validly `not-applicable`.

Validation is prospective against a closure candidate. It MUST verify:

- schema conformance and lifecycle transition legality;
- complete core and extension gate partitions;
- current class/mode invariants;
- no stale, superseded-as-current, or missing evidence;
- acceptance criteria and requested-vs-delivered reconciliation;
- mode-specific completion conditions;
- review level and verified correction closure;
- cleanup and runtime readback when triggered;
- package/runtime export consistency when in scope;
- no unresolved blocking defect or unclassified residual.

Exit: a signed or hashed validation receipt identifies the exact candidate state.

### Close

Entry: a fresh prospective validation receipt exists for the exact closure
candidate.

Close MUST be atomic from the consumer's perspective. It writes the final
report, lifecycle terminal state, closure receipt, and adapter transitions as a
single logical transaction. If any precondition or write fails, the run remains
non-terminal and retryable. Closure is root-owned and terminal. `closed` never
transitions back to a non-terminal state. Any material post-close event creates
a successor reconciliation run linked to the closed run; it never reopens or
rewrites it.

## Outcomes

The classification and validation engines use these canonical outcomes:

| Outcome | Meaning |
| --- | --- |
| `execute` | triggered gates and authority permit full declared execution |
| `bounded-execution` | work may proceed only within explicit scope, budget, rollback, and proof bounds |
| `minimal-valid-skips` | activated small run with always-run gates and valid coded skips only |
| `approval-required` | no mutation until one explicit approval, account, destination, or authority decision is supplied |
| `scope-required` | no mutation until foundational owner, target, denominator, or boundary is supplied |
| `proposal-only-unless-proven` | analysis or candidate output may be produced, but effect or completion is blocked pending named proof |
| `blocked` | current request is prohibited, irreversible without protection, or cannot be made safe by one bounded decision |
| `rerun-invalidated-only` | mutation made proof stale; only affected proof lanes may run until freshness is restored |
| `answer-without-accelerate` | activation boundary does not match |

Executable outcomes are `execute`, `bounded-execution`, and
`minimal-valid-skips`. `rerun-invalidated-only` authorizes only the declared
reproof work. All other outcomes deny mutation.

## Review Levels

Review level is risk-derived and independent of mode:

- `self`: low-risk, local, reversible artifact with no runtime, executable,
  integration, sensitive-data, or external side-effect claim.
- `independent`: executable code, integration, configuration, multi-surface,
  parallel seam, or material workflow change.
- `forensic`: production, auth, secrets, PII, recurring automation, outbound
  effects, autonomous mutation, incident recovery, irreversible action, or
  ambiguous/conflicting evidence.

The selected level is a floor. Adapters and policy may raise but never lower it.
A reviewer result is a finding set, not proof by itself. Material findings MUST
be reproduced or directly inspected; corrections invalidate affected review and
require review-of-review. Root owns the final verdict.

Review stages remain compatible with existing doctrine:

```text
micro-review -> branch review -> integration review -> forensic review
             -> closure review -> review-of-review
```

Not every stage requires a distinct person or agent. The required review level
determines segregation, evidence, and independence, not staffing count.

## Portable Core Gates

Every activated v1 run MUST contain exactly one decision for every core gate.
Decisions are `run` or `skip`. `run` requires a reason and evidence requirements;
`skip` requires an allowed gate-specific code and no fabricated evidence.

| ID | Gate | Trigger | Required behavior | Valid skip code(s) |
| --- | --- | --- | --- | --- |
| `core.mode-contract` | Mode contract | every activated run | choose and justify exactly one mode | none |
| `core.scope-owner` | Scope and owner | mutation | owner, target, denominator, side effects, rollback | `read-only` |
| `core.authority-truth` | Authority and truth ownership | every activated run | classify governing, supporting, generated, and forbidden sources | none |
| `core.runtime-truth` | Runtime truth | runtime-facing claim | pre-state probe and post-change readback | `pure-local-artifact` |
| `core.review-level` | Review level | every activated run | choose risk-derived floor | none |
| `core.proof` | Proof | every completion claim | map claims to typed evidence in proof order | none |
| `core.recurring-executor` | Recurring executor | cron, timer, watcher, poller, consumer, retry loop | lock, idempotency, cursor, bounded batch, failure and delivery receipt | `one-shot` |
| `core.script-agent-integrity` | Script plus agent integrity | deterministic output feeds probabilistic interpretation | script exit is authoritative; separate mechanical and semantic stages | `no-script-agent-seam` |
| `core.autonomous-mutation` | Autonomous mutation | unattended mutation | deterministic bounds, diff, rollback, postcondition; otherwise proposal-only | `read-only`, `attended-mutation` |
| `core.service-cutover` | Service/API cutover | listener, gateway, router, webhook, daemon, endpoint | fail-closed auth, controlled transition, health, negative/positive probe, identity readback | `no-runtime-process` |
| `core.changed-code-coverage` | Changed-code coverage | executable code changed | profile-defined changed-surface coverage; a triggered core decision cannot be waived | `docs-config-only` |
| `core.wave` | Wave denominator | mode is `wave` or repeated independent target set exists | frozen unique IDs, target proof, threshold, residual accounting | `not-wave` |
| `core.outbound-side-effect` | Outbound side effect | external send, publish, payment, provider write | account, destination, payload, authority, dry run, dedup, receipt, compensation | `no-outbound` |
| `core.sensitive-data` | Sensitive data | PII, credentials, sessions, protected logs/data | minimization, authorization, destination, retention, redaction, cleanup | `no-sensitive-data` |
| `core.execution-budget` | Execution budget | non-trivial or resource-intensive run | bound lanes/agents, waves, retries, time, heavy gates, early stop | `trivial-bounded` |
| `core.evidence-invalidation` | Evidence invalidation | evidence exists or mutation follows proof | graph invalidation and selective rerun | `no-prior-evidence` |
| `core.resource-cleanup` | Resource cleanup | disposable or background resource opened | inventory, bounded teardown, absence/readback receipt | `no-managed-resource` |
| `core.transactional-close` | Transactional closure | every close attempt | prospective validate, atomic publish, terminal readback | none |

This design intentionally uses 18 portable gates rather than adopting the
Hermes candidate's count as law. `authority-truth`, `resource-cleanup`, and
`transactional-close` are explicit portable gates because they are existing
Accelerate root concerns and closure invariants. Gate count is versioned; v1
implementations MUST use this complete set.

### Gate extension rules

1. Extension IDs use `<namespace>.<gate-name>` and MUST NOT use `core.`.
2. Extensions declare owning adapter, trigger, evidence capabilities, allowed
   skips, risk escalation, and dependency edges.
3. An extension may add proof or raise review; it may not skip, replace, or
   weaken a triggered core gate.
4. Unknown required extensions fail closed. Unknown optional observability
   fields may be preserved but not executed.
5. Adapter removal is blocked while active run artifacts depend on its required
   gate definitions.
6. Triggered core gates cannot be waived. A governed, scoped, expiring waiver
   may apply only to a registered extension/profile gate whose definition
   declares waiver policy; it cannot lower review or satisfy a core gate.

## Codex Extensions

Codex extensions are repo-owned adapter behavior, not portable core. Their
target registry is `adapters/runtime/codex/contract-extension.yaml`; human
doctrine remains under `adapters/runtime/codex/` and native `core/` references.

Proposed Codex extension gates are:

| ID | Trigger | Requirement |
| --- | --- | --- |
| `codex.local-workspace-entry` | target repo uses `.accelerate/` | resolve install/reuse/reentry/reonboarding before mutation |
| `codex.issue-bootstrap` | mutation-bearing engineering work under issue policy | governing issue or explicit narrow approved exception |
| `codex.post-issue-plan` | non-trivial issue-driven mutation | persisted integrated plan before execution |
| `codex.prompt-hardening` | ambiguous, long, epic-like, or architecture-heavy request | visible `Prompt A -> Prompt B` execution-ready artifact |
| `codex.runtime-packet-visibility` | non-trivial run | Branch Entry, Runtime Delta, proof, and closure packet cadence |
| `codex.side-by-side-reconciliation` | one-shot protocol active | plan/task/request/defect/correction/validation reconciliation |
| `codex.browser-before-persistent-e2e` | unstable runtime-facing UI flow | direct browser truth before persistent Playwright proof |
| `codex.local-handoff-preparation` | `.accelerate/` enters review/closure | use canonical composed preparation or explicit debug exception |
| `codex.skill-export-sync` | repo-managed runtime bundle changed and export is in scope | repository validation, generated export, mirror check |
| `codex.single-threaded-exception` | non-trivial work remains root-only | explicit reason and compensating review posture |

These extensions MUST be capability-driven. Script names such as
`prepare-review.sh` and `prepare-closure.sh` belong to the Codex/local-workspace
adapter contract and MUST NOT become portable lifecycle requirements.

## Typed Evidence Object

Free-form prefixes are retained as human rendering, but storage uses typed
objects. The target schema is
`core/contracts/v1/schemas/evidence.schema.json`.

```json
{
  "evidence_id": "ev_01J...",
  "contract_version": 1,
  "type": "test",
  "subject": {
    "kind": "git-tree",
    "id": "repo-relative-or-provider-stable-id",
    "revision": "sha256-or-git-sha"
  },
  "claim_ids": ["claim.acceptance.1"],
  "gate_ids": ["core.proof", "core.changed-code-coverage"],
  "producer": {
    "kind": "runtime-adapter",
    "id": "python-uv",
    "version": "resolved-version"
  },
  "command": ["pytest", "tests/example_test.py"],
  "working_directory": ".",
  "started_at": "2026-07-20T12:00:00Z",
  "finished_at": "2026-07-20T12:00:02Z",
  "exit_code": 0,
  "result": "pass",
  "artifact_refs": ["artifact://qa/test-report.json"],
  "content_digest": "sha256:...",
  "redaction": "none",
  "freshness": "fresh",
  "supersedes": [],
  "metadata": {}
}
```

### Evidence types

Canonical v1 types are:

- `command`
- `file`
- `api`
- `runtime`
- `test`
- `coverage`
- `receipt`
- `artifact`
- `review`
- `approval`
- `cleanup`
- `readback`

Human renderers may display `cmd:` for `command`. Persisted values use the full
enum. Adapters may add namespaced subtypes in `metadata`, not new top-level types
without a contract minor/major decision.

### Evidence invariants

1. `evidence_id`, subject identity, producer, time, result, and digest are
   mandatory.
2. Commands are arrays, never shell-joined strings, in machine artifacts.
3. Evidence MUST identify the exact revision, artifact, runtime instance, API
   object, or external receipt it proves.
4. Secrets, raw credentials, session tokens, and unbounded logs MUST NOT be
   embedded. Store redacted artifacts or references with access policy.
5. `pass` means the declared check passed, not that the run is complete.
6. Agent summaries are `review` or `artifact` inputs; they are not runtime truth.
7. Evidence is append-only. New evidence supersedes old evidence by ID.
8. `freshness` is `fresh | stale | superseded | historical | rejected`.
9. A digest mismatch rejects the evidence.
10. External URLs require an immutable provider ID or revision where the
    provider supports one.

## Invalidation Graph

The invalidation model is a directed acyclic derivation graph for one run:

```text
subjects -> evidence -> gate verdicts -> review verdicts
         -> acceptance verdicts -> validation receipts -> closure candidates
```

Nodes:

- `subject`: source tree, file, config, test, runtime process, deployment,
  provider object, issue, approval, denominator, or artifact;
- `evidence`: typed proof object;
- `gate-verdict`: pass, fail, skip, blocked;
- `review-verdict`: verified finding disposition;
- `acceptance-verdict`: criterion pass/fail;
- `validation-receipt`;
- `closure-candidate`.

Proof stages such as implementation, backend/frontend QA, browser truth,
persistent regression, post-merge, cleanup, and forensic closure are claim or
`metadata.proof_stage` values. They do not add competing top-level evidence
types to the closed evidence type enum.

Edges use `depends_on`. Mutation events identify changed subject IDs and
revisions. The engine performs reverse dependency traversal, marks descendants
stale, and emits rerun requirements for affected gates. Cycles are invalid
contract data and block validation.

### Baseline invalidation rules

| Mutation/event | Directly invalidates | Minimum reproof |
| --- | --- | --- |
| executable code | affected tests, coverage, runtime/build evidence | focused tests, coverage, affected integration/runtime proof |
| test code or fixture | test and coverage receipts using it | focused tests and report identity |
| config/policy/schema | parser, policy, adapter and runtime readback | parse, schema validate, semantic validator, readback |
| skill/prompt/eval | activation and behavior claims | structure tests, focused behavioral evals, export sync when in scope |
| denominator or target list | wave coverage and closure | re-freeze, reclassify affected targets, recompute coverage |
| lane boundary or owner | parallel seam and integration proof | lane reclassification, seam proof, integration review |
| service/runtime unit | process identity, health, route and log proof | controlled transition, identity, health, negative/positive probes |
| auth/secret boundary | access and safety evidence | fail-closed negative plus authorized positive proof |
| outbound destination/payload | approval, dry run, dedup and receipt | renewed scope/approval and bounded effect proof |
| review correction | affected proof and prior review verdict | gate reproof and review-of-review |
| merge-generated SHA | claims about merged/default branch state | exact merged SHA CI/readback and tree comparison where meaningful |
| late worker | evidence or artifact it could affect | classification plus narrow current-candidate rerun |
| cleanup action | runtime/resource state proof | absence/readback and any affected functional smoke |

The invalidation ledger stores event ID, actor, timestamp, old and new subject
revision, affected nodes, reason, planned reruns, completed reruns, and result.
It is append-only and schema-validated.

## Mode-Specific Execution Contracts

### Single

- one lane owner;
- tightly coupled targets may share the lane;
- no fake parallelism or denominator ceremony;
- review and proof still follow risk;
- production cutover remains `single` unless an active incident exists.

### Parallel

- at least two lane records with non-overlapping write scopes or explicit lock
  coordination;
- bounded parallelism budget;
- no nested delegation unless an extension explicitly authorizes it;
- each return includes scope, mutations, evidence, residuals, and self-review;
- late or missing returns are classified, never silently treated as consumed;
- root performs seam proof, integration proof, and final revalidation.

### Wave

- denominator freezes before mutation with unique stable target IDs;
- each target names all applicable gates and typed proof;
- default portable threshold is `0.95`; profiles or risk may raise it;
- critical/small denominators SHOULD require `1.0`;
- uncovered, failed, governed-waived extension/profile, and excluded targets
  remain distinct; core-gate targets are never waived;
- an uncovered blocking target prevents advancement even if numeric threshold
  passes;
- denominator changes require an explicit re-freeze event and invalidate prior
  coverage;
- each wave closes with `advance | correct | block`; a registered
  extension/profile target may separately record an allowed governed waiver,
  but no triggered core gate can be waived;
- final run closure reconciles all waves, not only the last one.

### Incident

- preserve volatile pre-mutation evidence before destructive convergence;
- declare incident commander/root owner and mutation authority;
- classify observations as direct observation, supported inference, or unproven
  cause;
- use narrow, reversible recovery steps with readback after each material step;
- runtime health and user-visible recovery do not by themselves prove root cause;
- maintain a timeline and handoff state;
- closure requires recovered-state proof, residual risk, cleanup, follow-up/RCA
  disposition, and forensic review.

## Post-Merge Semantics

Pre-merge proof and post-merge proof are distinct subjects. Post-merge is a
registered triggered extension/profile gate (for example
`workflow.post-merge`): when no merge/default-branch claim is in scope it
records `skip: not-triggered`; when triggered it must run and cannot be waived.

1. Record candidate commit and tree identity before merge.
2. Record provider PR/check identity and successful candidate checks.
3. Read back merged state and exact merge/default-branch SHA.
4. Treat a new merge SHA as invalidating claims that asserted proof of the
   resulting default-branch state.
5. Require CI or equivalent proof for that exact SHA when default-branch proof
   is in scope.
6. Compare candidate and merged trees when merge strategy permits a meaningful
   comparison.
7. Persist immutable provider IDs/URLs as `api`, `receipt`, and `readback`
   evidence.
8. Do not claim fully landed delivery from PR CI alone when post-merge proof is
   required.
9. If post-merge automation mutates artifacts or deployment state, represent
   those as new subjects and evidence.

## Late-Worker Semantics

A notification arriving after closure preparation is neither automatically a
current failure nor ignorable noise.

Late events are classified as:

- `replay-historical`: output belongs to an obsolete candidate;
- `late-nonmutating`: worker did not alter the candidate, though findings may
  still affect a documentary or readiness claim;
- `late-mutating`: worker may have altered final artifacts or runtime state;
- `dispatched-not-consumed`: delegated result never entered root integration.

Required reconciliation:

1. Identify worker, command/config revision, process state, and candidate.
2. Inspect only affected residue and safe artifact fingerprints.
3. If current state may have changed, invalidate affected nodes and rerun the
   narrowest current-source gate.
4. If findings alter a document or claim, independently verify them; the
   resulting amendment is itself a mutation.
5. Persist classification, cleanup, identity readback, and focused revalidation.
6. Never attribute a decision or review to an unconsumed worker result.
7. A post-close material event creates a successor reconciliation run; v1 does
   not rewrite a terminal run.

## Cleanup Semantics

Any run that opens disposable or background resources maintains a resource
ledger. `core.resource-cleanup` records `skip: no-managed-resource` when no
managed resource was opened; otherwise it runs and cannot be waived. Resource
kinds include process, listener/port, container, database,
temporary directory, fixture project, generated credential, branch/worktree,
provider draft, and scheduled job.

Each resource record contains owner, create evidence, expected lifetime,
cleanup strategy, sensitivity, cleanup evidence, and final state. Prefer
command-scoped teardown (`trap` or bounded wrappers). The proof order is:

```text
functional proof -> triggered cleanup proof or coded skip -> prospective validation
-> provider reconciliation/readback -> logical terminal commit
```

Unclean sensitive or production resources block closure. A bounded benign
residual may close only with an explicit warning, owner, expiry, and approved
follow-up policy. Running out of execution budget does not convert missing
cleanup into success.

## Transactional Closure

### Closure candidate

The closure coordinator builds an isolated candidate containing:

- final lifecycle state;
- gate matrix and extension matrix;
- evidence and invalidation indexes;
- acceptance and requested-vs-delivered verdicts;
- defect, correction, residual, resource, budget, and review summaries;
- mode-specific summary;
- adapter transition intents;
- final report and content digests.

### Algorithm

1. Acquire a run-scoped closure lock and enter internal state `closing`.
   `closing` is prepared/nonterminal transaction state, not a published
   lifecycle phase or terminal outcome.
2. Snapshot current run revision and external adapter read versions.
3. Build the candidate in a temporary sibling directory or in-memory model.
4. Run schema, semantic, freshness, security, adapter, and acceptance validators
   against the candidate.
5. Generate a validation receipt bound to all candidate digests.
6. Recheck optimistic concurrency tokens and runtime/provider state.
7. Stage reversible adapter transitions; irreversible provider transitions occur
   only after all local preconditions pass and require compensation metadata.
8. Apply or confirm the provider transition, capture its immutable receipt, and
   read it back while local state remains nonterminal `closing`.
9. Prepare the final report, closure receipt, provider-confirmed/read-back state,
   and local terminal state from the same candidate digest.
10. Publish `closed`, the final receipt/report, and provider readback as one
    logical commit, then verify local terminal state and receipt digests.

No observer may see local `closed` before provider reconciliation/readback is
confirmed and included in the logical commit. If any step fails, local state
remains nonterminal `closing` or blocked and retryable. If a provider transition
succeeds but local commit fails, the coordinator retains the provider receipt
and performs compensation/reconciliation before retry; it does not publish
`closed`. Validators MUST reject a report that says closed while lifecycle or
provider truth disagrees.

## Machine Contracts And Schemas

### Canonical target paths

```text
core/contracts/
├── README.md
└── v1/
    ├── accelerate-contract.json
    ├── accelerate-contract.schema.json
    ├── extension-registry.yaml
    ├── outcome-rules.yaml
    ├── adaptive-gate-matrix.json
    ├── adaptive-gate-matrix.schema.json
    └── schemas/
        ├── run.schema.json
        ├── lifecycle.schema.json
        ├── authority-set.schema.json
        ├── gate-definition.schema.json
        ├── gate-decision.schema.json
        ├── evidence.schema.json
        ├── invalidation-event.schema.json
        ├── dependency-graph.schema.json
        ├── lane.schema.json
        ├── wave.schema.json
        ├── incident.schema.json
        ├── resource.schema.json
        ├── review.schema.json
        ├── validation-receipt.schema.json
        ├── closure-receipt.schema.json
        ├── eval-case.schema.json
        ├── eval-result.schema.json
        └── release-backup-manifest.schema.json
```

JSON Schemas use draft 2020-12, repository-owned `$id` values, closed objects by
default, explicit required fields, and no remote schema resolution during
validation. YAML extension definitions are parsed to data and validated against
the same schema family.

### Run aggregate

`run.schema.json` is the persisted aggregate root and requires:

- `run_id`, `framework`, `contract_version`, `revision`;
- `class`, optional `class_tags`, and exactly one `mode` for activated runs;
- `goal`, `acceptance_criteria`, `authority_set`, `owner`;
- `lifecycle`, `outcome`, `review_level`;
- `gate_decisions`, `extension_gate_decisions`;
- `lane_ids`, optional `wave_ids`, optional `incident_id`;
- `evidence_ids`, `invalidation_event_ids`, `resource_ids`;
- `defects`, `corrections`, `residuals`, `budget`;
- `created_at`, `updated_at`, and content digest.

Large evidence bodies and artifacts remain separate files addressed by ID and
digest. The aggregate stores indexes, not raw logs.

### Machine invariants

- `framework == "accelerate"` and `contract_version == 1`;
- mode is one of the four canonical values;
- gate IDs are unique and exactly partition the active definitions;
- always-run gates cannot skip;
- skip codes belong to that gate and evidence is absent except for skip rationale;
- run gates carry typed evidence requirements and eventually fresh evidence;
- lifecycle transitions follow the state machine;
- graph nodes and references resolve locally;
- digests match canonical JSON serialization;
- extension namespaces are registered;
- `parallel`, `wave`, and `incident` satisfy their mode constraints;
- validation and closure receipts bind the same run revision;
- terminal close has no stale evidence or unresolved blocking records.

## Package Layout

The implementation should add the smallest coherent package while preserving
the accepted layered architecture:

```text
core/contracts/                         # canonical portable data contract
core/control-plane/contract-lifecycle.md
core/closure/transactional-closure.md
core/runtime-packets/contract-v1-templates.md
adapters/runtime/codex/contract-extension.yaml
adapters/runtime/opencode/contract-extension.yaml
adapters/runtime/claude/contract-extension.yaml
adapters/runtime/hermes/contract-extension.yaml
adapters/workflow/local/contract-extension.yaml
global-runtime/accelerate/assets/       # generated portable contract subset
global-runtime/accelerate/references/contract-v1.md
global-runtime/accelerate/templates/    # generated portable packet templates
scripts/accelerate_contract/            # validator library/CLI implementation
tests/*.sh                              # repository-conventional top-level focused tests
tests/fixtures/                         # domain-grouped deterministic fixtures
evals/contract-v1/                      # behavioral cases and expected partitions
```

Do not place canonical schema files under `global-runtime/`; that directory is
an export target. Do not place runtime-specific extension gates under `core/`.
Do not duplicate human doctrine into every adapter. Contract v1 follows the
repository's canonical test topology: executable shell tests remain top-level
under `tests/`, while their data lives under named domains in
`tests/fixtures/`. A separate `tests/contract-v1/` package is not required.

## Data Models

### AuthoritySet

- governing authorities;
- supporting references;
- decision artifacts;
- backend or domain truth sources;
- generated exports;
- forbidden/excluded authorities;
- conflicts and resolution status.

Every source has stable ID, type, location, digest/revision where available,
authority role, and rationale. External candidates default to `supporting` or
`forbidden-as-authority`.

### GateDefinition And GateDecision

`GateDefinition` contains ID, version, owner, trigger expression, mandatory
status, allowed skip codes, required evidence capabilities, risk escalation,
and dependencies. `GateDecision` contains definition ID/version, trigger result,
`run|skip`, reason/code, evidence requirements, verdict, and freshness.

### Lane

Contains lane ID, owner, read/write scope, dependencies, concurrency group,
budget, required return fields, evidence IDs, status, and integration verdict.

### Wave

Contains wave ID, selection rule, frozen denominator digest, unique targets,
threshold, exclusions, governed extension/profile waivers, target gate/evidence
status, correction loops, coverage, residuals, and decision. It cannot waive a
triggered core gate.

### Incident

Contains incident ID, severity, start time, commander, affected surface,
symptoms, pre-mutation evidence, hypothesis classifications, actions, timeline,
recovery criteria, current runtime state, cleanup, handoff, and RCA disposition.

### Review

Contains review ID, level, reviewer identity/independence, subject revision,
finding IDs, reproduction evidence, dispositions, corrections, reproof, and
review-of-review verdict.

### Resource

Contains resource ID/type, owner, sensitivity, create evidence, process/provider
identity, lifetime, teardown plan, teardown evidence, final state, and residual
approval when applicable.

### ValidationReceipt And ClosureReceipt

Validation binds run revision, aggregate digest, all index roots, validator
versions, verdict, and timestamp. Closure adds transition result, provider
receipts, readbacks, final report digest, and terminal state. Receipts are
immutable and superseded only by successor attempts.

## Validators

Target CLI: `scripts/validate-accelerate-contract.py`, backed by importable code
under `scripts/accelerate_contract/`.

Validator stages run in this order:

1. `schema`: JSON/YAML parsing, local schema resolution, closed-object checks.
2. `contract`: enums, definitions, IDs, version, complete gate partition.
3. `lifecycle`: legal transition and phase preconditions.
4. `mode`: lane, denominator, or incident invariants.
5. `authority`: source roles, conflicts, forbidden authority use.
6. `evidence`: IDs, types, digests, subjects, provenance, redaction metadata.
7. `graph`: reference integrity, acyclicity, stale descendant calculation.
8. `proof`: claim-to-fresh-evidence coverage and proof order.
9. `review`: level floor, correction/reproof, review-of-review.
10. `resources`: cleanup and residual policy.
11. `adapters`: registered extension conformance without executing side effects.
12. `closure`: prospective transaction and receipt consistency.
13. `security`: secret-pattern scan, unsafe paths/URLs, untrusted extension use.
14. `export`: canonical-to-global-runtime parity when export is in scope.

CLI requirements:

- supports `--help` without optional runtime dependencies;
- supports `--root`, `--run`, `--stage`, `--format json|text`, and `--quiet`;
- never executes scenario side effects during validation;
- exit `0` pass, `1` contract failure, `2` usage/environment failure;
- emits stable error codes and JSON pointers;
- does not print secrets or full sensitive evidence;
- defaults to offline local schema resolution.

## Evals And Tests

### Deterministic tests

Repository-conventional top-level Contract v1 shell tests plus their exact
`tests/fixtures/<domain>/` data will cover:

- manifest/schema self-validation;
- exact class, mode, outcome, evidence, review, and lifecycle enums;
- all 18 core gates, unique IDs, always-run rules, and skip codes;
- valid and invalid lifecycle transitions;
- complete gate partitions and unknown extension rejection;
- each mode's positive and negative invariants;
- evidence digest, provenance, and redaction requirements;
- invalidation graph propagation and cycle rejection;
- selective rerun behavior;
- prospective close, injected write failure, and retry;
- post-merge SHA invalidation;
- all late-worker classifications;
- resource cleanup and unsafe residual rejection;
- Codex extension registration without core coupling;
- generated global-runtime parity;
- migration fixtures for `wave-gated` and old packet forms.

### Behavioral evals

Target path `evals/contract-v1/evals.json` will include:

- activation and near-miss cases;
- trivial read-only, trivial mutation, one-shot, parallel, repeated wave, and
  runtime incident cases;
- one focused case for every core gate;
- mode ambiguity and size/urgency near misses;
- approval, scope, outbound, sensitive-data, auth, and autonomous safety cases;
- post-proof mutation and selective invalidation;
- post-merge, late-worker, cleanup, and conflicting-review cases;
- Codex extension trigger and non-trigger cases;
- class/mode confusion traps.

Each case defines primary expected class/mode/outcome, explicitly allowed
variance where judgment is legitimate, exact required gate partition, skip
codes, and evidence capabilities. The runner MUST NOT expose expected answers to
the model. Safety cases MUST NOT permit executable outcomes. A permitted
non-primary result is reported as `PASS_WITH_VARIANCE`, never silently
normalized.

### Mutation and property tests

- mutate every enum and required field to ensure fail-closed rejection;
- generate random DAGs and verify stale propagation;
- inject graph cycles and broken references;
- inject closure failures at every transaction step;
- vary target order and prove denominator digest stability;
- replay evidence against a different subject revision and reject it;
- test redaction against representative credential/token patterns.

## Runtime Adapters

Runtime adapters translate proof capabilities into commands and readbacks. They
MUST implement the contract in `adapters/runtime/adapter-contract.md` and declare:

- adapter ID/version and supported contract versions;
- capabilities and concrete invocation shape;
- evidence types produced;
- subject identity and digest method;
- cancellation, timeout, and cleanup behavior;
- sensitivity/redaction policy;
- extension gates, if any;
- health and availability probe.

Initial adapter mapping should use existing paths:

- `adapters/runtime/python-uv/` for Python checks;
- `adapters/runtime/node/` for Node/type/build checks;
- `adapters/runtime/browser/` and
  `adapters/runtime/chrome-devtools/` for browser truth;
- `adapters/runtime/playwright/` for persistent E2E;
- `adapters/runtime/codex/`, `opencode/`, `claude/`, and `hermes/` for host
  capabilities and extension registration;
- `adapters/runtime/proof-fixtures/` for deterministic adapter conformance.

Adapters return evidence; they do not set root outcome or close the run. Missing
adapter capability yields `proposal-only-unless-proven`, `scope-required`, or
`blocked` according to risk, never fabricated success.

## Workflow Adapters

Workflow adapters map run identity, issue topology, provider states, comments,
artifacts, approvals, and closure transitions. Existing target surfaces include:

- `adapters/workflow/local/`;
- `adapters/workflow/github/` and `github-pr/`;
- `adapters/workflow/github-issues/`;
- `adapters/workflow/linear/`.

The local adapter is the baseline fallback. Remote adapters are optional and
MUST advertise capability rather than being assumed. Provider state is external
truth and requires readback. Comments are reports, not lifecycle authority.
Provider writes require idempotency keys where available and are included in
transactional closure reconciliation.

## Observability

Contract observability uses structured events plus human packets.

### Event envelope

Every event contains `event_id`, `run_id`, contract version, run revision,
timestamp, phase, class, mode, actor, event type, correlation IDs, severity,
subject IDs, and redacted payload digest.

Canonical event types include:

- `run.created`, `run.classified`, `run.outcome-selected`;
- `phase.transitioned`, `gate.decided`, `gate.passed`, `gate.failed`;
- `evidence.recorded`, `evidence.invalidated`, `evidence.rerun`;
- `lane.opened`, `lane.returned`, `lane.integrated`;
- `wave.frozen`, `wave.corrected`, `wave.advanced`;
- `incident.observed`, `incident.mutated`, `incident.recovered`;
- `resource.opened`, `resource.cleaned`, `resource.residual`;
- `review.finding`, `review.corrected`, `review.verified`;
- `closure.attempted`, `closure.reconciliation-required`, `run.closed`.

### Human packet mapping

Existing Branch Entry, Runtime Delta, QA/Proof, Subagent Return, Wave, Defect,
Correction, Seam Proof, and Closure packets become renderings of machine state.
Packet text MUST NOT be a second mutable database. `handoff-summary.md` remains
a compact reentry projection when the local workspace adapter is active.

### Metrics

Useful aggregate metrics are activation rate, class/mode distribution, gate
trigger/skip/failure rate, stale evidence count, rerun fan-out, closure retries,
cleanup residuals, wave coverage, lane integration failures, incident recovery
time, eval variance, and adapter availability. Metrics MUST avoid source,
prompt, secret, or customer payload leakage.

## Security And Fail-Closed Behavior

1. Contract and schema loading is local-only by default; remote `$ref` is
   forbidden.
2. Extension registries are allowlisted and repository-owned.
3. Unknown required fields, gate IDs, skip codes, modes, outcomes, evidence
   types, or lifecycle transitions block advancement.
4. Outbound, production, auth, sensitive-data, and autonomous actions never
   default to executable outcomes when authority or scope is missing.
5. Evidence artifacts use least privilege, bounded retention, redaction, and
   digest verification.
6. Commands are represented as argument arrays; validators never `eval` command
   strings from artifacts.
7. Paths are repository-relative or explicitly allowlisted; traversal and
   symlink escapes are rejected for managed artifacts.
8. External content and agent output are untrusted inputs and cannot alter the
   contract or authority set by instruction injection.
9. Provider receipts and approvals identify account, actor, target, and stable
   provider object where possible.
10. Incident evidence is captured before destructive mutation when safe, but
    collection MUST remain bounded and redact secrets.
11. Closure locks, optimistic revisions, idempotency keys, and immutable receipts
    protect against concurrent or duplicate close attempts.
12. A validator crash, adapter timeout, missing runtime, or unreadable evidence
    is not a pass.

## Migration And Compatibility

### Compatibility policy

- `contract_version` is an integer major contract version.
- Additive optional fields may ship under v1 only when old validators safely
  ignore them by explicit schema allowance; closed core objects otherwise
  require a versioned schema update and coordinated release.
- Removing/renaming enum values, changing gate meaning, weakening invariants, or
  changing lifecycle semantics requires v2.
- Historical unversioned artifacts are read-only legacy inputs, not valid v1
  closure artifacts.
- No silent best-effort coercion is allowed during closure.

### Migration phases

1. **Inventory and fixtures.** Capture representative legacy wave/packet inputs
   under `tests/fixtures/contract-v1-migration/valid/`, with expected v1 output
   under `tests/fixtures/contract-v1-migration/expected/` and blocking cases
   under `tests/fixtures/contract-v1-migration/invalid/`; remove secrets.
2. **Canonical manifest.** Implement `core/contracts/v1/` and deterministic
   self-validation without changing runtime behavior.
3. **Read-only validator.** Validate generated examples and report current drift;
   do not gate users yet.
4. **Dual emission.** Existing renderers emit current Markdown plus v1 machine
   artifacts. Machine state is compared but not yet closure-authoritative.
5. **Wave normalization.** Map legacy `mode: wave-gated` to `mode: wave`, record
   `migration_alias_used`, and update repo-owned templates/evals/scripts.
6. **Evidence and invalidation.** Introduce typed evidence IDs and graph-backed
   freshness while preserving Markdown projections.
7. **Extension extraction.** Move Codex/local-workspace requirements into the
   registered Codex extension without weakening current behavior.
8. **Transactional close shadowing.** Build and validate closure candidates while
   existing close remains authoritative; compare results.
9. **Cutover.** Make v1 validation and transactional close authoritative after
   fixture, adapter, export, and rollback acceptance passes.
10. **Deprecation.** Reject new unversioned run artifacts; retain read-only
    migration tooling for historical inspection.

### Legacy mappings

| Legacy value/form | v1 mapping |
| --- | --- |
| `wave-gated` mode | `wave` plus migration warning |
| `bounded slice` | class tag; base class selected by complexity |
| `orchestrated mission` | `orchestrated-nontrivial` class/tag, not mode |
| `runtime incident` | class tag plus `incident` mode only with live-runtime trigger |
| `cmd:` string | `command` evidence object |
| free-form proof list | typed evidence records and claim links |
| closure packet only | projection; insufficient without validation/closure receipt |

## Explicit Hermes-Only Exclusions

The following MUST NOT enter portable core or become Accelerate authority solely
because they exist in the analyzed Hermes bundle:

- `thor-task-stack` CLI, PRD/Gate Matrix file conventions, and the exact
  `qa/final-validation.txt` requirement;
- Hermes home paths such as `~/.hermes`, `~/.hermes/hermes-agent`,
  `~/.hermes/apps`, and `~/.hermes/router/tasks`;
- Hermes profile `AGENTS.md`/`SOUL.md` semantics;
- Hermes gateway, plugins, connectors, cron, systemd, and Postgres SessionDB as
  required runtime truth sources;
- Thor/default as a mandatory final synthesis voice;
- Hermes agent YAML shape and provider/model invocation conventions;
- Hermes-specific scripts `validate_hermes_governance.py`,
  `run_adaptive_gate_evals.py`, and `compare_accelerate_skill.py` as shipped;
- the Hermes schema ID namespace and exact 15-gate count;
- Hermes issue/task topology, maturity labels, and governance approval storage;
- Rocket.Chat, Adonis, Yasmim, and other product-specific operational lessons as
  generic contract requirements;
- Hermes upstream fork, release build, livechat, container, and deployment
  assumptions;
- any rule that a Hermes external mirror is a health dependency;
- any automatic synchronization from Hermes into this repository.

Portable principles may be independently reimplemented. Hermes interoperability
belongs only in `adapters/runtime/hermes/` and MUST declare the repository v1
contract as its authority.

## Risks And Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Contract ceremony overwhelms trivial work | adoption failure | `minimal-valid-skips`, compact projections, smallest valid workflow |
| Schema and prose drift | contradictory authority | generated docs where feasible, doctrine integrity tests, release blocker |
| Gate count becomes rigid bureaucracy | unsafe or irrelevant execution | trigger-based adaptive gates, versioned definitions, no arbitrary per-run omission |
| Evidence graph grows too large | slow validation | content-addressed indexes, bounded artifacts, incremental traversal |
| Selective rerun misses a dependency | stale closure | conservative default edges, mutation tests, ability to escalate to broader rerun |
| Adapters weaken core policy | safety regression | extension-only additions, conformance tests, root outcome ownership |
| Transactional illusion across remote providers | split-brain close | staged intents, optimistic readback, reconciliation-required state, idempotency |
| Legacy migration silently changes meaning | false confidence | explicit aliases/warnings, fixture comparisons, no silent coercion at close |
| Agent-generated evidence is trusted | false proof | producer typing, independent readback, review findings remain hypotheses |
| Sensitive evidence leaks into packets | security incident | minimization, redaction, references/digests, secret-pattern validator |
| Incident process delays recovery | operational harm | bounded evidence preservation, commander authority, risk-based emergency actions with receipts |
| Runtime export drifts | deployed behavior differs | repo-generated export and mirror parity tests |

## Rollback Strategy

Contract rollout is reversible until authoritative cutover.

1. Keep current Markdown packet generation operational during shadow and dual-
   emission phases.
2. Feature-gate v1 authoritative closure through repo-owned configuration, not a
   user-home switch.
3. If validator false positives or data loss appear, disable authoritative v1
   close, retain v1 artifacts as diagnostic output, and return to current local
   closure scripts.
4. Do not downgrade or rewrite already closed v1 runs. Read them with the pinned
   v1 schema and create successor reconciliation artifacts if needed.
5. Preserve provider receipts and external transitions even during rollback;
   reconcile them rather than pretending they did not occur.
6. Wave 5 run identity is the top-level `run_key` in
   `.accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json`.
   Initialization holds the exclusive fixed lock
   `.accelerate/locks/contract-v1-wave-5-run-key.lock` across inspection and
   completion. It first O_EXCL-creates/fsyncs immutable fixed intent
   `planning/evidence/contract-v1-wave-5-run-key-initialization-intent.json`
   containing the sole proposed key, preinitialization digest, canonical packet
   bytes/digest, expected final packet mode `0444`, creator/tool version, UTC
   timestamp, and creation proof. It then atomically publishes exactly those
   bytes, applies/verifies final mode, and fsyncs the fully sealed packet and
   parent before O_EXCL-creating/fsyncing fixed anchor
   `planning/evidence/contract-v1-wave-5-run-key-initialization.json`, binding
   intent digest, packet identity/path/digest/mode, and original key. Final-anchor
   publication/fsync is the last durable initialization operation; no packet
   write, chmod, or seal follows it. Intent and anchor are never overwritten.

   On locked retry, an existing intent is the only recovery source; no key or
   packet bytes are regenerated. Intent-only may resume only from the exact
   preinitialization packet, intent plus packet may resume only when packet bytes
   and final mode equal intent, and intent plus packet plus anchor returns
   read-only idempotent success only when every binding including anchor packet
   mode matches. Before final anchor, any downstream
   artifact for the proposed key blocks recovery. Missing intent, unexpected
   object/stage, mode/digest/pointer/key mismatch, or tampering fails closed.
   Every later `--load` validates all three records and packet mode under lock
   without content or metadata mutation. No later command calls a clock/UUID
   generator; keyed paths therefore avoid collision and midnight drift.
7. Treat the following three lanes as independent; one lane's evidence cannot
   satisfy another:

   - **Workspace integration.** The authority artifact is the project-local
     `.accelerate/status/contract-v1-installation.json`, validated by the
     repository-owned installation-manifest schema. Before install or upgrade
     mutates the explicit project target, create a write-once predecessor backup
     under `.accelerate/status/contract-v1-predecessor/<installation-id>/`,
     inventory every managed path/mode/digest, validate the complete backup, and
     refuse an existing destination. Only then stage the installation manifest
     and managed replacements and publish them as one atomic transaction.
     Restore only those managed
     `.accelerate/` paths from that manifest-bound backup; read back predecessor
     version, inventory, and a distinct workspace rollback receipt.
   - **Repository source and generated export.** Canonical repository source,
     including `core/contracts/v1/`, extension registry, and adapter selection,
     remains authority. Before the first generated-export replacement, create
     and validate the immutable prior-byte snapshot, then bind its identity to
     the typed prior-release manifest. Actual rollback first demotes the named
     canonical source/registry/selection slices to that accepted predecessor,
     records a source-demotion receipt, and regenerates
     `global-runtime/accelerate/`; only that regenerated export may run normal
     current-source package and mirror parity checks. Restoring historical bytes
     is a separate manifest-bound drill limited to an explicit `/tmp` target and
     validated by the historical-restore validator, never by current-source
     mirror parity and never by replacing the repository export.
   - **Optional host deployment.** The authority artifact is the backup manifest
     emitted for the explicit managed host target before deployment. Validate
     its path/mode/digest inventory and refuse backup overwrite before host
     mutation. Restore only that same explicit host package root from its own
     backup, then read back the predeployment identity and emit a distinct host
     rollback receipt/status. Host proof says nothing about workspace or
     repository-export state.
8. `scripts/verify-contract-v1-rollback-lanes.sh` is the operational aggregate
   closure proof. It anchor-validates the entry-packet key, runs workspace,
   source/regenerated-export, disposable historical, then optional host proof in
   order, validates each distinct keyed receipt/status before advancing, and
   stops on the first failure. `tests/contract-v1-rollback-lanes.sh` is a
   non-mutating, fixture-only wrapper; no args equals `--self-test`, operational
   target arguments are rejected, and only this safe behavior is auto-discovered
   by the full suite. Individual lane commands remain diagnostic only.
9. A rollback is complete only when each triggered lane has its own validated
   authority artifact, target-specific receipt/status, and readback, and when
   canonical repository source, regenerated export, adapter registry, and
   documented active contract agree.

Authoritative cutover occurs only in Wave 5 after repository-local Wave 4
enforcement, adapter/export proof, a typed prior-release backup manifest,
disposable restore drill, and forensic gates pass. Earlier closure work is
shadow/fixture-only and cannot publish authoritative runtime `closed` state.

## Acceptance Criteria

Implementation of this SDD is acceptable when all of the following are true:

1. `core/contracts/v1/accelerate-contract.json` exists and validates against its
   repository-owned schema.
2. The contract defines exactly the three base classes, four modes, six lifecycle
   phases, nine outcomes, three review levels, evidence enums, and 18 gates in
   this SDD.
3. Class values cannot appear as modes, and `wave-gated` is rejected except by
   explicit migration tooling.
4. Every activated fixture contains a complete, unique core gate partition with
   valid run/skip semantics.
5. All mode invariants have positive and negative deterministic tests.
6. Typed evidence binds producer, subject revision, claim/gate, result, time,
   digest, redaction, and freshness.
7. Invalidation graph tests prove direct and transitive staleness, selective
   reruns, cycle rejection, and review/closure invalidation.
8. Prospective validation rejects missing, stale, superseded, malformed, or
   sensitive-leaking proof.
9. Transaction failure injection demonstrates that a failed close does not
   publish a false terminal state.
10. Post-merge SHA changes, all late-worker classes, and resource cleanup have
    passing reconciliation fixtures.
11. Codex extension gates are registered under `adapters/runtime/codex/` and no
    Codex script/path is required by portable schemas.
12. Hermes adapter fixtures prove optional interoperability while tests reject
    Hermes files as authority.
13. Runtime and workflow adapters declare supported contract versions and pass
    conformance tests.
14. Behavioral evals cover activation boundaries, every core gate, all modes,
    all fail-closed outcomes, and class/mode traps without exposing expected
    answers.
15. Safety evals never accept executable outcomes when required authority,
    destination, retention, auth, or rollback scope is missing.
16. Generated `global-runtime/accelerate/` assets match canonical repository
    digests and pass export checks.
17. Existing Markdown packets are generated as projections from v1 machine
    state during cutover.
18. `AGENTS.md`, root skill, control-plane docs, machine contract, and public
    runtime inventory have no unresolved semantic drift.
19. One immutable timestamp-plus-UUID Wave 5 `run_key` is persisted through the
    locked intent -> exact fully sealed/fsynced packet -> final anchor state
    machine; crash injection after each stage recovers the same key/bytes/mode,
    final-anchor fsync is the last durable initialization operation, mismatches
    fail closed, and matching completed state is read-only/idempotent.
20. The operational fail-fast script proves workspace,
    source/regenerated-export, disposable historical, and optional host order,
    stop-on-first-failure behavior, and distinct keyed receipts/readbacks; its
    auto-discovered test wrapper is non-mutating with safe no-arg behavior.
21. No user-home path is required to build, validate, test, or explain the
    canonical contract.

## Open Decisions

The following decisions must be resolved during implementation planning, not
silently inferred:

1. Whether canonical persisted artifacts use JSON only or YAML authoring with
   canonical JSON serialization.
2. The repository-owned `$id` URI namespace for schemas.
3. Exact changed-code coverage defaults by profile; portable core defines the
   capability while waiver shape, if any, belongs only to registered
   extension/profile gates.
4. Whether wave's portable default remains 95% or requires profile declaration.
5. Which benign resource residuals may close with warnings and who can approve
   them.
6. Filesystem transaction implementation and recovery journal format for the
   local adapter.
7. External provider transition ordering and compensation per workflow adapter.
8. Signing model for receipts: digest-only, Git identity, local key, or provider
   attestation.
9. Retention and access policy for sensitive evidence references.
10. Whether event storage is JSON Lines, per-run files, or an adapter interface.
11. Stable ID generation policy for runs, evidence, graph nodes, and events.
12. Compatibility window and removal date for unversioned packet ingestion.
13. Whether extension registries can be dynamically discovered or must be a
    static repository allowlist in v1.
14. How OpenCode and Claude extension gates differ from Codex without duplicating
    portable behavior.

## Implementation Planning Boundaries

An implementation plan should split work into independently reviewable slices:

1. canonical manifest and schema package;
2. validator core and deterministic fixtures;
3. typed evidence and invalidation graph;
4. mode-specific models and wave reporter migration;
5. review, cleanup, post-merge, and late-worker reconciliation;
6. transactional closure shadow implementation;
7. runtime/workflow extension registry and Codex extraction;
8. behavioral eval runner and safety corpus;
9. dual-emission packet renderers;
10. generated global-runtime export and cutover/rollback rehearsal.

Each slice must name its authority set, migration fixture, validator stage,
failure behavior, and rollback point. Implementation must not begin by copying
the Hermes package. It must begin with repository-native schemas and tests.

## Authority References Used

Source inventory by authority role:

- **Governing:** `AGENTS.md`, root `SKILL.md`, accepted native owners under
  `core/`, and bounded owners under `adapters/`, `profiles/`, `skills/`, and
  `onboarding/`.
- **Supporting:** root `README.md`, `docs/architecture/accelerate-sdd-v1.md`,
  `docs/architecture/accelerate-control-plane.md`, and registered `references/`.
- **Decision artifacts:** accepted bounded-run artifacts under `planning/` and
  this proposed SDD/package until human acceptance.
- **Generated:** every file under `global-runtime/accelerate/`, including its
  `SKILL.md`, `README.md`, metadata, references, scripts, and evals. These may be
  inspected as downstream compatibility fixtures but are never authority.
- **Excluded as authority:** user-home catalogs and the analyzed import
  candidate `/home/marcelo-karval/.hermes/skills/productivity/accelerate`.

The candidate informed comparison only. This SDD's contract is intentionally
restated in repository-native terms and remains proposed until implemented,
validated, and promoted through this repository's governance.
