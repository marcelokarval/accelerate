from __future__ import annotations

import importlib.util
import json
import re
import subprocess
import sys
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


# ==============================================================================
# Phase C33-2: Defect Reproduction Tests (CODEX-33)
# ==============================================================================


def test_tree_digest_excludes_pycache_and_bytecode_caches(tmp_path: Path):
    """Defect C33-R1: tree_digest() must exclude Python bytecode and cache files.

    Currently, tree_digest() traverses all files and directories unconditionally via
    rglob('*'), hashing __pycache__ and *.pyc/*.pyo files. This causes non-reproducible
    digests and false drift whenever bytecode caches are generated.

    The canonical enumeration must exclude only known Python caches (__pycache__/, *.pyc, *.pyo),
    while preserving arbitrary unknown files in the digest, and keeping symlinks fail-closed.
    """
    root, registry, home = fixture(tmp_path)
    module = load_installer()
    source = root / "skills/operations/example-operations"

    # Add a legitimate python script to the skill
    script = source / "scripts/tool.py"
    script.parent.mkdir(parents=True, exist_ok=True)
    script.write_text("print('operational tool')\n", encoding="utf-8")

    clean_digest = module.tree_digest(source)

    # Contaminate source tree with Python cache directories and bytecode files
    pycache_dir = source / "__pycache__"
    pycache_dir.mkdir()
    (pycache_dir / "tool.cpython-312.pyc").write_bytes(b"\x00\x00\x00\x00transient-bytecode-1")

    sub_pycache = source / "scripts/__pycache__"
    sub_pycache.mkdir()
    (sub_pycache / "tool.cpython-312.pyc").write_bytes(b"\x00\x00\x00\x00transient-bytecode-2")

    (source / "tool.pyc").write_bytes(b"\x00\x00\x00\x00standalone-pyc")
    (source / "tool.pyo").write_bytes(b"\x00\x00\x00\x00standalone-pyo")

    # Contract requirement: digest must remain identical despite python bytecode cache presence
    assert module.tree_digest(source) == clean_digest, (
        "tree_digest() is contaminated by __pycache__ and bytecode files (.pyc/.pyo)"
    )

    # Invariant requirement: arbitrary unknown non-cache files MUST still change digest
    unknown_file = source / "unexpected_artifact.dat"
    unknown_file.write_bytes(b"arbitrary-unknown-data")
    assert module.tree_digest(source) != clean_digest, (
        "tree_digest() failed to include arbitrary unknown non-cache file in digest"
    )
    unknown_file.unlink()

    # Invariant requirement: symlinks must remain fail-closed, even with pycache/pyc names
    symlink_cache = source / "cache_link"
    symlink_cache.symlink_to(script)
    with pytest.raises(ValueError, match=r"unsafe source"):
        module.tree_digest(source)


def test_stage_excludes_pycache_and_bytecode_from_destination(tmp_path: Path):
    """Defect C33-R1: _stage() and reconcile() must exclude __pycache__ and bytecode from target.

    Currently, _stage() uses shutil.copytree(source, stage) without filtering, copying
    __pycache__ and .pyc/.pyo files into the staged tree and destination target.
    """
    root, registry, home = fixture(tmp_path)
    module = load_installer()
    source = root / "skills/operations/example-operations"

    # Add python script and bytecode caches to source
    script = source / "scripts/tool.py"
    script.parent.mkdir(parents=True, exist_ok=True)
    script.write_text("print('operational tool')\n", encoding="utf-8")

    pycache_dir = source / "__pycache__"
    pycache_dir.mkdir()
    (pycache_dir / "tool.cpython-312.pyc").write_bytes(b"bytecode-payload")

    (source / "standalone.pyc").write_bytes(b"bytecode-standalone")
    (source / "standalone.pyo").write_bytes(b"bytecode-optimized")

    # Also add a valid operational asset that MUST be copied
    data_file = source / "config.json"
    data_file.write_text('{"key": "value"}\n', encoding="utf-8")

    # Reconcile/materialize the skill
    module.reconcile(
        "opencode",
        home=home,
        registry_path=registry,
        repo_root=root,
        apply=True,
        run_id="20260821T120000Z-opencode",
    )

    destination = home / ".config/opencode/skills/example-operations"
    assert destination.is_dir()

    # Legitimate files must be present
    assert (destination / "SKILL.md").is_file()
    assert (destination / "scripts/tool.py").is_file()
    assert (destination / "config.json").is_file()

    # Bytecode and pycache artifacts MUST NOT be present in destination
    assert not (destination / "__pycache__").exists(), (
        "_stage() copied __pycache__ directory into target destination"
    )
    copied_pyc = list(destination.rglob("*.pyc"))
    assert copied_pyc == [], (
        f"_stage() copied .pyc bytecode files into target destination: {copied_pyc}"
    )
    copied_pyo = list(destination.rglob("*.pyo"))
    assert copied_pyo == [], (
        f"_stage() copied .pyo bytecode files into target destination: {copied_pyo}"
    )


