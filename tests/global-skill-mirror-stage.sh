#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stage_root="$(mktemp -d)"
trap 'rm -rf "$stage_root"' EXIT

codex_home="$stage_root/runtime/.codex"
target="$codex_home/skills"
backup="$stage_root/backups/success"
receipt="$backup/sync-receipt.json"
legacy_catalog="$codex_home/skill-catalog-h55-fixture"
legacy_accelerate="$legacy_catalog/accelerate"
mkdir -p "$target" "$legacy_accelerate/references" "$target/user-owned-fixture"
printf 'old governed package\n' >"$legacy_accelerate/references/operator-sentinel.md"
ln -s "../$(basename "$legacy_catalog")/accelerate" "$target/accelerate"
expected_accelerate_link="$(readlink "$target/accelerate")"
printf 'preserve unrelated package\n' >"$target/user-owned-fixture/SKILL.md"
cat >"$codex_home/config.toml" <<'TOML'
model = "legacy-model"
model_reasoning_effort = "high"

[skills]
config = [
  { path = "/unmanaged/operator/SKILL.md", enabled = false },
  { path = "/home/marcelo-karval/.codex/skills/python-pro/SKILL.md", enabled = true },
]

[mcp_servers.fixture]
command = "fixture"
TOML
for profile in django-backend python-backend nextjs-frontend research reviewer qa orchestrator; do
  printf 'old %s profile\n' "$profile" >"$codex_home/$profile.config.toml"
done
printf '{"schema_version":1,"install_identity":"legacy-logical-sentinel"}\n' \
  >"$codex_home/logical-agent-install-receipt.json"
chmod 0664 "$codex_home/logical-agent-install-receipt.json"
cp -a "$legacy_accelerate" "$stage_root/expected-old-accelerate"
cp "$codex_home/config.toml" "$stage_root/expected-old-config.toml"
cp "$codex_home/logical-agent-install-receipt.json" \
  "$stage_root/expected-old-logical-receipt.json"
