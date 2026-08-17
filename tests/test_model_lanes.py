from __future__ import annotations

import importlib.util
import io
import subprocess
import sys
import tomllib
from pathlib import Path


ADAPTER = (
    Path(__file__).resolve().parents[1]
    / "adapters/runtime/model-lanes/run-codex-model-lane.py"
)
PARITY = ADAPTER.parent / "cross-runtime-agent-parity.toml"
MATERIALIZER = ADAPTER.parents[3] / "scripts/install-openhands-agent-bindings.py"


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
