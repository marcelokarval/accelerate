# Accelerate Contract V1 Master Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver the SDD's accepted Accelerate Contract V1 in six gated
waves: authority, canonical package foundation, adaptive shadow gates, typed
evidence and shadow closure, repository-local enforcement, then authoritative
runtime cutover/export.

**Architecture:** Repository source remains sole authoring authority. The
canonical package is `core/contracts/v1/`; all runtime files are generated
downstream. Wave 3 proves transactional closure in shadow fixtures, Wave 4
enforces only repository source/evals, and Wave 5 alone performs runtime wiring,
provider reconciliation, generated export, rollback drill, and authoritative
cutover.

**Tech Stack:** Markdown doctrine, JSON contracts, Python 3 standard-library validators/evaluators, Bash contract tests, existing `tests/all.sh` suite.

---

## Status And Control Packet

- Plan ID: `ACV1-MASTER`
- Owner: Accelerate root/orchestrator
- Date: 2026-07-20
- Classification: orchestrated non-trivial governance/runtime work
- Persisted class/mode: `orchestrated-nontrivial` / `wave`
- Accepted direction (`ACV1-A001`): authority graph first; canonical machine package without behavior change; adaptive gate matrix next
- Local workspace: existing repo-local `.accelerate/` state must be read at implementation entry
- Workflow backend: repo-local planning and `.accelerate/` artifacts unless an implemented adapter proves otherwise
- Commit posture: no commit is authorized by this planning task; implementation requires bounded commits later
- Single-threaded exception: none assumed; executor and skeptical reviewer should be separated per wave

## Exact Outcome

Contract V1 is complete only when:

1. Authority precedence and generation direction are explicit, acyclic, and tested.
2. One machine-readable V1 package encodes exactly three classes, four modes,
   nine outcomes, 18 core gates, the SDD aggregates/schemas, proof order, and
   authority roles without changing routing behavior in Wave 1.
3. One adaptive gate matrix deterministically maps declared context to required gates, artifacts, and proof in shadow mode.
4. Typed SDD evidence, full-DAG invalidation, selective reruns, incident correction, and transactional closure are proven in shadow/fixture mode.
5. Structured evals, canonical source-package/schema validation, authority/link checks, forensic tooling, and CI enforce repository-local denominators without generated-runtime mutation.
6. Optional local integration, backend-neutral readback, identity/capability
   selection, five source-owned extension manifests, supported-version adapter
   conformance and Hermes fixtures, public catalogs, reproducible export, typed
   restore, red-first closure cutover, and forensic review complete without
   direct user-home mutation.

## Scope

- Clarify canonical authority, supporting authority, decision artifacts, backend facts, and generated exports.
- Add a versioned machine contract and schema/semantic validation.
- Add an adaptive gate matrix with deterministic, explainable selection.
- Add shadow comparison before evidence/closure and enforcement work.
- Add typed evidence, incident correction, shadow transactional closure, and deterministic eval/source-package/schema enforcement.
- Integrate the accepted contract through an optional project-local runtime adapter in the final wave.
- Generate and verify the portable runtime export from repo-local accepted state.
- Add focused, negative, parity, export, and full-suite evidence.

## Non-Scope

- No application/product feature behavior.
- No new remote workflow adapter and no claim that a planned adapter is implemented.
- No direct edits under `~/.claude`, `~/.codex`, `~/.agents`, or any other user-home runtime catalog.
- No use of `bash scripts/sync-skills-to-global.sh` or `bash scripts/check-global-skill-mirror.sh` against their default user-home targets.
- No deletion of existing prose doctrine before Contract V1 is proven and accepted.
- No enforcement in Waves 0-2.
- Contract acceptance does not itself authorize a commit, push, PR, or worktree cleanup; each requires separate authorization.

## Authority And Generation Invariants

