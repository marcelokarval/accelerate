#!/usr/bin/env python3
"""Atomically install rendered logical Codex profiles with a rollback receipt."""

from __future__ import annotations

import argparse
import atexit
import fcntl
import hashlib
import json
import os
import re
import shutil
import stat
import subprocess
import tempfile
import tomllib
from datetime import UTC, datetime
from pathlib import Path


PRIVATE_FILE_MODE = 0o600
PRIVATE_DIRECTORY_MODE = 0o700
RUNTIME_MUTATION_LOCK = ".codex-runtime-mutation.lock"
INHERITED_LOCK_FD_ENV = "CODEX_RUNTIME_MUTATION_LOCK_FD"
INHERITED_LOCK_HOME_ENV = "CODEX_RUNTIME_MUTATION_LOCK_HOME"
LOGICAL_RECEIPT_NAME = "logical-agent-install-receipt.json"
LOGICAL_RECEIPT_KEYS = {
    "schema_version",
    "install_identity",
    "installed_at",
    "topology_sha256",
    "catalog_sha256",
    "installed",
    "retired_profiles",
    "rollback_directory",
}
LOGICAL_INSTALLED_KEYS = {"agent", "target", "backup", "sha256", "provenance"}
LOGICAL_RETIRED_KEYS = {"agent", "target", "backup"}


def write_private_text(path: Path, text: str) -> None:
    path.write_text(text)
    os.chmod(path, PRIVATE_FILE_MODE)


def ensure_private_directory(path: Path) -> None:
    parent = path.parent
    if not os.path.lexists(parent):
        parent.mkdir(mode=PRIVATE_DIRECTORY_MODE)
    parent_metadata = parent.lstat()
    if (
        not stat.S_ISDIR(parent_metadata.st_mode)
        or parent.is_symlink()
        or parent_metadata.st_uid != os.geteuid()
    ):
        raise SystemExit(f"logical installer backup parent is not a safe owned directory: {parent}")
    os.chmod(parent, PRIVATE_DIRECTORY_MODE)
    if not os.path.lexists(path):
        path.mkdir(mode=PRIVATE_DIRECTORY_MODE)
    metadata = path.lstat()
    if not stat.S_ISDIR(metadata.st_mode) or path.is_symlink() or metadata.st_uid != os.geteuid():
        raise SystemExit(f"logical installer backup path is not a safe owned directory: {path}")
    os.chmod(path, PRIVATE_DIRECTORY_MODE)


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def exact_private_file(path: Path, expected: Path) -> bool:
    try:
        metadata = path.lstat()
    except OSError:
        return False
    return (
        stat.S_ISREG(metadata.st_mode)
        and metadata.st_nlink == 1
        and stat.S_IMODE(metadata.st_mode) == PRIVATE_FILE_MODE
        and path.read_bytes() == expected.read_bytes()
    )


def preflight_owned_file_target(
    path: Path,
    *,
    required: bool,
    label: str,
    required_mode: int | None = None,
) -> None:
    """Require an absent or exact regular, non-symlink, single-link owned target."""
    if not os.path.lexists(path):
        if required:
            raise SystemExit(f"{label} is missing: {path}")
        return
    metadata = path.lstat()
    if (
        not stat.S_ISREG(metadata.st_mode)
        or path.is_symlink()
        or metadata.st_nlink != 1
        or metadata.st_uid != os.geteuid()
        or (required_mode is not None and stat.S_IMODE(metadata.st_mode) != required_mode)
    ):
        raise SystemExit(f"{label} is not an exact owned regular file: {path}")


