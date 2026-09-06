# TASK-V06-R: Plane v3 Lifecycle/Receipt Semantics Restoration Plan (v2)

**Timestamp:** 2026-09-04T14:15:00-04:00
**Baseline Commit:** `7a4b60ef3a4303033ab0972c47a143120d4bf0c3` (v3 Authoritative)
**Candidate Commit:** `26488c53ec9852ae8d02adfecaf86694f50e3c8c` (v2 Reversion)

## 1. Git Ancestry & Provenance-Safe Strategy
The candidate `26488c53` fundamentally reverted all v3 functionality and removed the v3 test matrices. Because standard merges or rebases may result in semantic collisions or silent replacement of v3 logic, the chosen provenance-safe strategy is **independent replacement**. We will explicitly extract the frozen blobs from the `7a4b60` baseline and re-inject them into a fresh candidate tree, isolating the changes strictly to the explicitly allowed files.

## 2. Exact Changed-File Allowlist
Only the following files are permitted to be modified or restored. The blobs from `7a4b60` will serve as the trusted source truth:

**Recovered Assets & Documentation (Exact Blobs from `7a4b60`):**
- `docs/HERMES-236-v3-test-matrix.md` (Blob: `d199cd6a70b147361351d724324dd06bee9cb51b`)
- `src/plane_mcp_karval/assets/plane-state-role-registry.v3.json` (Blob: `920681d485ac4d9ad21ad02ac807741469231172`)

**Recovered Tests (Exact Blobs from `7a4b60`):**
- `tests/test_plane_lifecycle_contract_v3.py` (Blob: `63fa1fd0910b65c183381fcf8e430de6fbfd5ee1`)
- `tests/test_plane_operator_v3.py` (Blob: `f3431b2c527d5e2541d6569e0846a1e05cb9a5fb`)

**Target Replacements/Patches (Source Blobs from `7a4b60`):**
- `src/plane_mcp_karval/lifecycle_transition_contract.py` (Blob: `d604a6536d8066d77c29104b5239d961fafd496b`)
- `src/plane_mcp_karval/server.py` (Blob: `fbdf63cb341fba0742437c49fd4d02c336826e86`)
*(Note: These Python files must be patched to ensure v3 logic coexists with v2 without breaking v2 functionality.)*

## 3. Frozen V3 Semantic Matrix
The restored v3 logic must satisfy the following frozen semantics:
- **Contract Admission:** Must enforce `contract_version=3` admission strictly *before* executing any client I/O.
- **Six-Role Mapping:** Enforce exactly six workflow roles (backlog, unstarted, started, completed, canceled, duplicate).
- **Invariance:** `PROGRESS` and `BLOCKED` states are comment-only invariances; no mutation to the state field is allowed for these lifecycle phases.
- **Integrity:** Strict provider + ledger history integrity ensuring verifiable state paths.
- **Receipt Constraints:** Must strictly validate cross-binding, single-use, and exact expiry policies for all preparation receipts.

## 4. Adversarial & Negative Test Matrix
The test suite (`test_plane_lifecycle_contract_v3.py` & `test_plane_operator_v3.py`) must prove resilience against the following vectors:
- **Pre-Client Rejection:** Rejection of `v2` or absent version identifiers strictly *before* interacting with the provider or performing readbacks.
- **No-PATCH Enforcements:** For `PROGRESS` and `BLOCKED` annotation events, transition semantics must reject any provider PATCH requests that attempt state mutation.
- **History Tampering:** Rejection of tampered histories, duplicate state sequences, or manipulated pagination boundaries during history verification.
- **Receipt Integrity:** Rejection of tampered, expired, or catalog/provider/idempotency mismatched receipts.

## 5. Clean Environment & Independent Gate
- **Candidate Delivery:** The patched candidate will be delivered as a clean, detached worktree.
- **Retention:** All standard outputs, CLI test executions, error exits, and file digests will be retained in durable receipts.
- **Review Gate:** Code patches will not be executed or built until this exact plan passes an independent source review gate.
