#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'codex logical agent topology failed: %s\n' "$1" >&2
  exit 1
}

topology="adapters/runtime/codex/logical-agent-topology.toml"
catalog="adapters/runtime/codex/skill-catalog-manifest.toml"
policy="adapters/runtime/codex-collaboration/role-policy.json"
validator="scripts/validate-codex-logical-agent-topology.py"
renderer="scripts/render-codex-logical-agent.py"
assignment="scripts/render-codex-spawn-packet.py"

for path in "$topology" "$catalog" "$policy" "$validator" "$renderer" "$assignment"; do
  [ -f "$path" ] || fail "missing $path"
done
rg -F 'fork_turns_override = "integer-1-to-5-only"' "$topology" >/dev/null || fail 'topology does not declare the 1..5 fork override bound'
rg -F 'global-budget-exactly-3' "$topology" >/dev/null || fail 'topology does not declare the exact nested physical budget'
rg -F 'Tester=verifier+verification' "$topology" >/dev/null || fail 'topology does not declare Tester as verifier plus verification'
rg -F 'specialize assignments by surface and domain_path rather than creating profiles' "$topology" >/dev/null || fail 'topology permits profile explosion instead of assignment specialization'

python3 "$validator" "$topology" "$catalog" "$policy"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

for agent in python-backend nextjs-frontend research reviewer qa data-db integrations-ops; do
  output="$tmp_dir/${agent}.config.toml"
  python3 "$renderer" "$topology" "$catalog" --agent "$agent" --output "$output"
  [ -s "$output" ] || fail "empty profile for $agent"
  rg -F "# Generated from the governed logical-agent topology." "$output" >/dev/null || fail "missing provenance for $agent"
  ! rg -F '*' "$output" >/dev/null || fail "wildcard in $agent profile"
done

for agent in data-db integrations-ops; do
  output="$tmp_dir/${agent}.config.toml"
  rg -F '# logical_agent = "'"$agent"'"' "$output" >/dev/null || fail "missing logical agent identity for $agent"
  rg -F 'model = "gpt-5.6-terra"' "$output" >/dev/null || fail "$agent must use Terra"
  rg -F 'model_reasoning_effort = "medium"' "$output" >/dev/null || fail "$agent must use medium reasoning"
done

if python3 "$renderer" "$topology" "$catalog" --agent orchestrator --output "$tmp_dir/orchestrator.config.toml" >/dev/null 2>&1; then
  fail 'renderer accepted orchestrator as an additive profile'
fi
rg -F 'python-pro/SKILL.md", enabled = true' "$tmp_dir/python-backend.config.toml" >/dev/null || fail 'python profile missing'
! rg -F 'nextjs-app-router-patterns/SKILL.md' "$tmp_dir/python-backend.config.toml" >/dev/null || fail 'python profile leaked frontend skill'
rg -F 'nextjs-app-router-patterns/SKILL.md", enabled = true' "$tmp_dir/nextjs-frontend.config.toml" >/dev/null || fail 'frontend profile missing'
! rg -F 'python-pro/SKILL.md' "$tmp_dir/nextjs-frontend.config.toml" >/dev/null || fail 'frontend profile leaked python skill'

packet="$(python3 "$assignment" "$topology" --agent python-backend --task-id CODEX-1 --objective 'Add one bounded backend change' --scope 'src/service.py' --write-scope 'src/service.py tests/test_service.py' --evidence 'pytest tests/test_service.py' --context 'Use the active issue and current worktree.')"
printf '%s\n' "$packet" | rg -F 'Spawn Packet' >/dev/null || fail 'spawn packet missing heading'
[ "$(printf '%s\n' "$packet" | rg -c '^-' || true)" -le 10 ] || fail 'spawn packet exceeds ten lines'
printf '%s\n' "$packet" | rg -F 'Root only: issue topology, external writes, integration, review-of-review, closure.' >/dev/null || fail 'root boundary missing'
printf '%s\n' "$packet" | rg -F 'No nested spawn; return only evidence, risks, and recommendation.' >/dev/null || fail 'return boundary missing'
printf '%s\n' "$packet" | rg -F 'Physical binding: model override gpt-5.6-terra/medium; fork_turns = none.' >/dev/null || fail 'default physical binding missing'