def validate_receipt_history(receipt: dict[str, object], home: Path) -> None:
    """Fail closed when a v2 receipt's rollback history is not repo-governed."""
    backups_root = home / "backups"
    rollback_raw = receipt.get("rollback_directory")
    collections = (receipt.get("installed"), receipt.get("retired_profiles"))
    backup_records: list[tuple[Path, Path]] = []
    for collection in collections:
        if not isinstance(collection, list):
            raise SystemExit("logical installer receipt history collection is invalid")
        for entry in collection:
            if not isinstance(entry, dict):
                raise SystemExit("logical installer receipt history entry is invalid")
            backup = entry.get("backup")
            if backup is None:
                continue
            if not isinstance(backup, str):
                raise SystemExit("logical installer receipt backup path is invalid")
            target = entry.get("target")
            if not isinstance(target, str):
                raise SystemExit("logical installer receipt backup lacks its governed target")
            backup_records.append((Path(backup), Path(target)))
    if not backup_records:
        if rollback_raw is not None:
            raise SystemExit("logical installer receipt has rollback directory without backup history")
        return
    if not isinstance(rollback_raw, str):
        raise SystemExit("logical installer receipt backup history lacks rollback directory")
    rollback_directory = Path(rollback_raw)
    if not rollback_directory.is_absolute() or rollback_directory != Path(os.path.normpath(rollback_raw)):
        raise SystemExit("logical installer receipt rollback directory is not canonical")
    try:
        backups_metadata = backups_root.lstat()
        rollback_metadata = rollback_directory.lstat()
        backups_resolved = backups_root.resolve(strict=True)
        rollback_resolved = rollback_directory.resolve(strict=True)
        rollback_resolved.relative_to(backups_resolved)
    except (OSError, ValueError):
        raise SystemExit("logical installer receipt rollback directory escapes CODEX_HOME backups") from None
    if (
        backups_root.is_symlink()
        or not stat.S_ISDIR(backups_metadata.st_mode)
        or backups_metadata.st_uid != os.geteuid()
        or stat.S_IMODE(backups_metadata.st_mode) != PRIVATE_DIRECTORY_MODE
        or rollback_directory.is_symlink()
        or not stat.S_ISDIR(rollback_metadata.st_mode)
        or rollback_metadata.st_uid != os.geteuid()
        or stat.S_IMODE(rollback_metadata.st_mode) != PRIVATE_DIRECTORY_MODE
        or rollback_directory != rollback_resolved
        or rollback_directory.parent != backups_root
    ):
        raise SystemExit("logical installer receipt rollback directory is not an exact owned backup child")
    seen_backups: set[Path] = set()
    for backup, target in backup_records:
        if not backup.is_absolute() or backup != Path(os.path.normpath(str(backup))):
            raise SystemExit("logical installer receipt backup path is not canonical")
        if not target.is_absolute() or target.parent != home:
            raise SystemExit("logical installer receipt backup target escapes Codex home")
        try:
            metadata = backup.lstat()
            resolved = backup.resolve(strict=True)
            backup.read_bytes()
        except OSError:
            raise SystemExit(f"logical installer receipt backup is unavailable: {backup}") from None
        if (
            backup.is_symlink()
            or not stat.S_ISREG(metadata.st_mode)
            or metadata.st_nlink != 1
            or metadata.st_uid != os.geteuid()
            or stat.S_IMODE(metadata.st_mode) != PRIVATE_FILE_MODE
            or backup != resolved
            or backup.parent != rollback_directory
            or backup.name != target.name
            or backup in seen_backups
        ):
            raise SystemExit(f"logical installer receipt backup does not identify its exact private target history: {backup}")
        seen_backups.add(backup)


