from __future__ import annotations

import importlib.util
import io
import subprocess
import sys
from pathlib import Path


ADAPTER = (
    Path(__file__).resolve().parents[1]
    / "adapters/runtime/model-lanes/run-codex-model-lane.py"
)


def load_adapter():
    spec = importlib.util.spec_from_file_location("codex_model_lane", ADAPTER)
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
