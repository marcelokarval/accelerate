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
SKILL_MATERIALIZER = ADAPTER.parents[3] / "scripts/install-openhands-governed-skills.py"
LLM_PROFILE_MATERIALIZER = ADAPTER.parents[3] / "scripts/install-openhands-llm-profiles.py"


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


def load_skill_materializer():
    spec = importlib.util.spec_from_file_location(
        "openhands_governed_skill_installer", SKILL_MATERIALIZER
    )
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_llm_profile_materializer():
    spec = importlib.util.spec_from_file_location(
        "openhands_llm_profile_installer", LLM_PROFILE_MATERIALIZER
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
        "default": "chatgpt-sol-medium",
        "deepseek": "deepseek-pro-reasoning",
        "research": "deepseek-flash-fast",
        "mechanical-fixer": "deepseek-flash-fast",
        "orchestrator": "chatgpt-sol-medium",
        "reviewer": "deepseek-pro-reasoning",
        "high-stakes-reviewer": "deepseek-pro-reasoning",
        "python-backend": "deepseek-pro-reasoning",
        "nextjs-frontend": "deepseek-pro-reasoning",
        "data-db": "deepseek-pro-reasoning",
        "integrations-ops": "deepseek-pro-reasoning",
        "qa": "deepseek-pro-reasoning",
        "test-engineer": "deepseek-flash-reasoning",
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

    expected = {"orchestrator": "chatgpt-sol-medium"}
    assert module.reconcile(profiles, expected, apply=False) == 1
    assert module.reconcile(profiles, expected, apply=True) == 0
    first = target.read_bytes()
    assert module.reconcile(profiles, expected, apply=True) == 0
    assert target.read_bytes() == first


def test_openhands_root_delegation_policy_is_materialized_only_for_default(tmp_path):
    module = load_materializer()
    profiles = tmp_path / "agent-profiles"
    profiles.mkdir()
    default = profiles / "default.json"
    default.write_text(
        '{"schema_version":2,"name":"default","revision":1,'
        '"agent_kind":"openhands","llm_profile_ref":"default",'
        '"enable_sub_agents":false,"system_message_suffix":null}\n',
        encoding="utf-8",
    )
    orchestrator = profiles / "orchestrator.json"
    orchestrator.write_text(
        '{"schema_version":2,"name":"orchestrator","revision":1,'
        '"agent_kind":"openhands","llm_profile_ref":"chatgpt-sol-medium",'
        '"enable_sub_agents":true,"system_message_suffix":"stale"}\n',
        encoding="utf-8",
    )
    policy = {
        "profiles": ["default"],
        "system_message_suffix": "Delegate bounded work; retain closure.\n",
    }
    assert module.reconcile(
        profiles,
        {"default": "chatgpt-sol-medium", "orchestrator": "chatgpt-sol-medium"},
        root_policy=policy,
        apply=True,
    ) == 0
    payload = json.loads(default.read_text())
    assert payload["enable_sub_agents"] is True
    assert payload["system_message_suffix"] == "Delegate bounded work; retain closure."
    retired = json.loads(orchestrator.read_text())
    assert retired["enable_sub_agents"] is False
    assert retired["system_message_suffix"] is None


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
    assert registry["root_profiles"] == ["default"]
    assert set(registry["excluded_profiles"]) == {"codex", "gemini-flash"}
    assert set(registry["excluded_profiles"]) == set(parity["openhands_acp"])
    assert registry["recursive_delegation"] is False
    assert set(agents) == set(parity["openhands_native_subagent_roles"])
    assert parity["invariants"]["provider_lanes_require_explicit_role_definition"] is True
    assert agents["reviewer"]["review_posture"] == "adversarial-evidence"
    assert agents["high-stakes-reviewer"]["review_posture"] == "adversarial-evidence"
    subscription_profiles = {
        profile["name"]
        for profile in parity["openhands_llm_profile_registry"]["profiles"]
        if profile["auth_type"] == "subscription"
    }
    for agent in agents.values():
        assert "task" not in agent["tools"]
        assert agent["max_iteration_per_run"] > 0
        assert agent["max_budget_per_run"] > 0
        assert agent["model"] in {
            "chatgpt-sol-medium",
            "deepseek-flash-fast",
            "deepseek-flash-reasoning",
            "deepseek-pro-reasoning",
        }
        assert agent["model"] not in subscription_profiles


def test_openhands_reviewers_and_root_require_adversarial_review_contract():
    with PARITY.open("rb") as stream:
        parity = tomllib.load(stream)
    root_suffix = parity["openhands_root_delegation_policy"]["system_message_suffix"]
    assert "Treat every child result as evidence, never as truth" in root_suffix
    assert "actively try to disprove" in root_suffix
    module = load_subagent_materializer()
    with PARITY.open("rb") as stream:
        agents = {agent["name"]: agent for agent in tomllib.load(stream)["openhands_subagent_registry"]["agents"]}
    for name in ("reviewer", "high-stakes-reviewer"):
        rendered = module.render_agent(agents[name])
        assert "Review posture: adversarial evidence" in rendered
        assert "accept a green test" in rendered
        assert "remaining uncertainty" in rendered


def test_openhands_llm_profile_registry_is_subscription_safe_and_idempotent(tmp_path):
    module = load_llm_profile_materializer()
    profiles = tmp_path / "profiles"
    expected = module.load_registry(PARITY)

    assert expected["chatgpt-sol-medium"]["auth_type"] == "subscription"
    assert expected["chatgpt-sol-medium"]["is_subscription"] is True
    assert "credential_env" not in expected["chatgpt-sol-medium"]
    assert expected["deepseek-flash-fast"]["reasoning_effort"] == "low"
    assert module.reconcile(profiles, expected, apply=False) == len(expected)
    assert module.reconcile(profiles, expected, apply=True) == 0
    payload = json.loads((profiles / "chatgpt-sol-medium.json").read_text())
    assert payload["is_subscription"] is True
    assert payload["subscription_vendor"] == "openai"
    assert payload["api_mode"] == "responses"
    assert payload["stream"] is True
    assert "api_key" not in payload
    assert (profiles / "chatgpt-sol-medium.json").stat().st_mode & 0o777 == 0o600
    first = (profiles / "chatgpt-sol-medium.json").read_bytes()
    assert module.reconcile(profiles, expected, apply=True) == 0
    assert (profiles / "chatgpt-sol-medium.json").read_bytes() == first


def test_openhands_llm_profile_materializer_sanitizes_managed_subscription_key(tmp_path):
    module = load_llm_profile_materializer()
    profiles = tmp_path / "profiles"
    profiles.mkdir()
    expected = {"chatgpt-sol-medium": module.load_registry(PARITY)["chatgpt-sol-medium"]}
    contaminated = module.profile_payload(expected["chatgpt-sol-medium"])
    contaminated["api_key"] = "must-not-survive"
    (profiles / "chatgpt-sol-medium.json").write_text(
        json.dumps(contaminated), encoding="utf-8"
    )
    assert module.reconcile(profiles, expected, apply=False) == 1
    assert module.reconcile(profiles, expected, apply=True) == 0
    assert "api_key" not in json.loads((profiles / "chatgpt-sol-medium.json").read_text())


def test_openhands_llm_profile_materializer_refuses_unmanaged_or_symlink(tmp_path):
    module = load_llm_profile_materializer()
    profiles = tmp_path / "profiles"
    profiles.mkdir()
    target = profiles / "chatgpt-sol-medium.json"
    target.write_text('{"model":"personal"}\n', encoding="utf-8")
    expected = {"chatgpt-sol-medium": module.load_registry(PARITY)["chatgpt-sol-medium"]}
    with pytest.raises(ValueError, match="unmanaged"):
        module.reconcile(profiles, expected, apply=True)

    target.unlink()
    outside = tmp_path / "outside.json"
    outside.write_text("{}\n", encoding="utf-8")
    os.symlink(outside, target)
    with pytest.raises(ValueError, match="non-regular"):
        module.reconcile(profiles, expected, apply=True)
    assert outside.read_text(encoding="utf-8") == "{}\n"


def test_openhands_llm_profile_materializer_removes_only_stale_managed_profiles(tmp_path):
    module = load_llm_profile_materializer()
    profiles = tmp_path / "profiles"
    profiles.mkdir()
    stale = profiles / "retired.json"
    stale.write_text(
        '{"managed_by":"accelerate","managed_schema":1}\n', encoding="utf-8"
    )
    personal = profiles / "personal.json"
    personal.write_text('{"model":"personal"}\n', encoding="utf-8")
    expected = {"chatgpt-sol-medium": module.load_registry(PARITY)["chatgpt-sol-medium"]}
    assert module.reconcile(profiles, expected, apply=False) == 2
    assert module.reconcile(profiles, expected, apply=True) == 0
    assert not stale.exists()
    assert personal.exists()


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
    expected = {
        "default": "DEEPSEEK_API_KEY",
        "deepseek-v4-pro": "DEEPSEEK_API_KEY",
        "deepseek-flash-fast": "DEEPSEEK_API_KEY",
    }
    for name, model in {
        "default": "deepseek/deepseek-v4-flash",
        "deepseek-v4-pro": "deepseek/deepseek-v4-pro",
        "deepseek-flash-fast": "deepseek/deepseek-v4-flash",
    }.items():
        managed = name == "deepseek-flash-fast"
        (profiles / f"{name}.json").write_text(
            json.dumps(
                {
                    "model": model,
                    "auth_type": "api_key",
                    "api_key": "stale",
                    **({"managed_by": "accelerate", "managed_schema": 1} if managed else {}),
                }
            )
            + "\n",
            encoding="utf-8",
        )
    environ = {"DEEPSEEK_API_KEY": "fresh-deepseek"}

    assert module.reconcile(profiles, environ, apply=False, expected=expected) == 3
    assert module.reconcile(profiles, environ, apply=True, expected=expected) == 0
    assert module.reconcile(profiles, environ, apply=False, expected=expected) == 0
    assert json.loads((profiles / "default.json").read_text())["api_key"] == "fresh-deepseek"


def test_openhands_provider_credential_sync_refuses_symlink(tmp_path):
    module = load_credential_sync()
    profiles = tmp_path / "profiles"
    profiles.mkdir()
    outside = tmp_path / "outside.json"
    outside.write_text('{"api_key":"personal"}\n', encoding="utf-8")
    os.symlink(outside, profiles / "default.json")
    with pytest.raises(ValueError, match="non-regular OpenHands LLM profile path"):
        module.reconcile(
            profiles,
            {"DEEPSEEK_API_KEY": "fresh-deepseek"},
            apply=True,
            expected={"default": "DEEPSEEK_API_KEY"},
        )
    assert outside.read_text(encoding="utf-8") == '{"api_key":"personal"}\n'


def test_openhands_provider_credential_sync_refuses_unmanaged_generated_profile(tmp_path):
    module = load_credential_sync()
    profiles = tmp_path / "profiles"
    profiles.mkdir()
    (profiles / "deepseek-flash-fast.json").write_text(
        '{"model":"deepseek/deepseek-v4-flash","auth_type":"api_key"}\n',
        encoding="utf-8",
    )
    with pytest.raises(ValueError, match="refusing to sync unmanaged"):
        module.reconcile(
            profiles,
            {"DEEPSEEK_API_KEY": "fresh-deepseek"},
            apply=True,
            expected={"deepseek-flash-fast": "DEEPSEEK_API_KEY"},
        )


def test_openhands_provider_credential_sync_derives_only_env_backed_candidates():
    module = load_credential_sync()
    expected = module.profile_env(PARITY)
    assert expected["deepseek-flash-fast"] == "DEEPSEEK_API_KEY"
    assert expected["deepseek-pro-reasoning"] == "DEEPSEEK_API_KEY"
    assert "chatgpt-sol-medium" not in expected
    assert "chatgpt-gpt-5.6" not in expected


def test_openhands_governed_skill_materializer_is_safe_and_idempotent(tmp_path):
    module = load_skill_materializer()
    source = tmp_path / "source" / "accelerate"
    (source / "references").mkdir(parents=True)
    (source / "SKILL.md").write_text(
        "---\nname: accelerate\ndescription: governance\n---\n", encoding="utf-8"
    )
    (source / "references" / "guide.md").write_text("guide\n", encoding="utf-8")
    target = tmp_path / "skills"

    assert module.reconcile(target, {"accelerate": source}, apply=False) == 1
    assert module.reconcile(target, {"accelerate": source}, apply=True) == 0
    assert module.reconcile(target, {"accelerate": source}, apply=False) == 0
    assert (target / "accelerate" / "references" / "guide.md").read_text() == "guide\n"

    unmanaged = target / "personal"
    unmanaged.mkdir()
    (unmanaged / "SKILL.md").write_text("personal\n", encoding="utf-8")
    with pytest.raises(ValueError, match="unmanaged"):
        module.reconcile(target, {"personal": source}, apply=True)


def test_openhands_governed_skill_materializer_migrates_only_matching_legacy_link(tmp_path):
    module = load_skill_materializer()
    source = tmp_path / "codex" / "accelerate"
    source.mkdir(parents=True)
    (source / "SKILL.md").write_text(
        "---\nname: accelerate\ndescription: governance\n---\n", encoding="utf-8"
    )
    target = tmp_path / "skills"
    target.mkdir()
    os.symlink(source, target / "accelerate")

    assert module.reconcile(
        target,
        {"accelerate": source},
        apply=False,
        legacy_root=source.parent,
    ) == 1
    assert module.reconcile(
        target,
        {"accelerate": source},
        apply=True,
        legacy_root=source.parent,
    ) == 0
    assert not (target / "accelerate").is_symlink()


def test_openhands_governed_skill_materializer_rejects_broken_legacy_link(tmp_path):
    module = load_skill_materializer()
    source = tmp_path / "source" / "accelerate"
    source.mkdir(parents=True)
    (source / "SKILL.md").write_text(
        "---\nname: accelerate\ndescription: governance\n---\n", encoding="utf-8"
    )
    target = tmp_path / "skills"
    target.mkdir()
    os.symlink(tmp_path / "missing", target / "accelerate")

    with pytest.raises(ValueError, match="unmanaged skill symlink"):
        module.reconcile(
            target,
            {"accelerate": source},
            apply=True,
            legacy_root=source.parent,
        )
