from __future__ import annotations

import subprocess
import sys
from shutil import copytree
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
VALIDATOR = REPO / "scripts/validate-other-runtime-adapters.py"


def test_other_runtime_adapter_contracts_are_fail_closed_and_complete():
    result = subprocess.run(
        [sys.executable, str(VALIDATOR)], cwd=REPO, text=True, capture_output=True, check=False
    )
    assert result.returncode == 0, result.stderr
    assert "PASS" in result.stdout


def test_other_runtime_adapter_contracts_reject_an_optimistic_registry(tmp_path):
    registry = REPO / "adapters/runtime/runtime-consumer-registry.json"
    candidate = tmp_path / "registry.json"
    candidate.write_text(registry.read_text(encoding="utf-8").replace('"status": "export-only"', '"status": "supported"'), encoding="utf-8")
    result = subprocess.run(
        [sys.executable, str(VALIDATOR), "--registry", str(candidate)],
        cwd=REPO, text=True, capture_output=True, check=False,
    )
    assert result.returncode != 0
    assert "FAIL" in result.stderr


def test_other_runtime_adapter_contracts_reject_reviewer_adversarial_cases(tmp_path):
    runtime = tmp_path / "adapters/runtime"
    for name in ("opencode", "openclaw", "claude"):
        copytree(REPO / "adapters/runtime" / name, runtime / name)
    (tmp_path / "core/control-plane").mkdir(parents=True)
    (tmp_path / "core/delegation").mkdir(parents=True)
    (tmp_path / "core/control-plane/runtime-adapter-maturity-dashboard.md").write_text((REPO / "core/control-plane/runtime-adapter-maturity-dashboard.md").read_text(encoding="utf-8"), encoding="utf-8")
    (tmp_path / "core/delegation/runtime-neutral-delegation.schema.json").write_text((REPO / "core/delegation/runtime-neutral-delegation.schema.json").read_text(encoding="utf-8"), encoding="utf-8")
    (tmp_path / "tests").mkdir()
    (tmp_path / "tests/test_other_runtime_adapters.py").write_text("fixture", encoding="utf-8")
    (tmp_path / "adapters/runtime/other-runtime-adapters.policy.json").write_text((REPO / "adapters/runtime/other-runtime-adapters.policy.json").read_text(encoding="utf-8"), encoding="utf-8")
    registry = tmp_path / "registry.json"
    registry.write_text((REPO / "adapters/runtime/runtime-consumer-registry.json").read_text(encoding="utf-8"), encoding="utf-8")
    def run() -> subprocess.CompletedProcess[str]:
        return subprocess.run([sys.executable, str(VALIDATOR), "--root", str(tmp_path), "--registry", str(registry)], cwd=REPO, text=True, capture_output=True, check=False)

    cases = {
            "wildcard-tools": (runtime / "opencode/capabilities.yaml", "allowed_current_tools: []", "allowed_current_tools: ['*']", "opencode manifest renderer hash mismatch"),
            "xhigh-effort": (runtime / "opencode/delegation-contract.md", '"forbidden_efforts": ["xhigh", "max"]', '"forbidden_efforts": ["max"]', "opencode contract renderer hash mismatch"),
            "standalone-designer": (runtime / "opencode/delegation-contract.md", '"forbidden_roles": ["designer", "observer", "council"]', '"forbidden_roles": ["observer", "council"]', "opencode contract renderer hash mismatch"),
            "openclaw-current-spawn": (runtime / "openclaw/capabilities.yaml", "allowed_current_tools: []", "allowed_current_tools: [sessions-spawn]", "openclaw manifest renderer hash mismatch"),
            "claude-callability": (registry, '"runtime": "claude",\n      "status": "export-only"', '"runtime": "claude",\n      "status": "supported"', "claude registry status/projection drift"),
            "appended-contradiction": (runtime / "claude/delegation-contract.md", "<!-- accelerate-runtime-policy", "Contradictory supported callability\n<!-- accelerate-runtime-policy", "claude contract renderer hash mismatch"),
            "visible-row-drift": (tmp_path / "core/control-plane/runtime-adapter-maturity-dashboard.md", "| OpenCode / OMO-Slim task projection", "| Drifted / OMO-Slim task projection", "opencode visible dashboard row or metadata drift"),
                    "unsafe-registry-proof": (registry, "static-contract-only; runtime callability unproven", "live callable proof", "opencode unsafe registry proof/install/readback/rollback claim"),
            "empty-proof": (runtime / "opencode/capabilities.yaml", "proof_artifacts: [adapters/runtime/opencode/delegation-contract.md, tests/test_other_runtime_adapters.py]", "proof_artifacts: []", "opencode manifest renderer hash mismatch"),
            "removed-effective-receipt": (tmp_path / "adapters/runtime/other-runtime-adapters.policy.json", '"effective_model_receipt_required": true', '"effective_model_receipt_required": false', "opencode effective-model/effort receipt requirement removed"),
            "extra-structured-key": (tmp_path / "adapters/runtime/other-runtime-adapters.policy.json", '"type": "runtime-reference", "runtime_status"', '"type": "runtime-reference", "optimistic": true, "runtime_status"', "opencode machine policy contains unknown or missing key"),
    }
    for _name, (path, before, after, expected) in cases.items():
        original = path.read_text(encoding="utf-8")
        assert before in original
        path.write_text(original.replace(before, after, 1), encoding="utf-8")
        result = run()
        assert result.returncode != 0, _name
        assert expected in result.stderr, result.stderr
        path.write_text(original, encoding="utf-8")
