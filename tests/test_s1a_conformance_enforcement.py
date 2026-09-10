#!/usr/bin/env python3
"""Independent S1A conformance contract tests.

These expectations are deliberately encoded here rather than imported from the
validator under test.
"""

import copy
import json
import shutil
import subprocess
import sys
import unittest
from pathlib import Path
from tempfile import TemporaryDirectory
from typing import Optional


ROOT = Path(__file__).resolve().parents[1]
FIXTURES = ROOT / "tests" / "fixtures" / "contract-v1-authority"
VALIDATOR = ROOT / "scripts" / "validate-accelerate-v020-s1a-authority.py"
FOCAL_RUNNER = ROOT / "tests" / "accelerate-v020-s1a-authority.sh"
PASS = "[PASS: S1A_AUTHORITY_CANONICAL_VALID]"
NEGATIVE = "[NEG-ACV1-03: ACV1_MAPPING_NON_COMPLIANT_REJECTED]"

OWNER_WAVE = {
    "D001": ("Wave 0", "Wave 0"),
    "D002": ("Wave 1", "Wave 1"),
    "D003": ("Wave 1", "Wave 1"),
    "D004": ("Wave 1", "Wave 1"),
    "D005": ("Wave 0", "Wave 0"),
    "D006": ("Wave 0 e posteriores", "Wave 0"),
    "D007": ("Wave 3", "Wave 3"),
    "D008": ("Wave 2", "Wave 2"),
    "D009": ("Wave 3", "Wave 3"),
    "D010": ("Wave 3", "Wave 3"),
    "D011": ("Wave 3", "Wave 3"),
    "D012": ("Wave 3", "Wave 3"),
    "D013": ("Wave 3", "Wave 3"),
    "D014": ("Wave 3", "Wave 3"),
    "D015": ("Wave 5", "Wave 5"),
    "D016": ("Wave 5", "Wave 5"),
    "D017": ("Wave 5", "Wave 5"),
    "D018": ("Wave 1 após Wave 0", "Wave 1"),
    "D019": ("Wave 4", "Wave 4"),
    "D020": ("Wave 3", "Wave 3"),
    "D021": ("Wave 5", "Wave 5"),
    "D022": ("Wave 3/5", "Wave 3"),
    "D023": ("Wave 4", "Wave 4"),
    "D024": ("Wave 5", "Wave 5"),
}
RULE_IDS = (
    "RULE-01-REPO-LOCAL-FIRST",
    "RULE-02-NO-REVERSE-EDGE",
    "RULE-03-SUPPORTING-CANNOT-OVERRIDE",
    "RULE-04-BACKEND-STATE-BOUNDED",
    "RULE-05-FORBIDDEN-STRICT-REJECTION",
)
CLASS_NAMES = (
    "governing-authority",
    "decision-artifact",
    "backend-authority",
    "supporting-reference",
    "generated-export",
    "forbidden-authority",
)
DIAGNOSTIC_FIELDS = {
    "fixture_id",
    "violation",
    "expected_verdict",
    "expected_marker",
    "expected_rejection_marker",
    "missing_decision_ids",
    "invalid_dispositions",
    "decisions_count",
}


def load_json(name):
    return json.loads((FIXTURES / name).read_text(encoding="utf-8"))


