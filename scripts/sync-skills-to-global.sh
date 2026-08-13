#!/usr/bin/env bash
set -euo pipefail
umask 077

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_home_input="${CODEX_HOME:-$HOME/.codex}"
timestamp="$(date -u +%Y%m%dT%H%M%SZ)-$$"
target_input="${CODEX_SKILLS_DIR:-$codex_home_input/skills}"
backup_input="${CODEX_SKILLS_BACKUP_DIR:-$codex_home_input/backups/skill-sync-$timestamp}"
receipt_input="${CODEX_SKILLS_RECEIPT_FILE:-$backup_input/sync-receipt.json}"
allowed_root_input="${CODEX_SKILL_SYNC_ALLOWED_ROOT:-}"
if ! python3 - "$codex_home_input" "$target_input" "$backup_input" "$receipt_input" "$allowed_root_input" <<'PY'
import sys
for value in sys.argv[1:]:
    if any(ord(character) < 32 or ord(character) == 127 for character in value):
        raise SystemExit("Refusing control character in sync path input")
PY
then
  exit 1
fi
codex_home_lexical="$(realpath -ms "$codex_home_input")"
target_lexical="$(realpath -ms "$target_input")"
expected_target_lexical="$codex_home_lexical/skills"
if [[ "$target_lexical" != "$expected_target_lexical" ]]; then
  echo "Skill sync target must be lexically exactly $expected_target_lexical" >&2
  exit 1
fi
if [[ -L "$expected_target_lexical" ]]; then
  echo "Refusing symlinked Codex skills target: $expected_target_lexical" >&2
  exit 1
fi
codex_home="$(realpath -m "$codex_home_input")"
target_root="$(realpath -m "$target_input")"
backup_root="$(realpath -m "$backup_input")"
receipt_file="$(realpath -m "$receipt_input")"
allowed_root="$allowed_root_input"
test_allowlist=false
root_runtime_dir="$root_dir/global-runtime/accelerate"
rollback_script="$root_dir/scripts/rollback-global-skill-sync.sh"
catalog="$root_dir/adapters/runtime/codex/skill-catalog-manifest.toml"
topology="$root_dir/adapters/runtime/codex/logical-agent-topology.toml"
runtime_lock_name=".codex-runtime-mutation.lock"
runtime_lock_fd=""

verify_runtime_lock_fd() {
  local lock_path="$1" descriptor="$2"
  python3 - "$lock_path" "/proc/$$/fd/$descriptor" <<'PY'
import os
import stat
import sys
from pathlib import Path

path = Path(sys.argv[1])
fd_path = Path(sys.argv[2])
try:
    lexical = path.lstat()
    opened = fd_path.stat()
except OSError as error:
    raise SystemExit(f"runtime mutation lock cannot be inspected: {path}: {error}") from None
if (
    not stat.S_ISREG(lexical.st_mode)
    or not stat.S_ISREG(opened.st_mode)
    or lexical.st_nlink != 1
    or opened.st_nlink != 1
    or (lexical.st_dev, lexical.st_ino) != (opened.st_dev, opened.st_ino)
):
    raise SystemExit(f"runtime mutation lock is not an exact regular file: {path}")
PY
  # Operate on the inherited open-file-description itself. A path-based third
  # descriptor cannot distinguish ownership from unrelated contention.
  if ! flock -n "$descriptor"; then
    echo "runtime mutation inherited lock does not hold an exclusive flock: $lock_path" >&2
    return 1
  fi
}

