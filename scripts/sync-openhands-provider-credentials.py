#!/usr/bin/env python3
"""Secret-safe reconciliation of OpenHands LLM profile credentials from ENV."""

from __future__ import annotations

import argparse
import json
import os
import tempfile
from pathlib import Path


PROFILE_ENV = {
    "default": "DEEPSEEK_API_KEY",
    "deepseek-v4-pro": "DEEPSEEK_API_KEY",
}


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


def reconcile(profiles_dir: Path, environ: dict[str, str], *, apply: bool) -> int:
    drift = 0
    for profile_name, env_name in PROFILE_ENV.items():
        path = profiles_dir / f"{profile_name}.json"
        if not path.is_file():
            raise ValueError(f"missing OpenHands LLM profile: {profile_name}")
        credential = environ.get(env_name)
        if not credential:
            raise ValueError(f"required environment credential is unavailable: {env_name}")
        payload = json.loads(path.read_text(encoding="utf-8"))
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
        drift = reconcile(args.profiles_dir, dict(os.environ), apply=args.apply)
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"FAIL: {error}")
        return 2
    if drift:
        print(f"FAIL: OpenHands provider credential drift: {drift} profile(s)")
        return 1
    action = "applied" if args.apply else "verified"
    print(f"PASS: OpenHands provider credentials {action}: {len(PROFILE_ENV)} profile(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
