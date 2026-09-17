from __future__ import annotations

import json
import shutil
import subprocess
import sys
from pathlib import Path

import pytest
import yaml


REPO = Path(__file__).resolve().parents[1]
CATALOG = REPO / "catalog"
ALLOWED_MODES = {"native-direct", "symlink", "generated-projection", "api-projection"}
VALIDATOR = REPO / "scripts/validate-harness-catalog.py"


def load(name: str) -> dict:
    return yaml.safe_load((CATALOG / name).read_text(encoding="utf-8"))


def test_catalog_has_unique_repository_owned_harnesses_and_existing_sources():
    catalog = load("catalog.yaml")
    assert catalog["authority"]["canonical_source"] == "repository"
    assert catalog["authority"]["installed_discovery_catalog"] == "~/.agents"
    assert catalog["authority"]["installed_catalog_role"] == "discovery-only"
    ids = [entry["id"] for entry in catalog["assets"]]
    assert len(ids) == len(set(ids))
    assert all(entry["kind"] == "harness" for entry in catalog["assets"])
    for entry in catalog["assets"]:
        assert (REPO / entry["source_path"]).is_file()
        assert entry["lifecycle_state"] == "defined"


def catalog_fixture(tmp_path: Path) -> Path:
    for relative in ("catalog", "references/harnesses"):
        shutil.copytree(REPO / relative, tmp_path / relative)
    (tmp_path / "adapters/runtime").mkdir(parents=True)
    for name in ("runtime-consumer-registry.json", "cross-runtime-bootstrap-manifest.json"):
        shutil.copy2(REPO / "adapters/runtime" / name, tmp_path / "adapters/runtime" / name)
    return tmp_path


def validate(root: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(VALIDATOR), "--root", str(root)],
        cwd=REPO,
        text=True,
        capture_output=True,
        check=False,
    )


def test_catalog_validator_accepts_repository_catalog():
    result = validate(REPO)
    assert result.returncode == 0, result.stderr
    assert "PASS harness catalog" in result.stdout


def test_namespace_guards_huggingface_accelerate_collision():
    namespaces = load("namespaces.yaml")
    policy = namespaces["collision_policy"]
    exception = policy["external_distribution_exception"]
    assert policy["unqualified_lookup"] == "denied"
    assert "accelerate" in namespaces["namespaces"][0]["reserved_unqualified_names"]
    assert exception["distribution"] == "huggingface-accelerate"
    assert exception["required_identifier"].startswith("external.huggingface.")
    assert policy["resolution_on_collision"] == "block-and-report"


def test_lifecycle_and_harness_projection_modes_are_closed_and_receipted():
    lifecycle = load("lifecycle.yaml")
    states = lifecycle["states"]
    assert states == ["defined", "registered", "projected", "loader-confirmed", "callable", "authorized", "retired"]
    assert all(rule["required_receipt"] for rule in lifecycle["rules"])
    for source in (REPO / "references/harnesses").glob("*.md"):
        body = source.read_text(encoding="utf-8")
        mode = next(line.split("`", 2)[1] for line in body.splitlines() if line.startswith("- Projection mode:"))
        assert mode in ALLOWED_MODES


def test_catalog_validator_rejects_source_path_traversal(tmp_path):
    root = catalog_fixture(tmp_path)
    catalog = root / "catalog/catalog.yaml"
    catalog.write_text(
        catalog.read_text(encoding="utf-8").replace(
            "references/harnesses/codex.md", "../outside.md", 1
        ),
        encoding="utf-8",
    )
    result = validate(root)
    assert result.returncode != 0
    assert "traversal-free" in result.stderr


def test_catalog_validator_rejects_symlinked_source_target(tmp_path):
    root = catalog_fixture(tmp_path)
    target = root / "references/harnesses/codex.md"
    outside = tmp_path.parent / "catalog-outside.md"
    outside.write_text("outside", encoding="utf-8")
    target.unlink()
    target.symlink_to(outside)
    result = validate(root)
    assert result.returncode != 0
    assert "symlink" in result.stderr


def test_catalog_validator_rejects_symlinked_source_ancestor(tmp_path):
    root = catalog_fixture(tmp_path)
    external_references = tmp_path.parent / "catalog-external-references"
    shutil.copytree(root / "references", external_references)
    shutil.rmtree(root / "references")
    (root / "references").symlink_to(external_references, target_is_directory=True)
    result = validate(root)
    assert result.returncode != 0
    assert "symlink" in result.stderr


