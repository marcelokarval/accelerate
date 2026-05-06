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

require_match '^env:$' "$WORKFLOW"
require_match 'FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: true' "$WORKFLOW"
require_match 'GitHub is deprecating Node.js 20' "$WORKFLOW"

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

require_match 'production_merge_land_gate: planned' "$GITHUB_CAPS"
require_match 'create_update: blocked' "$LINEAR_CAPS"
require_match 'structured_write: no' "$REMOTE_REGISTRY"
require_match 'github-pr-land' "$REMOTE_REGISTRY"

echo "governance maintenance pack tests passed"
