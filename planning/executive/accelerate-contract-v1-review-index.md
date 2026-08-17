# Accelerate Contract v1 Review Index

Status: `accepted-for-implementation`
Review scope: the complete 45-task Waves 0-5 contract denominator
Primary catalog: `planning/executive/accelerate-contract-v1-task-catalog.md`
Proof checklist: `planning/executive/accelerate-contract-v1-validation-checklist.md`

## Review Objective

Approve or reject a single, enforceable v1 contract for Accelerate. Approval means the SDD, master plan, six detailed wave plans, authority graph, machine schemas, adaptive matrix, typed evidence/closure engine, generated runtime projection, public documentation, tests, evals, adapters, and forensic closure rules form one coherent contract. It does not authorize implementation shortcuts, partial-wave closure, user-home mutation, or generated artifacts as source authority.

## Package Acceptance

- Acceptance ID: `ACV1-A001`
- Accepted by: repository owner/user
- Accepted on: 2026-07-21
- Evidence: explicit acceptance instruction in the active implementation session
- Scope: this review index, the SDD, master plan, six wave plans, 45-task
  catalog, validation checklist, and decisions `ACV1-D001` through `ACV1-D024`
- Effect: removes the design-decision blockers and authorizes Wave 0 entry
- Limits: does not pre-approve wave closure evidence, implementation findings,
  commits, pushes, pull requests, user-home writes, or later-wave advancement

The decision table below preserves the reviewed proposal snapshot. `ACV1-A001`
is the append-only acceptance event for every listed decision; proposal rows are
not rewritten because decision history must remain reconstructable.

## Reading Order

1. `AGENTS.md` for repository authority and source/runtime boundaries.
2. `planning/executive/accelerate-contract-v1-review-index.md` for scope, decisions, questions, and approvals.
3. `docs/architecture/accelerate-contract-v1-sdd.md` for contract intent, vocabulary, lifecycle, evidence, adapters, security, migration, and acceptance criteria.
4. `planning/executive/accelerate-contract-v1-master-plan.md` for rollout order, dirty-worktree protocol, file topology, and global exit conditions.
5. `planning/architecture/accelerate-contract-v1-wave-0-authority.md` through `accelerate-contract-v1-wave-5-runtime-integration.md` in numeric order for exact implementation slices and paths.
6. `planning/executive/accelerate-contract-v1-task-catalog.md` for the frozen 45-task implementation denominator and dependencies.
7. `planning/executive/accelerate-contract-v1-validation-checklist.md` for requirement-to-proof mapping and closure blockers.
8. `core/control-plane/truth-ownership-check.md`, `core/control-plane/authority-set-gate.md`, `core/control-plane/gate-ownership-index.md`, and `core/control-plane/skill-sync-topology.md` for current authority doctrine.
9. `SKILL.md`, `core/control-plane/branch-enforcement-matrix.md`, and `references/wave-gated-execution.md` for current classification, gate, and wave behavior.
10. `core/runtime-packets/templates.md`, `references/runtime-packet-templates.md`, and `core/review/architecture.md` for evidence, closure, and forensic baselines.
11. Implementation outputs in wave order: authority; observation-only contract;
shadow adaptive matrix; typed evidence/transactional closure; eval/package/schema
enforcement; optional runtime/provider integration, five extension manifests,
adapter conformance/Hermes fixtures, closure cutover, rollback, and export.
12. Final public catalogs, per-wave packets, rollback evidence, and forensic closure report.

Reviewers should stop at the first unresolved P0 design conflict. Later-wave approval cannot compensate for an unclear authority, vocabulary, schema, or denominator foundation.

## Wave Review Gates

