from __future__ import annotations

import importlib.util
import json
from pathlib import Path

import pytest


REPO = Path(__file__).resolve().parents[1]
INSTALLER = REPO / "scripts/install-operational-skills.py"


def load_installer():
    spec = importlib.util.spec_from_file_location("operational_skill_installer", INSTALLER)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def fixture(tmp_path: Path) -> tuple[Path, Path, Path]:
    root = tmp_path / "repo"
    source = root / "skills/operations/example-operations"
    source.mkdir(parents=True)
    (source / "SKILL.md").write_text(
        "---\nname: example-operations\ndescription: fixture\n---\n# Example\n",
        encoding="utf-8",
    )
    registry = root / "registry.toml"
    registry.write_text(
        "schema_version = 1\n"
        'managed_by = "accelerate"\n'
        'marker = ".accelerate-operational-skill.json"\n\n'
        "[[skills]]\n"
        'name = "example-operations"\n'
        'source = "skills/operations/example-operations"\n\n'
        "[[targets]]\n"
        'runtime = "opencode"\n'
        'home_suffix = ".config/opencode/skills"\n\n'
        "[[targets]]\n"
        'runtime = "agents"\n'
        'home_suffix = ".agents/skills"\n\n'
        "[[targets]]\n"
        'runtime = "codex"\n'
        'home_suffix = ".codex/skills"\n\n'
        "[[targets]]\n"
        'runtime = "hermes"\n'
        'home_suffix = ".hermes/skills/runtime"\n',
        encoding="utf-8",
    )
    home = tmp_path / "home"
    home.mkdir()
    return root, registry, home


def test_dry_run_reports_drift_without_writing(tmp_path):
    root, registry, home = fixture(tmp_path)
    result = load_installer().reconcile(
        "opencode", home=home, registry_path=registry, repo_root=root, apply=False
    )
    assert result == {"drift": 1, "changed": [], "rollback_id": None}
    assert not (home / ".config").exists()


def test_apply_creates_digest_marker_and_is_idempotent(tmp_path):
    root, registry, home = fixture(tmp_path)
    module = load_installer()
    result = module.reconcile(
        "opencode",
        home=home,
        registry_path=registry,
        repo_root=root,
        apply=True,
        run_id="20260821T120000Z-opencode",
    )
    destination = home / ".config/opencode/skills/example-operations"
    marker = json.loads((destination / module.MARKER).read_text(encoding="utf-8"))
    assert result["changed"] == ["example-operations"]
    assert result["rollback_id"] == "20260821T120000Z-opencode"
    assert marker["runtime"] == "opencode"
    assert marker["source_digest"] == module.tree_digest(
        root / "skills/operations/example-operations"
    )
    second = module.reconcile(
        "opencode", home=home, registry_path=registry, repo_root=root, apply=True
    )
    assert second == {"drift": 0, "changed": [], "rollback_id": None}


def test_refuses_unmanaged_target(tmp_path):
    root, registry, home = fixture(tmp_path)
    destination = home / ".config/opencode/skills/example-operations"
    destination.mkdir(parents=True)
    (destination / "SKILL.md").write_text("user owned\n", encoding="utf-8")
    with pytest.raises(ValueError, match="unmanaged"):
        load_installer().reconcile(
            "opencode", home=home, registry_path=registry, repo_root=root, apply=True
        )


def test_source_symlink_is_rejected(tmp_path):
    root, registry, home = fixture(tmp_path)
    source = root / "skills/operations/example-operations"
    (source / "unsafe").symlink_to(source / "SKILL.md")
    with pytest.raises(ValueError, match="unsafe source"):
        load_installer().reconcile(
            "opencode", home=home, registry_path=registry, repo_root=root, apply=False
        )


