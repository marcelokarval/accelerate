from __future__ import annotations

import importlib.util
import io
import json
import subprocess
import sys
import tomllib
import os
from pathlib import Path

import pytest


ADAPTER = (
    Path(__file__).resolve().parents[1]
    / "adapters/runtime/model-lanes/run-codex-model-lane.py"
)
PARITY = ADAPTER.parent / "cross-runtime-agent-parity.toml"
MATERIALIZER = ADAPTER.parents[3] / "scripts/install-openhands-agent-bindings.py"
SUBAGENT_MATERIALIZER = ADAPTER.parents[3] / "scripts/install-openhands-subagents.py"
CREDENTIAL_SYNC = ADAPTER.parents[3] / "scripts/sync-openhands-provider-credentials.py"


def load_adapter():
    spec = importlib.util.spec_from_file_location("codex_model_lane", ADAPTER)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_materializer():
    spec = importlib.util.spec_from_file_location("openhands_binding_installer", MATERIALIZER)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_subagent_materializer():
    spec = importlib.util.spec_from_file_location(
        "openhands_subagent_installer", SUBAGENT_MATERIALIZER
    )
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_credential_sync():
    spec = importlib.util.spec_from_file_location(
        "openhands_credential_sync", CREDENTIAL_SYNC
    )
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_deepseek_lane_keeps_prompt_off_argv_and_filters_session_id(
    monkeypatch, capsys
):
    module = load_adapter()
    observed = {}

    def fake_run(command, **kwargs):
        observed["command"] = command
        observed["input"] = kwargs["input"]
        return subprocess.CompletedProcess(
            command,
            0,
            stdout=(
                "┌─ Reasoning ───┐\ninternal analysis\n└────────────────┘\n"
                "DEEPSEEK_RESULT\n"
            ),
            stderr="session_id: test\n",
        )

    monkeypatch.setattr(module.subprocess, "run", fake_run)
    monkeypatch.setattr(sys, "argv", ["adapter", "--lane", "deepseek"])
    monkeypatch.setattr(sys, "stdin", io.StringIO("SECRET_PROMPT"))

    assert module.main() == 0
    captured = capsys.readouterr()
    assert captured.out == "DEEPSEEK_RESULT\n"
    assert captured.err == ""
    assert observed["input"] == "SECRET_PROMPT"
    assert "SECRET_PROMPT" not in observed["command"]


def test_gemini_lane_pins_37_flash_and_keeps_prompt_off_argv(monkeypatch, capsys):
    module = load_adapter()
    observed = {}

    def fake_run(command, **kwargs):
        observed["command"] = command
        observed["input"] = kwargs["input"]
        return subprocess.CompletedProcess(command, 0, stdout="GEMINI_RESULT\n", stderr="")

    monkeypatch.setattr(module.subprocess, "run", fake_run)
    monkeypatch.setattr(sys, "argv", ["adapter", "--lane", "gemini-flash"])
    monkeypatch.setattr(sys, "stdin", io.StringIO("SECRET_PROMPT"))

    assert module.main() == 0
    captured = capsys.readouterr()
    assert captured.out == "GEMINI_RESULT\n"
    assert observed["input"] == "SECRET_PROMPT"
    assert "SECRET_PROMPT" not in observed["command"]
    assert observed["command"][observed["command"].index("--model") + 1] == (
        "gemini-3.7-flash"
    )


def test_openhands_native_roles_have_explicit_model_bindings():
    with PARITY.open("rb") as stream:
        bindings = tomllib.load(stream)["openhands_native_bindings"]

    assert bindings == {
        "default": "default",
        "deepseek": "default",
        "research": "default",
        "mechanical-fixer": "default",
        "orchestrator": "deepseek-v4-pro",
        "reviewer": "deepseek-v4-pro",
        "high-stakes-reviewer": "deepseek-v4-pro",
        "python-backend": "gemini-3.7-flash",
        "nextjs-frontend": "gemini-3.7-flash",
        "data-db": "gemini-3.7-flash",
        "integrations-ops": "gemini-3.7-flash",
        "qa": "gemini-3.7-flash",
        "test-engineer": "gemini-3.7-flash",
    }


