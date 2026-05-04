#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'template-promotion-readiness failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

contract="agents/promotion/template-promotion-readiness.md"
packet="planning/promotion/template-promotion-readiness-packet.md"
promotion_readme="agents/promotion/README.md"
templates_readme="agents/templates/README.md"

[ -f "$contract" ] || fail "missing template promotion readiness contract"
[ -f "$packet" ] || fail "missing template promotion readiness packet"

for state in template-only candidate-defined contract-approved runtime-adapter-bound empirically-replayed promoted; do
  require_match "$state" "$contract"
  require_match "$state" "$packet"
done

for field in \
  'template path' \
  'base contract reference' \
  'selected role family' \
  'compatible capability family' \
  'required skills / profiles' \
  'prohibited authority' \
  'return contract' \
  'cleanup behavior' \
  'review isolation plan' \
  'root integration plan' \
  'runtime adapter binding status' \
  'empirical replay status' \
  'root-only or virtual fallback' \
  'promotion state'; do
  require_match "$field" "$contract"
  require_match "$field" "$packet"
done

require_match 'template-only.*only valid state without empirical replay|only valid state without empirical replay' "$packet"
require_match 'Runtime adapter status `planned` cannot support `promoted`' "$packet"
require_match 'template-promotion-readiness.md' "$promotion_readme"
require_match 'template-promotion-readiness-packet.md' "$templates_readme"

printf 'template promotion readiness passed\n'
