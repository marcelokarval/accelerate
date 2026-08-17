# Accelerate Contract V1 Wave 3 Evidence Closure Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make closure a typed, fresh, invalidation-aware transaction that remains correct across selective reruns, merges, late workers, and cleanup.

**Architecture:** Canonical schemas under `core/contracts/v1/schemas/` define
evidence and closure state. Importable code under `scripts/accelerate_contract/`
validates the full derivation DAG and simulates compare-and-swap closure against
fixtures. Wave 3 is shadow/fixture-only: local-workspace consumers and
authoritative cutover remain untouched until Wave 5. Proof stages are claims or
metadata on the SDD evidence envelope, never new evidence kinds.

**Tech Stack:** Python 3 standard library, JSON/JSONL, JSON Schema documents, Bash contract tests, existing `.accelerate/` local-workspace scripts.

---

## Wave Packet

- Wave ID: `ACV1-W3`
- Class/mode: `orchestrated-nontrivial / wave`
- Dependency: `ACV1-W2-006` is accepted and predecessor contract/bootstrap work is merged and green.
- Frozen denominator: the nine acceptance capabilities `W3-C01` through `W3-C09` listed below.
- Coverage threshold: `9/9` capabilities and every required validator passing; triggered core gates cannot be waived.
- Non-goals: remote provider writes, an always-on daemon, a database, user-home catalog synchronization, or changing Linear into core authority.
- Stop conditions: an untyped record can satisfy a gate; stale evidence can close; invalidation loses history; a late worker can overwrite newer state; cleanup deletes retained proof; post-merge proof is inferred from pre-merge proof.

## Authority And Invariants

- The repository is governing authority. `.accelerate/` is optional project-local runtime state, not doctrine.
- `core/contracts/v1/schemas/*.json` owns persisted contract shape. Python code enforces semantics that JSON Schema cannot express.
- Evidence is append-only by identity. Supersession and invalidation add ledger events; they do not rewrite historical claims.
- Freshness binds the canonical envelope's `subject.revision`, `command`,
  `working_directory`, producer identity, artifact references, and
  `content_digest` to declared dependency subjects.
- Closure is a compare-and-swap transaction over a calculated candidate digest. Validation and write must use the same locked snapshot.
- Merge changes the source revision. Required post-merge proof must be captured against the merge commit and cannot reuse a pre-merge result.
- Worker results are candidates until root reconciliation accepts them. A result based on an obsolete assignment revision is rejected or selectively re-proved.
- Cleanup proof reports retained/deleted paths and scans for governed junk; it must not delete evidence required by the closure record.

## Target Files

| Action | Exact file | Responsibility |
| --- | --- | --- |
| Create | `core/contracts/v1/schemas/evidence.schema.json` | Canonical SDD evidence envelope and closed type vocabulary. |
| Create | `core/contracts/v1/schemas/invalidation-event.schema.json` | Append-only invalidation/supersession event contract. |
| Create | `core/contracts/v1/schemas/dependency-graph.schema.json` | Full subject-to-closure derivation DAG. |
| Create | `core/contracts/v1/schemas/resource.schema.json` | Managed-resource and cleanup decision contract. |
| Create | `core/contracts/v1/schemas/review.schema.json` | Review, correction, reproof, and review-of-review contract. |
| Create | `core/contracts/v1/schemas/validation-receipt.schema.json` | Candidate-bound prospective validation receipt. |
| Create | `core/contracts/v1/schemas/closure-receipt.schema.json` | Prepared `closing`, provider readback, and terminal logical-commit receipt. |
| Create | `core/control-plane/contract-lifecycle.md` | Lifecycle and terminal successor-run semantics. |
| Create | `core/closure/transactional-closure.md` | Normative freshness, reconciliation, and shadow transaction rules. |
| Create | `core/runtime-packets/contract-v1-templates.md` | Human projections of canonical machine state. |
| Create | `scripts/accelerate_contract/evidence.py` | Validation, digest, freshness, invalidation, rerun, reconciliation, and closure library. |
| Create | `scripts/accelerate_contract/closure.py` | Shadow closure transaction, provider readback, and logical-commit engine. |
| Create | `tests/fixtures/evidence-closure/valid/` | Minimal valid registries, ledger, candidate, worker result, and cleanup manifest. |
| Create | `tests/fixtures/evidence-closure/invalid/` | Stale, malformed, invalidated, late-worker, and partial-write fixtures. |
| Create | `tests/evidence-closure-contract.sh` | Focused black-box contract and transaction tests. |
| Modify | `tests/all.sh` | No code change expected: auto-discovery already runs new top-level shell tests. Verify this assumption. |

