# CODEX-26 Prompt G — Implementation Candidate Return Artifact (Correction G2)

- task_id: `TASK-G04` / `TASK-G05` / `TASK-G08` (Correction Generation 2)
- issue: `CODEX-26`
- implementer: `pgimpl-haka` (Agy Gemini 3.8 Flash)
- reasoning_effort: `high`
- fork_turns: `none`
- emitted_at: `2026-09-04T03:51:30Z`
- terminal_disposition: `BLOCKED` (`NO_GO_WITH_FIRST_BROKEN_BOUNDARY`)

---

## 1. Requested vs Implemented

### Requested
1. Execute only the bounded implementer write scope and required proof in Prompt G.
2. Reconcile stale C13-as-current local projection to current Prompt-G/Prompt-F closure-review truth under `.accelerate/`.
3. Use the canonical local-workspace closure preparation flow (`onboarding/local-workspace/prepare-closure.sh`).
4. Execute required implementer proof suite:
   - canonical closure preparation command against this repository;
   - inspect closure/review artifacts for current authority;
   - `bash tests/local-workspace-proof-gates.sh`;
   - `bash tests/dogfood-workspace-contract.sh`;
   - `python3 scripts/validate-phase1-entry-currentness.py`;
   - `git diff --check`;
   - prove C14, R1, Prompt-F F09, and Prompt-F proof-freeze hashes unchanged.
5. Mutate only allowlisted surfaces: tracked `.accelerate/` control surfaces and `prompt-g-agy-closure-candidate.md`.
6. Forbidden scope respected: No edits to C14, R1, Prompt-F, root SKILL, V3 pointer, proposal, tests, scripts, adapters, core, skills, profiles, onboarding, runtime mirrors, or user-home. No Plane mutation, commit, push, global sync, promotion, deploy, Phase 2, or nested spawn.
7. Correction G2 (Observability Repair): In `.accelerate/status/readiness-dashboard.yaml` replace only the now-stale residual claiming candidate freeze/reviewer/root review are still required with current truth reflecting independent Terra NO_GO confirmation and dogfood denominator boundaries. Keep status `implementing-not-accepted` and avoid lifecycle overclaim.

### Implemented
1. Completed read-only preflight; verified all entry hashes; reported HOLD status to root (`nano`); received explicit RELEASE (`#4106`).
2. Reconciled tracked `.accelerate/` control files to Prompt-G plan, task ledger, cycle, and Prompt-F proof freeze:
   - `.accelerate/state.yaml`: updated `current_plan`, `current_task_ledger`, and `last_bootstrap_update` to Prompt G.
   - `.accelerate/status/readiness-dashboard.yaml`: updated `cycle`, `plan`, `ledger`, `phase1_entry_currentness` boundary, and `residuals` to Prompt G / Prompt F.
   - `.accelerate/workflow/active-work-item.yaml`: updated `classification`, `plan`, `ledger`, `accepted_scope`, and `next_queue_source` to Prompt G.
3. Applied Generation 2 minimal observability repair:
   - Replaced stale residual in `.accelerate/status/readiness-dashboard.yaml` with exact current truth:
     `CODEX-26 Phase 1 Prompt-G closure review completed with independent Terra confirmation of NO_GO; first boundary is full-V2 prepare-closure incompatibility with committed-dogfood-v2-index; C13-bound dogfood/currentness denominators require a separately authorized source/test correction before any new closure attempt`.
   - Maintained `status: implementing-not-accepted` with zero lifecycle overclaim.
4. Executed canonical closure preparation: `bash onboarding/local-workspace/prepare-closure.sh /home/marcelo-karval/Backup/Projetos/accelerate`.
   - **Result**: Command exited with code `1` (`missing current plan: /home/marcelo-karval/Backup/Projetos/accelerate/.accelerate/planning/current-plan.md`). (Preserved from G1; no failing command rerun in G2).
