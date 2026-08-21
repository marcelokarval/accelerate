#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tool=(python3 "$ROOT/scripts/sync-accelerate-governed-drift.py")
root="$(mktemp -d)"
wrapper_before="$(mktemp)"
wrapper_after="$(mktemp)"
source_mode="$(stat -c %a "$ROOT/references/subagent-model.md")"
cleanup() {
  chmod "$source_mode" "$ROOT/references/subagent-model.md"
  python3 -c 'import os,sys
try:
 os.removexattr(sys.argv[1], "user.accelerate_test")
except OSError:
 pass' "$ROOT/references/subagent-model.md" 2>/dev/null || true
  rm -rf "$root"
  rm -f "$wrapper_before" "$wrapper_after"
}
trap cleanup EXIT
printf 'accelerate-test-root-v1\n' > "$root/.accelerate-test-root"
mkdir -p "$root/.codex/skills/accelerate" "$root/.agents/skills/accelerate"

target_path() {
  case "$1" in
    references/subagent-model.md) printf 'references/subagent-model.md' ;;
    core/runtime-packets/delegation-dispatch-receipt.schema.json) printf 'assets/delegation-dispatch-receipt.schema.json' ;;
    scripts/validate-delegation-dispatch-receipt.py) printf 'scripts/validate-delegation-dispatch-receipt.py' ;;
  esac
}
base() { printf '%s/.%s/skills/accelerate' "$root" "$1"; }
run() { "${tool[@]}" --mirror "$1" --test-root "$root" "${@:2}"; }
must_fail() { if "$@" >/dev/null 2>&1; then echo "expected failure: $*" >&2; exit 1; fi; }
digest() { sha256sum "$1" | awk '{print $1}'; }

# The legacy wrapper refuses before registry validation, mkdir, or copying.
find "$root" -printf '%P|%i\n' | LC_ALL=C sort > "$wrapper_before"
must_fail env CODEX_SKILLS_DIR="$root/legacy-codex" HERMES_SKILLS_DIR="$root/legacy-hermes" bash "$ROOT/scripts/sync-skills-to-global.sh"
find "$root" -printf '%P|%i\n' | LC_ALL=C sort > "$wrapper_after"
cmp -s "$wrapper_before" "$wrapper_after"

# Git mode/bytes, rather than mutable working-tree metadata, are authoritative.
chmod 600 "$ROOT/references/subagent-model.md"
python3 -c 'import os,sys; os.setxattr(sys.argv[1], "user.accelerate_test", b"source")' "$ROOT/references/subagent-model.md" 2>/dev/null || true

seed() {
  local mirror="$1" target path source
  target="$(base "$mirror")"
  for source in references/subagent-model.md core/runtime-packets/delegation-dispatch-receipt.schema.json scripts/validate-delegation-dispatch-receipt.py; do
    path="$(target_path "$source")"
    mkdir -p "$(dirname "$target/$path")"
    cp "$ROOT/$source" "$target/$path"
  done
  mkdir -p "$target/unmanaged"
  for number in $(seq 1 208); do printf 'untouched-%s\n' "$number" > "$target/unmanaged/$number"; done
}

drift() {
  local mirror="$1" target source path
  target="$(base "$mirror")"
  for source in references/subagent-model.md core/runtime-packets/delegation-dispatch-receipt.schema.json scripts/validate-delegation-dispatch-receipt.py; do
    path="$(target_path "$source")"
    printf 'drift-%s\n' "$mirror" >> "$target/$path"
  done
}

for mirror in codex agents; do
  seed "$mirror"
  target="$(base "$mirror")"
  find "$target" -printf '%P|%i|%m|%u|%g|%s\n' | LC_ALL=C sort > "$root/$mirror.before"
  plan="$(run "$mirror" --dry-run)"
  python3 -c 'import json,sys; p=json.load(sys.stdin); assert p["contract"] == "accelerate-governed-drift-v1" and len(p["files"]) == 3' <<<"$plan"
  find "$target" -printf '%P|%i|%m|%u|%g|%s\n' | LC_ALL=C sort > "$root/$mirror.after"
  cmp -s "$root/$mirror.before" "$root/$mirror.after"
  drift "$mirror"
  find "$target/unmanaged" -type f -printf '%P|%i|%m|%u|%g|%s\n' | LC_ALL=C sort > "$root/$mirror.unmanaged.before"
  run "$mirror" --apply >/dev/null
  for source in references/subagent-model.md core/runtime-packets/delegation-dispatch-receipt.schema.json scripts/validate-delegation-dispatch-receipt.py; do
    cmp -s "$ROOT/$source" "$target/$(target_path "$source")"
  done
  [[ "$(stat -c %a "$target/references/subagent-model.md")" == 644 ]]
  if python3 -c 'import os,sys; os.getxattr(sys.argv[1], "user.accelerate_test")' "$ROOT/references/subagent-model.md" >/dev/null 2>&1; then must_fail python3 -c 'import os,sys; os.getxattr(sys.argv[1], "user.accelerate_test")' "$target/references/subagent-model.md"; fi
  find "$target/unmanaged" -type f -printf '%P|%i|%m|%u|%g|%s\n' | LC_ALL=C sort > "$root/$mirror.unmanaged.after"
  cmp -s "$root/$mirror.unmanaged.before" "$root/$mirror.unmanaged.after"
  inode="$(stat -c %i "$target/references/subagent-model.md")"
  run "$mirror" --apply >/dev/null
  [[ "$(stat -c %i "$target/references/subagent-model.md")" == "$inode" ]]
