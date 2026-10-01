"""Release-entry contracts and complete accounting for current/historical tests."""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]


def test_suite_inventory_accounts_for_every_test():
    entries = json.loads((ROOT / "tests/suites.json").read_text())["tests"]
    paths = [entry["path"] for entry in entries]
    assert len(paths) == len(set(paths)), "duplicate test registration"
    discovered = {
        str(path.relative_to(ROOT))
        for pattern in ("tests/*.sh", "tests/test_*.py", "tests/phase1/test_*.py", "tests/harness/test-*.mjs")
        for path in ROOT.glob(pattern)
        if path.name != "all.sh"
    }
    assert set(paths) == discovered, "every test needs an explicit active or historical disposition"
    for entry in entries:
        assert entry["status"] in {"active", "historical-v0"}
        assert len(entry["reason"]) >= 20
        assert (ROOT / entry["path"]).is_file()
    active = {entry["path"] for entry in entries if entry["status"] == "active"}
    assert {"tests/test_routing.py", "tests/test_v1_authority.py", "tests/harness/test-plugin-v1.mjs"} <= active


def test_active_entry_sources_do_not_reinstate_v0_root_ownership():
    sources = ["SKILL.md", "AGENTS.md", "README.md", "core/control-plane/root-laws.md",
               "core/control-plane/branch-enforcement-matrix.md", "global-runtime/accelerate/SKILL.md"]
    prohibited = [r"natively absorbs", r"Standing Multi-Agent V2", r"root-owned issue topology",
                  r"root always owns[\s\S]*?final AI review", r"MUST call `collaboration\.spawn_agent`"]
    for relative in sources:
        text = (ROOT / relative).read_text()
        assert "ASDS" in text or "spec-driven-superpowers" in text, relative
        for pattern in prohibited:
            assert not re.search(pattern, text, re.I), (relative, pattern)


def test_canonical_runner_does_not_recursively_activate_historical_tests():
    runner = (ROOT / "tests/run-suite.py").read_text()
    assert 'entry["status"] == "active"' in runner
    assert '"no:cacheprovider"' in runner
    assert "check=True" in runner
    assert "phase1/run.sh" not in (ROOT / "tests/all.sh").read_text()


def test_declared_release_version_matches_active_projections():
    import yaml
    version = (ROOT / "VERSION").read_text().strip()
    assert re.fullmatch(r"\d+\.\d+\.\d+", version)
    assert version == "1.0.0", "the responsibility split is the v1 major release"
    metadata = yaml.safe_load((ROOT / "global-runtime/accelerate/metadata.yaml").read_text())
    assert str(metadata["version"]) == version
    assert f"Version **{version}**" in (ROOT / "README.md").read_text()
    assert f'version="{version}"' in (ROOT / "adapters/runtime/opencode/accelerate-plugin.js").read_text()
