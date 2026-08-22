from __future__ import annotations

import importlib.util
from pathlib import Path

import pytest


REPO = Path(__file__).resolve().parents[1]
INSTALLER = REPO / "adapters/runtime/dsh/install-code-orchestrated-bootstrap.py"


def load_installer():
    spec = importlib.util.spec_from_file_location("dsh_bootstrap_installer", INSTALLER)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def preset(tmp_path: Path) -> tuple[Path, Path]:
    root = tmp_path / "code-orchestrated"
    root.mkdir()
    (root / "preset.yml").write_text("name: Code Orchestrated\n", encoding="utf-8")
    target = root / "agent.cordis.yml"
    target.write_text(
        "# keep this comment\n"
        "- id: persona\n"
        "  name: '@deepseek-ai/dsh-persona'\n"
        "  config:\n"
        "    text: >-\n"
        "      Existing coding persona.\n\n"
        "- id: tool-skill\n"
        "  name: '@deepseek-ai/dsh-tool-skill'\n",
        encoding="utf-8",
    )
    return root, target


def test_dry_run_detects_drift_without_writing(tmp_path):
    root, target = preset(tmp_path)
    before = target.read_bytes()
    result = load_installer().reconcile(root, apply=False)
    assert result["drift"] is True
    assert result["changed"] is False
    assert target.read_bytes() == before
    assert not (root / ".accelerate-backups").exists()


def test_apply_inserts_one_prompt_block_and_is_idempotent(tmp_path):
    root, target = preset(tmp_path)
    module = load_installer()
    result = module.reconcile(root, apply=True, timestamp="20260821T120000Z")
    installed = target.read_text(encoding="utf-8")
    assert result["changed"] is True
    assert installed.count(module.START) == 1
    assert installed.count(module.END) == 1
    assert "load `accelerate` before task actions" in installed
    assert "# keep this comment" in installed
    assert "/home/marcelo-karval" not in installed
    backup = Path(result["backup"])
    assert backup == root / ".accelerate-backups/agent.cordis.yml.20260821T120000Z.bak"
    assert backup.is_file()
    before_second = target.read_bytes()
    second = module.reconcile(root, apply=True, timestamp="20260821T120001Z")
    assert second["drift"] is False
    assert second["changed"] is False
    assert second["backup"] is None
    assert target.read_bytes() == before_second


def test_apply_corrects_managed_drift_and_rollback_restores_previous_bytes(tmp_path):
    root, target = preset(tmp_path)
    module = load_installer()
    module.reconcile(root, apply=True, timestamp="20260821T120000Z")
    target.write_text(
        target.read_text(encoding="utf-8").replace("load `accelerate`", "skip `accelerate`"),
        encoding="utf-8",
    )
    drifted = target.read_bytes()
    result = module.reconcile(root, apply=True, timestamp="20260821T120001Z")
    assert b"load `accelerate`" in target.read_bytes()
    module.rollback(root, Path(result["backup"]))
    assert target.read_bytes() == drifted


@pytest.mark.parametrize(
    "content",
    [
        "- id: tool-skill\n  name: '@deepseek-ai/dsh-tool-skill'\n",
        "- id: persona\n  config:\n    text: >-\n      Existing.\n      # accelerate-dsh-bootstrap:begin\n",
        "- id: persona\n  config:\n    text: >-\n      Existing.\n      # accelerate-dsh-bootstrap:begin\n      # accelerate-dsh-bootstrap:end\n      # accelerate-dsh-bootstrap:begin\n      # accelerate-dsh-bootstrap:end\n",
    ],
)
def test_unexpected_preset_shape_or_markers_fail_closed(tmp_path, content):
    root, target = preset(tmp_path)
    target.write_text(content, encoding="utf-8")
    with pytest.raises(ValueError):
        load_installer().reconcile(root, apply=True)


def test_missing_preset_metadata_fails_closed(tmp_path):
    root, _target = preset(tmp_path)
    (root / "preset.yml").unlink()
    with pytest.raises(ValueError, match="preset.yml"):
        load_installer().reconcile(root, apply=False)
