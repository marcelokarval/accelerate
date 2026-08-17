# Accelerate Contract V1 Wave 1 Contract Foundation Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a versioned, machine-readable projection of accepted Accelerate doctrine without changing runtime behavior.

**Architecture:** The observation-only projection starts the canonical package at
`core/contracts/v1/`; it is not a competing control-plane package. An explicit
dependency decision selects a Draft 2020-12-conforming validator, while Python
adds referential and semantic invariants. Existing prose remains executable
authority in this wave, and the package is downstream projection evidence until
Wave 5 cutover.

**Tech Stack:** JSON, JSON Schema Draft 2020-12, a pinned conforming validator
selected by decision, Python 3 semantic checks, Bash tests, Markdown owner docs.

---

## Identity And Dependencies

- Plan ID: `ACV1-W1`
- Parent: [Accelerate Contract V1 Master Plan](../executive/accelerate-contract-v1-master-plan.md)
- Depends on: accepted [Wave 0 Authority Plan](accelerate-contract-v1-wave-0-authority.md) closure
- Produces: Contract V1 schema, instance, validator, fixtures, parity evidence
- Behavior change: forbidden; no runtime decision may consume the contract

## Exact Goal

Create one contract instance that describes the currently accepted:

- contract identity/version/status
- authority classes and canonical owner paths
- root-owned invariants
- exact three-class and four-mode persisted vocabularies
- proof order
- gate registry and owner paths
- branch identifiers and current mandatory requirements
- generated-export boundary
- compatibility and rollout mode (`observation-only`)

The contract must not invent requirements absent from accepted doctrine or omit a current root invariant.

## Scope

- JSON schema and canonical JSON instance.
- Structural and semantic validator.
- Positive and negative fixtures.
- Referential parity against authority graph, gate index, and branch matrix.
- Minimal owner/index documentation.

## Non-Scope

- No adaptive conditions, priorities, conflict resolution, or gate selection algorithm.
- No change to `SKILL.md` classification behavior or branch matrix requirements.
- No generated-runtime update.
- No user-home export or mirror check.
- No replacement or deletion of prose doctrine.

### ACV1-W1-001: Freeze The Current-Doctrine Contract Denominator

**Depends on:** `ACV1-W0-006`

- [ ] Verify Wave 0 closure says `advance to ACV1-W1`.
- [ ] Capture fresh `git status --short --branch` and `git diff --name-only`.
- [ ] Confirm Wave 0 bounded commit exists or explicitly record why execution is continuing in an uncommitted coordinated state.
- [ ] Re-run `bash tests/authority-graph-v1.sh` and `bash tests/authority-set-gate.sh`; expect pass.
- [ ] Read `core/control-plane/authority-graph-v1.md`, `branch-enforcement-matrix.md`, `gate-ownership-index.md`, root `SKILL.md`, and `tests/doctrine-integrity.sh`.
- [ ] Freeze the contract denominator: all root invariants, all top-level classes, all proof-order stages, all six authority classes, all indexed gates, and all branch rows.
- [ ] Resolve ownership for any planned file already dirty; do not overwrite concurrent work.

## Exact Files

**Create:**
- `core/contracts/README.md`
- `core/contracts/v1/accelerate-contract.schema.json`
- `core/contracts/v1/accelerate-contract.json`
- `core/contracts/v1/extension-registry.yaml`
- `core/contracts/v1/outcome-rules.yaml`
- `core/contracts/v1/schemas/run.schema.json`
- `core/contracts/v1/schemas/lifecycle.schema.json`
- `core/contracts/v1/schemas/authority-set.schema.json`
- `core/contracts/v1/schemas/gate-definition.schema.json`
- `core/contracts/v1/schemas/gate-decision.schema.json`
- `scripts/validate-accelerate-contract.py`
- `scripts/accelerate_contract/__init__.py`
- `scripts/accelerate_contract/validator.py`
- `planning/architecture/accelerate-contract-v1-decisions.md`
- `scripts/check-contract-validation-dependencies.sh`
- `tests/accelerate-contract-v1.sh`
- `tests/accelerate-contract-v1-dependencies.sh`
- `tests/fixtures/accelerate-contract-v1/valid-minimal.json`
- `tests/fixtures/accelerate-contract-v1/invalid-missing-owner.json`
- `tests/fixtures/accelerate-contract-v1/invalid-generated-authority.json`
- `tests/fixtures/accelerate-contract-v1/invalid-proof-order.json`
- `tests/fixtures/accelerate-contract-v1/invalid-unknown-gate.json`

**Create only if external schema validation is accepted:**
- `requirements-validation.txt`