bootstrap_runtime_lock() {
  local lock_path="$codex_home/$runtime_lock_name"
  local inherited_fd="${CODEX_RUNTIME_MUTATION_LOCK_FD:-}"
  if [[ -n "$inherited_fd" ]]; then
    if [[ ! "$inherited_fd" =~ ^[0-9]+$ ]] || [[ "${CODEX_RUNTIME_MUTATION_LOCK_HOME:-}" != "$codex_home" ]]; then
      echo "runtime mutation inherited lock does not govern sync home: $codex_home" >&2
      return 1
    fi
    runtime_lock_fd="$inherited_fd"
    verify_runtime_lock_fd "$lock_path" "$runtime_lock_fd"
    return
  fi
  if [[ -n "${CODEX_RUNTIME_MUTATION_LOCK_HOME:-}" || -n "${CODEX_RUNTIME_MUTATION_LOCK_OWNER_PID:-}" ]]; then
    echo "runtime mutation inherited lock environment is incomplete" >&2
    return 1
  fi
  local bootstrap_status=0
  python3 - "$codex_home" "$root_dir/scripts/sync-skills-to-global.sh" <<'PY' || bootstrap_status=$?
import fcntl
import os
import stat
import sys
from pathlib import Path

home = Path(sys.argv[1]).resolve()
script = str(Path(sys.argv[2]).resolve())
directory = os.open(home, os.O_RDONLY | os.O_DIRECTORY | getattr(os, "O_NOFOLLOW", 0))
try:
    flags = os.O_RDWR | os.O_CREAT | getattr(os, "O_NOFOLLOW", 0)
    descriptor = os.open(".codex-runtime-mutation.lock", flags, 0o600, dir_fd=directory)
    opened = os.fstat(descriptor)
    lexical = os.stat(".codex-runtime-mutation.lock", dir_fd=directory, follow_symlinks=False)
    if (
        not stat.S_ISREG(opened.st_mode)
        or not stat.S_ISREG(lexical.st_mode)
        or opened.st_nlink != 1
        or lexical.st_nlink != 1
        or (opened.st_dev, opened.st_ino) != (lexical.st_dev, lexical.st_ino)
    ):
        raise SystemExit(f"runtime mutation lock is not an exact regular file: {home / '.codex-runtime-mutation.lock'}")
    try:
        fcntl.flock(descriptor, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        raise SystemExit(f"runtime mutation is already locked: {home / '.codex-runtime-mutation.lock'}") from None
    os.fchmod(descriptor, 0o600)
    os.set_inheritable(descriptor, True)
finally:
    os.close(directory)
environment = os.environ.copy()
environment["CODEX_RUNTIME_MUTATION_LOCK_FD"] = str(descriptor)
environment["CODEX_RUNTIME_MUTATION_LOCK_HOME"] = str(home)
environment["CODEX_RUNTIME_MUTATION_LOCK_OWNER_PID"] = str(os.getpid())
os.execve("/bin/bash", ["/bin/bash", script], environment)
PY
  exit "$bootstrap_status"
}

release_runtime_lock() {
  if [[ -n "$runtime_lock_fd" ]]; then
    flock -u "$runtime_lock_fd" || true
    eval "exec ${runtime_lock_fd}>&-"
    runtime_lock_fd=""
  fi
  unset CODEX_RUNTIME_MUTATION_LOCK_FD
  unset CODEX_RUNTIME_MUTATION_LOCK_HOME
  unset CODEX_RUNTIME_MUTATION_LOCK_OWNER_PID
}

if [[ -n "$allowed_root" ]]; then
  test_allowlist=true
  allowed_root="$(realpath -m "$allowed_root")"
  case "$allowed_root" in
    /|/home|"$HOME"|"$root_dir")
      echo "Refusing broad test allowlist root: $allowed_root" >&2
      exit 1
      ;;
  esac
  case "$codex_home" in "$allowed_root"/*) ;; *) echo "Codex home is outside the test allowlist: $codex_home" >&2; exit 1 ;; esac
  case "$target_root" in "$allowed_root"/*) ;; *) echo "Skill target is outside the test allowlist: $target_root" >&2; exit 1 ;; esac
  case "$backup_root" in "$allowed_root"/*) ;; *) echo "Backup is outside the test allowlist: $backup_root" >&2; exit 1 ;; esac
else
  allowed_root="$codex_home"
  case "$backup_root" in "$codex_home"/*) ;; *) echo "Production backup must remain below $codex_home" >&2; exit 1 ;; esac
fi

expected_target="$(realpath -m "$codex_home/skills")"
if [[ "$target_root" != "$expected_target" || "$target_root" != "$codex_home"/skills ]]; then
  echo "Skill sync target must be exactly $expected_target" >&2
  exit 1
fi
case "$codex_home" in /|/home|"$HOME"|"$root_dir") echo "Refusing broad Codex home: $codex_home" >&2; exit 1 ;; esac
case "$target_root" in /|/home|"$HOME"|"$codex_home"|"$root_dir") echo "Refusing broad skill sync target: $target_root" >&2; exit 1 ;; esac
case "$backup_root" in /|/home|"$HOME"|"$codex_home"|"$root_dir"|"$target_root"|"$target_root"/*) echo "Backup must be a separate bounded path: $backup_root" >&2; exit 1 ;; esac
case "$target_root" in "$backup_root"/*) echo "Backup cannot be an ancestor of the skill target: $backup_root" >&2; exit 1 ;; esac
if [[ "$receipt_file" != "$backup_root/sync-receipt.json" ]]; then
  echo "Receipt must be the direct sync-receipt.json child of the backup root" >&2
  exit 1
fi
if [[ -e "$receipt_file" ]]; then
  echo "Refusing to overwrite existing sync receipt: $receipt_file" >&2
  exit 1
fi
if [[ -e "$backup_root" ]] && { [[ ! -d "$backup_root" ]] || [[ -n "$(find "$backup_root" -mindepth 1 -print -quit)" ]]; }; then
  echo "Backup path must be absent or empty: $backup_root" >&2
  exit 1
fi

"$root_dir/scripts/validate-skill-registry.sh"
python3 "$root_dir/scripts/validate-codex-skill-catalog.py" "$catalog"
python3 "$root_dir/scripts/validate-codex-logical-agent-topology.py" \
  "$topology" "$catalog" "$root_dir/adapters/runtime/codex-collaboration/role-policy.json"

stage_packages=""
stage_home=""
operations_file=""
rollback_needed=0
cleanup() {
  local status=$?
  trap - EXIT
  if [[ "$rollback_needed" -eq 1 ]]; then
    local rollback_output
    if ! rollback_output="$(bash "$rollback_script" "$receipt_file" 2>&1)"; then
      printf 'Automatic rollback failed after sync error:\n%s\n' "$rollback_output" >&2
      status=70
    fi
  fi
  [[ -z "$stage_packages" ]] || rm -rf -- "$stage_packages"
  [[ -z "$stage_home" ]] || rm -rf -- "$stage_home"
  release_runtime_lock
  exit "$status"
}
trap cleanup EXIT

mkdir -p "$codex_home"
bootstrap_runtime_lock
mkdir -p "$target_root"
stage_packages="$(mktemp -d "$target_root/.accelerate-sync-packages.XXXXXX")"
stage_home="$(mktemp -d "$codex_home/.accelerate-sync-runtime.XXXXXX")"
operations_file="$stage_home/operations.tsv"

while IFS= read -r skill_file; do
  skill_dir="$(dirname "$skill_file")"
  skill_name="$(basename "$skill_dir")"
  mkdir -p "$stage_packages/$skill_name"
  cp -a "$skill_dir/." "$stage_packages/$skill_name/"
done < <(find "$root_dir/skills" -mindepth 3 -maxdepth 3 -name SKILL.md | sort)

accelerate_stage="$stage_packages/accelerate"
mkdir -p "$accelerate_stage/references" "$accelerate_stage/agents"
for file_name in SKILL.md README.md metadata.yaml; do
  [[ -f "$root_runtime_dir/$file_name" ]] && cp -a "$root_runtime_dir/$file_name" "$accelerate_stage/$file_name"
done
for support_dir in assets evals scripts templates; do
  if [[ -d "$root_runtime_dir/$support_dir" ]]; then
    mkdir -p "$accelerate_stage/$support_dir"
    cp -a "$root_runtime_dir/$support_dir/." "$accelerate_stage/$support_dir/"
  fi
done
cp -a "$root_dir/references/." "$accelerate_stage/references/"
cp -a "$root_dir/adapters/runtime/codex-collaboration/role-policy.json" \
  "$accelerate_stage/references/codex-collaboration-role-policy.json"
[[ -f "$root_dir/agents/openai.yaml" ]] && cp -a "$root_dir/agents/openai.yaml" "$accelerate_stage/agents/openai.yaml"

if [[ -f "$codex_home/config.toml" ]]; then
  cp -a "$codex_home/config.toml" "$stage_home/config.toml"
fi
python3 "$root_dir/scripts/install-codex-skill-catalog.py" "$catalog" --codex-home "$stage_home" >/dev/null
python3 "$root_dir/scripts/install-codex-logical-agents.py" "$topology" "$catalog" --codex-home "$stage_home" >/dev/null

# Materialize standalone installer receipts for the real CODEX_HOME. These are
# separate runtime ownership receipts (catalog v2 and logical v2), not the
# outer sync transaction receipt (v4). Targets and digests describe the exact
# files that the transaction will install at CODEX_HOME.
python3 - "$stage_home" "$codex_home" "$catalog" <<'PY'
import hashlib
import json
import os
import sys
import tomllib
from pathlib import Path

stage = Path(sys.argv[1]).resolve()
home = Path(sys.argv[2]).resolve()
catalog_manifest = tomllib.loads(Path(sys.argv[3]).read_text())

catalog_path = stage / "skill-catalog-install-receipt.json"
catalog = json.loads(catalog_path.read_text())
if catalog.get("schema_version") != 2 or catalog.get("install_identity") != "codex-skill-catalog":
    raise SystemExit("staged catalog receipt is not schema v2")
for entry in catalog["installed"]:
    profile = entry["profile"]
    entry["target"] = str(home / ("config.toml" if profile == "global" else f"{profile}.config.toml"))
    entry["backup"] = None
for entry in catalog["profile_ownership"]:
    profile = entry["profile"]
    target = stage / f"{profile}.config.toml"
    entry["target"] = str(home / target.name)
    entry["sha256"] = hashlib.sha256(target.read_bytes()).hexdigest()
catalog["rollback_directory"] = None

logical_path = stage / "logical-agent-install-receipt.json"
logical = json.loads(logical_path.read_text())
if logical.get("schema_version") != 2 or logical.get("install_identity") != "codex-logical-agent-profiles":
    raise SystemExit("staged logical receipt is not schema v2")
for entry in logical["installed"]:
    agent = entry["agent"]
    name = "config.toml" if agent == "orchestrator" else f"{agent}.config.toml"
    target = stage / name
    entry["target"] = str(home / name)
    entry["backup"] = None
    entry["sha256"] = hashlib.sha256(target.read_bytes()).hexdigest()
for entry in logical["retired_profiles"]:
    agent = entry["agent"]
    entry["target"] = str(home / f"{agent}.config.toml")
    entry["backup"] = None
logical["rollback_directory"] = None
logical_path.write_text(json.dumps(logical, indent=2, sort_keys=True) + "\n")
os.chmod(logical_path, 0o600)

# Catalog and logical profile names intentionally overlap for internal aliases.
# Materialize that current logical ownership into the catalog receipt so a
# standalone catalog reinstall is an exact byte-idempotent no-op.
hidden = {
    str(group["profile"])
    for group in catalog_manifest["groups"]
    if group.get("profile") and group.get("public_profile") is False
}
logical_by_agent = {
    str(entry["agent"]): entry
    for entry in logical["installed"]
    if entry["agent"] != "orchestrator"
}
preserved = sorted(hidden & set(logical_by_agent))
catalog["preserved_logical_profiles"] = preserved
catalog["profile_ownership"] = [
    entry for entry in catalog["profile_ownership"]
    if entry["profile"] not in set(preserved)
]
for profile in preserved:
    logical_entry = logical_by_agent[profile]
    catalog["profile_ownership"].append(
        {
            "profile": profile,
            "target": logical_entry["target"],
            "owner": "logical",
            "sha256": logical_entry["sha256"],
            "provenance": "logical-agent-install-receipt",
        }
    )
catalog["profile_ownership"].sort(key=lambda entry: entry["profile"])
catalog_path.write_text(json.dumps(catalog, indent=2, sort_keys=True) + "\n")
os.chmod(catalog_path, 0o600)
PY

: >"$operations_file"
while IFS= read -r package; do
  name="$(basename "$package")"
  if [[ -L "$target_root/$name" ]]; then
    if ! python3 - "$target_root/$name" "$codex_home" "$name" <<'PY'
import sys
import os
import re
from pathlib import Path

link = Path(sys.argv[1])
home = Path(sys.argv[2]).resolve(strict=True)
package_name = sys.argv[3]
raw_target = Path(os.readlink(link))
lexical_target = Path(os.path.normpath(str(raw_target if raw_target.is_absolute() else link.parent / raw_target)))
try:
    relative = lexical_target.relative_to(home)
except ValueError:
    raise SystemExit("legacy package symlink escapes CODEX_HOME or is broken")
if (
    lexical_target.name != package_name
    or len(relative.parts) != 2
    or re.fullmatch(r"skill-catalog-[A-Za-z0-9][A-Za-z0-9._-]*", relative.parts[0]) is None
):
    raise SystemExit("legacy package symlink does not match CODEX_HOME/skill-catalog-*/<package>")