def test_reconcile_prevents_false_drift_from_pycache_and_bytecode(tmp_path: Path):
    """Defect C33-R1: Post-install bytecode generation must not trigger false DRIFT.

    Currently, after a skill is installed, running pytest or importing a python tool
    creates __pycache__ and *.pyc files in the source tree or target directory.
    Because tree_digest() includes these, reconcile() reports false drift.
    """
    root, registry, home = fixture(tmp_path)
    module = load_installer()
    source = root / "skills/operations/example-operations"

    script = source / "tool.py"
    script.write_text("def run(): pass\n", encoding="utf-8")

    # Initial clean installation
    result1 = module.reconcile(
        "opencode",
        home=home,
        registry_path=registry,
        repo_root=root,
        apply=True,
        run_id="20260821T120000Z-opencode",
    )
    assert result1["changed"] == ["example-operations"]

    destination = home / ".config/opencode/skills/example-operations"

    # Simulate Python runtime compiling bytecode during execution in both source and target
    source_cache = source / "__pycache__"
    source_cache.mkdir(exist_ok=True)
    (source_cache / "tool.cpython-312.pyc").write_bytes(b"compiled-source-bytecode")
    (source / "tool.pyc").write_bytes(b"standalone-pyc")

    dest_cache = destination / "__pycache__"
    dest_cache.mkdir(exist_ok=True)
    (dest_cache / "tool.cpython-312.pyc").write_bytes(b"compiled-dest-bytecode")

    # Contract requirement: dry-run check must not report false drift
    result2 = module.reconcile(
        "opencode",
        home=home,
        registry_path=registry,
        repo_root=root,
        apply=False,
    )
    assert result2["drift"] == 0, (
        f"False drift detected ({result2['drift']} drift): reconcile() was contaminated by Python bytecode caches"
    )


def test_cli_codex_runtime_choices_do_not_announce_unsupported_target():
    """Defect C33-R2: CLI choices must not announce 'codex' as a separate target.

    Codex consumes the shared 'agents' hub (.agents/skills) and has no separate
    projection target in operational-skill-projections.toml.
    The CLI argument parser currently announces choices=('opencode', 'agents', 'codex', ...),
    misleading operators that --runtime codex is a valid materialization target.
    """
    result = subprocess.run(
        [sys.executable, str(INSTALLER), "--help"],
        capture_output=True,
        text=True,
        check=True,
    )
    match = re.search(r"--runtime\s+\{([^}]+)\}", result.stdout)
    assert match is not None, "Could not locate --runtime choices in --help output"
    choices = [c.strip() for c in match.group(1).split(",")]
    assert "codex" not in choices, (
        f"CLI announces nonexistent target 'codex' in choices: {choices}. "
        "Codex consumes the 'agents' hub and must not be advertised as an independent target."
    )


def test_cli_codex_runtime_invocation_guides_operator_to_agents():
    """Defect C33-R2: Invoking --runtime codex must guide operator to use 'agents'.

    Currently, the CLI accepts --runtime codex because 'codex' is listed in choices,
    but reconcile() crashes with 'FAIL: unknown runtime: codex' because operational-skill-projections.toml
    does not and should not have a codex target.
    The CLI must not crash with raw 'unknown runtime: codex' and must explicitly guide
    the operator that Codex uses the 'agents' runtime hub.
    """
    result = subprocess.run(
        [sys.executable, str(INSTALLER), "--runtime", "codex"],
        capture_output=True,
        text=True,
    )
    # Proves the current failure: CLI accepts argument but crashes with raw 'unknown runtime: codex'
    assert "unknown runtime: codex" not in result.stderr, (
        f"CLI crashed with unhandled 'unknown runtime: codex' instead of guiding operator: {result.stderr.strip()}"
    )
    # Requires clear operator guidance pointing to 'agents'
    combined_output = (result.stderr + "\n" + result.stdout).lower()
    assert "agents" in combined_output, (
        f"CLI failed to guide operator to use 'agents' runtime. Output was:\n"
        f"STDERR: {result.stderr}\nSTDOUT: {result.stdout}"
    )


def test_rollback_rejects_tampered_marker_sha256(tmp_path):
    """T3 (Defect C33-P1-04): Rollback preflight must reject backups whose marker (.accelerate-operational-skill.json) was tampered with."""
    root, registry, home = fixture(tmp_path)
    module = load_installer()
    # Install version 1
    module.reconcile(
        "opencode",
        home=home,
        registry_path=registry,
        repo_root=root,
        apply=True,
        run_id="20260821T120000Z-opencode",
    )
    # Drift source to trigger version 2 and create a backup of version 1
    source = root / "skills/operations/example-operations"
    (source / "extra.txt").write_text("v2\n", encoding="utf-8")
    run2_id = "20260821T130000Z-opencode"
    module.reconcile(
        "opencode",
        home=home,
        registry_path=registry,
        repo_root=root,
        apply=True,
        run_id=run2_id,
    )
    backup_marker = (
        home
        / ".local/state/accelerate/backups/operational-skills"
        / run2_id
        / "example-operations.previous"
        / module.MARKER
    )
    assert backup_marker.exists()

    # Tamper with the marker inside the backup directory
    marker_data = json.loads(backup_marker.read_text(encoding="utf-8"))
    marker_data["source_digest"] = "tampered_digest_00000000000000000000"
    backup_marker.write_text(json.dumps(marker_data), encoding="utf-8")

    # Attempt rollback: must fail closed and refuse rollback due to tampered marker
    with pytest.raises(ValueError, match=r"tampered|marker"):
        module.rollback("opencode", run2_id, home=home, registry_path=registry, repo_root=root)


