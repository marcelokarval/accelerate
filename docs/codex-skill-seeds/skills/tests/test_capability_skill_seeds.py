#!/usr/bin/env python3
"""Validate the versioned, on-demand capability-skill seed contract."""

from __future__ import annotations

import json
import re
import unittest
from pathlib import Path

import yaml


SKILLS_ROOT = Path(__file__).resolve().parents[1]
SEEDS_ROOT = SKILLS_ROOT.parent

CAPABILITY_SKILLS = {
    "nx-nestjs-monorepo-operations": "references/nx-nestjs-monorepo.md",
    "governed-us-lead-data-acquisition": "references/us-lead-governance.md",
    "docker-compose-deployment-operations": "references/compose-deployment.md",
    "chatwoot-conversational-channel-operations": "references/chatwoot-channel-operations.md",
}


def frontmatter(skill_text: str) -> dict:
    if not skill_text.startswith("---\n"):
        return {}
    body, separator, _ = skill_text.removeprefix("---\n").partition("\n---\n")
    if not separator:
        return {}
    parsed = yaml.safe_load(body)
    return parsed if isinstance(parsed, dict) else {}


def metadata(metadata_text: str) -> dict:
    parsed = yaml.safe_load(metadata_text)
    return parsed if isinstance(parsed, dict) else {}


def assert_unique_eval_case_ids(test_case: unittest.TestCase, cases: list[dict]) -> None:
    case_ids = [case.get("id") for case in cases if isinstance(case, dict)]
    test_case.assertEqual(
        len(case_ids),
        len(set(case_ids)),
        "duplicate eval case id detected in evals/evals.json",
    )


def registry_rows(manifest_text: str) -> list[tuple[str, list[str]]]:
    rows = []
    for line in manifest_text.splitlines():
        match = re.fullmatch(r"\|\s*`([^`]+)`\s*\|(.+)\|", line)
        if not match:
            continue
        rows.append((match.group(1), [cell.strip() for cell in match.group(2).split("|")]))
    return rows


def registry_data_lines(manifest_text: str) -> list[str]:
    return [
        line
        for line in manifest_text.splitlines()
        if line.startswith("|")
        and not line.startswith("| Skill")
        and not re.fullmatch(r"\|[- |]+\|", line)
    ]


