#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
sync="$ROOT/scripts/sync-runtime-bootstrap.py"; fail(){ echo "cross-runtime-bootstrap: $1" >&2; exit 1; }
printf 'accelerate-test-root-v1\n' > "$tmp/.accelerate-test-root"; mkdir "$tmp/.codex"
target="$tmp/.codex/AGENTS.md"; receipt="$tmp/.codex/.accelerate-bootstrap-receipt.json"; journal="$tmp/.codex/.accelerate-bootstrap-journal.json"
printf 'before\n' > "$target"; cp "$target" "$tmp/original"
python3 - "$target" <<'PY'
import os, sys
try:
    os.setxattr(sys.argv[1], "user.accelerate_test", b"preserve", follow_symlinks=False)
except (AttributeError, OSError) as exc:
    raise SystemExit(f"raw xattr support is required for this fixture: {exc}")
PY

# Closed matrix: only Codex can reach a derived target; no arbitrary paths or output writes.
for runtime in openhands hermes opencode openclaw claude; do
  if python3 "$sync" --runtime "$runtime" --test-root "$tmp" --receipt "$receipt" --dry-run >/dev/null 2>&1; then fail "$runtime admitted"; fi
  [ ! -e "$receipt" ] || fail "$runtime wrote receipt"
done
if python3 "$sync" --runtime codex --test-root "$tmp" --target "$tmp/x" --dry-run >/dev/null 2>&1; then fail 'arbitrary target admitted'; fi
if python3 "$sync" --runtime codex --test-root "$tmp" --stage-output "$tmp/x" --stage >/dev/null 2>&1; then fail 'arbitrary stage output admitted'; fi
if python3 "$sync" --runtime codex --test-root "$tmp" --receipt "$target" --dry-run >/dev/null 2>&1; then fail 'target equals receipt admitted'; fi

python3 "$sync" --runtime codex --test-root "$tmp" --receipt "$receipt" --dry-run >/dev/null
cmp -s "$target" "$tmp/original" || fail 'dry-run changed target'
python3 "$sync" --runtime codex --test-root "$tmp" --apply >/dev/null
rg -F '<!-- accelerate-delegation-policy:start -->' "$target" >/dev/null || fail 'missing managed block'
python3 "$sync" --runtime codex --test-root "$tmp" --receipt "$receipt" --dry-run >/dev/null
python3 "$sync" --runtime codex --test-root "$tmp" --apply >/dev/null

# A single managed block is corrected; duplicate/malformed blocks fail closed.
perl -0pi -e 's/Standing Multi-Agent V2/Corrupted Policy/' "$target"
python3 "$sync" --runtime codex --test-root "$tmp" --receipt "$receipt" --dry-run >/dev/null
python3 "$sync" --runtime codex --test-root "$tmp" --apply >/dev/null
rg -F 'Standing Multi-Agent V2' "$target" >/dev/null || fail 'tampered block not corrected'
printf '\n<!-- accelerate-delegation-policy:start -->' >> "$target"
if python3 "$sync" --runtime codex --test-root "$tmp" --dry-run >/dev/null 2>&1; then fail 'malformed block admitted'; fi
cp "$tmp/original" "$target"
python3 - "$target" <<'PY'
import os, sys
os.setxattr(sys.argv[1], "user.accelerate_test", b"preserve", follow_symlinks=False)
PY

# Forced final receipt failure leaves a prepared journal that recover finalizes.
python3 "$sync" --runtime codex --test-root "$tmp" --receipt "$receipt" --dry-run >/dev/null
if ACCELERATE_BOOTSTRAP_TEST_FAIL_FINALIZE=1 python3 "$sync" --runtime codex --test-root "$tmp" --apply >/dev/null 2>&1; then fail 'forced finalization failure admitted'; fi
python3 "$sync" --runtime codex --test-root "$tmp" --recover >/dev/null
python3 "$sync" --runtime codex --test-root "$tmp" --rollback-preflight >/dev/null
python3 "$sync" --runtime codex --test-root "$tmp" --rollback >/dev/null
cmp -s "$target" "$tmp/original" || fail 'rollback did not restore bytes'
python3 - "$target" <<'PY'
import os, sys
assert os.getxattr(sys.argv[1], "user.accelerate_test", follow_symlinks=False) == b"preserve"
PY

# Every persisted transaction phase has deterministic recovery.
for phase in intent backup_ready target_replaced receipt_finalize; do
  rm -f "$receipt" "$journal"; cp "$tmp/original" "$target"
  python3 - "$target" <<'PY'
