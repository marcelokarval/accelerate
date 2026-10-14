from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
INSPECTOR = ROOT / "scripts/inspect-opencode-host.py"


def write_json(path: Path, value: dict) -> None:
    path.write_text(json.dumps(value, separators=(",", ":")), encoding="utf-8")


def fixture(tmp_path: Path, *, accelerate: bool = False, secret_plugin: bool = False) -> list[str]:
    opencode_package = tmp_path / "opencode-package.json"
    opencode_config = tmp_path / "opencode.json"
    slim_package = tmp_path / "slim-package.json"
    slim_config = tmp_path / "slim.json"
    plugins = [
        str(tmp_path / "npm/oh-my-opencode-slim@2.2.24/node_modules/oh-my-opencode-slim/dist/server"),
    ]
    if accelerate:
        plugins.append(str(tmp_path / "plugins/accelerate-plugin.js"))
    if secret_plugin:
        plugins.append("https://user:password@example.test/plugin?token=do-not-print&channel=stable#private")
    write_json(opencode_package, {"name": "@opencode/cli", "version": "2.0.26"})
    write_json(opencode_config, {
        "plugin": plugins,
        "default_agent": "orchestrator",
        "provider": {"private": {"apiKey": "do-not-print"}},
    })
    write_json(slim_package, {"name": "oh-my-opencode-slim", "version": "2.2.24", "type": "module"})
    write_json(slim_config, {
        "preset": "openai",
        "presets": {"openai": {
            "orchestrator": {"model": "secret-model-value", "skills": ["*"], "mcps": ["*", "!context7"]},
            "designer": {"model": "secret-designer-value"},
            "council": {"model": "secret-council-value"},
        }},
        "council": {"presets": {"private": {"member": {"model": "secret-councillor-value"}}}},
    })
    return [
        sys.executable,
        str(INSPECTOR),
        "--opencode-package", str(opencode_package),
        "--opencode-config", str(opencode_config),
        "--slim-package", str(slim_package),
        "--slim-config", str(slim_config),
    ]


def run(command: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=False)


def test_inspector_emits_a_redacted_fail_closed_receipt(tmp_path):
    command = fixture(tmp_path, secret_plugin=True)
    result = run(command)
    assert result.returncode == 0, result.stderr
    assert "do-not-print" not in result.stdout
    assert "secret-model-value" not in result.stdout
    receipt = json.loads(result.stdout)
    assert receipt["schema_version"] == "accelerate.opencode-host-inspection/1"
    assert receipt["runtime_status"] == "blocked"
    assert receipt["consumer_disposition"] == "manual_handoff_required"
    assert receipt["packages"] == {
        "omo_slim": {"name": "oh-my-opencode-slim", "version": "2.2.24"},
        "opencode": {"name": "@opencode/cli", "version": "2.0.26"},
    }
    assert receipt["configuration"]["default_agent"] == "orchestrator"
    assert receipt["configuration"]["omo_slim_preset"] == "openai"
    assert "[redacted]" in receipt["configuration"]["plugin_declarations"][-1]
    assert receipt["capabilities"]["omo_slim_declared"] is True
    assert receipt["capabilities"]["omo_slim_package_identity_matches"] is True
    assert receipt["capabilities"]["accelerate_loader_declared"] is False
    assert receipt["capabilities"]["omo_slim_loaded_observed"] is False
    assert receipt["capabilities"]["cli_readback_observed"] is False
    assert receipt["capabilities"]["asds_execution_consumer_host_qualified"] is False
    assert receipt["capabilities"]["wildcard_skills_declared"] is True
    assert receipt["capabilities"]["wildcard_mcps_declared"] is True
    assert len(receipt["evidence"]) == 4
    for item in receipt["evidence"]:
        body = Path(item["path"]).read_bytes()
        assert item["sha256"] == hashlib.sha256(body).hexdigest()
        assert item["size"] == len(body)


def test_accelerate_declaration_does_not_claim_loader_or_consumer_qualification(tmp_path):
    result = run(fixture(tmp_path, accelerate=True))
    assert result.returncode == 0, result.stderr
    receipt = json.loads(result.stdout)
    capabilities = receipt["capabilities"]
    assert capabilities["accelerate_loader_declared"] is True
    assert capabilities["accelerate_loader_loaded_observed"] is False
    assert capabilities["asds_execution_consumer_host_qualified"] is False
    assert "accelerate_loader_not_declared" not in receipt["blockers"]
    assert "accelerate_loader_runtime_readback_missing" in receipt["blockers"]
    assert receipt["runtime_status"] == "blocked"


def test_slim_declaration_version_drift_fails_closed_without_guessing(tmp_path):
    command = fixture(tmp_path)
    config_path = Path(command[command.index("--opencode-config") + 1])
    config = json.loads(config_path.read_text(encoding="utf-8"))
    config["plugin"][0] = config["plugin"][0].replace("@2.2.24", "@2.2.23")
    write_json(config_path, config)
    result = run(command)
    assert result.returncode == 0, result.stderr
    receipt = json.loads(result.stdout)
    assert receipt["capabilities"]["omo_slim_package_identity_matches"] is False
    assert "omo_slim_identity_unverified" in receipt["blockers"]
    assert receipt["consumer_disposition"] == "manual_handoff_required"


def test_inspector_rejects_symlinked_inputs_and_reports_only_a_closed_error(tmp_path):
    command = fixture(tmp_path)
    package_path = Path(command[command.index("--slim-package") + 1])
    target = tmp_path / "outside.json"
    target.write_text('{"secret":"must-not-leak"}', encoding="utf-8")
    package_path.unlink()
    package_path.symlink_to(target)
    result = run(command)
    assert result.returncode == 2
    assert result.stdout == ""
    assert "must-not-leak" not in result.stderr
    error = json.loads(result.stderr)
    assert error["error"]["code"] == "slim_package_not_regular_file"


def test_inspector_rejects_ambiguous_plugin_fields(tmp_path):
    command = fixture(tmp_path)
    config_path = Path(command[command.index("--opencode-config") + 1])
    config = json.loads(config_path.read_text(encoding="utf-8"))
    config["plugins"] = []
    write_json(config_path, config)
    result = run(command)
    assert result.returncode == 2
    assert json.loads(result.stderr)["error"]["code"] == "opencode_config_ambiguous_plugin_fields"


def test_inspector_redacts_malformed_or_sensitive_plugin_declarations(tmp_path):
    command = fixture(tmp_path)
    config_path = Path(command[command.index("--opencode-config") + 1])
    config = json.loads(config_path.read_text(encoding="utf-8"))
    config["plugin"] += ["https://example.test:bad/plugin", "/plugins/private-token-value.js"]
    write_json(config_path, config)
    result = run(command)
    assert result.returncode == 0, result.stderr
    assert "private-token-value" not in result.stdout
    declarations = json.loads(result.stdout)["configuration"]["plugin_declarations"]
    assert "[redacted-invalid-plugin-declaration]" in declarations
    assert "[redacted]" in declarations


def test_inspector_source_has_no_runtime_or_sensitive_file_dependency():
    source = INSPECTOR.read_text(encoding="utf-8")
    for forbidden in ("subprocess", "auth.json", "opencode.log", "urlopen", "requests.", "write_text", "write_bytes"):
        assert forbidden not in source
