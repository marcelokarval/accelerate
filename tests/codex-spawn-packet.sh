#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'codex spawn packet failed: %s\n' "$1" >&2
  exit 1
}

topology="adapters/runtime/codex/logical-agent-topology.toml"
policy="adapters/runtime/codex-collaboration/role-policy.json"
renderer="scripts/render-codex-spawn-packet.py"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

common=(
  --task-id CODEX-1
  --objective "Bounded collaboration proof"
  --scope "adapters/runtime/codex-collaboration"
  --evidence "bash tests/codex-spawn-packet.sh"
  --validation-owner root
  --context "Current worktree and governed issue"
)

expect_reject() {
  local label="$1"
  local expected="$2"
  shift
  shift
  if python3 "$renderer" "$topology" --policy "$policy" "${common[@]}" "$@" >"$tmp_dir/$label.out" 2>"$tmp_dir/$label.err"; then
    fail "renderer accepted invalid case: $label"
  fi
  rg -F -- "$expected" "$tmp_dir/$label.err" >/dev/null || fail "wrong rejection for $label: expected $expected"
}

packet="$(python3 "$renderer" "$topology" --policy "$policy" --route scoped --agent python-backend --write-scope 'scripts/service.py tests/service.sh' "${common[@]}")"
[ "$(printf '%s\n' "$packet" | wc -l)" -le 10 ] || fail 'packet exceeds ten output lines'
printf '%s\n' "$packet" | rg -F 'role=backend; profile=implementation; model=gpt-5.6-terra; effort=medium' >/dev/null || fail 'explicit binding is missing'
printf '%s\n' "$packet" | rg -F 'routing metadata only; not injected into native spawn' >/dev/null || fail 'logical profile is overstated'
printf '%s\n' "$packet" | rg -F 'validation owner=root' >/dev/null || fail 'validation owner is missing'
printf '%s\n' "$packet" | rg -F 'files_changed, behavior, validations, skipped_checks' >/dev/null || fail 'implementation return fields are missing'

research_packet="$(python3 "$renderer" "$topology" --policy "$policy" --route scoped --role-family research --profile explorer --write-scope read-only "${common[@]}")"
printf '%s\n' "$research_packet" | rg -F 'role=research; profile=explorer; model=gpt-5.6-luna; effort=low' >/dev/null || fail 'research explorer binding is missing'
printf '%s\n' "$research_packet" | rg -F 'paths_and_lines, answer, gaps' >/dev/null || fail 'explorer return fields are missing'

expect_reject wrong-role-profile 'profile explorer is not bound to role architecture' --route scoped --role-family architecture --profile explorer --write-scope read-only
expect_reject logical-role-mismatch 'logical agent research belongs to research, not architecture' --route scoped --agent research --role-family architecture --write-scope read-only
expect_reject logical-profile-mismatch 'logical agent research requires profile librarian, not explorer' --route scoped --agent research --profile explorer --write-scope read-only
expect_reject direct-fast-path 'direct-fast-path cannot bind a subagent' --route direct-fast-path --role-family research --profile explorer --write-scope read-only
expect_reject read-only-write-scope 'profile explorer is read-only' --route scoped --role-family research --profile explorer --write-scope scripts/discovery.py
expect_reject writer-read-only-scope 'writer profile implementation requires a bounded write scope' --route scoped --role-family backend --profile implementation --write-scope read-only
expect_reject high-without-receipt 'profile high-stakes-review requires --reasoning-receipt' --route scoped --role-family security --profile high-stakes-review --write-scope read-only
expect_reject high-with-invalid-receipt 'invalid reasoning receipt' --route scoped --role-family security --profile high-stakes-review --write-scope read-only --reasoning-receipt artifact:not-a-local-receipt
expect_reject multiline-role 'role family must be a non-empty single-line value' --route scoped --role-family $'research\narchitecture' --profile explorer --write-scope read-only
expect_reject wildcard-scope 'scope cannot contain a wildcard' --route scoped --role-family research --profile explorer --scope '*' --write-scope read-only
expect_reject wildcard-write-scope 'write scope cannot contain a wildcard' --route scoped --role-family backend --profile implementation --write-scope '*'

invalid_policy="$tmp_dir/invalid-policy.json"
cp "$policy" "$invalid_policy"
sed -i 's/"duplicate_active_lane": "forbidden"/"duplicate_active_lane": "allowed"/' "$invalid_policy"
if python3 "$renderer" "$topology" --policy "$invalid_policy" --route scoped --role-family research --profile explorer --write-scope read-only "${common[@]}" >"$tmp_dir/invalid-policy.out" 2>"$tmp_dir/invalid-policy.err"; then
  fail 'renderer accepted an invalid collaboration policy'
fi
rg -F 'collaboration policy is invalid' "$tmp_dir/invalid-policy.err" >/dev/null || fail 'invalid policy rejection was not semantic'

invalid_topology="$tmp_dir/invalid-topology.toml"
cp "$topology" "$invalid_topology"
sed -i '0,/role_family = "research"/s//role_family = "architecture"/' "$invalid_topology"
if python3 "$renderer" "$invalid_topology" --policy "$policy" --route scoped --agent research --write-scope read-only "${common[@]}" >"$tmp_dir/invalid-topology.out" 2>"$tmp_dir/invalid-topology.err"; then
  fail 'renderer accepted an invalid logical topology'
fi
rg -F 'logical topology is invalid' "$tmp_dir/invalid-topology.err" >/dev/null || fail 'invalid topology rejection was not semantic'

high_packet="$(python3 "$renderer" "$topology" --policy "$policy" --route scoped --role-family security --profile high-stakes-review --write-scope read-only --reasoning-receipt 'tests/fixtures/high-reasoning-receipt.json' "${common[@]}")"
printf '%s\n' "$high_packet" | rg -F 'reasoning receipt=tests/fixtures/high-reasoning-receipt.json' >/dev/null || fail 'high receipt is missing'
printf '%s\n' "$high_packet" | rg -F 'Root only: issue topology, external writes, integration, review-of-review, closure.' >/dev/null || fail 'root authority boundary is missing'
printf '%s\n' "$high_packet" | rg -F 'reuse relevant context; no duplicate active lane; interruption is not rollback; reconcile partial shared changes before replacement' >/dev/null || fail 'session lifecycle contract is missing'

printf 'codex spawn packet passed\n'
