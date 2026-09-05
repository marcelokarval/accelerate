# TASK-V10-R: Deterministic Proof-Harness Specification (Read-Only Correction)

**Timestamp:** 2026-09-04T14:35:00-04:00
**Author:** `plane-runtime-exec-hiro`

This document defines the strict, standalone immutable evidence specification to validate a future restored detached worktree. **This is a template demonstration only.** No structural modifications, live tests, worktrees, or configuration changes were executed.

## Immutable Execution Template

```bash
#!/usr/bin/env bash
# Do not use set -e to allow capturing receipts for failed tests/assertions unconditionally
set -uo pipefail

# 1. Directory and Environment Declarations
EXPECTED_HEAD="26488c53ec9852ae8d02adfecaf86694f50e3c8c"
WORKTREE_ROOT="/home/marcelo-karval/.local/share/plane-mcp-karval/releases/26488c53ec9852ae8d02adfecaf86694f50e3c8c"
APP_DIR="${WORKTREE_ROOT}/apps/mcp-servers/plane-mcp-karval"
# Explicit, absolute receipt root physically outside the worktree
RECEIPT_ROOT="/home/marcelo-karval/Backup/Projetos/accelerate/planning/evidence/dated-proof-appendix/hermes-238/receipts-v3"

# Validate and ensure receipt root is writable
mkdir -p "${RECEIPT_ROOT}"
if [[ ! -w "${RECEIPT_ROOT}" ]]; then
    echo "ERROR: RECEIPT_ROOT is not writable" >&2
    exit 1
fi

VENV="/home/marcelo-karval/.local/share/plane-mcp-karval/venvs/26488c53ec9852ae8d02adfecaf86694f50e3c8c"
export VIRTUAL_ENV="$VENV"
export PATH="$VENV/bin:$PATH"

# Prevent writing bytecode and cache inside the worktree
export PYTHONDONTWRITEBYTECODE=1
export TMPDIR="${RECEIPT_ROOT}/tmp"
mkdir -p "$TMPDIR"

# 2. Pre-Execution Identity Assertions
cd "$WORKTREE_ROOT" || exit 1
TOP_LEVEL=$(git rev-parse --show-toplevel)
if [[ "$TOP_LEVEL" != "$WORKTREE_ROOT" ]]; then
    echo "ERROR: WORKTREE_ROOT is not a valid git top-level directory."
    exit 1
fi

BEFORE_HEAD=$(git rev-parse HEAD)
if [[ "$BEFORE_HEAD" != "$EXPECTED_HEAD" ]]; then
    echo "ERROR: Expected HEAD $EXPECTED_HEAD but got $BEFORE_HEAD"
    exit 1
fi
BEFORE_TREE=$(git rev-parse HEAD^{tree})

echo "BEFORE_HEAD: $BEFORE_HEAD" > "${RECEIPT_ROOT}/identity.receipt"
echo "BEFORE_TREE: $BEFORE_TREE" >> "${RECEIPT_ROOT}/identity.receipt"

# 3. Test Execution & Receipt Capture
cd "$APP_DIR" || exit 1
echo "VENV Python Interpreter proof:" > "${RECEIPT_ROOT}/interpreter.receipt"
which python >> "${RECEIPT_ROOT}/interpreter.receipt"
python -c "import sys; print(sys.executable)" >> "${RECEIPT_ROOT}/interpreter.receipt"

# Run tests using a strictly offline, no-sync controlled test runner without pytest cache
uv run --offline --no-sync pytest tests/test_plane_lifecycle_contract_v3.py tests/test_plane_operator_v3.py tests/test_plane_lifecycle_contract_v2.py \
    -p no:cacheprovider \
    > "${RECEIPT_ROOT}/pytest-stdout.log" \
    2> "${RECEIPT_ROOT}/pytest-stderr.log"
TEST_EXIT=$?
echo "${TEST_EXIT}" > "${RECEIPT_ROOT}/pytest-exit.receipt"

# 4. Post-Execution Identity & Integrity Capture
cd "$WORKTREE_ROOT" || exit 1
AFTER_HEAD=$(git rev-parse HEAD)
AFTER_TREE=$(git rev-parse HEAD^{tree})

echo "AFTER_HEAD: $AFTER_HEAD" >> "${RECEIPT_ROOT}/identity.receipt"
echo "AFTER_TREE: $AFTER_TREE" >> "${RECEIPT_ROOT}/identity.receipt"

# 5. Immutable Tree & State Assertions
INVARIANT_FAIL=0
echo "" > "${RECEIPT_ROOT}/invariants.receipt"

if [[ "$BEFORE_HEAD" != "$AFTER_HEAD" ]]; then
    echo "INVARIANT FAILURE: HEAD drifted! ($BEFORE_HEAD -> $AFTER_HEAD)" >> "${RECEIPT_ROOT}/invariants.receipt"
    INVARIANT_FAIL=1
fi
if [[ "$BEFORE_TREE" != "$AFTER_TREE" ]]; then
    echo "INVARIANT FAILURE: Tree drifted! ($BEFORE_TREE -> $AFTER_TREE)" >> "${RECEIPT_ROOT}/invariants.receipt"
    INVARIANT_FAIL=1
fi

git diff --check > "${RECEIPT_ROOT}/git-diff-check.receipt" || { 
    echo "INVARIANT FAILURE: Diff check failed (whitespace or conflict markers)" >> "${RECEIPT_ROOT}/invariants.receipt"
    INVARIANT_FAIL=1
}

PORCELAIN=$(git status --porcelain)
echo "$PORCELAIN" > "${RECEIPT_ROOT}/git-status.receipt"
if [[ -n "$PORCELAIN" ]]; then
    echo "INVARIANT FAILURE: Tree is not clean (untracked/modified files exist)" >> "${RECEIPT_ROOT}/invariants.receipt"
    INVARIANT_FAIL=1
fi

# 6. Comprehensive Digest Manifest
# Hash every tracked file in the APP_DIR to ensure absolute structural parity and no hidden mutations
git ls-files -z "apps/mcp-servers/plane-mcp-karval" | xargs -0 sha256sum > "${RECEIPT_ROOT}/all-tracked-files-digests.receipt"

# Isolate the exact allowlist files for explicit assertion
grep -E '(HERMES-236-v3-test-matrix.md|plane-state-role-registry.v3.json|test_plane_lifecycle_contract_v3.py|test_plane_operator_v3.py|lifecycle_transition_contract.py|src/plane_mcp_karval/server.py)$' "${RECEIPT_ROOT}/all-tracked-files-digests.receipt" > "${RECEIPT_ROOT}/allowlist-digests.receipt"

# 7. No-Residual Requirements
if pgrep -f "$VENV" > /dev/null; then
    echo "INVARIANT FAILURE: Residual processes detected." >> "${RECEIPT_ROOT}/invariants.receipt"
    pgrep -f "$VENV" -a > "${RECEIPT_ROOT}/residual-processes.receipt"
    INVARIANT_FAIL=1
fi

# 8. Terminal Evaluation
if [[ $TEST_EXIT -ne 0 || $INVARIANT_FAIL -ne 0 ]]; then
    echo "FATAL: Validation failed. Test Exit: $TEST_EXIT, Invariant Failures: $INVARIANT_FAIL" >&2
    exit 1
fi

echo "SUCCESS: All tests and invariants passed cleanly."
exit 0
```
