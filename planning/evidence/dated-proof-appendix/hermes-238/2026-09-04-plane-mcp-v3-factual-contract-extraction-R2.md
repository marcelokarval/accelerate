# TASK-V08-R2: Factual V3 Contract Extraction (Read-Only)

**Timestamp:** 2026-09-04T14:29:00-04:00
**Author:** `plane-runtime-exec-hiro`

## 1. State IDs from V3 Registry
**Fact (Baseline `7a4b60`):** From `src/plane_mcp_karval/assets/plane-state-role-registry.v3.json:6-11`
- `backlog`: `49452586-c91f-455c-a438-93a7989fa7dc`
- `ready`: `e61e1f72-1dbc-455c-974c-bbf8387d6d42`
- `in_progress`: `fe1ee0d2-d8f1-47c8-b379-2cc62d758ae3`
- `review`: `444e6ffa-b56f-4235-9386-6ccb754ddef3`
- `done`: `fd321010-850f-4d92-94cd-e9f083ad035a`
- `cancelled`: `25a76639-7122-471e-974d-028bf67a639e`

## 2. Role & Alias Vocabulary
**Fact (Baseline `7a4b60`):** `src/plane_mcp_karval/lifecycle_transition_contract.py:39-44`
Canonical Roles: `backlog`, `ready`, `in_progress`, `review`, `done`, `cancelled`
Aliases: `review_qa`->`review`, `qa`->`review`, `completed`->`done`, `canceled`->`cancelled`

## 3. Predecessor Predicate Distinctions
**Fact (Baseline `7a4b60`):** `src/plane_mcp_karval/lifecycle_transition_contract.py`
- **REVIEW requires prior START:** `if phase == "REVIEW": if not seen.get("START"): errors.append("v3 REVIEW requires a prior START event")` (Lines 286-288)
- **FINISH requires prior REVIEW:** `if phase == "FINISH" and not review_seen: errors.append("v3 FINISH requires a prior REVIEW event")` (Lines 284-285)
- **Receipt Predecessor Field Constraint:** `if not historical and receipt["phase"] != "REVIEW" and receipt["predecessor_evidence"] != "none": raise ValueError("only REVIEW receipts may carry predecessor evidence")` (Lines 410-413)

## 4. Coexistence Symbol Manifest
**Facts (Existing implementations to extract or preserve):**

### V3 Symbols (To Restore from Baseline `7a4b60`)
* `src/plane_mcp_karval/server.py`
  - `_canonical_v3_registry_verifier` (line 401)
  - `_v3_transition_comment_html` (line 412)
  - `_verified_v3_history` (line 433)
  - `plane_reconcile_v3_lifecycle_transition` (line 736)
* `src/plane_mcp_karval/lifecycle_transition_contract.py`
  - `normalize_v3_role` (line 148)
  - `_v3_request_role` (line 161)
  - `validate_v3_phase_transition` (line 170)
  - `validate_v3_annotation_event` (line 184)
  - `validate_v3_mutation_request` (line 215)
  - `validate_v3_lifecycle_history` (line 227)
  - `load_state_role_registry_v3` (line 299)
  - `_bundled_v3_registry_receipt_binding` (line 344)
  - `validate_v3_transition_receipt` (line 363)

### V2 Symbols (To Preserve from Candidate `26488c53` & Baseline)
* `src/plane_mcp_karval/server.py`
  - `plane_operator_lifecycle_transition` (Candidate `26488c53` line 506 / Baseline `7a4b60` line 1079)
* `src/plane_mcp_karval/lifecycle_transition_contract.py`
  - `load_state_role_registry` (Candidate `26488c53` line 106 / Baseline `7a4b60` line 108)

*(Constraint: The restored V3 symbols must coexist with the listed V2 symbols in the candidate tree without modifying V2 functionality.)*

## 5. Deterministic Future Test Execution Command Template
**Future Constraint:** The following exact isolated deterministic shell commands will be executed to verify the candidate once patched:

```bash
# 1. Capture HEAD & Tree Before
BEFORE_HEAD=$(git rev-parse HEAD)
BEFORE_TREE=$(git rev-parse HEAD^{tree})

# 2. Execution Environment Setup
WORKTREE_ROOT="/home/marcelo-karval/.local/share/plane-mcp-karval/releases/26488c53ec9852ae8d02adfecaf86694f50e3c8c"
APP_DIR="${WORKTREE_ROOT}/apps/mcp-servers/plane-mcp-karval"
RECEIPT_ROOT="/home/marcelo-karval/Backup/Projetos/accelerate/planning/evidence/dated-proof-appendix/hermes-238"

export VIRTUAL_ENV="/home/marcelo-karval/.local/share/plane-mcp-karval/venvs/26488c53ec9852ae8d02adfecaf86694f50e3c8c"
export PATH="$VIRTUAL_ENV/bin:$PATH"

cd "$APP_DIR" || exit 1

# 3. Execution & Retained Logs
uv run pytest tests/test_plane_lifecycle_contract_v3.py tests/test_plane_operator_v3.py tests/test_plane_lifecycle_contract_v2.py \
    > "${RECEIPT_ROOT}/pytest-stdout.log" \
    2> "${RECEIPT_ROOT}/pytest-stderr.log"
EXIT_CODE=$?
echo $EXIT_CODE > "${RECEIPT_ROOT}/pytest-exit.receipt"

# 4. Capture HEAD & Tree After
AFTER_HEAD=$(git rev-parse HEAD)
AFTER_TREE=$(git rev-parse HEAD^{tree})
```

## 6. Expanded Final Digest Manifest Schema
**Future Constraint:** After patching, the final verification step must export the exact digests of the specific allowlisted source files to ensure no unexpected mutations occurred.

```bash
cd "$WORKTREE_ROOT" || exit 1

git diff --check
git status --porcelain # Must equal zero unexpected paths

# Tree Digest Validation
git rev-parse HEAD^{tree}

# Source File Validation
sha256sum apps/mcp-servers/plane-mcp-karval/docs/HERMES-236-v3-test-matrix.md
sha256sum apps/mcp-servers/plane-mcp-karval/src/plane_mcp_karval/assets/plane-state-role-registry.v3.json
sha256sum apps/mcp-servers/plane-mcp-karval/tests/test_plane_lifecycle_contract_v3.py
sha256sum apps/mcp-servers/plane-mcp-karval/tests/test_plane_operator_v3.py
sha256sum apps/mcp-servers/plane-mcp-karval/src/plane_mcp_karval/lifecycle_transition_contract.py
sha256sum apps/mcp-servers/plane-mcp-karval/src/plane_mcp_karval/server.py
```
