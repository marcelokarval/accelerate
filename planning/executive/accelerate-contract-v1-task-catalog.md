# Accelerate Contract v1 Task Catalog

Status: `accepted-for-implementation`
Authorities: `docs/architecture/accelerate-contract-v1-sdd.md`, `planning/executive/accelerate-contract-v1-master-plan.md`, and the six `planning/architecture/accelerate-contract-v1-wave-*.md` plans
Frozen denominator: 45 tasks across Waves 0-5
Required coverage / closure threshold: 100% for authority, P0, schema, safety,
and wave capability targets; at least 95% elsewhere with no uncovered blocker.

## Catalog Rules

- IDs are permanent and never reused. Supersession retains the old ID and records its replacement.
- Paths are repository-relative; `(new)` marks an exact proposed surface.
- Detailed wave plans own implementation slicing and file paths. The SDD owns broader contract intent. Conflicts are closure blockers until a recorded decision resolves them.
- `global-runtime/accelerate/` and user-home installations are generated outputs, never authoring authority.
- Package acceptance `ACV1-A001` authorizes Wave 0 entry. Individual tasks retain
  `proposed` until their wave packet admits them, and a wave advances only after
  its frozen manifest, focused proof, correction/reproof, independent review,
  and closure packet pass.

## Wave 0: Authority Graph

### ACV1-W0-001: Open the Wave 0 entry and ownership packet
- **Priority:** P0
- **Owner role:** root orchestrator
- **Dependencies:** none
- **Exact file surfaces:** `.accelerate/review/handoff-summary.md` (read-only), active Wave Packet in repo-local workflow state, `planning/architecture/accelerate-contract-v1-wave-0-authority.md`
- **Deliverables:** Baseline branch/status/path list, local-workspace decision, issue/no-issue decision, owner map, authority pre-read, focused baseline outputs, and stop conditions for concurrent overlap.
- **Acceptance criteria:** Every planned/dirty overlap has an owner; no unowned file is staged, reset, stashed, cleaned, or overwritten; no user-home path is authority or output.
- **Tests/commands:** `git status --short --branch`; `git diff --name-only`; `bash tests/authority-set-gate.sh`; `bash tests/doctrine-integrity.sh`; `bash tests/markdown-link-integrity.sh`
- **Rollback:** Discard only Wave Packet state created by this task; preserve all pre-existing worktree/runtime state.
- **Status:** `proposed`

### ACV1-W0-002: Freeze the authority denominator and write failing graph tests
- **Priority:** P0
- **Owner role:** control-plane architect
- **Dependencies:** ACV1-W0-001
- **Exact file surfaces:** `tests/authority-graph-v1.sh` (new), `.tmp/authority-graph-v1/` (test-owned temporary fixtures), active Wave Packet
- **Deliverables:** Frozen six-class/six-edge denominator and failing structural/reverse-edge/user-home tests before graph implementation.
- **Acceptance criteria:** Test exists first and fails with stable `missing graph`; no future graph implementation is created by this task.
- **Tests/commands:** `rg -n "governing-authority|supporting-reference|decision-artifact|backend-authority|generated-export|forbidden-authority|source of truth" AGENTS.md SKILL.md README.md core adapters profiles onboarding planning references global-runtime/accelerate`; `bash tests/authority-graph-v1.sh --graph-only` (expected red)
- **Rollback:** Remove only the unaccepted test and temporary fixtures; runtime/generated files remain untouched.
- **Status:** `proposed`

### ACV1-W0-003: Implement authority graph and complete positive/negative tests
- **Priority:** P0
- **Owner role:** governance test engineer
- **Dependencies:** ACV1-W0-002
- **Exact file surfaces:** `core/control-plane/authority-graph-v1.md` (new), `tests/authority-graph-v1.sh`, `.tmp/authority-graph-v1/` (test-owned temporary fixtures)
- **Deliverables:** Graph implementation for all classes/edges/direction/drift rules plus completed positive/negative proof.
- **Acceptance criteria:** Missing semantics fail with stable labels; reverse authority is rejected for the intended reason; temporary fixtures are removed; `--graph-only` is Green before commit and does not include future owner-pointer assertions.
- **Tests/commands:** `bash tests/authority-graph-v1.sh --graph-only`; `git status --short`
- **Rollback:** Remove/revert `core/control-plane/authority-graph-v1.md` and the
matching `tests/authority-graph-v1.sh` changes together as one bounded
`ACV1-W0-003` slice; preserve unrelated and predecessor state.
- **Status:** `proposed`

### ACV1-W0-004: Reconcile canonical authority owners
- **Priority:** P0
- **Owner role:** doctrine maintainer
- **Dependencies:** ACV1-W0-003
- **Exact file surfaces:** `AGENTS.md`, `SKILL.md`, `README.md`, `core/control-plane/README.md`, `core/control-plane/authority-set-gate.md`, `core/control-plane/gate-ownership-index.md`, `tests/doctrine-integrity.sh`
- **Deliverables:** Red-first owner-pointer test mode, minimal owner pointers, explicit generated-runtime direction, graph ownership boundaries, and doctrine-test registration.
- **Acceptance criteria:** `--owner-pointers` fails for missing pointers before owner edits and passes afterward; classes remain owned by authority-set doctrine, graph owns relationships/precedence, generated drift repairs from source, and no runtime behavior changes.
- **Tests/commands:** `bash tests/authority-graph-v1.sh --owner-pointers` (expected red before owner edits, green after); `bash tests/authority-graph-v1.sh`; `bash tests/authority-set-gate.sh`; `bash tests/doctrine-integrity.sh`; `bash tests/markdown-link-integrity.sh`; `git diff --check`
- **Rollback:** Revert only the bounded owner-pointer slice; no generated or host state exists to restore.
- **Status:** `proposed`

### ACV1-W0-005: Materialize the six-wave denominator manifest
- **Priority:** P0
- **Owner role:** release governance maintainer
- **Dependencies:** ACV1-W0-002
- **Exact file surfaces:** `planning/execution/accelerate-contract-v1-wave-denominator.json` (new), `tests/accelerate-contract-v1-denominator.sh` (new), `planning/executive/accelerate-contract-v1-task-catalog.md`, `planning/executive/accelerate-contract-v1-validation-checklist.md`
- **Deliverables:** Machine-readable 45-task denominator with wave, owner, dependencies, priority, capability target, proof, exclusions, and threshold.
- **Acceptance criteria:** IDs are unique/acyclic and exactly match this catalog; changes require explicit re-freeze and invalidate prior coverage; each detailed wave capability denominator is represented.
- **Tests/commands:** `bash tests/accelerate-contract-v1-denominator.sh` (self-contained Wave 0 validation; the general validator does not exist until ACV1-W1-004)
- **Rollback:** Restore the last accepted manifest and invalidate reports using changed membership.
- **Status:** `proposed`

### ACV1-W0-006: Independently review and close Wave 0
- **Priority:** P0
- **Owner role:** independent governance reviewer
- **Dependencies:** ACV1-W0-003, ACV1-W0-004, ACV1-W0-005
- **Exact file surfaces:** all Wave 0 surfaces; Wave 0 Closure Packet in active repo-local workflow state
- **Deliverables:** Skeptical node/edge review, finding disposition, fresh proof, 100% authority coverage, closing worktree/staging audit, and advance/block decision.
- **Acceptance criteria:** No ambiguity/cycle/residual, no runtime/generated change, no user-home authority/write, no unowned dirty path staged/reverted, and full suite passes.
- **Tests/commands:** `bash tests/authority-graph-v1.sh`; `bash tests/authority-set-gate.sh`; `bash tests/doctrine-integrity.sh`; `bash tests/markdown-link-integrity.sh`; `bash tests/all.sh`; `git status --short --branch`; `git diff --check`
- **Rollback:** Reopen Wave 0 and revert only its bounded implementation slice; preserve review evidence.
- **Status:** `proposed`

## Wave 1: Behavior-Neutral Contract Foundation

### ACV1-W1-001: Freeze the current-doctrine contract denominator
- **Priority:** P0
- **Owner role:** contract architect
- **Dependencies:** ACV1-W0-006
- **Exact file surfaces:** active Wave 1 Packet, `core/control-plane/authority-graph-v1.md`, `core/control-plane/branch-enforcement-matrix.md`, `core/control-plane/gate-ownership-index.md`, `SKILL.md`
- **Deliverables:** Frozen inventory of root invariants, 3 top-level classifications, exact 5-stage proof order, 6 authority classes, indexed gates, branch rows, compatibility, and observation-only status.
- **Acceptance criteria:** Every denominator item has a canonical owner; unresolved prose is classified, not guessed; runtime/generated files are read-only in this wave.
- **Tests/commands:** `bash tests/authority-graph-v1.sh`; `bash tests/authority-set-gate.sh`; `git status --short --branch`
- **Rollback:** Remove Wave 1 packet/denominator state and leave prose authority unchanged.
- **Status:** `proposed`