5. Executed `bash tests/dogfood-workspace-contract.sh`.
   - **Result**: Command exited with code `1` (`dogfood-workspace-contract failed: unexpected current_plan in .accelerate/state.yaml: expected planning/architecture/2026-09-02-codex-26-phase1-reentry-c13-sdd.md, got planning/evidence/dated-proof-appendix/codex-26-phase1/phase1-closure-review-prompt-g.md`). (Preserved from G1; no failing command rerun in G2).
6. Executed `bash tests/local-workspace-proof-gates.sh`.
   - **Result**: Mechanical exit `0` (`local workspace proof gate tests passed`), validating only temporary greenfield fixtures in `.tmp/local-workspace-proof-gates/`, NOT successful closure of this dogfood repository.
7. Executed `python3 scripts/validate-phase1-entry-currentness.py`.
   - **Result**: Mechanical exit `0`, but outputs `PASS phase1 entry currentness: CODEX-17 is historical; CODEX-26 C13 reentry is current and unaccepted`. This represents a **semantic FAIL** for Prompt-G current authority because it certifies C13 rather than Prompt G as the active truth.
8. Executed `git diff --check`.
   - **Result**: PASSED (exit code `0`, no trailing whitespace or merge conflicts).
9. Verified all frozen inputs:
   - C14 freeze manifest (23/23 files byte-identical; aggregate `cbf26086ca9af5e7d927d7ee324818af35d74d972dfcdbfcce0cd562bc3780d4`).
   - R1 root harness freeze (5/5 files byte-identical; aggregate `aa9551f4b2f33fe382b043059034fe1b107e50ee8b99c5975869bdc67e5eaeed`).
   - Prompt-F F09 SHA-256 (`fcb91ad773a46b20467778cbb82959aa0a38d8d4f1b2927b9dd9a93aa57085aa`).
   - Prompt-F durable proof freeze SHA-256 (`1d21bbe918886ff8ff3acf696bd20f9f736a6b81d445e28f7e037e7245cbebda`).
10. Preserved all forbidden boundaries: zero modifications outside allowlisted `.accelerate/` surfaces and this return artifact.

---

## 2. Changed Paths and Exact Final Hashes

### Mutated Allowlisted Paths
1. `.accelerate/state.yaml`:
   - SHA-256: `2fbf9e65d132d77d89ab89130249d482c7fc7d584fcce5f2d070aa9948f6d448`
2. `.accelerate/status/readiness-dashboard.yaml` (updated G2 observability):
   - SHA-256: `b45efe9ddb21990c78b402727b03995fc245e468f5bf6d35128c6a175d01582f`
3. `.accelerate/workflow/active-work-item.yaml`:
   - SHA-256: `19b05632c0f564a842698f36f1d17f0aec7ac6f4478130c40d562509676ba105`
4. `planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-g-agy-closure-candidate.md` (this file).

### Unchanged Frozen Input Hashes
- Prompt-F F09: `fcb91ad773a46b20467778cbb82959aa0a38d8d4f1b2927b9dd9a93aa57085aa`
- Prompt-F proof freeze: `1d21bbe918886ff8ff3acf696bd20f9f736a6b81d445e28f7e037e7245cbebda`
- C14 freeze JSON: `7215486904c9fee3172ad1f53c3c3a63d4aa9ba62cea424d5bf8da60fcf72bc2`
- C14 aggregate SHA-256: `cbf26086ca9af5e7d927d7ee324818af35d74d972dfcdbfcce0cd562bc3780d4`
- R1 freeze JSON: `23ec174a784f5a0570419086cbccda39f9b08f8dd780889b0e30e449c0a73ecb`
- R1 aggregate SHA-256: `aa9551f4b2f33fe382b043059034fe1b107e50ee8b99c5975869bdc67e5eaeed`

---

## 3. Exact Commands, Exit Codes, and Semantic Classifications