**Modify:**
- `core/control-plane/README.md`
- `core/control-plane/authority-graph-v1.md`
- `tests/doctrine-integrity.sh`

**Test without modifying:**
- `AGENTS.md`
- `SKILL.md`
- `core/control-plane/authority-set-gate.md`
- `core/control-plane/branch-enforcement-matrix.md`
- `core/control-plane/gate-ownership-index.md`
- `global-runtime/accelerate/`
- `tests/authority-graph-v1.sh`
- `tests/classification-golden.sh`
- `tests/all.sh`

## Contract Shape

Required top-level keys:

```json
{
  "schema_version": "1.0.0",
  "contract_id": "accelerate-contract-v1",
  "status": "observation-only",
  "canonical_owner": "core/contracts/v1/accelerate-contract.json",
  "authority_graph": "core/control-plane/authority-graph-v1.md",
  "root_invariants": [],
  "authority_classes": [],
  "classifications": [],
  "proof_order": [],
  "gates": [],
  "branches": [],
  "generated_export": {},
  "compatibility": {}
}
```

Every gate must have stable `id`, display `name`, `owner`, `ownership_class`, and `blocking` fields. Every branch must reference gate IDs, not copy gate definitions. Every path must be repo-relative and must not contain `~`, `$HOME`, or an absolute user path.

The validator must enforce at least:

- exact V1 identity and observation-only status
- unique IDs
- owner files exist and remain inside repository root
- all branch gate references resolve
- all six authority classes exist exactly once
- root proof order is exactly implementation, backend/frontend QA, browser truth, persistent regression, forensic closure
- generated export has `authoritative: false` and direction `repo-to-generated-to-host`
- no user-home path appears
- no generated-export node owns a governing rule
- contract does not claim runtime enforcement

### ACV1-W1-002: Write Failing Contract Fixtures And Behavior-Neutral Guards

**Depends on:** `ACV1-W1-001`

**Files:**
- Create: `tests/accelerate-contract-v1.sh`
- Create: `tests/fixtures/accelerate-contract-v1/valid-minimal.json`
- Create: `tests/fixtures/accelerate-contract-v1/invalid-missing-owner.json`
- Create: `tests/fixtures/accelerate-contract-v1/invalid-generated-authority.json`
- Create: `tests/fixtures/accelerate-contract-v1/invalid-proof-order.json`
- Create: `tests/fixtures/accelerate-contract-v1/invalid-unknown-gate.json`
- Test: future contract and validator files

- [ ] **Step 1: Add positive-path test**

Require `python3 scripts/validate-accelerate-contract.py --root . --run core/contracts/v1/accelerate-contract.json` to print `accelerate contract v1 valid`.

- [ ] **Step 2: Add negative-path tests**

Each invalid fixture must exit non-zero and print a stable error containing, respectively: `owner`, `generated export`, `proof order`, or `unknown gate`.

- [ ] **Step 3: Add behavior-neutral guard**

In `tests/accelerate-contract-v1.sh`, add `--no-active-consumer` assertions that
inspect only executable selector/call-site shapes in root `SKILL.md`, quick
invocation mappings, and generated runtime entrypoints. Require status
`observation-only`; allow documentation links and explanatory mentions.

- [ ] **Step 4: Run to verify failure**

Run: `bash tests/accelerate-contract-v1.sh`

Expected: FAIL with `missing validator` or `missing contract`, proving the test is red before implementation.

- [ ] **Step 5: Do not commit red-only state**

Keep test and implementation in one later bounded commit unless repository practice explicitly requires a red-test commit.

### ACV1-W1-003: Decide And Enforce JSON Schema Dependency Policy

**Depends on:** `ACV1-W1-001`

**Files:**
- Create: `planning/architecture/accelerate-contract-v1-decisions.md`
- Create if external validation is accepted: `requirements-validation.txt`
- Create: `scripts/check-contract-validation-dependencies.sh`
- Create: `tests/accelerate-contract-v1-dependencies.sh`

- [ ] **Step 1: Write the failing dependency-policy test**

Require the validator capability label and dependency check to agree. No command may claim full JSON Schema Draft 2020-12 validation without a conforming pinned dependency; a required dependency that is missing or incompatible must exit nonzero and must not skip.

- [ ] **Step 2: Run to verify failure**

Run: `bash tests/accelerate-contract-v1-dependencies.sh`

Expected: non-zero because no accepted dependency decision or checker exists.

- [ ] **Step 3: Record the decision**

Select and pin a reviewed Draft 2020-12-conforming validator implementation.
The library choice remains proposed until accepted, but the required validation
capability is not optional and cannot be downgraded to structural lint.

