from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

import pytest
import yaml
from jsonschema import Draft202012Validator


REPO = Path(__file__).resolve().parents[1]
SCHEMA_PATH = REPO / "assets/schemas/semantic-implication-receipt.schema.json"
REGISTRY_PATH = REPO / "assets/registries/domain-risk-registry.yaml"
VALIDATOR = REPO / "scripts/validate-semantic-implication.py"
FIXTURES = REPO / "evals/semantic-implication/fixtures"


def run_validator(*paths: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(VALIDATOR), *(str(path) for path in paths)],
        cwd=REPO,
        text=True,
        capture_output=True,
        check=False,
    )


def test_schema_is_closed_and_requires_a_machine_readable_semantic_contract():
    schema = json.loads(SCHEMA_PATH.read_text(encoding="utf-8"))

    assert schema["additionalProperties"] is False
    assert set(schema["required"]) == {
        "schema_version",
        "receipt_id",
        "prompt_binding",
        "domain",
        "capability",
        "invariants",
        "seams",
        "effects",
        "external_effects",
        "reversibility",
        "risk_basis",
        "risk_tier",
        "change_summary",
        "implications",
        "selected_route",
        "required_proof",
        "escalation",
    }
    assert schema["$defs"]["implications"]["minItems"] == 1
    assert schema["$defs"]["implications"]["uniqueItems"] is True


@pytest.mark.parametrize(
    "name",
    [
        "valid-short-refund.yaml",
        "valid-login.yaml",
        "valid-checkout-seam.yaml",
        "valid-migration.yaml",
        "valid-low-risk-typo.yaml",
    ],
)
def test_positive_semantic_implication_receipts_pass(name: str):
    result = run_validator(FIXTURES / name)

    assert result.returncode == 0, result.stderr
    assert "PASS" in result.stdout


@pytest.mark.parametrize(
    ("name", "message"),
    [
        ("invalid-short-refund.yaml", "refund requires implications"),
        ("invalid-login.yaml", "authentication requires implications"),
        ("invalid-checkout-seam.yaml", "checkout-seam requires implications"),
        ("invalid-migration.yaml", "migration requires implications"),
        ("invalid-low-risk-typo.yaml", "editorial requires implications"),
    ],
)
def test_negative_semantic_implication_receipts_fail_closed(name: str, message: str):
    result = run_validator(FIXTURES / name)

    assert result.returncode != 0
    assert message in result.stderr


@pytest.mark.parametrize("name", [
    "invalid-refund-missing-seam.yaml",
    "invalid-refund-missing-effect.yaml",
    "invalid-refund-missing-proof.yaml",
    "invalid-refund-missing-route.yaml",
])
def test_required_operational_decision_fields_fail_closed_when_missing(name: str):
    result = run_validator(FIXTURES / name)

    assert result.returncode != 0
    assert "schema violation" in result.stderr


def test_refund_receipt_carries_financial_provider_and_irreversible_semantics():
    receipt = yaml.safe_load((FIXTURES / "valid-short-refund.yaml").read_text(encoding="utf-8"))

    assert receipt["capability"] == "refund"
    assert receipt["prompt_binding"]["raw_prompt"] == "Refund the duplicate payment now"
    assert receipt["prompt_binding"]["normalized_signals"] == ["duplicate", "payment", "refund"]
    assert {"financial-ledger-integrity", "idempotent-provider-request", "ledger-reconciliation"} <= set(receipt["invariants"])
    assert receipt["seams"] == ["payment-provider"]
    assert {"financial-ledger-write", "refund"} <= set(receipt["effects"])
    assert receipt["external_effects"] == ["payment-provider-refund"]
    assert receipt["reversibility"] == "irreversible-or-constrained"
    assert receipt["selected_route"]["route"] == "orchestrated"
    assert {"idempotency", "ledger-reconciliation", "provider-readback"} <= set(receipt["required_proof"])
    assert receipt["escalation"]["required"] is True


def test_financial_refund_prompt_cannot_be_declared_as_low_risk_editorial_fast_path():
    result = run_validator(FIXTURES / "attack-refund-as-editorial-low-direct.yaml")

    assert result.returncode != 0
    assert "prompt signal refund requires domain refund" in result.stderr


@pytest.mark.parametrize(("name", "message"), [("attack-reimburse-as-editorial-low-direct.yaml", "prompt signal reimburse requires domain refund"), ("attack-unknown-as-editorial-low-direct.yaml", "direct-fast-path receipt is not positively admitted")])
def test_direct_fast_path_requires_positive_editorial_typo_admission(name: str, message: str):
    result = run_validator(FIXTURES / name)
    assert result.returncode != 0
    assert message in result.stderr


def test_migration_signal_cannot_be_declared_as_editorial_direct_fast_path(tmp_path: Path):
    receipt = yaml.safe_load((FIXTURES / "valid-low-risk-typo.yaml").read_text(encoding="utf-8"))
    receipt["prompt_binding"] = {"raw_prompt": "Migration database typo now", "sha256": "40bc801fc33d015075623bce4c30f34b96a3bc8ad932ff583b2d80bebb8558c3", "normalized_prompt": "migration database typo now", "normalized_signals": ["database", "migration", "typo"], "target_kind": "documentation"}
    candidate = tmp_path / "migration-editorial.yaml"
    candidate.write_text(yaml.safe_dump(receipt, sort_keys=False), encoding="utf-8")
    result = run_validator(candidate)
    assert result.returncode != 0
    assert "prompt signal migration requires domain migration" in result.stderr


