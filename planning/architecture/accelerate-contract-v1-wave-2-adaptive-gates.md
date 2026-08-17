# Accelerate Contract V1 Wave 2 Adaptive Gates Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a deterministic adaptive gate matrix and explainable shadow evaluator without activating runtime enforcement.

**Architecture:** A versioned matrix inside `core/contracts/v1/` contains ordered,
additive rules over explicit run context. A Python evaluator validates inputs,
applies all 18 core gate definitions first, resolves matching rules
deterministically, and emits a shadow workflow action for comparison with
existing prose routing; shadow actions are not persisted modes or outcomes.

**Tech Stack:** JSON, JSON Schema vocabulary, Python 3 standard library, Bash scenario tests, JSON fixtures, existing classification and doctrine tests.

---

## Identity And Dependencies

- Plan ID: `ACV1-W2`
- Parent: [Accelerate Contract V1 Master Plan](../executive/accelerate-contract-v1-master-plan.md)
- Depends on: accepted [Wave 1 Contract Foundation Plan](accelerate-contract-v1-wave-1-contract-foundation.md) closure
- Produces: adaptive matrix, evaluator, scenario corpus, shadow parity report
- Behavior change: none; output remains advisory/shadow until accepted Wave 5 cutover

## Exact Goal

Given explicit context, produce deterministic JSON containing:

- selected classification and branch candidates
- immutable root gates
- adaptive mandatory gates
- required artifacts and evidence
- matched rule IDs and reason trace
- conflicts, unknowns, and closure blockers
- `shadow_action`: `shadow-pass`, `needs-input`, or `block`, separate from the
  canonical persisted `outcome`

The matrix may add requirements but may never remove a root invariant or downgrade a mandatory gate inherited from accepted doctrine.

## Scope

- Versioned adaptive matrix schema and data.
- Deterministic evaluator with validation and explanation.
- Frozen positive, near-miss, conflict, unknown, and high-risk scenarios.
- Shadow comparison against existing branch/gate doctrine.
- Minimal contract/index registration without enforcement.

## Non-Scope

- No change to default root runtime behavior.
- No direct edits to `global-runtime/accelerate/`.
- No auto-discovery from repository contents; input facts must be explicit.
- No probabilistic scoring or model-dependent selection.
- No rule that weakens authority, issue, proof-order, local-workspace, or closure laws.
- No user-home export.

### ACV1-W2-001: Freeze Adaptive Scenario Denominator And Input Contract

**Depends on:** `ACV1-W1-007`

**Files:**
- Create: `tests/fixtures/accelerate-contract-v1/adaptive-scenarios.json`
- Modify: active Wave 2 Packet and `planning/execution/accelerate-contract-v1-wave-denominator.json`

- [ ] Verify Wave 1 closure says `advance to ACV1-W2` and contract status is `observation-only`.
- [ ] Capture `git status --short --branch` and `git diff --name-only`; classify overlap before edit.
- [ ] Run `bash tests/accelerate-contract-v1.sh`, `bash tests/authority-graph-v1.sh`, and `bash tests/classification-golden.sh`; expect pass.
- [ ] Read the canonical contract, branch matrix, gate ownership index, quick invocation map, local workspace gate, issue topology, and QA proof stack.
- [ ] Freeze the scenario denominator before writing rules.
- [ ] Confirm every matrix gate ID already exists in Contract V1; new gates require owner-first work outside this wave or a plan amendment.

## Exact Files

**Create:**
- `core/contracts/v1/adaptive-gate-matrix.schema.json`
- `core/contracts/v1/adaptive-gate-matrix.json`
- `core/contracts/v1/schemas/lane.schema.json`
- `core/contracts/v1/schemas/wave.schema.json`
- `core/contracts/v1/schemas/incident.schema.json`
- `scripts/evaluate-adaptive-gates.py`
- `tests/adaptive-gate-matrix-v1.sh`
- `tests/fixtures/accelerate-contract-v1/adaptive-scenarios.json`
- `tests/fixtures/accelerate-contract-v1/adaptive-invalid-unknown-gate.json`
- `tests/fixtures/accelerate-contract-v1/adaptive-invalid-relaxation.json`
- `tests/fixtures/accelerate-contract-v1/adaptive-invalid-priority-conflict.json`

**Modify:**
- `core/contracts/v1/accelerate-contract.schema.json`
- `core/contracts/v1/accelerate-contract.json`
- `core/control-plane/README.md`
- `core/control-plane/authority-graph-v1.md`
- `scripts/validate-accelerate-contract.py`
- `tests/accelerate-contract-v1.sh`
- `tests/doctrine-integrity.sh`

