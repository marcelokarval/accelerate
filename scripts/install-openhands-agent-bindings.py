#!/usr/bin/env python3
"""Materialize repo-governed OpenHands native-agent LLM bindings."""

from __future__ import annotations

import argparse
import json
import os
import tempfile
import tomllib
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
PARITY = REPO / "adapters/runtime/model-lanes/cross-runtime-agent-parity.toml"


def _write_atomic(path: Path, payload: dict) -> None:
    mode = path.stat().st_mode & 0o777
    rendered = json.dumps(payload, indent=2, ensure_ascii=False) + "\n"
    descriptor, temporary_name = tempfile.mkstemp(
        prefix=f".{path.name}.", suffix=".tmp", dir=path.parent
    )
    temporary = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as stream:
            stream.write(rendered)
            stream.flush()
            os.fsync(stream.fileno())
        temporary.chmod(mode)
        os.replace(temporary, path)
    finally:
        if temporary.exists():
            temporary.unlink()


def reconcile(
    profiles_dir: Path,
    expected: dict[str, str],
    *,
    root_policy: dict | None = None,
    apply: bool,
) -> int:
    drift = 0
    for role, llm_profile in sorted(expected.items()):
        path = profiles_dir / f"{role}.json"
        if not path.is_file():
            raise ValueError(f"missing OpenHands agent profile: {role}")
        payload = json.loads(path.read_text(encoding="utf-8"))
        if payload.get("name") != role or payload.get("agent_kind") != "openhands":
            raise ValueError(f"invalid native OpenHands agent profile: {role}")
        changes: dict[str, object] = {}
        if payload.get("llm_profile_ref") != llm_profile:
            changes["llm_profile_ref"] = llm_profile
        if root_policy and role in root_policy["profiles"]:
            if payload.get("enable_sub_agents") is not True:
                changes["enable_sub_agents"] = True
            suffix = root_policy["system_message_suffix"].strip()
            if payload.get("system_message_suffix") != suffix:
                changes["system_message_suffix"] = suffix
        if not changes:
            continue
        drift += 1
        if apply:
            payload.update(changes)
            payload["revision"] = int(payload.get("revision", 0)) + 1
            _write_atomic(path, payload)
    return 0 if apply else drift


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--profiles-dir",
        type=Path,
        default=Path.home() / ".openhands/agent-profiles",
    )
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()

    with PARITY.open("rb") as stream:
        parity = tomllib.load(stream)
        expected = parity["openhands_native_bindings"]
        root_policy = parity["openhands_root_delegation_policy"]
    try:
        drift = reconcile(
            args.profiles_dir, expected, root_policy=root_policy, apply=args.apply
        )
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"FAIL: {error}")
        return 2
    if drift:
        print(f"FAIL: OpenHands native-agent binding drift: {drift} profile(s)")
        return 1
    action = "applied" if args.apply else "verified"
    print(f"PASS: OpenHands native-agent bindings {action}: {len(expected)} profile(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