### ACV1-W1-002: Write failing contract fixtures and behavior-neutral guards
- **Priority:** P0
- **Owner role:** contract test engineer
- **Dependencies:** ACV1-W1-001
- **Exact file surfaces:** `tests/accelerate-contract-v1.sh` (new), `tests/fixtures/accelerate-contract-v1/valid-minimal.json` (new), `tests/fixtures/accelerate-contract-v1/invalid-missing-owner.json` (new), `tests/fixtures/accelerate-contract-v1/invalid-generated-authority.json` (new), `tests/fixtures/accelerate-contract-v1/invalid-proof-order.json` (new), `tests/fixtures/accelerate-contract-v1/invalid-unknown-gate.json` (new)
- **Deliverables:** Positive fixture, four stable negative classes, and assertions that Wave 1 contract status is observation-only and has no runtime consumer.
- **Acceptance criteria:** Tests are red before implementation for missing validator/contract; each invalid fixture fails for its declared reason; root/generated skills do not use the contract as selector.
- **Tests/commands:** `bash tests/accelerate-contract-v1.sh`; `bash tests/accelerate-contract-v1.sh --no-active-consumer`
- **Rollback:** Remove only Wave 1 fixtures/tests; no runtime behavior exists to migrate.
- **Status:** `proposed`

### ACV1-W1-003: Decide and enforce JSON Schema dependency policy
- **Priority:** P0
- **Owner role:** schema and dependency maintainer
- **Dependencies:** ACV1-W1-001
- **Exact file surfaces:** `planning/architecture/accelerate-contract-v1-decisions.md` (new), `requirements-validation.txt` (new if external validation is accepted), `scripts/check-contract-validation-dependencies.sh` (new), `tests/accelerate-contract-v1-dependencies.sh` (new)
- **Deliverables:** Human decision selecting and pinning a reviewed Draft 2020-12-conforming validator plus a dependency check; no structural-only alternative is executable.
- **Acceptance criteria:** No tool claims full JSON Schema validation without a conforming dependency; missing/incompatible required dependency exits nonzero and never skips; `--help` remains available.
- **Tests/commands:** `bash scripts/check-contract-validation-dependencies.sh`; `bash tests/accelerate-contract-v1-dependencies.sh` (does not invoke the validator created by ACV1-W1-004)
- **Rollback:** Restore the last accepted validator/dependency pair; never make schema validation optional to recover green status.
- **Status:** `proposed`

### ACV1-W1-004: Implement the behavior-neutral validator
- **Priority:** P0
- **Owner role:** validator engineer
- **Dependencies:** ACV1-W1-002, ACV1-W1-003
- **Exact file surfaces:** `scripts/validate-accelerate-contract.py` (new), `scripts/accelerate_contract/__init__.py` (new), `scripts/accelerate_contract/validator.py` (new), `tests/accelerate-contract-v1.sh`
- **Deliverables:** JSON loading, structural validation at the accepted capability, stable exits/errors, identity/ID/reference/path/authority/proof-order/generated-boundary/observation-only semantics.
- **Acceptance criteria:** Malformed input exits 2; violations exit 1; valid exits 0; paths stay repo-relative; unknown references/gates fail; validator does not alter routing.
- **Tests/commands:** `python3 scripts/validate-accelerate-contract.py --help`; `bash tests/accelerate-contract-v1.sh`
- **Rollback:** Stop invoking the validator and preserve prose behavior as authority.
- **Status:** `proposed`

### ACV1-W1-005: Define schema and canonical observation-only contract
- **Priority:** P0
- **Owner role:** contract schema maintainer
- **Dependencies:** ACV1-W1-004
- **Exact file surfaces:** `core/contracts/README.md` (new), `core/contracts/v1/accelerate-contract.schema.json` (new), `core/contracts/v1/accelerate-contract.json` (new), `core/contracts/v1/extension-registry.yaml` (new), `core/contracts/v1/outcome-rules.yaml` (new), `core/contracts/v1/schemas/run.schema.json` (new), `core/contracts/v1/schemas/lifecycle.schema.json` (new), `core/contracts/v1/schemas/authority-set.schema.json` (new), `core/contracts/v1/schemas/gate-definition.schema.json` (new), `core/contracts/v1/schemas/gate-decision.schema.json` (new)
- **Deliverables:** Canonical package foundation with exact three classes, four modes, nine outcomes, three review levels, six phases, 18 `core.*` gates, run aggregate, authority/gate schemas, proof order, compatibility, and `observation-only` status.
- **Acceptance criteria:** Draft 2020-12 closed boundaries; exact SDD enums/gates; triggered core gates unwaivable; all owners/references resolve; generated export is downstream; no user-home path or runtime-enforcement claim.
- **Tests/commands:** `python3 scripts/validate-accelerate-contract.py --root . --run core/contracts/v1/accelerate-contract.json`; `bash tests/accelerate-contract-v1.sh`
- **Rollback:** Revert schema/instance and stop observation-only validation; prose remains authoritative.
- **Status:** `proposed`

### ACV1-W1-006: Register the projection without activating it
- **Priority:** P0
- **Owner role:** control-plane documentation maintainer
- **Dependencies:** ACV1-W1-005
- **Exact file surfaces:** `core/control-plane/README.md`, `core/control-plane/authority-graph-v1.md`, `tests/doctrine-integrity.sh`
- **Deliverables:** Projection semantics, `doctrine -> machine projection` edge, reverse-edge prohibition until promotion, and focused test registration.
- **Acceptance criteria:** Contract cannot override prose on drift; no active runtime invocation; classification result is unchanged; generated/user-home surfaces untouched.
- **Tests/commands:** `bash tests/classification-golden.sh`; `bash tests/authority-graph-v1.sh`; `bash tests/doctrine-integrity.sh`; `bash tests/all.sh`; `git diff --check`
- **Rollback:** Remove pointers/test registration and stop validator invocation.
- **Status:** `proposed`

### ACV1-W1-007: Run parity review and close Wave 1
- **Priority:** P0
- **Owner role:** independent contract reviewer
- **Dependencies:** ACV1-W1-002, ACV1-W1-003, ACV1-W1-004, ACV1-W1-005, ACV1-W1-006
- **Exact file surfaces:** all Wave 1 surfaces; Wave 1 parity report and Closure Packet
- **Deliverables:** Expected-versus-represented counts, owner/reference audit, negative-fixture review, drift report, correction/reproof, and advance/block decision.
- **Acceptance criteria:** 100% root invariants/classes/proof stages/gate owners; all branches represented; no unexplained parity drift or runtime consumption; full suite unchanged.
- **Tests/commands:** `bash tests/accelerate-contract-v1.sh`; `bash tests/classification-golden.sh`; `bash tests/doctrine-integrity.sh`; `bash tests/all.sh`; `git status --short --branch`
- **Rollback:** Disable observation-only validation and revert only the affected task-scoped bounded commits.
- **Status:** `proposed`

## Wave 2: Adaptive Gates In Shadow Mode

### ACV1-W2-001: Freeze adaptive scenario denominator and input contract
- **Priority:** P0
- **Owner role:** adaptive policy architect
- **Dependencies:** ACV1-W1-007
- **Exact file surfaces:** `tests/fixtures/accelerate-contract-v1/adaptive-scenarios.json` (new and solely owned here), active Wave 2 Packet, `planning/execution/accelerate-contract-v1-wave-denominator.json`
- **Deliverables:** At least 15 frozen scenarios, explicit context enums/defaults, expected class/mode/canonical outcome/branch/complete gate partition/artifacts/evidence/reasons/shadow action, exclusions, count, and digest.
- **Acceptance criteria:** Includes all plan scenarios and class/mode confusion traps; missing blocking facts do not default; membership changes require re-freeze.
- **Tests/commands:** `bash tests/accelerate-contract-v1.sh`; `bash tests/classification-golden.sh`
- **Rollback:** Remove only the unaccepted scenario corpus/packet and retain Wave 1 observation-only contract.
- **Status:** `proposed`

### ACV1-W2-002: Write adaptive matrix, determinism, and negative tests
- **Priority:** P0
- **Owner role:** policy test engineer
- **Dependencies:** ACV1-W2-001
- **Exact file surfaces:** `tests/adaptive-gate-matrix-v1.sh` (new), `tests/fixtures/accelerate-contract-v1/adaptive-scenarios.json`, `tests/fixtures/accelerate-contract-v1/adaptive-invalid-unknown-gate.json` (new), `tests/fixtures/accelerate-contract-v1/adaptive-invalid-relaxation.json` (new), `tests/fixtures/accelerate-contract-v1/adaptive-invalid-priority-conflict.json` (new)
- **Deliverables:** Scenario class/mode/outcome/gate/shadow-action assertions, byte-determinism test, invalid matrix tests, and no-enforcement guard.
- **Acceptance criteria:** Unknown gates, relaxation operators, ambiguous priority conflicts, authority attacks, and fail-open inputs reject with stable labels; test is red before evaluator exists.
- **Tests/commands:** `bash tests/adaptive-gate-matrix-v1.sh`; `bash tests/adaptive-gate-matrix-v1.sh --no-active-consumer`
- **Rollback:** Remove test/fixtures only; runtime remains unchanged.
- **Status:** `proposed`

