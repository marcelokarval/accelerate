# TASK-V06: Plane v3 Lifecycle/Receipt Semantics Restoration Plan

**Timestamp:** 2026-09-04T14:10:00-04:00
**Baseline Commit:** `7a4b60ef3a4303033ab0972c47a143120d4bf0c3`
**Candidate Commit:** `26488c53ec9852ae8d02adfecaf86694f50e3c8c`

## Executive Summary
A mechanical comparison between the baseline and candidate releases indicates that the candidate (`26488c53`) systematically removed all v3 lifecycle logic, history verification, operator receipts, and associated test matrices, reverting to `v2` semantics. 

This report outlines the precise scope required to restore v3 governance without mutating the existing v2 successor scope in the candidate tree.

## File-Level Restoration Scope

### 1. Removed Assets & Documentation
- **RESTORE:** `src/plane_mcp_karval/assets/plane-state-role-registry.v3.json`
- **RESTORE:** `docs/HERMES-236-v3-test-matrix.md`

### 2. Removed Tests
- **RESTORE:** `tests/test_plane_lifecycle_contract_v3.py`
- **RESTORE:** `tests/test_plane_operator_v3.py`

### 3. Removed Modules & Symbols
To restore v3 semantics in the `lifecycle_transition_contract.py` module:
- `normalize_v3_role`
- `_v3_request_role`
- `validate_v3_phase_transition`
- `validate_v3_annotation_event`
- `validate_v3_mutation_request`
- `validate_v3_lifecycle_history`
- `load_state_role_registry_v3`
- `_bundled_v3_registry_receipt_binding`
- `validate_v3_transition_receipt`

To restore v3 operator logic in `server.py`:
- `_canonical_v3_registry_verifier`
- `_v3_transition_comment_html`
- `_verified_v3_history`
- `plane_reconcile_v3_lifecycle_transition`

## Minimal Successor Scope
The restoration must inject the removed v3 symbols and operator endpoints alongside the current candidate's `v2` implementations. The candidate's `plane_operator_lifecycle_transition` (which enforces v2 `sparse_finish` semantics) must be preserved alongside `plane_reconcile_v3_lifecycle_transition` to ensure dual-version capability until v2 is formally retired.

## Acceptance Criteria
1. **No Governance Downgrade:** The restored v3 symbols must enforce strict history validation (`_verified_v3_history`) and immutable receipt bindings.
2. **Side-by-Side Coexistence:** The v2 endpoints must remain functional. `load_state_role_registry_v2` and `load_state_role_registry_v3` must coexist.
3. **Test Parity:** The restored v3 tests must pass independently against the restored v3 code, while existing candidate tests (`test_plane_lifecycle_contract_v2.py`) must continue to pass.

## Exact Test Commands
To verify the restoration once applied, the following isolated commands must be run within the virtual environment:
```bash
# Verify v3 lifecycle contract tests
uv run pytest tests/test_plane_lifecycle_contract_v3.py

# Verify v3 operator integration tests
uv run pytest tests/test_plane_operator_v3.py

# Verify global test suite to ensure no regressions in v2
uv run pytest tests/
```