| Wave | Review focus | Required decision before advancement |
| --- | --- | --- |
| Wave 0 | Entry/ownership packet, authority graph, negative tests, owner reconciliation, global denominator | One owner per node/edge; graph is acyclic; runtime/generated behavior is untouched; authority coverage is 100%. |
| Wave 1 | Behavior-neutral schema/contract, JSON Schema dependency decision, validator, fixtures, parity | Projection matches current doctrine, remains observation-only, and has no unexplained denominator drift. |
| Wave 2 | Frozen scenarios, adaptive matrix/evaluator, deterministic shadow parity | Rules are additive, explainable, deterministic, fail closed, and remain non-enforcing; root parity is 100%. |
| Wave 3 | Canonical typed evidence/freshness, full DAG, late workers, triggered post-merge/cleanup, incident correction, shadow transactional close | All 9 capabilities pass; stale proof cannot close; terminal runs use successors; no runtime consumer is cut over. |
| Wave 4 | Frozen eval corpus/mapping, runner, source-package/schema/forensic validators, authority/link/CI enforcement | All 7 capabilities and 100% eval IDs pass; three classes/four modes/nine outcomes remain distinct; generated runtime is untouched. |
| Wave 5 | Integration, readback, identity/capability selection, extensions/conformance/Hermes, bounded migration, export/drift, cutover, restore, catalogs, forensics | All 12 capabilities pass; migration is dry-run-first/no-dual-write; cutover negatives, export parity, rollback, and approvals are fresh. |

## Decision Log

Record decisions before implementation changes the affected surface. Do not overwrite rejected options; append a superseding decision.

All executable slices encode the single accepted model in this package.
`ACV1-A001` satisfies every `Resolve before` design category below. Wave entry,
task proof, independent review, and closure gates remain mandatory.

**Resolve before categories:** `Wave 0`: D001, D005, D006. `Wave 1`: D002-D004,
D018. `Wave 2`: D008. `Wave 3`: D007, D009-D014, D020, D022. `Wave 4`: D019,
D023. `Wave 5`: D015-D017, D021, D024.

