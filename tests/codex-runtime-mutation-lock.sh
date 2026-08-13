#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

catalog="adapters/runtime/codex/skill-catalog-manifest.toml"
topology="adapters/runtime/codex/logical-agent-topology.toml"
lock_name=".codex-runtime-mutation.lock"
sandbox="$(mktemp -d)"
evidence="$(mktemp -d)"
trap 'rm -rf -- "$sandbox" "$evidence"' EXIT

snapshot_home() {
  local home="$1" output="$2"
  python3 - "$home" "$output" "$lock_name" <<'PY'
import hashlib
import json
import os
import stat
import sys
from pathlib import Path

root = Path(sys.argv[1])
output = Path(sys.argv[2])
lock_name = sys.argv[3]
state = []
if root.exists():
    for path in sorted(root.rglob("*")):
        relative = path.relative_to(root)
        if relative.parts and relative.parts[0] == lock_name:
            continue
        metadata = path.lstat()
        item = {
            "path": str(relative),
            "mode": stat.S_IMODE(metadata.st_mode),
            "kind": "other",
        }
        if stat.S_ISREG(metadata.st_mode):
            item["kind"] = "file"
            item["sha256"] = hashlib.sha256(path.read_bytes()).hexdigest()
        elif stat.S_ISDIR(metadata.st_mode):
            item["kind"] = "directory"
        elif stat.S_ISLNK(metadata.st_mode):
            item["kind"] = "symlink"
            item["target"] = os.readlink(path)
        state.append(item)
output.write_text(json.dumps(state, sort_keys=True, separators=(",", ":")) + "\n")
PY
}

assert_unlocked_inherited_fd_acquires() {
  local label="$1" home="$2"
  shift 2
  mkdir -p "$home"
  local lock="$home/$lock_name"
  exec {unlocked_fd}>>"$lock"
  chmod 0600 "$lock"
  # An exact inherited descriptor with no competing holder must atomically
  # acquire LOCK_EX and complete successfully.
  exec {probe_fd}>>"$lock"
  flock -n "$probe_fd"
  flock -u "$probe_fd"
  if ! CODEX_RUNTIME_MUTATION_LOCK_FD="$unlocked_fd" \
    CODEX_RUNTIME_MUTATION_LOCK_HOME="$home" \
    CODEX_RUNTIME_MUTATION_LOCK_OWNER_PID="$$" \
      "$@" >"$evidence/unlocked-$label.out" 2>&1; then
    printf 'runtime mutation lock failed: %s failed after acquiring unlocked inherited FD\n' "$label" >&2
    exit 1
  fi
  eval "exec ${unlocked_fd}>&-"
  if ! flock -n "$probe_fd"; then
    printf 'runtime mutation lock failed: %s did not release inherited lock normally\n' "$label" >&2
    exit 1
  fi
  flock -u "$probe_fd"
  eval "exec ${probe_fd}>&-"
}

assert_shadowed_inherited_fd_rejects() {
  local label="$1" home="$2"
  shift 2
  mkdir -p "$home"
  local lock="$home/$lock_name"
  # OFD-A owns the real lock. OFD-B names the exact same inode but remains
  # unlocked. A third path-based probe only sees OFD-A's contention and can
  # therefore misclassify OFD-B as the owner.
  exec {owner_fd}>>"$lock"
  chmod 0600 "$lock"
  flock -n "$owner_fd"
  exec {shadow_fd}>>"$lock"
  snapshot_home "$home" "$evidence/shadowed-$label.before"
  if CODEX_RUNTIME_MUTATION_LOCK_FD="$shadow_fd" \
    CODEX_RUNTIME_MUTATION_LOCK_HOME="$home" \
    CODEX_RUNTIME_MUTATION_LOCK_OWNER_PID="$$" \
      "$@" >"$evidence/shadowed-$label.out" 2>&1; then
    printf 'runtime mutation lock failed: %s accepted an unlocked inherited FD shadowed by another holder\n' "$label" >&2
    exit 1
  fi
  snapshot_home "$home" "$evidence/shadowed-$label.after"
  cmp -s "$evidence/shadowed-$label.before" "$evidence/shadowed-$label.after" || {
    printf 'runtime mutation lock failed: %s shadowed-FD rejection occurred after mutation\n' "$label" >&2
    exit 1
  }
  rg -F 'inherited lock does not hold an exclusive flock' "$evidence/shadowed-$label.out" >/dev/null || {
    printf 'runtime mutation lock failed: %s omitted shadowed inherited flock diagnostic\n' "$label" >&2
    exit 1
  }
  eval "exec ${shadow_fd}>&-"
  flock -u "$owner_fd"
  eval "exec ${owner_fd}>&-"
}

