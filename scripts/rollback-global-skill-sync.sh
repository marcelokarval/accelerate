#!/usr/bin/env bash
set -euo pipefail
umask 077

receipt_file="${1:-}"
if [[ -z "$receipt_file" || ! -f "$receipt_file" || -L "$receipt_file" ]]; then
  echo "Usage: $0 /absolute/path/to/sync-receipt.json" >&2
  exit 1
fi
receipt_file="$(realpath -m "$receipt_file")"
root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
validation_file="$(mktemp)"
runtime_lock_name=".codex-runtime-mutation.lock"
runtime_lock_fd=""
runtime_lock_owned=false

verify_runtime_lock_fd() {
  local lock_path="$1" descriptor="$2"
  python3 - "$lock_path" "/proc/$$/fd/$descriptor" <<'PY'
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
  # Verify/acquire the inherited open-file-description directly; contention on
  # a separately opened path does not prove this descriptor owns the lock.
  if ! flock -n "$descriptor"; then
    echo "runtime mutation inherited lock does not hold an exclusive flock: $lock_path" >&2
    return 1
  fi
}

acquire_runtime_lock() {
  local governed_home="$1" lock_path="$1/$runtime_lock_name"
  local inherited_fd="${CODEX_RUNTIME_MUTATION_LOCK_FD:-}"
  if [[ -n "$inherited_fd" ]]; then
    if [[ ! "$inherited_fd" =~ ^[0-9]+$ ]] || [[ "${CODEX_RUNTIME_MUTATION_LOCK_HOME:-}" != "$governed_home" ]]; then
      echo "runtime mutation inherited lock does not govern rollback home: $governed_home" >&2
      return 1
    fi
    runtime_lock_fd="$inherited_fd"
    verify_runtime_lock_fd "$lock_path" "$runtime_lock_fd"
    if [[ "${CODEX_RUNTIME_MUTATION_LOCK_OWNER_PID:-}" == "$$" ]]; then
      runtime_lock_owned=true
    fi
    return
  fi
  if [[ -n "${CODEX_RUNTIME_MUTATION_LOCK_HOME:-}" || -n "${CODEX_RUNTIME_MUTATION_LOCK_OWNER_PID:-}" ]]; then
    echo "runtime mutation inherited lock environment is incomplete" >&2
    return 1
  fi
  local bootstrap_status=0
  python3 - "$governed_home" "$root_dir/scripts/rollback-global-skill-sync.sh" "$receipt_file" <<'PY' || bootstrap_status=$?
import fcntl
import os
import stat
import sys
from pathlib import Path

home = Path(sys.argv[1]).resolve()
script = str(Path(sys.argv[2]).resolve())
receipt = str(Path(sys.argv[3]).resolve())
directory = os.open(home, os.O_RDONLY | os.O_DIRECTORY | getattr(os, "O_NOFOLLOW", 0))
try:
    flags = os.O_RDWR | getattr(os, "O_NOFOLLOW", 0)
    descriptor = os.open(".codex-runtime-mutation.lock", flags, dir_fd=directory)
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
os.execve("/bin/bash", ["/bin/bash", script, receipt], environment)
PY
  exit "$bootstrap_status"
}

cleanup() {
  rm -f -- "$validation_file"
  if [[ -n "$runtime_lock_fd" && "$runtime_lock_owned" == true ]]; then
    flock -u "$runtime_lock_fd" || true
    eval "exec ${runtime_lock_fd}>&-"
  fi
}
trap cleanup EXIT

# Extract only the absolute lexical lock-home locator before serialization.
# The receipt schema, transaction state, snapshots, targets, and digests remain
# unread authority until after the cooperative lock is held.
lexical_lock_home="$(python3 - "$receipt_file" <<'PY'
import json
import os
import stat
import sys
from pathlib import Path

path = Path(sys.argv[1])
metadata = path.lstat()
if not stat.S_ISREG(metadata.st_mode) or metadata.st_nlink != 1:
    raise SystemExit("rollback receipt locator must be an exact regular file")
try:
    receipt = json.loads(path.read_text())
except (OSError, json.JSONDecodeError) as error:
    raise SystemExit(f"rollback receipt locator cannot be read: {error}") from None