**Test without modifying:**
- `SKILL.md`
- `core/control-plane/branch-enforcement-matrix.md`
- `core/control-plane/gate-ownership-index.md`
- `core/control-plane/quick-invocation-map.md`
- `global-runtime/accelerate/`
- `tests/classification-golden.sh`
- `tests/all.sh`

## Input Contract

Required context fields:

```json
{
  "request_kind": "engineering",
  "mutation": true,
  "scope": "non-trivial",
  "ambiguity": "low",
  "governed_target_repo": true,
  "local_workspace_state": "existing",
  "issue_state": "execution-ready",
  "risk_tags": ["governance"],
  "surface_tags": ["architecture"],
  "proof_tags": ["static"],
  "repeated_target_count": 0,
  "user_overrides": []
}
```

Enums and defaults must be explicit in the schema. Missing facts that affect a
blocking gate must produce shadow action `needs-input` or `block`; the evaluator
must not guess or invent a canonical outcome.

## Rule Contract

Each rule must contain:

- stable `id`
- integer `priority`
- `description`
- `when` predicates using only approved operators: `equals`, `in`, `contains-any`, `contains-all`, `gte`, `present`
- additive `require.gates`, `require.artifacts`, and `require.evidence`
- `reason`
- optional `block_if_missing`

Resolution order:

1. Validate contract, matrix, and input.
2. Apply immutable root invariants.
3. Select top-level classification.
4. Evaluate rules by ascending priority then stable rule ID.
5. Union additive requirements.
6. Detect incompatible branch claims or contradictory user overrides.
7. Emit stable sorted output and reason trace.

No `remove`, `exclude`, `disable`, or negative requirement operator is permitted in V1.

## Frozen Scenario Denominator

The scenario corpus must include at least the following workflow/scenario labels.
They map to independent persisted `class`, persisted `mode`, canonical `outcome`,
and shadow `action` fields; none of these labels is itself a mode or outcome:

| ID | Expected posture |
| --- | --- |
| `conversational-noop` | no engineering mutation gates |
| `trivial-readonly` | compact proof, no issue bootstrap, no wave gate |
| `trivial-living-doc-mutation` | local workspace decision plus issue bootstrap unless explicit exception |
| `ambiguous-epic` | prompt hardening, specification artifacts, task breakdown |
| `nontrivial-governance` | root invariants, authority/truth gates, issue/planning gates |
| `bug-regression` | failure classification and corrected-state proof |
| `visual-ui` | UI/design proof requirements without backend-only gates |
| `contract-sensitive-backend` | truth ownership and backend validation requirements |
| `repeated-broad-work` | class `orchestrated-nontrivial`, mode `wave`, denominator requirement |
| `large-one-shot` | class `orchestrated-nontrivial`, mode `single` unless independence is proven |
| `unknown-local-workspace` | needs input or block before deeper routing |
| `missing-issue` | block mutation unless explicit narrow exception |
| `conflicting-branch-signals` | deterministic conflict report, no silent choice |
| `generated-export-authority-attempt` | block |
| `user-home-authority-attempt` | block |

Additional scenarios are allowed, but the denominator must be frozen before implementation and changed only through an explicit correction note.

### ACV1-W2-002: Write Adaptive Matrix, Determinism, And Negative Tests

**Depends on:** `ACV1-W2-001`

**Files:**
- Create: `tests/adaptive-gate-matrix-v1.sh`
- Modify: `tests/fixtures/accelerate-contract-v1/adaptive-scenarios.json` (created and owned by `ACV1-W2-001`)
- Create: `tests/fixtures/accelerate-contract-v1/adaptive-invalid-unknown-gate.json`
- Create: `tests/fixtures/accelerate-contract-v1/adaptive-invalid-relaxation.json`
- Create: `tests/fixtures/accelerate-contract-v1/adaptive-invalid-priority-conflict.json`

- [ ] **Step 1: Encode all frozen scenarios**

Each scenario must define input plus exact expected class, mode, canonical
outcome, complete core-gate partition, shadow action, and reason IDs.

- [ ] **Step 2: Add deterministic-output test**

Run each scenario twice and compare byte-identical normalized JSON output.

- [ ] **Step 3: Add invalid matrix tests**

Unknown gate IDs, relaxation operators, and duplicate-priority conflicting rules must exit non-zero with stable error labels.

- [ ] **Step 4: Add no-enforcement guard**

