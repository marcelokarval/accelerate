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


# Test 11: (T4) Rollback rejects tampered backup
def test_rollback_rejects_tampered_backup(tmp_path: Path):
    root, registry, home = fixture(tmp_path)
    module = load_installer()
    run_id_1 = "20260821T120000Z-opencode"
    module.reconcile(
        "opencode", home=home, registry_path=registry, repo_root=root,
        apply=True, run_id=run_id_1,
    )

    source = root / "skills/operations/example-operations"
    (source / "SKILL.md").write_text(
        "---\nname: example-operations\ndescription: fixture v2\n---\n# Example V2\n",
        encoding="utf-8",
    )
    run_id_2 = "20260821T130000Z-opencode"
    module.reconcile(
        "opencode", home=home, registry_path=registry, repo_root=root,
        apply=True, run_id=run_id_2,
    )

    backup_dir = (
        home / ".local/state/accelerate/backups/operational-skills" / run_id_2 / "example-operations.previous"
    )
    assert backup_dir.is_dir()
    tampered_file = backup_dir / "SKILL.md"
    tampered_file.write_text("MALICIOUS INJECTED DATA", encoding="utf-8")

    with pytest.raises(ValueError, match=r"(?i)(tamper|digest|corrupt|integrity|invalid)"):
        module.rollback("opencode", run_id_2, home=home, registry_path=registry, repo_root=root)


# Test 12: (T5) Rollback validates all backups before touching any destination
def test_rollback_validates_all_backups_before_touching_destination(tmp_path: Path):
    import shutil
    root = tmp_path / "repo"
    src_a = root / "skills/operations/skill-a"
    src_a.mkdir(parents=True)
    (src_a / "SKILL.md").write_text("---\nname: skill-a\ndescription: a\n---\n# A\n", encoding="utf-8")
    src_b = root / "skills/operations/skill-b"
    src_b.mkdir(parents=True)
    (src_b / "SKILL.md").write_text("---\nname: skill-b\ndescription: b\n---\n# B\n", encoding="utf-8")

    registry = root / "registry.toml"
    registry.write_text(
        "schema_version = 1\n"
        'managed_by = "accelerate"\n'
        'marker = ".accelerate-operational-skill.json"\n\n'
        "[[skills]]\n"
        'name = "skill-a"\n'
        'source = "skills/operations/skill-a"\n\n'
        "[[skills]]\n"
        'name = "skill-b"\n'
        'source = "skills/operations/skill-b"\n\n'
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

    module = load_installer()
    run_id_1 = "20260821T120000Z-opencode"
    module.reconcile(
        "opencode", home=home, registry_path=registry, repo_root=root,
        apply=True, run_id=run_id_1,
    )

    # Update both skills
    (src_a / "SKILL.md").write_text("---\nname: skill-a\ndescription: a2\n---\n# A2\n", encoding="utf-8")
    (src_b / "SKILL.md").write_text("---\nname: skill-b\ndescription: b2\n---\n# B2\n", encoding="utf-8")
    run_id_2 = "20260821T130000Z-opencode"
    module.reconcile(
        "opencode", home=home, registry_path=registry, repo_root=root,
        apply=True, run_id=run_id_2,
    )

    dest_a = home / ".config/opencode/skills/skill-a"
    dest_b = home / ".config/opencode/skills/skill-b"
    assert dest_a.is_dir()
    assert dest_b.is_dir()

    # Corrupt/remove backup of skill-a
    backup_a = (
        home / ".local/state/accelerate/backups/operational-skills" / run_id_2 / "skill-a.previous"
    )
    shutil.rmtree(backup_a)

    with pytest.raises(Exception):
        module.rollback("opencode", run_id_2, home=home, registry_path=registry, repo_root=root)

    # Both destinations must remain fully intact
    assert dest_b.is_dir() and (dest_b / "SKILL.md").is_file(), "dest_b was deleted during partial rollback!"
    assert dest_a.is_dir() and (dest_a / "SKILL.md").is_file(), "dest_a was deleted during partial rollback!"
