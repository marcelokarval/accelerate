#!/usr/bin/env python3
"""Atomically install rendered logical Codex profiles with a rollback receipt."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import tempfile
import tomllib
from datetime import UTC, datetime
from pathlib import Path


parser = argparse.ArgumentParser()
parser.add_argument("topology", type=Path)
parser.add_argument("catalog", type=Path)
parser.add_argument("--codex-home", type=Path, required=True)
parser.add_argument("--receipt", type=Path)
parser.add_argument("--rollback", action="store_true")
parser.add_argument("--rollback-receipt", type=Path)
args = parser.parse_args()


def managed_catalog_states(catalog: dict[str, object]) -> dict[str, bool]:
    sources = {str(source["id"]): source for source in catalog["sources"]}
    states: dict[str, bool] = {}
    for group in catalog["groups"]:
        if group["source"] != "r0":
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
        if re.match(r"^\s*(?:\[\[.*\]\]|\[.*\])\s*(?:#.*)?$", line):
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


def reconciled_catalog_base(text: str, document: dict[str, object], states: dict[str, bool]) -> str:
    skills = document.get("skills", {})
    if not isinstance(skills, dict):
        raise SystemExit("existing [skills] table must be a TOML table")
    existing = skills.get("config", [])
    if not isinstance(existing, list):
        raise SystemExit("existing skills.config must be an array")
    unmanaged: list[tuple[str, bool]] = []
    for entry in existing:
        if not isinstance(entry, dict) or set(entry) != {"path", "enabled"}:
            raise SystemExit("existing skills.config entries must contain only path and enabled")
        path = entry["path"]
        enabled = entry["enabled"]
        if not isinstance(path, str) or type(enabled) is not bool:
            raise SystemExit("existing skills.config entries have invalid path or enabled")
        if path not in states:
            unmanaged.append((path, enabled))
    entries = [*unmanaged, *states.items()]
    block = ["config = [\n"]
    block.extend(
        f"  {{ path = {toml_basic_string(path)}, enabled = {str(enabled).lower()} }},\n"
        for path, enabled in entries
    )
    block.append("]\n")
    lines = text.splitlines(keepends=True)
    section_indexes = [index for index, line in enumerate(lines) if line.strip() == "[skills]"]
    if len(section_indexes) > 1:
        raise SystemExit("existing config has multiple [skills] tables")
    if not section_indexes:
        prefix = "" if not text or text.endswith("\n") else "\n"
        return text + prefix + "\n[skills]\n" + "".join(block)
    start = section_indexes[0]
    end = next(
        (index for index in range(start + 1, len(lines)) if re.match(r"^\s*\[", lines[index])),
        len(lines),
    )
    config_indexes = [
        index
        for index in range(start + 1, end)
        if re.match(r"^\s*config\s*=", lines[index])
    ]
    if len(config_indexes) > 1:
        raise SystemExit("existing [skills] table has multiple config entries")
    if not config_indexes:
        lines[end:end] = block
        return "".join(lines)
    config_start = config_indexes[0]
    depth = 0
    config_end = None
    for index in range(config_start, end):
        depth += lines[index].count("[") - lines[index].count("]")
        if depth == 0 and "[" in "".join(lines[config_start : index + 1]):
            config_end = index + 1
            break
    if config_end is None:
        raise SystemExit("existing skills.config array is malformed")
    lines[config_start:config_end] = block
    return "".join(lines)


def toml_basic_string(value: str) -> str:
    escapes = {
        "\\": "\\\\",
        '"': '\\"',
        "\b": "\\b",
        "\t": "\\t",
        "\n": "\\n",
        "\f": "\\f",
        "\r": "\\r",
    }
    return '"' + "".join(escapes.get(character, character) for character in value) + '"'


def sha256_path(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def unique_backup_directory(home: Path, timestamp: str) -> Path:
    root = home / "backups"
    candidate = root / f"logical-agents-{timestamp}"
    suffix = 2
    while candidate.exists():
        candidate = root / f"logical-agents-{timestamp}-{suffix}"
        suffix += 1
    return candidate


def atomic_copy(source: Path, target: Path) -> None:
    temporary = target.with_name(f".{target.name}.logical-agents-{os.getpid()}.tmp")
    try:
        shutil.copy2(source, temporary)
        os.replace(temporary, target)
    finally:
        temporary.unlink(missing_ok=True)


def rollback(home: Path, receipt_path: Path, rollback_receipt: Path, topology_hash: str, catalog_hash: str, owned_names: set[str]) -> None:
    try:
        receipt = json.loads(receipt_path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        raise SystemExit(f"rollback requires a readable install receipt: {error}") from error
    if receipt.get("install_identity") != "codex-logical-agent-profiles" or receipt.get("topology_sha256") != topology_hash or receipt.get("catalog_sha256") != catalog_hash:
        raise SystemExit("rollback receipt identity or source fingerprints do not match")
    owned = receipt.get("owned_files")
    if not isinstance(owned, list) or not owned:
        raise SystemExit("rollback receipt has no changed owned files")
    home_resolved = home.resolve()
    prepared: list[tuple[dict[str, object], Path, Path | None]] = []
    for entry in owned:
        if not isinstance(entry, dict) or set(entry) != {"target", "backup", "before_sha256", "after_sha256"}:
            raise SystemExit("rollback receipt owned file shape is invalid")
        target = Path(str(entry["target"]))
        if target.parent.resolve() != home_resolved or target.name not in owned_names:
            raise SystemExit("rollback receipt names an unowned target")
        after = entry["after_sha256"]
        if after is None:
            if target.exists():
                raise SystemExit("rollback current target fingerprint mismatch")
        elif not isinstance(after, str) or not target.is_file() or sha256_path(target) != after:
            raise SystemExit("rollback current target fingerprint mismatch")
        backup_value = entry["backup"]
        if backup_value is None:
            if entry["before_sha256"] is not None:
                raise SystemExit("rollback receipt has inconsistent created-file backup state")
            prepared.append((entry, target, None))
            continue
        backup = Path(str(backup_value))
        if not backup.is_file() or backup.parent.parent.resolve() != (home / "backups").resolve():
            raise SystemExit("rollback backup is unavailable or outside the owned backup root")
        if sha256_path(backup) != entry["before_sha256"]:
            raise SystemExit("rollback backup fingerprint mismatch")
        prepared.append((entry, target, backup))
    for _, target, backup in reversed(prepared):
        if backup is None:
            target.unlink()
        else:
            atomic_copy(backup, target)
    result = {
        "mode": "rollback",
        "install_receipt": str(receipt_path),
        "changed": True,
        "rolled_back_files": [str(target) for _, target, _ in prepared],
        "timestamp": datetime.now(UTC).isoformat(),
    }
    rollback_receipt.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(rollback_receipt)


topology = tomllib.loads(args.topology.read_text())
orchestrator = next(agent for agent in topology["agents"] if agent["kind"] == "root-orchestrator")
home = args.codex_home
owned_names = {"config.toml", "orchestrator.config.toml"} | {
    f"{agent['name']}.config.toml" for agent in topology["agents"] if agent["kind"] == "specialist"
}
receipt_path = args.receipt or home / "logical-agent-install-receipt.json"
if receipt_path.parent.resolve() != home.resolve():
    raise SystemExit("receipt path must be directly inside --codex-home")
if receipt_path.name in owned_names:
    raise SystemExit("receipt path must not overlap an owned logical-agent file")
if args.rollback:
    if args.rollback_receipt is None or args.rollback_receipt.parent.resolve() != home.resolve():
        raise SystemExit("rollback requires --rollback-receipt directly inside --codex-home")
    if args.rollback_receipt.name in owned_names:
        raise SystemExit("rollback receipt path must not overlap an owned logical-agent file")
    if args.rollback_receipt.resolve() == receipt_path.resolve():
        raise SystemExit("rollback receipt path must differ from the install receipt")
    rollback(
        home,
        receipt_path,
        args.rollback_receipt,
        hashlib.sha256(args.topology.read_bytes()).hexdigest(),
        hashlib.sha256(args.catalog.read_bytes()).hexdigest(),
        owned_names,
    )
    raise SystemExit(0)
if args.rollback_receipt is not None:
    raise SystemExit("--rollback-receipt requires --rollback")
home.mkdir(parents=True, exist_ok=True)
timestamp = datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")
backup_dir = unique_backup_directory(home, timestamp)
renderer = Path(__file__).with_name("render-codex-logical-agent.py")
catalog_renderer = Path(__file__).with_name("render-codex-skill-profile.py")
validator = Path(__file__).with_name("validate-codex-logical-agent-topology.py")
source_root = Path(__file__).resolve().parents[1]
policy = source_root / "adapters/runtime/codex-collaboration/role-policy.json"
installed: list[dict[str, str | None]] = []
retired_profiles: list[dict[str, str]] = []
owned_files: list[dict[str, str | None]] = []

with tempfile.TemporaryDirectory(prefix="codex-logical-agents-", dir=home) as temporary:
    temporary_dir = Path(temporary)
    subprocess.run(
        ["python3", str(validator), str(args.topology), str(args.catalog), str(policy)],
        check=True,
    )
    base_config = home / "config.toml"
    expected_base = temporary_dir / "global-catalog.config.toml"
    subprocess.run(
        ["python3", str(catalog_renderer), str(args.catalog), "--mode", "global", "--output", str(expected_base)],
        check=True,
    )
    catalog = tomllib.loads(args.catalog.read_text())
    expected_states = managed_catalog_states(catalog)
    base_text = base_config.read_text() if base_config.is_file() else ""
    base_document = tomllib.loads(base_text) if base_text else {}
    reconciled_base = reconciled_catalog_base(base_text, base_document, expected_states)
    reconciled_document = tomllib.loads(reconciled_base)
    actual_states = effective_states(reconciled_document, set(expected_states))
    if any(actual_states.get(path, True) != expected for path, expected in expected_states.items()):
        raise SystemExit("reconciled global catalog is incomplete")
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
        staged.append((name, target, generated))

    staged_base = temporary_dir / "config.toml"
    rendered_base = root_config_with_orchestrator_defaults(reconciled_base, orchestrator)
    tomllib.loads(rendered_base)
    staged_base.write_text(rendered_base)
    stale_orchestrator_profile = home / "orchestrator.config.toml"
    replaced: list[tuple[Path, Path | None]] = []
    try:
        base_backup: Path | None = None
        base_before = base_config.read_bytes() if base_config.exists() else None
        base_changed = base_before != staged_base.read_bytes()
        if base_changed:
            backup_dir.mkdir(parents=True, exist_ok=True)
            if base_before is not None:
                base_backup = backup_dir / base_config.name
                shutil.copy2(base_config, base_backup)
            os.replace(staged_base, base_config)
            replaced.append((base_config, base_backup))
            owned_files.append({"target": str(base_config), "backup": str(base_backup) if base_backup else None, "before_sha256": sha256_path(base_backup) if base_backup else None, "after_sha256": sha256_path(base_config)})
        installed.append({"agent": "orchestrator", "target": str(base_config), "backup": str(base_backup) if base_backup else None, "changed": base_changed})
        if stale_orchestrator_profile.exists():
            backup_dir.mkdir(parents=True, exist_ok=True)
            profile_backup = backup_dir / stale_orchestrator_profile.name
            shutil.copy2(stale_orchestrator_profile, profile_backup)
            stale_orchestrator_profile.unlink()
            replaced.append((stale_orchestrator_profile, profile_backup))
            owned_files.append({"target": str(stale_orchestrator_profile), "backup": str(profile_backup), "before_sha256": sha256_path(profile_backup), "after_sha256": None})
            retired_profiles.append(
                {
                    "agent": "orchestrator",
                    "target": str(stale_orchestrator_profile),
                    "backup": str(profile_backup),
                }
            )
        for name, target, generated in staged:
            backup: Path | None = None
            changed = not target.exists() or target.read_bytes() != generated.read_bytes()
            if not changed:
                installed.append({"agent": name, "target": str(target), "backup": None, "changed": False})
                continue
            if target.exists():
                backup_dir.mkdir(parents=True, exist_ok=True)
                backup = backup_dir / target.name
                shutil.copy2(target, backup)
            os.replace(generated, target)
            replaced.append((target, backup))
            owned_files.append({"target": str(target), "backup": str(backup) if backup else None, "before_sha256": sha256_path(backup) if backup else None, "after_sha256": sha256_path(target)})
            installed.append({"agent": name, "target": str(target), "backup": str(backup) if backup else None, "changed": True})
    except Exception:
        for target, backup in reversed(replaced):
            if backup is None:
                target.unlink(missing_ok=True)
            else:
                shutil.copy2(backup, target)
        raise

receipt = {
    "schema_version": 1,
    "install_identity": "codex-logical-agent-profiles",
    "installed_at": datetime.now(UTC).isoformat(),
    "topology_sha256": hashlib.sha256(args.topology.read_bytes()).hexdigest(),
    "catalog_sha256": hashlib.sha256(args.catalog.read_bytes()).hexdigest(),
    "installed": installed,
    "retired_profiles": retired_profiles,
    "changed": bool(owned_files),
    "owned_files": owned_files,
    "rollback_directory": str(backup_dir) if backup_dir.exists() else None,
}
staged_receipt = home / f".{receipt_path.name}.{timestamp}.tmp"
staged_receipt.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
os.replace(staged_receipt, receipt_path)
print(receipt_path)
