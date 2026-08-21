#!/usr/bin/env python3
"""Validate the secret-free Codex, Hermes, and OpenHands parity contract."""

from __future__ import annotations

import json
import importlib.util
import sys
import tomllib
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
HOME = Path.home()
LANES = REPO / "adapters/runtime/model-lanes/model-lanes.toml"
PARITY = REPO / "adapters/runtime/model-lanes/cross-runtime-agent-parity.toml"
SUBAGENT_MATERIALIZER = REPO / "scripts/install-openhands-subagents.py"
SKILL_MATERIALIZER = REPO / "scripts/install-openhands-governed-skills.py"
LLM_PROFILE_MATERIALIZER = REPO / "scripts/install-openhands-llm-profiles.py"
NATIVE_TASK_VALIDATOR = REPO / "scripts/validate-openhands-native-task.py"


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


def load_skill_materializer():
    spec = importlib.util.spec_from_file_location(
        "openhands_governed_skill_installer", SKILL_MATERIALIZER
    )
    if not spec or not spec.loader:
        fail("OpenHands governed skill materializer cannot be loaded")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_llm_profile_materializer():
    spec = importlib.util.spec_from_file_location(
        "openhands_llm_profile_installer", LLM_PROFILE_MATERIALIZER
    )
    if not spec or not spec.loader:
        fail("OpenHands LLM profile materializer cannot be loaded")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def validate_native_task_contract() -> None:
    spec = importlib.util.spec_from_file_location(
        "openhands_native_task_validator", NATIVE_TASK_VALIDATOR
    )
    if not spec or not spec.loader:
        fail("OpenHands native task validator cannot be loaded")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    try:
        module.validate_contract(PARITY)
    except (KeyError, ValueError) as error:
        fail(str(error))


def main() -> None:
    lanes = load_toml(LANES)["lanes"]
    parity = load_toml(PARITY)
    validate_native_task_contract()
    if lanes["deepseek"]["model"] != "deepseek-v4-flash":
        fail("DeepSeek lane is not pinned to deepseek-v4-flash")
    if lanes["gemini_flash"]["model"] != "gemini-3.7-flash":
        fail("Gemini lane is not pinned to gemini-3.7-flash")
    # Gemini remains an optional ACP launch lane but is deliberately excluded
    # from the governed child-lane denominator until its provider is stable.

    openhands_agents = HOME / ".openhands/agent-profiles"
    native_bindings = parity["openhands_native_bindings"]
    subagent_registry = parity["openhands_subagent_registry"]
    root_policy = parity["openhands_root_delegation_policy"]
    skill_registry = parity["openhands_skill_registry"]
    subagent_candidates = {agent["name"]: agent for agent in subagent_registry["agents"]}
    declared_subagent_roles = set(parity["openhands_native_subagent_roles"])
    roots = set(subagent_registry["root_profiles"])
    excluded = set(subagent_registry["excluded_profiles"])
    acp_profiles = set(parity["openhands_acp"])
    if set(subagent_candidates) & roots:
        fail("OpenHands root profile is incorrectly spawnable")
    if set(subagent_candidates) & excluded or set(subagent_candidates) & acp_profiles:
        fail("OpenHands ACP/excluded profile is incorrectly spawnable")
    if set(subagent_candidates) & set(native_bindings):
        fail("OpenHands blocked child incorrectly retains a native LLM binding")
    if excluded != acp_profiles:
        fail("OpenHands native subagent exclusions do not match ACP profiles")
    if subagent_registry["recursive_delegation"] is not False:
        fail("OpenHands recursive subagent delegation is enabled")
    if roots != set(root_policy["profiles"]):
        fail("OpenHands root policy and delegation roots drift")
    if set(subagent_candidates) != declared_subagent_roles:
        fail("OpenHands native subagent role denominator drift")
    missing = [
        role for role in native_bindings
        if not (openhands_agents / f"{role}.json").is_file()
    ]
    if missing:
        fail(f"OpenHands agent profiles missing: {', '.join(missing)}")
    for role in native_bindings:
        payload = json.loads((openhands_agents / f"{role}.json").read_text())
        expected_kind = "openhands"
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
        if role not in roots and payload.get("system_message_suffix") is not None:
            fail(f"OpenHands non-root retains routing policy: {role}")

    llm_materializer = load_llm_profile_materializer()
    expected_llm_profiles = llm_materializer.load_registry(PARITY)
    subscription_profiles = {
        name
        for name, profile in expected_llm_profiles.items()
        if profile["auth_type"] == "subscription"
    }
    if native_bindings["default"] not in subscription_profiles:
        fail("OpenHands root subscription binding is not materialized")
    llm_profiles_dir = HOME / ".openhands/profiles"
    if llm_materializer.reconcile(llm_profiles_dir, expected_llm_profiles, apply=False):
        fail("OpenHands governed LLM profiles are not materialized exactly")
    for profile_name, expected in expected_llm_profiles.items():
        profile = json.loads(
            (llm_profiles_dir / f"{profile_name}.json").read_text()
        )
        for key in (
            "model",
            "auth_type",
            "reasoning_effort",
            "managed_by",
            "managed_schema",
        ):
            expected_value = (
                llm_materializer.MANAGED_BY
                if key == "managed_by"
                else llm_materializer.MANAGED_SCHEMA
                if key == "managed_schema"
                else expected[key]
            )
            if profile.get(key) != expected_value:
                fail(f"OpenHands LLM profile drift: {profile_name}.{key}")
        if "api_mode" in expected and profile.get("api_mode") != expected["api_mode"]:
            fail(f"OpenHands LLM profile drift: {profile_name}.api_mode")
        if profile.get("stream") is not (expected["auth_type"] == "subscription"):
            fail(f"OpenHands LLM profile streaming contract drift: {profile_name}")
        if expected["auth_type"] == "subscription" and profile.get(
            "is_subscription"
        ) is not True:
            fail(f"OpenHands LLM profile drift: {profile_name}")

    materializer = load_subagent_materializer()
    expected_definitions = materializer.load_registry(PARITY)
    target_dir = HOME / ".agents/agents"
    if materializer.reconcile(target_dir, expected_definitions, apply=False):
        fail("OpenHands native subagent definitions are not materialized exactly")
    if expected_definitions:
        fail("OpenHands binding_unavailable children are materializable")
    for name, definition in expected_definitions.items():
        if "task_tool_set" in definition["tools"] or "task" in definition["tools"]:
            fail(f"OpenHands child can recursively delegate: {name}")
        if definition["max_iteration_per_run"] <= 0:
            fail(f"OpenHands child lacks an iteration limit: {name}")
        if definition["max_budget_per_run"] <= 0:
            fail(f"OpenHands child lacks a budget limit: {name}")

    skill_materializer = load_skill_materializer()
    expected_skills = skill_materializer.load_registry(PARITY)
    if set(expected_skills) != set(skill_registry["skills"]):
        fail("OpenHands governed skill denominator drift")
    skill_target = HOME / ".agents/skills"
    if skill_materializer.reconcile(skill_target, expected_skills, apply=False):
        fail("OpenHands governed skills are not materialized exactly")

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
