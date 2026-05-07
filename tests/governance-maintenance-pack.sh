#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKFLOW="${ROOT}/.github/workflows/accelerate-tests.yml"
PACKETS_README="${ROOT}/core/runtime-packets/README.md"
DASHBOARD="${ROOT}/core/control-plane/capability-maturity-dashboard.md"
GITHUB_CAPS="${ROOT}/adapters/workflow/github-pr/capabilities.yaml"
LINEAR_CAPS="${ROOT}/adapters/workflow/linear/capabilities.yaml"
REMOTE_REGISTRY="${ROOT}/adapters/workflow/remote-write-registry.yaml"

fail() {
  echo "governance maintenance pack test failed: $*" >&2
  exit 1
}

require_file() {
  [ -f "$1" ] || fail "missing required file: ${1#${ROOT}/}"
}

require_match() {
  local pattern="$1"
  local file="$2"
  grep -Eq "$pattern" "$file" || fail "${file#${ROOT}/} missing pattern: ${pattern}"
}

require_file "$WORKFLOW"
require_file "$PACKETS_README"
require_file "$DASHBOARD"
require_file "$GITHUB_CAPS"
require_file "$LINEAR_CAPS"
require_file "$REMOTE_REGISTRY"

require_match 'uses: actions/checkout@v5' "$WORKFLOW"
if grep -Eq 'actions/checkout@v4|FORCE_JAVASCRIPT_ACTIONS_TO_NODE24|GitHub is deprecating Node.js 20' "$WORKFLOW"; then
  fail "workflow still carries Node 20 compatibility fallback instead of native checkout@v5"
fi

for packet in \
  templates.md \
  visual-modeling-packet.md \
  observability-performance-packet.md \
  ship-readiness-packet.md \
  deploy-verification-packet.md \
  qa-report-packet.md \
  review-finding-schema.md \
  task-ledger-schema.md \
  context-checkpoint-packet.md \
  decision-audit-trail.md; do
  require_match "${packet}" "$PACKETS_README"
done

for column in \
  'Packet \| Trigger \| Required fields \| Gate / owner \| Test coverage' \
  'Required Maintenance Rule' \
  'tests/visual-modeling-contract.sh' \
  'tests/production-readiness-gate.sh'; do
  require_match "$column" "$PACKETS_README"
done

for term in \
  'Capability Maturity Dashboard' \
  'Status Vocabulary' \
  'Workflow Adapter Summary' \
  'Remote Write Registry Summary' \
  'Next promotion condition' \
  'github-pr-create' \
  'github-pr-land' \
  'linear-mcp-create' \
  'structured_non_llm_mcp_write_binding_required'; do
  require_match "$term" "$DASHBOARD"
done

require_match 'production_merge_land_gate: native' "$GITHUB_CAPS"
require_match 'production_merge_land_gate_proof: planning/evidence/dated-proof-appendix/github-pr-land-live-validation-2026-05-07.md' "$GITHUB_CAPS"
require_match 'create_update: blocked' "$LINEAR_CAPS"
require_match 'structured_write: no' "$REMOTE_REGISTRY"
require_match 'github-pr-land' "$REMOTE_REGISTRY"
require_match 'status: available' "$REMOTE_REGISTRY"
require_match 'live_proof: planning/evidence/dated-proof-appendix/github-pr-land-live-validation-2026-05-07.md' "$REMOTE_REGISTRY"

python3 - "$ROOT" "$GITHUB_CAPS" "$REMOTE_REGISTRY" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
github_caps = Path(sys.argv[2]).read_text()
registry = Path(sys.argv[3]).read_text()
proof = "planning/evidence/dated-proof-appendix/github-pr-land-live-validation-2026-05-07.md"

if f"production_merge_land_gate_proof: {proof}" not in github_caps:
    raise SystemExit("governance maintenance pack test failed: github land proof locator missing")
if not (root / proof).is_file():
    raise SystemExit("governance maintenance pack test failed: github land proof file missing")

blocks = re.split(r"\n\s*- id:\s*", registry)
land = None
for raw in blocks[1:]:
    block = "id: " + raw
    if re.search(r"^id:\s*github-pr-land\s*$", block, re.M):
        land = block
        break
if land is None:
    raise SystemExit("governance maintenance pack test failed: github-pr-land registry block missing")
for expected in ["status: available", f"live_proof: {proof}", "requires_opt_in: ACCELERATE_ALLOW_LAND"]:
    if expected not in land:
        raise SystemExit(f"governance maintenance pack test failed: github-pr-land block missing {expected}")
PY

echo "governance maintenance pack tests passed"