## Contract Vocabulary

Evidence types are exactly the SDD vocabulary: `command`, `file`, `api`,
`runtime`, `test`, `coverage`, `receipt`, `artifact`, `review`, `approval`,
`cleanup`, and `readback`. `implementation`, QA/proof stages, post-merge,
late-worker reconciliation, and forensic closure are claim IDs or
`metadata.proof_stage` values.

Every evidence record must include:

```json
{
  "evidence_id": "ev-post-merge-001",
  "contract_version": 1,
  "type": "test",
  "subject": {"kind": "git-tree", "id": "repository", "revision": "<commit>"},
  "claim_ids": ["claim.post-merge"],
  "gate_ids": ["workflow.post-merge"],
  "producer": {"kind": "runtime-adapter", "id": "python", "version": "<version>"},
  "command": ["bash", "tests/all.sh"],
  "working_directory": ".",
  "started_at": "<RFC3339 UTC>",
  "finished_at": "<RFC3339 UTC>",
  "exit_code": 0,
  "result": "pass",
  "artifact_refs": ["artifact://proof/post-merge.json"],
  "content_digest": "sha256:<64-hex>",
  "redaction": "none",
  "freshness": "fresh",
  "supersedes": [],
  "metadata": {"proof_stage": "post-merge"}
}
```

The invalidation ledger is append-only. Its DAG is complete and acyclic:
`subject -> evidence -> gate-verdict -> review-verdict -> acceptance-verdict -> validation-receipt -> closure-candidate`.
Every mutation traverses all descendants, marks them stale, and emits the
narrowest proof-ordered rerun plan. Allowed reason codes include
`source-revision-changed`, `input-changed`, `command-changed`,
`dependency-changed`, `artifact-missing`, `worker-obsolete`, and
`manual-risk-correction`.

### ACV1-W3-001: Freeze The Nine-Capability Evidence/Closure Denominator

**Depends on:** `ACV1-W2-006`

- [ ] Confirm Waves 1 and 2 are merged and record their merge commit in the Wave Packet.
- [ ] Run `bash tests/all.sh`.

Expected: exit `0` and final line `all tests passed` before Wave 3 mutation.

- [ ] Freeze `W3-C01` through `W3-C09` in `.tmp/acv1-wave-3-denominator.json` with target count `9` and a SHA-256 digest, including incident correction as its own capability.
- [ ] Confirm no target file is concurrently owned by another active lane; if it is, stop instead of overwriting work.

## Chunk 1: Typed Evidence And Freshness

### ACV1-W3-002: Define Typed Evidence, Invalidation, And Closure Schemas

**Depends on:** `ACV1-W3-001`

**Files:**
- Create: `core/contracts/v1/schemas/evidence.schema.json`
- Create: `core/contracts/v1/schemas/invalidation-event.schema.json`
- Create: `core/contracts/v1/schemas/dependency-graph.schema.json`
- Create: `core/contracts/v1/schemas/resource.schema.json`
- Create: `core/contracts/v1/schemas/review.schema.json`
- Create: `core/contracts/v1/schemas/validation-receipt.schema.json`
- Create: `core/contracts/v1/schemas/closure-receipt.schema.json`
- Create: `core/control-plane/contract-lifecycle.md`
- Create: `core/closure/transactional-closure.md`
- Create: `core/runtime-packets/contract-v1-templates.md`
- Create: `tests/fixtures/evidence-closure/valid/evidence.json`
- Create: `tests/fixtures/evidence-closure/invalid/untyped-evidence.json`
- Create: `tests/evidence-closure-contract.sh`

- [ ] **Red:** Add focused tests that require the complete SDD envelope, reject
unknown evidence types/freshness values and extra top-level fields such as
`command_digest`, require `working_directory`, reject local absolute artifact paths,
exercise every schema owned by this task, and reject a closure candidate without
a frozen required-gate list or complete derivation DAG.
- [ ] Run `bash tests/evidence-closure-contract.sh`.

Expected: non-zero with `missing core/contracts/v1/schemas/evidence.schema.json`.

- [ ] **Green:** Add all seven schemas and three normative/projection documents.
Use `additionalProperties: false` for persisted objects; keep timestamps UTC,
digests algorithm-prefixed, and references local to the canonical package.
- [ ] Add only enough fixture data for one valid and one invalid record.
- [ ] Run `bash tests/evidence-closure-contract.sh`.