### ACV1-W2-003: Extend contract and validator for matrix linkage
- **Priority:** P0
- **Owner role:** contract validator engineer
- **Dependencies:** ACV1-W2-002
- **Exact file surfaces:** `core/contracts/v1/accelerate-contract.schema.json`, `core/contracts/v1/accelerate-contract.json`, `scripts/validate-accelerate-contract.py`, `tests/accelerate-contract-v1.sh`
- **Deliverables:** Matrix descriptor and validation for ID/version/path, `shadow` mode, additive-only operators, gate references, unique rules, deterministic priorities, and root non-relaxation.
- **Acceptance criteria:** Linkage is contained and valid; matrix cannot remove/exclude/disable; previous fixtures remain green; missing matrix fails clearly.
- **Tests/commands:** `bash tests/accelerate-contract-v1.sh`; `python3 scripts/validate-accelerate-contract.py --root . --run core/contracts/v1/accelerate-contract.json`
- **Rollback:** Remove matrix linkage while preserving Wave 1 contract.
- **Status:** `proposed`

### ACV1-W2-004: Implement adaptive matrix and shadow evaluator
- **Priority:** P0
- **Owner role:** policy engine engineer
- **Dependencies:** ACV1-W2-003
- **Exact file surfaces:** `core/contracts/v1/adaptive-gate-matrix.schema.json` (new), `core/contracts/v1/adaptive-gate-matrix.json` (new), `core/contracts/v1/schemas/lane.schema.json` (new), `core/contracts/v1/schemas/wave.schema.json` (new), `core/contracts/v1/schemas/incident.schema.json` (new), `scripts/evaluate-adaptive-gates.py` (new)
- **Deliverables:** Immutable 18-core-gate partition, lane/wave/incident schemas, smallest doctrine-backed rule set, explicit input validation, approved operators, deterministic additive union, and shadow workflow actions separate from persisted mode/outcome.
- **Acceptance criteria:** Same input is byte-deterministic; evaluator guesses no
blocking fact; conflicts are visible; root laws remain intact; all gate IDs
exist; output stays shadow-only until accepted `ACV1-W5-007` cutover.
- **Tests/commands:** `bash tests/adaptive-gate-matrix-v1.sh`; `bash tests/accelerate-contract-v1.sh`; `python3 scripts/evaluate-adaptive-gates.py --help`
- **Rollback:** Stop shadow evaluation and revert matrix/evaluator; Wave 1 behavior-neutral contract remains.
- **Status:** `proposed`

### ACV1-W2-005: Prove adaptive parity and correction coverage
- **Priority:** P0
- **Owner role:** quality governance lead
- **Dependencies:** ACV1-W2-004
- **Exact file surfaces:** `tests/fixtures/accelerate-contract-v1/adaptive-scenarios.json`, `.tmp/accelerate-contract-v1-wave-2-coverage.json` (temporary), Wave 2 Closure Packet
- **Deliverables:** Per-scenario owner citations, classification/gates/decision/reason comparison, coverage report, residual classification, and correction/reproof loops.
- **Acceptance criteria:** Mandatory root-invariant coverage is 100%; overall parity >=95%; no authority/fail-open/root miss waived; evaluator remains shadow-only until accepted Wave 5 cutover.
- **Tests/commands:** `python3 global-runtime/accelerate/scripts/wave_gate_report.py .tmp/accelerate-contract-v1-wave-2-coverage.json --format packet`; `bash tests/adaptive-gate-matrix-v1.sh --no-active-consumer`
- **Rollback:** Invalidate report on denominator/rule change and rerun from frozen expectations; remove temporary report after evidence capture.
- **Status:** `proposed`

### ACV1-W2-006: Register, regress, independently review, and close Wave 2
- **Priority:** P0
- **Owner role:** independent policy reviewer
- **Dependencies:** ACV1-W2-002, ACV1-W2-003, ACV1-W2-004, ACV1-W2-005
- **Exact file surfaces:** `core/control-plane/README.md`, `core/control-plane/authority-graph-v1.md`, `tests/doctrine-integrity.sh`, all Wave 2 surfaces, Wave 2 Closure Packet
- **Deliverables:** Ownership pointers, shadow edges, test registration, precedence/fail-closed review, fresh focused/full proof, and advance/block decision.
- **Acceptance criteria:** No enforcement call site or generated/user-home edit;
focused no-active-consumer guard passes while documentation mentions remain
allowed; shadow persists until accepted Wave 5 cutover; all residuals classify.
- **Tests/commands:** `bash tests/adaptive-gate-matrix-v1.sh`; `bash tests/accelerate-contract-v1.sh`; `bash tests/classification-golden.sh`; `bash tests/doctrine-integrity.sh`; `bash tests/all.sh`; `bash tests/markdown-link-integrity.sh`; `git diff --check`
- **Rollback:** Disable shadow commands and revert only Wave 2’s bounded slice; preserve parity evidence.
- **Status:** `proposed`

## Wave 3: Typed Evidence And Transactional Closure

### ACV1-W3-001: Freeze the nine-capability evidence/closure denominator
- **Priority:** P0
- **Owner role:** closure governance lead
- **Dependencies:** ACV1-W2-006
- **Exact file surfaces:** `.tmp/acv1-wave-3-denominator.json` (temporary), `planning/execution/accelerate-contract-v1-wave-denominator.json`, active Wave 3 Packet
- **Deliverables:** `W3-C01..W3-C09`, including incident correction, count/digest, source revisions, owner assignments, baseline full-suite evidence, and stop conditions.
- **Acceptance criteria:** 9/9 required; triggered core gates have no waiver; no concurrent owner conflict; Waves 1-2 merge/closure identity is recorded.
- **Tests/commands:** `bash tests/all.sh`; `git status --short --branch`; `sha256sum .tmp/acv1-wave-3-denominator.json`
- **Rollback:** Remove temporary denominator only after recording its digest; preserve predecessor evidence.
- **Status:** `proposed`

### ACV1-W3-002: Define typed evidence, invalidation, and closure schemas
- **Priority:** P0
- **Owner role:** evidence schema maintainer
- **Dependencies:** ACV1-W3-001
- **Exact file surfaces:** `core/contracts/v1/schemas/evidence.schema.json` (new), `core/contracts/v1/schemas/invalidation-event.schema.json` (new), `core/contracts/v1/schemas/dependency-graph.schema.json` (new), `core/contracts/v1/schemas/resource.schema.json` (new), `core/contracts/v1/schemas/review.schema.json` (new), `core/contracts/v1/schemas/validation-receipt.schema.json` (new), `core/contracts/v1/schemas/closure-receipt.schema.json` (new), `core/control-plane/contract-lifecycle.md` (new), `core/closure/transactional-closure.md` (new), `core/runtime-packets/contract-v1-templates.md` (new), `tests/evidence-closure-contract.sh` (new), `tests/fixtures/evidence-closure/valid/evidence.json` (new), `tests/fixtures/evidence-closure/invalid/untyped-evidence.json` (new)
- **Deliverables:** Exact closed SDD evidence envelope/types, including
`working_directory` and no top-level `command_digest`, complete
subject-to-closure DAG, resource/review/receipt shapes, `closing` rules,
successor-run terminal semantics, and red/green fixtures.
- **Acceptance criteria:** Untyped/unknown/absolute-path records and candidates without frozen gates reject; timestamps/digests are bounded and canonical; all required plan evidence kinds exist.
- **Tests/commands:** `bash tests/evidence-closure-contract.sh`
- **Rollback:** Revert schema/test slice before consumers; no history exists yet.
- **Status:** `proposed`

### ACV1-W3-003: Implement typed evidence validation and candidate freshness
- **Priority:** P0
- **Owner role:** evidence engine engineer
- **Dependencies:** ACV1-W3-002
- **Exact file surfaces:** `scripts/accelerate_contract/evidence.py` (new), `scripts/validate-accelerate-contract.py`, `tests/evidence-closure-contract.sh`, `tests/fixtures/evidence-closure/invalid/stale-source-revision.json` (new), `tests/fixtures/evidence-closure/invalid/stale-dependency.json` (new)
- **Deliverables:** `validate`, `candidate`, and `freshness` commands; canonical hashing; revision/input/command/dependency/artifact freshness checks; stable 0/1/2 exits.
- **Acceptance criteria:** Stale valid input exits 1 with reason; malformed exits 2; fresh valid exits 0; evidence identity/history is immutable.
- **Tests/commands:** `python3 scripts/validate-accelerate-contract.py --root . --run tests/fixtures/evidence-closure/invalid/stale-source-revision.json --stage evidence`; `python3 scripts/validate-accelerate-contract.py --root . --run tests/fixtures/evidence-closure/valid/evidence.json --stage evidence`
- **Rollback:** Stop consumers and retain records for forensic readability.
- **Status:** `proposed`