1. `AGENTS.md`, root `SKILL.md`, accepted `core/`, and other classes named by `core/control-plane/authority-set-gate.md` are repo-local authority.
2. `references/` is supporting depth unless explicitly promoted through repo-local governance.
3. `planning/` artifacts decide only their accepted bounded run.
4. `global-runtime/accelerate/` is a generated deployment/export surface, never the authoring source of truth.
5. A generated file is changed only by its repo-local generator after source changes pass focused validation.
6. Host proof targets must be explicit temporary paths such as `/tmp/accelerate-contract-v1-host`; never rely on `$HOME` defaults.
7. If generated output differs from canonical repo source, canonical source wins and rollout blocks.

## Dirty Worktree Protocol

The planning baseline observed existing modifications to `global-runtime/accelerate/SKILL.md`, `references/`, and runtime sync scripts, plus untracked generated-runtime support files and `references/wave-gated-execution.md`. Implementers must not assume those changes belong to Contract V1.

- [ ] Record `git status --short --branch` and `git diff --name-only` before every wave.
- [ ] Save the baseline path list in the wave packet; do not copy file contents into committed planning evidence if sensitive.
- [ ] Do not reset, checkout, stash, overwrite, or clean pre-existing work.
- [ ] Prefer a dedicated worktree from a clean commit when available; otherwise coordinate ownership of every overlapping file before edit.
- [ ] Stop on direct overlap with an unowned concurrent change; resume only after ownership or integration order is explicit.
- [ ] Stage only the files listed for the active task and inspect `git diff --cached --name-only` before each later commit.
- [ ] Keep each commit bounded to one task ID or one inseparable test/implementation pair.

## Plan Map And Dependencies

| Wave | Plan | Outcome | Depends on |
| --- | --- | --- | --- |
| 0 | [Wave 0: Authority](../architecture/accelerate-contract-v1-wave-0-authority.md) | Acyclic authority and generation graph | accepted master plan |
| 1 | [Wave 1: Contract Foundation](../architecture/accelerate-contract-v1-wave-1-contract-foundation.md) | Valid behavior-neutral machine contract | Wave 0 exit |
| 2 | [Wave 2: Adaptive Gates](../architecture/accelerate-contract-v1-wave-2-adaptive-gates.md) | Deterministic shadow gate selection | Wave 1 exit |
| 3 | [Wave 3: Evidence And Closure](../architecture/accelerate-contract-v1-wave-3-evidence-closure.md) | Typed, fresh, full-DAG shadow transactional closure | Wave 2 exit |
| 4 | [Wave 4: Evals And Enforcement](../architecture/accelerate-contract-v1-wave-4-evals-enforcement.md) | Repository-local eval, schema, source-package, authority, link, forensic, and CI enforcement | Wave 3 exit |
| 5 | [Wave 5: Runtime Integration And Export](../architecture/accelerate-contract-v1-wave-5-runtime-integration.md) | Runtime integration, authoritative closure cutover, backend-neutral readback, deterministic export/restore, and forensic closure | Waves 3 and 4 exit |

No wave may begin from calendar pressure alone. Its predecessor must have an accepted Wave Closure Packet and all named exit evidence.

## Planning Authority And Slicing

- The [Contract V1 SDD](../../docs/architecture/accelerate-contract-v1-sdd.md) owns broader contract intent.
- The [task catalog](accelerate-contract-v1-task-catalog.md) owns the stable 45-task denominator and canonical IDs.
- The six detailed wave plans linked above own exact implementation slicing and file paths.
- A conflict among these layers blocks closure until a recorded decision resolves it; the master plan does not replace detailed paths with stale inline implementation slices.
- Package acceptance `ACV1-A001` accepts decisions `ACV1-D001` through
  `ACV1-D024` and clears every design-level `Resolve before` blocker. Executable
  slices encode that accepted model, never a menu of alternatives. Wave entry,
  task proof, independent review, and closure gates remain mandatory.

## Global Entry Gate