research_packet="$(python3 "$assignment" "$topology" --agent research --task-id CODEX-1 --objective 'Inspect the bounded source' --scope 'docs/' --write-scope 'read-only' --evidence 'rg exact-term docs/' --context 'Return cited local evidence only.')"
printf '%s\n' "$research_packet" | rg -F 'Physical binding: model override gpt-5.6-luna/low; fork_turns = none; Luna is a leaf.' >/dev/null || fail 'research leaf binding missing'

bounded_packet="$(python3 "$assignment" "$topology" --agent python-backend --task-id CODEX-1 --objective 'Apply a bounded correction' --scope 'src/service.py' --write-scope 'src/service.py' --evidence 'pytest tests/test_service.py' --context 'Use the active issue and current worktree.' --fork-turns 2)"
printf '%s\n' "$bounded_packet" | rg -F 'Physical binding: model override gpt-5.6-terra/medium; fork_turns = 2.' >/dev/null || fail 'bounded fork_turns binding missing'

nested_packet="$(python3 "$assignment" "$topology" --agent python-backend --task-id CODEX-LUNA-1 --objective 'Apply prescribed mechanical correction' --scope 'src/luna-child.py' --write-scope 'src/luna-child.py' --evidence 'pytest tests/test_luna_child.py' --context 'Return mechanical proof only.' --nested-luna-child --parent-task-id CODEX-PARENT-1 --parent-reference 'CODEX-PARENT-1:call-terra->CODEX-LUNA-1' --parent-write-scope 'src/terra-parent.py' --root-authorization root-authorized-only --global-physical-budget 3 --terra-accountability required)"
[ "$(printf '%s\n' "$nested_packet" | rg -c '^-' || true)" -le 10 ] || fail 'nested spawn packet exceeds ten lines'
printf '%s\n' "$nested_packet" | rg -F 'Child supplement under Terra parent python-backend: luna-mechanical (mechanical-fixer; gpt-5.6-luna/medium).' >/dev/null || fail 'nested packet missing Luna mechanical child binding'
printf '%s\n' "$nested_packet" | rg -F 'Parent: python-backend; task CODEX-PARENT-1; reference CODEX-PARENT-1:call-terra->CODEX-LUNA-1; Terra accountability required.' >/dev/null || fail 'nested packet missing parent reference'
printf '%s\n' "$nested_packet" | rg -F 'Nested exception: root-authorized-only; global physical budget = 3 (Terra parent, Luna child, independent reviewer); scopes disjoint; Luna is a leaf.' >/dev/null || fail 'nested packet missing root-approved constraints'
! printf '%s\n' "$nested_packet" | rg -F 'No nested spawn' >/dev/null || fail 'nested packet retained default no-nesting denial'

if python3 "$assignment" "$topology" --agent python-backend --task-id CODEX-LUNA-1 --objective 'Apply prescribed mechanical correction' --scope 'src/luna-child.py' --write-scope 'src/luna-child.py' --evidence 'pytest tests/test_luna_child.py' --context 'Return mechanical proof only.' --nested-luna-child --parent-task-id CODEX-PARENT-1 --parent-reference 'CODEX-PARENT-1:call-terra->CODEX-LUNA-1' --parent-write-scope 'src/terra-parent.py' --root-authorization missing --global-physical-budget 3 --terra-accountability required >/dev/null 2>&1; then
  fail 'spawn packet accepted nested Luna without root authorization'
fi
if python3 "$assignment" "$topology" --agent python-backend --task-id CODEX-LUNA-1 --objective 'Apply prescribed mechanical correction' --scope 'src/terra-parent.py' --write-scope 'src/terra-parent.py' --evidence 'pytest tests/test_luna_child.py' --context 'Return mechanical proof only.' --nested-luna-child --parent-task-id CODEX-PARENT-1 --parent-reference 'CODEX-PARENT-1:call-terra->CODEX-LUNA-1' --parent-write-scope 'src/terra-parent.py' --root-authorization root-authorized-only --global-physical-budget 3 --terra-accountability required >/dev/null 2>&1; then
  fail 'spawn packet accepted overlapping nested Luna scope'