In `tests/adaptive-gate-matrix-v1.sh`, add a `--no-active-consumer` mode that
detects executable evaluator invocations/selector wiring in known runtime call
sites while allowing documentation mentions and future-cutover prose.

- [ ] **Step 5: Run to verify failure**

Run: `bash tests/adaptive-gate-matrix-v1.sh`

Expected: FAIL with `missing adaptive gate evaluator` or `missing adaptive gate matrix`.

### ACV1-W2-003: Extend Contract And Validator For Matrix Linkage

**Depends on:** `ACV1-W2-002`

**Files:**
- Modify: `core/contracts/v1/accelerate-contract.schema.json`
- Modify: `core/contracts/v1/accelerate-contract.json`
- Modify: `scripts/validate-accelerate-contract.py`
- Modify: `tests/accelerate-contract-v1.sh`

- [ ] **Step 1: Write failing linkage assertions**

Require a `gate_matrix` descriptor with ID, version, path,
`evaluation_state: shadow`, and `may_relax_root_invariants: false`. Do not use
the persisted `mode` field for rollout state.

- [ ] **Step 2: Run contract tests**

Run: `bash tests/accelerate-contract-v1.sh`

Expected: FAIL because the linkage descriptor and matrix validation are absent.

- [ ] **Step 3: Implement minimal linkage validation**

Validate matrix path containment, identity/version, gate references, allowed operators, additive-only actions, unique rule IDs, deterministic priority rules, and shadow mode.

- [ ] **Step 4: Run contract tests again**

Expected: progress to failure on missing matrix file, not a regression in prior positive/negative fixtures.

### ACV1-W2-004: Implement Adaptive Matrix And Shadow Evaluator

**Depends on:** `ACV1-W2-003`

**Files:**
- Create: `core/contracts/v1/adaptive-gate-matrix.schema.json`
- Create: `core/contracts/v1/adaptive-gate-matrix.json`
- Create: `core/contracts/v1/schemas/lane.schema.json`
- Create: `core/contracts/v1/schemas/wave.schema.json`
- Create: `core/contracts/v1/schemas/incident.schema.json`
- Create: `scripts/evaluate-adaptive-gates.py`
- Test: all adaptive fixtures

- [ ] **Step 1: Write matrix schema and immutable gates**

Reference the exact 18 Contract V1 `core.*` gate IDs and encode root invariants
separately from adaptive rules. Add lane, wave, and incident schemas with the
SDD aggregate references and positive/negative mode invariants.

- [ ] **Step 2: Add the smallest rule set**

Implement only rules needed to represent accepted branch doctrine and frozen scenarios. Do not encode speculative future branches.

- [ ] **Step 3: Implement input validation**

Use Python standard library only. Reject unknown fields when they could hide typos; reject invalid enums and forbidden authority paths.

- [ ] **Step 4: Implement deterministic matching and union**

Sort by priority and ID; sort emitted gates/artifacts/evidence; retain ordered reason trace.

- [ ] **Step 5: Implement fail-closed conflict handling**

Unknown blocking facts produce `needs-input`; invalid authority or incompatible mandatory branch outcomes produce `block`.

- [ ] **Step 6: Run the focused test**

Run: `bash tests/adaptive-gate-matrix-v1.sh`

Expected: `adaptive gate matrix v1 tests passed`.

- [ ] **Step 7: Run contract regression test**

Run: `bash tests/accelerate-contract-v1.sh`

Expected: `accelerate contract v1 tests passed`.

### ACV1-W2-005: Prove Adaptive Parity And Correction Coverage

**Depends on:** `ACV1-W2-004`

**Files:**
- Test: `tests/fixtures/accelerate-contract-v1/adaptive-scenarios.json`
- Test: existing branch and classification doctrine
- Evidence: Wave 2 shadow parity section in Closure Packet

- [ ] **Step 1: Compare scenario expectations to prose owners**

For every scenario, cite the branch matrix/root owner that justifies each mandatory gate and blocker.

- [ ] **Step 2: Compute coverage**

Use the repo-contained wave report tool from its approved canonical/generated location only after confirming ownership. Feed the frozen scenario denominator and mark a target covered only when classification, gates, decision, and reasons all match.

Suggested command when the current generated tool remains accepted:

`python3 global-runtime/accelerate/scripts/wave_gate_report.py .tmp/accelerate-contract-v1-wave-2-coverage.json --format packet`

Expected: decision `advance`, 100% mandatory root-invariant coverage, and at least 95% overall scenario coverage. Because `global-runtime/` is non-authoritative, the input expectations must come from repo-local doctrine and the command is only a calculator; if the tool's ownership is unresolved, use an equivalent reviewed repo-local calculation and record the exception.