value = receipt.get("codex_home") if isinstance(receipt, dict) else None
if not isinstance(value, str) or any(ord(character) < 32 or ord(character) == 127 for character in value):
    raise SystemExit("rollback receipt codex_home locator is invalid")
candidate = Path(os.path.normpath(value))
if not candidate.is_absolute() or candidate != candidate.resolve(strict=True):
    raise SystemExit("rollback receipt codex_home locator is not an exact existing directory")
print(candidate)
PY
)"
acquire_runtime_lock "$lexical_lock_home"

if ! python3 - "$receipt_file" "$root_dir" "$HOME" >"$validation_file" <<'PY'
import hashlib
import json
import os
import re
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

receipt_path = Path(sys.argv[1]).resolve()
source_root = Path(sys.argv[2]).resolve()
user_home = Path(sys.argv[3]).resolve()
receipt = json.loads(receipt_path.read_text())
receipt_keys = {
    "schema_version", "source_authority", "source", "target", "target_lexical",
    "codex_home", "codex_home_lexical", "backup", "allowed_root",
    "test_allowlist", "changed_packages", "runtime_files", "operations",
    "generation", "rollback_command", "status", "transaction_started",
    "backup_complete",
}
if not isinstance(receipt, dict) or set(receipt) != receipt_keys:
    raise SystemExit("receipt must contain exactly the governed top-level fields")
operation_keys = {
    "lane", "kind", "name", "target", "backup", "existed_before",
    "action", "backup_digest", "installed_digest",
}
operations = receipt["operations"]
if not isinstance(operations, list) or any(not isinstance(item, dict) or set(item) != operation_keys for item in operations):
    raise SystemExit("receipt operations must match the exact governed operation schema")
string_fields = ("source", "target", "target_lexical", "codex_home", "codex_home_lexical", "backup", "allowed_root", "status")
if any(not isinstance(receipt[field], str) for field in string_fields):
    raise SystemExit("receipt path, source, and status fields must be strings")
path_values = [receipt[field] for field in ("source", "target", "target_lexical", "codex_home", "codex_home_lexical", "backup", "allowed_root")]
path_values.extend(str(item[field]) for item in operations for field in ("name", "target", "backup"))
if any(any(ord(character) < 32 or ord(character) == 127 for character in value) for value in path_values):
    raise SystemExit("receipt contains a control character in a governed path")
if receipt.get("schema_version") != 4 or receipt.get("source_authority") != "repo":
    raise SystemExit("invalid governed runtime sync receipt")
if type(receipt.get("test_allowlist")) is not bool:
    raise SystemExit("receipt test_allowlist must be an exact boolean")
if receipt.get("status") not in {"prepared", "installed", "rolled_back"}:
    raise SystemExit(f"receipt cannot be rolled back from status {receipt.get('status')!r}")
if receipt.get("transaction_started") is not True:
    raise SystemExit("receipt transaction never started")
if type(receipt.get("backup_complete")) is not bool:
    raise SystemExit("receipt backup_complete must be an exact boolean")
target = Path(receipt["target"]).resolve()
home = Path(receipt["codex_home"]).resolve()
target_lexical = Path(os.path.normpath(receipt["target_lexical"]))
home_lexical = Path(os.path.normpath(receipt["codex_home_lexical"]))
backup = Path(receipt["backup"]).resolve()
allowed_root = Path(receipt["allowed_root"]).resolve()
if not target_lexical.is_absolute() or not home_lexical.is_absolute():
    raise SystemExit("receipt lexical runtime paths must be absolute")
if target_lexical != home_lexical / "skills":
    raise SystemExit("receipt lexical skill target is not the Codex skills child")
if target_lexical.is_symlink():
    raise SystemExit("refusing rollback through a symlinked lexical skills target")
if home_lexical.resolve() != home or target_lexical.resolve() != target:
    raise SystemExit("receipt lexical and resolved runtime paths have drifted")
if Path(receipt.get("source", "")).resolve() != source_root:
    raise SystemExit("receipt source is not this governed repository")
for label, path in (("allowed root", allowed_root), ("Codex home", home), ("skill target", target), ("backup", backup)):
    if path in {Path("/"), Path("/home"), user_home, source_root}:
        raise SystemExit(f"refusing broad receipt {label}: {path}")