done

# Rollback also deletes a path that was absent before the committed repair.
agents_target="$(base agents)"
rm "$agents_target/scripts/validate-delegation-dispatch-receipt.py"
run agents --apply >/dev/null
run agents --rollback >/dev/null
[[ ! -e "$agents_target/scripts/validate-delegation-dispatch-receipt.py" ]]

# Every persisted-before-replace phase recovers to the exact pre-apply drift.
target="$(base codex)"
for phase in backup-0 backup-1 backup-2 replace-0 replace-1 replace-2 receipt_pending; do
  drift codex
  before="$(digest "$target/references/subagent-model.md")"
  must_fail env ACCELERATE_GOVERNED_DRIFT_FAIL_AFTER="$phase" "${tool[@]}" --mirror codex --test-root "$root" --apply
  run codex --recover >/dev/null
  [[ "$(digest "$target/references/subagent-model.md")" == "$before" ]]
done

# A receipt written before its journal commit is finalized, not rolled back.
drift codex
must_fail env ACCELERATE_GOVERNED_DRIFT_FAIL_AFTER=receipt "${tool[@]}" --mirror codex --test-root "$root" --apply
run codex --recover >/dev/null
cmp -s "$ROOT/references/subagent-model.md" "$target/references/subagent-model.md"

# A committed journal is accepted only with its already-fsynced committed receipt;
# recovery is idempotent and the single rollback remains available.
drift codex
must_fail env ACCELERATE_GOVERNED_DRIFT_FAIL_AFTER=journal_committed "${tool[@]}" --mirror codex --test-root "$root" --apply
run codex --recover >/dev/null
run codex --rollback >/dev/null
must_fail run codex --rollback

# Backup metadata (including an available xattr) is restored, and receipt/backup
# tampering plus replay are rejected.
drift codex
printf 'xattr-before\n' > "$target/references/subagent-model.md"
if python3 -c 'import os,sys; os.setxattr(sys.argv[1], "user.accelerate_test", b"before")' "$target/references/subagent-model.md" 2>/dev/null; then xattr=yes; else xattr=no; fi
cp "$target/references/subagent-model.md" "$root/pre-rollback"
run codex --apply >/dev/null
receipt="$root/.codex/skills/.accelerate-governed-drift-codex.receipt.json"
backup="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["files"]["references/subagent-model.md"]["backup"])' "$receipt")"
printf tamper >> "$root/.codex/skills/$backup"
must_fail run codex --rollback
cp "$root/pre-rollback" "$root/.codex/skills/$backup"
run codex --rollback >/dev/null
cmp -s "$root/pre-rollback" "$target/references/subagent-model.md"
if [[ "$xattr" == yes ]]; then [[ "$(python3 -c 'import os,sys; print(os.getxattr(sys.argv[1], "user.accelerate_test").decode())' "$target/references/subagent-model.md")" == before ]]; fi
must_fail run codex --rollback

# Any target alias, ancestor symlink, or hardlink is rejected before writes.
rm -f "$target/references/subagent-model.md"
ln -s /etc/passwd "$target/references/subagent-model.md"
must_fail run codex --dry-run
rm "$target/references/subagent-model.md"
mkdir -p "$target/references"
rm -rf "$target/scripts"
ln -s /tmp "$target/scripts"
must_fail run codex --dry-run
rm "$target/scripts"
mkdir "$target/scripts"
cp "$ROOT/scripts/validate-delegation-dispatch-receipt.py" "$target/scripts/validate-delegation-dispatch-receipt.py"
cp "$ROOT/references/subagent-model.md" "$target/references/subagent-model.md"
ln "$target/references/subagent-model.md" "$target/references/external-victim"
must_fail run codex --dry-run

# A receipt cannot be replayed for another target.
python3 -c 'import json,sys; p=json.load(open(sys.argv[1])); p["target"]="/wrong"; open(sys.argv[1],"w").write(json.dumps(p))' "$receipt"
must_fail run codex --rollback

echo "accelerate governed drift transaction passed"