### ACV1-W3-004: Implement append-only invalidation and selective reruns
- **Priority:** P0
- **Owner role:** contract integrity engineer
- **Dependencies:** ACV1-W3-003
- **Exact file surfaces:** `scripts/accelerate_contract/evidence.py`, `scripts/validate-accelerate-contract.py`, `tests/evidence-closure-contract.sh`, `tests/fixtures/evidence-closure/valid/invalidation-ledger.jsonl` (new), `tests/fixtures/evidence-closure/valid/dependency-map.json` (new), `tests/fixtures/evidence-closure/valid/registry.json` (new)
- **Deliverables:** Locked/fsynced append, duplicate/mutation/unknown-ID rejection, full transitive invalidation through evidence/gate/review/acceptance/validation/closure nodes, deterministic rerun plan, and unaffected-proof preservation.
- **Acceptance criteria:** Ledger history never mutates; stale proof cannot close; all and only affected transitive dependants rerun in stable order.
- **Tests/commands:** `python3 scripts/accelerate_contract/evidence.py plan-reruns --registry tests/fixtures/evidence-closure/valid/registry.json --ledger tests/fixtures/evidence-closure/valid/invalidation-ledger.jsonl --dependency-map tests/fixtures/evidence-closure/valid/dependency-map.json --changed-subject repo-tree`; `bash tests/evidence-closure-contract.sh`
- **Rollback:** Freeze closure and conservatively rerun possibly affected proof; never truncate the ledger.
- **Status:** `proposed`

### ACV1-W3-005: Reconcile late-worker results
- **Priority:** P0
- **Owner role:** delegation runtime engineer
- **Dependencies:** ACV1-W3-004
- **Exact file surfaces:** `scripts/accelerate_contract/evidence.py`, `tests/evidence-closure-contract.sh`, `tests/fixtures/evidence-closure/valid/late-worker-result.json` (new), `tests/fixtures/evidence-closure/invalid/obsolete-worker-result.json` (new)
- **Deliverables:** Identity/revision comparison, dependency overlap, `accept|accept-with-selective-reproof|reject-and-rerun`, affected gates, typed reconciliation record, and post-close disposition.
- **Acceptance criteria:** Obsolete/overlapping output cannot overwrite current truth; accepted stale-adjacent output reproofs; a material post-close result creates a successor reconciliation run and never reopens terminal state.
- **Tests/commands:** `bash tests/evidence-closure-contract.sh`
- **Rollback:** Quarantine unconsumed worker output and require root manual reconciliation.
- **Status:** `proposed`

### ACV1-W3-006: Require triggered post-merge and cleanup proof
- **Priority:** P0
- **Owner role:** release and hygiene engineer
- **Dependencies:** ACV1-W3-005
- **Exact file surfaces:** `scripts/accelerate_contract/evidence.py`, `scripts/validate-accelerate-contract.py`, `tests/evidence-closure-contract.sh`, `tests/fixtures/evidence-closure/valid/cleanup-manifest.json` (new)
- **Deliverables:** Triggered merge-commit proof, `not-triggered` skip, managed-resource cleanup proof, `no-managed-resource` skip, governed-junk scan, and artifact protection in fixtures.
- **Acceptance criteria:** Pre-merge proof never implies post-merge; triggered proof/cleanup cannot be waived; coded skips fabricate no evidence; no local-workspace consumer changes in Wave 3.
- **Tests/commands:** `bash tests/evidence-closure-contract.sh`; `git status --short`
- **Rollback:** Restore consumer wiring only as blocked/manual recovery; preserve cleanup and merge receipts.
- **Status:** `proposed`

### ACV1-W3-007: Implement incident correction and manual risk correction
- **Priority:** P0
- **Owner role:** incident governance lead
- **Dependencies:** ACV1-W3-004, ACV1-W3-006
- **Exact file surfaces:** `core/closure/transactional-closure.md`, `core/contracts/v1/schemas/invalidation-event.schema.json`, `core/contracts/v1/schemas/incident.schema.json`, `scripts/accelerate_contract/evidence.py`, `tests/fixtures/evidence-closure/invalid/incident-correction/open.json` (new), `tests/fixtures/evidence-closure/invalid/incident-correction/corrected.json` (new), `tests/evidence-closure-contract.sh`
- **Deliverables:** Incident detection/containment/correction linkage, `manual-risk-correction`, affected evidence invalidation, corrected-state proof, recurrence/follow-up ownership, and closure blocking.
- **Acceptance criteria:** Incident cannot reuse pre-correction proof; corrected evidence is newer; open severity/blocker or missing cleanup prevents close; history and external receipts remain immutable.
- **Tests/commands:** `python3 scripts/validate-accelerate-contract.py --root . --run tests/fixtures/evidence-closure/invalid/incident-correction/open.json --stage graph --reason manual-risk-correction`; `bash tests/evidence-closure-contract.sh`
- **Rollback:** Preserve incident/receipt history, disable faulty automation, and leave candidate `rollback-required` or blocked.
- **Status:** `proposed`

### ACV1-W3-008: Prove transactional closure in shadow fixtures
- **Priority:** P0
- **Owner role:** closure transaction engineer
- **Dependencies:** ACV1-W3-006, ACV1-W3-007
- **Exact file surfaces:** `scripts/accelerate_contract/evidence.py`, `scripts/accelerate_contract/closure.py` (new), `scripts/validate-accelerate-contract.py`, `tests/evidence-closure-contract.sh`, `tests/fixtures/evidence-closure/valid/provider-readback.json` (new), `tests/fixtures/evidence-closure/invalid/provider-readback-mismatch.json` (new)
- **Deliverables:** Fixture lock/CAS/journal/fsync, prepared nonterminal `closing`, provider reconciliation/readback, one logical publish of `closed` plus final receipt/report/readback, race/crash/retry tests.
- **Acceptance criteria:** No observable local `closed` before provider readback; failure stays nonterminal/retryable; exactly one terminal record; Wave 3 remains shadow/fixture-only.
- **Tests/commands:** `for i in {1..10}; do bash tests/evidence-closure-contract.sh || exit 1; done`; `python3 -m py_compile scripts/accelerate_contract/evidence.py scripts/accelerate_contract/closure.py`
- **Rollback:** Revert consumer wiring, preserve schemas/ledgers/journals/last closure, and remove only recorded uncommitted temp files.
- **Status:** `proposed`

### ACV1-W3-009: Verify, independently review, and close Wave 3
- **Priority:** P0
- **Owner role:** independent closure reviewer
- **Dependencies:** ACV1-W3-002, ACV1-W3-003, ACV1-W3-004, ACV1-W3-005, ACV1-W3-006, ACV1-W3-007, ACV1-W3-008
- **Exact file surfaces:** all Wave 3 surfaces; typed proof attachments; Wave 3 Closure Packet
- **Deliverables:** Valid/stale/rerun/worker/incident/interruption/merge/cleanup outputs, 9/9 capability report, reconstructability review, and rollout/rollback decision.
- **Acceptance criteria:** 100% coverage; no unclassified residual; local workspace tests/full suite/links pass; reviewer reconstructs close without chat history.
- **Tests/commands:** `python3 -m py_compile scripts/accelerate_contract/evidence.py scripts/accelerate_contract/closure.py`; `bash tests/evidence-closure-contract.sh`; `bash tests/local-workspace-proof-gates.sh`; `bash tests/local-workspace-scenario-matrix.sh`; `bash tests/markdown-link-integrity.sh`; `bash tests/all.sh`; `git diff --check`
- **Rollback:** Reopen Wave 3, preserve all history, and return closure consumer to blocked/manual recovery.
- **Status:** `proposed`

## Wave 4: Eval, Schema, Package, And CI Enforcement

### ACV1-W4-001: Freeze eval and seven-capability denominators
- **Priority:** P0
- **Owner role:** evaluation governance lead
- **Dependencies:** ACV1-W3-009
- **Exact file surfaces:** `evals/contract-v1/denominator.json` (new), `planning/execution/accelerate-contract-v1-wave-denominator.json`, active Wave 4 Packet
- **Deliverables:** Sorted case IDs/count/digest/selection/exclusions/change policy plus `W4-C01..W4-C07`; coverage for six scenario labels, three classes, four modes, all 18 core gates, nine outcomes, ambiguity/FP/FN/stale denominator, and three incident variants.
- **Acceptance criteria:** 100% case and 7/7 capability threshold; membership drift blocks; scenario/action labels never persist as modes/outcomes; predecessor proof is fresh.
- **Tests/commands:** `bash tests/all.sh`; `python3 -m json.tool evals/contract-v1/denominator.json` after this task creates it; no future eval test/runner command
- **Rollback:** Preserve frozen denominator/report and stop eval enforcement; never lower coverage by deleting cases.
- **Status:** `proposed`

