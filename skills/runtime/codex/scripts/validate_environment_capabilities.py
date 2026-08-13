#!/usr/bin/env python3
"""Validate a Codex environment capability catalog without reading ENV values."""

from __future__ import annotations

import argparse
import json
import pathlib
import sys

REQUIRED_SYSTEM_KEYS = {
    "id", "display_name", "aliases", "env_names", "env_posture",
    "policy_state", "source_of_truth", "preferred_access",
    "forbidden_fallbacks", "availability", "read_probe", "write_policy",
}


def validate(path: pathlib.Path) -> tuple[int, int, int]:
    data = json.loads(path.read_text(encoding="utf-8"))
    if data.get("schema_version") != 1:
        raise ValueError("unsupported schema_version")
    if data.get("security", {}).get("contains_values") is not False:
        raise ValueError("catalog must declare contains_values=false")
    systems = data.get("systems")
    if not isinstance(systems, list) or not systems:
        raise ValueError("systems must be a non-empty list")

    ids: set[str] = set()
    env_total = defined = empty = 0
    by_id: dict[str, dict] = {}
    for system in systems:
        if not isinstance(system, dict) or not REQUIRED_SYSTEM_KEYS <= system.keys():
            raise ValueError("system entry has an incomplete schema")
        system_id = system["id"]
        if not isinstance(system_id, str) or not system_id or system_id in ids:
            raise ValueError("system ids must be unique non-empty strings")
        ids.add(system_id)
        by_id[system_id] = system
        names = system["env_names"]
        posture = system["env_posture"]
        if not isinstance(names, list) or any(not isinstance(name, str) or not name for name in names):
            raise ValueError(f"invalid env_names for {system_id}")
        if set(posture) != {"total", "defined", "empty"}:
            raise ValueError(f"invalid env_posture for {system_id}")
        if posture["total"] != len(names) or posture["defined"] + posture["empty"] != posture["total"]:
            raise ValueError(f"env posture mismatch for {system_id}")
        env_total += posture["total"]
        defined += posture["defined"]
        empty += posture["empty"]

    summary = data.get("summary", {})
    expected = {"system_total": len(systems), "env_total": env_total, "env_defined": defined, "env_empty": empty}
    if any(summary.get(key) != value for key, value in expected.items()):
        raise ValueError("summary does not match system aggregates")

    hermes = by_id.get("hermes-core-api-webui-state-governance")
    if not hermes or hermes.get("preferred_access", {}).get("kind") != "postgresql":
        raise ValueError("Hermes PostgreSQL authority is missing")
    if not any("SQLite" in item for item in hermes.get("forbidden_fallbacks", [])):
        raise ValueError("Hermes SQLite fallback prohibition is missing")
    manychat = by_id.get("manychat")
    if not manychat or manychat.get("policy_state") != "disabled" or manychat.get("write_policy") != "disabled":
        raise ValueError("ManyChat must remain disabled")
    return len(systems), defined, empty


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("catalog", type=pathlib.Path)
    args = parser.parse_args()
    try:
        systems, defined, empty = validate(args.catalog)
    except (OSError, json.JSONDecodeError, ValueError) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1
    print(f"PASS: systems={systems} defined={defined} empty={empty} values=not-read")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