- [ ] Confirm this master plan and all six detailed wave plans exist and links pass.
- [ ] Read `AGENTS.md`, root `SKILL.md`, `core/control-plane/authority-set-gate.md`, `core/control-plane/branch-enforcement-matrix.md`, and `core/control-plane/gate-ownership-index.md`.
- [ ] Read `.accelerate/review/handoff-summary.md` when materialized; otherwise use the canonical repo-local reentry helper.
- [ ] Bootstrap or attach the governing issue before mutation, unless the user explicitly grants a narrow no-issue exception.
- [ ] Create a Wave Packet with authority set, baseline dirty paths, owner assignments, denominator, proof commands, rollback trigger, and stop conditions.
- [ ] Run baseline focused tests and `bash tests/all.sh`; record failures as pre-existing or block entry if attribution is unclear.
- [ ] Confirm no command in the active wave writes to a user-home path.

Expected entry evidence: baseline status, issue/planning linkage, local workspace decision, passing baseline or classified pre-existing failures, and an accepted wave denominator.

## Wave 0: Authority Graph

Detailed plan: [accelerate-contract-v1-wave-0-authority.md](../architecture/accelerate-contract-v1-wave-0-authority.md).

Outcome: every V1 source and output has one class, precedence edge, owner, mutation rule, and drift response. No machine contract work starts until the graph is acyclic and generated runtime is explicitly downstream.

Exit gate:

- `bash tests/authority-graph-v1.sh` passes.
- `bash tests/authority-set-gate.sh` passes.
- `bash tests/doctrine-integrity.sh` passes.
- `bash tests/markdown-link-integrity.sh` passes.
- The accepted graph contains no edge from user home or `global-runtime/` back into canonical authority.
- Wave 0 bounded commit exists later, with no pre-existing dirty paths accidentally staged.

## Wave 1: Contract Foundation

Detailed plan: [accelerate-contract-v1-wave-1-contract-foundation.md](../architecture/accelerate-contract-v1-wave-1-contract-foundation.md).

Outcome: schema-valid and semantically valid JSON describes current doctrine. Runtime behavior and gate selection remain prose-driven; the validator only reports drift.

Canonical surface: `core/contracts/v1/`, beginning as the observation-only
projection and expanded across Waves 2-4. No competing
`core/control-plane/accelerate-contract-v1.*` package is created.

Exit gate:

- Positive and negative contract fixtures pass.
- Contract identifiers resolve to canonical package definitions and repo-local owners.
- A doctrine-to-contract parity report has zero unexplained differences.
- Existing classification and doctrine suites remain unchanged in result.
- No root/runtime routing code reads the contract to decide behavior.

## Wave 2: Adaptive Gate Matrix

Detailed plan: [accelerate-contract-v1-wave-2-adaptive-gates.md](../architecture/accelerate-contract-v1-wave-2-adaptive-gates.md).

Outcome: a deterministic matrix selects additive gate requirements from declared context and prints reasons, conflicts, and unresolved inputs. It runs in shadow mode and cannot relax root invariants.

Exit gate:

- Every frozen scenario returns the expected branch, gates, artifacts, proof, and explanation.
- Unknown, contradictory, and high-risk inputs fail closed.
- Shadow comparison reaches 100% on mandatory root invariants and at least 95% overall scenario parity; all residuals are explicitly classified.
- No enforcement call site has changed.

## Wave 3: Evidence And Transactional Closure

Detailed plan: [accelerate-contract-v1-wave-3-evidence-closure.md](../architecture/accelerate-contract-v1-wave-3-evidence-closure.md). Catalog tasks: `ACV1-W3-001` through `ACV1-W3-009`.

Outcome: canonical typed evidence, full derivation-DAG invalidation, selective
reruns, successor-run late-event reconciliation, triggered post-merge/cleanup,
incident correction, and compare-and-swap closure in shadow fixtures. Exit
requires 9/9 capability coverage and independent reconstructability review; no
local-workspace consumer is cut over.

## Wave 4: Evals, Schemas, Packages, And CI Enforcement

Detailed plan: [accelerate-contract-v1-wave-4-evals-enforcement.md](../architecture/accelerate-contract-v1-wave-4-evals-enforcement.md). Catalog tasks: `ACV1-W4-001` through `ACV1-W4-008`.

