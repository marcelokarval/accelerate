#!/usr/bin/env python3
"""Validate quality-skill package and eval-fixture contracts, not LLM behavior."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
from datetime import date
from pathlib import Path, PurePosixPath
from typing import Any

import yaml


CASE_FIELDS = {"id", "prompt", "should_trigger", "expected_behavior"}
ROLES = {"positive", "negative", "collision", "brownfield", "pressure"}
OPTIONAL_ROLES = {"behavioral"}
METADATA_REQUIRED = {
    "name",
    "category",
    "status",
    "source",
    "runtime_export",
    "local_native_owner",
    "sync_policy",
}
METADATA_OPTIONAL = {
    "description",
    "owner",
    "adaptation_policy",
    "last_reviewed",
    "references",
    "provenance",
}
STATUS_ALLOWLIST = {"native", "native-adapted", "standalone-adapted"}
ROOT = Path(__file__).resolve().parent.parent
REVIEWED_SNAPSHOT_PATH = ROOT / "skills/_registry/quality-skill-reviewed-snapshot.json"
REVIEWED_PACKAGE_PATHS = (
    "skills/workflow/specification-lifecycle",
    "skills/workflow/test-driven-development",
    "skills/review/test-engineering",
    "skills/review/source-verification",
    "skills/review/solution-minimalism",
    "skills/review/web-performance-review",
    "skills/review/code-audit",
    "skills/review/requesting-code-review",
    "skills/security/security-patterns",
)
SNAPSHOT_TOP_FIELDS = {
    "schema_version",
    "contract",
    "hash_algorithm",
    "tree_encoding",
    "packages",
}
SNAPSHOT_PACKAGE_FIELDS = {"path", "tree_sha256", "files"}
SNAPSHOT_FILE_FIELDS = {"path", "size", "sha256"}
SNAPSHOT_CONTRACT = "reviewed-package-integrity-not-llm-behavior"
SNAPSHOT_TREE_ENCODING = "canonical-json-v1"
CACHE_DIRECTORY_NAMES = {"__pycache__", ".pytest_cache", ".mypy_cache", ".ruff_cache"}
CACHE_FILE_SUFFIXES = {".pyc", ".pyo"}
SHA256_HEX = re.compile(r"^[0-9a-f]{64}$")
SKILL_CONCEPT_GROUPS = {
    "specification-lifecycle": (
        {"spec", "specification", "sdd"},
        {"requirement", "requirements", "artifact", "artifacts", "traceability"},
        {"implementation", "readiness", "acceptance", "mutation", "design"},
    ),
    "test-driven-development": (
        {"test", "tests", "testing", "tdd", "red"},
        {"green", "baseline", "repro", "characterization"},
        {"proof", "correction", "refactor", "migration", "behavior"},
    ),
    "test-engineering": (
        {"test", "tests", "testing"},
        {"strategy", "regression", "proof", "suite", "fixture", "fixtures"},
        {"independent", "independently", "negative", "nonfunctional", "acceptance", "authorship", "boundary"},
    ),
    "source-verification": (
        {"source", "sources"},
        {"claim", "claims", "version", "authority"},
        {"evidence", "verify", "verification", "corroboration", "uncertainty", "contradiction"},
    ),
    "solution-minimalism": (
        {"minimal", "minimalism", "simplify", "simplification", "smallest"},
        {"complexity", "reuse", "dependency", "dependencies", "solution"},
        {"guarantee", "guarantees", "spec", "green", "proof", "security"},
    ),
    "web-performance-review": (
        {"web", "performance"},
        {"lighthouse", "crux", "trace", "traces", "metric", "metrics"},
        {"measured", "measurement", "source", "unmeasured", "runtime", "field", "lab"},
    ),
    "code-audit": (
        {"audit", "review"},
        {"finding", "findings", "severity", "evidence", "candidate", "candidates"},
        {"correctness", "security", "architecture", "tests", "performance", "legibility"},
    ),
    "requesting-code-review": (
        {"review", "reviews", "reviewer", "reviewers"},
        {"independent", "candidate", "implementation"},
        {"proof", "acceptance", "mutation", "publication", "correction"},
    ),
    "security-patterns": (
        {"security", "trust"},
        {"actor", "actors", "threat", "threats", "exploit", "exploitability", "stride"},
        {"auth", "authorization", "ownership", "negative", "proof", "supply"},
    ),
}
COLLISION_OWNERS = {
    "specification-lifecycle": {"architecture"},
    "test-driven-development": {"systematic", "debugging"},
    "test-engineering": {"product", "browser", "qa", "runtime"},
    "source-verification": {"code", "audit"},
    "solution-minimalism": {"security", "patterns"},
    "web-performance-review": {"product", "browser", "runtime"},
    "code-audit": {"security", "patterns"},
    "requesting-code-review": {"github", "code", "review"},
    "security-patterns": {"code", "audit"},
}
PRESSURE_INVARIANTS = {
    "specification-lifecycle": {"spec", "specification", "artifact", "readiness"},
    "test-driven-development": {"proof", "baseline", "red", "migration"},
    "test-engineering": {"independent", "independence", "reviewer", "acceptance"},
    "source-verification": {"source", "evidence", "authority", "proof"},
    "solution-minimalism": {"guarantee", "guarantees", "rollback", "security", "observability"},
    "web-performance-review": {"metric", "metrics", "unavailable", "unmeasured", "source"},
    "code-audit": {"severity", "evidence", "candidate", "impact"},
    "requesting-code-review": {"independent", "authority", "review", "acceptance"},
    "security-patterns": {"safe", "poc", "proof", "authority", "negative"},
}
BEHAVIORAL_ORACLES = {
    "specification-lifecycle": {"draft", "readiness", "implementation", "proof"},
    "test-driven-development": {"hybrid", "baseline", "prove", "browser", "provider"},
    "test-engineering": {"invalidate", "stale", "rerun", "suite", "proof"},
    "source-verification": {"version", "observed", "inapplicable", "stale", "contradiction"},
    "solution-minimalism": {"route", "diagnosis", "specification", "architecture", "owner"},
    "web-performance-review": {"field", "lab", "metric", "trace", "regression"},
    "code-audit": {"candidate", "evidence", "severity", "signal"},
    "requesting-code-review": {"correction", "proof", "review", "stale"},
    "security-patterns": {"trust", "exploitability", "negative", "proof", "abuse"},
}
NEGATIVE_BOUNDARY_ANCHORS = {
    "specification-lifecycle": {"sdd", "lifecycle"},
    "test-driven-development": {"proof", "loop", "read"},
    "test-engineering": {"unit", "conversationally"},
    "source-verification": {"acquisition", "protocol", "search"},
    "solution-minimalism": {"specification", "green", "debugging"},
    "web-performance-review": {"backend", "architecture", "migration"},
    "code-audit": {"implementation", "audit"},
    "requesting-code-review": {"architecture", "candidate"},
    "security-patterns": {"authentication", "security", "content"},
}
BROWNFIELD_OWNERSHIP_ANCHORS = {
    "specification-lifecycle": {"requirements", "design", "mappings"},
    "test-driven-development": {"regression", "test", "red"},
    "test-engineering": {"suite", "regression", "proof"},
    "source-verification": {"authority", "evidence", "contradiction"},
    "solution-minimalism": {"simplification", "minimalism", "correction", "solution"},
    "web-performance-review": {"metrics", "quick", "static", "web", "performance"},
    "code-audit": {"review", "audit", "defects", "finding"},
    "requesting-code-review": {"review", "candidate", "proof"},
    "security-patterns": {"trust", "security", "risk"},
}


class ValidationError(ValueError):
    pass


def text(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip())


def substantive(value: Any, *, minimum_words: int = 6, minimum_chars: int = 32) -> bool:
    if not text(value) or len(value.strip()) < minimum_chars:
        return False
    words = re.findall(r"[A-Za-z0-9]+", value)
    return len(words) >= minimum_words and len({word.lower() for word in words}) >= 5


def semantic_words(value: str) -> set[str]:
    return set(re.findall(r"[a-z0-9]+", value.lower()))


def ownership_group_matches(skill_name: str, value: str) -> list[set[str]]:
    groups = SKILL_CONCEPT_GROUPS.get(skill_name)
    if groups is None:
        return []
    words = semantic_words(value)
    return [words & group for group in groups]


def matched_group_count(skill_name: str, value: str) -> int:
    return sum(bool(matches) for matches in ownership_group_matches(skill_name, value))


def load_yaml(path: Path) -> Any:
    try:
        return yaml.safe_load(path.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ValidationError(f"{path}: cannot read: {exc}") from exc
    except yaml.YAMLError as exc:
        raise ValidationError(f"{path}: invalid YAML: {exc}") from exc


def is_cache_resource(path: PurePosixPath) -> bool:
    return any(part in CACHE_DIRECTORY_NAMES for part in path.parts) or (
        path.suffix in CACHE_FILE_SUFFIXES
    )


def canonical_tree_digest(files: list[dict[str, Any]]) -> str:
    encoded = json.dumps(
        files,
        ensure_ascii=False,
        separators=(",", ":"),
        sort_keys=True,
    ).encode("utf-8")
    return hashlib.sha256(encoded).hexdigest()


def package_file_records(directory: Path) -> list[dict[str, Any]]:
    if directory.is_symlink():
        raise ValidationError(f"{directory}: reviewed package root must not be a symlink")
    records: list[dict[str, Any]] = []
    paths = sorted(directory.rglob("*"), key=lambda path: path.relative_to(directory).as_posix())
    for path in paths:
        relative = PurePosixPath(path.relative_to(directory).as_posix())
        if path.is_symlink():
            raise ValidationError(f"{path}: symlinks are forbidden in reviewed packages")
        if is_cache_resource(relative):
            continue
        if path.is_dir():
            continue
        if not path.is_file():
            raise ValidationError(f"{path}: non-regular resources are forbidden")
        try:
            payload = path.read_bytes()
        except OSError as exc:
            raise ValidationError(f"{path}: cannot read reviewed resource: {exc}") from exc
        records.append(
            {
                "path": relative.as_posix(),
                "size": len(payload),
                "sha256": hashlib.sha256(payload).hexdigest(),
            }
        )
    return records


def load_reviewed_snapshot() -> dict[str, dict[str, Any]]:
    try:
        snapshot = json.loads(REVIEWED_SNAPSHOT_PATH.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ValidationError(f"{REVIEWED_SNAPSHOT_PATH}: cannot read: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise ValidationError(f"{REVIEWED_SNAPSHOT_PATH}: invalid JSON: {exc}") from exc

    if not isinstance(snapshot, dict) or set(snapshot) != SNAPSHOT_TOP_FIELDS:
        raise ValidationError(
            f"{REVIEWED_SNAPSHOT_PATH}: reviewed snapshot has an invalid top-level schema"
        )
    if type(snapshot["schema_version"]) is not int or snapshot["schema_version"] != 1:
        raise ValidationError(f"{REVIEWED_SNAPSHOT_PATH}: schema_version must be integer 1")
    if snapshot["contract"] != SNAPSHOT_CONTRACT:
        raise ValidationError(f"{REVIEWED_SNAPSHOT_PATH}: reviewed snapshot contract is invalid")
    if snapshot["hash_algorithm"] != "sha256":
        raise ValidationError(f"{REVIEWED_SNAPSHOT_PATH}: hash_algorithm must be sha256")
    if snapshot["tree_encoding"] != SNAPSHOT_TREE_ENCODING:
        raise ValidationError(
            f"{REVIEWED_SNAPSHOT_PATH}: tree_encoding must be {SNAPSHOT_TREE_ENCODING}"
        )
    packages = snapshot["packages"]
    if not isinstance(packages, list) or len(packages) != len(REVIEWED_PACKAGE_PATHS):
        raise ValidationError(f"{REVIEWED_SNAPSHOT_PATH}: reviewed denominator size is invalid")

    indexed: dict[str, dict[str, Any]] = {}
    observed_paths: list[str] = []
    for index, package in enumerate(packages):
        if not isinstance(package, dict) or set(package) != SNAPSHOT_PACKAGE_FIELDS:
            raise ValidationError(
                f"{REVIEWED_SNAPSHOT_PATH}: package {index} has an invalid exact schema"
            )
        package_path = package["path"]
        if not isinstance(package_path, str):
            raise ValidationError(f"{REVIEWED_SNAPSHOT_PATH}: package path must be a string")
        relative_package = PurePosixPath(package_path)
        if (
            relative_package.is_absolute()
            or ".." in relative_package.parts
            or relative_package.as_posix() != package_path
        ):
            raise ValidationError(
                f"{REVIEWED_SNAPSHOT_PATH}: package paths must be normalized and repo-relative"
            )
        observed_paths.append(package_path)
        if not isinstance(package["tree_sha256"], str) or not SHA256_HEX.fullmatch(
            package["tree_sha256"]
        ):
            raise ValidationError(
                f"{REVIEWED_SNAPSHOT_PATH}: package tree digest must be lowercase SHA256"
            )
        files = package["files"]
        if not isinstance(files, list) or not files:
            raise ValidationError(f"{REVIEWED_SNAPSHOT_PATH}: package files must be non-empty")
        file_paths: list[str] = []
        for file_index, record in enumerate(files):
            if not isinstance(record, dict) or set(record) != SNAPSHOT_FILE_FIELDS:
                raise ValidationError(
                    f"{REVIEWED_SNAPSHOT_PATH}: file {file_index} has an invalid exact schema"
                )
            relative_file = PurePosixPath(record["path"]) if isinstance(record["path"], str) else None
            if (
                relative_file is None
                or relative_file.is_absolute()
                or ".." in relative_file.parts
                or relative_file.as_posix() != record["path"]
                or is_cache_resource(relative_file)
            ):
                raise ValidationError(
                    f"{REVIEWED_SNAPSHOT_PATH}: file paths must be normalized, repo-relative, and non-cache"
                )
            if type(record["size"]) is not int or record["size"] < 0:
                raise ValidationError(f"{REVIEWED_SNAPSHOT_PATH}: file size must be non-negative")
            if not isinstance(record["sha256"], str) or not SHA256_HEX.fullmatch(record["sha256"]):
                raise ValidationError(
                    f"{REVIEWED_SNAPSHOT_PATH}: file digest must be lowercase SHA256"
                )
            file_paths.append(record["path"])
        if file_paths != sorted(file_paths) or len(file_paths) != len(set(file_paths)):
            raise ValidationError(
                f"{REVIEWED_SNAPSHOT_PATH}: package file set must be sorted and unique"
            )
        if canonical_tree_digest(files) != package["tree_sha256"]:
            raise ValidationError(
                f"{REVIEWED_SNAPSHOT_PATH}: package tree digest does not match its file set"
            )
        indexed[relative_package.name] = package

    if tuple(observed_paths) != REVIEWED_PACKAGE_PATHS or len(indexed) != len(packages):
        raise ValidationError(
            f"{REVIEWED_SNAPSHOT_PATH}: reviewed denominator paths must match the frozen nine-package set"
        )
    return indexed


def validate_reviewed_package_snapshot(
    directory: Path, indexed_snapshot: dict[str, dict[str, Any]]
) -> None:
    expected = indexed_snapshot.get(directory.name)
    if expected is None:
        raise ValidationError(f"{directory}: package is outside the frozen reviewed denominator")
    actual_files = package_file_records(directory)
    actual_tree = canonical_tree_digest(actual_files)
    if actual_files != expected["files"] or actual_tree != expected["tree_sha256"]:
        raise ValidationError(
            f"{directory}: reviewed snapshot mismatch for {expected['path']}"
        )


def validate_metadata(path: Path, directory: Path) -> None:
    value = load_yaml(path)
    if not isinstance(value, dict) or not value:
        raise ValidationError(f"{path}: metadata must be a non-empty mapping")
    missing = sorted(METADATA_REQUIRED - set(value))
    unknown = sorted(set(value) - METADATA_REQUIRED - METADATA_OPTIONAL)
    if missing or unknown:
        raise ValidationError(f"{path}: metadata keys missing={missing} unknown={unknown}")
    for field in METADATA_REQUIRED - {"runtime_export"}:
        if not text(value[field]):
            raise ValidationError(f"{path}: metadata.{field} must be a non-empty string")
    if value["name"] != directory.name:
        raise ValidationError(f"{path}: metadata name must match folder")
    expected_source = re.compile(
        rf"^skills/(?P<category>workflow|review|security)/{re.escape(directory.name)}$"
    )
    source_match = expected_source.fullmatch(value["source"])
    if not source_match:
        raise ValidationError(f"{path}: metadata source must name the governed skill path")
    if value["category"] != source_match.group("category"):
        raise ValidationError(f"{path}: metadata category must match the governed source path")
    if value["status"] not in STATUS_ALLOWLIST:
        raise ValidationError(f"{path}: metadata status must be one of {sorted(STATUS_ALLOWLIST)}")
    if value["runtime_export"] not in {"optional", "required", "disabled"}:
        raise ValidationError(f"{path}: runtime_export has an invalid value")
    if value["sync_policy"] != "repo-first":
        raise ValidationError(f"{path}: sync_policy must be repo-first")
    owner = PurePosixPath(value["local_native_owner"])
    if owner.is_absolute() or ".." in owner.parts or not (ROOT / owner).exists():
        raise ValidationError(
            f"{path}: local_native_owner must resolve to an existing repo-relative path"
        )
    for field in ("description", "owner", "adaptation_policy", "provenance"):
        if field in value and not text(value[field]):
            raise ValidationError(f"{path}: metadata.{field} must be a non-empty string")
    if "references" in value:
        refs = value["references"]
        if not isinstance(refs, list) or not refs or not all(text(item) for item in refs):
            raise ValidationError(f"{path}: metadata.references must be a non-empty string list")
        if len(refs) != len(set(refs)):
            raise ValidationError(f"{path}: metadata.references contains duplicates")
        for reference in refs:
            if not re.fullmatch(r"references/[^/]+\.md", reference):
                raise ValidationError(f"{path}: metadata reference must be one hop")
            if not (directory / reference).is_file():
                raise ValidationError(f"{path}: metadata reference does not exist: {reference}")
    if "last_reviewed" in value:
        reviewed = value["last_reviewed"]
        if isinstance(reviewed, str):
            try:
                reviewed = date.fromisoformat(reviewed)
            except ValueError as exc:
                raise ValidationError(f"{path}: last_reviewed must be an ISO date") from exc
        elif not isinstance(reviewed, date):
            raise ValidationError(f"{path}: last_reviewed must be an ISO date")
        if reviewed > date.today():
            raise ValidationError(f"{path}: last_reviewed cannot be in the future")


def validate_interface(path: Path, skill_name: str) -> None:
    value = load_yaml(path)
    if not isinstance(value, dict) or set(value) != {"interface"}:
        raise ValidationError(f"{path}: expected exact interface top-level mapping")
    interface = value["interface"]
    expected = {"display_name", "short_description", "default_prompt"}
    if not isinstance(interface, dict) or set(interface) != expected:
        raise ValidationError(f"{path}: interface must contain exactly {sorted(expected)}")
    if not all(text(interface[field]) for field in expected):
        raise ValidationError(f"{path}: interface fields must be non-empty strings")
    if not 25 <= len(interface["short_description"]) <= 64:
        raise ValidationError(f"{path}: short_description must contain 25-64 characters")
    if f"${skill_name}" not in interface["default_prompt"]:
        raise ValidationError(f"{path}: default_prompt must mention ${skill_name}")


def validate_references(directory: Path, skill_path: Path) -> None:
    body = skill_path.read_text(encoding="utf-8")
    linked = set(re.findall(r"\]\((references/[^)#?]+)(?:#[^)]+)?\)", body))
    reference_dir = directory / "references"
    actual = (
        {path.relative_to(directory).as_posix() for path in reference_dir.rglob("*") if path.is_file()}
        if reference_dir.is_dir()
        else set()
    )
    deep_links = sorted(
        reference for reference in linked
        if not re.fullmatch(r"references/[^/]+", reference)
    )
    deep_files = sorted(
        reference for reference in actual
        if not re.fullmatch(r"references/[^/]+", reference)
    )
    if deep_links or deep_files:
        raise ValidationError(
            f"{skill_path}: references must be exact one-hop files links={deep_links} files={deep_files}"
        )
    broken = sorted(linked - actual)
    orphaned = sorted(actual - linked)
    if broken or orphaned:
        raise ValidationError(
            f"{skill_path}: direct reference links broken={broken} unreferenced={orphaned}"
        )


def classify_case(case_id: str, path: Path) -> str:
    normalized = case_id.lower()
    matched = {
        role for role in ROLES | OPTIONAL_ROLES
        if re.search(rf"(?:^|[^a-z0-9]){role}(?:[^a-z0-9]|$)", normalized)
    }
    if len(matched) != 1:
        raise ValidationError(f"{path}: case id {case_id!r} must encode exactly one role")
    return matched.pop()


def parse_frontmatter(path: Path) -> dict[str, str]:
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except OSError as exc:
        raise ValidationError(f"{path}: cannot read: {exc}") from exc
    if not lines or lines[0] != "---":
        raise ValidationError(f"{path}: missing YAML frontmatter")
    try:
        end = lines.index("---", 1)
    except ValueError as exc:
        raise ValidationError(f"{path}: unterminated YAML frontmatter") from exc

    values: dict[str, str] = {}
    active_key: str | None = None
    for raw in lines[1:end]:
        if not raw.strip():
            continue
        if raw.startswith((" ", "\t")):
            if active_key is None:
                raise ValidationError(f"{path}: invalid indented frontmatter line")
            values[active_key] = f"{values[active_key]} {raw.strip()}".strip()
            continue
        if ":" not in raw:
            raise ValidationError(f"{path}: invalid frontmatter line {raw!r}")
        key, value = raw.split(":", 1)
        active_key = key.strip()
        values[active_key] = value.strip().strip('"\'')

    if set(values) != {"name", "description"}:
        raise ValidationError(
            f"{path}: frontmatter must contain only name and description, found {sorted(values)}"
        )
    if not text(values["name"]) or not text(values["description"]):
        raise ValidationError(f"{path}: name and description must be non-empty")
    return values


def load_cases(path: Path) -> list[dict[str, Any]]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ValidationError(f"{path}: cannot read: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise ValidationError(f"{path}: invalid JSON: {exc}") from exc
    if not isinstance(value, list) or len(value) < 5:
        raise ValidationError(f"{path}: expected at least five eval cases")
    return value


def validate_package(directory: Path) -> None:
    if not directory.is_dir():
        raise ValidationError(f"missing skill directory: {directory}")
    skill_path = directory / "SKILL.md"
    metadata_path = directory / "metadata.yaml"
    interface_path = directory / "agents/openai.yaml"
    eval_path = directory / "evals/evals.json"
    for path in (skill_path, metadata_path, interface_path, eval_path):
        if not path.is_file():
            raise ValidationError(f"missing required file: {path}")
    for path in directory.rglob("*"):
        if path.is_file() and path.name == "README.md":
            raise ValidationError(f"forbidden README.md: {path}")
        if path.name == "__pycache__" or path.suffix == ".pyc":
            raise ValidationError(f"generated cache is forbidden: {path}")
        if path.is_dir() and not any(child.is_file() for child in path.rglob("*")):
            raise ValidationError(f"empty resource directory is forbidden: {path}")

    frontmatter = parse_frontmatter(skill_path)
    if frontmatter["name"] != directory.name:
        raise ValidationError(
            f"{skill_path}: name {frontmatter['name']!r} does not match folder {directory.name!r}"
        )
    if len(skill_path.read_bytes()) > 10_240:
        raise ValidationError(f"{skill_path}: exceeds local 10 KB target")
    if len(skill_path.read_text(encoding="utf-8").splitlines()) > 220:
        raise ValidationError(f"{skill_path}: exceeds local 220-line target")
    if not substantive(frontmatter["description"], minimum_words=12, minimum_chars=80):
        raise ValidationError(f"{skill_path}: description must be a substantive trigger contract")
    skill_text = skill_path.read_text(encoding="utf-8")
    frontmatter_end = skill_text.find("---", 3)
    body = skill_text[frontmatter_end + 3 :].strip() if frontmatter_end >= 0 else ""
    if not substantive(body, minimum_words=24, minimum_chars=160):
        raise ValidationError(f"{skill_path}: instructional body must be substantive")
    if matched_group_count(directory.name, frontmatter["description"]) != 3:
        raise ValidationError(
            f"{skill_path}: description is not semantically bound to {directory.name}"
        )
    if matched_group_count(directory.name, body) != 3:
        raise ValidationError(
            f"{skill_path}: instructional body is not semantically bound to {directory.name}"
        )
    validate_metadata(metadata_path, directory)
    validate_interface(interface_path, directory.name)
    validate_references(directory, skill_path)

    cases = load_cases(eval_path)
    ids: set[str] = set()
    roles: dict[str, int] = {role: 0 for role in ROLES | OPTIONAL_ROLES}
    prompts: set[str] = set()
    for index, case in enumerate(cases):
        if not isinstance(case, dict) or set(case) != CASE_FIELDS:
            raise ValidationError(f"{eval_path}: case {index} has invalid shape")
        if not all(text(case[field]) for field in ("id", "prompt", "expected_behavior")):
            raise ValidationError(f"{eval_path}: case {index} has blank text")
        if not isinstance(case["should_trigger"], bool):
            raise ValidationError(f"{eval_path}: case {case['id']} should_trigger must be boolean")
        if case["id"] in ids:
            raise ValidationError(f"{eval_path}: duplicate case id {case['id']}")
        ids.add(case["id"])
        role = classify_case(case["id"], eval_path)
        roles[role] += 1
        if not substantive(case["prompt"]) or not substantive(case["expected_behavior"]):
            raise ValidationError(f"{eval_path}: case {case['id']} is not substantive")
        normalized_prompt = " ".join(case["prompt"].lower().split())
        if normalized_prompt in prompts:
            raise ValidationError(f"{eval_path}: duplicate prompt semantics")
        prompts.add(normalized_prompt)
        expected = case["expected_behavior"].lower()
        prompt = case["prompt"].lower()
        if directory.name not in SKILL_CONCEPT_GROUPS:
            raise ValidationError(f"{eval_path}: no semantic fixture contract for {directory.name}")
        joined_case = f"{prompt} {expected}"
        if matched_group_count(directory.name, joined_case) < 1:
            raise ValidationError(
                f"{eval_path}: case {case['id']} lacks {directory.name} ownership semantics"
            )
        if role == "positive" and case["should_trigger"] is not True:
            raise ValidationError(f"{eval_path}: positive case must trigger")
        if role == "positive" and (
            matched_group_count(directory.name, prompt) < 1
            or matched_group_count(directory.name, expected) < 1
            or not re.search(r"add|change|review|design|verify|audit|implement|assess|decide|establish", prompt)
        ):
            raise ValidationError(f"{eval_path}: positive case lacks an owned task and response")
        if role == "negative" and case["should_trigger"] is not False:
            raise ValidationError(f"{eval_path}: negative case must not trigger")
        if role == "negative" and not re.search(
            r"do not|does not|without (?:activating|opening|changing)|rather than|route|not (?:the )?owner|treat .* (?:as|rather)",
            expected,
        ):
            raise ValidationError(f"{eval_path}: negative case lacks an excluded-owner boundary")
        if role == "negative" and not (
            semantic_words(joined_case) & NEGATIVE_BOUNDARY_ANCHORS[directory.name]
        ):
            raise ValidationError(
                f"{eval_path}: negative case lacks a package-specific non-trigger boundary"
            )
        if role in {"brownfield", "pressure"} and case["should_trigger"] is not True:
            raise ValidationError(f"{eval_path}: {role} case must trigger")
        if role == "collision" and not re.search(r"route|authorit|\bown|defer|leav", expected):
            raise ValidationError(f"{eval_path}: collision case must resolve adjacent ownership")
        if role == "collision" and not (
            semantic_words(expected) & COLLISION_OWNERS[directory.name]
        ):
            raise ValidationError(f"{eval_path}: collision case must name a concrete adjacent owner")
        if role == "brownfield" and (
            not re.search(r"brownfield|dirty|existing|baseline|unrelated", prompt)
            or not re.search(r"preserv|baseline|avoid|stale|unrelated|user", expected)
            or not (
                semantic_words(joined_case)
                & BROWNFIELD_OWNERSHIP_ANCHORS[directory.name]
            )
        ):
            raise ValidationError(f"{eval_path}: brownfield case lacks state-preservation behavior")
        if role == "pressure" and (
            not re.search(r"deadline|pressure|authority|sunk.?cost", prompt)
            or not re.search(r"reject|resist|refuse|block|preserv", expected)
        ):
            raise ValidationError(f"{eval_path}: pressure case lacks resistance behavior")
        if role == "pressure" and not (
            semantic_words(expected) & PRESSURE_INVARIANTS[directory.name]
        ):
            raise ValidationError(f"{eval_path}: pressure case omits its protected invariant")
        if role == "behavioral" and (
            matched_group_count(directory.name, expected) < 1
            or len(semantic_words(expected) & BEHAVIORAL_ORACLES[directory.name]) < 2
            or not re.search(
                r"invalidate|reconcile|classify|route|prove|trace|inspect|rerun|separate|reject|require|preserve|record|declare|establish|fail|mark|label",
                expected,
            )
        ):
            raise ValidationError(f"{eval_path}: behavioral fixture lacks an observable contract")

    for role in ROLES:
        if roles[role] != 1:
            raise ValidationError(f"{eval_path}: expected exactly one {role} case")
    if roles["behavioral"] != 1:
        raise ValidationError(f"{eval_path}: expected exactly one behavioral case")


def git_status(repo: Path) -> bytes:
    result = subprocess.run(
        ["git", "-C", str(repo), "status", "--porcelain=v1", "-z"],
        check=False,
        capture_output=True,
    )
    if result.returncode != 0:
        raise ValidationError(f"{repo}: brownfield fixture is not a readable git repository")
    return result.stdout


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--brownfield-repo", type=Path)
    parser.add_argument("skill_dirs", nargs="+", type=Path)
    args = parser.parse_args()

    try:
        reviewed_snapshot = load_reviewed_snapshot()
        before = None
        if args.brownfield_repo is not None:
            before = git_status(args.brownfield_repo)
            if not before:
                raise ValidationError(
                    f"{args.brownfield_repo}: expected a dirty brownfield fixture"
                )
        seen_packages: set[str] = set()
        for directory in args.skill_dirs:
            if directory.name in seen_packages:
                raise ValidationError(f"{directory}: duplicate reviewed package input")
            seen_packages.add(directory.name)
            validate_package(directory)
            validate_reviewed_package_snapshot(directory, reviewed_snapshot)
        if args.brownfield_repo is not None:
            after = git_status(args.brownfield_repo)
            if after != before:
                raise ValidationError(
                    f"{args.brownfield_repo}: validation mutated brownfield state"
                )
    except ValidationError as exc:
        print(f"quality skill eval validation failed: {exc}", file=sys.stderr)
        return 1

    print(
        "quality skill fixture-contract and reviewed-package-integrity validation passed "
        f"({len(args.skill_dirs)} skill(s); behavioral replay not performed)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