def test_openhands_binding_materializer_is_idempotent(tmp_path):
    module = load_materializer()
    profiles = tmp_path / "agent-profiles"
    profiles.mkdir()
    target = profiles / "orchestrator.json"
    target.write_text(
        '{"schema_version":2,"name":"orchestrator","revision":1,'
        '"agent_kind":"openhands","llm_profile_ref":"default"}\n',
        encoding="utf-8",
    )

    expected = {"orchestrator": "deepseek-v4-pro"}
    assert module.reconcile(profiles, expected, apply=False) == 1
    assert module.reconcile(profiles, expected, apply=True) == 0
    first = target.read_bytes()
    assert module.reconcile(profiles, expected, apply=True) == 0
    assert target.read_bytes() == first


def test_openhands_root_delegation_policy_is_materialized(tmp_path):
    module = load_materializer()
    profiles = tmp_path / "agent-profiles"
    profiles.mkdir()
    target = profiles / "orchestrator.json"
    target.write_text(
        '{"schema_version":2,"name":"orchestrator","revision":1,'
        '"agent_kind":"openhands","llm_profile_ref":"default",'
        '"enable_sub_agents":false,"system_message_suffix":null}\n',
        encoding="utf-8",
    )
    policy = {
        "profiles": ["orchestrator"],
        "system_message_suffix": "Delegate bounded work; retain closure.\n",
    }
    assert module.reconcile(
        profiles, {"orchestrator": "deepseek-v4-pro"}, root_policy=policy, apply=True
    ) == 0
    payload = json.loads(target.read_text())
    assert payload["enable_sub_agents"] is True
    assert payload["system_message_suffix"] == "Delegate bounded work; retain closure."


def test_openhands_subagent_registry_is_native_bounded_and_non_recursive():
    with PARITY.open("rb") as stream:
        parity = tomllib.load(stream)
    registry = parity["openhands_subagent_registry"]

    agents = {agent["name"]: agent for agent in registry["agents"]}
    assert set(agents) == {
        "deepseek", "python-backend", "nextjs-frontend", "data-db", "integrations-ops",
        "qa", "test-engineer", "research", "mechanical-fixer", "reviewer",
        "high-stakes-reviewer",
    }
    assert registry["root_profiles"] == ["default", "orchestrator"]
    assert set(registry["excluded_profiles"]) == {"codex", "gemini-flash"}
    assert set(registry["excluded_profiles"]) == set(parity["openhands_acp"])
    assert registry["recursive_delegation"] is False
    assert set(agents) == set(parity["openhands_native_subagent_roles"])
    assert parity["invariants"]["provider_lanes_require_explicit_role_definition"] is True
    for agent in agents.values():
        assert "task" not in agent["tools"]
        assert agent["max_iteration_per_run"] > 0
        assert agent["max_budget_per_run"] > 0
        assert agent["model"] in {"default", "deepseek-v4-pro", "gemini-3.7-flash"}


def test_openhands_subagent_materializer_is_idempotent_and_preserves_unmanaged(tmp_path):
    module = load_subagent_materializer()
    target = tmp_path / "agents"
    target.mkdir()
    unmanaged = target / "personal.md"
    unmanaged.write_text("personal\n", encoding="utf-8")

    expected = module.load_registry(PARITY)
    assert module.reconcile(target, expected, apply=False) == len(expected)
    assert module.reconcile(target, expected, apply=True) == 0
    first = {path.name: path.read_bytes() for path in target.iterdir()}
    assert module.reconcile(target, expected, apply=True) == 0
    assert {path.name: path.read_bytes() for path in target.iterdir()} == first
    assert unmanaged.read_text(encoding="utf-8") == "personal\n"