- [ ] **Step 4: Implement the dependency check**

The dependency checker owns only dependency probing and must not invoke the
future validator. It reports missing and incompatible versions with stable
nonzero exits. `--help` availability becomes an `ACV1-W1-004` acceptance check
after that task creates the validator.

- [ ] **Step 5: Run focused proof**

Run: `bash scripts/check-contract-validation-dependencies.sh`

Expected: exit `0` for the accepted validator/dependency pair.

Run: `bash tests/accelerate-contract-v1-dependencies.sh`

Expected: exit `0`; missing/incompatible required dependency fixtures fail for their declared reason.

- [ ] **Step 6: Preserve rollback pairing**

Rollback restores the last accepted validator/dependency pair; never weaken or skip schema validation merely to recover green status.

- [ ] **Step 7: Commit later as this task-scoped slice**

After explicit implementation authorization only, stage the decision,
dependency lock (when selected), checker, and dependency test together. No
commit is authorized during this planning task.

### ACV1-W1-004: Implement The Behavior-Neutral Validator

**Depends on:** `ACV1-W1-002`, `ACV1-W1-003`

**Files:**
- Create: `scripts/validate-accelerate-contract.py`
- Create: `scripts/accelerate_contract/__init__.py`
- Create: `scripts/accelerate_contract/validator.py`
- Test: `tests/accelerate-contract-v1.sh`

- [ ] **Step 1: Implement JSON loading and stable errors**

Use the validator capability accepted by `ACV1-W1-003`. Expected: malformed JSON exits 2; contract violations exit 1; valid input exits 0.

- [ ] **Step 2: Implement structural checks**

Validate required keys and primitive/list/object types at the accepted dependency-policy capability; do not overclaim Draft compliance.

- [ ] **Step 3: Implement semantic checks**

Validate IDs, references, path containment/existence, authority invariants, proof order, generated boundary, and observation-only status.

- [ ] **Step 4: Run focused test**

Run: `bash tests/accelerate-contract-v1.sh`

Expected: tests progress past `missing validator` and fail because schema/contract files are absent.

- [ ] **Step 5: Prove the CLI surface**

Run: `python3 scripts/validate-accelerate-contract.py --help`

Expected: documents `--root`, `--run`, `--stage`, `--format`, and `--quiet`
without loading optional runtime adapters.

### ACV1-W1-005: Define Schema And Canonical Observation-Only Contract

**Depends on:** `ACV1-W1-004`

**Files:**
- Create: `core/contracts/README.md`
- Create: `core/contracts/v1/accelerate-contract.schema.json`
- Create: `core/contracts/v1/accelerate-contract.json`
- Create: `core/contracts/v1/extension-registry.yaml`
- Create: `core/contracts/v1/outcome-rules.yaml`
- Create: `core/contracts/v1/schemas/run.schema.json`
- Create: `core/contracts/v1/schemas/lifecycle.schema.json`
- Create: `core/contracts/v1/schemas/authority-set.schema.json`
- Create: `core/contracts/v1/schemas/gate-definition.schema.json`
- Create: `core/contracts/v1/schemas/gate-decision.schema.json`
- Test: `scripts/validate-accelerate-contract.py`
- Test: owner doctrine files

- [ ] **Step 1: Write the schema document**

Use JSON Schema Draft 2020-12 with repository-owned `$id`, local-only `$ref`,
`additionalProperties: false` at stable boundaries, and explicit required fields.

- [ ] **Step 2: Populate immutable sections**

Encode exactly the SDD's three persisted classes, four persisted modes, nine
outcomes, three review levels, six lifecycle phases, canonical evidence type
enum, and exact proof order. The run aggregate includes every field required by
the SDD; mode values are exactly `single|parallel|wave|incident`.

- [ ] **Step 3: Populate gate registry**

Encode all 18 `core.*` gates from the SDD with exact IDs, triggers, allowed skip
codes, evidence capabilities, and owners. Triggered core gates have no waiver;
only registered extension/profile definitions may declare governed waivers.

- [ ] **Step 4: Populate branches**

Transcribe every branch row and its current mandatory gates/artifacts/proof references. Preserve current semantics; mark unresolved prose-only elements explicitly rather than guessing.

- [ ] **Step 5: Run validator directly**

Run: `python3 scripts/validate-accelerate-contract.py --root . --run core/contracts/v1/accelerate-contract.json`

Expected: `accelerate contract v1 valid`.

- [ ] **Step 6: Run focused fixture suite**

Run: `bash tests/accelerate-contract-v1.sh`

Expected: `accelerate contract v1 tests passed`.

