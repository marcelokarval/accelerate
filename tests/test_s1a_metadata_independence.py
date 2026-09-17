#!/usr/bin/env python3
"""Regression tests proving S1A fixture verdicts do not trust diagnostics."""

import copy
import json
import subprocess
import sys
import unittest
from pathlib import Path
from tempfile import TemporaryDirectory


ROOT = Path(__file__).resolve().parents[1]
FIXTURES = ROOT / "tests" / "fixtures" / "contract-v1-authority"
VALIDATOR = ROOT / "scripts" / "validate-accelerate-v020-s1a-authority.py"

NEGATIVES = (
    (
        "NEG-R01-01",
        "neg-r01-01-external-authority-override.json",
        "EXTERNAL_AUTHORITY_OVERRIDE",
        "[NEG-R01-01: EXTERNAL_AUTHORITY_OVERRIDE_REJECTED]",
    ),
    (
        "NEG-R01-02",
        "neg-r01-02-generated-export-as-canonical.json",
        "REVERSE_EDGE_EXPORT_AS_CANONICAL",
        "[NEG-R01-02: REVERSE_EDGE_EXPORT_AS_CANONICAL_REJECTED]",
    ),
    (
        "NEG-ACV1-03",
        "neg-acv1-03-invalid-disposition-or-missing-id.json",
        "ACV1_MAPPING_NON_COMPLIANT",
        "[NEG-ACV1-03: ACV1_MAPPING_NON_COMPLIANT_REJECTED]",
    ),
    (
        "NEG-SEQ-04",
        "neg-seq-04-draft-authorizing-advance.json",
        "DRAFT_AUTHORIZATION_OF_ADVANCE",
        "[NEG-SEQ-04: DRAFT_AUTHORIZATION_OF_ADVANCE_REJECTED]",
    ),
    (
        "NEG-SEQ-05",
        "neg-seq-05-s1b-started-before-amendment-accepted.json",
        "S1B_PREMATURE_START",
        "[NEG-SEQ-05: S1B_PREMATURE_START_REJECTED]",
    ),
)

DIAGNOSTIC_FIELDS = (
    "fixture_id",
    "violation",
    "expected_verdict",
    "expected_marker",
    "expected_rejection_marker",
    "missing_decision_ids",
    "invalid_dispositions",
    "decisions_count",
)


def load_fixture(name):
    return json.loads((FIXTURES / name).read_text(encoding="utf-8"))


class S1AMetadataIndependenceTests(unittest.TestCase):
    def run_fixture(self, payload, expected_code, marker, label):
        with TemporaryDirectory() as temporary:
            fixture = Path(temporary) / f"{label}.json"
            fixture.write_text(json.dumps(payload), encoding="utf-8")
            result = subprocess.run(
                [sys.executable, "-B", str(VALIDATOR), "--fixture", str(fixture)],
                cwd=ROOT,
                capture_output=True,
                text=True,
                check=False,
            )
        output = result.stdout + result.stderr
        self.assertEqual(result.returncode, expected_code, output)
        self.assertIn(marker, output)

    def test_canonical_metadata_annotations_are_ignored(self):
        canonical = load_fixture("canonical-authority-positive.json")
        self.run_fixture(canonical, 0, "[PASS: S1A_AUTHORITY_CANONICAL_VALID]", "canonical-control")
        for fixture_id, _, violation_type, _ in NEGATIVES:
            variants = (
                ("fixture-id", {"fixture_id": fixture_id}),
                ("violation", {"violation": {"type": violation_type, "detail": "diagnostic-only annotation"}}),
                (
                    "both",
                    {
                        "fixture_id": fixture_id,
                        "violation": {"type": violation_type, "detail": "diagnostic-only annotation"},
                    },
                ),
            )
            for variant, annotations in variants:
                payload = copy.deepcopy(canonical)
                payload.update(annotations)
                with self.subTest(fixture_id=fixture_id, variant=variant):
                    self.run_fixture(payload, 0, "[PASS: S1A_AUTHORITY_CANONICAL_VALID]", f"{fixture_id}-{variant}")

    def test_original_negative_semantics_survive_metadata_removal(self):
        for fixture_id, filename, _, marker in NEGATIVES:
            payload = load_fixture(filename)
            for field in DIAGNOSTIC_FIELDS:
                payload.pop(field, None)
            with self.subTest(fixture_id=fixture_id):
                self.run_fixture(payload, 1, marker, f"{fixture_id}-without-diagnostics")

    def test_valid_mapping_ignores_contradictory_summary_annotations(self):
        payload = load_fixture("acv1-expected-mapping.json")
        payload.update(
            {
                "missing_decision_ids": ["ACV1-D999"],
                "invalid_dispositions": [{"id": "ACV1-D999", "disposition": "deprecated"}],
                "decisions_count": 999,
            }
        )
        self.run_fixture(payload, 0, "[PASS: S1A_AUTHORITY_CANONICAL_VALID]", "mapping-contradictory-summaries")

    def test_mapping_content_errors_are_rejected_without_diagnostics(self):
        mapping = load_fixture("acv1-expected-mapping.json")

        missing = copy.deepcopy(mapping)
        missing["decisions"] = [decision for decision in missing["decisions"] if decision["short_id"] != "D005"]

        duplicate = copy.deepcopy(mapping)
        d001 = next(decision for decision in duplicate["decisions"] if decision["short_id"] == "D001")
        duplicate["decisions"] = [decision for decision in duplicate["decisions"] if decision["short_id"] != "D005"] + [copy.deepcopy(d001)]

        invalid = copy.deepcopy(mapping)
        next(decision for decision in invalid["decisions"] if decision["short_id"] == "D001")["disposition"] = "deprecated"

        for name, payload in (("missing-d005", missing), ("duplicate-d001", duplicate), ("invalid-d001-disposition", invalid)):
            for field in DIAGNOSTIC_FIELDS:
                payload.pop(field, None)
            with self.subTest(case=name):
                self.run_fixture(payload, 1, "[NEG-ACV1-03: ACV1_MAPPING_NON_COMPLIANT_REJECTED]", f"mapping-{name}")


if __name__ == "__main__":
    unittest.main()