def test_openhands_subagent_materializer_rejects_unsafe_names_and_symlinks(tmp_path):
    module = load_subagent_materializer()
    target = tmp_path / "agents"
    target.mkdir()
    fixture = {
        "name": "../escape", "description": "bad", "model": "default",
        "tools": ["terminal"], "permission_mode": "confirm_risky",
        "max_iteration_per_run": 1, "max_budget_per_run": 0.1,
        "write_mode": "read-only",
    }
    with pytest.raises(ValueError, match="invalid OpenHands subagent name"):
        module.reconcile(target, {"../escape": fixture}, apply=True)

    outside = tmp_path / "outside.md"
    outside.write_text("safe\n", encoding="utf-8")
    os.symlink(outside, target / "research.md")
    fixture["name"] = "research"
    with pytest.raises(ValueError, match="non-regular agent path"):
        module.reconcile(target, {"research": fixture}, apply=True)
    assert outside.read_text(encoding="utf-8") == "safe\n"


def test_openhands_subagent_registry_rejects_duplicate_names(tmp_path):
    module = load_subagent_materializer()
    manifest = tmp_path / "parity.toml"
    manifest.write_text(
        '[[openhands_subagent_registry.agents]]\nname="research"\n'
        '[[openhands_subagent_registry.agents]]\nname="research"\n',
        encoding="utf-8",
    )
    with pytest.raises(ValueError, match="duplicate OpenHands subagent name"):
        module.load_registry(manifest)


def test_openhands_subagent_ownership_requires_exact_frontmatter(tmp_path):
    module = load_subagent_materializer()
    target = tmp_path / "agents"
    target.mkdir()
    unmanaged = target / "research.md"
    unmanaged.write_text(
        '---\nname: "research"\n---\n\nBody mentions managed_by: "accelerate"\n',
        encoding="utf-8",
    )
    fixture = {
        "name": "research", "description": "safe", "model": "default",
        "tools": ["terminal"], "permission_mode": "confirm_risky",
        "max_iteration_per_run": 1, "max_budget_per_run": 0.1,
        "write_mode": "read-only",
    }
    with pytest.raises(ValueError, match="unmanaged agent"):
        module.reconcile(target, {"research": fixture}, apply=True)


def test_openhands_subagent_materializer_removes_only_stale_managed_files(tmp_path):
    module = load_subagent_materializer()
    target = tmp_path / "agents"
    target.mkdir()
    stale = target / "stale.md"
    stale.write_text(
        '---\nname: "stale"\nmanaged_by: "accelerate"\nmanaged_schema: 1\n---\n',
        encoding="utf-8",
    )
    unmanaged = target / "personal.md"
    unmanaged.write_text("personal\n", encoding="utf-8")
    assert module.reconcile(target, {}, apply=False) == 1
    assert module.reconcile(target, {}, apply=True) == 0
    assert not stale.exists()
    assert unmanaged.exists()


def test_openhands_provider_credential_sync_is_secret_safe_and_idempotent(tmp_path):
    module = load_credential_sync()
    profiles = tmp_path / "profiles"
    profiles.mkdir()
    for name in module.PROFILE_ENV:
        (profiles / f"{name}.json").write_text(
            '{"model":"fixture","api_key":"stale"}\n', encoding="utf-8"
        )
    environ = {
        "DEEPSEEK_API_KEY": "fresh-deepseek",
        "GOOGLE_API_KEY": "fresh-gemini",
    }

    assert module.reconcile(profiles, environ, apply=False) == 3
    assert module.reconcile(profiles, environ, apply=True) == 0
    assert module.reconcile(profiles, environ, apply=False) == 0
    assert json.loads((profiles / "default.json").read_text())["api_key"] == "fresh-deepseek"
    assert (
        json.loads((profiles / "gemini-3.7-flash.json").read_text())["api_key"]
        == "fresh-gemini"
    )