### ACV1-W1-006: Register The Projection Without Activating It

**Depends on:** `ACV1-W1-005`

**Files:**
- Modify: `core/control-plane/README.md`
- Modify: `core/control-plane/authority-graph-v1.md`
- Modify: `tests/doctrine-integrity.sh`

- [ ] **Step 1: Document projection semantics**

State that the JSON contract is a machine-readable projection of accepted owners, is observation-only in Wave 1, and cannot override prose when drift exists.

- [ ] **Step 2: Add graph edge**

Add `canonical doctrine -> machine projection` and prohibit the reverse edge until explicit Wave 5 promotion. Keep generated runtime downstream.

- [ ] **Step 3: Register the focused test**

Require and invoke `tests/accelerate-contract-v1.sh` from `tests/doctrine-integrity.sh`.

- [ ] **Step 4: Run regression proof**

Run: `bash tests/classification-golden.sh`

Expected: `classification golden tests passed`.

Run: `bash tests/authority-graph-v1.sh`

Expected: `authority graph v1 passed`.

Run: `bash tests/doctrine-integrity.sh`

Expected: all nested tests pass and final doctrine marker is present.

Run: `bash tests/all.sh`

Expected: `all tests passed`.

Run: `git diff --check`

Expected: no output and exit 0.

- [ ] **Step 5: Prove no behavior consumption**

Run: `bash tests/accelerate-contract-v1.sh --no-active-consumer`

Expected: `contract v1 active-consumer guard passed`; an injected executable
selector fixture fails while documentation-only mentions pass.

- [ ] **Step 6: Commit later as a task-scoped registration slice**

```bash
git add core/control-plane/README.md core/control-plane/authority-graph-v1.md tests/doctrine-integrity.sh
git commit -m "docs(contract-v1): register canonical observation package"
```

Expected: staged path list contains only `ACV1-W1-006` outputs. Other Wave 1
tasks use their own bounded commits with every required output staged; no commit
is authorized during this planning task.

### ACV1-W1-007: Run Parity Review And Close Wave 1

**Depends on:** `ACV1-W1-002`, `ACV1-W1-003`, `ACV1-W1-004`, `ACV1-W1-005`, `ACV1-W1-006`

**Files:**
- Test: canonical contract against all owner docs
- Evidence: Wave 1 Closure Packet

- [ ] Generate a denominator report counting expected vs represented root invariants, classes, proof stages, gates, and branches.
- [ ] Require 100% representation for root invariants, authority classes, proof stages, and gate owner IDs.
- [ ] Require every branch row represented; classify prose that cannot yet become adaptive data.
- [ ] Have a skeptical reviewer sample every category and inspect all negative fixtures.
- [ ] Correct and re-run all focused/full tests for valid findings.
- [ ] Capture closing status and confirm `global-runtime/accelerate/` and user-home paths were untouched by Wave 1.

## Rollout

Run the validator as additional local/CI proof only. Do not wire it into classification or gate selection. A validation failure blocks Contract V1 promotion but must not silently alter current runtime behavior.

## Rollback

Stop invoking the validator and revert only the affected task-scoped bounded
Wave 1 slices. Existing prose doctrine remains complete and authoritative, so no
runtime or data migration is needed.

## Risks

| Risk | Mitigation |
| --- | --- |
| JSON duplicates prose and drifts | Referential/parity validator and explicit projection status |
| Schema is claimed but not actually validated | Pin/check a conforming Draft 2020-12 engine and test dependency failure |
| Transcription changes semantics | Freeze denominator and require skeptical parity review |
| Contract IDs become unstable | Stable kebab-case IDs and uniqueness checks |
| Absolute/user-home paths leak into data | Path containment and forbidden-pattern validation |
| Dirty runtime work is folded in | Runtime files are test-only and untouched in Wave 1 |

## Exit Gate And Deliverables

Deliverables:

- canonical `core/contracts/v1/` package foundation, including the aggregate,
  lifecycle, authority, gate-definition, and gate-decision schemas
- validator, five fixtures, dependency proof, and focused shell test
- owner pointers that preserve prose authority
- Contract V1 parity/coverage evidence
- accepted Wave 1 Closure Packet
- task-scoped bounded commits for each owned Wave 1 slice later

Exit requires:

- focused positive and negative tests pass
- root invariants/classes/proof/gate owners have 100% representation
- all branches are represented and residual prose is classified
- classification and full-suite outputs do not regress
- no runtime consumer, generated export, or user-home path changes
- rollback disables observation and reverts only the affected task-scoped
  bounded commits
- explicit `advance to ACV1-W2` decision
