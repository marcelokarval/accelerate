# TASK-V06-R2: Plane v3 Lifecycle/Receipt Semantics Restoration Plan (v3)

**Timestamp:** 2026-09-04T14:18:00-04:00
**Author:** `plane-runtime-exec-hiro`

## 1. Frozen Baseline Extraction Manifest
- **Baseline Commit (Authoritative v3):** `7a4b60ef3a4303033ab0972c47a143120d4bf0c3`
- **Baseline Tree Digest:** `b6ded7e540782b4f7b7a371be0fb833406f8a5a2`
- **Candidate Base Commit (v2 Reversion):** `26488c53ec9852ae8d02adfecaf86694f50e3c8c`
- **Candidate Base Tree Digest:** `9d53761f070e0f33d2746ca1ad9760039935f9a5`

### Path -> Blob Verifier Commands (Tied to 7a4b60)
```bash
git ls-tree 7a4b60ef3a4303033ab0972c47a143120d4bf0c3 apps/mcp-servers/plane-mcp-karval/docs/HERMES-236-v3-test-matrix.md
# Expected blob: d199cd6a70b147361351d724324dd06bee9cb51b

git ls-tree 7a4b60ef3a4303033ab0972c47a143120d4bf0c3 apps/mcp-servers/plane-mcp-karval/src/plane_mcp_karval/assets/plane-state-role-registry.v3.json
# Expected blob: 920681d485ac4d9ad21ad02ac807741469231172

git ls-tree 7a4b60ef3a4303033ab0972c47a143120d4bf0c3 apps/mcp-servers/plane-mcp-karval/tests/test_plane_lifecycle_contract_v3.py
# Expected blob: 63fa1fd0910b65c183381fcf8e430de6fbfd5ee1

git ls-tree 7a4b60ef3a4303033ab0972c47a143120d4bf0c3 apps/mcp-servers/plane-mcp-karval/tests/test_plane_operator_v3.py
# Expected blob: f3431b2c527d5e2541d6569e0846a1e05cb9a5fb

git ls-tree 7a4b60ef3a4303033ab0972c47a143120d4bf0c3 apps/mcp-servers/plane-mcp-karval/src/plane_mcp_karval/lifecycle_transition_contract.py
# Expected blob: d604a6536d8066d77c29104b5239d961fafd496b

git ls-tree 7a4b60ef3a4303033ab0972c47a143120d4bf0c3 apps/mcp-servers/plane-mcp-karval/src/plane_mcp_karval/server.py
# Expected blob: fbdf63cb341fba0742437c49fd4d02c336826e86
```

## 2. Successor Integration Allowlist
Only the exact files listed above are permitted to be integrated. No other modules may be mutated.

**Symbols to Restore/Inject (from `fbdf63` & `d604a6`):**
- `_canonical_v3_registry_verifier`
- `_verified_v3_history`
- `_v3_transition_comment_html`
- `plane_reconcile_v3_lifecycle_transition`
- `validate_v3_transition_receipt`
- `validate_v3_lifecycle_history`
- `load_state_role_registry_v3`

*Post-patch output digest manifest will be generated explicitly during the independent execution phase.*

## 3. Semantic Matrix (Expanded v3 Rules)
- **Contract Admission:** `contract_version=3` must be validated and enforced *strictly before* any client I/O.
- **Six-Role Mapping:** Exact state mappings enforced for `backlog`, `unstarted`, `started`, `completed`, `canceled`, and `duplicate`.
- **Transition Table Validation:** Strict governance enforced for `ADMIT`, `START`, `REVIEW`, `FINISH`, and `CANCEL` transitions.
- **BLOCKED Resolution:** Explicit verification required for `BLOCKED` states; no state mutations permitted on `PROGRESS`/`BLOCKED` annotation events (comment-only invariance).
- **Predecessor Proof:** Transitions into `REVIEW` or `FINISH` require rigorous predecessor proof (e.g. proof of prior `started` state).
- **Legacy Provider Bridge:** Preserves Provider semantics bridging securely to v2 logic, ensuring side-by-side coexistence.
- **Historical-Evidence Non-Authority:** Historical sequence evidence is treated as read-only; it strictly lacks the authority to dictate or mutate live operational state.

## 4. Adversarial & Negative Test Matrix
The test suite must explicitly assert rejection on the following vectors:
- **Table/Bridge Tests:** Complete coverage ensuring v2 requests are rejected in v3 paths and vice-versa.
- **Pre-Client Rejection:** V2 payloads, or absent versions, must be rejected before client init.
- **No-PATCH Enforcements:** Attempted transition/annotation updates containing state mutations for `PROGRESS`/`BLOCKED` must fail.
- **History Integrity:** Must reject tampered histories, manipulated pagination boundaries, or spoofed predecessor duplicates.
- **Receipt Integrity:** Strong enforcement against registry hash mismatches, cross-binding, provider/target manipulation, and replay (single-use expiry validation).

## 5. Execution & Review Constraints
**This is a PLAN-ONLY correction. No code patch, worktree manipulation, release generation, or launcher modification is permitted.**

*Execution Constraints for Successor Phase:*
1. Generate detached candidate worktree directly from `26488c53`.
2. Extract allowlisted blobs directly from `7a4b60` and apply structural diff patching.
3. Validate output hashes to form final `Tree/Digest Manifest`.
4. Command to run: `uv run pytest tests/test_plane_lifecycle_contract_v3.py tests/test_plane_operator_v3.py`
5. Collect retained logs, error exits, and independent source-review receipts.
