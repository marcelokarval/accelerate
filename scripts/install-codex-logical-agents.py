#!/usr/bin/env python3
"""Atomically install rendered logical Codex profiles with a rollback receipt."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
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


topology = tomllib.loads(args.topology.read_text())
home = args.codex_home
home.mkdir(parents=True, exist_ok=True)
timestamp = datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")
backup_dir = home / "backups" / f"logical-agents-{timestamp}"
renderer = Path(__file__).with_name("render-codex-logical-agent.py")
catalog_renderer = Path(__file__).with_name("render-codex-skill-profile.py")
validator = Path(__file__).with_name("validate-codex-logical-agent-topology.py")
source_root = Path(__file__).resolve().parents[1]
policy = source_root / "adapters/runtime/codex-collaboration/role-policy.json"
installed: list[dict[str, str | None]] = []

with tempfile.TemporaryDirectory(prefix="codex-logical-agents-", dir=home) as temporary:
    temporary_dir = Path(temporary)
    subprocess.run(
        ["python3", str(validator), str(args.topology), str(args.catalog), str(policy)],
        check=True,
    )
    base_config = home / "config.toml"
    if not base_config.is_file():
        raise SystemExit(f"global catalog base is not installed: {base_config}")
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
        name = str(agent["name"])
        target = home / f"{name}.config.toml"
        generated = temporary_dir / target.name
        subprocess.run(
            ["python3", str(renderer), str(args.topology), str(args.catalog), "--agent", name, "--output", str(generated)],
            check=True,
        )
        tomllib.loads(generated.read_text())
        staged.append((name, target, generated))

    replaced: list[tuple[Path, Path | None]] = []
    try:
        for name, target, generated in staged:
            backup: Path | None = None
            if target.exists():
                backup_dir.mkdir(parents=True, exist_ok=True)
                backup = backup_dir / target.name
                shutil.copy2(target, backup)
            os.replace(generated, target)
            replaced.append((target, backup))
            installed.append({"agent": name, "target": str(target), "backup": str(backup) if backup else None})
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
    "rollback_directory": str(backup_dir) if backup_dir.exists() else None,
}
receipt_path = home / "logical-agent-install-receipt.json"
staged_receipt = home / f".{receipt_path.name}.{timestamp}.tmp"
staged_receipt.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
os.replace(staged_receipt, receipt_path)
print(receipt_path)