### ACV1-W4-002: Define eval schemas and canonical corpus
- **Priority:** P0
- **Owner role:** eval schema maintainer
- **Dependencies:** ACV1-W4-001
- **Exact file surfaces:** `core/contracts/v1/schemas/eval-case.schema.json` (new), `core/contracts/v1/schemas/eval-result.schema.json` (new), `evals/contract-v1/cases.json` (new), `evals/contract-v1/denominator.json` (owned by ACV1-W4-001), `tests/contract-v1-evals.sh` (new)
- **Deliverables:** Closed case/result structures and tested scenario/class/mode/gate/outcome/action mappings tied exactly to denominator IDs.
- **Acceptance criteria:** IDs unique; vocabularies closed; mode/outcome compatible; incident/wave fields required; corpus/denominator exact; focused test is red before runner.
- **Tests/commands:** `bash tests/contract-v1-evals.sh`
- **Rollback:** Remove unaccepted corpus/schema/test while preserving Wave 3 evidence.
- **Status:** `proposed`

### ACV1-W4-003: Implement structured eval assertions
- **Priority:** P0
- **Owner role:** evaluation runner engineer
- **Dependencies:** ACV1-W4-002
- **Exact file surfaces:** `scripts/run-contract-evals.py` (new), `tests/contract-v1-evals.sh`, `tests/fixtures/contract-v1-evals/valid/full.json` (new), `tests/fixtures/contract-v1-evals/invalid/wrong-mode.json` (new), `tests/fixtures/contract-v1-evals/invalid/missing-required-gate.json` (new), `tests/fixtures/contract-v1-evals/invalid/forbidden-gate.json` (new), `tests/fixtures/contract-v1-evals/invalid/incompatible-outcome.json` (new), `tests/fixtures/contract-v1-evals/invalid/missing-incident-gate.json` (new), `tests/fixtures/contract-v1-evals/invalid/executed-subset.json` (new)
- **Deliverables:** Corpus validation, observed trigger/mode/gates/outcome/explanation assertions, deterministic JSON, supplemental required-term checks, stable pass/failure classes, and 0/1/2 exits.
- **Acceptance criteria:** Runner calls no model/fixture command; structured comparisons are not substring scoring; missing incident gate and incompatible outcomes fail; complete observations report 100%.
- **Tests/commands:** `python3 scripts/run-contract-evals.py --help`; `bash tests/contract-v1-evals.sh`
- **Rollback:** Disable runner gating but retain corpus and failed cases.
- **Status:** `proposed`

### ACV1-W4-004: Enforce eval denominator membership and coverage
- **Priority:** P0
- **Owner role:** coverage engineer
- **Dependencies:** ACV1-W4-003
- **Exact file surfaces:** `scripts/run-contract-evals.py`, `tests/contract-v1-evals.sh`, `tests/fixtures/contract-v1-evals/invalid/denominator-added.json` (new), `tests/fixtures/contract-v1-evals/invalid/denominator-removed.json` (new), `tests/fixtures/contract-v1-evals/invalid/denominator-renamed.json` (new), `tests/fixtures/contract-v1-evals/invalid/denominator-duplicate.json` (new), `tests/fixtures/contract-v1-evals/invalid/denominator-skipped.json` (new), `tests/fixtures/contract-v1-evals/valid/denominator-reordered.json` (new)
- **Deliverables:** Canonical sorted-ID digest verification and added/removed/renamed/duplicate/skipped/reordered tests.
- **Acceptance criteria:** Reorder does not drift; membership does; denominator is frozen cases, not executed subset; missing/extra IDs block.
- **Tests/commands:** `bash tests/contract-v1-evals.sh`; `python3 scripts/run-contract-evals.py coverage --cases evals/contract-v1/cases.json --denominator evals/contract-v1/denominator.json`
- **Rollback:** Invalidate affected reports and require reviewed re-freeze; never silently normalize membership.
- **Status:** `proposed`

### ACV1-W4-005: Implement repository source package validation
- **Priority:** P0
- **Owner role:** package integrity engineer
- **Dependencies:** ACV1-W4-004
- **Exact file surfaces:** `scripts/validate-contract-package.py` (new), `tests/contract-package-validator.sh` (new), `tests/fixtures/contract-v1-package/valid/package.json` (new), `tests/fixtures/contract-v1-package/invalid/cases.json` (new)
- **Deliverables:** Explicit-root canonical `core/contracts/v1/` allowlist/digest/mode/path/symlink/local-ref/authority checks and missing/extra/drift fixtures.
- **Acceptance criteria:** Repository package is authoritative; path/mode/content/schema/authority drift fails; `--package-root` is required; no `global-runtime/`, sync, mirror, exporter, or manifest mutation.
- **Tests/commands:** `bash tests/contract-package-validator.sh`
- **Rollback:** Stop export and use repository source; preserve failed report and frozen corpus.
- **Status:** `proposed`

### ACV1-W4-006: Implement semantic schema validation
- **Priority:** P0
- **Owner role:** schema test engineer
- **Dependencies:** ACV1-W3-002, ACV1-W4-005
- **Exact file surfaces:** `scripts/validate-contract-schemas.py` (new), `core/contracts/v1/schemas/release-backup-manifest.schema.json` (new), `tests/contract-v1-schema-semantic.sh` (new), `tests/fixtures/contract-v1-schemas/valid/cases.json` (new), `tests/fixtures/contract-v1-schemas/invalid/cases.json` (new)
- **Deliverables:** Schema-document lint and cross-field checks for time order, evidence, incident containment, core-waiver rejection, governed extension/profile waivers, closure/post-merge revision, and typed Wave 5 prior-release backup manifests.
- **Acceptance criteria:** Every v1 schema has valid/invalid fixtures; each invalid case declares its expected label; the accepted Draft 2020-12 engine and custom semantic stages are both run and reported distinctly.
- **Tests/commands:** `bash tests/contract-v1-schema-semantic.sh`; `python3 -m py_compile scripts/validate-contract-schemas.py`
- **Rollback:** Block new closure records, preserve old Wave 3 evidence, and revert defective semantic gating only.
- **Status:** `proposed`

### ACV1-W4-007: Enforce authority, links, CI, and forensic validation
- **Priority:** P0
- **Owner role:** CI governance maintainer
- **Dependencies:** ACV1-W4-005, ACV1-W4-006
- **Exact file surfaces:** `tests/authority-set-gate.sh`, `tests/markdown-link-integrity.sh`, `tests/ci-contract.sh`, `tests/contract-v1-evals.sh`, `tests/contract-package-validator.sh`, `tests/contract-v1-schema-semantic.sh`, `scripts/validate-accelerate-contract-v1-forensic.py` (new), `tests/accelerate-contract-v1-forensic.sh` (new)
- **Deliverables:** Negative authority/link/path fixtures, forensic CLI TDD for `--catalog`, `--checklist`, and `--final`, command/file sequencing and owner/parity checks, and CI registration.
- **Acceptance criteria:** User-home/generated authority, missing/absolute/escaping links, and manifest targets outside repo fail; local/CI proof uses the same commands.
- **Tests/commands:** `bash tests/accelerate-contract-v1-forensic.sh`; `python3 scripts/validate-accelerate-contract-v1-forensic.py --catalog planning/executive/accelerate-contract-v1-task-catalog.md`; `python3 scripts/validate-accelerate-contract-v1-forensic.py --checklist planning/executive/accelerate-contract-v1-validation-checklist.md`; `bash tests/authority-set-gate.sh`; `bash tests/markdown-link-integrity.sh`; `bash tests/ci-contract.sh`
- **Rollback:** Remove only defective CI wiring, retain reports/denominators, and keep source authoritative.
- **Status:** `proposed`