def exact_current_receipt(
    receipt_path: Path,
    home: Path,
    topology_path: Path,
    catalog_path: Path,
    expected_installed: list[dict[str, str]],
) -> bool:
    """Return true only for an exact, current v2 ownership receipt.

    The catalog checker has already applied the authoritative schema, target,
    containment, and provenance validation. This predicate adds current-input,
    byte, mode, ownership-set, and canonical rollback-history checks before the
    installer elects not to mutate any governed target.
    """
    try:
        metadata = receipt_path.lstat()
        if (
            not stat.S_ISREG(metadata.st_mode)
            or metadata.st_nlink != 1
            or stat.S_IMODE(metadata.st_mode) != PRIVATE_FILE_MODE
        ):
            return False
        receipt = json.loads(receipt_path.read_text())
    except (OSError, json.JSONDecodeError):
        return False
    if not isinstance(receipt, dict) or set(receipt) != LOGICAL_RECEIPT_KEYS:
        return False
    if (
        receipt.get("schema_version") != 2
        or receipt.get("install_identity") != "codex-logical-agent-profiles"
        or receipt.get("topology_sha256") != file_sha256(topology_path)
        or receipt.get("catalog_sha256") != file_sha256(catalog_path)
    ):
        return False
    installed_at = receipt.get("installed_at")
    if not isinstance(installed_at, str):
        return False
    try:
        if datetime.fromisoformat(installed_at).tzinfo is None:
            return False
    except ValueError:
        return False

    installed = receipt.get("installed")
    if not isinstance(installed, list) or len(installed) != len(expected_installed):
        return False
    rollback_raw = receipt.get("rollback_directory")
    rollback_directory = Path(rollback_raw) if isinstance(rollback_raw, str) else None
    validate_receipt_history(receipt, home)
    backup_paths: list[Path] = []
    for actual, expected in zip(installed, expected_installed, strict=True):
        if not isinstance(actual, dict) or set(actual) != LOGICAL_INSTALLED_KEYS:
            return False
        if any(actual.get(key) != expected[key] for key in ("agent", "target", "sha256", "provenance")):
            return False
        backup = actual.get("backup")
        if backup is not None:
            if not isinstance(backup, str):
                return False
            backup_paths.append(Path(backup))

    retired = receipt.get("retired_profiles")
    if not isinstance(retired, list) or len(retired) > 1:
        return False
    for entry in retired:
        if not isinstance(entry, dict) or set(entry) != LOGICAL_RETIRED_KEYS:
            return False
        if entry.get("agent") != "orchestrator" or entry.get("target") != str(home / "orchestrator.config.toml"):
            return False
        backup = entry.get("backup")
        if not isinstance(backup, str):
            return False
        backup_paths.append(Path(backup))

    if backup_paths:
        if rollback_directory is None:
            return False
        try:
            rollback_metadata = rollback_directory.lstat()
        except OSError:
            return False
        if not stat.S_ISDIR(rollback_metadata.st_mode) or stat.S_IMODE(rollback_metadata.st_mode) != PRIVATE_DIRECTORY_MODE:
            return False
        for backup in backup_paths:
            try:
                backup_metadata = backup.lstat()
            except OSError:
                return False
            if (
                backup.parent != rollback_directory
                or not stat.S_ISREG(backup_metadata.st_mode)
                or backup_metadata.st_nlink != 1
            ):
                return False
    elif rollback_raw is not None:
        return False
    return True