| Decision ID | Topic | Options considered | Proposed decision | Rationale | Owner | Status | Date | Supersedes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ACV1-D001 | Canonical authority direction | runtime-first; dual authority; repository-source-first | Repository source is canonical; runtime and public outputs are derived. | Matches repository self-contained authority and makes drift detectable. | control-plane architect | proposed | TBD | none |
| ACV1-D002 | Class and mode model | one combined enum; independent closed enums; free-form labels | Exactly three SDD classes and modes `single|parallel|wave|incident`; nine SDD outcomes remain separate. | Prevents scenario labels from overloading persisted fields. | contract architect | proposed | TBD | none |
| ACV1-D003 | Schema strictness | permissive; strict core with extensions; strict everywhere | Strict required-domain objects with explicitly named extension points only where justified. | Fails closed while allowing reviewed evolution. | schema maintainer | proposed | TBD | none |
| ACV1-D004 | JSON Schema runtime | structural checks; pinned `jsonschema`; another reviewed conforming engine | Draft 2020-12 conformance is required; select and pin a reviewed conforming engine before validator implementation. | Capability is fixed while the library choice remains staged. | schema maintainer | proposed | TBD | none |
| ACV1-D005 | Wave denominator | prose catalog only; generated inventory only; catalog plus machine manifest | Human catalog and machine manifest must have exact parity. | Supports review readability and executable coverage. | release governance maintainer | proposed | TBD | none |
| ACV1-D006 | Coverage threshold | 95% all tasks; 100% all tasks; 100% P0 plus at least 95% total | 100% P0 and schema rules; at least 95% total with governed residuals. | Preserves the existing wave default without permitting critical omissions. | quality governance lead | proposed | TBD | none |
| ACV1-D007 | Rollback history | mutate current state; append transition; restart as new run | Append while nonterminal; rollback or reconciliation after `closed` creates a successor run. | Maintains auditability and terminality. | runtime lifecycle engineer | proposed | TBD | none |
| ACV1-D008 | Adaptive gates | static only; unrestricted adaptation; monotonic expansion | Adaptation may add; triggered core gates cannot be waived; governed waivers apply only to registered extension/profile gates. | Prevents root proof from weakening. | risk and gate architect | proposed | TBD | none |
| ACV1-D009 | Evidence model | free-form links; typed envelopes; embedded proof payloads | Use exactly the SDD envelope/types; proof stages are metadata/claims. | Enables one validated vocabulary. | evidence systems engineer | proposed | TBD | none |
| ACV1-D010 | Invalidation | direct only; transitive append-only; destructive replacement | Traverse subjects through evidence, gate/review/acceptance verdicts, validation receipts, and closure candidates. | Prevents stale downstream closure claims. | contract integrity engineer | proposed | TBD | none |
| ACV1-D011 | Merge semantics | unconditional; ignored; triggered | Post-merge runs for merged/default-branch claims; otherwise record `not-triggered`. | Avoids both missing and fabricated proof. | release lifecycle engineer | proposed | TBD | none |
| ACV1-D012 | Late workers | accept latest output; discard silently; quarantine and reconcile by epoch | Reconcile while open; a material post-close result creates a successor run. | Preserves useful work without reopening terminal state. | delegation runtime engineer | proposed | TBD | none |
| ACV1-D013 | Cleanup | unconditional; best-effort; triggered typed gate | Managed resources require cleanup; otherwise record `no-managed-resource`. | Makes hygiene provable without fake evidence. | runtime hygiene engineer | proposed | TBD | none |
| ACV1-D014 | Incident correction | ordinary defect only; separate external process; first-class contract loop | Incident loop invalidates closure and requires containment, correction, reproof, and prevention. | Ensures incidents repair workflow state as well as code. | incident governance lead | proposed | TBD | none |
| ACV1-D015 | Runtime sync | manual copies; bidirectional sync; deterministic source-to-runtime projection | Perform all exporter/manifest/sync/mirror mutations in Wave 5, outward from repository source. | Enforces authority, reproducibility, and rollout order. | runtime packaging engineer | proposed | TBD | none |
| ACV1-D016 | Migration | permanent compatibility layer; one-shot explicit migration; no migration | Dry-run-first explicit migration with lossy-conversion blockers and no indefinite dual write. | Supports existing packets without creating a second contract. | migration engineer | proposed | TBD | none |
| ACV1-D017 | Final validation | suite green only; checklist sign-off only; suite plus independent forensic reconciliation and rollback/incident proof | Require clean suite, source/runtime proof, rollback/incident correction proof, and independent forensic reconciliation. | Tests alone cannot prove denominator, authority, generated parity, or review completeness. | contract approver | proposed | TBD | none |
| ACV1-D018 | Canonical package | control-plane package; SDD package; mixed | `core/contracts/v1/` is canonical from Wave 1; detailed waves only distribute its implementation. | Eliminates competing packages. | contract architecture lead | proposed | TBD | none |
| ACV1-D019 | Class/mode vocabulary | labels as modes; free-form; explicit composition mapping | Six legacy labels are scenario/workflow/action dimensions mapped and tested against canonical class/mode/outcome. | Preserves closed persisted enums. | contract architect | proposed | TBD | none |
| ACV1-D020 | Post-close late event | reopen terminal run; successor reconciliation run; explicit reject | Every material post-close event creates a successor reconciliation run; `closed` never reopens. | Preserves terminal history. | closure architect | proposed | TBD | none |
| ACV1-D021 | Closure rollout | Wave 3 cutover; Wave 5 cutover; dual authority | Wave 3 is shadow/fixture-only; Wave 5 cuts over after Wave 4, adapter/export/rollback, and forensic preflight. | Prevents premature cutover. | closure architect | proposed | TBD | none |
| ACV1-D022 | Closure commit boundary | local first; provider first; prepared logical commit | Internal `closing` remains nonterminal; provider readback and local terminal artifacts publish logically together. | Prevents split-brain closed state. | closure architect | proposed | TBD | none |
| ACV1-D023 | Forensic tool ownership | reviewer creates; Wave 4 creates; manual only | ACV1-W4-007 creates/tests `--catalog`, `--checklist`, and `--final`; the reviewer only executes them. | Preserves independent review. | quality governance lead | proposed | TBD | none |
| ACV1-D024 | Export target and rollback | self-anchored packet plus mutating test; crash-recoverable immutable intent/anchor plus operational verifier | Under the fixed exclusive lock, O_EXCL-create/fsync fixed intent containing the sole timestamp-plus-UUID key and exact packet bytes/digest/expected final mode; publish exact bytes, apply/verify final mode, and fsync the fully sealed packet and parent; then O_EXCL-create/fsync final anchor binding packet mode as the last durable initialization operation. No packet write/chmod/seal follows anchor creation. Locked recovery never generates a new key, resumes only matching incomplete stages, returns read-only idempotent success for complete mode-matching state, and fails closed on mismatch, tamper, unexpected stage, or downstream keyed artifacts before anchor. Every load validates intent, packet bytes/mode, and anchor without mutation. Operational rollback runs only through `scripts/verify-contract-v1-rollback-lanes.sh`; the auto-discovered test wrapper is non-mutating and safe with no args. | Prevents crash-time identity rebinding, incompletely sealed anchored packets, post-anchor packet mutation, packet self-rebinding, immutable-record overwrite, pre-anchor downstream work, auto-discovered mutation, partial lane continuation, historical substitution, and cross-lane claims. | release tooling owner | proposed | TBD | none |