### ACV1-W4-008: Verify, independently review, and close Wave 4
- **Priority:** P0
- **Owner role:** independent evaluation reviewer
- **Dependencies:** ACV1-W4-002, ACV1-W4-003, ACV1-W4-004, ACV1-W4-005, ACV1-W4-006, ACV1-W4-007
- **Exact file surfaces:** all Wave 4 surfaces; typed eval/package/schema/authority/link proof; Wave 4 Closure Packet
- **Deliverables:** 7/7 capability and 100% case reports, negative-class proof, source-package inventory, forensic structure proof, correction/reproof, and advance/block decision.
- **Acceptance criteria:** All IDs execute; no denominator/source-package drift; incident/safety/mapping cases pass; full suite green; no generated-runtime mutation.
- **Tests/commands:** `python3 -m py_compile scripts/run-contract-evals.py scripts/validate-contract-package.py scripts/validate-contract-schemas.py scripts/validate-accelerate-contract-v1-forensic.py`; `bash tests/contract-v1-evals.sh`; `bash tests/contract-package-validator.sh`; `bash tests/contract-v1-schema-semantic.sh`; `bash tests/accelerate-contract-v1-forensic.sh`; `bash tests/authority-set-gate.sh`; `bash tests/markdown-link-integrity.sh`; `bash tests/all.sh`; `git diff --check`
- **Rollback:** Revert defective enforcement wiring, preserve denominators/reports, and block exports/closure affected by failed validators.
- **Status:** `proposed`

## Wave 5: Optional Runtime Integration, Export, And Final Closure

### ACV1-W5-001: Freeze integration/provider/export denominator and entry proof
- **Priority:** P0
- **Owner role:** runtime integration lead
- **Dependencies:** ACV1-W3-009, ACV1-W4-008
- **Exact file surfaces:** `.accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json` (runtime packet), `.accelerate/locks/contract-v1-wave-5-run-key.lock` (runtime lock), `scripts/contract-v1-run-key.py` (new), `core/contracts/v1/schemas/run-key-initialization-intent.schema.json` (new), `core/contracts/v1/schemas/run-key-initialization-receipt.schema.json` (new), `planning/evidence/contract-v1-wave-5-run-key-initialization-intent.json` (new write-once execution evidence), `planning/evidence/contract-v1-wave-5-run-key-initialization.json` (new write-once execution evidence), `tests/contract-v1-run-key.sh` (new), `tests/fixtures/contract-v1-run-key/valid/initialization-intent.json` (new), `tests/fixtures/contract-v1-run-key/valid/initialization-receipt.json` (new), `tests/fixtures/contract-v1-run-key/valid/crash-after-intent.json` (new), `tests/fixtures/contract-v1-run-key/valid/crash-after-packet.json` (new), `tests/fixtures/contract-v1-run-key/valid/crash-after-anchor.json` (new), `tests/fixtures/contract-v1-run-key/invalid/valid-format-key-mutation.json` (new), `tests/fixtures/contract-v1-run-key/invalid/receipt-pointer-mutation.json` (new), `tests/fixtures/contract-v1-run-key/invalid/packet-digest-mutation.json` (new), `tests/fixtures/contract-v1-run-key/invalid/receipt-overwrite.json` (new), `tests/fixtures/contract-v1-run-key/invalid/intent-packet-mismatch.json` (new), `tests/fixtures/contract-v1-run-key/invalid/intent-anchor-mismatch.json` (new), `tests/fixtures/contract-v1-run-key/invalid/downstream-artifact-before-anchor.json` (new), `tests/fixtures/contract-v1-run-key/invalid/intent-tamper.json` (new), `planning/execution/accelerate-contract-v1-wave-denominator.json`, current generated runtime manifest/digests
- **Deliverables:** `W5-C01..W5-C12`; exclusive initialization lock; fixed O_EXCL intent containing the sole proposed key plus canonical packet bytes/digest and expected final packet mode; exact fully sealed/fsynced packet publication; fixed O_EXCL final anchor binding packet mode; closed schemas; crash/recovery and tamper fixtures; anchored loader proof.
- **Acceptance criteria:** Initialization persists/fsyncs immutable intent first; atomically publishes exactly its packet bytes, applies/verifies intent mode, and fsyncs the sealed packet and parent second; and O_EXCL-creates/fsyncs final anchor third as the last durable initialization operation. No packet write/chmod/seal occurs afterward. Locked retry never generates a new key: matching intent-only or intent+packet states resume, while complete matching state validates mode against intent/anchor and returns read-only idempotent success with bytes, modes, and mtimes unchanged. Mismatch, tamper, invalid stage, or downstream keyed artifact before anchor fails closed; intent/anchor are never overwritten; `--load` validates all three records including packet mode without mutation.
- **Tests/commands:** `bash tests/contract-v1-run-key.sh` (expected red before helper, green after); one `python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --initialize`; later `RUN_KEY="$(python3 scripts/contract-v1-run-key.py --root . --packet .accelerate/workflow/active/accelerate-contract-v1-wave-5-entry.json --load)"`; `bash tests/all.sh`; `git status --short --branch`; `rg -n '\$HOME|~/.claude|~/.codex|~/.agents' global-runtime scripts adapters onboarding`
- **Rollback:** Disable Wave 5 and preserve immutable intent and final anchor; never delete, overwrite, repair, or rebind either record to another packet/key.
- **Status:** `proposed`

### ACV1-W5-002: Define optional runtime adapter, read-only check, and explicit atomic install/upgrade
- **Priority:** P0
- **Owner role:** local runtime adapter engineer
- **Dependencies:** ACV1-W5-001
- **Exact file surfaces:** `adapters/runtime/accelerate-contract-v1/capabilities.yaml` (new), `adapters/runtime/accelerate-contract-v1/README.md` (new), `adapters/runtime/accelerate-contract-v1/installation-manifest.schema.json` (new), `adapters/runtime/codex/contract-extension.yaml` (new), `adapters/runtime/opencode/contract-extension.yaml` (new), `adapters/runtime/claude/contract-extension.yaml` (new), `adapters/runtime/hermes/contract-extension.yaml` (new), `adapters/workflow/local/contract-extension.yaml` (new), `core/contracts/v1/extension-registry.yaml`, `adapters/runtime/codex/capabilities.yaml`, `adapters/runtime/opencode/capabilities.yaml`, `adapters/runtime/claude/capabilities.yaml`, `adapters/runtime/hermes/capabilities.yaml`, `onboarding/local-workspace/integrate-contract-v1.sh` (new), `onboarding/local-workspace/restore-contract-v1.sh` (new), `tests/contract-v1-runtime-integration.sh` (new), `tests/contract-v1-extension-registry.sh` (new), `tests/fixtures/contract-v1-adapters/extensions/invalid-core-namespace.yaml` (new), `tests/fixtures/contract-v1-adapters/extensions/invalid-external-authority.yaml` (new), `tests/fixtures/contract-v1-adapters/extensions/missing-supported-version.yaml` (new), `tests/fixtures/contract-v1-runtime-integration/predecessor-installation.json` (new), `tests/fixtures/contract-v1-runtime-integration/invalid-installation-digest.json` (new), `tests/fixtures/contract-v1-runtime-integration/rollback-readback.json` (new)
- **Deliverables:** Read-only check; explicit install/upgrade with a validated write-once predecessor backup before manifest or mutation; installation manifest and dedicated project-local restore/readback; plus five source-owned extension manifests and negative fixtures.
- **Acceptance criteria:** Install/upgrade refuses backup overwrite, inventories and validates every managed path/mode/digest before staging the installation manifest or managed files, then publishes manifest and managed replacements as one atomic/idempotent transaction; failure leaves manifest and managed state unchanged. Workspace rollback requires explicit project root, installation manifest, predecessor version and valid backup digest, restores only managed files atomically, and emits workspace-specific readback/receipt; runtime export restore cannot satisfy workspace proof; extensions remain namespaced/source-owned.
- **Tests/commands:** `bash tests/contract-v1-extension-registry.sh` (expected red with missing Codex manifest before any manifest creation, green after registration); `bash tests/contract-v1-runtime-integration.sh`
- **Rollback:** Use only `restore-contract-v1.sh` with explicit project root,
installation manifest and predecessor version; preserve unrelated `.accelerate/`
state/evidence. Never use generated-runtime restore as workspace proof.
- **Status:** `proposed`

### ACV1-W5-003: Wire bootstrap, materialization, validation, and reentry
- **Priority:** P0
- **Owner role:** onboarding integration engineer
- **Dependencies:** ACV1-W5-002
- **Exact file surfaces:** `onboarding/local-workspace/bootstrap-or-reentry.sh`, `onboarding/local-workspace/emit-v2.sh`, `onboarding/local-workspace/validate-v2.sh`, `onboarding/local-workspace/read-local-handoff.sh`, `onboarding/local-workspace/check-evidence-gate.sh`, `onboarding/local-workspace/prepare-closure.sh`, `onboarding/local-workspace/v2-materialization-contract.md`, `tests/contract-v1-runtime-integration.sh`
- **Deliverables:** Deterministic integration classifications, explicit materialization, V2 preservation, handoff status/gaps, and disabled evidence/closure compatibility hooks pending ACV1-W5-007 preflight.
- **Acceptance criteria:** No auto-install; only contract-owned files change; all classifications are deterministic; no unrelated workspace state mutates.
- **Tests/commands:** `bash tests/contract-v1-runtime-integration.sh`; `bash tests/local-workspace-scenario-matrix.sh`
- **Rollback:** Disable integration routing and retain installed state/readback for forensic inspection.
- **Status:** `proposed`