def acquire_runtime_mutation_lock(home: Path) -> int:
    """Acquire the shared advisory lock used by cooperative Codex mutators."""
    lock_path = home / RUNTIME_MUTATION_LOCK
    inherited = os.environ.get(INHERITED_LOCK_FD_ENV)
    if inherited is not None:
        if not inherited.isdecimal():
            raise SystemExit("runtime mutation inherited lock descriptor is invalid")
        inherited_home_raw = os.environ.get(INHERITED_LOCK_HOME_ENV)
        if inherited_home_raw is None:
            raise SystemExit("runtime mutation inherited lock home is missing")
        inherited_home = Path(inherited_home_raw).resolve()
        allowed_stage = (
            home.parent == inherited_home
            and re.fullmatch(r"\.accelerate-sync-runtime\.[A-Za-z0-9]+", home.name) is not None
        )
        if home != inherited_home and not allowed_stage:
            raise SystemExit(f"runtime mutation inherited lock does not govern target home: {home}")
        lock_path = inherited_home / RUNTIME_MUTATION_LOCK
        descriptor = int(inherited)
        try:
            opened = os.fstat(descriptor)
            lexical = os.lstat(lock_path)
        except OSError as error:
            raise SystemExit(f"runtime mutation inherited lock cannot be verified: {lock_path}: {error}") from None
        if (
            not stat.S_ISREG(opened.st_mode)
            or not stat.S_ISREG(lexical.st_mode)
            or opened.st_nlink != 1
            or lexical.st_nlink != 1
            or (opened.st_dev, opened.st_ino) != (lexical.st_dev, lexical.st_ino)
        ):
            raise SystemExit(f"runtime mutation inherited lock is not exact: {lock_path}")
        try:
            # Verify/acquire on the inherited open-file-description itself.
            # Contention observed through a separately opened descriptor does
            # not identify which description owns the lock.
            fcntl.flock(descriptor, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise SystemExit(f"runtime mutation inherited lock does not hold an exclusive flock: {lock_path}") from None
        return descriptor
    flags = os.O_RDWR | os.O_CREAT | os.O_CLOEXEC | getattr(os, "O_NOFOLLOW", 0)
    try:
        descriptor = os.open(lock_path, flags, PRIVATE_FILE_MODE)
    except OSError as error:
        raise SystemExit(f"runtime mutation lock is not a safe regular file: {lock_path}: {error}") from None
    try:
        opened = os.fstat(descriptor)
        lexical = os.lstat(lock_path)
        if (
            not stat.S_ISREG(opened.st_mode)
            or not stat.S_ISREG(lexical.st_mode)
            or opened.st_nlink != 1
            or lexical.st_nlink != 1
            or (opened.st_dev, opened.st_ino) != (lexical.st_dev, lexical.st_ino)
        ):
            raise SystemExit(f"runtime mutation lock is not an exact regular file: {lock_path}")
        try:
            fcntl.flock(descriptor, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise SystemExit(f"runtime mutation is already locked: {lock_path}") from None
        os.fchmod(descriptor, PRIVATE_FILE_MODE)
    except BaseException:
        os.close(descriptor)
        raise
    # flock is cooperative/advisory: it serializes these governed mutators but
    # cannot prevent a non-cooperating process from writing files directly.
    atexit.register(os.close, descriptor)
    return descriptor


parser = argparse.ArgumentParser()
parser.add_argument("topology", type=Path)
parser.add_argument("catalog", type=Path)
parser.add_argument("--codex-home", type=Path, required=True)
args = parser.parse_args()


def managed_catalog_states(catalog: dict[str, object]) -> dict[str, bool]:
    sources = {str(source["id"]): source for source in catalog["sources"]}
    states: dict[str, bool] = {}
    for group in catalog["groups"]:
        if group["classification"] == "host-injected":
            continue
        source = sources[str(group["source"])]
        prefix = [str(source["base_path"])]
        if group.get("path_prefix"):
            prefix.append(str(group["path_prefix"]))
        for skill_id in group["skill_ids"]:
            path = "/".join([*prefix, str(skill_id), "SKILL.md"])
            if path in states:
                raise SystemExit(f"catalog has duplicate managed path: {path}")
            states[path] = bool(group["enabled_by_default"])
    return states


def effective_states(base_document: dict[str, object], managed_paths: set[str]) -> dict[str, bool]:
    states: dict[str, bool] = {}
    for entry in base_document.get("skills", {}).get("config", []):
        if not isinstance(entry, dict) or "path" not in entry or "enabled" not in entry:
            continue
        path = str(entry["path"])
        if path not in managed_paths:
            continue
        enabled = bool(entry["enabled"])
        if path in states and states[path] != enabled:
            raise SystemExit(f"global catalog has conflicting entries: {path}")
        states[path] = enabled
    return states


def root_config_with_orchestrator_defaults(text: str, orchestrator: dict[str, object]) -> str:
    """Replace only root model settings while preserving unrelated user config."""
    desired = {
        "model": str(orchestrator["model"]),
        "model_reasoning_effort": str(orchestrator["reasoning_effort"]),
    }
    lines = text.splitlines(keepends=True)
    root_scope = True
    seen: set[str] = set()
    for index, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("[") and stripped.endswith("]"):
            root_scope = False
        if not root_scope or "=" not in line:
            continue
        key = line.split("=", 1)[0].strip()
        if key in desired:
            lines[index] = f'{key} = "{desired[key]}"\n'
            seen.add(key)
    missing = [key for key in desired if key not in seen]
    if missing:
        insertion = next((index for index, line in enumerate(lines) if line.strip().startswith("[")), len(lines))
        lines[insertion:insertion] = [f'{key} = "{desired[key]}"\n' for key in missing]
    return "".join(lines)


topology = tomllib.loads(args.topology.read_text())
orchestrator = next(agent for agent in topology["agents"] if agent["kind"] == "root-orchestrator")
home = args.codex_home.resolve()
home.mkdir(parents=True, exist_ok=True)
mutation_lock_descriptor = acquire_runtime_mutation_lock(home)
timestamp = datetime.now(UTC).strftime("%Y%m%dT%H%M%S.%fZ") + f"-{os.getpid()}"
backup_dir = home / "backups" / f"logical-agents-{timestamp}"
renderer = Path(__file__).with_name("render-codex-logical-agent.py")
catalog_renderer = Path(__file__).with_name("render-codex-skill-profile.py")
catalog_checker = Path(__file__).with_name("check-codex-skill-catalog-install.py")
validator = Path(__file__).with_name("validate-codex-logical-agent-topology.py")
source_root = Path(__file__).resolve().parents[1]
policy = source_root / "adapters/runtime/codex-collaboration/role-policy.json"
receipt_path = home / LOGICAL_RECEIPT_NAME
preflight_owned_file_target(
    receipt_path,
    required=False,
    label="logical installer receipt target",
    required_mode=PRIVATE_FILE_MODE,
)
base_config = home / "config.toml"
preflight_owned_file_target(base_config, required=True, label="global catalog base")
stale_orchestrator_profile = home / "orchestrator.config.toml"
preflight_owned_file_target(stale_orchestrator_profile, required=False, label="legacy orchestrator profile")
for agent in topology["agents"]:
    if agent["kind"] == "specialist":
        preflight_owned_file_target(
            home / f"{agent['name']}.config.toml",
            required=False,
            label=f"logical profile {agent['name']}",
        )
installed: list[dict[str, str | None]] = []
retired_profiles: list[dict[str, str]] = []

with tempfile.TemporaryDirectory(prefix="codex-logical-agents-", dir=home) as temporary:
    temporary_dir = Path(temporary)
    subprocess.run(
        ["python3", str(validator), str(args.topology), str(args.catalog), str(policy)],
        check=True,
    )
    subprocess.run(
        [
            "python3", str(catalog_checker), str(args.catalog),
            "--codex-home", str(home),
            "--logical-topology", str(args.topology),
        ],
        check=True,
    )
    expected_base = temporary_dir / "global-catalog.config.toml"
    subprocess.run(
        ["python3", str(catalog_renderer), str(args.catalog), "--mode", "global", "--output", str(expected_base)],
        check=True,
    )
    catalog = tomllib.loads(args.catalog.read_text())
    expected_states = managed_catalog_states(catalog)
    actual_states = effective_states(tomllib.loads(base_config.read_text()), set(expected_states))
    if any(actual_states.get(path, True) != expected for path, expected in expected_states.items()):
        raise SystemExit(f"global catalog base is stale or incomplete: {base_config}")
    staged: list[tuple[str, Path, Path]] = []
    for agent in topology["agents"]:
        if agent["kind"] != "specialist":
            continue
        name = str(agent["name"])
        target = home / f"{name}.config.toml"
        generated = temporary_dir / target.name
        subprocess.run(
            ["python3", str(renderer), str(args.topology), str(args.catalog), "--agent", name, "--output", str(generated)],
            check=True,
        )
        tomllib.loads(generated.read_text())
        os.chmod(generated, PRIVATE_FILE_MODE)
        staged.append((name, target, generated))

    staged_base = temporary_dir / "config.toml"
    rendered_base = root_config_with_orchestrator_defaults(base_config.read_text(), orchestrator)
    tomllib.loads(rendered_base)
    write_private_text(staged_base, rendered_base)
    expected_installed = [
        {
            "agent": "orchestrator",
            "target": str(base_config),
            "sha256": file_sha256(staged_base),
            "provenance": "logical-orchestrator-defaults",
        },
        *(
            {
                "agent": name,
                "target": str(target),
                "sha256": file_sha256(generated),
                "provenance": "logical-agent-render",
            }
            for name, target, generated in staged
        ),
    ]
    exact_targets = exact_private_file(base_config, staged_base) and all(
        exact_private_file(target, generated) for _, target, generated in staged
    )
    if (
        exact_targets
        and not os.path.lexists(stale_orchestrator_profile)
        and exact_current_receipt(receipt_path, home, args.topology, args.catalog, expected_installed)
    ):
        print(receipt_path)
        raise SystemExit(0)
    replaced: list[tuple[Path, Path | None]] = []
    staged_receipt: Path | None = None
    try:
        base_backup: Path | None = None
        if (
            base_config.read_bytes() != staged_base.read_bytes()
            or stat.S_IMODE(base_config.stat().st_mode) != PRIVATE_FILE_MODE
        ):
            ensure_private_directory(backup_dir)
            base_backup = backup_dir / base_config.name
            shutil.copy2(base_config, base_backup)
            os.chmod(base_backup, PRIVATE_FILE_MODE)
            os.replace(staged_base, base_config)
            replaced.append((base_config, base_backup))
        installed.append(
            {
                "agent": "orchestrator",
                "target": str(base_config),
                "backup": str(base_backup) if base_backup else None,
                "sha256": hashlib.sha256(base_config.read_bytes()).hexdigest(),
                "provenance": "logical-orchestrator-defaults",
            }
        )
        if stale_orchestrator_profile.exists():
            ensure_private_directory(backup_dir)
            profile_backup = backup_dir / stale_orchestrator_profile.name
            shutil.copy2(stale_orchestrator_profile, profile_backup)
            os.chmod(profile_backup, PRIVATE_FILE_MODE)
            stale_orchestrator_profile.unlink()
            replaced.append((stale_orchestrator_profile, profile_backup))
            retired_profiles.append(
                {
                    "agent": "orchestrator",
                    "target": str(stale_orchestrator_profile),
                    "backup": str(profile_backup),
                }
            )
        for name, target, generated in staged:
            backup: Path | None = None
            if target.exists():
                ensure_private_directory(backup_dir)
                backup = backup_dir / target.name
                shutil.copy2(target, backup)
                os.chmod(backup, PRIVATE_FILE_MODE)
            os.replace(generated, target)
            replaced.append((target, backup))
            installed.append(
                {
                    "agent": name,
                    "target": str(target),
                    "backup": str(backup) if backup else None,
                    "sha256": hashlib.sha256(target.read_bytes()).hexdigest(),
                    "provenance": "logical-agent-render",
                }
            )
        receipt = {
            "schema_version": 2,
            "install_identity": "codex-logical-agent-profiles",
            "installed_at": datetime.now(UTC).isoformat(),
            "topology_sha256": hashlib.sha256(args.topology.read_bytes()).hexdigest(),
            "catalog_sha256": hashlib.sha256(args.catalog.read_bytes()).hexdigest(),
            "installed": installed,
            "retired_profiles": retired_profiles,
            "rollback_directory": str(backup_dir) if backup_dir.exists() else None,
        }
        staged_receipt = home / f".{receipt_path.name}.{timestamp}.tmp"
        preflight_owned_file_target(staged_receipt, required=False, label="logical installer staged receipt")
        write_private_text(staged_receipt, json.dumps(receipt, indent=2, sort_keys=True) + "\n")
        os.replace(staged_receipt, receipt_path)
        staged_receipt = None
    except BaseException:
        if staged_receipt is not None:
            staged_receipt.unlink(missing_ok=True)
        for target, backup in reversed(replaced):
            if backup is None:
                target.unlink(missing_ok=True)
            else:
                shutil.copy2(backup, target)
        if backup_dir.exists() and not backup_dir.is_symlink():
            shutil.rmtree(backup_dir)
        raise
print(receipt_path)