import os, sys
os.setxattr(sys.argv[1], "user.accelerate_test", b"preserve", follow_symlinks=False)
PY
  python3 "$sync" --runtime codex --test-root "$tmp" --receipt "$receipt" --dry-run >/dev/null
  if ACCELERATE_BOOTSTRAP_TEST_FAULT="$phase" python3 "$sync" --runtime codex --test-root "$tmp" --apply >/dev/null 2>&1; then fail "$phase fault admitted"; fi
  python3 "$sync" --runtime codex --test-root "$tmp" --recover >/dev/null
  if [[ "$phase" == intent || "$phase" == backup_ready ]]; then cmp -s "$target" "$tmp/original" || fail "$phase recovery changed original"; fi
done

# Crafted intent journals never own or unlink an arbitrary external path.
victim="$tmp/victim"; printf 'do-not-delete\n' > "$victim"
python3 - "$journal" "$target" "$victim" <<'PY'
import hashlib, json, pathlib, sys
journal, target, victim = map(pathlib.Path, sys.argv[1:])
before = target.read_bytes()
journal.write_text(json.dumps({
    "status": "intent", "target": str(target),
    "before_sha256": hashlib.sha256(before).hexdigest(),
    "after_sha256": "0" * 64, "backup_path": str(victim),
    "backup_sha256": None, "backup_size": None,
    "backup_type": None, "backup_xattr_sha256": None,
}))
PY
if python3 "$sync" --runtime codex --test-root "$tmp" --recover >/dev/null 2>&1; then fail 'crafted intent backup path admitted'; fi
[[ "$(cat "$victim")" == 'do-not-delete' ]] || fail 'intent recovery touched external victim'

# POSIX ACL is carried as an xattr where the host supports ACL tooling.
if command -v setfacl >/dev/null && command -v getfacl >/dev/null; then
  rm -f "$receipt" "$journal"; cp "$tmp/original" "$target"
  setfacl -m u::rw "$target"
  acl_before="$(getfacl -cp "$target")"
  python3 "$sync" --runtime codex --test-root "$tmp" --receipt "$receipt" --dry-run >/dev/null
  python3 "$sync" --runtime codex --test-root "$tmp" --apply >/dev/null
  python3 "$sync" --runtime codex --test-root "$tmp" --rollback-preflight >/dev/null
  python3 "$sync" --runtime codex --test-root "$tmp" --rollback >/dev/null
  [[ "$(getfacl -cp "$target")" == "$acl_before" ]] || fail 'ACL was not restored'
else
  printf 'SKIP: ACL tooling unavailable\n'
fi

# Tampered backup is rejected before rollback and cannot alter target bytes.
rm -f "$receipt" "$journal"; cp "$tmp/original" "$target"
python3 "$sync" --runtime codex --test-root "$tmp" --receipt "$receipt" --dry-run >/dev/null
python3 "$sync" --runtime codex --test-root "$tmp" --apply >/dev/null
cp "$target" "$tmp/installed-before-tamper"
backup="$(python3 - "$receipt" <<'PY'
import json, pathlib, sys
print(json.loads(pathlib.Path(sys.argv[1]).read_text())['backup_path'])
PY
)"
printf 'tamper' >> "$backup"
if python3 "$sync" --runtime codex --test-root "$tmp" --rollback-preflight >/dev/null 2>&1; then fail 'tampered backup admitted'; fi
cmp -s "$target" "$tmp/installed-before-tamper" || fail 'tampered backup changed target'

# A target that did not exist before install must be absent after rollback.
rm -f "$target" "$receipt" "$journal"
python3 "$sync" --runtime codex --test-root "$tmp" --receipt "$receipt" --dry-run >/dev/null
python3 "$sync" --runtime codex --test-root "$tmp" --apply >/dev/null
python3 "$sync" --runtime codex --test-root "$tmp" --rollback-preflight >/dev/null
python3 "$sync" --runtime codex --test-root "$tmp" --rollback >/dev/null
[ ! -e "$target" ] || fail 'missing original target was recreated by rollback'
printf 'before\n' > "$target"

# Alias defenses include file and ancestor symlinks and multi-link targets.
ln -s "$target" "$tmp/.codex/alias"; if python3 "$sync" --runtime codex --test-root "$tmp" --receipt "$tmp/.codex/alias" --dry-run >/dev/null 2>&1; then fail 'receipt alias admitted'; fi
ln "$target" "$tmp/.codex/hard"; if python3 "$sync" --runtime codex --test-root "$tmp" --dry-run >/dev/null 2>&1; then fail 'hardlink target admitted'; fi
printf 'cross-runtime bootstrap passed\n'