fi
if python3 "$assignment" "$topology" --agent python-backend --task-id CODEX-LUNA-1 --objective 'Apply prescribed mechanical correction' --scope 'src/luna-child.py' --write-scope 'src/luna-child.py' --evidence 'pytest tests/test_luna_child.py' --context 'Return mechanical proof only.' --nested-luna-child --parent-task-id CODEX-PARENT-1 --parent-reference 'CODEX-PARENT-1:call-terra->CODEX-LUNA-1' --parent-write-scope 'src/terra-parent.py' --root-authorization root-authorized-only --global-physical-budget 4 --terra-accountability required >/dev/null 2>&1; then
  fail 'spawn packet accepted nested Luna above the global budget'
fi
for budget in 1 2; do
  if python3 "$assignment" "$topology" --agent python-backend --task-id CODEX-LUNA-1 --objective 'Apply prescribed mechanical correction' --scope 'src/luna-child.py' --write-scope 'src/luna-child.py' --evidence 'pytest tests/test_luna_child.py' --context 'Return mechanical proof only.' --nested-luna-child --parent-task-id CODEX-PARENT-1 --parent-reference 'CODEX-PARENT-1:call-terra->CODEX-LUNA-1' --parent-write-scope 'src/terra-parent.py' --root-authorization root-authorized-only --global-physical-budget "$budget" --terra-accountability required >/dev/null 2>&1; then
    fail "spawn packet accepted nested Luna with impossible physical budget $budget"
  fi
done

if python3 "$assignment" "$topology" --agent python-backend --task-id CODEX-1 --objective 'Apply a bounded correction' --scope 'src/service.py' --write-scope 'src/service.py' --evidence 'pytest tests/test_service.py' --context 'Use the active issue and current worktree.' --fork-turns all >/dev/null 2>&1; then
  fail 'spawn packet accepted fork_turns = all'
fi
if python3 "$assignment" "$topology" --agent python-backend --task-id CODEX-1 --objective 'Apply a bounded correction' --scope 'src/service.py' --write-scope 'src/service.py' --evidence 'pytest tests/test_service.py' --context 'Use the active issue and current worktree.' --fork-turns 0 >/dev/null 2>&1; then
  fail 'spawn packet accepted a non-positive fork_turns value'
fi
if python3 "$assignment" "$topology" --agent python-backend --task-id CODEX-1 --objective 'Apply a bounded correction' --scope 'src/service.py' --write-scope 'src/service.py' --evidence 'pytest tests/test_service.py' --context 'Use the active issue and current worktree.' --fork-turns 6 >/dev/null 2>&1; then
  fail 'spawn packet accepted fork_turns above the global bound'
fi
if python3 "$assignment" "$topology" --agent python-backend --task-id CODEX-1 --objective 'Apply a bounded correction' --scope 'src/service.py' --write-scope 'src/service.py' --evidence 'pytest tests/test_service.py' --context 'Use the active issue and current worktree.' --fork-turns 05 >/dev/null 2>&1; then
  fail 'spawn packet accepted a non-canonical bounded fork_turns value'
fi

invalid="$tmp_dir/invalid.toml"
cp "$topology" "$invalid"
sed -i '/name = "qa"/,+10d' "$invalid"
if python3 "$validator" "$invalid" "$catalog" "$policy" >/dev/null 2>&1; then
  fail 'validator accepted missing required logical agent'
fi

invalid_fork="$tmp_dir/invalid-fork.toml"
sed '0,/fork_turns = "none"/{s/fork_turns = "none"/fork_turns = "all"/}' "$topology" > "$invalid_fork"
if python3 "$validator" "$invalid_fork" "$catalog" "$policy" >/dev/null 2>&1; then
  fail 'validator accepted fork_turns = all with an override'
fi

invalid_luna="$tmp_dir/invalid-luna.toml"
sed '/name = "research"/,+11s/model = "gpt-5.6-luna"/model = "gpt-5.6-terra"/' "$topology" > "$invalid_luna"
if python3 "$validator" "$invalid_luna" "$catalog" "$policy" >/dev/null 2>&1; then
  fail 'validator accepted a topology without the Luna research leaf'
fi

for family in data-db provider-boundary; do
  invalid_policy="$tmp_dir/invalid-${family}-binding.json"
  sed 's/"'"$family"'": \["implementation"\], //' "$policy" > "$invalid_policy"
  if python3 "$validator" "$topology" "$catalog" "$invalid_policy" >/dev/null 2>&1; then
    fail "validator accepted missing $family implementation binding"
  fi
done

printf 'codex logical agent topology passed\n'