def test_rollback_restores_previous_managed_tree(tmp_path):
    root, registry, home = fixture(tmp_path)
    module = load_installer()
    module.reconcile(
        "opencode",
        home=home,
        registry_path=registry,
        repo_root=root,
        apply=True,
        run_id="20260821T120000Z-opencode",
    )
    source = root / "skills/operations/example-operations/SKILL.md"
    original = source.read_text(encoding="utf-8")
    source.write_text(original + "updated\n", encoding="utf-8")
    module.reconcile(
        "opencode",
        home=home,
        registry_path=registry,
        repo_root=root,
        apply=True,
        run_id="20260821T120001Z-opencode",
    )
    module.rollback(
        "opencode",
        "20260821T120001Z-opencode",
        home=home,
        registry_path=registry,
        repo_root=root,
    )
    installed = home / ".config/opencode/skills/example-operations/SKILL.md"
    assert installed.read_text(encoding="utf-8") == original


def test_rollback_removes_first_install_only_while_marker_matches(tmp_path):
    root, registry, home = fixture(tmp_path)
    module = load_installer()
    run_id = "20260821T120000Z-opencode"
    module.reconcile(
        "opencode", home=home, registry_path=registry, repo_root=root,
        apply=True, run_id=run_id,
    )
    destination = home / ".config/opencode/skills/example-operations"
    module.rollback(
        "opencode", run_id, home=home, registry_path=registry, repo_root=root
    )
    assert not destination.exists()


def test_registry_rejects_path_traversal_and_duplicate_names(tmp_path):
    root, registry, home = fixture(tmp_path)
    content = registry.read_text(encoding="utf-8")
    registry.write_text(
        content.replace(
            'source = "skills/operations/example-operations"',
            'source = "../outside"',
        ),
        encoding="utf-8",
    )
    with pytest.raises(ValueError, match="source path"):
        load_installer().reconcile(
            "opencode", home=home, registry_path=registry, repo_root=root, apply=False
        )


def test_unmanaged_directory_is_never_deleted(tmp_path: Path):
    root, registry, home = fixture(tmp_path)
    module = load_installer()
    target = home / ".config/opencode/skills/example-operations"
    target.mkdir(parents=True)
    secret_file = target / "unmanaged-secret.txt"
    secret_file.write_text("critical data", encoding="utf-8")

    with pytest.raises(ValueError, match="refusing unmanaged skill"):
        module.reconcile(
            "opencode", home=home, registry_path=registry, repo_root=root, apply=True
        )

    assert secret_file.exists(), "unmanaged target must never be deleted"
    assert secret_file.read_text(encoding="utf-8") == "critical data"


def test_rollback_refused_after_drift(tmp_path: Path):
    root, registry, home = fixture(tmp_path)
    module = load_installer()
    run_id = "20260821T120000Z-opencode"
    module.reconcile(
        "opencode", home=home, registry_path=registry, repo_root=root,
        apply=True, run_id=run_id,
    )
    destination = home / ".config/opencode/skills/example-operations"
    # Cause drift by changing the marker digest
    marker = destination / ".accelerate-operational-skill.json"
    data = json.loads(marker.read_text(encoding="utf-8"))
    data["source_digest"] = "drifted"
    marker.write_text(json.dumps(data), encoding="utf-8")

    with pytest.raises(ValueError, match="refusing rollback after target drift"):
        module.rollback("opencode", run_id, home=home, registry_path=registry, repo_root=root)


def test_claude_runtime_materialization_and_rollback(tmp_path: Path):
    root, registry, home = fixture(tmp_path)
    # Add claude target to fixture registry
    content = registry.read_text(encoding="utf-8")
    content += '\n[[targets]]\nruntime = "claude"\nhome_suffix = ".claude/skills"\n'
    registry.write_text(content, encoding="utf-8")

    module = load_installer()
    run_id = "20260821T120000Z-claude"
    result = module.reconcile(
        "claude", home=home, registry_path=registry, repo_root=root,
        apply=True, run_id=run_id,
    )
    assert result["changed"] == ["example-operations"]
    installed = home / ".claude/skills/example-operations/SKILL.md"
    assert installed.is_file()

    # Rollback removes it cleanly
    module.rollback("claude", run_id, home=home, registry_path=registry, repo_root=root)
    assert not (home / ".claude/skills/example-operations").exists()