current = home
for part in relative.parts:
    current = current / part
    if current.is_symlink():
        raise SystemExit("legacy package target traverses another symlink")
try:
    resolved_target = lexical_target.resolve(strict=True)
except (FileNotFoundError, OSError):
    raise SystemExit("legacy package symlink escapes CODEX_HOME or is broken") from None
if resolved_target != lexical_target or not resolved_target.is_dir():
    raise SystemExit("legacy package target is not a real directory")
PY
    then
      echo "Refusing unsafe governed package symlink: $target_root/$name" >&2
      exit 1
    fi
  fi
  existed=false
  [[ -e "$target_root/$name" ]] && existed=true
  printf 'packages\tpackage\t%s\t%s\t%s\t%s\treplace\n' \
    "$name" "$target_root/$name" "$backup_root/packages/$name" "$existed" >>"$operations_file"
done < <(find "$stage_packages" -mindepth 1 -maxdepth 1 -type d | sort)

mapfile -t catalog_profiles < <(python3 "$root_dir/scripts/render-codex-skill-profile.py" "$catalog" --mode profile --list-profiles)
mapfile -t hidden_catalog_profiles < <(python3 "$root_dir/scripts/render-codex-skill-profile.py" "$catalog" --mode profile --list-hidden-profiles)
mapfile -t logical_profiles < <(python3 - "$topology" <<'PY'
import sys
import tomllib
from pathlib import Path
for agent in tomllib.loads(Path(sys.argv[1]).read_text())["agents"]:
    if agent["kind"] == "specialist":
        print(agent["name"])
PY
)
declare -A logical_profile_names=()
for profile in "${logical_profiles[@]}"; do
  logical_profile_names["$profile"]=1