Expected: exit `0` with `typed evidence schema tests passed`.

- [ ] Commit checkpoint: `feat(closure): define typed evidence v1 schemas`.

### ACV1-W3-003: Implement Typed Evidence Validation And Candidate Freshness

**Depends on:** `ACV1-W3-002`

**Files:**
- Create: `scripts/accelerate_contract/evidence.py`
- Modify: `scripts/validate-accelerate-contract.py`
- Modify: `tests/evidence-closure-contract.sh`
- Create: `tests/fixtures/evidence-closure/invalid/stale-source-revision.json`
- Create: `tests/fixtures/evidence-closure/invalid/stale-dependency.json`

- [ ] **Red:** Test `validate`, `candidate`, and `freshness` subcommands. Require stable canonical JSON hashing, exact revision matching, dependency-key digest matching, command digest matching, and artifact existence/digest checks.
- [ ] Run `python3 scripts/validate-accelerate-contract.py --root . --run tests/fixtures/evidence-closure/invalid/stale-source-revision.json --stage evidence`.

Expected: exit `1`; JSON output contains `"decision": "stale"` and `source-revision-changed`.

- [ ] **Green:** Implement canonical JSON with sorted keys and compact separators. Return exit `0` only for `fresh`, exit `1` for a valid but stale/blocked decision, and exit `2` for malformed input.
- [ ] Run the stale command again, then run `python3 scripts/validate-accelerate-contract.py --root . --run tests/fixtures/evidence-closure/valid/evidence.json --stage evidence`.

Expected: stale command exits `1`; valid fixture exits `0` and emits `"valid": true`.

- [ ] Commit checkpoint: `feat(closure): enforce evidence candidate freshness`.

## Chunk 2: Invalidation, Reruns, And Worker Reconciliation

### ACV1-W3-004: Implement Append-Only Invalidation And Selective Reruns

**Depends on:** `ACV1-W3-003`

**Files:**
- Modify: `scripts/accelerate_contract/evidence.py`
- Modify: `scripts/validate-accelerate-contract.py`
- Modify: `tests/evidence-closure-contract.sh`
- Create: `tests/fixtures/evidence-closure/valid/invalidation-ledger.jsonl`
- Create: `tests/fixtures/evidence-closure/valid/dependency-map.json`
- Create: `tests/fixtures/evidence-closure/valid/registry.json`

- [ ] **Red:** Test that changed dependency keys invalidate only transitive dependants, preserve unaffected evidence, and output a deterministic rerun plan ordered by gate then evidence ID.
- [ ] Test duplicate event IDs, mutation of an existing event, and invalidation of an unknown evidence ID as failures.
- [ ] Run `python3 scripts/accelerate_contract/evidence.py plan-reruns --registry tests/fixtures/evidence-closure/valid/registry.json --ledger tests/fixtures/evidence-closure/valid/invalidation-ledger.jsonl --dependency-map tests/fixtures/evidence-closure/valid/dependency-map.json --changed-subject repo-tree`.

Expected before implementation: exit `2` with an unknown `plan-reruns` command.

- [ ] **Green:** Implement `invalidate` and `plan-reruns`; lock files before append, fsync the ledger, and never edit prior lines.
- [ ] Run the focused test.

Expected: `selective rerun tests passed`; unaffected evidence IDs are absent from `rerun_evidence_ids`.

- [ ] Commit checkpoint: `feat(closure): add invalidation ledger and selective reruns`.

### ACV1-W3-005: Reconcile Late-Worker Results

**Depends on:** `ACV1-W3-004`

**Files:**
- Modify: `scripts/accelerate_contract/evidence.py`
- Modify: `tests/evidence-closure-contract.sh`
- Create: `tests/fixtures/evidence-closure/valid/late-worker-result.json`
- Create: `tests/fixtures/evidence-closure/invalid/obsolete-worker-result.json`

- [ ] **Red:** Test results whose `assignment_revision` predates the active
candidate. An unchanged dependency set may reconcile after digest verification;
overlapping changed keys must produce `reject-and-rerun`. A material result
arriving after `closed` must create a linked successor reconciliation run and
never reopen or attach to the terminal run.
- [ ] Run the focused test and observe failure at `late worker reconciliation`.
- [ ] **Green:** Implement `reconcile-worker` returning `accept`, `accept-with-selective-reproof`, or `reject-and-rerun`, plus affected gate IDs and a typed `late-worker-reconciliation` record.
- [ ] Run `bash tests/evidence-closure-contract.sh`.

