# TASK-V10-R2: Deterministic Proof-Harness Specification (Read-Only Correction)

**Timestamp:** 2026-09-04T14:38:00-04:00
**Author:** `plane-runtime-exec-hiro`

This document defines the strict, standalone immutable evidence specification to validate a future restored detached worktree. **This is a template demonstration only.** No structural modifications, live tests, worktrees, or configuration changes were executed.

## Immutable Execution Template

```bash
#!/usr/bin/env bash
# Do not use set -e to allow unconditional receipt captures
set -uo pipefail

# 1. Identity & Environment Declarations
EXPECTED_HEAD="26488c53ec9852ae8d02adfecaf86694f50e3c8c"
WORKTREE_ROOT="/home/marcelo-karval/.local/share/plane-mcp-karval/releases/26488c53ec9852ae8d02adfecaf86694f50e3c8c"
APP_DIR="${WORKTREE_ROOT}/apps/mcp-servers/plane-mcp-karval"
VENV="/home/marcelo-karval/.local/share/plane-mcp-karval/venvs/26488c53ec9852ae8d02adfecaf86694f50e3c8c"

# Timestamp-based absolute, isolated receipt root (ensures new/empty per run)
RUN_TIMESTAMP=$(date -u +"%Y%m%dT%H%M%SZ")
RECEIPT_ROOT="/home/marcelo-karval/Backup/Projetos/accelerate/planning/evidence/dated-proof-appendix/hermes-238/receipts-v3-run-${RUN_TIMESTAMP}"

# Prove RECEIPT_ROOT is explicitly outside WORKTREE_ROOT
if [[ "${RECEIPT_ROOT}" == "${WORKTREE_ROOT}"* ]]; then
    echo "FATAL: RECEIPT_ROOT must be outside WORKTREE_ROOT" >&2
    exit 1
fi
# Prove RECEIPT_ROOT does not already exist (no reuse/overwrite)
if [[ -e "${RECEIPT_ROOT}" ]]; then
    echo "FATAL: RECEIPT_ROOT already exists; no reuse/overwrite permitted" >&2
    exit 1
fi

mkdir -p "${RECEIPT_ROOT}"
if [[ ! -w "${RECEIPT_ROOT}" ]]; then
    echo "FATAL: RECEIPT_ROOT is not writable" >&2
    exit 1
fi

export VIRTUAL_ENV="$VENV"
export PATH="$VENV/bin:$PATH"

export PYTHONDONTWRITEBYTECODE=1
export TMPDIR="${RECEIPT_ROOT}/tmp"
mkdir -p "$TMPDIR"

# 2. Pre-Execution Verification
TOP_LEVEL=$(git -C "$WORKTREE_ROOT" rev-parse --show-toplevel)
if [[ "$TOP_LEVEL" != "$WORKTREE_ROOT" ]]; then
    echo "FATAL: WORKTREE_ROOT is not a valid git top-level directory."
    exit 1
fi

# Assert explicitly detached HEAD via symbolic-ref failure
if git -C "$WORKTREE_ROOT" symbolic-ref -q HEAD > /dev/null; then
    echo "FATAL: WORKTREE_ROOT is not a detached HEAD."
    exit 1
fi

BEFORE_HEAD=$(git -C "$WORKTREE_ROOT" rev-parse HEAD)
if [[ "$BEFORE_HEAD" != "$EXPECTED_HEAD" ]]; then
    echo "FATAL: Expected HEAD $EXPECTED_HEAD but got $BEFORE_HEAD"
    exit 1
fi
BEFORE_TREE=$(git -C "$WORKTREE_ROOT" rev-parse HEAD^{tree})

echo "BEFORE_HEAD: $BEFORE_HEAD" > "${RECEIPT_ROOT}/identity.receipt"
echo "BEFORE_TREE: $BEFORE_TREE" >> "${RECEIPT_ROOT}/identity.receipt"

# Pre-tracked manifest extraction using git -C explicitly
git -C "$WORKTREE_ROOT" ls-files -z "apps/mcp-servers/plane-mcp-karval" | xargs -0 -I{} git -C "$WORKTREE_ROOT" hash-object "{}" > "${RECEIPT_ROOT}/pre-tracked-manifest.receipt" || { echo "FATAL: Pre-manifest generation failed"; exit 1; }

# 3. Controlled Execution
cd "$APP_DIR" || exit 1

echo "Interpreter evidence:" > "${RECEIPT_ROOT}/interpreter.receipt"
which python >> "${RECEIPT_ROOT}/interpreter.receipt"
python -c "import sys; print(sys.executable)" >> "${RECEIPT_ROOT}/interpreter.receipt"

uv run --offline --no-sync pytest tests/test_plane_lifecycle_contract_v3.py tests/test_plane_operator_v3.py tests/test_plane_lifecycle_contract_v2.py \
    -p no:cacheprovider \
    > "${RECEIPT_ROOT}/pytest-stdout.log" \
    2> "${RECEIPT_ROOT}/pytest-stderr.log"
TEST_EXIT=$?
echo "${TEST_EXIT}" > "${RECEIPT_ROOT}/pytest-exit.receipt"

cd "$WORKTREE_ROOT" || exit 1

# 4. Post-Execution Validations
INVARIANT_FAIL=0
echo "" > "${RECEIPT_ROOT}/invariants.receipt"

AFTER_HEAD=$(git -C "$WORKTREE_ROOT" rev-parse HEAD)
AFTER_TREE=$(git -C "$WORKTREE_ROOT" rev-parse HEAD^{tree})
echo "AFTER_HEAD: $AFTER_HEAD" >> "${RECEIPT_ROOT}/identity.receipt"
echo "AFTER_TREE: $AFTER_TREE" >> "${RECEIPT_ROOT}/identity.receipt"

if [[ "$BEFORE_HEAD" != "$AFTER_HEAD" ]]; then
    echo "INVARIANT FAILURE: HEAD drifted" >> "${RECEIPT_ROOT}/invariants.receipt"
    INVARIANT_FAIL=1
fi
if [[ "$BEFORE_TREE" != "$AFTER_TREE" ]]; then
    echo "INVARIANT FAILURE: Tree drifted" >> "${RECEIPT_ROOT}/invariants.receipt"
    INVARIANT_FAIL=1
fi

git -C "$WORKTREE_ROOT" diff --check > "${RECEIPT_ROOT}/git-diff-check.receipt" || {
    echo "INVARIANT FAILURE: diff check failed" >> "${RECEIPT_ROOT}/invariants.receipt"
    INVARIANT_FAIL=1
}

PORCELAIN=$(git -C "$WORKTREE_ROOT" status --porcelain --untracked-files=all)
echo "$PORCELAIN" > "${RECEIPT_ROOT}/git-status.receipt"
if [[ -n "$PORCELAIN" ]]; then
    echo "INVARIANT FAILURE: Tree is not clean" >> "${RECEIPT_ROOT}/invariants.receipt"
    INVARIANT_FAIL=1
fi

# Post-tracked manifest & Byte-identical comparison
git -C "$WORKTREE_ROOT" ls-files -z "apps/mcp-servers/plane-mcp-karval" | xargs -0 -I{} git -C "$WORKTREE_ROOT" hash-object "{}" > "${RECEIPT_ROOT}/post-tracked-manifest.receipt" || { echo "INVARIANT FAILURE: Post-manifest generation failed"; INVARIANT_FAIL=1; }

if ! cmp -s "${RECEIPT_ROOT}/pre-tracked-manifest.receipt" "${RECEIPT_ROOT}/post-tracked-manifest.receipt"; then
    echo "INVARIANT FAILURE: PRE and POST tracked manifests differ byte-for-byte" >> "${RECEIPT_ROOT}/invariants.receipt"
    INVARIANT_FAIL=1
fi

# 5. Exact Allowlist Digest Execution
git -C "$WORKTREE_ROOT" ls-files -z "apps/mcp-servers/plane-mcp-karval" | xargs -0 -I{} sha256sum "${WORKTREE_ROOT}/{}" > "${RECEIPT_ROOT}/all-tracked-files-digests.receipt" || { echo "INVARIANT FAILURE: SHA256 hashing failed"; INVARIANT_FAIL=1; }

EXPECTED_ALLOWLIST=(
    "apps/mcp-servers/plane-mcp-karval/docs/HERMES-236-v3-test-matrix.md"
    "apps/mcp-servers/plane-mcp-karval/src/plane_mcp_karval/assets/plane-state-role-registry.v3.json"
    "apps/mcp-servers/plane-mcp-karval/tests/test_plane_lifecycle_contract_v3.py"
    "apps/mcp-servers/plane-mcp-karval/tests/test_plane_operator_v3.py"
    "apps/mcp-servers/plane-mcp-karval/src/plane_mcp_karval/lifecycle_transition_contract.py"
    "apps/mcp-servers/plane-mcp-karval/src/plane_mcp_karval/server.py"
)

> "${RECEIPT_ROOT}/allowlist-digests.receipt"
for path in "${EXPECTED_ALLOWLIST[@]}"; do
    if ! grep -F "$path" "${RECEIPT_ROOT}/all-tracked-files-digests.receipt" >> "${RECEIPT_ROOT}/allowlist-digests.receipt"; then
        echo "INVARIANT FAILURE: Missing allowlist path: $path" >> "${RECEIPT_ROOT}/invariants.receipt"
        INVARIANT_FAIL=1
    fi
done

FOUND_ALLOWLIST_COUNT=$(wc -l < "${RECEIPT_ROOT}/allowlist-digests.receipt")
if [[ "$FOUND_ALLOWLIST_COUNT" -ne 6 ]]; then
    echo "INVARIANT FAILURE: Found $FOUND_ALLOWLIST_COUNT allowlist paths, expected exactly 6" >> "${RECEIPT_ROOT}/invariants.receipt"
    INVARIANT_FAIL=1
fi

# 6. Residual Process Check
if pgrep -f "$VENV" > /dev/null; then
    echo "INVARIANT FAILURE: Residual processes detected." >> "${RECEIPT_ROOT}/invariants.receipt"
    pgrep -f "$VENV" -a > "${RECEIPT_ROOT}/residual-processes.receipt"
    INVARIANT_FAIL=1
fi

# 7. Terminal Evaluation
if [[ $TEST_EXIT -ne 0 || $INVARIANT_FAIL -ne 0 ]]; then
    echo "FATAL: Validation failed. Test Exit: $TEST_EXIT, Invariants: $INVARIANT_FAIL" >&2
    cat "${RECEIPT_ROOT}/invariants.receipt" >&2
    exit 1
fi

echo "SUCCESS: All validations passed."
exit 0
```