### ACV1-W5-004: Define and normalize backend-neutral workflow readback
- **Priority:** P0
- **Owner role:** workflow contract engineer
- **Dependencies:** ACV1-W5-003
- **Exact file surfaces:** `core/runtime-packets/schemas/workflow-readback-v1.schema.json` (new), `adapters/workflow/readback-contract-v1.md` (new), `scripts/normalize-workflow-readback.py` (new), `tests/fixtures/workflow-readback/local-valid.json` (new), `tests/fixtures/workflow-readback/github-valid.json` (new), `tests/fixtures/workflow-readback/linear-valid.json` (new), `tests/fixtures/workflow-readback/missing-id.json` (new), `tests/fixtures/workflow-readback/fabricated-pr.json` (new), `tests/fixtures/workflow-readback/unmapped-state.json` (new), `tests/fixtures/workflow-readback/malformed.json` (new), `tests/fixtures/workflow-readback/api-error.json` (new), `tests/fixtures/workflow-readback/auth-error.json` (new), `tests/fixtures/workflow-readback/rate-limit.json` (new), `tests/fixtures/workflow-readback/stale.json` (new), `tests/workflow-readback-v1.sh` (new)
- **Deliverables:** Provider-neutral issue/PR packet, local/GitHub/Linear normalization, stable gaps/digest/freshness, and malformed/API/auth/rate-limit/stale tests.
- **Acceptance criteria:** Missing fields are null plus gap, never fabricated; stale/unavailable cannot report available; provider statuses stay adapter-owned; exits 0/1/2 are honest.
- **Tests/commands:** `bash tests/workflow-readback-v1.sh`; `python3 -m py_compile scripts/normalize-workflow-readback.py`
- **Rollback:** Mark affected readback capability blocked and retain raw digest/evidence; no provider write occurred.
- **Status:** `proposed`

### ACV1-W5-005: Select workflow adapters by capability and freshness
- **Priority:** P0
- **Owner role:** workflow adapter maintainer
- **Dependencies:** ACV1-W5-004
- **Exact file surfaces:** four explicit child-slice blocks; their union is the complete primary-task surface and every path remains repository-relative.
  - **Provider And Capability Selection:** `onboarding/local-workspace/read-workflow-capabilities.sh`, `onboarding/local-workspace/select-workflow-capability.sh`, `onboarding/local-workspace/read-github-pr-adapter.sh`, `onboarding/local-workspace/read-linear-adapter.sh`, `tests/workflow-readback-v1.sh`, `tests/workflow-backend-neutrality.sh`.
  - **Version And Adapter Conformance:** `adapters/workflow/local/capabilities.yaml`, `adapters/workflow/github-pr/capabilities.yaml`, `adapters/workflow/github-issues/capabilities.yaml`, `adapters/workflow/linear/capabilities.yaml`, `adapters/runtime/python-uv/capabilities.yaml`, `adapters/runtime/node/capabilities.yaml`, `adapters/runtime/browser/capabilities.yaml`, `adapters/runtime/agent-browser/capabilities.yaml`, `adapters/runtime/physical-agent/capabilities.yaml`, `adapters/runtime/locale-pack-parity/capabilities.yaml`, `adapters/runtime/web-content-reader/capabilities.yaml`, `adapters/runtime/tailwind/capabilities.yaml`, `adapters/runtime/document-export/capabilities.yaml`, `adapters/runtime/model-voice/capabilities.yaml`, `adapters/runtime/chrome-devtools/capabilities.yaml`, `adapters/runtime/playwright/capabilities.yaml`, `adapters/runtime/proof-fixtures/capabilities.yaml`, `tests/contract-v1-adapter-conformance.sh` (new), `tests/fixtures/contract-v1-adapters/conformance/valid.json` (new), `tests/fixtures/contract-v1-adapters/conformance/missing-supported-version.json` (new), `tests/fixtures/contract-v1-adapters/conformance/unsupported-version.json` (new).
  - **Hermes Interoperability:** `tests/fixtures/contract-v1-adapters/hermes/valid.json` (new), `tests/fixtures/contract-v1-adapters/hermes/invalid-external-authority.json` (new), `tests/fixtures/contract-v1-adapters/hermes/unsupported-version.json` (new); reads predecessor-owned `adapters/runtime/hermes/capabilities.yaml`, `adapters/runtime/hermes/contract-extension.yaml`, and `tests/contract-v1-adapter-conformance.sh` without duplicating create ownership.
  - **Legacy Migration:** `scripts/migrate-accelerate-contract-v1.py` (new), `tests/contract-v1-migration.sh` (new), `tests/fixtures/contract-v1-migration/valid/legacy-wave-gated.json` (new), `tests/fixtures/contract-v1-migration/valid/legacy-closure-packet.json` (new), `tests/fixtures/contract-v1-migration/expected/wave-v1.json` (new), `tests/fixtures/contract-v1-migration/expected/closure-v1.json` (new), `tests/fixtures/contract-v1-migration/invalid/lossy-conversion.json` (new), `tests/fixtures/contract-v1-migration/invalid/dual-write.json` (new), `tests/fixtures/contract-v1-migration/invalid/unsupported-version.json` (new).
- **Deliverables:** Four formal child slices within primary ID `ACV1-W5-005`:
Provider And Capability Selection (workflow capability selection engineer),
Version And Adapter Conformance (adapter compatibility engineer), Hermes
Interoperability (Hermes interoperability maintainer), and Legacy Migration
(migration engineer); each has exact surfaces, red/green proof, rollback
checkpoint, and task-scoped inseparable commit boundary.
- **Acceptance criteria:** D016 is accepted before Green; no implicit provider
wins/writes; every adapter has tested version bounds; migration defaults to no
writes, supports only `unversioned|0 -> 1`, requires explicit contained output
for apply, rejects lossy conversion and dual write, validates v1 output, and
never makes legacy/external state authority; every child slice closes its own
proof, rollback checkpoint, and bounded commit boundary without becoming a task
ID or alias.
- **Tests/commands:** `bash tests/contract-v1-adapter-conformance.sh` (expected red before manifest implementation, green after); `bash tests/contract-v1-migration.sh` (expected red before tool creation, green after); `bash tests/workflow-readback-v1.sh`; `bash tests/workflow-backend-neutrality.sh`; `bash tests/contract-v1-extension-registry.sh`
- **Rollback:** Apply the named child checkpoint only: block/revert provider
selection, version/conformance, Hermes translation, or migration independently;
preserve sibling slices, legacy inputs and accepted v1 output; never resume dual
write or silently select another provider.
- **Status:** `proposed`

### ACV1-W5-006: Generate global runtime deterministically from source
- **Priority:** P0
- **Owner role:** runtime export engineer
- **Dependencies:** ACV1-W4-005, ACV1-W5-005
- **Exact file surfaces:** `scripts/snapshot-global-runtime.py` (new), `scripts/export-global-runtime.py` (new), `scripts/restore-global-runtime.py` (new), `scripts/validate-historical-runtime.py` (new), `scripts/demote-accelerate-contract-v1.py` (new), `scripts/validate-runtime-package.py` (new), `scripts/verify-contract-v1-rollback-lanes.sh` (new), `global-runtime/accelerate/export-manifest.json` (generated), `global-runtime/accelerate/evals/evals.json` (generated), `planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-runtime-${RUN_KEY}/` (new execution evidence), `planning/evidence/dated-proof-appendix/accelerate-contract-v1-prior-release-backup-${RUN_KEY}.json` (new), `scripts/sync-skills-to-global.sh`, `tests/global-runtime-snapshot-v1.sh` (new), `tests/contract-v1-source-demotion.sh` (new), `tests/contract-v1-rollback-lanes.sh` (new), `tests/global-runtime-export-v1.sh` (new), `tests/runtime-package-validator.sh` (new)
- **Deliverables:** Anchored `RUN_KEY`; snapshot/export/source/history/host tooling and receipts; operational ordered fail-fast verifier under `scripts/`; safe non-mutating auto-discovered test wrapper under `tests/` whose no-arg behavior equals `--self-test`.
- **Acceptance criteria:** The operational verifier requires explicit packet/targets and runs workspace, source/export, history, then optional host, stopping on first failure and preserving distinct keyed statuses/receipts. The test wrapper rejects operational targets, uses temporary fixtures only, is safe with no arguments, and proves no-arg/`--self-test` equivalence without mutating repository, workspace, generated export, or host state.
- **Tests/commands:** load anchored `RUN_KEY`; `bash tests/global-runtime-snapshot-v1.sh`; `bash tests/contract-v1-source-demotion.sh`; `bash tests/contract-v1-rollback-lanes.sh`; `bash tests/global-runtime-export-v1.sh`; invoke `bash scripts/verify-contract-v1-rollback-lanes.sh` only with explicit diagnostic/rollback targets; package validation; Python compile checks.
- **Rollback:** Demote manifest-listed canonical source/registry/selection to the accepted predecessor, emit its receipt, regenerate repository export, and only then run normal parity. Use immutable snapshot bytes only for manifest-bound historical validation under `/tmp`. Restore an optional host only from that target's explicit backup manifest/receipt. No lane claims project-local restoration.
- **Status:** `proposed`