Expected: exit `0`; output includes `late worker reconciliation tests passed`.

- [ ] Commit checkpoint: `feat(closure): reconcile late worker evidence`.

## Chunk 3: Post-Merge, Cleanup, And Transactional Closure

### ACV1-W3-006: Require Triggered Post-Merge And Cleanup Proof

**Depends on:** `ACV1-W3-005`

**Files:**
- Modify: `scripts/accelerate_contract/evidence.py`
- Modify: `scripts/validate-accelerate-contract.py`
- Modify: `tests/evidence-closure-contract.sh`
- Create: `tests/fixtures/evidence-closure/valid/cleanup-manifest.json`

- [ ] **Red:** Test that a triggered merged/default-branch claim cannot close
without post-merge evidence at the merge commit and that an opened managed
resource requires cleanup evidence. Also prove non-triggered post-merge records
`skip: not-triggered` and no-resource cleanup records
`skip: no-managed-resource` without fabricated evidence.
- [ ] Test that cleanup refuses to delete any path referenced by accepted evidence or the closure candidate.
- [ ] Run `bash tests/evidence-closure-contract.sh`.

Expected: non-zero with `post-merge proof gate not implemented`.

- [ ] **Green:** Add triggered post-merge workflow-gate and
`core.resource-cleanup` evaluation in the repository-local library. Triggered
gates cannot be waived. Do not wire local-workspace shell consumers in Wave 3.
- [ ] Run the focused suite.

Expected: pre-merge fixture is blocked; merged valid fixture reports both gates `passed`.

- [ ] Commit checkpoint: `feat(closure): require post-merge and cleanup proof`.

### ACV1-W3-007: Implement Incident Correction And Manual Risk Correction

**Depends on:** `ACV1-W3-004`, `ACV1-W3-006`

**Files:**
- Modify: `core/closure/transactional-closure.md`
- Modify: `core/contracts/v1/schemas/invalidation-event.schema.json`
- Modify: `core/contracts/v1/schemas/incident.schema.json`
- Modify: `scripts/accelerate_contract/evidence.py`
- Create: `tests/fixtures/evidence-closure/invalid/incident-correction/open.json`
- Create: `tests/fixtures/evidence-closure/invalid/incident-correction/corrected.json`
- Modify: `tests/evidence-closure-contract.sh`

- [ ] **Red:** Add incident fixtures that require detection, containment,
correction linkage, `manual-risk-correction`, affected-evidence invalidation,
corrected-state proof, recurrence/follow-up ownership, and closure blocking.
- [ ] Prove an incident cannot reuse pre-correction evidence and that an open severity/blocker or missing cleanup proof prevents close.
- [ ] Run `python3 scripts/validate-accelerate-contract.py --root . --run tests/fixtures/evidence-closure/invalid/incident-correction/open.json --stage graph --reason manual-risk-correction`.

Expected before implementation: non-zero because manual risk correction is not supported.

- [ ] **Green:** Extend the invalidation contract and engine so correction creates append-only linkage, invalidates affected proof, requires newer corrected evidence, and preserves incident history and external receipts.
- [ ] Run `bash tests/evidence-closure-contract.sh`.

Expected: incident correction fixtures pass; open blockers remain blocked and corrected-state evidence is newer than the incident.

- [ ] Commit checkpoint: `feat(closure): add incident correction and reproof`.

Rollback preserves incident and receipt history, disables faulty automation, and leaves the candidate `rollback-required` or blocked.

### ACV1-W3-008: Prove Transactional Closure In Shadow Fixtures

**Depends on:** `ACV1-W3-006`, `ACV1-W3-007`

**Files:**
- Modify: `scripts/accelerate_contract/evidence.py`
- Create: `scripts/accelerate_contract/closure.py`
- Modify: `scripts/validate-accelerate-contract.py`
- Modify: `tests/evidence-closure-contract.sh`
- Create: `tests/fixtures/evidence-closure/valid/provider-readback.json`
- Create: `tests/fixtures/evidence-closure/invalid/provider-readback-mismatch.json`

- [ ] **Red:** Add isolated fixture tests for two concurrent closers, candidate
change between validation and write, process termination, provider readback
failure, no observable local `closed` before provider reconciliation, and retry
after a completed transaction.
- [ ] Require exactly one closure record, no partial JSON, a retained recovery journal on interrupted writes, and idempotent success for the same transaction ID/digest.
- [ ] Run `bash tests/evidence-closure-contract.sh`.

Expected: non-zero at `transactional closure tests`.

