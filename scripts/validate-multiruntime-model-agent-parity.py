#!/usr/bin/env python3
"""Validate the secret-free Codex, Hermes, and OpenHands parity contract."""

from __future__ import annotations

import json
import shutil
import sys
import tomllib
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
HOME = Path.home()
LANES = REPO / "adapters/runtime/model-lanes/model-lanes.toml"
PARITY = REPO / "adapters/runtime/model-lanes/cross-runtime-agent-parity.toml"


def fail(message: str) -> None:
    print(f"FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def load_toml(path: Path) -> dict:
    with path.open("rb") as stream:
        return tomllib.load(stream)


def main() -> None:
    lanes = load_toml(LANES)["lanes"]
    parity = load_toml(PARITY)
    if lanes["deepseek"]["model"] != "deepseek-v4-flash":
        fail("DeepSeek lane is not pinned to deepseek-v4-flash")
    if lanes["gemini_flash"]["model"] != "gemini-3.7-flash":
        fail("Gemini lane is not pinned to gemini-3.7-flash")
    if not shutil.which(lanes["gemini_flash"]["codex_executable"]):
        fail("official Gemini CLI is not installed")

    openhands_agents = HOME / ".openhands/agent-profiles"
    native_bindings = parity["openhands_native_bindings"]
    missing = [
        role for role in parity["openhands_roles"]
        if not (openhands_agents / f"{role}.json").is_file()
    ]
    if missing:
        fail(f"OpenHands agent profiles missing: {', '.join(missing)}")
    for role in parity["openhands_roles"]:
        payload = json.loads((openhands_agents / f"{role}.json").read_text())
        expected_kind = "acp" if role in {"gemini-flash", "codex"} else "openhands"
        if payload.get("name") != role or payload.get("agent_kind") != expected_kind:
            fail(f"OpenHands agent profile contract mismatch: {role}")
        if expected_kind == "openhands" and payload.get("llm_profile_ref") != native_bindings.get(role):
            fail(f"OpenHands native LLM binding drift: {role}")
        if role == "gemini-flash" and (
            payload.get("acp_server") != "gemini-cli"
            or payload.get("acp_model") != "gemini-3.7-flash"
        ):
            fail("OpenHands Gemini ACP lane drift")
        if role == "codex" and (
            payload.get("acp_server") != "codex"
            or payload.get("acp_model") != "gpt-5.6-terra"
        ):
            fail("OpenHands Codex ACP lane drift")

    expected_llm_models = {
        "default": "deepseek/deepseek-v4-flash",
        "deepseek-v4-pro": "deepseek/deepseek-v4-pro",
        "gemini-3.7-flash": "gemini/gemini-3.7-flash",
    }
    for profile_name, model in expected_llm_models.items():
        profile = json.loads(
            (HOME / f".openhands/profiles/{profile_name}.json").read_text()
        )
        if profile.get("model") != model:
            fail(f"OpenHands LLM profile drift: {profile_name}")

    hermes_profiles = HOME / ".hermes/profiles"
    for profile in parity["hermes"]["profiles"]:
        if profile == "default":
            continue
        if not (hermes_profiles / profile).is_dir():
            fail(f"Hermes profile missing: {profile}")
    if (hermes_profiles / "sdr-agent").exists():
        fail("retired sdr-agent is discoverable")

    print("PASS: multi-runtime model and agent parity contract is structurally aligned")


if __name__ == "__main__":
    main()