done
for profile in "${catalog_profiles[@]}"; do
  target="$codex_home/$profile.config.toml"
  if [[ -L "$target" ]]; then
    echo "Refusing symlinked catalog profile target: $target" >&2
    exit 1
  fi
  existed=false
  [[ -e "$target" ]] && existed=true
  printf 'catalog\truntime-file\t%s.config.toml\t%s\t%s\t%s\treplace\n' \
    "$profile" "$target" "$backup_root/runtime/$profile.config.toml" "$existed" >>"$operations_file"
done
target="$codex_home/skill-catalog-install-receipt.json"
if [[ -L "$target" ]]; then
  echo "Refusing symlinked catalog receipt target: $target" >&2
  exit 1
fi
existed=false
[[ -e "$target" ]] && existed=true
printf 'catalog\truntime-file\tskill-catalog-install-receipt.json\t%s\t%s\t%s\treplace\n' \
  "$target" "$backup_root/runtime/skill-catalog-install-receipt.json" "$existed" >>"$operations_file"
for profile in "${hidden_catalog_profiles[@]}"; do
  if [[ -n "${logical_profile_names[$profile]:-}" ]]; then
    continue
  fi
  target="$codex_home/$profile.config.toml"
  if [[ -L "$target" ]]; then
    echo "Refusing symlinked hidden catalog profile target: $target" >&2
    exit 1
  fi
  existed=false
  [[ -e "$target" ]] && existed=true
  printf 'catalog\truntime-file\t%s.config.toml\t%s\t%s\t%s\tdelete\n' \
    "$profile" "$target" "$backup_root/runtime/$profile.config.toml" "$existed" >>"$operations_file"