## Review Questions

### Authority And Scope

1. Does every governed field and artifact have exactly one canonical owner?
2. Are any generated runtime, public documentation, user-home, or external surfaces accidentally treated as authority?
3. Is the 45-task denominator complete for every recommendation across Waves 0-5 and every explicit cross-cutting request?
4. Are any task dependencies cyclic, forward-wave, or missing?
5. Are exact file surfaces appropriately bounded, with generated files clearly distinguished from sources?

### Contract And Vocabulary

1. Are `class` and `mode` independent, and is the mapping from the Wave 4 six eval labels to the canonical persisted model explicit?
2. Are lifecycle, gate, evidence, invalidation, closure, and residual values closed and unambiguous?
3. Do schemas fail closed without blocking legitimate, explicitly designed extension points, and are validator capability claims honest?
4. Is the JSON Schema engine/dependency decision reproducible locally and in CI, with no silent fallback?
5. Does migration avoid permanent aliases and dual authority?

### Runtime Behavior

1. Does rollback/correction preserve history and invalidate all dependent proof?
2. Does adaptation preserve every triggered core gate, with governed waivers limited to registered extension/profile gates?
3. Can any narrative-only, stale, mutable, invalidated, or digest-mismatched evidence satisfy closure?
4. Do closure templates expose all blockers rather than compress them into a recommendation?
5. Does post-merge evidence bind the exact merge revision without equating pre-merge proof to landed truth?
6. Are late-worker identities robust to cancellation, merge, rollback, authority changes, and post-close successor-run creation?
7. Is cleanup safe for pre-existing resources and concurrent workers?
8. Does incident correction repair contract state, evidence state, and recurrence risk?

### Projection And Publication

1. Is every generated v1 runtime file owned by the export manifest and reproducible from repository sources?
2. Can sync detect missing, changed, and orphan files in check-only mode?
3. Are generation, package validation, and temporary-target proof deterministic and user-home independent?
4. Do public catalogs exactly match schema names, enums, and error semantics?
5. Are documentation examples executable and free of private evidence or host-specific assumptions?
6. Do all five extension manifests and participating adapter version declarations
   remain repository-owned, and do Hermes fixtures reject external authority?
7. Does workspace restore use its manifest-bound write-once backup, repository
   rollback demote canonical source before regeneration/parity, historical-byte
   validation stay under `/tmp`, and host restore use its own target-bound backup,
   with distinct receipts/readback throughout?
8. Does the fixed lock protect intent -> exact fully sealed/fsynced packet ->
   final anchor; does intent record expected mode plus bytes/digest; is anchor
   fsync the last durable initialization operation with no later packet mutation;
   do all three crash points recover only intent identity/bytes/mode; does
   complete mode-matching state return read-only idempotent success; and do
   mismatch, tamper, unexpected stage, or downstream keyed artifacts before
   anchor fail closed on initialize/load?
9. Does only `scripts/verify-contract-v1-rollback-lanes.sh` accept operational
   targets while the auto-discovered test wrapper is non-mutating and identical
   with no args or `--self-test`?

### Proof And Closure

1. Does every authority node/edge, task, wave capability, schema rule, scenario/eval ID, provider negative path, and public catalog have executable proof?
2. Do adversarial evals cover missing dependencies, invalid transitions, stale evidence, races, and cleanup failures?
3. Is the coverage denominator frozen and protected from silent edits?
4. Does incident correction prove detection/containment, invalidation, corrected-state proof, cleanup, and immutable history?
5. Is forensic review independent, fresh, and comparative rather than a summary of earlier claims?
6. Would any change after approval automatically invalidate the affected closure evidence?

## Required Review Outputs

Each reviewer must provide:

- scope, authority sources, and files reviewed;
- decisions accepted, rejected, or requiring revision;
- findings with severity, evidence, owner, and disposition;
- checklist rows sampled or executed;
- residual risks and required follow-ups;
- recommendation: `approve`, `approve-with-conditions`, or `reject`;
- conflict-of-interest or independence statement.

`approve-with-conditions` cannot waive an absolute closure blocker or an incomplete P0 task.

## Approval Fields

### Architecture Approval

- **Reviewer:** TBD
- **Role:** control-plane architect not acting as sole implementer
- **Scope:** authority graph, vocabulary, lifecycle, dependency graph
- **Decision:** `pending`
- **Conditions:** TBD
- **Evidence/findings locator:** TBD
- **Date (UTC):** TBD
- **Signature/identity:** TBD

### Schema And Validation Approval

- **Reviewer:** TBD
- **Role:** schema/validation maintainer
- **Scope:** JSON Schemas, dependency enforcement, validator behavior, fixtures
- **Decision:** `pending`
- **Conditions:** TBD
- **Evidence/findings locator:** TBD
- **Date (UTC):** TBD
- **Signature/identity:** TBD

### Runtime And Lifecycle Approval

- **Reviewer:** TBD
- **Role:** runtime lifecycle reviewer
- **Scope:** adaptive gates, typed evidence, invalidation, post-merge, late workers, cleanup, incident correction, transactional closure
- **Decision:** `pending`
- **Conditions:** TBD
- **Evidence/findings locator:** TBD
- **Date (UTC):** TBD
- **Signature/identity:** TBD

### Source/Runtime And Release Approval

- **Reviewer:** TBD
- **Role:** packaging/release reviewer
- **Scope:** optional integration, provider readback, identity/capability selection,
  extensions, adapter versions/conformance, Hermes interoperability, bounded
  migration/no-dual-write, closure cutover, deterministic export/drift, and
  rollback readiness
- **Decision:** `pending`
- **Conditions:** TBD
- **Evidence/findings locator:** TBD
- **Date (UTC):** TBD
- **Signature/identity:** TBD

### Documentation And Public Contract Approval

- **Reviewer:** TBD
- **Role:** documentation/API contract reviewer
- **Scope:** public overview, vocabulary, evidence/gate catalogs, examples, migration
- **Decision:** `pending`
- **Conditions:** TBD
- **Evidence/findings locator:** TBD
- **Date (UTC):** TBD
- **Signature/identity:** TBD

### Quality And Eval Approval

- **Reviewer:** TBD
- **Role:** independent quality governance reviewer
- **Scope:** frozen eval corpus, package/schema validators, authority/link enforcement, denominator coverage, full suite
- **Decision:** `pending`
- **Conditions:** TBD
- **Evidence/findings locator:** TBD
- **Date (UTC):** TBD
- **Signature/identity:** TBD

### Incident Correction Approval

- **Incident commander:** TBD
- **Independent observer:** TBD
- **Scope:** detection/containment, manual risk reopen, invalidation, corrected-state reproof, cleanup, immutable history
- **Decision:** `pending`
- **Conditions:** TBD
- **Incident evidence locator:** TBD
- **Date (UTC):** TBD
- **Signatures/identities:** TBD

### Final Forensic Approval

- **Forensic reviewer:** TBD
- **Contract approver:** TBD
- **Independence statement:** TBD
- **Catalog coverage:** `pending`
- **Checklist coverage:** `pending`
- **Open P0/P1 findings:** TBD
- **Residual-risk decision:** TBD
- **Final decision:** `pending`
- **Closure evidence locator:** TBD
- **Date (UTC):** TBD
- **Signatures/identities:** TBD

## Approval Invalidation

Approval becomes invalid when any of these changes after its proof timestamp:

- authority graph or canonical vocabulary;
- schema, validation dependency, or validator implementation;
- task or requirement denominator;
- lifecycle, gate, evidence, invalidation, closure, post-merge, worker, cleanup, or incident rules;
- source/runtime projection or generated runtime content;
- extension registry/manifests, adapter supported-version declarations,
  conformance/Hermes fixtures, or closure-cutover consumer tests;
- public catalogs or validated examples;
- eval fixtures, coverage calculation, generated export, provider integration, or incident correction evidence;
- an incident or defect affects an approved assumption.

The earliest affected wave reopens. Dependent approvals and proof must be rerun; a textual affirmation is not reproof.