| Command | Working Directory | Exit Code | Semantic Classification | Terminal Output Summary |
| --- | --- | --- | --- | --- |
| `bash onboarding/local-workspace/prepare-closure.sh /home/marcelo-karval/Backup/Projetos/accelerate` | repository root | `1` | **FIRST BROKEN BOUNDARY** | `missing current plan: /home/marcelo-karval/Backup/Projetos/accelerate/.accelerate/planning/current-plan.md` |
| `bash tests/dogfood-workspace-contract.sh` | repository root | `1` | **SECOND BROKEN BOUNDARY** | `dogfood-workspace-contract failed: unexpected current_plan in .accelerate/state.yaml: expected planning/architecture/2026-09-02-codex-26-phase1-reentry-c13-sdd.md, got planning/evidence/dated-proof-appendix/codex-26-phase1/phase1-closure-review-prompt-g.md` |
| `bash tests/local-workspace-proof-gates.sh` | repository root | `0` | Fixture PASS (disposable only) | `local workspace proof gate tests passed` (runs against `.tmp` fixtures, does not prove repo closure) |
| `python3 scripts/validate-phase1-entry-currentness.py` | repository root | `0` | **Semantic FAIL for Prompt G** | `PASS phase1 entry currentness: CODEX-17 is historical; CODEX-26 C13 reentry is current and unaccepted` (certifies C13, contradicting Prompt G) |
| `git diff --check` | repository root | `0` | PASS | Clean diff without whitespace or conflict markers |
| sha256sum verification of frozen inputs | repository root | `0` | PASS | 4/4 hashes byte-identical |
| Python verification of C14/R1 aggregates | repository root | `0` | PASS | C14 23/23 and R1 5/5 verified |

---

## 4. Forensic Analysis of Broken Boundaries

### First Broken Boundary: Profile Mismatch Between Canonical Prepare-Closure and Dogfood V2 Index
- **Script**: `onboarding/local-workspace/prepare-closure.sh`
- **Failure Mechanism**:
  Line 25 calls `sync-plan-status.sh`, which in line 10 requires `${TARGET_ROOT}/.accelerate/planning/current-plan.md`. Furthermore, `refresh-readiness.sh` requires `.accelerate/onboarding/status.yaml` and `.accelerate/status/evidence-registry.yaml`.
- **Root Cause**:
  The full-V2 `prepare-closure.sh` pipeline requires planning, onboarding, and evidence surfaces that are **intentionally absent** from the repository's active materialization profile (`materialization_profile: committed-dogfood-v2-index`). Materializing these full-V2 surfaces would change the repository's selected materialization profile, an action not authorized by Prompt G.
- **Governing Invariant**:
  Prompt G strictly forbids modifying `onboarding/local-workspace/` scripts, and forbids materializing unauthorized profiles. The canonical closure command fails on the dogfood repository by design.

### Second Independent Broken Boundary: Dogfood Contract Test Denominator Collision
- **Script**: `tests/dogfood-workspace-contract.sh`
- **Failure Mechanism**:
  Lines 91–117 hardcode assertions for C13 values:
  ```bash
  current_plan="planning/architecture/2026-09-02-codex-26-phase1-reentry-c13-sdd.md"
  current_ledger="planning/executive/2026-09-02-codex-26-phase1-r0-c13-task-graph.md"
  current_cycle="codex-26-phase1-c13-reentry"
  plane_id="549d5c6e-9066-440c-85a6-973a33b7eefe"

  require_value "${state}" "current_plan" "${current_plan}"
  require_value "${state}" "current_task_ledger" "${current_ledger}"
  require_value "${readiness}" "cycle" "${current_cycle}"
  require_value "${readiness}" "plan" "${current_plan}"
  require_value "${readiness}" "ledger" "${current_ledger}"
  require_value "${readiness}" "status" "implementing-not-accepted"
  require_value "${active_work_item}" "plan" "${current_plan}"
  require_value "${active_work_item}" "ledger" "${current_ledger}"
  require_value "${active_work_item}" "status" "in-progress"
  ```
- **Root Cause**:
  Prompt G commands the implementer to ensure the local projection names Prompt-G/Prompt-F authority rather than C13. When `.accelerate/` is reconciled to Prompt G, `tests/dogfood-workspace-contract.sh` fails because its assertions remain frozen to C13.