def test_catalog_validator_rejects_callability_overclaim_and_unregistered_advance(tmp_path):
    root = catalog_fixture(tmp_path)
    catalog = root / "catalog/catalog.yaml"
    content = catalog.read_text(encoding="utf-8")
    catalog.write_text(content.replace("lifecycle_state: defined", "lifecycle_state: callable", 1), encoding="utf-8")
    result = validate(root)
    assert result.returncode != 0
    assert "source-only catalog cannot advance lifecycle_state above defined" in result.stderr

    catalog.write_text(content.replace("lifecycle_state: defined", "lifecycle_state: registered", 1), encoding="utf-8")
    result = validate(root)
    assert result.returncode != 0
    assert "source-only catalog cannot advance lifecycle_state above defined" in result.stderr

    catalog.write_text(content.replace("lifecycle_state: defined", "lifecycle_state: projected", 1), encoding="utf-8")
    result = validate(root)
    assert result.returncode != 0
    assert "source-only catalog cannot advance lifecycle_state above defined" in result.stderr


def test_catalog_validator_rejects_cross_wired_consumer_or_bootstrap_registry(tmp_path):
    root = catalog_fixture(tmp_path)
    catalog = root / "catalog/catalog.yaml"
    content = catalog.read_text(encoding="utf-8")
    catalog.write_text(
        content.replace("runtime_registry: {consumer: codex, bootstrap: codex}", "runtime_registry: {consumer: claude, bootstrap: codex}", 1),
        encoding="utf-8",
    )
    result = validate(root)
    assert result.returncode != 0
    assert "registry identity must bind" in result.stderr
    catalog.write_text(
        content.replace("runtime_registry: {consumer: codex, bootstrap: codex}", "runtime_registry: {consumer: codex, bootstrap: claude}", 1),
        encoding="utf-8",
    )
    result = validate(root)
    assert result.returncode != 0
    assert "registry identity must bind" in result.stderr


def test_catalog_validator_rejects_alias_cross_wire(tmp_path):
    root = catalog_fixture(tmp_path)
    catalog = root / "catalog/catalog.yaml"
    catalog.write_text(
        catalog.read_text(encoding="utf-8")
        + "\nruntime_registry_aliases:\n  codex:\n    runtime_identity: claude\n    consumer: claude\n    bootstrap: claude\n",
        encoding="utf-8",
    )
    result = validate(root)
    assert result.returncode != 0
    assert "may not redirect canonical identity" in result.stderr


def test_catalog_validator_rejects_source_path_identity_swap(tmp_path):
    root = catalog_fixture(tmp_path)
    catalog = root / "catalog/catalog.yaml"
    catalog.write_text(
        catalog.read_text(encoding="utf-8").replace(
            "source_path: references/harnesses/codex.md",
            "source_path: references/harnesses/claude.md",
            1,
        ),
        encoding="utf-8",
    )
    result = validate(root)
    assert result.returncode != 0
    assert "source_path must bind to its canonical harness identity" in result.stderr


def test_catalog_validator_rejects_coordinated_harness_mode_and_claim_drift(tmp_path):
    root = catalog_fixture(tmp_path)
    harness = root / "references/harnesses/codex.md"
    harness.write_text(
        harness.read_text(encoding="utf-8")
        .replace("Projection mode: `native-direct`", "Projection mode: `generated-projection`")
        .replace("Current claim: catalog definition only.", "Current claim: generated projection is callable."),
        encoding="utf-8",
    )
    result = validate(root)
    assert result.returncode != 0
    assert "canonical harness drift: references/harnesses/codex.md" in result.stderr


def test_catalog_validator_rejects_unknown_asset_authorization_field(tmp_path):
    root = catalog_fixture(tmp_path)
    catalog = root / "catalog/catalog.yaml"
    catalog.write_text(
        catalog.read_text(encoding="utf-8").replace(
            "    lifecycle_state: defined\n    runtime_registry: {consumer: codex, bootstrap: codex}",
            "    lifecycle_state: defined\n    implementation_authorized: true\n    runtime_registry: {consumer: codex, bootstrap: codex}",
            1,
        ),
        encoding="utf-8",
    )
    result = validate(root)
    assert result.returncode != 0
    assert "catalog asset has unknown or missing keys" in result.stderr


