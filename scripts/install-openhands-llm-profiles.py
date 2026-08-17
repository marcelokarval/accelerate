#!/usr/bin/env python3
"""Materialize governed, secret-free OpenHands LLM profile definitions."""

from __future__ import annotations

import argparse
import json
import os
import re
import tempfile
import tomllib
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
PARITY = REPO / "adapters/runtime/model-lanes/cross-runtime-agent-parity.toml"
NAME_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$")
MANAGED_BY = "accelerate"
MANAGED_SCHEMA = 1


def load_registry(path: Path = PARITY) -> dict[str, dict]:
    with path.open("rb") as stream:
        profiles = tomllib.load(stream)["openhands_llm_profile_registry"]["profiles"]
    expected: dict[str, dict] = {}
    for profile in profiles:
        name = profile.get("name")
        if not isinstance(name, str) or not NAME_RE.fullmatch(name):
            raise ValueError(f"invalid OpenHands LLM profile name: {name!r}")
        if name in expected:
            raise ValueError(f"duplicate OpenHands LLM profile name: {name}")
        auth_type = profile.get("auth_type")
        if auth_type not in {"api_key", "subscription"}:
            raise ValueError(f"invalid auth_type for {name}: {auth_type!r}")
        if auth_type == "subscription":
            if profile.get("subscription_vendor") != "openai":
                raise ValueError(f"subscription vendor must be openai for {name}")
            if profile.get("is_subscription") is not True:
                raise ValueError(f"subscription profile must set is_subscription=true: {name}")
            if "credential_env" in profile:
                raise ValueError(f"subscription profile must not declare credential_env: {name}")
        elif not profile.get("credential_env"):
            raise ValueError(f"api_key profile lacks credential_env: {name}")
        expected[name] = dict(profile)
    return expected


def profile_payload(profile: dict, *, existing: dict | None = None) -> dict:
    payload = {
        "managed_by": MANAGED_BY,
        "managed_schema": MANAGED_SCHEMA,
        "model": profile["model"],
        "auth_type": profile["auth_type"],
        "reasoning_effort": profile["reasoning_effort"],
        "num_retries": 5,
        "retry_multiplier": 8.0,
        "retry_min_wait": 8,
        "retry_max_wait": 64,
        "timeout": 300,
        "max_message_chars": 30000,
        "api_mode": profile.get("api_mode", "auto"),
        "capability_overrides": {},
        # ChatGPT subscription requests use the Codex responses transport. Its
        # child-task path requires streaming, whereas API-key providers retain
        # the conservative non-streaming default unless their registry says
        # otherwise.
        "stream": profile.get("stream", profile["auth_type"] == "subscription"),
        "drop_params": True,
        "modify_params": True,
        "disable_stop_word": False,
        "caching_prompt": True,
        "log_completions": False,
        "log_completions_folder": "logs/completions",
        "native_tool_calling": True,
        "enable_encrypted_reasoning": True,
        "prompt_cache_retention": "24h",
        "extended_thinking_budget": 200000,
        "usage_id": profile["name"],
        "litellm_extra_body": {},
        "schema_version": 1,
    }
    for key in ("base_url", "subscription_vendor", "is_subscription"):
        if key in profile:
            payload[key] = profile[key]
    if profile["auth_type"] == "api_key" and existing and "api_key" in existing:
        payload["api_key"] = existing["api_key"]
    return payload


def _is_managed(payload: dict) -> bool:
    return (
        payload.get("managed_by") == MANAGED_BY
        and payload.get("managed_schema") == MANAGED_SCHEMA
    )


def _write_atomic(path: Path, payload: dict) -> None:
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
        temporary.chmod(0o600)
        os.replace(temporary, path)
    finally:
        if temporary.exists():
            temporary.unlink()


def reconcile(profiles_dir: Path, expected: dict[str, dict], *, apply: bool) -> int:
    profiles_dir.mkdir(parents=True, exist_ok=True)
    drift = 0
    for name, profile in sorted(expected.items()):
        path = profiles_dir / f"{name}.json"
        if path.is_symlink() or (path.exists() and not path.is_file()):
            raise ValueError(f"non-regular OpenHands LLM profile path: {name}")
        existing: dict | None = None
        if path.exists():
            existing = json.loads(path.read_text(encoding="utf-8"))
            if not _is_managed(existing):
                raise ValueError(f"refusing to overwrite unmanaged OpenHands LLM profile: {name}")
        target = profile_payload(profile, existing=existing)
        if existing == target and (path.stat().st_mode & 0o777) == 0o600:
            continue
        drift += 1
        if apply:
            _write_atomic(path, target)
    for path in sorted(profiles_dir.glob("*.json")):
        if path.stem in expected or path.is_symlink() or not path.is_file():
            continue
        try:
            existing = json.loads(path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            continue
        if not _is_managed(existing):
            continue
        drift += 1
        if apply:
            path.unlink()
    return 0 if apply else drift


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--profiles-dir", type=Path, default=Path.home() / ".openhands/profiles"
    )
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()
    try:
        expected = load_registry()
        drift = reconcile(args.profiles_dir, expected, apply=args.apply)
    except (OSError, ValueError, json.JSONDecodeError, tomllib.TOMLDecodeError) as error:
        print(f"FAIL: {error}")
        return 2
    if drift:
        print(f"FAIL: OpenHands LLM profile drift: {drift} profile(s)")
        return 1
    action = "applied" if args.apply else "verified"
    print(f"PASS: OpenHands LLM profiles {action}: {len(expected)} profile(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