Outcome: frozen eval/capability denominators, tested legacy-label mapping to the
three classes/four modes/nine outcomes, source-package and semantic schema
validation, forensic CLI creation, authority/link enforcement, and CI
composition. Exit requires 7/7 capability coverage, 100% frozen eval-case
coverage, no generated-runtime mutation, and independent correction/reproof.

## Wave 5: Optional Runtime Integration, Export, And Final Closure

Detailed plan: [accelerate-contract-v1-wave-5-runtime-integration.md](../architecture/accelerate-contract-v1-wave-5-runtime-integration.md). Catalog tasks: `ACV1-W5-001` through `ACV1-W5-009`.

Outcome: optional integration, backend-neutral readback, identity/capability
selection, five extension manifests, supported-version adapter conformance,
Hermes interoperability fixtures, dry-run-first bounded legacy migration,
one immutable entry-packet `run_key`, deterministic export/drift, typed restore,
an owned fail-fast rollback aggregate, red-first authoritative closure cutover,
public catalogs, and final forensics.
Exit requires 12/12 capability coverage, all prior waves accepted, and a
transactional final closure with no unresolved blocker.

## Rollout Strategy

1. Documentation-only authority repair.
2. Contract validation in observation-only CI/local proof.
3. Adaptive evaluator in shadow mode against frozen scenarios.
4. Typed evidence, incident correction, and transactional closure in shadow fixtures.
5. Repository-local structured eval, schema, source-package, forensic, authority, link, and CI enforcement.
6. Optional runtime integration, backend-neutral readback, identity/capability
   selection, source-owned extensions, adapter conformance/Hermes fixtures,
   exactly-once timestamp-plus-UUID run identity, deterministic export, typed
   aggregate rollback drill, red-first authoritative closure cutover, public
   catalogs, and final forensics.
7. Public V1 catalogs and promotion after full forensic closure.

## Rollback Strategy

- Wave 0: revert task-scoped graph/test, owner-pointer, and denominator slices independently; no generated or host state exists.
- Wave 1: stop invoking validation and revert only affected task-scoped slices; prose behavior remains authoritative.
- Wave 2: disable shadow evaluation and revert task-scoped matrix/evaluator slices; no routing behavior changes before accepted Wave 5 cutover.
- Wave 3: disable shadow runners and retain schemas, ledgers, journals, and receipts; no authoritative consumer wiring exists yet.
- Wave 4: revert defective repository-local enforcement wiring, preserve denominators/reports, and keep runtime/export cutover disabled.
- Wave 5: use three non-substitutable rollback lanes. For project-local
  `.accelerate/`, create and validate a write-once predecessor backup before
  mutation, bind it to the installation manifest, restore only managed paths,
  and emit workspace readback/receipt. For repository rollback, first demote
  canonical contract source, extension registry, and adapter selection to the
  accepted predecessor, record the source-demotion receipt, regenerate
  `global-runtime/accelerate/`, and only then run normal source/export parity.
  The immutable pre-replacement byte snapshot is limited to manifest-bound
  historical validation under `/tmp`; it never replaces canonical source or
  satisfies current-source mirror parity. Restore optional host deployment only
  from that explicit host target's validated backup manifest and emit a separate
  host readback/receipt. Under the fixed exclusive lock, persist/fsync immutable
  O_EXCL intent with the sole proposed `run_key`, exact canonical packet
  bytes/digest, and expected final mode. Atomically publish those bytes at
  `.accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json`, apply
  final mode, and fsync the fully sealed packet and parent before persisting and
  fsyncing the immutable O_EXCL final anchor as the last durable initialization
  operation. No packet write/chmod/seal follows anchor creation. Locked retry
  reuses only intent identity/bytes/mode; matching intent-only or intent+packet
  states resume, complete matching state is read-only idempotent success, and
  mismatch, tamper, unexpected stage, or downstream keyed artifacts before
  anchor fail closed. Every later load compares intent, packet bytes/mode, and
  anchor without mutation; no command recomputes time/UUID or overwrites either
  immutable record. Use the W5-006-owned
  `scripts/verify-contract-v1-rollback-lanes.sh` operational verifier to execute
  workspace, source/export, history, then optional host fail-fast. The
  auto-discovered `tests/contract-v1-rollback-lanes.sh` is fixture-only and safe
  with no args; individual lane commands are diagnostic only. Preserve all keyed
  receipts and open a successor run.

