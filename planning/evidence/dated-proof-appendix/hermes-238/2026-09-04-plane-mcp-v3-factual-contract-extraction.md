# TASK-V08: Factual V3 Contract Extraction (Read-Only)

**Timestamp:** 2026-09-04T14:22:00-04:00
**Author:** `plane-runtime-exec-hiro`
**Frozen Baseline Source:** `7a4b60ef3a4303033ab0972c47a143120d4bf0c3`

## 1. Factual V3 Contract Semantics
All semantic facts below are explicitly extracted from `src/plane_mcp_karval/lifecycle_transition_contract.py` at the `7a4b60ef` baseline.

### Exact Role to State-ID Mapping
*Reference:* `lifecycle_transition_contract.py:39-44`
```python
V3_CANONICAL_ROLES = {"backlog", "ready", "in_progress", "review", "done", "cancelled"}
V3_ROLE_ALIASES = {
    "review_qa": "review",
    "qa": "review",
    "completed": "done",
    "canceled": "cancelled",
}
```

### Legal Phase Transition Table
*Reference:* `lifecycle_transition_contract.py:46-56`
```python
V3_TRANSITIONS = {
    "ADMIT": {("backlog", "ready")},
    "START": {("ready", "in_progress")},
    "REVIEW": {("in_progress", "review")},
    "FINISH": {("review", "done")},
    "CANCEL": {
        ("backlog", "cancelled"),
        ("ready", "cancelled"),
        ("in_progress", "cancelled"),
        ("review", "cancelled"),
    },
}
```

### BLOCKED Resolution & Annotation Invariance
*Reference:* `lifecycle_transition_contract.py:193-200`
```python
if (before, after) != ("in_progress", "in_progress"):
    return [f"v3 {normalized_phase} is an annotation event and must remain in_progress -> in_progress"]
```
*Reference:* `lifecycle_transition_contract.py:274-279`
```python
pointer = str(event.get("resolves_blocked_receipt_fingerprint") or "").strip()
if pointer != open_blocker:
    errors.append("v3 PROGRESS must resolve the open BLOCKED receipt_fingerprint exactly")
```

### REVIEW / FINISH Predecessor Predicates
*Reference:* `lifecycle_transition_contract.py:284-285`
```python
if phase == "FINISH" and not review_seen:
    errors.append("v3 FINISH requires a prior REVIEW event")
```
*Reference:* `lifecycle_transition_contract.py:410-413`
```python
if not historical and receipt["phase"] != "REVIEW" and receipt["predecessor_evidence"] != "none":
    raise ValueError("only REVIEW receipts may carry predecessor evidence")
```

## 2. Coexistence Constraints
**V3 Symbols to Restore (Strict Addition):**
- `load_state_role_registry_v3`
- `_bundled_v3_registry_receipt_binding`
- `validate_v3_transition_receipt`
- `validate_v3_lifecycle_history`
- `validate_v3_annotation_event`
- `validate_v3_phase_transition`
- `_v3_request_role`
- `normalize_v3_role`
- `_canonical_v3_registry_verifier`
- `_verified_v3_history`
- `_v3_transition_comment_html`
- `plane_reconcile_v3_lifecycle_transition`

**V2 Symbols to Preserve:**
- `load_state_role_registry_v2`
- `validate_v2_work_item_history`
- `plane_operator_lifecycle_transition`
*(These existing candidate symbols must be fully preserved to maintain the predecessor interface).*

## 3. Execution & Verification Environment
To reproduce the facts and verify eventual application, the following deterministic operations are declared:

### Isolated Python/uv Test Env & Commands
```bash
# Isolated verification environment execution within the designated venv
VIRTUAL_ENV=/home/marcelo-karval/.local/share/plane-mcp-karval/venvs/26488c53ec9852ae8d02adfecaf86694f50e3c8c
export VIRTUAL_ENV

uv run pytest tests/test_plane_lifecycle_contract_v3.py tests/test_plane_operator_v3.py \
    --junitxml=planning/evidence/dated-proof-appendix/hermes-238/pytest_v3.xml

# Expected exit code: 0
```

### Final Digest-Manifest Schema
A successful extraction and subsequent patching validation must export:
```bash
git diff --stat
git status --porcelain
sha256sum src/plane_mcp_karval/server.py src/plane_mcp_karval/lifecycle_transition_contract.py
```
*This validates structural integrity. No patches or operations against GitHub, releases, configurations, or the live provider were generated or performed.*