- [ ] **Green:** In a disposable fixture root, enter prepared/nonterminal
`closing`, validate the candidate and complete DAG, reconcile and read back the
fixture provider, then publish `closed`, final receipt/report, and
provider-confirmed state as one logical commit. Refuse CAS/readback mismatch and
leave nonterminal state retryable. This does not touch `.accelerate/` or cut over
authoritative closure.
- [ ] Run the focused suite ten times to exercise races:

`for i in {1..10}; do bash tests/evidence-closure-contract.sh || exit 1; done`

Expected: ten successful runs and no orphaned temporary file in the fixture workspace.

- [ ] Commit checkpoint: `feat(closure): make evidence closure transactional`.

### ACV1-W3-009: Verify, Independently Review, And Close Wave 3

**Depends on:** `ACV1-W3-002`, `ACV1-W3-003`, `ACV1-W3-004`, `ACV1-W3-005`, `ACV1-W3-006`, `ACV1-W3-007`, `ACV1-W3-008`

- [ ] Run `python3 -m py_compile scripts/accelerate_contract/evidence.py scripts/accelerate_contract/closure.py`.

Expected: exit `0` and no output.

- [ ] Run `bash tests/evidence-closure-contract.sh`.

Expected: exit `0`; final line `evidence closure contract tests passed`.

- [ ] Run `bash tests/local-workspace-proof-gates.sh` and `bash tests/local-workspace-scenario-matrix.sh`.

Expected: both exit `0`; existing local-workspace behavior remains unchanged
because Wave 3 has no consumer wiring.

- [ ] Run `bash tests/markdown-link-integrity.sh` and `bash tests/all.sh`.

Expected: `markdown link integrity passed` and final `all tests passed`.

- [ ] Run `git diff --check`.

Expected: exit `0` and no output.

- [ ] Save machine-readable outputs for valid closure, stale candidate, selective rerun, late-worker rejection, incident correction, interrupted transaction recovery, post-merge proof, and cleanup proof under the active issue's evidence attachment surface; do not commit temporary evidence.
- [ ] Have an independent reviewer reconstruct closure without chat history, classify every finding, run correction/reproof for valid findings, and record the advance/block decision in the Wave 3 Closure Packet.

## Rollout

1. Land canonical schemas and repository-local engine with no runtime consumer.
2. Validate legacy/migration fixtures read-only; untyped artifacts cannot newly close.
3. Prove candidate freshness, full DAG invalidation, and selective reruns.
4. Prove transactional closure only in disposable fixture/shadow mode.
5. Defer all local-workspace wiring and authoritative cutover to Wave 5 after
   Wave 4 enforcement, adapter/export/rollback proof, and forensic readiness.

## Rollback

- Disable the shadow runner and retain schemas/ledgers for forensic readability;
  never truncate evidence or invalidation history. No authoritative consumer
  wiring exists to revert in Wave 3.
- Preserve journals and the last committed closure record. Remove only uncommitted temp files after their digest and status are recorded in cleanup proof.
- Reopen the governing work item and mark the candidate `rollback-required`; do not synthesize a successful closure.

## Exit Gate And Acceptance

| ID | Acceptance capability | Required evidence |
| --- | --- | --- |
| `W3-C01` | Typed evidence | Unknown/malformed records fail; valid V1 records pass. |
| `W3-C02` | Candidate freshness | Revision, input, command, dependency, and artifact drift block closure. |
| `W3-C03` | Invalidation ledger | History is append-only, validated, locked, and auditable. |
| `W3-C04` | Selective reruns | Only invalidated gates and transitive dependants are scheduled. |
| `W3-C05` | Triggered post-merge proof | Merge-commit evidence runs when triggered; otherwise `not-triggered` is recorded. |
| `W3-C06` | Late-worker reconciliation | Obsolete/overlapping results cannot overwrite current truth; post-close material events create successor runs. |
| `W3-C07` | Triggered cleanup proof | Managed resources require cleanup; otherwise `no-managed-resource` is recorded. |
| `W3-C08` | Incident correction | Correction invalidates implicated proof and requires newer corrected-state evidence. |
| `W3-C09` | Shadow transactional closure | `closing`, provider readback, race, crash, CAS mismatch, atomic logical commit, and idempotent retry tests pass. |

- [ ] Generate the Wave Closure Packet from the frozen denominator.
- [ ] Exit only when coverage is `100%`, all commands above pass from a clean fixture, no residual is unclassified, and a reviewer confirms the closure record can be reconstructed without chat history.