done

target="$codex_home/config.toml"
if [[ -L "$target" ]]; then
  echo "Refusing symlinked Codex config target: $target" >&2
  exit 1
fi
existed=false
[[ -e "$target" ]] && existed=true
printf 'logical\truntime-file\tconfig.toml\t%s\t%s\t%s\treplace\n' \
  "$target" "$backup_root/runtime/config.toml" "$existed" >>"$operations_file"
target="$codex_home/logical-agent-install-receipt.json"
if [[ -L "$target" ]]; then
  echo "Refusing symlinked logical receipt target: $target" >&2
  exit 1
fi
existed=false
[[ -e "$target" ]] && existed=true
printf 'logical\truntime-file\tlogical-agent-install-receipt.json\t%s\t%s\t%s\treplace\n' \
  "$target" "$backup_root/runtime/logical-agent-install-receipt.json" "$existed" >>"$operations_file"
for profile in "${logical_profiles[@]}"; do
  target="$codex_home/$profile.config.toml"
  if [[ -L "$target" ]]; then
    echo "Refusing symlinked logical profile target: $target" >&2
    exit 1
  fi
  existed=false
  [[ -e "$target" ]] && existed=true
  printf 'logical\truntime-file\t%s.config.toml\t%s\t%s\t%s\treplace\n' \
    "$profile" "$target" "$backup_root/runtime/$profile.config.toml" "$existed" >>"$operations_file"