assert_locked_rejects() {
  local label="$1" home="$2"
  shift 2
  mkdir -p "$home"
  local lock="$home/$lock_name"
  exec {held_fd}>>"$lock"
  chmod 0600 "$lock"
  flock -n "$held_fd"
  snapshot_home "$home" "$evidence/$label.before"
  if "$@" >"$evidence/$label.out" 2>&1; then
    printf 'runtime mutation lock failed: %s accepted a concurrent writer\n' "$label" >&2
    exit 1
  fi
  snapshot_home "$home" "$evidence/$label.after"
  cmp -s "$evidence/$label.before" "$evidence/$label.after" || {
    printf 'runtime mutation lock failed: %s rejected after mutation\n' "$label" >&2
    exit 1
  }
  rg -F 'runtime mutation is already locked' "$evidence/$label.out" >/dev/null || {
    printf 'runtime mutation lock failed: %s omitted the lock diagnostic\n' "$label" >&2
    exit 1
  }
  flock -u "$held_fd"
  eval "exec ${held_fd}>&-"
}

# Source guard: inherited ownership must be established on the inherited
# descriptor itself. The behavioral matrix below distinguishes uncontended
# acquisition from holder-A/unlocked-B contention; this guard prevents a
# regression back to path-based third-OFD inference.
for python_mutator in \
  scripts/install-codex-skill-catalog.py \
  scripts/install-codex-logical-agents.py; do
  rg -F 'fcntl.flock(descriptor, fcntl.LOCK_EX | fcntl.LOCK_NB)' "$python_mutator" >/dev/null || {
    printf 'runtime mutation lock failed: %s lacks direct inherited-FD flock\n' "$python_mutator" >&2
    exit 1
  }
done
for shell_mutator in \
  scripts/sync-skills-to-global.sh \
  scripts/rollback-global-skill-sync.sh; do
  rg -F 'flock -n "$descriptor"' "$shell_mutator" >/dev/null || {
    printf 'runtime mutation lock failed: %s lacks direct inherited-FD flock\n' "$shell_mutator" >&2
    exit 1
  }
done
if rg -F 'flock -n "$lock_path"' \
  scripts/sync-skills-to-global.sh scripts/rollback-global-skill-sync.sh >/dev/null; then
  printf 'runtime mutation lock failed: path-based inherited flock probe remains\n' >&2
  exit 1
fi

catalog_home="$sandbox/catalog/.codex"
mkdir -p "$catalog_home"
printf '# catalog lock sentinel\n' >"$catalog_home/config.toml"
assert_locked_rejects catalog "$catalog_home" \
  python3 scripts/install-codex-skill-catalog.py "$catalog" \
    --codex-home "$catalog_home" --logical-topology "$topology"
assert_shadowed_inherited_fd_rejects catalog "$catalog_home" \
  python3 scripts/install-codex-skill-catalog.py "$catalog" \
    --codex-home "$catalog_home" --logical-topology "$topology"

unlocked_catalog_home="$sandbox/unlocked-catalog/.codex"
assert_unlocked_inherited_fd_acquires catalog "$unlocked_catalog_home" \
  python3 scripts/install-codex-skill-catalog.py "$catalog" \
    --codex-home "$unlocked_catalog_home" --logical-topology "$topology"

logical_home="$sandbox/logical/.codex"
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$logical_home" --logical-topology "$topology" >/dev/null
assert_locked_rejects logical "$logical_home" \
  python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
    --codex-home "$logical_home"
assert_shadowed_inherited_fd_rejects logical "$logical_home" \
  python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
    --codex-home "$logical_home"

unlocked_logical_home="$sandbox/unlocked-logical/.codex"
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$unlocked_logical_home" --logical-topology "$topology" >/dev/null
assert_unlocked_inherited_fd_acquires logical "$unlocked_logical_home" \
  python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
    --codex-home "$unlocked_logical_home"