if receipt.get("test_allowlist"):
    if not home.is_relative_to(allowed_root) or home == allowed_root:
        raise SystemExit("test Codex home is not a strict child of its allowlist")
else:
    if allowed_root != home:
        raise SystemExit("production receipt allowlist must be the Codex home")
if receipt_path != backup / "sync-receipt.json":
    raise SystemExit("receipt must be the direct sync-receipt.json child of its backup")
if target != home / "skills":
    raise SystemExit("receipt skill target is not the Codex skills directory")
if not target.is_relative_to(home) or target == home:
    raise SystemExit("receipt skill target is outside the resolved Codex home")
if not target.is_relative_to(allowed_root) or target == allowed_root:
    raise SystemExit("receipt skill target is outside its bounded allowlist")
if not backup.is_relative_to(allowed_root) or backup == allowed_root:
    raise SystemExit("receipt backup is outside its bounded allowlist")
if backup == target or backup.is_relative_to(target) or target.is_relative_to(backup):
    raise SystemExit("receipt backup and target are not disjoint")

expected_rollback = source_root / "scripts/rollback-global-skill-sync.sh"
expected_command = ["/bin/bash", str(expected_rollback), str(receipt_path)]
if receipt.get("rollback_command") != expected_command:
    raise SystemExit("receipt rollback_command is not the exact governed argv")

generation = receipt.get("generation")
generation_keys = {
    "package_denominator", "runtime_denominator", "source_snapshots",
    "operation_plan_digest",
}
if not isinstance(generation, dict) or set(generation) != generation_keys:
    raise SystemExit("receipt generation must match the exact governed schema")
package_denominator = generation["package_denominator"]
runtime_denominator = generation["runtime_denominator"]
for label, denominator in (
    ("package", package_denominator), ("runtime", runtime_denominator)
):
    if (
        not isinstance(denominator, list)
        or not all(isinstance(name, str) and name for name in denominator)
        or len(denominator) != len(set(denominator))
    ):
        raise SystemExit(f"receipt {label} denominator is invalid")
snapshots = generation["source_snapshots"]
expected_snapshot_paths = {
    "catalog": source_root / "adapters/runtime/codex/skill-catalog-manifest.toml",
    "topology": source_root / "adapters/runtime/codex/logical-agent-topology.toml",
    "rollback": expected_rollback,
}
if not isinstance(snapshots, dict) or set(snapshots) != set(expected_snapshot_paths):
    raise SystemExit("receipt source snapshots are incomplete")
for name, expected_path in expected_snapshot_paths.items():
    snapshot = snapshots[name]
    if not isinstance(snapshot, dict) or set(snapshot) != {"path", "sha256"}:
        raise SystemExit(f"receipt {name} source snapshot is invalid")
    if snapshot["path"] != str(expected_path):
        raise SystemExit(f"receipt {name} source snapshot path is not governed")
    if not isinstance(snapshot["sha256"], str) or re.fullmatch(r"[0-9a-f]{64}", snapshot["sha256"]) is None:
        raise SystemExit(f"receipt {name} source snapshot digest is invalid")
    if any(ord(character) < 32 or ord(character) == 127 for character in snapshot["path"]):
        raise SystemExit(f"receipt {name} source snapshot path contains a control character")
plan_digest = generation["operation_plan_digest"]
if not isinstance(plan_digest, str) or re.fullmatch(r"[0-9a-f]{64}", plan_digest) is None:
    raise SystemExit("receipt generation operation-plan digest is invalid")

changed_packages = receipt.get("changed_packages", [])
runtime_files = receipt.get("runtime_files", [])
if changed_packages != package_denominator:
    raise SystemExit("receipt package set does not match its own generation denominator")
if runtime_files != runtime_denominator:
    raise SystemExit("receipt runtime-file set does not match its own generation denominator")
if operation_plan_digest(package_denominator, runtime_denominator, operations) != plan_digest:
    raise SystemExit("receipt operation plan does not match its generation digest")