done
target="$codex_home/orchestrator.config.toml"
if [[ -L "$target" ]]; then
  echo "Refusing symlinked orchestrator profile target: $target" >&2
  exit 1
fi
existed=false
[[ -e "$target" ]] && existed=true
printf 'logical\truntime-file\torchestrator.config.toml\t%s\t%s\t%s\tdelete\n' \
  "$target" "$backup_root/runtime/orchestrator.config.toml" "$existed" >>"$operations_file"

mkdir -p "$backup_root"
python3 - "$receipt_file" "$root_dir" "$target_root" "$target_lexical" "$codex_home" "$codex_home_lexical" "$backup_root" "$allowed_root" "$test_allowlist" "$rollback_script" "$catalog" "$topology" "$operations_file" <<'PY'
import hashlib
import json
import os
import stat
import sys
from pathlib import Path


def governed_digest(path: Path, symlink_context: Path | None = None) -> str:
    digest = hashlib.sha256()

    def field(value: bytes) -> None:
        digest.update(len(value).to_bytes(8, "big"))
        digest.update(value)

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
                child_relative = child.name if relative == "." else f"{relative}/{child.name}"
                visit(child, child_relative)
        elif stat.S_ISREG(metadata.st_mode):
            field(b"file")
            with node.open("rb") as handle:
                for chunk in iter(lambda: handle.read(1024 * 1024), b""):
                    digest.update(chunk)
        else:
            raise SystemExit(f"unsupported governed backup node: {node}")

    root_metadata = path.lstat()
    visit(path, ".")
    if stat.S_ISLNK(root_metadata.st_mode):
        field(b"root-symlink-target")
        raw_target = Path(os.readlink(path))
        contextual_target = raw_target if raw_target.is_absolute() else (symlink_context or path.parent) / raw_target
        try:
            resolved_target = contextual_target.resolve(strict=True)
        except (FileNotFoundError, OSError) as error:
            raise SystemExit(f"governed symlink target cannot be resolved: {path}: {error}") from None
        visit(resolved_target, "@target")
    return digest.hexdigest()


