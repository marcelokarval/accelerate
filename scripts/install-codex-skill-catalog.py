#!/usr/bin/env python3
"""Reconcile the managed Codex skill config and catalog profiles atomically."""

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
from dataclasses import dataclass
from datetime import UTC, datetime
from pathlib import Path
from typing import Any


SOURCE_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_LOGICAL_TOPOLOGY = SOURCE_ROOT / "adapters/runtime/codex/logical-agent-topology.toml"
CATALOG_RECEIPT_NAME = "skill-catalog-install-receipt.json"
LOGICAL_RECEIPT_NAME = "logical-agent-install-receipt.json"
PROFILE_NAME = re.compile(r"[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
SHA256 = re.compile(r"[0-9a-f]{64}")
CATALOG_RECEIPT_KEYS = {
    "schema_version",
    "install_identity",
    "installed_at",
    "catalog_sha256",
    "logical_topology_sha256",
    "installed",
    "preserved_logical_profiles",
    "retired_profiles",
    "profile_ownership",
    "rollback_directory",
}
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
OWNERSHIP_KEYS = {"profile", "target", "owner", "sha256", "provenance"}
INSTALLED_KEYS = {"profile", "target", "backup"}
LOGICAL_INSTALLED_KEYS = {"agent", "target", "backup", "sha256", "provenance"}
LOGICAL_RETIRED_KEYS = {"agent", "target", "backup"}
RETIRED_KEYS = {"profile", "target", "backup", "previous_owner", "sha256"}
PRIVATE_FILE_MODE = 0o600
PRIVATE_DIRECTORY_MODE = 0o700
RUNTIME_MUTATION_LOCK = ".codex-runtime-mutation.lock"
INHERITED_LOCK_FD_ENV = "CODEX_RUNTIME_MUTATION_LOCK_FD"
INHERITED_LOCK_HOME_ENV = "CODEX_RUNTIME_MUTATION_LOCK_HOME"


@dataclass(frozen=True)
class OwnershipEvidence:
    owner: str
    source: str
    sha256: str | None = None


def fail(message: str) -> None:
    raise SystemExit(f"catalog profile ownership invalid: {message}")


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


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
        fail(f"backup parent is not a safe owned directory: {parent}")
    os.chmod(parent, PRIVATE_DIRECTORY_MODE)
    if not os.path.lexists(path):
        path.mkdir(mode=PRIVATE_DIRECTORY_MODE)
    metadata = path.lstat()
    if not stat.S_ISDIR(metadata.st_mode) or path.is_symlink() or metadata.st_uid != os.geteuid():
        fail(f"backup path is not a safe owned directory: {path}")
    os.chmod(path, PRIVATE_DIRECTORY_MODE)


def is_exact_private_file(target: Path, expected: Path) -> bool:
    return (
        target.is_file()
        and not target.is_symlink()
        and stat.S_IMODE(target.stat().st_mode) == PRIVATE_FILE_MODE
        and target.read_bytes() == expected.read_bytes()
    )


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
            # flock is attached to an open-file-description. Re-locking the
            # inherited description is idempotent when it already owns LOCK_EX,
            # acquires it when currently free, and rejects when another
            # description owns the lock. A third path-open cannot prove which
            # description owns the contention.
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


def exact_keys(value: Any, keys: set[str], label: str) -> dict[str, Any]:
    if not isinstance(value, dict) or set(value) != keys:
        fail(f"{label} must contain exactly {sorted(keys)}")
    return value


def receipt_time(value: Any, label: str) -> datetime:
    if not isinstance(value, str):
        fail(f"{label} must be a timezone-aware ISO timestamp")
    try:
        parsed = datetime.fromisoformat(value)
    except ValueError:
        fail(f"{label} must be a timezone-aware ISO timestamp")
    if parsed.tzinfo is None:
        fail(f"{label} must include a timezone")
    return parsed.astimezone(UTC)


def require_sha256(value: Any, label: str) -> str:
    if not isinstance(value, str) or SHA256.fullmatch(value) is None:
        fail(f"{label} must be a lowercase SHA-256 digest")
    return value


def require_profile(value: Any, label: str) -> str:
    if not isinstance(value, str) or PROFILE_NAME.fullmatch(value) is None:
        fail(f"{label} must be a bounded profile name")
    return value


def exact_target(value: Any, home: Path, profile: str, *, global_target: bool = False) -> Path:
    expected = home / ("config.toml" if global_target else f"{profile}.config.toml")
    if not isinstance(value, str) or value != str(expected):
        fail(f"receipt target for {profile} must equal {expected}")
    candidate = Path(value)
    if not candidate.is_absolute() or candidate.parent != home:
        fail(f"receipt target for {profile} escapes Codex home")
    return candidate


def contained_backup(
    value: Any,
    home: Path,
    target: Path,
    rollback_directory: Path | None,
    label: str,
) -> str | None:
    if value is None:
        return None
    if rollback_directory is None:
        fail(f"{label} exists without a declared rollback directory")
    if not isinstance(value, str):
        fail(f"{label} must be null or an absolute backup path")
    candidate = Path(value)
    backups = home / "backups"
    try:
        backups_metadata = backups.lstat()
        parent_metadata = candidate.parent.lstat()
        metadata = candidate.lstat()
        backups_resolved = backups.resolve(strict=True)
        parent_resolved = candidate.parent.resolve(strict=True)
        resolved = candidate.resolve(strict=True)
        resolved.relative_to(backups_resolved)
        candidate.read_bytes()
    except (OSError, ValueError):
        fail(f"{label} escapes {backups}")
    if (
        not candidate.is_absolute()
        or candidate != resolved
        or candidate.is_symlink()
        or not stat.S_ISREG(metadata.st_mode)
        or metadata.st_nlink != 1
        or metadata.st_uid != os.geteuid()
        or stat.S_IMODE(metadata.st_mode) != PRIVATE_FILE_MODE
        or backups.is_symlink()
        or not stat.S_ISDIR(backups_metadata.st_mode)
        or backups_metadata.st_uid != os.geteuid()
        or stat.S_IMODE(backups_metadata.st_mode) != PRIVATE_DIRECTORY_MODE
        or candidate.parent.is_symlink()
        or not stat.S_ISDIR(parent_metadata.st_mode)
        or parent_metadata.st_uid != os.geteuid()
        or stat.S_IMODE(parent_metadata.st_mode) != PRIVATE_DIRECTORY_MODE
        or candidate.parent != parent_resolved
        or candidate.parent.parent != backups
        or candidate.parent != rollback_directory
        or candidate.name != target.name
    ):
        fail(f"{label} does not identify the target backup")
    return value


def contained_rollback(value: Any, home: Path, label: str) -> Path | None:
    if value is None:
        return None
    if not isinstance(value, str):
        fail(f"{label} must be null or an absolute directory")
    candidate = Path(value)
    try:
        backups = home / "backups"
        backups_metadata = backups.lstat()
        metadata = candidate.lstat()
        backups_resolved = backups.resolve(strict=True)
        resolved = candidate.resolve(strict=True)
        resolved.relative_to(backups_resolved)
    except (OSError, ValueError):
        fail(f"{label} escapes {home / 'backups'}")
    if (
        not candidate.is_absolute()
        or candidate != resolved
        or candidate.parent != backups
        or candidate.is_symlink()
        or not stat.S_ISDIR(metadata.st_mode)
        or metadata.st_uid != os.geteuid()
        or stat.S_IMODE(metadata.st_mode) != PRIVATE_DIRECTORY_MODE
        or backups.is_symlink()
        or not stat.S_ISDIR(backups_metadata.st_mode)
        or backups_metadata.st_uid != os.geteuid()
        or stat.S_IMODE(backups_metadata.st_mode) != PRIVATE_DIRECTORY_MODE
    ):
        fail(f"{label} must be an exact owned private backup child")
    return candidate


def read_receipt(path: Path, label: str) -> dict[str, Any] | None:
    if not os.path.lexists(path):
        return None
    metadata = path.lstat()
    if (
        path.is_symlink()
        or not stat.S_ISREG(metadata.st_mode)
        or metadata.st_nlink != 1
        or metadata.st_uid != os.geteuid()
        or stat.S_IMODE(metadata.st_mode) != PRIVATE_FILE_MODE
    ):
        fail(f"{label} must be an exact owned private regular file: {path}")
    try:
        receipt = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        fail(f"{label} cannot be read as JSON: {error}")
    if not isinstance(receipt, dict):
        fail(f"{label} root must be an object")
    return receipt


def load_catalog_evidence(path: Path, home: Path) -> dict[str, OwnershipEvidence]:
    receipt = read_receipt(path, "catalog receipt")
    if receipt is None:
        return {}
    # Schema 1 predates explicit owner and content digests. It remains a
    # migration artifact, but must never authorize deletion or preservation.
    if receipt.get("schema_version") == 1:
        if receipt.get("install_identity") != "codex-skill-catalog":
            fail("legacy catalog receipt identity is invalid")
        return {}
    exact_keys(receipt, CATALOG_RECEIPT_KEYS, "catalog receipt")
    if receipt["schema_version"] != 2 or receipt["install_identity"] != "codex-skill-catalog":
        fail("catalog receipt identity or schema is invalid")
    receipt_time(receipt["installed_at"], "catalog receipt installed_at")
    require_sha256(receipt["catalog_sha256"], "catalog receipt catalog_sha256")
    require_sha256(receipt["logical_topology_sha256"], "catalog receipt logical_topology_sha256")
    rollback_directory = contained_rollback(
        receipt["rollback_directory"], home, "catalog receipt rollback_directory"
    )

    installed = receipt["installed"]
    if not isinstance(installed, list):
        fail("catalog receipt installed must be a list")
    installed_targets: set[Path] = set()
    installed_profiles: set[str] = set()
    backup_count = 0
    for index, raw in enumerate(installed):
        entry = exact_keys(raw, INSTALLED_KEYS, f"catalog receipt installed[{index}]")
        profile = entry["profile"]
        if profile == "global":
            target = exact_target(entry["target"], home, "global", global_target=True)
        else:
            profile = require_profile(profile, f"catalog receipt installed[{index}].profile")
            target = exact_target(entry["target"], home, profile)
        if contained_backup(
            entry["backup"], home, target, rollback_directory,
            f"catalog receipt installed[{index}].backup",
        ) is not None:
            backup_count += 1
        if target in installed_targets:
            fail("catalog receipt installed targets are duplicated")
        if profile in installed_profiles:
            fail("catalog receipt installed profiles are duplicated")
        installed_targets.add(target)
        installed_profiles.add(profile)

    preserved = receipt["preserved_logical_profiles"]
    if not isinstance(preserved, list) or any(not isinstance(item, str) for item in preserved):
        fail("catalog receipt preserved_logical_profiles must be a string list")
    if len(preserved) != len(set(preserved)):
        fail("catalog receipt preserved logical profiles are duplicated")
    for index, profile in enumerate(preserved):
        require_profile(profile, f"catalog receipt preserved_logical_profiles[{index}]")

    retired = receipt["retired_profiles"]
    if not isinstance(retired, list):
        fail("catalog receipt retired_profiles must be a list")
    retired_profiles: set[str] = set()
    for index, raw in enumerate(retired):
        entry = exact_keys(raw, RETIRED_KEYS, f"catalog receipt retired_profiles[{index}]")
        profile = require_profile(entry["profile"], f"catalog receipt retired_profiles[{index}].profile")
        target = exact_target(entry["target"], home, profile)
        if contained_backup(
            entry["backup"], home, target, rollback_directory,
            f"catalog receipt retired_profiles[{index}].backup",
        ) is not None:
            backup_count += 1
        if entry["previous_owner"] != "catalog":
            fail("catalog receipt may retire only catalog-owned profiles")
        require_sha256(entry["sha256"], f"catalog receipt retired_profiles[{index}].sha256")
        if profile in retired_profiles:
            fail("catalog receipt retired profiles are duplicated")
        retired_profiles.add(profile)

    ownership = receipt["profile_ownership"]
    if not isinstance(ownership, list):
        fail("catalog receipt profile_ownership must be a list")
    evidence: dict[str, OwnershipEvidence] = {}
    targets: set[Path] = set()
    allowed_provenance = {
        "catalog-render",
        "logical-agent-install-receipt",
        "catalog-profile-ownership-receipt",
    }
    for index, raw in enumerate(ownership):
        entry = exact_keys(raw, OWNERSHIP_KEYS, f"catalog receipt profile_ownership[{index}]")
        profile = require_profile(entry["profile"], f"catalog receipt profile_ownership[{index}].profile")
        target = exact_target(entry["target"], home, profile)
        owner = entry["owner"]
        if owner not in {"catalog", "logical"}:
            fail(f"catalog receipt profile owner is invalid for {profile}")
        digest = require_sha256(entry["sha256"], f"catalog receipt ownership digest for {profile}")
        provenance = entry["provenance"]
        if provenance not in allowed_provenance:
            fail(f"catalog receipt provenance is invalid for {profile}")
        if owner == "catalog" and provenance != "catalog-render":
            fail(f"catalog-owned profile {profile} lacks catalog-render provenance")
        if profile in evidence or target in targets:
            fail("catalog receipt profile ownership is duplicated")
        evidence[profile] = OwnershipEvidence(owner, "catalog receipt", digest)
        targets.add(target)
    if set(preserved) - {profile for profile, item in evidence.items() if item.owner == "logical"}:
        fail("preserved logical profiles lack logical ownership records")
    catalog_owned = {profile for profile, item in evidence.items() if item.owner == "catalog"}
    logical_owned = {profile for profile, item in evidence.items() if item.owner == "logical"}
    if catalog_owned != installed_profiles - {"global"}:
        fail("catalog ownership records must exactly match installed catalog profiles")
    if logical_owned != set(preserved):
        fail("logical ownership records must exactly match preserved logical profiles")
    if retired_profiles & (catalog_owned | logical_owned):
        fail("retired profiles cannot retain current ownership")
    if backup_count == 0 and rollback_directory is not None:
        fail("catalog receipt has rollback directory without backup history")
    return evidence


def load_logical_evidence(path: Path, home: Path) -> dict[str, OwnershipEvidence]:
    receipt = read_receipt(path, "logical installer receipt")
    if receipt is None:
        return {}
    exact_keys(receipt, LOGICAL_RECEIPT_KEYS, "logical installer receipt")
    if receipt["schema_version"] != 2 or receipt["install_identity"] != "codex-logical-agent-profiles":
        fail("logical installer receipt identity or schema is invalid")
    receipt_time(receipt["installed_at"], "logical installer receipt installed_at")
    require_sha256(receipt["topology_sha256"], "logical installer receipt topology_sha256")
    require_sha256(receipt["catalog_sha256"], "logical installer receipt catalog_sha256")
    rollback_directory = contained_rollback(
        receipt["rollback_directory"], home, "logical installer receipt rollback_directory"
    )
    installed = receipt["installed"]
    if not isinstance(installed, list):
        fail("logical installer receipt installed must be a list")
    evidence: dict[str, OwnershipEvidence] = {}
    targets: set[Path] = set()
    backup_count = 0
    for index, raw in enumerate(installed):
        entry = exact_keys(raw, LOGICAL_INSTALLED_KEYS, f"logical receipt installed[{index}]")
        agent = entry["agent"]
        if agent == "orchestrator":
            target = exact_target(entry["target"], home, "orchestrator", global_target=True)
        else:
            agent = require_profile(agent, f"logical receipt installed[{index}].agent")
            target = exact_target(entry["target"], home, agent)
        if contained_backup(
            entry["backup"], home, target, rollback_directory,
            f"logical receipt installed[{index}].backup",
        ) is not None:
            backup_count += 1
        digest = require_sha256(entry["sha256"], f"logical receipt installed[{index}].sha256")
        expected_provenance = "logical-orchestrator-defaults" if agent == "orchestrator" else "logical-agent-render"
        if entry["provenance"] != expected_provenance:
            fail(f"logical receipt provenance is invalid for {agent}")
        if agent in evidence or target in targets:
            fail("logical installer receipt installed ownership is duplicated")
        evidence[agent] = OwnershipEvidence("logical", "logical installer receipt", digest)
        targets.add(target)
    retired = receipt["retired_profiles"]
    if not isinstance(retired, list):
        fail("logical installer receipt retired_profiles must be a list")
    for index, raw in enumerate(retired):
        entry = exact_keys(raw, LOGICAL_RETIRED_KEYS, f"logical receipt retired_profiles[{index}]")
        agent = require_profile(entry["agent"], f"logical receipt retired_profiles[{index}].agent")
        target = exact_target(entry["target"], home, agent)
        if contained_backup(
            entry["backup"], home, target, rollback_directory,
            f"logical receipt retired_profiles[{index}].backup",
        ) is not None:
            backup_count += 1
    if backup_count == 0 and rollback_directory is not None:
        fail("logical installer receipt has rollback directory without backup history")
    return evidence


def classify_hidden_profiles(
    home: Path,
    hidden_profiles: list[str],
    logical_profiles: set[str],
    catalog_receipt: Path,
    logical_receipt: Path,
) -> dict[str, tuple[str, str]]:
    existing = [profile for profile in hidden_profiles if os.path.lexists(home / f"{profile}.config.toml")]
    if not existing:
        return {}
    catalog_evidence = load_catalog_evidence(catalog_receipt, home)
    logical_evidence = load_logical_evidence(logical_receipt, home)
    actions: dict[str, tuple[str, str]] = {}
    for profile in existing:
        target = home / f"{profile}.config.toml"
        if target.is_symlink() or not target.is_file():
            fail(f"hidden profile target is not a regular non-symlink file: {target}")
        digest = file_sha256(target)
        logical = logical_evidence.get(profile)
        if profile in logical_profiles and logical is not None:
            if logical.sha256 != digest:
                fail(f"logical profile digest does not match its installer receipt: {target}")
            actions[profile] = ("preserve", logical.source)
            continue
        prior = catalog_evidence.get(profile)
        if prior is None or prior.sha256 != digest:
            fail(f"hidden profile ownership is ambiguous for {target}")
        if prior.owner == "catalog":
            actions[profile] = ("retire", prior.source)
        elif prior.owner == "logical":
            fail(f"logical profile lacks an exact current logical installer receipt: {target}")
        else:
            fail(f"hidden profile owner is unsupported for {target}")
    return actions


def toml_value(value: Any) -> str:
    if isinstance(value, bool):
        return str(value).lower()
    if isinstance(value, str):
        return json.dumps(value, ensure_ascii=False)
    if isinstance(value, int):
        return str(value)
    if isinstance(value, list):
        return "[" + ", ".join(toml_value(item) for item in value) + "]"
    if isinstance(value, dict):
        return "{ " + ", ".join(f"{key} = {toml_value(item)}" for key, item in value.items()) + " }"
    raise SystemExit(f"unsupported unmanaged skills.config value: {value!r}")


def managed_catalog_states(catalog: dict[str, Any]) -> dict[str, bool]:
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


def replace_skills_config(text: str, entries: list[dict[str, Any]]) -> str:
    """Replace only skills.config while leaving every unrelated TOML section intact."""
    rendered = "config = [\n" + "".join(f"  {toml_value(entry)},\n" for entry in entries) + "]\n"
    lines = text.splitlines(keepends=True)
    skills_header: int | None = None
    section_end = len(lines)
    for index, line in enumerate(lines):
        stripped = line.strip()
        if stripped == "[skills]":
            skills_header = index
            continue
        if skills_header is not None and index > skills_header and stripped.startswith("["):
            section_end = index
            break
    if skills_header is None:
        separator = "" if not text or text.endswith("\n\n") else ("\n" if text.endswith("\n") else "\n\n")
        return text + separator + "[skills]\n" + rendered

    assignment: int | None = None
    for index in range(skills_header + 1, section_end):
        if lines[index].lstrip().startswith("config") and "=" in lines[index]:
            assignment = index
            break
    rendered_lines = rendered.splitlines(keepends=True)
    if assignment is None:
        lines[skills_header + 1 : skills_header + 1] = rendered_lines
        return "".join(lines)

    depth = 0
    started = False
    end = assignment
    for index in range(assignment, section_end):
        segment = lines[index].split("#", 1)[0]
        for character in segment:
            if character == "[":
                depth += 1
                started = True
            elif character == "]" and started:
                depth -= 1
        end = index
        if started and depth == 0:
            break
    if not started or depth != 0:
        raise SystemExit("unable to locate the complete [skills].config array")
    lines[assignment : end + 1] = rendered_lines
    return "".join(lines)


def restore(replaced: list[tuple[Path, Path | None, int | None]]) -> None:
    for target, backup, original_mode in reversed(replaced):
        if backup is None:
            target.unlink(missing_ok=True)
        else:
            os.replace(backup, target)
            if original_mode is None:
                raise RuntimeError(f"missing original mode for restored target: {target}")
            os.chmod(target, original_mode)


parser = argparse.ArgumentParser()
parser.add_argument("catalog", type=Path)
parser.add_argument("--codex-home", type=Path, required=True)
parser.add_argument("--logical-topology", type=Path, default=DEFAULT_LOGICAL_TOPOLOGY)
args = parser.parse_args()

catalog_path = args.catalog.resolve()
topology_path = args.logical_topology.resolve()
home = args.codex_home.resolve()
catalog_validator = SOURCE_ROOT / "scripts/validate-codex-skill-catalog.py"
topology_validator = SOURCE_ROOT / "scripts/validate-codex-logical-agent-topology.py"
policy = SOURCE_ROOT / "adapters/runtime/codex-collaboration/role-policy.json"
renderer = SOURCE_ROOT / "scripts/render-codex-skill-profile.py"
subprocess.run(["python3", str(catalog_validator), str(catalog_path)], check=True)
subprocess.run(
    ["python3", str(topology_validator), str(topology_path), str(catalog_path), str(policy)],
    check=True,
)
catalog = tomllib.loads(catalog_path.read_text())
topology = tomllib.loads(topology_path.read_text())
managed = managed_catalog_states(catalog)
profiles = [
    str(group["profile"])
    for group in catalog["groups"]
    if group.get("profile") and group.get("public_profile") is True
]
hidden_profiles = [
    str(group["profile"])
    for group in catalog["groups"]
    if group.get("profile") and group.get("public_profile") is False
]
all_profiles = [*profiles, *hidden_profiles]
if len(all_profiles) != len(set(all_profiles)):
    raise SystemExit("catalog profile names must be unique")
logical_profiles = {
    str(agent["name"])
    for agent in topology["agents"]
    if agent["kind"] == "specialist"
}
public_logical_collisions = sorted(set(profiles) & logical_profiles)
if public_logical_collisions:
    raise SystemExit(
        "public catalog profiles collide with logical agent ownership: "
        + ", ".join(public_logical_collisions)
    )
home.mkdir(parents=True, exist_ok=True)
mutation_lock_descriptor = acquire_runtime_mutation_lock(home)
base_config = home / "config.toml"
receipt_path = home / CATALOG_RECEIPT_NAME
logical_receipt_path = home / LOGICAL_RECEIPT_NAME
base_text = base_config.read_text() if base_config.exists() else ""
base_document = tomllib.loads(base_text) if base_text else {}
unmanaged: list[dict[str, Any]] = []
for entry in base_document.get("skills", {}).get("config", []):
    if not isinstance(entry, dict) or not isinstance(entry.get("path"), str):
        raise SystemExit("every existing skills.config entry must be a path-bearing table")
    if entry["path"] not in managed:
        unmanaged.append(entry)
desired = [*unmanaged, *({"path": path, "enabled": False} for path, enabled in managed.items() if not enabled)]
reconciled_base = replace_skills_config(base_text, desired)
tomllib.loads(reconciled_base)

# Resolve every colliding hidden target before staging or replacing catalog
# artifacts. A filename, current renderer equality, or rollback backup is not
# ownership. Only an exact repo-controlled receipt plus bounded target/content
# evidence may authorize preserve or retirement.
hidden_actions = classify_hidden_profiles(
    home,
    hidden_profiles,
    logical_profiles,
    receipt_path,
    logical_receipt_path,
)

timestamp = datetime.now(UTC).strftime("%Y%m%dT%H%M%S.%fZ")
backup_dir = home / "backups" / f"skill-catalog-{timestamp}-{os.getpid()}"
backups_root = backup_dir.parent
backups_root_existed = os.path.lexists(backups_root)
backups_root_mode = (
    stat.S_IMODE(backups_root.lstat().st_mode) if backups_root_existed else None
)
if backups_root_existed:
    backups_root_metadata = backups_root.lstat()
    if (
        backups_root.is_symlink()
        or not stat.S_ISDIR(backups_root_metadata.st_mode)
        or backups_root_metadata.st_uid != os.geteuid()
    ):
        fail(f"backup root is not a safe owned directory: {backups_root}")
if os.path.lexists(backup_dir):
    fail(f"catalog transaction backup path already exists: {backup_dir}")
backup_storage_touched = False
installed: list[dict[str, str | None]] = []
retired_profiles: list[dict[str, str]] = []
preserved_logical_profiles: list[str] = []
profile_ownership: list[dict[str, str]] = []
replaced: list[tuple[Path, Path | None, int | None]] = []

with tempfile.TemporaryDirectory(prefix="codex-skill-catalog-", dir=home) as temporary:
    stage = Path(temporary)
    staged_base = stage / "config.toml"
    write_private_text(staged_base, reconciled_base)
    staged: list[tuple[str, Path, Path]] = []
    for profile in profiles:
        generated = stage / f"{profile}.config.toml"
        subprocess.run(
            ["python3", str(renderer), str(catalog_path), "--mode", "profile", "--profile", profile, "--output", str(generated)],
            check=True,
        )
        tomllib.loads(generated.read_text())
        os.chmod(generated, PRIVATE_FILE_MODE)
        staged.append((profile, home / generated.name, generated))

    # A current install is a true byte-idempotent no-op. This matters when a
    # sync transaction includes these receipts in its rollback generation: a
    # later standalone catalog preflight must not stale that transaction merely
    # by refreshing timestamps or backup paths.
    existing_receipt = read_receipt(receipt_path, "catalog receipt")
    preserved_now = sorted(
        profile for profile, (action, _) in hidden_actions.items()
        if action == "preserve"
    )
    if existing_receipt is not None and not any(
        action == "retire" for action, _ in hidden_actions.values()
    ):
        load_catalog_evidence(receipt_path, home)
        installed_profiles = {
            entry["profile"] for entry in existing_receipt.get("installed", [])
        }
        expected_installed = {"global", *profiles}
        expected_owners = {
            **{profile: "catalog" for profile in profiles},
            **{profile: "logical" for profile in preserved_now},
        }
        ownership_by_profile = {
            entry["profile"]: entry
            for entry in existing_receipt.get("profile_ownership", [])
        }
        ownership_matches = set(ownership_by_profile) == set(expected_owners)
        if ownership_matches:
            for profile, owner in expected_owners.items():
                target = home / f"{profile}.config.toml"
                evidence = ownership_by_profile[profile]
                expected_provenance = "catalog-render" if owner == "catalog" else "logical-agent-install-receipt"
                if (
                    not target.is_file()
                    or target.is_symlink()
                    or evidence["owner"] != owner
                    or evidence["target"] != str(target)
                    or evidence["provenance"] != expected_provenance
                    or evidence["sha256"] != file_sha256(target)
                ):
                    ownership_matches = False
                    break
        if (
            existing_receipt.get("catalog_sha256") == hashlib.sha256(catalog_path.read_bytes()).hexdigest()
            and existing_receipt.get("logical_topology_sha256") == hashlib.sha256(topology_path.read_bytes()).hexdigest()
            and installed_profiles == expected_installed
            and existing_receipt.get("preserved_logical_profiles") == preserved_now
            and existing_receipt.get("retired_profiles") == []
            and ownership_matches
            and is_exact_private_file(base_config, staged_base)
            and all(is_exact_private_file(target, generated) for _, target, generated in staged)
            and stat.S_IMODE(receipt_path.stat().st_mode) == PRIVATE_FILE_MODE
        ):
            print(receipt_path)
            raise SystemExit(0)

    staged_receipt: Path | None = None
    staged_receipt_created = False
    candidate_receipt_path = home / f".{receipt_path.name}.{os.getpid()}.tmp"
    if os.path.lexists(candidate_receipt_path):
        fail(f"catalog staged receipt path already exists: {candidate_receipt_path}")
    try:
        for name, target, generated in [("global", base_config, staged_base), *staged]:
            backup: Path | None = None
            original_mode: int | None = None
            if target.exists():
                original_mode = stat.S_IMODE(target.stat().st_mode)
                backup_storage_touched = True
                ensure_private_directory(backup_dir)
                backup = backup_dir / target.name
                shutil.copy2(target, backup)
                os.chmod(backup, PRIVATE_FILE_MODE)
            os.replace(generated, target)
            replaced.append((target, backup, original_mode))
            installed.append({"profile": name, "target": str(target), "backup": str(backup) if backup else None})
            if name != "global":
                profile_ownership.append(
                    {
                        "profile": name,
                        "target": str(target),
                        "owner": "catalog",
                        "sha256": file_sha256(target),
                        "provenance": "catalog-render",
                    }
                )
        for profile in hidden_profiles:
            target = home / f"{profile}.config.toml"
            action = hidden_actions.get(profile)
            if action is None:
                continue
            disposition, source = action
            if disposition == "preserve":
                preserved_logical_profiles.append(profile)
                profile_ownership.append(
                    {
                        "profile": profile,
                        "target": str(target),
                        "owner": "logical",
                        "sha256": file_sha256(target),
                        "provenance": (
                            "logical-agent-install-receipt"
                            if source == "logical installer receipt"
                            else "catalog-profile-ownership-receipt"
                        ),
                    }
                )
                continue
            if disposition != "retire":
                fail(f"unsupported preflight disposition for {target}: {disposition}")
            retired_digest = file_sha256(target)
            original_mode = stat.S_IMODE(target.stat().st_mode)
            backup_storage_touched = True
            ensure_private_directory(backup_dir)
            backup = backup_dir / target.name
            shutil.copy2(target, backup)
            os.chmod(backup, PRIVATE_FILE_MODE)
            target.unlink()
            replaced.append((target, backup, original_mode))
            retired_profiles.append(
                {
                    "profile": profile,
                    "target": str(target),
                    "backup": str(backup),
                    "previous_owner": "catalog",
                    "sha256": retired_digest,
                }
            )
        receipt = {
            "schema_version": 2,
            "install_identity": "codex-skill-catalog",
            "installed_at": datetime.now(UTC).isoformat(),
            "catalog_sha256": hashlib.sha256(catalog_path.read_bytes()).hexdigest(),
            "logical_topology_sha256": hashlib.sha256(topology_path.read_bytes()).hexdigest(),
            "installed": installed,
            "preserved_logical_profiles": preserved_logical_profiles,
            "retired_profiles": retired_profiles,
            "profile_ownership": sorted(profile_ownership, key=lambda entry: entry["profile"]),
            "rollback_directory": str(backup_dir) if backup_dir.exists() else None,
        }
        staged_receipt = candidate_receipt_path
        write_private_text(staged_receipt, json.dumps(receipt, indent=2, sort_keys=True) + "\n")
        staged_receipt_created = True
        os.replace(staged_receipt, receipt_path)
        staged_receipt_created = False
    except BaseException:
        restore(replaced)
        if staged_receipt_created and staged_receipt is not None:
            metadata = staged_receipt.lstat()
            if (
                not stat.S_ISREG(metadata.st_mode)
                or staged_receipt.is_symlink()
                or metadata.st_nlink != 1
                or metadata.st_uid != os.geteuid()
            ):
                raise RuntimeError(f"cannot safely clean staged catalog receipt: {staged_receipt}")
            staged_receipt.unlink()
        if backup_dir.exists():
            metadata = backup_dir.lstat()
            if not stat.S_ISDIR(metadata.st_mode) or backup_dir.is_symlink() or metadata.st_uid != os.geteuid():
                raise RuntimeError(f"cannot safely clean catalog backup directory: {backup_dir}")
            shutil.rmtree(backup_dir)
        if backup_storage_touched and backups_root_existed:
            if backups_root_mode is None:
                raise RuntimeError(f"missing original mode for backup root: {backups_root}")
            os.chmod(backups_root, backups_root_mode)
        elif backup_storage_touched and backups_root.exists():
            backups_root.rmdir()
        raise
print(receipt_path)
