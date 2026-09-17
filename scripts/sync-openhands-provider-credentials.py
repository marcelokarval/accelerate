#!/usr/bin/env python3
"""Secret-safe reconciliation of OpenHands LLM profile credentials from ENV."""

from __future__ import annotations

import argparse
import json
import os
import tempfile
import tomllib
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
PARITY = REPO / "adapters/runtime/model-lanes/cross-runtime-agent-parity.toml"
MANAGED_BY = "accelerate"
MANAGED_SCHEMA = 1


def profile_env(path: Path = PARITY) -> dict[str, str]:
    """Return only ENV-backed profiles; subscription profiles never copy secrets."""
    with path.open("rb") as stream:
        registry = tomllib.load(stream)["openhands_llm_profile_registry"]["profiles"]
    expected: dict[str, str] = {}
    for profile in registry:
        credential_env = profile.get("credential_env")
        if credential_env:
            expected[profile["name"]] = credential_env
    return expected


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


def _is_governed_profile(profile_name: str, payload: dict) -> bool:
    """Reject secret writes to an arbitrary user profile.

    Every generated API-key profile must carry the explicit Accelerate ownership
    marker. Subscription profiles are credential-free by contract.
    """
    return (
        payload.get("managed_by") == MANAGED_BY
        and payload.get("managed_schema") == MANAGED_SCHEMA
        and payload.get("auth_type") == "api_key"
    )


def reconcile(
    profiles_dir: Path,
    environ: dict[str, str],
    *,
    apply: bool,
    expected: dict[str, str] | None = None,
) -> int:
    drift = 0
    for profile_name, env_name in (expected or profile_env()).items():
        path = profiles_dir / f"{profile_name}.json"
        if path.is_symlink() or not path.is_file():
            raise ValueError(f"non-regular OpenHands LLM profile path: {profile_name}")
        credential = environ.get(env_name)
        if not credential:
            raise ValueError(f"required environment credential is unavailable: {env_name}")
        payload = json.loads(path.read_text(encoding="utf-8"))
        if not _is_governed_profile(profile_name, payload):
            raise ValueError(f"refusing to sync unmanaged OpenHands LLM profile: {profile_name}")
        if payload.get("api_key") == credential:
            continue
        drift += 1
        if apply:
            payload["api_key"] = credential
            _write_atomic(path, payload)
    return 0 if apply else drift


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--profiles-dir", type=Path, default=Path.home() / ".openhands/profiles"
    )
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()
    try:
        expected = profile_env()
        drift = reconcile(
            args.profiles_dir, dict(os.environ), apply=args.apply, expected=expected
        )
    except (OSError, ValueError, json.JSONDecodeError, tomllib.TOMLDecodeError) as error:
        print(f"FAIL: {error}")
        return 2
    if drift:
        print(f"FAIL: OpenHands provider credential drift: {drift} profile(s)")
        return 1
    action = "applied" if args.apply else "verified"
    print(f"PASS: OpenHands provider credentials {action}: {len(expected)} profile(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
