#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stage_root="$(mktemp -d)"
trap 'rm -rf "$stage_root"' EXIT

fail() {
  echo "codex-global-bootstrap-install failed: $1" >&2
  exit 1
}

fragment="$ROOT/adapters/runtime/codex/global-bootstrap-orchestration.fragment.md"
renderer="$ROOT/scripts/render-codex-global-bootstrap.py"
installer="$ROOT/scripts/install-codex-global-bootstrap.py"
real_agents="${CODEX_GLOBAL_AGENTS:-/home/marcelo-karval/.codex/AGENTS.md}"

[[ -f "$fragment" ]] || fail 'missing repo-owned fragment'
[[ -f "$renderer" ]] || fail 'missing renderer'
[[ -f "$installer" ]] || fail 'missing installer'
rg -F '<!-- accelerate-delegation-policy:start -->' "$fragment" >/dev/null || fail 'missing start marker'
rg -F '<!-- accelerate-delegation-policy:end -->' "$fragment" >/dev/null || fail 'missing end marker'
rg -F 'MUST call `collaboration.spawn_agent` before any task-owned mutation' "$fragment" >/dev/null || fail 'missing physical dispatch requirement'
for exception_code in explicit_user_opt_out collaboration_unavailable spawn_failed_operator_authorized; do
  rg -F "\`$exception_code\`" "$fragment" >/dev/null || fail "missing canonical exception code $exception_code"
done
if rg -F 'spawn_failed_operator_authorized_degradation' "$fragment" >/dev/null; then
  fail 'non-canonical exception code remains'
fi

[[ -f "$real_agents" ]] || fail 'missing real global AGENTS fixture source'
real_target="$stage_root/real-AGENTS.md"
cp "$real_agents" "$real_target"
python3 "$renderer" --target "$real_target" >/dev/null
python3 "$installer" --target "$real_target" --receipt "$stage_root/real-preflight.json" --dry-run >/dev/null
python3 "$installer" --target "$real_target" --receipt "$stage_root/real-preflight.json" --apply >/dev/null
rg -F '<!-- accelerate-delegation-policy:start -->' "$real_target" >/dev/null || fail 'real legacy fixture did not install'
wrapped_target="$stage_root/wrapped-AGENTS.md"
cp "$ROOT/tests/fixtures/codex-global-bootstrap/current-real-legacy-block.md" "$wrapped_target"
python3 "$installer" --target "$wrapped_target" --receipt "$stage_root/wrapped-preflight.json" --dry-run >/dev/null

target="$stage_root/AGENTS.md"
original="$stage_root/original"
receipt="$stage_root/receipt.json"
cat >"$target" <<'EOF'
# Legacy global rules

Before

- Non-trivial work defaults to multi-agent execution.
- At least one bounded subagent should normally be spawned for non-trivial work.
- Each spawned subagent should load `accelerate` first, then leave `self-review` and `self-forensic review` output before returning.

After
EOF
cp "$target" "$original"
if python3 "$installer" --target "$target" --receipt "$receipt" --apply >/dev/null 2>&1; then
  fail 'apply without preflight did not fail closed'
fi

python3 "$installer" --target "$target" --receipt "$receipt" --dry-run >/dev/null

replay_target="$stage_root/replay-AGENTS.md"
cp "$original" "$replay_target"
if python3 "$installer" --target "$replay_target" --receipt "$receipt" --apply >/dev/null 2>&1; then
  fail 'apply accepted a preflight receipt for a different canonical target identity'
fi
cmp -s "$original" "$target" || fail 'dry-run mutated target'
[[ -f "$receipt" ]] || fail 'dry-run did not write preflight receipt'
python3 - "$receipt" "$target" <<'PY'
import json
import pathlib
import sys

receipt = json.loads(pathlib.Path(sys.argv[1]).read_text())
assert receipt['mode'] == 'dry-run'
assert receipt['backup_path'] is None
assert receipt['target_identity'] == str(pathlib.Path(sys.argv[2]).resolve())
PY

python3 - "$receipt" <<'PY'
import json
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
receipt = json.loads(path.read_text())
receipt['target_after_sha256'] = '0' * 64
path.write_text(json.dumps(receipt))
PY
if python3 "$installer" --target "$target" --receipt "$receipt" --apply >/dev/null 2>&1; then
  fail 'wrong preflight fingerprint did not fail closed'
fi
python3 "$installer" --target "$target" --receipt "$receipt" --dry-run >/dev/null

echo 'stale target drift' >>"$target"
if python3 "$installer" --target "$target" --receipt "$receipt" --apply >/dev/null 2>&1; then
  fail 'stale target preflight did not fail closed'
fi
cp "$original" "$target"
python3 "$installer" --target "$target" --receipt "$receipt" --dry-run >/dev/null
alternate_fragment="$stage_root/alternate.fragment.md"
cp "$fragment" "$alternate_fragment"
echo >>"$alternate_fragment"
if python3 "$installer" --target "$target" --receipt "$receipt" --fragment "$alternate_fragment" --apply >/dev/null 2>&1; then
  fail 'wrong source preflight did not fail closed'
fi
cp "$original" "$target"
python3 "$installer" --target "$target" --receipt "$receipt" --dry-run >/dev/null
chmod 640 "$target"
target_mode_before="$(stat -c '%a' "$target")"