class S1AConformanceEnforcementTests(unittest.TestCase):
    def invoke(self, payload=None, *, raw=None, expected_code=0, marker=None, label="fixture", amendment=None, repo_root=None):
        with TemporaryDirectory() as temporary:
            temp = Path(temporary)
            if raw is not None:
                fixture = temp / f"{label}.json"
                fixture.write_text(raw, encoding="utf-8")
            elif payload is not None:
                fixture = temp / f"{label}.json"
                fixture.write_text(json.dumps(payload, ensure_ascii=False), encoding="utf-8")
            else:
                fixture = None
            command = [sys.executable, "-B", str(VALIDATOR)]
            if fixture:
                command += ["--fixture", str(fixture)]
            else:
                command += ["--repo-root", str(repo_root), "--amendment", str(amendment)]
            result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, check=False)
        output = result.stdout + result.stderr
        self.assertEqual(result.returncode, expected_code, f"{label}:\n{output}")
        if marker:
            self.assertIn(marker, output, f"{label}:\n{output}")
        self.assertNotIn("Traceback", output, f"{label}:\n{output}")

    def test_a_input_structure_and_duplicate_keys(self):
        canonical = load_json("canonical-authority-positive.json")
        malformed = [[], {"authority_set": []}, {"authority_set": {"governing-authority": "AGENTS.md"}}, {"authority_set": {"governing-authority": ["AGENTS.md", 7]}}]
        for index, payload in enumerate(malformed):
            with self.subTest(case=f"malformed-{index}"):
                self.invoke(payload=payload, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label=f"malformed-{index}")
        with self.subTest(case="empty-object"):
            self.invoke(payload={}, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label="empty-object")
        with self.subTest(case="valid-control"):
            self.invoke(payload=canonical, expected_code=0, marker=PASS, label="structure-control")
        duplicate = '{"authority_set":{"governing-authority":[],"governing-authority":[]}}'
        self.invoke(raw=duplicate, expected_code=2, marker="[ERROR: DUPLICATE_JSON_KEY]", label="duplicate-key")

    def test_b_governing_paths_are_lexical_repo_local(self):
        canonical = load_json("canonical-authority-positive.json")
        allowed = ["AGENTS.md", "SKILL.md", "README.md", "core/", "adapters/", "profiles/", "onboarding/", "planning/", "skills/", "references/", "core/contracts/v1/schema.json"]
        rejected = ["/etc/passwd", "../AGENTS.md", "./global-runtime/", ".", "user-home/skills/", "~/.codex/skills/", "external:Fission-AI/OpenSpec", "global-runtime/accelerate/", "src/", "vendor/authority.md"]
        for path in allowed:
            payload = copy.deepcopy(canonical)
            payload["authority_set"]["governing-authority"] = [path]
            with self.subTest(path=path):
                self.invoke(payload=payload, expected_code=0, marker=PASS, label="allowed-path")
        for path in rejected:
            payload = copy.deepcopy(canonical)
            payload["authority_set"]["governing-authority"] = [path]
            with self.subTest(path=path):
                self.invoke(payload=payload, expected_code=1, marker="[ERROR: AUTHORITY_PATH_INVALID]", label="rejected-path")

    def test_c_authority_classes_precedence_model(self):
        control = load_json("authority-classes-precedence.json")
        self.assertEqual(tuple(control["classes"]), CLASS_NAMES)
        self.assertEqual(control["precedence_order"], list(CLASS_NAMES))
        self.assertEqual([control["classes"][name]["rank"] for name in CLASS_NAMES], [1, 2, 3, 4, 5, 6])
        self.assertEqual([control["classes"][name]["may_decide_runtime"] for name in CLASS_NAMES], [True, True, True, False, False, False])
        self.assertEqual([rule["id"] for rule in control["enforcement_rules"]], list(RULE_IDS))
        self.invoke(payload=control, expected_code=0, marker=PASS, label="classes-control")
        cases = {}
        missing = copy.deepcopy(control)
        del missing["classes"]["backend-authority"]
        cases["missing-class"] = missing
        extra = copy.deepcopy(control)
        extra["classes"]["unrecognized"] = {"rank": 7, "may_decide_runtime": False}
        cases["extra-class"] = extra
        cases["reversed-order"] = {**copy.deepcopy(control), "precedence_order": list(reversed(control["precedence_order"]))}
        duplicate_rank = copy.deepcopy(control)
        duplicate_rank["classes"]["decision-artifact"]["rank"] = 1
        cases["duplicate-rank"] = duplicate_rank
        out_of_range = copy.deepcopy(control)
        out_of_range["classes"]["forbidden-authority"]["rank"] = 7
        cases["out-of-range-rank"] = out_of_range
        wrong_pattern = copy.deepcopy(control)
        wrong_pattern["classes"]["supporting-reference"]["may_decide_runtime"] = True
        cases["wrong-runtime-pattern"] = wrong_pattern
        missing_rule = copy.deepcopy(control)
        missing_rule["enforcement_rules"] = missing_rule["enforcement_rules"][1:]
        cases["missing-rule"] = missing_rule
        extra_rule = copy.deepcopy(control)
        extra_rule["enforcement_rules"].append({"id": "RULE-06-EXTRA"})
        cases["extra-rule"] = extra_rule
        wrong_rule = copy.deepcopy(control)
        wrong_rule["enforcement_rules"][0]["id"] = "RULE-00-WRONG"
        cases["wrong-rule"] = wrong_rule
        for name, payload in cases.items():
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=1, marker="[ERROR: AUTHORITY_MODEL_INVALID]", label=name)

    def test_d_acv1_mapping_is_exact_and_canonical(self):
        control = load_json("acv1-expected-mapping.json")
        self.assertEqual(control["allowed_dispositions"], ["mantido", "alterado", "substituído"])
        self.assertEqual(control["allowed_waves"], [f"Wave {number}" for number in range(6)])
        self.invoke(payload=control, expected_code=0, marker=PASS, label="mapping-control")
        decisions = control["decisions"]
        self.assertEqual([decision["short_id"] for decision in decisions], list(OWNER_WAVE))
        for decision in decisions:
            short_id = decision["short_id"]
            self.assertEqual(decision["id"], "ACV1-" + short_id)
            self.assertEqual(decision["disposition"], "mantido")
            self.assertEqual((decision["implementation_owner"], decision["wave"]), OWNER_WAVE[short_id])
        cases = {}
        missing_owner = copy.deepcopy(control)
        del missing_owner["decisions"][0]["implementation_owner"]
        cases["missing-owner"] = missing_owner
        missing_wave = copy.deepcopy(control)
        del missing_wave["decisions"][0]["wave"]
        cases["missing-wave"] = missing_wave
        invalid_wave = copy.deepcopy(control)
        invalid_wave["decisions"][0]["wave"] = "Wave 99"
        cases["invalid-wave"] = invalid_wave
        wrong_disposition = copy.deepcopy(control)
        wrong_disposition["decisions"][0]["disposition"] = "alterado"
        cases["wrong-disposition"] = wrong_disposition
        conflicting_id = copy.deepcopy(control)
        conflicting_id["decisions"][0]["id"] = "ACV1-D002"
        cases["conflicting-id-short"] = conflicting_id
        wrong_allowed_waves = copy.deepcopy(control)
        wrong_allowed_waves["allowed_waves"] = ["Wave 0", "Wave 1", "Wave 2", "Wave 3", "Wave 4", "Wave 99"]
        cases["wrong-allowed-waves"] = wrong_allowed_waves
        for name, payload in cases.items():
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=1, marker="[ERROR: ACV1_MAPPING_INVALID]", label=name)

    def test_e_approval_consistency_and_sequence_gates(self):
        canonical = load_json("canonical-authority-positive.json")
        draft = copy.deepcopy(canonical)
        draft.update({"status": "draft", "operator_acceptance": {"status": "accepted", "accepted_by": "operator", "accepted_at": "2026-09-10"}, "advance_gates": {"wave_0_allowed": True, "core_contracts_v1_mutation_allowed": True, "s1b_allowed": True, "operator_acceptance": {"status": "accepted", "accepted_by": "operator"}}})
        with self.subTest(case="draft-nested-accepted"):
            self.invoke(payload=draft, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label="draft-nested-accepted")
        disagreement = copy.deepcopy(canonical)
        disagreement.update({"status": "accepted", "operator_acceptance": {"status": "accepted", "accepted_by": "operator"}, "advance_gates": {"operator_acceptance": {"status": "pending", "accepted_by": None}}})
        with self.subTest(case="acceptance-disagreement"):
            self.invoke(payload=disagreement, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label="acceptance-disagreement")
        empty_acceptor = copy.deepcopy(canonical)
        empty_acceptor.update({"status": "accepted", "operator_acceptance": {"status": "accepted", "accepted_by": ""}})
        with self.subTest(case="empty-accepted-by"):
            self.invoke(payload=empty_acceptor, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label="empty-accepted-by")
        consistent = copy.deepcopy(canonical)
        consistent.update({"status": "accepted", "operator_acceptance": {"status": "accepted", "accepted_by": "operator"}, "advance_gates": {"wave_0_allowed": False, "core_contracts_v1_mutation_allowed": False, "s1b_allowed": False, "operator_acceptance": {"status": "accepted", "accepted_by": "operator"}}})
        with self.subTest(case="consistent-accepted-records"):
            self.invoke(payload=consistent, expected_code=0, marker=PASS, label="consistent-accepted-records")

    def amendment_variant(self, transform, name, expected_code=1, marker: Optional[str] = "[ERROR: MARKDOWN_CONTRACT_INVALID]"):
        original = (ROOT / "planning/architecture/2026-09-06-accelerate-v020-acv1-authority-amendment.md").read_text(encoding="utf-8")
        text = transform(original)
        with TemporaryDirectory() as temporary:
            repo = Path(temporary) / "repo"
            repo.mkdir()
            amendment = repo / "amendment.md"
            amendment.write_text(text, encoding="utf-8")
            for surface in ("AGENTS.md", "SKILL.md", "README.md"):
                (repo / surface).write_text("surface\n", encoding="utf-8")
            for directory in ("core", "adapters", "profiles", "skills"):
                (repo / directory).mkdir()
            result = subprocess.run([sys.executable, "-B", str(VALIDATOR), "--repo-root", str(repo), "--amendment", str(amendment)], cwd=ROOT, capture_output=True, text=True, check=False)
            output = result.stdout + result.stderr
        self.assertEqual(result.returncode, expected_code, f"{name}:\n{output}")
        if marker:
            self.assertIn(marker, output, f"{name}:\n{output}")
        if marker is None:
            self.assertNotIn(PASS, output, f"{name}:\n{output}")
        self.assertNotIn("Traceback", output)

    def test_f_markdown_contract_shape_and_mapping(self):
        original = (ROOT / "planning/architecture/2026-09-06-accelerate-v020-acv1-authority-amendment.md").read_text(encoding="utf-8")
        with TemporaryDirectory() as temporary:
            repo = Path(temporary) / "repo"
            repo.mkdir()
            amendment = repo / "amendment.md"
            amendment.write_text(original, encoding="utf-8")
            for surface in ("AGENTS.md", "SKILL.md", "README.md"):
                (repo / surface).write_text("surface\n", encoding="utf-8")
            for directory in ("core", "adapters", "profiles", "skills"):
                (repo / directory).mkdir()
            self.invoke(expected_code=0, marker=PASS, label="markdown-control", amendment=amendment, repo_root=repo)
        heading = "## Mapa completo de ACV1"
        with self.subTest(case="renamed-section"):
            self.amendment_variant(lambda text: text.replace(heading, "## Renamed ACV1 map", 1), "renamed-section")
        with self.subTest(case="extra-column"):
            self.amendment_variant(lambda text: text.replace("| Decisão | Disposição v0.2.0 | Dono de implementação | Condição/verificação de S1A |", "| Decisão | Disposição v0.2.0 | Dono de implementação | Condição | Extra |", 1), "extra-column")
        table = original.split(heading, 1)[1].split("## Relação com requisitos", 1)[0]
        with self.subTest(case="multiple-normative-tables"):
            self.amendment_variant(lambda text: text + "\n" + heading + table, "multiple-normative-tables")
        with self.subTest(case="wrong-owner-wave"):
            self.amendment_variant(lambda text: text.replace("| D001 autoridade repo-first | mantido | Wave 0 |", "| D001 autoridade repo-first | mantido | Wave 9 |", 1), "wrong-owner-wave")
        with self.subTest(case="wrong-disposition"):
            self.amendment_variant(lambda text: text.replace("| D001 autoridade repo-first | mantido |", "| D001 autoridade repo-first | alterado |", 1), "wrong-disposition")

    def test_g_runner_red_classification_is_distinct_from_blocked(self):
        with TemporaryDirectory() as temporary:
            repo = Path(temporary) / "fake"
            repo.mkdir()
            (repo / "tests").mkdir()
            shutil.copy2(FOCAL_RUNNER, repo / "tests" / "accelerate-v020-s1a-authority.sh")
            fixture_dir = repo / "tests" / "fixtures" / "contract-v1-authority"
            shutil.copytree(FIXTURES, fixture_dir)
            shutil.copy2(ROOT / "tests/test_s1a_metadata_independence.py", repo / "tests/test_s1a_metadata_independence.py")
            (repo / "scripts").mkdir()
            for surface in ("AGENTS.md", "SKILL.md", "README.md"):
                (repo / surface).write_text("surface\n", encoding="utf-8")
            for directory in ("core", "adapters", "profiles", "skills"):
                (repo / directory).mkdir()
            validator = repo / "scripts" / "validate-accelerate-v020-s1a-authority.py"
            validator.write_text("import sys\nprint('[ERROR: FAKE_VALIDATOR]')\nsys.exit(2)\n", encoding="utf-8")
            runner = repo / "tests" / "accelerate-v020-s1a-authority.sh"
            blocked = subprocess.run(["bash", str(runner), "--red-first"], cwd=repo, capture_output=True, text=True, check=False)
            with self.subTest(case="error-is-blocked"):
                self.assertEqual(blocked.returncode, 2, blocked.stdout + blocked.stderr)
                self.assertIn("[BLOCKED:", blocked.stdout + blocked.stderr)
                self.assertNotIn("RED-S1A-00", blocked.stdout + blocked.stderr)
            validator.write_text("import sys\nprint('[RED-S1A-00: FAKE]')\nsys.exit(1)\n", encoding="utf-8")
            red = subprocess.run(["bash", str(runner), "--red-first"], cwd=repo, capture_output=True, text=True, check=False)
            with self.subTest(case="red-is-not-blocked"):
                self.assertEqual(red.returncode, 1, red.stdout + red.stderr)
                self.assertIn("RED-S1A-00", red.stdout + red.stderr)

    def test_h_invalid_json_has_parse_error_contract(self):
        self.invoke(raw="{", expected_code=2, marker="[ERROR: INVALID_FIXTURE_JSON]", label="invalid-json")
        duplicate = '{"contract_name":"first","contract_name":"second"}'
        self.invoke(raw=duplicate, expected_code=2, marker="[ERROR: DUPLICATE_JSON_KEY]", label="duplicate-json")

    def test_i_authority_set_has_exact_structural_classes(self):
        canonical = load_json("canonical-authority-positive.json")
        self.invoke(payload=canonical, expected_code=0, marker=PASS, label="authority-structure-control")
        cases = {}
        missing = copy.deepcopy(canonical)
        del missing["authority_set"]["forbidden-authority"]
        cases["missing-class"] = missing
        extra = copy.deepcopy(canonical)
        extra["authority_set"]["unexpected-class"] = []
        cases["extra-class"] = extra
        for class_name in CLASS_NAMES:
            malformed = copy.deepcopy(canonical)
            malformed["authority_set"][class_name] = {"not": "a list"}
            cases[f"malformed-{class_name}"] = malformed
        for name, payload in cases.items():
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label=name)
        for field in ("external_provenance", "reverse_edge_claim"):
            malformed = copy.deepcopy(canonical)
            malformed[field] = ["not", "an", "object"]
            with self.subTest(case=f"malformed-{field}"):
                self.invoke(payload=malformed, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label=f"malformed-{field}")

    def test_j_approval_records_cannot_override_status(self):
        canonical = load_json("canonical-authority-positive.json")
        for status in ("draft", "draft-pre-s1a"):
            payload = copy.deepcopy(canonical)
            payload.update({"status": status, "operator_acceptance": {"status": "accepted", "accepted_by": "operator", "accepted_at": "2026-09-10"}, "advance_gates": {"wave_0_allowed": False, "core_contracts_v1_mutation_allowed": False, "s1b_allowed": False}})
            with self.subTest(case=f"{status}-accepted-record"):
                self.invoke(payload=payload, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label=f"{status}-accepted-record")
        missing_acceptor = copy.deepcopy(canonical)
        missing_acceptor.update({"status": "accepted", "operator_acceptance": {"status": "accepted", "accepted_by": ""}})
        with self.subTest(case="accepted-empty-operator"):
            self.invoke(payload=missing_acceptor, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label="accepted-empty-operator")

    def test_k_markdown_rows_are_frozen_contract_records(self):
        with self.subTest(case="changed-topic"):
            self.amendment_variant(lambda text: text.replace("| D001 autoridade repo-first | mantido |", "| D001 changed topic | mantido |", 1), "changed-topic")
        with self.subTest(case="changed-gate-note"):
            self.amendment_variant(lambda text: text.replace("S1A guarda a precedência: fixture rejeita fonte externa/export como autoridade.", "arbitrary replacement note", 1), "changed-gate-note")

    def test_l_runner_rejects_corrupt_fixtures_and_wrong_exit_discipline(self):
        with TemporaryDirectory() as temporary:
            repo = Path(temporary) / "fake"
            repo.mkdir()
            (repo / "tests").mkdir()
            shutil.copy2(FOCAL_RUNNER, repo / "tests" / "accelerate-v020-s1a-authority.sh")
            fixture_dir = repo / "tests" / "fixtures" / "contract-v1-authority"
            shutil.copytree(FIXTURES, fixture_dir)
            classes_fixture = fixture_dir / "authority-classes-precedence.json"
            raw = classes_fixture.read_text(encoding="utf-8")
            raw = raw.replace('"contract_name": "accelerate-contract-v1-authority-classes-precedence",', '"contract_name": "first",\n  "contract_name": "second",', 1)
            classes_fixture.write_text(raw, encoding="utf-8")
            shutil.copy2(ROOT / "tests/test_s1a_metadata_independence.py", repo / "tests/test_s1a_metadata_independence.py")
            (repo / "scripts").mkdir()
            for surface in ("AGENTS.md", "SKILL.md", "README.md"):
                (repo / surface).write_text("surface\n", encoding="utf-8")
            for directory in ("core", "adapters", "profiles", "skills"):
                (repo / directory).mkdir()
            validator = repo / "scripts" / "validate-accelerate-v020-s1a-authority.py"
            validator.write_text("import sys\nprint('[PASS: FAKE_VALIDATOR]')\nsys.exit(0)\n", encoding="utf-8")
            runner = repo / "tests" / "accelerate-v020-s1a-authority.sh"
            corrupt = subprocess.run(["bash", str(runner)], cwd=repo, capture_output=True, text=True, check=False)
            with self.subTest(case="corrupt-fixture"):
                self.assertEqual(corrupt.returncode, 2, corrupt.stdout + corrupt.stderr)
                self.assertIn("[BLOCKED: FIXTURE_CORRUPTED]", corrupt.stdout + corrupt.stderr)
                self.assertNotIn("[PASS: S1A_AUTHORITY_SUITE_COMPLIANT]", corrupt.stdout + corrupt.stderr)

            shutil.copytree(FIXTURES, repo / "tests" / "fixtures" / "clean-authority", dirs_exist_ok=True)
            shutil.copy2(FIXTURES / "authority-classes-precedence.json", classes_fixture)
            validator.write_text(
                "import sys\n"
                "args = sys.argv[1:]\n"
                "if '--fixture' not in args:\n"
                "    print('[PASS: FAKE_REPOSITORY]')\n"
                "    raise SystemExit(0)\n"
                "fixture = args[args.index('--fixture') + 1]\n"
                "if fixture.endswith('canonical-authority-positive.json'):\n"
                "    print('[PASS: S1A_AUTHORITY_CANONICAL_VALID]')\n"
                "    raise SystemExit(0)\n"
                "print('[NEG-R01-01: EXTERNAL_AUTHORITY_OVERRIDE_REJECTED] fake')\n"
                "raise SystemExit(2)\n",
                encoding="utf-8",
            )
            wrong_exit = subprocess.run(["bash", str(runner)], cwd=repo, capture_output=True, text=True, check=False)
            with self.subTest(case="negative-wrong-exit"):
                self.assertEqual(wrong_exit.returncode, 2, wrong_exit.stdout + wrong_exit.stderr)
                self.assertIn("[BLOCKED:", wrong_exit.stdout + wrong_exit.stderr)
                self.assertNotIn("[PASS: S1A_AUTHORITY_SUITE_COMPLIANT]", wrong_exit.stdout + wrong_exit.stderr)

    def test_m_sequence_is_fail_closed_for_unknown_or_ambiguous_approval(self):
        canonical = load_json("canonical-authority-positive.json")
        review = copy.deepcopy(canonical)
        review.update({"status": "review", "advance_gates": {"wave_0_allowed": True}})
        with self.subTest(case="review-wave-zero"):
            self.invoke(payload=review, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label="review-wave-zero")
        absent_status = copy.deepcopy(canonical)
        absent_status["advance_claims"] = {"authorize_wave_0": True}
        with self.subTest(case="missing-status-advance"):
            self.invoke(payload=absent_status, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label="missing-status-advance")
        accepted = copy.deepcopy(canonical)
        accepted.update({"status": "accepted", "operator_acceptance": {"status": "accepted", "accepted_by": "operator"}, "advance_gates": {"wave_0_allowed": True, "core_contracts_v1_mutation_allowed": True, "s1b_allowed": False, "operator_acceptance": {"status": "accepted", "accepted_by": "operator"}}})
        with self.subTest(case="accepted-consistent-gate"):
            self.invoke(payload=accepted, expected_code=0, marker=PASS, label="accepted-consistent-gate")
        unknown = copy.deepcopy(canonical)
        unknown.update({"status": "unrecognized-status", "advance_gates": {"wave_0_allowed": False, "core_contracts_v1_mutation_allowed": False, "s1b_allowed": False}})
        with self.subTest(case="unknown-status"):
            self.invoke(payload=unknown, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label="unknown-status")

    def test_n_full_canonical_mapping_cannot_downgrade_by_metadata(self):
        control = load_json("acv1-expected-mapping.json")
        with self.subTest(case="canonical-mapping-control"):
            self.invoke(payload=control, expected_code=0, marker=PASS, label="canonical-mapping-control")
        renamed = copy.deepcopy(control)
        renamed["contract_name"] = "another-contract"
        renamed["decisions"][0]["disposition"] = "alterado"
        with self.subTest(case="renamed-wrong-disposition"):
            self.invoke(payload=renamed, expected_code=1, marker="[ERROR: ACV1_MAPPING_INVALID]", label="renamed-wrong-disposition")
        unnamed = copy.deepcopy(control)
        unnamed.pop("contract_name")
        unnamed["decisions"][0]["implementation_owner"] = "Wave 9"
        unnamed["decisions"][0]["wave"] = "Wave 99"
        with self.subTest(case="unnamed-wrong-owner-wave"):
            self.invoke(payload=unnamed, expected_code=1, marker="[ERROR: ACV1_MAPPING_INVALID]", label="unnamed-wrong-owner-wave")

    def test_o_markdown_status_is_anchored_and_unambiguous(self):
        original = (ROOT / "planning/architecture/2026-09-06-accelerate-v020-acv1-authority-amendment.md").read_text(encoding="utf-8")
        self.amendment_variant(lambda text: text, "status-control", expected_code=0, marker=PASS)
        real_accepted = original.replace("Estado: `draft-pre-s1a`", "Estado: `accepted`", 1)
        decoy_then_accepted = "Estado: `draft-pre-s1a`\n\n" + real_accepted
        with self.subTest(case="decoy-status-real-accepted"):
            self.amendment_variant(lambda _text: decoy_then_accepted, "decoy-status-real-accepted", marker=None)
        duplicate = original.replace("Estado: `draft-pre-s1a`", "Estado: `draft-pre-s1a`\nEstado: `draft-pre-s1a`", 1)
        with self.subTest(case="duplicate-status-line"):
            self.amendment_variant(lambda _text: duplicate, "duplicate-status-line")

    def test_p_explicit_bypass_is_never_authorized(self):
        canonical = load_json("canonical-authority-positive.json")
        for skip_operator_acceptance in (True, False):
            payload = copy.deepcopy(canonical)
            payload.update({
                "status": "accepted",
                "operator_acceptance": {"status": "accepted", "accepted_by": "operator"},
                "advance_gates": {
                    "wave_0_allowed": True,
                    "core_contracts_v1_mutation_allowed": True,
                    "s1b_allowed": False,
                    "operator_acceptance": {"status": "accepted", "accepted_by": "operator"},
                },
                "advance_claims": {
                    "authorize_wave_0": True,
                    "authorize_core_contracts_v1_mutation": True,
                    "skip_operator_acceptance": skip_operator_acceptance,
                },
            })
            expected_code = 1 if skip_operator_acceptance else 0
            marker = "[ERROR: SEQUENCE_GATE_INVALID]" if skip_operator_acceptance else PASS
            with self.subTest(case=f"skip-operator-acceptance-{skip_operator_acceptance}"):
                self.invoke(
                    payload=payload,
                    expected_code=expected_code,
                    marker=marker,
                    label=f"skip-operator-acceptance-{skip_operator_acceptance}",
                )

    def test_q_malformed_sequence_structures_fail_deterministically(self):
        canonical = load_json("canonical-authority-positive.json")
        malformed = {}
        for field in ("operator_acceptance", "advance_gates", "advance_claims"):
            payload = copy.deepcopy(canonical)
            payload[field] = []
            malformed[f"{field}-non-object"] = payload
        for name, payload in malformed.items():
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label=name)

        gate_fields = (
            "wave_0_allowed",
            "core_contracts_v1_mutation_allowed",
            "s1b_allowed",
        )
        claim_fields = (
            "authorize_wave_0",
            "authorize_core_contracts_v1_mutation",
            "skip_operator_acceptance",
        )
        invalid_values = ("true", 1, None)
        for field in gate_fields:
            for value in invalid_values:
                payload = copy.deepcopy(canonical)
                payload["advance_gates"] = {field: value}
                name = f"advance-gates-{field}-{value!r}"
                with self.subTest(case=name):
                    self.invoke(payload=payload, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label=name)
        for field in claim_fields:
            for value in invalid_values:
                payload = copy.deepcopy(canonical)
                payload["advance_claims"] = {field: value}
                name = f"advance-claims-{field}-{value!r}"
                with self.subTest(case=name):
                    self.invoke(payload=payload, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label=name)

        nested = copy.deepcopy(canonical)
        nested["advance_gates"] = {"operator_acceptance": []}
        with self.subTest(case="nested-operator-acceptance-non-object"):
            self.invoke(payload=nested, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label="nested-operator-acceptance-non-object")

        for location in ("top-level", "nested"):
            payload = copy.deepcopy(canonical)
            payload["status"] = "accepted"
            accepted = {"status": "mystery", "accepted_by": "operator"}
            if location == "top-level":
                payload["operator_acceptance"] = accepted
            else:
                payload["advance_gates"] = {"operator_acceptance": accepted}
            name = f"unknown-acceptance-status-{location}"
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label=name)

        with self.subTest(case="unrelated-authority-model"):
            self.invoke(payload=load_json("authority-classes-precedence.json"), expected_code=0, marker=PASS, label="unrelated-authority-model")
        with self.subTest(case="unrelated-mapping"):
            self.invoke(payload=load_json("acv1-expected-mapping.json"), expected_code=0, marker=PASS, label="unrelated-mapping")

    def test_r_s1b_execution_and_amendment_types_are_fail_closed(self):
        canonical = load_json("canonical-authority-positive.json")
        for field in ("initiated", "inferred_acceptance"):
            for value in (1, 0, "true", "false", None):
                payload = copy.deepcopy(canonical)
                payload["s1b_execution"] = {field: value}
                name = f"s1b-execution-{field}-{value!r}"
                with self.subTest(case=name):
                    self.invoke(payload=payload, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label=name)

        for field in ("initiated", "inferred_acceptance"):
            payload = copy.deepcopy(canonical)
            payload["s1b_execution"] = {field: False}
            name = f"s1b-execution-{field}-false-control"
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=0, marker=PASS, label=name)

        for value in ([], "not-an-object", None):
            payload = copy.deepcopy(canonical)
            payload["s1a_amendment"] = value
            name = f"s1a-amendment-{value!r}"
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label=name)

        for value in ([], "not-an-object", None):
            payload = copy.deepcopy(canonical)
            payload["s1a_amendment"] = {"status": "accepted", "operator_acceptance": value}
            name = f"s1a-amendment-operator-acceptance-{value!r}"
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label=name)

        accepted_amendment = {
            "status": "accepted",
            "operator_acceptance": {"status": "accepted", "accepted_by": "operator"},
        }
        for amendment in (None, {"status": "draft"}, {"status": "accepted", "operator_acceptance": {"status": "pending", "accepted_by": None}}):
            payload = copy.deepcopy(canonical)
            payload["s1b_execution"] = {"initiated": True}
            if amendment is not None:
                payload["s1a_amendment"] = amendment
            name = f"initiated-before-accepted-amendment-{amendment!r}"
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label=name)

        for amendment in (
            {"status": "accepted", "operator_acceptance": {"status": "accepted", "accepted_by": ""}},
            {"status": "accepted", "operator_acceptance": {"status": "accepted", "accepted_by": 7}},
            {"status": "accepted", "operator_acceptance": {"status": 1, "accepted_by": "operator"}},
        ):
            payload = copy.deepcopy(canonical)
            payload["s1b_execution"] = {"initiated": True}
            payload["s1a_amendment"] = amendment
            name = f"invalid-amendment-acceptance-{amendment!r}"
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label=name)

        payload = copy.deepcopy(canonical)
        payload["s1b_execution"] = {"initiated": True}
        payload["s1a_amendment"] = accepted_amendment
        with self.subTest(case="initiated-after-accepted-amendment"):
            self.invoke(payload=payload, expected_code=0, marker=PASS, label="initiated-after-accepted-amendment")

    def test_r_inferred_acceptance_is_never_accepted(self):
        canonical = load_json("canonical-authority-positive.json")
        for payload in (
            {"inferred_acceptance": True},
            {"inferred_acceptance": True, "initiated": False},
            {
                "inferred_acceptance": True,
                "initiated": True,
                "s1a_amendment": {
                    "status": "accepted",
                    "operator_acceptance": {"status": "accepted", "accepted_by": "operator"},
                },
            },
        ):
            candidate = copy.deepcopy(canonical)
            candidate["s1b_execution"] = payload
            name = f"inferred-acceptance-{payload!r}"
            with self.subTest(case=name):
                self.invoke(payload=candidate, expected_code=1, marker="[ERROR: SEQUENCE_GATE_INVALID]", label=name)

    def test_s_nested_amendment_invariants_are_independent_of_s1b(self):
        canonical = load_json("canonical-authority-positive.json")
        base = copy.deepcopy(canonical)
        base["s1b_execution"] = {"initiated": False}

        controls = {
            "draft": {"status": "draft"},
            "draft-pre-s1a-normalized": {"status": " Draft-Pre-S1A "},
            "accepted": {
                "status": "ACCEPTED",
                "operator_acceptance": {"status": "accepted", "accepted_by": "operator"},
            },
            "draft-pending-record": {
                "status": "draft",
                "operator_acceptance": {"status": "pending", "accepted_by": None},
            },
        }
        for name, amendment in controls.items():
            payload = copy.deepcopy(base)
            payload["s1a_amendment"] = amendment
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=0, marker=PASS, label=f"s1a-amendment-{name}")

        rejected = {
            "missing-status": {},
            "unknown-status": {"status": "review"},
            "non-string-status": {"status": 1},
            "accepted-without-record": {"status": "accepted"},
            "accepted-with-pending-record": {
                "status": "accepted",
                "operator_acceptance": {"status": "pending", "accepted_by": None},
            },
            "accepted-with-empty-accepted-by": {
                "status": "accepted",
                "operator_acceptance": {"status": "accepted", "accepted_by": ""},
            },
            "accepted-with-non-string-accepted-by": {
                "status": "accepted",
                "operator_acceptance": {"status": "accepted", "accepted_by": 7},
            },
            "draft-with-accepted-record": {
                "status": "draft",
                "operator_acceptance": {"status": "accepted", "accepted_by": "operator"},
            },
            "pending-with-accepted-by": {
                "status": "draft-pre-s1a",
                "operator_acceptance": {"status": "pending", "accepted_by": "operator"},
            },
            "unknown-record-status": {
                "status": "draft",
                "operator_acceptance": {"status": "review", "accepted_by": None},
            },
        }
        for name, amendment in rejected.items():
            payload = copy.deepcopy(base)
            payload["s1a_amendment"] = amendment
            with self.subTest(case=name):
                self.invoke(
                    payload=payload,
                    expected_code=1,
                    marker="[ERROR: SEQUENCE_GATE_INVALID]",
                    label=f"s1a-amendment-{name}",
                )

    def test_t_external_and_reverse_boolean_types_and_authority_class(self):
        canonical = load_json("canonical-authority-positive.json")

        false_controls = copy.deepcopy(canonical)
        false_controls["external_provenance"].update({"overrides_repo_local": False, "is_governing": False})
        false_controls["reverse_edge_claim"] = {
            "claimed_as_canonical": False,
            "derives_expected_from_export": False,
            "description": {"arbitrary": "descriptive metadata"},
        }
        self.invoke(payload=false_controls, expected_code=0, marker=PASS, label="external-reverse-false-controls")

        for container, field in (
            ("external_provenance", "overrides_repo_local"),
            ("external_provenance", "is_governing"),
            ("reverse_edge_claim", "claimed_as_canonical"),
            ("reverse_edge_claim", "derives_expected_from_export"),
        ):
            for value in (1, 0, "true", "false", None):
                payload = copy.deepcopy(canonical)
                payload.setdefault(container, {})[field] = value
                name = f"{container}-{field}-{value!r}"
                with self.subTest(case=name):
                    self.invoke(payload=payload, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label=name)

        for value in ("unknown-class", 1, 0, None, [], {}):
            payload = copy.deepcopy(canonical)
            payload["external_provenance"]["authority_class"] = value
            name = f"external-authority-class-{value!r}"
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=2, marker="[ERROR: INVALID_FIXTURE_STRUCTURE]", label=name)

        for class_name in CLASS_NAMES:
            payload = copy.deepcopy(canonical)
            payload["external_provenance"]["authority_class"] = class_name
            expected_code = 1 if class_name == "governing-authority" else 0
            marker = "[ERROR: AUTHORITY_PATH_INVALID]" if expected_code else PASS
            with self.subTest(case=f"canonical-authority-class-{class_name}"):
                self.invoke(payload=payload, expected_code=expected_code, marker=marker, label=f"canonical-authority-class-{class_name}")

        for container, field, marker in (
            ("external_provenance", "overrides_repo_local", "[ERROR: AUTHORITY_PATH_INVALID]"),
            ("external_provenance", "is_governing", "[ERROR: AUTHORITY_PATH_INVALID]"),
            ("external_provenance", "authority_class", "[ERROR: AUTHORITY_PATH_INVALID]"),
            ("reverse_edge_claim", "claimed_as_canonical", "[ERROR: AUTHORITY_PATH_INVALID]"),
            ("reverse_edge_claim", "derives_expected_from_export", "[ERROR: AUTHORITY_PATH_INVALID]"),
        ):
            payload = copy.deepcopy(canonical)
            payload.setdefault(container, {})[field] = True if field != "authority_class" else "governing-authority"
            name = f"semantic-{container}-{field}"
            with self.subTest(case=name):
                self.invoke(payload=payload, expected_code=1, marker=marker, label=name)

    def test_u_mapping_identity_does_not_require_violated_fields(self):
        control = load_json("acv1-expected-mapping.json")
        with self.subTest(case="canonical-control"):
            self.invoke(payload=control, expected_code=0, marker=PASS, label="u-canonical-control")
        with self.subTest(case="legacy-negative-control"):
            self.invoke(
                payload=load_json("neg-acv1-03-invalid-disposition-or-missing-id.json"),
                expected_code=1,
                marker=NEGATIVE,
                label="u-legacy-negative-control",
            )

        missing_metadata = copy.deepcopy(control)
        missing_metadata.pop("allowed_dispositions")
        missing_metadata.pop("allowed_waves")
        del missing_metadata["decisions"][0]["implementation_owner"]
        with self.subTest(case="missing-allowed-fields-and-owner"):
            self.invoke(
                payload=missing_metadata,
                expected_code=1,
                marker="[ERROR: ACV1_MAPPING_INVALID]",
                label="u-missing-allowed-fields-and-owner",
            )

        for name, contract_mutation in (
            ("unnamed", lambda payload: payload.pop("contract_name")),
            ("renamed", lambda payload: payload.__setitem__("contract_name", "legacy-mapping")),
        ):
            variant = copy.deepcopy(control)
            contract_mutation(variant)
            del variant["decisions"][0]["wave"]
            with self.subTest(case=f"{name}-exact-decision-set-missing-wave"):
                self.invoke(
                    payload=variant,
                    expected_code=1,
                    marker="[ERROR: ACV1_MAPPING_INVALID]",
                    label=f"u-{name}-exact-decision-set-missing-wave",
                )


if __name__ == "__main__":
    unittest.main(verbosity=2)