Rollback must never use `git reset --hard`, broad checkout, cleaning, or deletion of unowned dirty work.

## Cross-Wave Evidence Ledger

Each Wave Closure Packet must include:

- wave/task IDs and accepted denominator
- baseline and closing `git status --short --branch`
- exact files changed, generated, and deliberately untouched
- focused test commands with exit status and expected marker
- full-suite status or explicit reason it is not yet an exit requirement
- parity percentage and classified residuals
- generated-export disposition
- user-home mutation check
- reviewer findings and correction/reproof links
- bounded commit hash after implementation, not during this planning task
- rollback readiness and next-wave decision

## Risk Register

| Risk | Mitigation | Blocker condition |
| --- | --- | --- |
| Contract becomes a second authority | Declare prose owners and machine projection relationship; validate identifiers against owner files | machine data cannot trace to one repo-local owner |
| Existing dirty changes are overwritten or accidentally committed | baseline capture, ownership check, isolated worktree, staged-scope inspection | overlapping file has no agreed owner/integration order |
| Machine contract silently changes behavior | Wave 1 observation-only; parity fixtures; no consumer call site | classification/gate result changes in Wave 1 |
| Adaptive rules weaken root law | additive rules and immutable root invariants; fail closed | any scenario removes a root-required gate |
| Matrix precedence is ambiguous | explicit priority, conflict detection, reason trace | two matching rules conflict without deterministic resolution |
| Generated runtime becomes authority | one-way generation and provenance tests | output is hand-edited or read as canonical source |
| User-home runtime is modified during proof | explicit `/tmp` targets and path rejection | command resolves to `$HOME` or an unspecified target |
| Full suite hides focused semantic gaps | negative fixtures and scenario corpus before aggregate suite | only `tests/all.sh` evidence exists |
| Six waves become one broad commit | task IDs and bounded commit requirement | staged files cross unrelated task boundaries |

## Master Definition Of Done

- All six wave exit gates are accepted in order.
- All waves match their detailed plans and the 45 canonical catalog task IDs.
- Contract V1 has one canonical repo-local owner and a validated generated-runtime projection.
- Adaptive selection is deterministic, explainable, fail-closed, and root-law preserving.
- Typed closure and eval/package enforcement have correction, rollback, and independent review proof.
- Optional runtime integration, public catalogs, and deterministic export have final forensic proof.
- Wave 5 has one immutable entry-packet `run_key` produced by the locked O_EXCL
  intent -> exact fully sealed/fsynced packet -> O_EXCL final anchor protocol;
  intent and anchor bind packet mode, anchor fsync is the last durable
  initialization operation, crash recovery reuses only intent identity/bytes/mode,
  every run-scoped artifact validates all three records, and complete matching
  state is read-only/idempotent;
  the operational rollback verifier proves ordered stop-on-first-failure behavior,
  while its auto-discovered wrapper remains non-mutating.
- All five extension manifests, supported-version declarations, shared adapter
  conformance, optional Hermes fixtures, D016 dry-run/lossy/dual-write migration
  fixtures, and consumer-boundary cutover negatives have fresh source-owned
  proof.
- No direct user-home edit or authority dependency occurred.
- Existing dirty work is preserved or integrated only with explicit ownership.
- Bounded implementation commits exist and are reviewed; this planning-only change remains uncommitted unless separately authorized.
- `bash tests/all.sh`, `bash tests/markdown-link-integrity.sh`, and `git diff --check` pass at final closure.