def file_digest(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def operation_plan_digest(package_denominator: list[str], runtime_denominator: list[str], operations: list[dict]) -> str:
    plan = {
        "package_denominator": package_denominator,
        "runtime_denominator": runtime_denominator,
        "operations": [
            {
                key: item[key]
                for key in (
                    "lane", "kind", "name", "target", "backup",
                    "existed_before", "action", "backup_digest",
                )
            }
            for item in operations
        ],
    }
    encoded = json.dumps(plan, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(encoded).hexdigest()


(
    receipt_path, source, target, target_lexical, codex_home,
    codex_home_lexical, backup, allowed_root, test_allowlist,
    rollback_script, catalog, topology, operations_path,
) = sys.argv[1:]
operations = []
for line in Path(operations_path).read_text().splitlines():
    lane, kind, name, target_path, backup_path, existed, action = line.split("\t")
    existed_before = existed == "true"
    operations.append({
        "lane": lane, "kind": kind, "name": name, "target": target_path,
        "backup": backup_path, "existed_before": existed_before, "action": action,
        "backup_digest": governed_digest(Path(target_path), Path(target_path).parent) if existed_before else None,
        "installed_digest": None,
    })
package_denominator = [item["name"] for item in operations if item["kind"] == "package"]
runtime_denominator = [item["name"] for item in operations if item["kind"] == "runtime-file"]
receipt = {
    "schema_version": 4,
    "source_authority": "repo",
    "source": source,
    "target": target,
    "target_lexical": target_lexical,
    "codex_home": codex_home,
    "codex_home_lexical": codex_home_lexical,
    "backup": backup,
    "allowed_root": allowed_root,
    "test_allowlist": test_allowlist == "true",
    "changed_packages": package_denominator,
    "runtime_files": runtime_denominator,
    "operations": operations,
    "generation": {
        "package_denominator": package_denominator,
        "runtime_denominator": runtime_denominator,
        "source_snapshots": {
            "catalog": {"path": catalog, "sha256": file_digest(Path(catalog))},
            "topology": {"path": topology, "sha256": file_digest(Path(topology))},
            "rollback": {"path": rollback_script, "sha256": file_digest(Path(rollback_script))},
        },
        "operation_plan_digest": operation_plan_digest(
            package_denominator, runtime_denominator, operations
        ),
    },
    "rollback_command": ["/bin/bash", rollback_script, receipt_path],
    "status": "prepared",
    "transaction_started": False,
    "backup_complete": False,
}
Path(receipt_path).write_text(json.dumps(receipt, indent=2) + "\n")
PY

rollback_needed=1
python3 - "$receipt_file" <<'PY'
import json
import os
import sys
from pathlib import Path
path = Path(sys.argv[1])
receipt = json.loads(path.read_text())
receipt["transaction_started"] = True
temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
temporary.write_text(json.dumps(receipt, indent=2) + "\n")
os.replace(temporary, path)
PY

backup_count=0
while IFS=$'\t' read -r lane kind name target backup existed action; do
  if [[ "$existed" == true ]]; then
    mkdir -p "$(dirname "$backup")"
    mv -- "$target" "$backup"
    backup_count=$((backup_count + 1))
    if [[ "${CODEX_SKILL_SYNC_FAIL_AT:-}" == after-backup && "$backup_count" -eq 1 ]]; then
      echo "injected operation failure at after-backup" >&2
      exit 94
    fi
  fi
done <"$operations_file"

python3 - "$receipt_file" <<'PY'
import json
import os
import sys
from pathlib import Path
path = Path(sys.argv[1])
receipt = json.loads(path.read_text())
receipt["backup_complete"] = True
temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
temporary.write_text(json.dumps(receipt, indent=2) + "\n")
os.replace(temporary, path)
PY
if [[ "${CODEX_SKILL_SYNC_FAIL_AT:-}" == before-replace ]]; then
  echo "injected operation failure at before-replace" >&2
  exit 95
fi

replace_count=0
apply_lane() {
  local requested_lane="$1"
  while IFS=$'\t' read -r lane kind name target backup existed action; do
    if [[ "$lane" != "$requested_lane" ]]; then
      continue
    fi
    if [[ "$action" == replace ]]; then
      if [[ "$kind" == package ]]; then
        mv -- "$stage_packages/$name" "$target"
      else
        mv -- "$stage_home/$name" "$target"
      fi
      replace_count=$((replace_count + 1))
      if [[ "${CODEX_SKILL_SYNC_FAIL_AT:-}" == after-replace && "$replace_count" -eq 1 ]]; then
        echo "injected operation failure at after-replace" >&2
        exit 96
      fi
    fi
  done <"$operations_file"
}

apply_lane packages
if [[ "${CODEX_SKILL_SYNC_FAIL_AFTER:-}" == packages ]]; then
  echo "injected failure after packages" >&2
  exit 91
fi
apply_lane catalog
if [[ "${CODEX_SKILL_SYNC_FAIL_AFTER:-}" == catalog ]]; then
  echo "injected failure after catalog" >&2
  exit 92
fi
apply_lane logical
if [[ "${CODEX_SKILL_SYNC_FAIL_AFTER:-}" == logical ]]; then
  echo "injected failure after logical" >&2
  exit 93
fi

python3 - "$receipt_file" <<'PY'
import hashlib
import json
import os
import stat
import sys
from pathlib import Path


def lexists(path: Path) -> bool:
    return os.path.lexists(path)


def governed_digest(path: Path, symlink_context: Path | None = None) -> str:
    digest = hashlib.sha256()

    def field(value: bytes) -> None:
        digest.update(len(value).to_bytes(8, "big"))
        digest.update(value)

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
                child_relative = child.name if relative == "." else f"{relative}/{child.name}"
                visit(child, child_relative)
        elif stat.S_ISREG(metadata.st_mode):
            field(b"file")
            with node.open("rb") as handle:
                for chunk in iter(lambda: handle.read(1024 * 1024), b""):
                    digest.update(chunk)
        else:
            raise SystemExit(f"unsupported governed installed node: {node}")

    root_metadata = path.lstat()
    visit(path, ".")
    if stat.S_ISLNK(root_metadata.st_mode):
        field(b"root-symlink-target")
        raw_target = Path(os.readlink(path))
        contextual_target = raw_target if raw_target.is_absolute() else (symlink_context or path.parent) / raw_target
        try:
            resolved_target = contextual_target.resolve(strict=True)
        except (FileNotFoundError, OSError) as error:
            raise SystemExit(f"governed symlink target cannot be resolved: {path}: {error}") from None
        visit(resolved_target, "@target")
    return digest.hexdigest()


path = Path(sys.argv[1])
receipt = json.loads(path.read_text())
for operation in receipt["operations"]:
    target = Path(operation["target"])
    if operation["action"] == "replace":
        if not lexists(target):
            raise SystemExit(f"installed replacement is missing: {operation['name']}")
        operation["installed_digest"] = governed_digest(target, target.parent)
    elif operation["action"] == "delete":
        if lexists(target):
            raise SystemExit(f"installed deletion target still exists: {operation['name']}")
        operation["installed_digest"] = None
    else:
        raise SystemExit(f"unsupported installed action: {operation['action']}")
receipt["status"] = "installed"
temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
temporary.write_text(json.dumps(receipt, indent=2) + "\n")
os.replace(temporary, path)
PY
rollback_needed=0

echo "Synced governed Accelerate packages and Codex runtime to $codex_home"
echo "Backup: $backup_root"
echo "Receipt: $receipt_file"