seen_operations = set()
validated_operations = []
for index, item in enumerate(operations):
    operation_string_fields = ("lane", "kind", "name", "target", "backup", "action")
    if any(not isinstance(item[field], str) for field in operation_string_fields):
        raise SystemExit(f"receipt operation string fields are invalid at index {index}")
    name = item.get("name", "")
    if not name or any(character not in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-" for character in name):
        raise SystemExit(f"unsafe operation name: {name!r}")
    operation_target = Path(os.path.normpath(item["target"]))
    operation_backup = Path(os.path.normpath(item["backup"]))
    if not operation_target.is_absolute() or not operation_backup.is_absolute():
        raise SystemExit(f"operation paths must be absolute: {name}")
    if type(item.get("existed_before")) is not bool:
        raise SystemExit(f"operation existed_before must be an exact boolean: {name}")
    backup_digest = item.get("backup_digest")
    if item["existed_before"]:
        if not isinstance(backup_digest, str) or not re.fullmatch(r"[0-9a-f]{64}", backup_digest):
            raise SystemExit(f"operation backup_digest must be a lowercase SHA-256: {name}")
    elif backup_digest is not None:
        raise SystemExit(f"operation without prior state must have a null backup_digest: {name}")
    installed_digest = item.get("installed_digest")
    if item.get("action") == "replace":
        if receipt["status"] == "installed":
            if not isinstance(installed_digest, str) or re.fullmatch(r"[0-9a-f]{64}", installed_digest) is None:
                raise SystemExit(f"installed replacement digest is invalid: {name}")
        elif installed_digest is not None and (
            not isinstance(installed_digest, str)
            or re.fullmatch(r"[0-9a-f]{64}", installed_digest) is None
        ):
            raise SystemExit(f"replacement installed_digest is invalid: {name}")
    elif item.get("action") == "delete":
        if installed_digest is not None:
            raise SystemExit(f"delete operation must have a null installed_digest: {name}")
    else:
        raise SystemExit(f"unsafe operation action: {item.get('action')!r}")
    if item["kind"] == "package":
        if name not in package_denominator:
            raise SystemExit(f"package operation is outside its generation denominator: {name}")
        if item.get("lane") != "packages" or item.get("action") != "replace":
            raise SystemExit(f"unsafe package lane or action: {name}")
        if operation_target != target / name or operation_backup != backup / "packages" / name:
            raise SystemExit(f"unsafe package operation: {name}")
    elif item["kind"] == "runtime-file":
        if name not in runtime_denominator or operation_target != home / name or operation_backup != backup / "runtime" / name:
            raise SystemExit(f"unsafe runtime operation: {name}")
        lane = item.get("lane")
        action = item.get("action")
        if name == "config.toml":
            valid_runtime_operation = lane == "logical" and action == "replace"
        elif name == "skill-catalog-install-receipt.json":
            valid_runtime_operation = lane == "catalog" and action == "replace"
        elif name == "logical-agent-install-receipt.json":
            valid_runtime_operation = lane == "logical" and action == "replace"
        elif name == "orchestrator.config.toml":
            valid_runtime_operation = lane == "logical" and action == "delete"
        elif not name.endswith(".config.toml"):
            valid_runtime_operation = False
        else:
            valid_runtime_operation = (
                (lane == "logical" and action == "replace")
                or (lane == "catalog" and action in {"replace", "delete"})
            )
        if not valid_runtime_operation:
            raise SystemExit(f"unsafe runtime lane or action: {name}")
    else:
        raise SystemExit(f"unsafe operation kind: {item.get('kind')!r}")
    identity = (item["kind"], name)
    if identity in seen_operations:
        raise SystemExit(f"duplicate receipt operation: {identity}")
    seen_operations.add(identity)
    validated_operations.append((index, operation_target, operation_backup, item["existed_before"]))
expected_operations = (
    {("package", name) for name in package_denominator}
    | {("runtime-file", name) for name in runtime_denominator}
)
if seen_operations != expected_operations:
    raise SystemExit("receipt operation set is incomplete")
if receipt["status"] == "installed" and receipt["backup_complete"] is not True:
    raise SystemExit("installed receipt must attest a complete backup")

if receipt["status"] == "rolled_back":
    for item in operations:
        operation_target = Path(item["target"])
        operation_backup = Path(item["backup"])
        if lexists(operation_backup):
            raise SystemExit(f"rolled-back receipt retained an operation backup: {item['name']}")
        if item["existed_before"]:
            if not lexists(operation_target):
                raise SystemExit(f"rolled-back original target is missing: {item['name']}")
            if governed_digest(operation_target, operation_target.parent) != item["backup_digest"]:
                raise SystemExit(f"rolled-back original target digest mismatch: {item['name']}")
        elif lexists(operation_target):
            raise SystemExit(f"rolled-back new target still exists: {item['name']}")
    print(target)
    print(home)
    print(backup)
    print("already-rolled-back")
    raise SystemExit(0)

for item in operations:
    operation_target = Path(item["target"])
    operation_backup = Path(item["backup"])
    if item["existed_before"]:
        if lexists(operation_backup):
            if governed_digest(operation_backup, operation_target.parent) != item["backup_digest"]:
                raise SystemExit(f"required rollback backup digest mismatch: {item['name']}")
        elif receipt["backup_complete"] or receipt["status"] == "installed":
            raise SystemExit(f"required rollback backup is missing: {item['name']}")
        elif not lexists(operation_target) or governed_digest(operation_target, operation_target.parent) != item["backup_digest"]:
            raise SystemExit(f"pre-backup original state is missing or changed: {item['name']}")
    elif lexists(operation_backup):
        raise SystemExit(f"unexpected rollback backup for new target: {item['name']}")

if receipt["status"] == "installed":
    for item in operations:
        operation_target = Path(item["target"])
        if item["action"] == "replace":
            if not lexists(operation_target):
                raise SystemExit(f"installed replacement target is missing: {item['name']}")
            if governed_digest(operation_target, operation_target.parent) != item["installed_digest"]:
                raise SystemExit(f"installed replacement target digest mismatch: {item['name']}")
        elif lexists(operation_target):
            raise SystemExit(f"installed deletion target was recreated: {item['name']}")
print(target)
print(home)
print(backup)
print("apply")
for index, operation_target, operation_backup, existed_before in validated_operations:
    print(
        f"{index}\t{operation_target}\t{operation_backup}\t"
        f"{'true' if existed_before else 'false'}"
    )
PY
then
  exit 1
fi
readarray -t receipt_data <"$validation_file"

backup_root="${receipt_data[2]}"
rollback_mode="${receipt_data[3]}"
if [[ "${receipt_data[1]}" != "$lexical_lock_home" ]]; then
  echo "rollback receipt home changed after lock acquisition" >&2
  exit 1
fi
if [[ "$rollback_mode" == already-rolled-back ]]; then
  echo "Governed Codex runtime sync was already rolled back from $receipt_file"
  exit 0
fi
if [[ "$rollback_mode" != apply ]]; then
  echo "Invalid governed rollback mode: $rollback_mode" >&2
  exit 1
fi
displaced_root="$backup_root/.rollback-displaced"
if [[ -e "$displaced_root" ]]; then
  echo "Rollback displacement already exists: $displaced_root" >&2
  exit 1
fi
mkdir -p "$displaced_root"

for ((position=${#receipt_data[@]} - 1; position >= 4; position--)); do
  IFS=$'\t' read -r index target backup existed <<<"${receipt_data[$position]}"
  displaced="$displaced_root/$index-$(basename "$target")"
  if [[ "$existed" == true ]]; then
    if [[ -e "$backup" || -L "$backup" ]]; then
      if [[ -e "$target" || -L "$target" ]]; then
        mv -- "$target" "$displaced"
      fi
      mkdir -p "$(dirname "$target")"
      mv -- "$backup" "$target"
    fi
  elif [[ -e "$target" || -L "$target" ]]; then
    mv -- "$target" "$displaced"
  fi
done

python3 - "$receipt_file" <<'PY'
import json
import os
import sys
from pathlib import Path
path = Path(sys.argv[1])
receipt = json.loads(path.read_text())
receipt["status"] = "rolled_back"
temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
temporary.write_text(json.dumps(receipt, indent=2) + "\n")
os.replace(temporary, path)
PY

echo "Rolled back governed Codex runtime sync from $receipt_file"
