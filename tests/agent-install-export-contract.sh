#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'agent-install-export-contract failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

contract="agents/promotion/install-export-contract.md"
readiness="agents/promotion/template-promotion-readiness.md"
packet="planning/promotion/template-promotion-readiness-packet.md"
promotion_readme="agents/promotion/README.md"
agents_readme="agents/README.md"
runtime_contract="adapters/runtime/host-export-contract.md"

for path in "$contract" "$readiness" "$packet" "$promotion_readme" "$agents_readme" "$runtime_contract"; do
  [ -f "$path" ] || fail "missing $path"
done

for state in doctrine-only template-only candidate-defined contract-approved runtime-adapter-bound installed exported empirically-replayed promoted rolled-back; do
  require_match "$state" "$contract"
done

for field in \
  'source artifact path' \
  'target host' \
  'target path' \
  'privacy classification' \
  'validation command' \
  'rollback command' \
  'fallback mode'; do
  require_match "$field" "$contract"
done

require_match 'installed.*not.*promoted|installed.*not promotion|installed` and `exported` are not' "$contract"
require_match 'exported.*not authority|generated copy only' "$contract"
require_match 'install-export-contract.md' "$readiness"
require_match 'install state' "$packet"
require_match 'export state' "$packet"
require_match 'install/export contract' "$packet"
require_match 'installed` and `exported` are host/export facts, not promotion states' "$packet"
require_match 'install-export-contract.md' "$promotion_readme"
require_match 'promotion/install-export-contract.md' "$agents_readme"
require_match 'cannot promote, install, or create real physical agents' "$runtime_contract"

printf 'agent install/export contract passed\n'