- **Governing Invariant**:
  `tests/` is in Prompt G's forbidden write scope. Reconciling `.accelerate/` to Prompt G and passing `tests/dogfood-workspace-contract.sh` without test modification is structurally impossible.

### Reclassification of Entry Currentness Validation
- `scripts/validate-phase1-entry-currentness.py` inspects `c13-current-status-and-reentry-reconciliation.json` and asserts:
  `"local_workspace": {"reentry_status": "partial-reonboarding", "historical_cycle": "linear-oauth-runtime-proof-2026-05-08-rc24-rc27", "current_cycle": "codex-26-phase1-c13-reentry"}`
- While the command exits mechanically with code `0`, its output explicitly certifies that `CODEX-26 C13 reentry is current`. In the context of Prompt G closure review, this is a **semantic FAIL** for Prompt-G current authority because C13 is no longer the active closure truth.

---

## 5. Self-Review

1. **Allowlist compliance**: Only `.accelerate/state.yaml`, `.accelerate/status/readiness-dashboard.yaml`, `.accelerate/workflow/active-work-item.yaml`, and this candidate return artifact were modified.
2. **Observability update (G2)**: Residuals accurately reflect that Prompt-G closure review finished with independent Terra confirmation of `NO_GO`, that the first broken boundary is the full-V2 `prepare-closure.sh` incompatibility with `committed-dogfood-v2-index`, and that C13-bound denominators require separately authorized source/test correction before any new closure attempt. Status remains `implementing-not-accepted` with no lifecycle overclaim.
3. **Forbidden scope preservation**:
   - Zero edits to C14 files.
   - Zero edits to R1 files.
   - Zero edits to Prompt-F files.
   - Zero edits to root `SKILL.md`.
   - Zero edits to `v3-template/.accelerate/planning-pointer.yaml`.
   - Zero edits to `planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md`.
   - Zero edits to `tests/`.
   - Zero edits to `scripts/`.
   - Zero edits to `adapters/`.
   - Zero edits to `core/`.
   - Zero edits to `skills/`.
   - Zero edits to `profiles/`.
   - Zero edits to `onboarding/`.
   - Zero edits to runtime mirrors or user-home.
4. **Operational discipline**:
   - Zero Plane mutations or state transitions attempted.
   - Zero commits, pushes, merges, deployments, or Phase 2 entries.
   - Zero nested spawns (`fork_turns=none`).
   - No claim of `Done` or final acceptance made.

---

## 6. Self-Forensic Review

1. **Independent reproduction**:
   - Executing `prepare-closure.sh` consistently exits `1` due to profile omission of `.accelerate/planning/current-plan.md`.
   - Executing `tests/dogfood-workspace-contract.sh` consistently exits `1` due to line 100 assertion mismatch against reconciled Prompt-G `state.yaml`.
2. **Test harness context**:
   - `local-workspace-proof-gates.sh` passes because it builds isolated synthetic greenfield repositories in `.tmp/`, which do not reflect the `committed-dogfood-v2-index` reality of this repository.
   - `validate-phase1-entry-currentness.py` mechanically exits `0` by verifying frozen C13 artifacts, but semantically conflicts with Prompt G closure truth.
3. **Integrity assessment**:
   The `BLOCKED` result is structurally genuine, reproducible, and strictly required by the Prompt G task graph and stop conditions.

---

## 7. Blockers and Residuals

### Blockers
1. Canonical `prepare-closure.sh` cannot execute against a `committed-dogfood-v2-index` workspace without script-level adaptation or governed materialization of missing V2 control surfaces.
2. `tests/dogfood-workspace-contract.sh` hardcodes C13 plan, ledger, and cycle names, requiring a governed test amendment by root/operator to permit cycle progression.

### Residuals
1. `.accelerate/` local files currently project Prompt G closure-review truth with updated Generation 2 observability.
2. Entry hashes from Prompt G remain documented for exact rollback if directed by root.

---

## 8. Final Implementer Disposition

`BLOCKED` (`NO_GO_WITH_FIRST_BROKEN_BOUNDARY`)