- [ ] **Step 3: Correct residuals**

Any failed scenario opens a correction/reproof loop. Waivers cannot hide a root-invariant miss, authority violation, or fail-open result.

- [ ] **Step 4: Preserve shadow mode**

Run: `bash tests/adaptive-gate-matrix-v1.sh --no-active-consumer`

Expected: `adaptive matrix active-consumer guard passed`; shadow state remains
non-enforcing until accepted `ACV1-W5-007` cutover, and documentation mentions
remain valid.

### ACV1-W2-006: Register, Regress, Independently Review, And Close Wave 2

**Depends on:** `ACV1-W2-002`, `ACV1-W2-003`, `ACV1-W2-004`, `ACV1-W2-005`

**Files:**
- Modify: `core/control-plane/README.md`
- Modify: `core/control-plane/authority-graph-v1.md`
- Modify: `tests/doctrine-integrity.sh`
- Test: all focused and aggregate suites

- [ ] Add minimal pointers identifying matrix ownership, shadow mode, and additive-only policy.
- [ ] Add `contract -> adaptive matrix -> shadow decision` edges; no edge may yet govern root runtime behavior.
- [ ] Require and invoke `tests/adaptive-gate-matrix-v1.sh` from doctrine integrity.
- [ ] Run `bash tests/adaptive-gate-matrix-v1.sh`; expect pass.
- [ ] Run `bash tests/accelerate-contract-v1.sh`; expect pass.
- [ ] Run `bash tests/classification-golden.sh`; expect pass.
- [ ] Run `bash tests/doctrine-integrity.sh`; expect pass.
- [ ] Run `bash tests/all.sh`; expect `all tests passed`.
- [ ] Run `bash tests/markdown-link-integrity.sh`; expect pass.
- [ ] Run `git diff --check`; expect no output.
- [ ] Have a skeptical reviewer inspect rule precedence, every fail-closed scenario, and all negative fixtures.
- [ ] Correct valid findings and re-run proof.
- [ ] Inspect staged paths and commit this registration task later only after implementation authorization:

```bash
git add core/control-plane/README.md core/control-plane/authority-graph-v1.md tests/doctrine-integrity.sh
git commit -m "docs(contract-v1): register adaptive shadow matrix"
```

Expected: only `ACV1-W2-006` outputs are staged. Tasks `ACV1-W2-001`
through `ACV1-W2-005` use their own task-scoped commits including all owned
fixtures/tests/implementation outputs; no commit is authorized during this
planning task.

## Rollout

Run the evaluator only from focused tests and explicit shadow comparison
commands through Waves 2-4 and Wave 5 preflight. Persist differences as evidence;
do not use output to add, remove, or satisfy runtime gates before accepted
`ACV1-W5-007` cutover.

## Rollback

Stop shadow commands and revert only task-scoped Wave 2 slices. Contract V1
remains observation-only and existing prose routing remains authoritative until
accepted Wave 5 cutover. Preserve parity evidence for diagnosis.

## Risks

| Risk | Mitigation |
| --- | --- |
| Adaptive means unpredictable | Explicit inputs, finite operators, stable priority/ID ordering, byte-determinism test |
| Rules weaken mandatory gates | Additive-only schema, immutable root set, invalid-relaxation fixture |
| Matrix overfits fixture examples | Cite every expectation to canonical prose and include near-miss/conflict cases |
| Missing facts are guessed | `needs-input`/`block` fail-closed outcomes |
| Branch conflicts are hidden by priority | Explicit incompatible-result detection and reason trace |
| Generated wave calculator is mistaken for authority | Treat it only as a calculator; source expectations from repo doctrine |
| Dirty runtime work is overwritten | Generated runtime is test-only and untouched in Wave 2 |

## Exit Gate And Deliverables

Deliverables:

- adaptive matrix schema and canonical matrix
- deterministic shadow evaluator
- at least 15 frozen scenarios and three invalid matrix fixtures
- focused adaptive and updated contract tests
- shadow parity/coverage evidence
- accepted Wave 2 Closure Packet
- task-scoped bounded commits for each owned Wave 2 slice later

Exit requires:

- all positive, negative, determinism, conflict, and fail-closed tests pass
- mandatory root-invariant scenario coverage = 100%
- overall frozen-scenario coverage >=95%, with every residual classified and no critical waiver
- existing classification and full-suite results do not regress
- no active runtime consumer and no generated/user-home edit
- rollback remains removal of shadow evaluation only
- explicit `advance to ACV1-W3 evidence and transactional closure` decision