mkdir "$stage_root/expected-old-profiles"
cp "$codex_home"/*.config.toml "$stage_root/expected-old-profiles/"

(
  umask 000
  CODEX_HOME="$codex_home" \
  CODEX_SKILLS_DIR="$target" \
  CODEX_SKILLS_BACKUP_DIR="$backup" \
  CODEX_SKILLS_RECEIPT_FILE="$receipt" \
  CODEX_SKILL_SYNC_ALLOWED_ROOT="$stage_root" \
    "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null
)
mirror_output="$(CODEX_HOME="$codex_home" CODEX_SKILLS_DIR="$target" \
  bash "$ROOT/scripts/check-global-skill-mirror.sh")"
printf '%s\n' "$mirror_output"
printf '%s\n' "$mirror_output" | rg -F 'This is static installed-state proof only.' >/dev/null
! printf '%s\n' "$mirror_output" | rg -F 'requires restart' >/dev/null

cmp -s "$ROOT/global-runtime/accelerate/SKILL.md" "$target/accelerate/SKILL.md"
test ! -L "$target/accelerate" || {
  printf 'staged global skill mirror failed: legacy package symlink was not migrated\n' >&2
  exit 1
}
cmp -s "$ROOT/adapters/runtime/codex-collaboration/role-policy.json" \
  "$target/accelerate/references/codex-collaboration-role-policy.json"
cmp -s "$ROOT/global-runtime/accelerate/evals/evals.json" \
  "$target/accelerate/evals/evals.json"
test -f "$target/user-owned-fixture/SKILL.md"
test ! -e "$codex_home/orchestrator.config.toml"
test -f "$codex_home/skill-catalog-install-receipt.json"
test -f "$codex_home/logical-agent-install-receipt.json"
! find "$codex_home" -maxdepth 1 -name '.accelerate-sync-*' -print -quit | rg . >/dev/null

python3 - "$codex_home/config.toml" "$receipt" "$backup" <<'PY'
import json
import stat
import sys
import tomllib
from pathlib import Path

config = tomllib.loads(Path(sys.argv[1]).read_text())
if config.get("model") != "gpt-5.6-sol" or config.get("model_reasoning_effort") != "medium":
    raise SystemExit("default orchestrator settings were not reconciled")
if config.get("mcp_servers", {}).get("fixture", {}).get("command") != "fixture":
    raise SystemExit("unmanaged MCP configuration was not preserved")
entries = config.get("skills", {}).get("config", [])
if not any(entry.get("path") == "/unmanaged/operator/SKILL.md" for entry in entries):
    raise SystemExit("unmanaged skill configuration was not preserved")
receipt_path = Path(sys.argv[2]).resolve()
backup = Path(sys.argv[3]).resolve()
if receipt_path.parent != backup or receipt_path.name != "sync-receipt.json":
    raise SystemExit("receipt is not the direct child of the disjoint backup root")
receipt = json.loads(receipt_path.read_text())
private_runtime = [
    Path(sys.argv[1]), receipt_path,
    Path(sys.argv[1]).parent / "skill-catalog-install-receipt.json",
    Path(sys.argv[1]).parent / "logical-agent-install-receipt.json",
]
private_runtime.extend(
    Path(sys.argv[1]).parent / f"{profile}.config.toml"
    for profile in (
        "on-demand", "superpowers-on-demand", "python-backend",
        "nextjs-frontend", "research", "reviewer", "qa", "data-db",
        "integrations-ops",
    )
)
for path in private_runtime:
    mode = stat.S_IMODE(path.stat().st_mode)
    if mode != 0o600:
        raise SystemExit(f"private runtime artifact {path.name} has mode {mode:04o}, expected 0600")
required = {
    "schema_version", "changed_packages", "runtime_files", "rollback_command", "status",
    "target", "target_lexical", "codex_home", "codex_home_lexical",
}
if required - set(receipt):
    raise SystemExit("transaction receipt is incomplete")
if receipt["status"] != "installed":
    raise SystemExit("transaction receipt did not reach installed")
if receipt["schema_version"] != 4:
    raise SystemExit("transaction receipt schema version is not current")
for operation in receipt.get("operations", []):
    digest = operation.get("backup_digest")
    if operation.get("existed_before") and (not isinstance(digest, str) or len(digest) != 64):
        raise SystemExit("pre-existing operation is missing its rollback digest")
    if not operation.get("existed_before") and digest is not None:
        raise SystemExit("new operation must not fabricate a rollback digest")
if Path(receipt["target_lexical"]) != Path(receipt["codex_home_lexical"]) / "skills":
    raise SystemExit("receipt lexical target is not the Codex skills child")
runtime_files = set(receipt.get("runtime_files", []))
expected_receipts = {"skill-catalog-install-receipt.json", "logical-agent-install-receipt.json"}
if not expected_receipts <= runtime_files:
    raise SystemExit("transaction denominator omitted installed ownership receipts")
PY

python3 - "$codex_home" <<'PY'
import hashlib
import json
import sys
from pathlib import Path

home = Path(sys.argv[1]).resolve()
catalog = json.loads((home / "skill-catalog-install-receipt.json").read_text())
logical = json.loads((home / "logical-agent-install-receipt.json").read_text())
if catalog.get("schema_version") != 2 or catalog.get("install_identity") != "codex-skill-catalog":
    raise SystemExit("combined sync did not materialize catalog receipt v2")
if logical.get("schema_version") != 2 or logical.get("install_identity") != "codex-logical-agent-profiles":
    raise SystemExit("combined sync did not materialize logical receipt v2")
for entry in catalog.get("installed", []):
    profile = entry["profile"]
    target = home / ("config.toml" if profile == "global" else f"{profile}.config.toml")
    if Path(entry["target"]) != target:
        raise SystemExit(f"catalog receipt target was not rebased: {profile}")
for entry in logical.get("installed", []):
    agent = entry["agent"]
    target = home / ("config.toml" if agent == "orchestrator" else f"{agent}.config.toml")
    if Path(entry["target"]) != target:
        raise SystemExit(f"logical receipt target was not rebased: {agent}")
    if entry["sha256"] != hashlib.sha256(target.read_bytes()).hexdigest():
        raise SystemExit(f"logical receipt digest was not materialized: {agent}")
PY

# Combined sync receipts must support a later standalone catalog preflight.
# Tampered provenance fails first; exact materialized receipts then reinstall.
cp "$codex_home/skill-catalog-install-receipt.json" "$stage_root/sync-catalog-receipt.json"
cp "$codex_home/logical-agent-install-receipt.json" "$stage_root/sync-logical-receipt.json"
python3 - "$codex_home/logical-agent-install-receipt.json" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
receipt = json.loads(path.read_text())
for entry in receipt["installed"]:
    if entry["agent"] == "data-db":
        entry["sha256"] = "0" * 64
        break
path.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
PY
cp "$codex_home/config.toml" "$stage_root/pre-tamper-catalog-config.toml"
if python3 "$ROOT/scripts/install-codex-skill-catalog.py" \
  "$ROOT/adapters/runtime/codex/skill-catalog-manifest.toml" \
  --codex-home "$codex_home" \
  --logical-topology "$ROOT/adapters/runtime/codex/logical-agent-topology.toml" >/dev/null 2>&1; then
  printf 'staged global skill mirror failed: tampered materialized receipt was accepted\n' >&2
  exit 1
fi
cmp -s "$stage_root/pre-tamper-catalog-config.toml" "$codex_home/config.toml"
cp "$stage_root/sync-logical-receipt.json" "$codex_home/logical-agent-install-receipt.json"
python3 "$ROOT/scripts/install-codex-skill-catalog.py" \
  "$ROOT/adapters/runtime/codex/skill-catalog-manifest.toml" \
  --codex-home "$codex_home" \
  --logical-topology "$ROOT/adapters/runtime/codex/logical-agent-topology.toml" >/dev/null
cmp -s "$stage_root/sync-catalog-receipt.json" \
  "$codex_home/skill-catalog-install-receipt.json" || {
  printf 'staged global skill mirror failed: standalone catalog reinstall drifted catalog receipt\n' >&2
  exit 1
}
cmp -s "$stage_root/sync-logical-receipt.json" \
  "$codex_home/logical-agent-install-receipt.json" || {
  printf 'staged global skill mirror failed: standalone catalog reinstall drifted logical receipt\n' >&2
  exit 1
}

snapshot_operation_targets() {
  local output="$1"
  python3 - "$receipt" "$output" <<'PY'
import hashlib
import json
import os
import stat
import sys
from pathlib import Path


def digest(path: Path) -> str:
    result = hashlib.sha256()

    def field(value: bytes) -> None:
        result.update(len(value).to_bytes(8, "big"))
        result.update(value)

    def visit(node: Path, relative: str) -> None:
        metadata = node.lstat()
        field(relative.encode())
        field(oct(stat.S_IMODE(metadata.st_mode)).encode())
        if stat.S_ISLNK(metadata.st_mode):
            field(b"symlink")
            field(os.readlink(node).encode())
        elif stat.S_ISDIR(metadata.st_mode):
            field(b"directory")
            for child in sorted(node.iterdir(), key=lambda item: item.name):
                visit(child, child.name if relative == "." else f"{relative}/{child.name}")
        elif stat.S_ISREG(metadata.st_mode):
            field(b"file")
            field(node.read_bytes())
        else:
            field(b"other")

    visit(path, ".")
    return result.hexdigest()


receipt = json.loads(Path(sys.argv[1]).read_text())
state = []
for operation in receipt["operations"]:
    target = Path(operation["target"])
    exists = os.path.lexists(target)
    state.append({
        "name": operation["name"],
        "exists": exists,
        "digest": digest(target) if exists else None,
    })
Path(sys.argv[2]).write_text(json.dumps(state, sort_keys=True, separators=(",", ":")) + "\n")
PY
}

# Standalone logical reconciliation after combined sync must be a byte/mode
# no-op across every operation target. Otherwise the frozen installed digests
# reject the transaction's later governed rollback.
snapshot_operation_targets "$stage_root/logical-noop-before.json"
for pass in first second; do
  python3 "$ROOT/scripts/install-codex-logical-agents.py" \
    "$ROOT/adapters/runtime/codex/logical-agent-topology.toml" \
    "$ROOT/adapters/runtime/codex/skill-catalog-manifest.toml" \
    --codex-home "$codex_home" >/dev/null
  snapshot_operation_targets "$stage_root/logical-noop-$pass.json"
  cmp -s "$stage_root/logical-noop-before.json" \
    "$stage_root/logical-noop-$pass.json" || {
    printf 'staged global skill mirror failed: standalone logical reinstall drifted a governed operation target on %s pass\n' "$pass" >&2
    exit 1
  }
done

for profile in on-demand superpowers-on-demand; do
  test -s "$codex_home/$profile.config.toml"
done
for profile in django-backend next-react-frontend product-browser-qa governance-review catalog-librarian; do
  test ! -e "$codex_home/$profile.config.toml"
done
for profile in python-backend nextjs-frontend research reviewer qa data-db integrations-ops; do
  test -s "$codex_home/$profile.config.toml"
done

printf '\n# stale catalog profile\n' >>"$codex_home/django-backend.config.toml"
if CODEX_HOME="$codex_home" CODEX_SKILLS_DIR="$target" \
  bash "$ROOT/scripts/check-global-skill-mirror.sh" >/dev/null 2>&1; then
  printf 'staged global skill mirror failed: stale catalog profile was accepted\n' >&2
  exit 1
fi
rm -f -- "$codex_home/django-backend.config.toml"

cp "$receipt" "$stage_root/clean-sync-receipt.json"
python3 - "$receipt" <<'PY'
import json
import sys
from pathlib import Path
path = Path(sys.argv[1])
receipt = json.loads(path.read_text())
receipt["unexpected_top_level"] = "must be rejected"
receipt["operations"][0]["unexpected_operation_key"] = "must be rejected"
path.write_text(json.dumps(receipt, indent=2) + "\n")
PY
if bash "$ROOT/scripts/rollback-global-skill-sync.sh" "$receipt" >/dev/null 2>&1; then
  printf 'staged global skill mirror failed: receipt schema mutations were accepted\n' >&2
  exit 1
fi
cmp -s "$ROOT/global-runtime/accelerate/SKILL.md" "$target/accelerate/SKILL.md"
mv "$stage_root/clean-sync-receipt.json" "$receipt"

cp -a "$target/accelerate" "$stage_root/expected-installed-accelerate"
mv "$backup/packages/accelerate" "$stage_root/withheld-accelerate-backup"
if bash "$ROOT/scripts/rollback-global-skill-sync.sh" "$receipt" >/dev/null 2>&1; then
  printf 'staged global skill mirror failed: rollback accepted a missing required backup\n' >&2
  exit 1
fi
diff -qr "$stage_root/expected-installed-accelerate" "$target/accelerate"
python3 - "$receipt" <<'PY'
import json
import sys
from pathlib import Path
if json.loads(Path(sys.argv[1]).read_text())["status"] != "installed":
    raise SystemExit("failed rollback changed the installed receipt status")
PY
mv "$stage_root/withheld-accelerate-backup" "$backup/packages/accelerate"

cp "$legacy_accelerate/references/operator-sentinel.md" \
  "$stage_root/original-backup-sentinel.md"
printf 'corrupted backup\n' >"$legacy_accelerate/references/operator-sentinel.md"
if bash "$ROOT/scripts/rollback-global-skill-sync.sh" "$receipt" >/dev/null 2>&1; then
  printf 'staged global skill mirror failed: rollback accepted a corrupted required backup\n' >&2
  exit 1
fi
diff -qr "$stage_root/expected-installed-accelerate" "$target/accelerate"
python3 - "$receipt" <<'PY'
import json
import sys
from pathlib import Path
if json.loads(Path(sys.argv[1]).read_text())["status"] != "installed":
    raise SystemExit("corrupt-backup rejection changed the installed receipt status")
PY
cp "$stage_root/original-backup-sentinel.md" \
  "$legacy_accelerate/references/operator-sentinel.md"

python3 - "$receipt" <<'PY'
import json
import subprocess
import sys
from pathlib import Path

receipt = json.loads(Path(sys.argv[1]).read_text())
subprocess.run(receipt["rollback_command"], check=True)
PY
cmp -s "$stage_root/expected-old-config.toml" "$codex_home/config.toml"
diff -qr "$stage_root/expected-old-accelerate" "$legacy_accelerate"
test -L "$target/accelerate"
test "$(readlink "$target/accelerate")" = "$expected_accelerate_link"
test -f "$target/accelerate/references/operator-sentinel.md"
cmp -s "$stage_root/original-backup-sentinel.md" \
  "$target/accelerate/references/operator-sentinel.md"
for profile in "$stage_root/expected-old-profiles"/*.config.toml; do
  cmp -s "$profile" "$codex_home/$(basename "$profile")"
done
test ! -e "$codex_home/skill-catalog-install-receipt.json"
cmp -s "$stage_root/expected-old-logical-receipt.json" \
  "$codex_home/logical-agent-install-receipt.json"
for profile in next-react-frontend data-db integrations-ops product-browser-qa governance-review catalog-librarian on-demand superpowers-on-demand; do
  test ! -e "$codex_home/$profile.config.toml"
done

failure_home="$stage_root/failure/.codex"
failure_target="$failure_home/skills"
failure_backup="$stage_root/backups/failure"
mkdir -p "$failure_target/accelerate" "$failure_target/operator-package"
printf 'old package\n' >"$failure_target/accelerate/SKILL.md"
printf 'unrelated\n' >"$failure_target/operator-package/SKILL.md"
cat >"$failure_home/config.toml" <<'TOML'
model = "pre-transaction"
[mcp_servers.keep]
command = "keep"
TOML
printf 'old profile\n' >"$failure_home/python-backend.config.toml"
cp -a "$failure_target" "$stage_root/failure-target-before"
cp "$failure_home/config.toml" "$stage_root/failure-config-before.toml"
cp "$failure_home/python-backend.config.toml" "$stage_root/failure-profile-before.toml"
if CODEX_HOME="$failure_home" \
  CODEX_SKILLS_DIR="$failure_target" \
  CODEX_SKILLS_BACKUP_DIR="$failure_backup" \
  CODEX_SKILLS_RECEIPT_FILE="$failure_backup/sync-receipt.json" \
  CODEX_SKILL_SYNC_ALLOWED_ROOT="$stage_root" \
  CODEX_SKILL_SYNC_FAIL_AFTER=catalog \
  "$ROOT/scripts/sync-skills-to-global.sh" >"$stage_root/failure.out" 2>&1; then
  printf 'staged global skill mirror failed: injected partial failure was accepted\n' >&2
  exit 1
fi
rg -F 'injected failure after catalog' "$stage_root/failure.out" >/dev/null
diff -qr "$stage_root/failure-target-before" "$failure_target"
cmp -s "$stage_root/failure-config-before.toml" "$failure_home/config.toml"
cmp -s "$stage_root/failure-profile-before.toml" "$failure_home/python-backend.config.toml"
test ! -e "$failure_home/django-backend.config.toml"

for failure_point in after-backup before-replace after-replace; do
  boundary_home="$stage_root/boundary-$failure_point/.codex"
  boundary_target="$boundary_home/skills"
  boundary_backup="$stage_root/backups/boundary-$failure_point"
  mkdir -p "$boundary_target/accelerate" "$boundary_target/operator-package"
  printf 'old package %s\n' "$failure_point" >"$boundary_target/accelerate/SKILL.md"
  printf 'unrelated %s\n' "$failure_point" >"$boundary_target/operator-package/SKILL.md"
  cat >"$boundary_home/config.toml" <<TOML
model = "pre-$failure_point"
[mcp_servers.keep]
command = "keep-$failure_point"
TOML
  cp -a "$boundary_target" "$stage_root/boundary-target-before-$failure_point"
  cp "$boundary_home/config.toml" "$stage_root/boundary-config-before-$failure_point.toml"
  if CODEX_HOME="$boundary_home" \
    CODEX_SKILLS_DIR="$boundary_target" \
    CODEX_SKILLS_BACKUP_DIR="$boundary_backup" \
    CODEX_SKILLS_RECEIPT_FILE="$boundary_backup/sync-receipt.json" \
    CODEX_SKILL_SYNC_ALLOWED_ROOT="$stage_root" \
    CODEX_SKILL_SYNC_FAIL_AT="$failure_point" \
    "$ROOT/scripts/sync-skills-to-global.sh" >"$stage_root/boundary-$failure_point.out" 2>&1; then
    printf 'staged global skill mirror failed: injected %s operation failure was accepted\n' "$failure_point" >&2
    exit 1
  fi
  rg -F "injected operation failure at $failure_point" "$stage_root/boundary-$failure_point.out" >/dev/null
  diff -qr "$stage_root/boundary-target-before-$failure_point" "$boundary_target"
  cmp -s "$stage_root/boundary-config-before-$failure_point.toml" "$boundary_home/config.toml"
done

assert_rejected() {
  local label="$1" target_path="$2" backup_path="$3" receipt_path="$4"
  if CODEX_HOME="$stage_root/safety/.codex" \
    CODEX_SKILLS_DIR="$target_path" \
    CODEX_SKILLS_BACKUP_DIR="$backup_path" \
    CODEX_SKILLS_RECEIPT_FILE="$receipt_path" \
    CODEX_SKILL_SYNC_ALLOWED_ROOT="$stage_root" \
    "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null 2>&1; then
    printf 'staged global skill mirror failed: unsafe %s paths were accepted\n' "$label" >&2
    exit 1
  fi
}

assert_rejected target-root / "$stage_root/safety-backup/root" "$stage_root/safety-backup/root/sync-receipt.json"
assert_rejected target-home "$HOME" "$stage_root/safety-backup/home" "$stage_root/safety-backup/home/sync-receipt.json"
assert_rejected target-codex-home "$stage_root/safety/.codex" "$stage_root/safety-backup/codex" "$stage_root/safety-backup/codex/sync-receipt.json"
assert_rejected target-repo "$ROOT" "$stage_root/safety-backup/repo" "$stage_root/safety-backup/repo/sync-receipt.json"
assert_rejected nested-backup "$stage_root/nested/skills" "$stage_root/nested/skills/backup" "$stage_root/nested/skills/backup/sync-receipt.json"
assert_rejected ancestor-backup "$stage_root/ancestor/skills" "$stage_root/ancestor" "$stage_root/ancestor/sync-receipt.json"
assert_rejected nested-receipt "$stage_root/receipt/skills" "$stage_root/receipt/backup" "$stage_root/receipt/backup/nested/sync-receipt.json"

symlink_home="$stage_root/symlink/.codex"
symlink_outside="$stage_root/symlink-outside"
symlink_backup="$stage_root/backups/symlink"
mkdir -p "$symlink_home" "$symlink_outside"
printf 'outside sentinel\n' >"$symlink_outside/operator-sentinel.txt"
ln -s "$symlink_outside" "$symlink_home/skills"
if CODEX_HOME="$symlink_home" \
  CODEX_SKILLS_DIR="$symlink_home/skills" \
  CODEX_SKILLS_BACKUP_DIR="$symlink_backup" \
  CODEX_SKILLS_RECEIPT_FILE="$symlink_backup/sync-receipt.json" \
  CODEX_SKILL_SYNC_ALLOWED_ROOT="$stage_root" \
  "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null 2>&1; then
  printf 'staged global skill mirror failed: symlinked skills target was accepted\n' >&2
  exit 1
fi
test -f "$symlink_outside/operator-sentinel.txt"
test ! -e "$symlink_outside/accelerate"

package_symlink_home="$stage_root/package-symlink/.codex"
package_symlink_outside="$stage_root/package-symlink-outside"
package_symlink_backup="$stage_root/backups/package-symlink"
mkdir -p "$package_symlink_home/skills" "$package_symlink_outside"
printf 'outside package sentinel\n' >"$package_symlink_outside/SKILL.md"
ln -s "$package_symlink_outside" "$package_symlink_home/skills/architecture"
if CODEX_HOME="$package_symlink_home" \
  CODEX_SKILLS_DIR="$package_symlink_home/skills" \
  CODEX_SKILLS_BACKUP_DIR="$package_symlink_backup" \
  CODEX_SKILLS_RECEIPT_FILE="$package_symlink_backup/sync-receipt.json" \
  CODEX_SKILL_SYNC_ALLOWED_ROOT="$stage_root" \
  "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null 2>&1; then
  printf 'staged global skill mirror failed: external package symlink was accepted\n' >&2
  exit 1
fi
test -L "$package_symlink_home/skills/architecture"
test -f "$package_symlink_outside/SKILL.md"

assert_package_symlink_rejected() {
  local label="$1" package_home="$2" package_backup="$3"
  if CODEX_HOME="$package_home" \
    CODEX_SKILLS_DIR="$package_home/skills" \
    CODEX_SKILLS_BACKUP_DIR="$package_backup" \
    CODEX_SKILLS_RECEIPT_FILE="$package_backup/sync-receipt.json" \
    CODEX_SKILL_SYNC_ALLOWED_ROOT="$stage_root" \
    "$ROOT/scripts/sync-skills-to-global.sh" >"$stage_root/package-$label.out" 2>&1; then
    printf 'staged global skill mirror failed: %s package symlink was accepted\n' "$label" >&2
    exit 1
  fi
  ! rg -F 'Traceback' "$stage_root/package-$label.out" >/dev/null
}

chain_home="$stage_root/package-chain/.codex"
mkdir -p "$chain_home/skills" "$chain_home/skill-catalog-real/architecture"
ln -s skill-catalog-real "$chain_home/skill-catalog-h55-alias"
ln -s ../skill-catalog-h55-alias/architecture "$chain_home/skills/architecture"
assert_package_symlink_rejected chain "$chain_home" "$stage_root/backups/package-chain"

nested_link_home="$stage_root/package-nested-link/.codex"
mkdir -p "$nested_link_home/skills" "$nested_link_home/skill-catalog-h55/real-architecture"
ln -s real-architecture "$nested_link_home/skill-catalog-h55/architecture"
ln -s ../skill-catalog-h55/architecture "$nested_link_home/skills/architecture"
assert_package_symlink_rejected nested-link "$nested_link_home" "$stage_root/backups/package-nested-link"

empty_suffix_home="$stage_root/package-empty-suffix/.codex"
mkdir -p "$empty_suffix_home/skills" "$empty_suffix_home/skill-catalog-/architecture"
ln -s ../skill-catalog-/architecture "$empty_suffix_home/skills/architecture"
assert_package_symlink_rejected empty-suffix "$empty_suffix_home" "$stage_root/backups/package-empty-suffix"

assert_control_rejected() {
  local label="$1" codex_path="$2" target_path="$3" backup_path="$4" receipt_path="$5" allow_path="$6"
  local output="$stage_root/control-$label.out"
  if CODEX_HOME="$codex_path" CODEX_SKILLS_DIR="$target_path" \
    CODEX_SKILLS_BACKUP_DIR="$backup_path" CODEX_SKILLS_RECEIPT_FILE="$receipt_path" \
    CODEX_SKILL_SYNC_ALLOWED_ROOT="$allow_path" \
    "$ROOT/scripts/sync-skills-to-global.sh" >"$output" 2>&1; then
    printf 'staged global skill mirror failed: control character in %s was accepted\n' "$label" >&2
    exit 1
  fi
  rg -F 'Refusing control character in sync path input' "$output" >/dev/null
  ! rg -F 'Traceback' "$output" >/dev/null
}

control_home="$stage_root/control/.codex"
assert_control_rejected codex-home "$control_home"$'\r' "$control_home"$'\r''/skills' "$stage_root/control-backup/home" "$stage_root/control-backup/home/sync-receipt.json" "$stage_root"
assert_control_rejected target "$control_home" "$control_home/skills"$'\001' "$stage_root/control-backup/target" "$stage_root/control-backup/target/sync-receipt.json" "$stage_root"
assert_control_rejected backup "$control_home" "$control_home/skills" "$stage_root/control-backup/backup"$'\177' "$stage_root/control-backup/backup"$'\177''/sync-receipt.json' "$stage_root"
assert_control_rejected receipt "$control_home" "$control_home/skills" "$stage_root/control-backup/receipt" "$stage_root/control-backup/receipt/sync-"$'\a''receipt.json' "$stage_root"
assert_control_rejected allowlist "$control_home" "$control_home/skills" "$stage_root/control-backup/allow" "$stage_root/control-backup/allow/sync-receipt.json" "$stage_root"$'\r'

echo "staged global skill mirror passed"