sync_home="$sandbox/sync/.codex"
sync_target="$sync_home/skills"
sync_backup="$sandbox/backups/locked-sync"
mkdir -p "$sync_target"
printf 'model = "locked-sync-sentinel"\n' >"$sync_home/config.toml"
assert_locked_rejects sync "$sync_home" \
  env CODEX_HOME="$sync_home" \
    CODEX_SKILLS_DIR="$sync_target" \
    CODEX_SKILLS_BACKUP_DIR="$sync_backup" \
    CODEX_SKILLS_RECEIPT_FILE="$sync_backup/sync-receipt.json" \
    CODEX_SKILL_SYNC_ALLOWED_ROOT="$sandbox" \
    bash scripts/sync-skills-to-global.sh
assert_shadowed_inherited_fd_rejects sync "$sync_home" \
  env CODEX_HOME="$sync_home" \
    CODEX_SKILLS_DIR="$sync_target" \
    CODEX_SKILLS_BACKUP_DIR="$sync_backup" \
    CODEX_SKILLS_RECEIPT_FILE="$sync_backup/sync-receipt.json" \
    CODEX_SKILL_SYNC_ALLOWED_ROOT="$sandbox" \
    bash scripts/sync-skills-to-global.sh
test ! -e "$sync_backup" || {
  printf 'runtime mutation lock failed: rejected sync created its backup transaction\n' >&2
  exit 1
}

unlocked_sync_home="$sandbox/unlocked-sync/.codex"
unlocked_sync_target="$unlocked_sync_home/skills"
unlocked_sync_backup="$sandbox/backups/unlocked-sync"
mkdir -p "$unlocked_sync_target"
printf 'model = "unlocked-sync-sentinel"\n' >"$unlocked_sync_home/config.toml"
assert_unlocked_inherited_fd_acquires sync "$unlocked_sync_home" \
  env CODEX_HOME="$unlocked_sync_home" \
    CODEX_SKILLS_DIR="$unlocked_sync_target" \
    CODEX_SKILLS_BACKUP_DIR="$unlocked_sync_backup" \
    CODEX_SKILLS_RECEIPT_FILE="$unlocked_sync_backup/sync-receipt.json" \
    CODEX_SKILL_SYNC_ALLOWED_ROOT="$sandbox" \
    bash scripts/sync-skills-to-global.sh

rollback_home="$sandbox/rollback/.codex"
rollback_target="$rollback_home/skills"
rollback_backup="$sandbox/backups/rollback"
rollback_receipt="$rollback_backup/sync-receipt.json"
mkdir -p "$rollback_target"
printf 'model = "rollback-original"\n' >"$rollback_home/config.toml"
CODEX_HOME="$rollback_home" \
CODEX_SKILLS_DIR="$rollback_target" \
CODEX_SKILLS_BACKUP_DIR="$rollback_backup" \
CODEX_SKILLS_RECEIPT_FILE="$rollback_receipt" \
CODEX_SKILL_SYNC_ALLOWED_ROOT="$sandbox" \
  bash scripts/sync-skills-to-global.sh >/dev/null
assert_locked_rejects rollback "$rollback_home" \
  bash scripts/rollback-global-skill-sync.sh "$rollback_receipt"
assert_shadowed_inherited_fd_rejects rollback "$rollback_home" \
  bash scripts/rollback-global-skill-sync.sh "$rollback_receipt"
python3 - "$rollback_receipt" <<'PY'
import json
import sys
from pathlib import Path

if json.loads(Path(sys.argv[1]).read_text()).get("status") != "installed":
    raise SystemExit("runtime mutation lock failed: rejected rollback changed receipt status")
PY
assert_unlocked_inherited_fd_acquires rollback "$rollback_home" \
  bash scripts/rollback-global-skill-sync.sh "$rollback_receipt"

# G5-F2: lock contention wins before full receipt validation. Only the bounded
# lexical home locator may be read first; schema/state/snapshot reads happen
# after serialization.
cp "$rollback_receipt" "$evidence/rollback-valid-receipt.json"
python3 - "$rollback_receipt" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
receipt = json.loads(path.read_text())
receipt["schema_version"] = 999
path.write_text(json.dumps(receipt, indent=2) + "\n")
PY
exec {ordering_fd}>>"$rollback_home/$lock_name"
flock -n "$ordering_fd"
if bash scripts/rollback-global-skill-sync.sh "$rollback_receipt" \
  >"$evidence/rollback-ordering.out" 2>&1; then
  printf 'runtime mutation lock failed: invalid receipt passed under held lock\n' >&2
  exit 1
