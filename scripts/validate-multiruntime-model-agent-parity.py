#!/usr/bin/env python3
"""Validate the secret-free Codex, Hermes, and OpenHands parity contract."""

from __future__ import annotations

import json
import importlib.util
import shutil
import sys
import tomllib
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
HOME = Path.home()
LANES = REPO / "adapters/runtime/model-lanes/model-lanes.toml"
PARITY = REPO / "adapters/runtime/model-lanes/cross-runtime-agent-parity.toml"
SUBAGENT_MATERIALIZER = REPO / "scripts/install-openhands-subagents.py"


def fail(message: str) -> None:
    print(f"FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def load_toml(path: Path) -> dict:
    with path.open("rb") as stream:
        return tomllib.load(stream)


def load_subagent_materializer():
    spec = importlib.util.spec_from_file_location(
        "openhands_subagent_installer", SUBAGENT_MATERIALIZER
    )
    if not spec or not spec.loader:
        fail("OpenHands subagent materializer cannot be loaded")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


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
    subagent_registry = parity["openhands_subagent_registry"]
    root_policy = parity["openhands_root_delegation_policy"]
    subagents = {agent["name"]: agent for agent in subagent_registry["agents"]}
    declared_subagent_roles = set(parity["openhands_native_subagent_roles"])
    roots = set(subagent_registry["root_profiles"])
    excluded = set(subagent_registry["excluded_profiles"])
    acp_profiles = set(parity["openhands_acp"])
    if set(subagents) & roots:
        fail("OpenHands root profile is incorrectly spawnable")
    if set(subagents) & excluded or set(subagents) & acp_profiles:
        fail("OpenHands ACP/excluded profile is incorrectly spawnable")
    if not set(subagents) <= set(native_bindings):
        fail("OpenHands subagent lacks a native LLM binding")
    if excluded != acp_profiles:
        fail("OpenHands native subagent exclusions do not match ACP profiles")
    if subagent_registry["recursive_delegation"] is not False:
        fail("OpenHands recursive subagent delegation is enabled")
    if set(subagents) != declared_subagent_roles:
        fail("OpenHands native subagent role denominator drift")
    missing = [
        role for role in parity["openhands_agent_profiles"]
        if not (openhands_agents / f"{role}.json").is_file()
    ]
    if missing:
        fail(f"OpenHands agent profiles missing: {', '.join(missing)}")
    for role in parity["openhands_agent_profiles"]:
        payload = json.loads((openhands_agents / f"{role}.json").read_text())
        expected_kind = "acp" if role in {"gemini-flash", "codex"} else "openhands"
        if payload.get("name") != role or payload.get("agent_kind") != expected_kind:
            fail(f"OpenHands agent profile contract mismatch: {role}")
        if expected_kind == "openhands" and payload.get("llm_profile_ref") != native_bindings.get(role):
            fail(f"OpenHands native LLM binding drift: {role}")
        if expected_kind == "openhands":
            expected_subagents = role in roots
            if payload.get("enable_sub_agents") is not expected_subagents:
                fail(f"OpenHands delegation boundary drift: {role}")
        if role in roots and payload.get("system_message_suffix") != root_policy[
            "system_message_suffix"
        ].strip():
            fail(f"OpenHands root routing policy drift: {role}")
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

    materializer = load_subagent_materializer()
    expected_definitions = materializer.load_registry(PARITY)
    target_dir = HOME / ".agents/agents"
    if materializer.reconcile(target_dir, expected_definitions, apply=False):
        fail("OpenHands native subagent definitions are not materialized exactly")
    for name, definition in subagents.items():
        if definition["model"] != native_bindings[name]:
            fail(f"OpenHands subagent model drift: {name}")
        if "task_tool_set" in definition["tools"] or "task" in definition["tools"]:
            fail(f"OpenHands child can recursively delegate: {name}")
        if definition["max_iteration_per_run"] <= 0:
            fail(f"OpenHands child lacks an iteration limit: {name}")
        if definition["max_budget_per_run"] <= 0:
            fail(f"OpenHands child lacks a budget limit: {name}")

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