def test_catalog_validator_rejects_duplicate_lifecycle_state_key(tmp_path):
    root = catalog_fixture(tmp_path)
    catalog = root / "catalog/catalog.yaml"
    catalog.write_text(
        catalog.read_text(encoding="utf-8").replace(
            "    lifecycle_state: defined\n    runtime_registry: {consumer: codex, bootstrap: codex}",
            "    lifecycle_state: callable\n    lifecycle_state: defined\n    runtime_registry: {consumer: codex, bootstrap: codex}",
            1,
        ),
        encoding="utf-8",
    )
    result = validate(root)
    assert result.returncode != 0
    assert "duplicate YAML key: 'lifecycle_state'" in result.stderr


def test_catalog_validator_rejects_any_projected_state_even_with_receipts(tmp_path):
    root = catalog_fixture(tmp_path)
    catalog = yaml.safe_load((root / "catalog/catalog.yaml").read_text(encoding="utf-8"))
    codex = catalog["assets"][0]
    codex["lifecycle_state"] = "projected"
    codex["lifecycle_receipts"] = []
    (root / "catalog/catalog.yaml").write_text(yaml.safe_dump(catalog, sort_keys=False), encoding="utf-8")
    result = validate(root)
    assert result.returncode != 0
    assert "source-only catalog cannot advance lifecycle_state above defined" in result.stderr


def test_catalog_validator_rejects_authority_and_asset_semantic_overclaims(tmp_path):
    root = catalog_fixture(tmp_path)
    catalog = root / "catalog/catalog.yaml"
    original = catalog.read_text(encoding="utf-8")
    cases = {
        "installed-source": ("canonical_source: repository", "canonical_source: installed-runtime", "canonical_source must be repository"),
        "catalog-promotion": ("promotion: separate-receipt-required-not-authorized-by-catalog", "promotion: authorized-by-catalog", "promotion must remain separately authorized"),
        "attacker-namespace": ("namespace: prop4you.accelerate.harness", "namespace: attacker.namespace", "namespace or kind is not allowlisted"),
        "runtime-authority-kind": ("kind: harness", "kind: runtime-authority", "namespace or kind is not allowlisted"),
    }
    for _name, (before, after, error) in cases.items():
        catalog.write_text(original.replace(before, after, 1), encoding="utf-8")
        result = validate(root)
        assert result.returncode != 0
        assert error in result.stderr
    catalog.write_text(original, encoding="utf-8")


def test_catalog_validator_rejects_collision_policy_and_duplicate_consumer_runtime(tmp_path):
    root = catalog_fixture(tmp_path)
    namespaces = root / "catalog/namespaces.yaml"
    original = namespaces.read_text(encoding="utf-8")
    for before, after in (("unqualified_lookup: denied", "unqualified_lookup: allowed"), ("resolution_on_collision: block-and-report", "resolution_on_collision: prefer-external")):
        namespaces.write_text(original.replace(before, after, 1), encoding="utf-8")
        result = validate(root)
        assert result.returncode != 0
        assert "collision policy must deny unqualified lookup and block collisions" in result.stderr
    namespaces.write_text(original, encoding="utf-8")

    registry = root / "adapters/runtime/runtime-consumer-registry.json"
    payload = json.loads(registry.read_text(encoding="utf-8"))
    payload["consumers"].append(payload["consumers"][0].copy())
    registry.write_text(json.dumps(payload), encoding="utf-8")
    result = validate(root)
    assert result.returncode != 0
    assert "duplicate runtime IDs" in result.stderr


@pytest.mark.parametrize(
    ("relative", "before", "after"),
    [
        ("catalog/catalog.yaml", "installed_catalog_role: discovery-only", "installed_catalog_role: runtime-authority"),
        ("catalog/catalog.yaml", "This repository owns catalog definitions.", "This repository authorizes install/activation and owns catalog definitions."),
        ("catalog/catalog.yaml", "Any lifecycle_state above defined requires", "No receipts"),
        ("catalog/provenance.yaml", "authority: discovery-only", "authority: runtime-authority"),
        ("catalog/namespaces.yaml", "comparison: exact-after-casefold", "comparison: substring-prefer-external"),
        ("catalog/lifecycle.yaml", "from: defined", "from: authorized"),
        ("catalog/lifecycle.yaml", "required_evidence_kind: catalog-validation-readback", "required_evidence_kind: none"),
    ],
)
def test_catalog_validator_rejects_all_governing_scalar_mutations(tmp_path, relative, before, after):
    root = catalog_fixture(tmp_path)
    path = root / relative
    content = path.read_text(encoding="utf-8")
    assert before in content
    path.write_text(content.replace(before, after, 1), encoding="utf-8")
    result = validate(root)
    assert result.returncode != 0
    assert "FAIL harness catalog:" in result.stderr