### ACV1-W5-007: Enforce drift, cut over closure, and integrate CI
- **Priority:** P0
- **Owner role:** release tooling engineer
- **Dependencies:** ACV1-W5-006
- **Exact file surfaces:** `scripts/check-global-skill-mirror.sh`, `tests/global-runtime-export-v1.sh`, `tests/workflow-backend-neutrality.sh`, `tests/ci-contract.sh`, `onboarding/local-workspace/close-evidence-transaction.sh` (new), `onboarding/local-workspace/check-evidence-gate.sh`, `onboarding/local-workspace/prepare-closure.sh`, `onboarding/local-workspace/emit-v2.sh`, `onboarding/local-workspace/validate-v2.sh`, `onboarding/local-workspace/v2-materialization-contract.md`, `tests/contract-v1-runtime-integration.sh`, `tests/contract-v1-closure-cutover.sh` (new), `tests/fixtures/contract-v1-closure-cutover/valid-logical-commit.json` (new), `tests/fixtures/contract-v1-closure-cutover/early-closed.json` (new), `tests/fixtures/contract-v1-closure-cutover/provider-readback-mismatch.json` (new), `tests/fixtures/contract-v1-closure-cutover/partial-publication.json` (new), `tests/fixtures/contract-v1-closure-cutover/predecessor-path-retained.json` (new)
- **Deliverables:** Explicit-root drift/CI plus red-first authoritative consumer cutover tests before wiring, after all required preflight.
- **Acceptance criteria:** Early `closed`, provider mismatch, partial publication,
and predecessor closure-success retention fail at the actual consumer boundary;
valid logical commit passes; run-key and rollback-aggregate suites plus all Wave 5 focused suites are in CI; source and
package roots are explicit; no user-home/default target; historical bytes cannot
satisfy current-source parity.
- **Tests/commands:** `bash tests/contract-v1-closure-cutover.sh` (expected red before wiring, green after); `bash scripts/check-global-skill-mirror.sh --source-root . --package-root global-runtime/accelerate`; `bash tests/contract-v1-run-key.sh`; `bash tests/global-runtime-snapshot-v1.sh`; `bash tests/contract-v1-source-demotion.sh`; `bash tests/contract-v1-rollback-lanes.sh`; `bash tests/global-runtime-export-v1.sh`; `bash tests/runtime-package-validator.sh`; `bash tests/contract-v1-runtime-integration.sh`; `python3 scripts/validate-accelerate-contract-v1-forensic.py --catalog planning/executive/accelerate-contract-v1-task-catalog.md`; `python3 scripts/validate-accelerate-contract-v1-forensic.py --checklist planning/executive/accelerate-contract-v1-validation-checklist.md`; `bash tests/ci-contract.sh`
- **Rollback:** Disable cutover/export, then invoke only the affected typed lane:
W5-002 workspace manifest restore; W5-006 canonical source demotion followed by
regenerated export/parity; or explicit host-backup restore. Historical snapshot
validation remains disposable under `/tmp` and is not an actual rollback lane.
- **Status:** `proposed`

### ACV1-W5-008: Publish public v1 catalogs and runtime inventory
- **Priority:** P1
- **Owner role:** technical documentation lead
- **Dependencies:** ACV1-W5-003, ACV1-W5-004, ACV1-W5-005, ACV1-W5-007
- **Exact file surfaces:** `docs/reference/accelerate-contract-v1.md` (new), `docs/reference/accelerate-contract-v1-vocabulary.md` (new), `docs/reference/accelerate-contract-v1-gates.md` (new), `docs/reference/accelerate-contract-v1-evidence.md` (new), `docs/reference/accelerate-contract-v1-runtime-catalog.md` (new), `README.md`, `core/control-plane/README.md`
- **Deliverables:** Version/status, authority, class/mode/outcome/gate/evidence catalogs, lifecycle/closure behavior, five-extension registry, adapter supported-version/conformance inventory, Hermes boundary, migration/deprecation, rollback, and validated examples.
- **Acceptance criteria:** Public terms match accepted source; extension/provider support and gaps are exact; Hermes remains optional/non-authoritative; generated/source boundaries are explicit; no private path/secret/unsupported claim.
- **Tests/commands:** `bash tests/doc-snippet-integrity.sh`; `bash tests/markdown-link-integrity.sh`; `bash tests/doctrine-integrity.sh`
- **Rollback:** Demote v1 publication/status and retain internal evidence; do not leave partial navigation.
- **Status:** `proposed`

### ACV1-W5-009: Run final forensic validation and close Contract v1
- **Priority:** P0
- **Owner role:** independent forensic reviewer and contract approver
- **Dependencies:** ACV1-W5-002, ACV1-W5-003, ACV1-W5-004, ACV1-W5-005, ACV1-W5-006, ACV1-W5-007, ACV1-W5-008
- **Exact file surfaces:** `planning/evidence/dated-proof-appendix/accelerate-contract-v1-final-review-${RUN_KEY}.md` (new), `planning/executive/accelerate-contract-v1-review-index.md`, `planning/executive/accelerate-contract-v1-validation-checklist.md`, all Waves 0-5 packets/evidence
- **Deliverables:** Requested/promised/implemented reconciliation, 45-task and 12-capability Wave 5 coverage, extension/conformance/cutover proof, bounded commits, typed rollback/retention, incident correction, source/runtime parity, public catalogs, and signed closure.
- **Acceptance criteria:** 12/12 Wave 5, every prior wave accepted, no blocker/drift, full suite/link/authority/diff checks pass, and fresh post-merge plus logical terminal-commit proof exist.
- **Tests/commands:** load/validate the anchored entry-packet `RUN_KEY`; `python3 scripts/validate-accelerate-contract-v1-forensic.py --catalog planning/executive/accelerate-contract-v1-task-catalog.md`; `python3 scripts/validate-accelerate-contract-v1-forensic.py --checklist planning/executive/accelerate-contract-v1-validation-checklist.md`; `python3 scripts/validate-accelerate-contract-v1-forensic.py --final`; `bash tests/contract-v1-run-key.sh`; `bash tests/contract-v1-extension-registry.sh`; `bash tests/contract-v1-adapter-conformance.sh`; `bash tests/contract-v1-migration.sh`; `bash tests/contract-v1-closure-cutover.sh`; `bash tests/contract-v1-runtime-integration.sh`; `bash tests/workflow-readback-v1.sh`; `bash tests/workflow-backend-neutrality.sh`; `bash tests/global-runtime-snapshot-v1.sh`; `bash tests/contract-v1-source-demotion.sh`; `bash tests/contract-v1-rollback-lanes.sh`; `bash tests/global-runtime-export-v1.sh`; `bash tests/runtime-package-validator.sh`; `bash scripts/check-global-skill-mirror.sh --source-root . --package-root global-runtime/accelerate`; `bash tests/authority-set-gate.sh`; `bash tests/markdown-link-integrity.sh`; `bash tests/all.sh`; `git diff --check`
- **Rollback:** Exercise and record all three independent paths with distinct
receipts/status: project-local manifest restore/readback; canonical source
demotion followed by regenerated repository export/parity; and optional
explicit-target host restore/readback. Validate historical bytes separately and
only under `/tmp`. Preserve receipts and never substitute one proof for another
or reset/clean unowned work.
- **Status:** `proposed`

## Denominator Summary

| Wave | Theme | Tasks | P0 | P1 |
| --- | --- | ---: | ---: | ---: |
| Wave 0 | Authority entry, graph, tests, owners, manifest, closure | 6 | 6 | 0 |
| Wave 1 | Denominator, fixtures, dependency, validator, contract, registration, parity | 7 | 7 | 0 |
| Wave 2 | Scenarios, tests, linkage, evaluator, parity, closure | 6 | 6 | 0 |
| Wave 3 | Denominator, typed evidence, freshness, invalidation, workers, merge/cleanup, incident, transaction, closure | 9 | 9 | 0 |
| Wave 4 | Denominators, corpus, runner, coverage, package, schemas, CI, closure | 8 | 8 | 0 |
| Wave 5 | Entry, integration, readback, extensions/conformance, export/restore, cutover, public docs, forensics | 9 | 8 | 1 |
| **Total** |  | **45** | **44** | **1** |