def test_rollback_batch_failure_compensates_all_destinations(tmp_path, monkeypatch):
    """T4 (Defect C33-P1-05): If rollback fails mid-batch on skill 2, skill 1 must be compensated back to its pre-rollback state."""
    root = tmp_path / "repo"
    home = tmp_path / "home"
    home.mkdir()
    source_a = root / "skills/operations/skill-a"
    source_b = root / "skills/operations/skill-b"
    source_a.mkdir(parents=True)
    source_b.mkdir(parents=True)
    (source_a / "SKILL.md").write_text("---\nname: skill-a\ndescription: a\n---\n# A1\n", encoding="utf-8")
    (source_b / "SKILL.md").write_text("---\nname: skill-b\ndescription: b\n---\n# B1\n", encoding="utf-8")
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
        'runtime = "hermes"\n'
        'home_suffix = ".hermes/skills/runtime"\n',
        encoding="utf-8",
    )
    module = load_installer()
    # Run 1: initial install
    module.reconcile("opencode", home=home, registry_path=registry, repo_root=root, apply=True, run_id="20260821T120000Z-opencode")
    # Drift both skills for run 2
    (source_a / "SKILL.md").write_text("---\nname: skill-a\ndescription: a\n---\n# A2\n", encoding="utf-8")
    (source_b / "SKILL.md").write_text("---\nname: skill-b\ndescription: b\n---\n# B2\n", encoding="utf-8")
    run2_id = "20260821T130000Z-opencode"
    module.reconcile("opencode", home=home, registry_path=registry, repo_root=root, apply=True, run_id=run2_id)

    dest_a = home / ".config/opencode/skills/skill-a"
    dest_b = home / ".config/opencode/skills/skill-b"
    digest_a_run2 = module.tree_digest(dest_a)
    digest_b_run2 = module.tree_digest(dest_b)

    # Note: entries are processed in reversed(entries) -> skill-b first, then skill-a.
    # We simulate a failure on the second skill swapped (skill-a).
    original_replace = module._replace
    def faulty_replace(destination, staged):
        if destination.name == "skill-a":
            raise OSError("Injected disk failure during skill-a rollback swap")
        return original_replace(destination, staged)

    monkeypatch.setattr(module, "_replace", faulty_replace)

    with pytest.raises(OSError, match="Injected disk failure"):
        module.rollback("opencode", run2_id, home=home, registry_path=registry, repo_root=root)

    # Both destinations must remain or be compensated to their pre-rollback (run 2) state!
    # Neither skill should be left in a half-rolled-back state.
    assert module.tree_digest(dest_a) == digest_a_run2, "skill-a was left modified after failed rollback"
    assert module.tree_digest(dest_b) == digest_b_run2, "skill-b was NOT compensated back to pre-rollback state after mid-batch failure"


def test_install_and_backup_strict_permissions(tmp_path):
    """T6 (Defect C33-P2-01): Backup directory and files must strictly enforce 0700 for directories and 0600 for manifest."""
    root, registry, home = fixture(tmp_path)
    module = load_installer()
    run_id = "20260821T120000Z-opencode"
    module.reconcile("opencode", home=home, registry_path=registry, repo_root=root, apply=True, run_id=run_id)
    # Drift and create backup
    (root / "skills/operations/example-operations/SKILL.md").write_text("---\nname: example-operations\ndescription: v2\n---\n# V2\n", encoding="utf-8")
    run2_id = "20260821T130000Z-opencode"
    module.reconcile("opencode", home=home, registry_path=registry, repo_root=root, apply=True, run_id=run2_id)

    backup_dir = home / ".local/state/accelerate/backups/operational-skills" / run2_id
    manifest_path = backup_dir / "manifest.json"
    skill_backup = backup_dir / "example-operations.previous"

    # Directory permissions must be 0700
    assert (backup_dir.stat().st_mode & 0o777) == 0o700, f"backup_dir mode is {oct(backup_dir.stat().st_mode & 0o777)}"
    assert (skill_backup.stat().st_mode & 0o777) == 0o700, f"skill_backup mode is {oct(skill_backup.stat().st_mode & 0o777)}"
    # Manifest must be 0600
    assert (manifest_path.stat().st_mode & 0o777) == 0o600, f"manifest mode is {oct(manifest_path.stat().st_mode & 0o777)}"