python3 "$installer" --target "$target" --receipt "$receipt" --apply >/dev/null
[[ -f "$receipt" ]] || fail 'apply did not write receipt'
[[ "$(stat -c '%a' "$target")" == "$target_mode_before" ]] || fail 'apply changed target mode'
python3 - "$target" "$receipt" <<'PY'
import hashlib
import json
import pathlib
import sys

target = pathlib.Path(sys.argv[1])
receipt = json.loads(pathlib.Path(sys.argv[2]).read_text())
assert receipt['mode'] == 'apply'
assert receipt['target_after_sha256'] == hashlib.sha256(target.read_bytes()).hexdigest()
assert pathlib.Path(receipt['backup_path']).is_file()
assert receipt['source_before_sha256'] == receipt['source_after_sha256']
assert receipt['target_identity'] == str(target.resolve())
PY
first_apply_receipt="$stage_root/first-apply-receipt.json"
cp "$receipt" "$first_apply_receipt"
cross_rollback_target="$stage_root/cross-rollback-AGENTS.md"
cp "$target" "$cross_rollback_target"
if python3 "$installer" --target "$cross_rollback_target" --receipt "$first_apply_receipt" --rollback-receipt "$stage_root/cross-rollback.json" --rollback >/dev/null 2>&1; then
  fail 'rollback accepted an apply receipt for a different canonical target identity'
fi
rg -F 'Before' "$target" >/dev/null
rg -F 'After' "$target" >/dev/null
rg -F '<!-- accelerate-delegation-policy:start -->' "$target" >/dev/null
rg -F '<!-- accelerate-delegation-policy:end -->' "$target" >/dev/null
if rg -F 'Non-trivial work defaults to multi-agent execution.' "$target" >/dev/null; then
  fail 'legacy permissive block remains after first installation'
fi

installed="$stage_root/installed"
cp "$target" "$installed"
second_receipt="$stage_root/second-receipt.json"
backup_count_before="$(find "$stage_root" -name 'AGENTS.md.accelerate-delegation-policy.*.bak' | wc -l)"
python3 "$installer" --target "$target" --receipt "$second_receipt" --dry-run >/dev/null
python3 "$installer" --target "$target" --receipt "$second_receipt" --apply >/dev/null
cmp -s "$installed" "$target" || fail 'reapply was not idempotent'
python3 - "$second_receipt" <<'PY'
import json
import pathlib
import sys

receipt = json.loads(pathlib.Path(sys.argv[1]).read_text())
assert receipt['mode'] == 'apply'
assert receipt['changed'] is False
assert receipt['backup_path'] is None
PY
[[ "$(find "$stage_root" -name 'AGENTS.md.accelerate-delegation-policy.*.bak' | wc -l)" == "$backup_count_before" ]] || fail 'no-op apply created backup'

apply_receipt="$stage_root/apply-receipt.json"
cp "$first_apply_receipt" "$apply_receipt"
apply_receipt_hash_before="$(sha256sum "$apply_receipt" | awk '{print $1}')"
rollback_receipt="$stage_root/rollback-receipt.json"
python3 "$installer" --target "$target" --receipt "$apply_receipt" --rollback-receipt "$rollback_receipt" --rollback >/dev/null
cmp -s "$original" "$target" || fail 'rollback did not restore original bytes'
[[ "$(sha256sum "$apply_receipt" | awk '{print $1}')" == "$apply_receipt_hash_before" ]] || fail 'rollback changed apply receipt'
python3 - "$rollback_receipt" <<'PY'
import json
import pathlib
import sys

receipt = json.loads(pathlib.Path(sys.argv[1]).read_text())
assert receipt['mode'] == 'rollback'
assert receipt['changed'] is True
PY

rollback_target="$stage_root/rollback-tamper-AGENTS.md"
cp "$original" "$rollback_target"
rollback_apply="$stage_root/rollback-apply.json"
python3 "$installer" --target "$rollback_target" --receipt "$rollback_apply" --dry-run >/dev/null
python3 "$installer" --target "$rollback_target" --receipt "$rollback_apply" --apply >/dev/null
echo 'tampered current target' >>"$rollback_target"
if python3 "$installer" --target "$rollback_target" --receipt "$rollback_apply" --rollback-receipt "$stage_root/tampered-current-rollback.json" --rollback >/dev/null 2>&1; then
  fail 'rollback accepted tampered current target'
fi

backup_target="$stage_root/backup-tamper-AGENTS.md"
cp "$original" "$backup_target"
backup_apply="$stage_root/backup-apply.json"
python3 "$installer" --target "$backup_target" --receipt "$backup_apply" --dry-run >/dev/null
python3 "$installer" --target "$backup_target" --receipt "$backup_apply" --apply >/dev/null
backup_path="$(python3 - "$backup_apply" <<'PY'
import json
import pathlib
import sys
print(json.loads(pathlib.Path(sys.argv[1]).read_text())['backup_path'])
PY
)"
echo 'tampered backup' >>"$backup_path"
if python3 "$installer" --target "$backup_target" --receipt "$backup_apply" --rollback-receipt "$stage_root/tampered-backup-rollback.json" --rollback >/dev/null 2>&1; then
  fail 'rollback accepted tampered backup'
fi

echo '<!-- accelerate-delegation-policy:start -->' >>"$target"
if python3 "$installer" --target "$target" --receipt "$stage_root/bad.json" --dry-run >/dev/null 2>&1; then
  fail 'broken markers did not fail closed'
fi

echo 'codex global bootstrap install passed'