def test_login_prompt_cannot_be_declared_as_refund(tmp_path: Path):
    receipt = yaml.safe_load((FIXTURES / "valid-login.yaml").read_text(encoding="utf-8"))
    receipt["domain"] = "refund"
    candidate = tmp_path / "login-refund.yaml"
    candidate.write_text(yaml.safe_dump(receipt, sort_keys=False), encoding="utf-8")
    result = run_validator(candidate)
    assert result.returncode != 0
    assert "prompt signal login requires domain authentication" in result.stderr


@pytest.mark.parametrize("duplicate", [
    "domain: refund\ndomain: editorial",
    "prompt_binding: {raw_prompt: Refund the duplicate payment now}\nprompt_binding: {raw_prompt: Correct a typo in a non-operative label.}",
    "risk_tier: critical\nrisk_tier: low",
])
def test_receipt_duplicate_keys_fail_closed(tmp_path: Path, duplicate: str):
    candidate = tmp_path / "duplicate.yaml"
    candidate.write_text((FIXTURES / "valid-low-risk-typo.yaml").read_text(encoding="utf-8") + "\n" + duplicate + "\n", encoding="utf-8")
    result = run_validator(candidate)
    assert result.returncode != 0
    assert "duplicate key" in result.stderr


def test_registry_duplicate_keys_fail_closed(tmp_path: Path):
    registry = tmp_path / "registry.yaml"
    registry.write_text((REGISTRY_PATH.read_text(encoding="utf-8")) + "\nrisk_order: [low]\n", encoding="utf-8")
    # Exercise the same loader through a temporary repository-local registry replacement.
    import importlib.util
    spec = importlib.util.spec_from_file_location("semantic_validator", VALIDATOR)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    with pytest.raises(ValueError, match="duplicate key"):
        module.load_yaml(registry)


def test_governed_anchor_rejects_coordinated_registry_drift(tmp_path: Path):
    import importlib.util
    candidate = tmp_path / "domain-risk-registry.yaml"
    candidate.write_text(REGISTRY_PATH.read_text(encoding="utf-8").replace("required_signals: [typo]", "required_signals: [refund, typo]"), encoding="utf-8")
    spec = importlib.util.spec_from_file_location("semantic_validator_anchor", VALIDATOR)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    with pytest.raises(ValueError, match="governed semantic anchor mismatch"):
        module.verify_anchor(candidate, module.REGISTRY_SHA256)


@pytest.mark.parametrize("raw_prompt", [
    "Correct a typo in a non-operative label. ＲＥＦＵＮＤ",
    "Correct a typo in a non-operative label.\u200b",
    "Correct a typo in a non-operative label. РЕФUND",
])
def test_non_ascii_or_unicode_confusable_prompt_cannot_use_direct_fast_path(tmp_path: Path, raw_prompt: str):
    import hashlib
    receipt = yaml.safe_load((FIXTURES / "valid-low-risk-typo.yaml").read_text(encoding="utf-8"))
    receipt["prompt_binding"]["raw_prompt"] = raw_prompt
    receipt["prompt_binding"]["sha256"] = hashlib.sha256(raw_prompt.encode()).hexdigest()
    normalized = "correct a typo in a non operative label refund" if "Ｒ" in raw_prompt else "correct a typo in a non operative label"
    receipt["prompt_binding"]["normalized_prompt"] = normalized
    receipt["prompt_binding"]["normalized_signals"] = ["refund", "typo"] if "Ｒ" in raw_prompt else ["typo"]
    candidate = tmp_path / "unicode-direct.yaml"
    candidate.write_text(yaml.safe_dump(receipt, sort_keys=False, allow_unicode=True), encoding="utf-8")
    result = run_validator(candidate)
    assert result.returncode != 0


def test_registry_rules_are_enforced_in_addition_to_closed_schema(tmp_path: Path):
    valid = yaml.safe_load((FIXTURES / "valid-login.yaml").read_text(encoding="utf-8"))
    valid["risk_tier"] = "low"
    candidate = tmp_path / "understated-login.yaml"
    candidate.write_text(yaml.safe_dump(valid, sort_keys=False), encoding="utf-8")

    result = run_validator(candidate)

    assert result.returncode != 0
    assert "risk_tier low is below authentication minimum critical" in result.stderr


def test_schema_rejects_unknown_receipt_fields():
    schema = json.loads(SCHEMA_PATH.read_text(encoding="utf-8"))
    receipt = yaml.safe_load((FIXTURES / "valid-low-risk-typo.yaml").read_text(encoding="utf-8"))
    receipt["unreviewed_exception"] = True

    errors = list(Draft202012Validator(schema).iter_errors(receipt))

    assert any("Additional properties are not allowed" in error.message for error in errors)
