from __future__ import annotations
import json
import shutil
import subprocess
import sys
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
VALIDATOR = REPO / "scripts/validate-phase1-entry-currentness.py"
PROMPT_H_AUTH = "planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-h-current-authority.json"
C13 = "planning/evidence/dated-proof-appendix/codex-26-phase1/c13-current-status-and-reentry-reconciliation.json"
ARTIFACTS = (
    PROMPT_H_AUTH,
    C13,
    "planning/evidence/dated-proof-appendix/codex-17-phase1-entry/phase1-entry-current-candidate-supersession.json",
    "planning/evidence/dated-proof-appendix/codex-25-phase0-acceptance/round-3/phase0-operator-acceptance.json",
    "planning/evidence/dated-proof-appendix/codex-26-phase1/phase-implementation-authorization.json",
    "planning/evidence/dated-proof-appendix/codex-26-phase1/c13-operator-reentry-authorization.json",
    "planning/evidence/dated-proof-appendix/codex-26-phase1/c12-final-independent-gate-failure-and-round-exhaustion.md",
    "planning/evidence/dated-proof-appendix/codex-26-phase1/phase1-dogfood-closure-correction-prompt-h.md",
    "planning/executive/2026-09-04-codex-26-phase1-dogfood-closure-prompt-h-task-graph.md",
    "planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-g-task-g11-no-go.md",
    "planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-g-candidate-g2-freeze.json",
    "planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md",
)

def fixture_root(tmp_path: Path) -> Path:
    for relative in ARTIFACTS:
        source, target = REPO / relative, tmp_path / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
    return tmp_path

def validate(root: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run([sys.executable, str(VALIDATOR), "--root", str(root)], text=True, capture_output=True, check=False)

def prompt_h_receipt(root: Path) -> dict:
    return json.loads((root / PROMPT_H_AUTH).read_text(encoding="utf-8"))

def write_prompt_h_receipt(root: Path, value: dict) -> None:
    (root / PROMPT_H_AUTH).write_text(json.dumps(value, indent=2) + "\n", encoding="utf-8")

class TestPhase1EntryCurrentness(unittest.TestCase):
    def test_currentness_validator_accepts_prompt_h(self):
        result = validate(REPO)
        self.assertEqual(result.returncode, 0, f"Validator stderr: {result.stderr}\nValidator stdout: {result.stdout}")
        self.assertIn("CODEX-17 and C13 are historical; CODEX-26 Prompt H is current and unaccepted", result.stdout)

    def test_currentness_validator_rejects_false_phase1_acceptance(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp_dir:
            root = fixture_root(Path(tmp_dir))
            value = prompt_h_receipt(root)
            value["authority_effect"]["phase1_accepted"] = True
            write_prompt_h_receipt(root, value)
            result = validate(root)
            self.assertNotEqual(result.returncode, 0)
            self.assertTrue("phase1_accepted must be false" in result.stderr or "authority effect" in result.stderr)

    def test_currentness_validator_rejects_wrong_governing_work_item(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp_dir:
            root = fixture_root(Path(tmp_dir))
            value = prompt_h_receipt(root)
            value["governing_issue"]["identifier"] = "CODEX-17"
            write_prompt_h_receipt(root, value)
            result = validate(root)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("governing issue", result.stderr)

    def test_currentness_validator_rejects_contract_drift(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp_dir:
            root = fixture_root(Path(tmp_dir))
            contract = root / ARTIFACTS[7]
            contract.write_text(contract.read_text(encoding="utf-8") + "\nDrift.\n", encoding="utf-8")
            result = validate(root)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("digest mismatch", result.stderr)

    def test_currentness_validator_rejects_c13_as_current(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp_dir:
            root = fixture_root(Path(tmp_dir))
            value = prompt_h_receipt(root)
            value["current"]["cycle"] = "codex-26-phase1-c13-reentry"
            write_prompt_h_receipt(root, value)
            result = validate(root)
            self.assertNotEqual(result.returncode, 0)
            self.assertTrue("C13" in result.stderr or "cycle" in result.stderr)

    def test_currentness_validator_rejects_symlinked_authority(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp_dir:
            base_dir = Path(tmp_dir)
            root = fixture_root(base_dir / "repo")
            target = root / PROMPT_H_AUTH
            outside = base_dir / "outside-prompt-h-auth.json"
            outside.write_bytes(target.read_bytes())
            target.unlink()
            target.symlink_to(outside)
            result = validate(root)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("must not contain a symlink", result.stderr)

if __name__ == "__main__":
    unittest.main()