fi
rg -F 'runtime mutation is already locked' "$evidence/rollback-ordering.out" >/dev/null || {
  printf 'runtime mutation lock failed: rollback validated receipt before acquiring lock\n' >&2
  exit 1
}
flock -u "$ordering_fd"
eval "exec ${ordering_fd}>&-"
mv "$evidence/rollback-valid-receipt.json" "$rollback_receipt"

# Lock path integrity: neither a symlink nor a non-regular node can act as the
# cooperative lock. The outside target remains untouched.
unsafe_home="$sandbox/unsafe/.codex"
outside_lock="$sandbox/outside-lock-sentinel"
mkdir -p "$unsafe_home"
printf 'outside lock sentinel\n' >"$outside_lock"
ln -s "$outside_lock" "$unsafe_home/$lock_name"
if python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$unsafe_home" --logical-topology "$topology" >/dev/null 2>&1; then
  printf 'runtime mutation lock failed: symlink lock was accepted\n' >&2
  exit 1
fi
cmp -s "$outside_lock" <(printf 'outside lock sentinel\n') || {
  printf 'runtime mutation lock failed: symlink lock target was mutated\n' >&2
  exit 1
}
unlink "$unsafe_home/$lock_name"
mkdir "$unsafe_home/$lock_name"
if python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$unsafe_home" --logical-topology "$topology" >/dev/null 2>&1; then
  printf 'runtime mutation lock failed: non-regular lock was accepted\n' >&2
  exit 1
fi
rmdir "$unsafe_home/$lock_name"

# Error cleanup: an in-lock catalog failure releases the lock, and a subsequent
# valid operation can acquire it. Repeated valid installs are content-idempotent.
error_home="$sandbox/error-cleanup/.codex"
mkdir -p "$error_home"
printf '# ambiguous hidden profile\n' >"$error_home/django-backend.config.toml"
if python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$error_home" --logical-topology "$topology" >/dev/null 2>&1; then
  printf 'runtime mutation lock failed: ambiguity fixture unexpectedly passed\n' >&2
  exit 1
fi
unlink "$error_home/django-backend.config.toml"
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$error_home" --logical-topology "$topology" >/dev/null
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
  --codex-home "$error_home" >/dev/null
snapshot_home "$error_home" "$evidence/idempotent.before"
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$error_home" --logical-topology "$topology" >/dev/null
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
  --codex-home "$error_home" >/dev/null
snapshot_home "$error_home" "$evidence/idempotent.after"
# Receipts carry fresh timestamps/backups; installed config/profile content
# idempotency is covered by the dedicated installer tests. Successful repeated
# reacquisition is the cooperative-lock idempotency oracle here.

# Automatic rollback executes under the sync lock without self-deadlock, and
# the lock is available again after the injected error path exits.
failure_home="$sandbox/sync-error/.codex"
failure_target="$failure_home/skills"
failure_backup="$sandbox/backups/sync-error"
mkdir -p "$failure_target"
printf 'model = "before-sync-error"\n' >"$failure_home/config.toml"
if CODEX_HOME="$failure_home" \
  CODEX_SKILLS_DIR="$failure_target" \
  CODEX_SKILLS_BACKUP_DIR="$failure_backup" \
  CODEX_SKILLS_RECEIPT_FILE="$failure_backup/sync-receipt.json" \
  CODEX_SKILL_SYNC_ALLOWED_ROOT="$sandbox" \
  CODEX_SKILL_SYNC_FAIL_AFTER=catalog \
    bash scripts/sync-skills-to-global.sh >/dev/null 2>&1; then
  printf 'runtime mutation lock failed: injected sync error was accepted\n' >&2
  exit 1
fi
python3 scripts/install-codex-skill-catalog.py "$catalog" \
  --codex-home "$failure_home" --logical-topology "$topology" >/dev/null

# Normal rollback and its idempotent readback both reacquire and release the
# cooperative lock successfully.
bash scripts/rollback-global-skill-sync.sh "$rollback_receipt" >/dev/null
bash scripts/rollback-global-skill-sync.sh "$rollback_receipt" >/dev/null

printf 'codex runtime mutation lock passed\n'