class CapabilitySkillSeedsTest(unittest.TestCase):
    def test_each_registered_capability_skill_has_a_source_directory(self) -> None:
        missing = [
            skill_name
            for skill_name in CAPABILITY_SKILLS
            if not (SKILLS_ROOT / skill_name).is_dir()
        ]
        self.assertEqual([], missing, f"missing capability skill source directories: {', '.join(missing)}")

    def test_existing_capability_packages_match_the_agent_skills_contract(self) -> None:
        missing = [
            skill_name
            for skill_name in CAPABILITY_SKILLS
            if not (SKILLS_ROOT / skill_name).is_dir()
        ]
        if missing:
            self.skipTest("package contract begins after source directories exist")

        for skill_name, reference in CAPABILITY_SKILLS.items():
            with self.subTest(skill=skill_name):
                skill_dir = SKILLS_ROOT / skill_name
                skill_path = skill_dir / "SKILL.md"
                metadata_path = skill_dir / "metadata.yaml"
                self.assertTrue(skill_path.is_file(), "missing SKILL.md")
                self.assertTrue(metadata_path.is_file(), "missing metadata.yaml")

                skill_text = skill_path.read_text(encoding="utf-8")
                metadata_text = metadata_path.read_text(encoding="utf-8")
                self.assertEqual(skill_name, frontmatter(skill_text).get("name"))
                skill_metadata = metadata(metadata_text)
                self.assertEqual(skill_name, skill_metadata.get("name"))
                self.assertIn(reference, skill_text)
                self.assertTrue((skill_dir / reference).is_file(), f"missing {reference}")
                self.assertEqual("active", skill_metadata.get("status"))
                self.assertEqual("on-demand", skill_metadata.get("runtime_placement"))
                self.assertIs(False, skill_metadata.get("preload"))

    def test_capability_packages_have_agent_metadata_and_evals(self) -> None:
        for skill_name in CAPABILITY_SKILLS:
            with self.subTest(skill=skill_name):
                skill_dir = SKILLS_ROOT / skill_name
                agent_path = skill_dir / "agents" / "openai.yaml"
                evals_path = skill_dir / "evals" / "evals.json"
                self.assertTrue(agent_path.is_file(), "missing agents/openai.yaml")
                self.assertTrue(evals_path.is_file(), "missing evals/evals.json")

                agent_config = yaml.safe_load(agent_path.read_text(encoding="utf-8"))
                self.assertIsInstance(agent_config, dict)
                interface = agent_config.get("interface")
                self.assertIsInstance(interface, dict)
                for key in ("display_name", "short_description", "default_prompt"):
                    self.assertIsInstance(interface.get(key), str, f"missing interface.{key}")
                    self.assertTrue(interface[key].strip(), f"empty interface.{key}")
                self.assertIn(f"${skill_name}", interface["default_prompt"])

                with evals_path.open(encoding="utf-8") as evals_file:
                    evals = json.load(evals_file)
                self.assertEqual(skill_name, evals.get("skill"))
                self.assertIsInstance(evals.get("cases"), list)
                self.assertTrue(evals["cases"], "eval cases must not be empty")
                assert_unique_eval_case_ids(self, evals["cases"])
                for case in evals["cases"]:
                    self.assertIsInstance(case, dict)
                    for key in ("id", "prompt", "expect"):
                        self.assertIn(key, case)
                        self.assertTrue(case[key], f"empty eval case {key}")

    def test_duplicate_eval_case_ids_fail_closed(self) -> None:
        with self.assertRaisesRegex(AssertionError, "duplicate eval case id"):
            assert_unique_eval_case_ids(self, [{"id": "same"}, {"id": "same"}])

    def test_capability_guardrails_remain_explicit(self) -> None:
        skill_text = {
            skill_name: (SKILLS_ROOT / skill_name / "SKILL.md").read_text(encoding="utf-8")
            for skill_name in CAPABILITY_SKILLS
        }
        lead_reference = (
            SKILLS_ROOT
            / "governed-us-lead-data-acquisition"
            / "references"
            / "us-lead-governance.md"
        ).read_text(encoding="utf-8")

        self.assertIn("pnpm", skill_text["nx-nestjs-monorepo-operations"])
        self.assertIn("Nx", skill_text["nx-nestjs-monorepo-operations"])
        self.assertIn("US-only", skill_text["governed-us-lead-data-acquisition"])
        self.assertIn("## Privacy Consultation (Non-Gate)", lead_reference)
        self.assertIn("LGPD", lead_reference)
        self.assertIn("not an operational gate", lead_reference)
        self.assertIn("docker compose down -v", skill_text["docker-compose-deployment-operations"])
        self.assertIn("Chatwoot", skill_text["chatwoot-conversational-channel-operations"])
        self.assertIn("WhatsApp Web", skill_text["chatwoot-conversational-channel-operations"])
        self.assertIn("Baileys", skill_text["chatwoot-conversational-channel-operations"])

    def test_seed_documentation_and_registry_state_the_source_and_non_preload_policy(self) -> None:
        seeds_readme = (SEEDS_ROOT / "README.md").read_text(encoding="utf-8")
        skills_readme = (SKILLS_ROOT / "README.md").read_text(encoding="utf-8")
        manifest_path = SKILLS_ROOT / "_registry" / "manifest.md"

        self.assertIn("versioned source", seeds_readme)
        self.assertIn("root-level `skills/`", seeds_readme)
        self.assertIn("versioned source", skills_readme)
        self.assertIn("not preload", skills_readme)
        self.assertTrue(manifest_path.is_file(), "missing capability seed registry manifest")

        manifest = manifest_path.read_text(encoding="utf-8")
        rows = registry_rows(manifest)
        self.assertEqual(len(registry_data_lines(manifest)), len(rows), "invalid registry table row")
        registered_names = [name for name, _ in rows]
        self.assertEqual(list(CAPABILITY_SKILLS), registered_names)
        self.assertEqual(len(registered_names), len(set(registered_names)), "duplicate registry entries")

        for skill_name, columns in rows:
            with self.subTest(registry_skill=skill_name):
                self.assertEqual(3, len(columns), "registry entry must contain category, source, and runtime")
                self.assertEqual(f"`../{skill_name}/`", columns[1])
                self.assertEqual("on-demand; not preload", columns[2])


if __name__ == "__main__":
    unittest.main(verbosity=2)
