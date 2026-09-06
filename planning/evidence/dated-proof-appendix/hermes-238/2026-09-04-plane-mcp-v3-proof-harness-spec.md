# TASK-V10: Deterministic Proof-Harness Specification (Read-Only)

**Timestamp:** 2026-09-04T14:33:00-04:00
**Author:** `plane-runtime-exec-hiro`

This document defines the strict, standalone immutable evidence specification to validate a future restored detached worktree. **This is a template demonstration only.** No structural modifications, live tests, worktrees, or configuration changes were executed.

## Immutable Execution Template

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. Environment & Path Declarations
WORKTREE_ROOT="/path/to/detached/candidate/worktree"
APP_DIR="${WORKTREE_ROOT}/apps/mcp-servers/plane-mcp-karval"
RECEIPT_ROOT="/path/to/receipt/output/dir"

VENV="/path/to/candidate/venv"
export VIRTUAL_ENV="$VENV"
export PATH="$VENV/bin:$PATH"

# 2. Pre-Execution Identity Capture
BEFORE_HEAD=$(git -C "$WORKTREE_ROOT" rev-parse HEAD)
BEFORE_TREE=$(git -C "$WORKTREE_ROOT" rev-parse HEAD^{tree})

echo "BEFORE_HEAD: $BEFORE_HEAD" > "${RECEIPT_ROOT}/identity.receipt"
echo "BEFORE_TREE: $BEFORE_TREE" >> "${RECEIPT_ROOT}/identity.receipt"

# 3. Test Execution & Output Retention
cd "$APP_DIR" || exit 1

# Note: The test command is executed purely within the isolated environment.
uv run pytest tests/test_plane_lifecycle_contract_v3.py tests/test_plane_operator_v3.py tests/test_plane_lifecycle_contract_v2.py \
    > "${RECEIPT_ROOT}/pytest-stdout.log" \
    2> "${RECEIPT_ROOT}/pytest-stderr.log" || EXIT_CODE=$?

# Ensure an exit code is captured unconditionally
echo "${EXIT_CODE:-0}" > "${RECEIPT_ROOT}/pytest-exit.receipt"

# 4. Post-Execution Identity & Integrity Validations
AFTER_HEAD=$(git -C "$WORKTREE_ROOT" rev-parse HEAD)
AFTER_TREE=$(git -C "$WORKTREE_ROOT" rev-parse HEAD^{tree})

echo "AFTER_HEAD: $AFTER_HEAD" >> "${RECEIPT_ROOT}/identity.receipt"
echo "AFTER_TREE: $AFTER_TREE" >> "${RECEIPT_ROOT}/identity.receipt"

# 5. Tree Cleanliness Verification
git -C "$WORKTREE_ROOT" diff --check > "${RECEIPT_ROOT}/git-diff-check.receipt"
git -C "$WORKTREE_ROOT" status --porcelain > "${RECEIPT_ROOT}/git-status.receipt"

# 6. Allowlist Digest Validations
sha256sum docs/HERMES-236-v3-test-matrix.md > "${RECEIPT_ROOT}/allowlist-digests.receipt"
sha256sum src/plane_mcp_karval/assets/plane-state-role-registry.v3.json >> "${RECEIPT_ROOT}/allowlist-digests.receipt"
sha256sum tests/test_plane_lifecycle_contract_v3.py >> "${RECEIPT_ROOT}/allowlist-digests.receipt"
sha256sum tests/test_plane_operator_v3.py >> "${RECEIPT_ROOT}/allowlist-digests.receipt"
sha256sum src/plane_mcp_karval/lifecycle_transition_contract.py >> "${RECEIPT_ROOT}/allowlist-digests.receipt"
sha256sum src/plane_mcp_karval/server.py >> "${RECEIPT_ROOT}/allowlist-digests.receipt"

# 7. No-Residual Requirements Assertion
# Confirm no rogue test or server processes are left dangling in the background.
if pgrep -f "$VENV" > /dev/null; then
    echo "ERROR: Residual processes detected." > "${RECEIPT_ROOT}/residual-processes.receipt"
    pgrep -f "$VENV" -a >> "${RECEIPT_ROOT}/residual-processes.receipt"
else
    echo "CLEAN: No residual processes." > "${RECEIPT_ROOT}/residual-processes.receipt"
fi
```
