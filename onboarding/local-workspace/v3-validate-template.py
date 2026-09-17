#!/usr/bin/env python3
"""Fail-closed validator for the inactive V3 local-workspace template."""

from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

import yaml


EXPECTED_FILES = {
    "README.md",
    "state.yaml",
    "planning-pointer.yaml",
    "harness/declarations.yaml",
    "harness/overrides.yaml",
    "harness/receipts.yaml",
    "gauntlet/README.md",
    "gauntlet/.gitignore",
}
EXPECTED_DIRS = {".", "harness", "gauntlet"}
STATIC_CONTROL_DIGESTS = {
    "README.md": "040c73a927e13bb9e75a8e4f8fb83414029d5a1660b90195170357253f477ff9",
    "gauntlet/README.md": "97175194fb797a3e085d91f8798f913da98998c20dfd2382cc43340c70fa3fed",
    "gauntlet/.gitignore": "0d5bf23bebba93df40c9b09584d8908e0ad3ef327b6c2ad7ee8bf2c98a97e3de",
}
SQLITE_MAGIC = b"SQLite format 3\x00"
FORBIDDEN_PATH = re.compile(r"(?:openspec|journal|provider[_-]?payload|state\.sqlite3(?:[-.]|$))", re.IGNORECASE)
SECRET = re.compile(
    rb"(?:BEGIN [A-Z ]*PRIVATE KEY|AKIA[0-9A-Z]{16}|github_pat_[A-Za-z0-9_]{20,}|gh[pousr]_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9_-]{20,}|(?:api[_-]?key|secret|token|credential|password)\s*[:=]\s*[\"']?[A-Za-z0-9_./+=-]{12,}[\"']?|authorization\s*[:=]\s*bearer\s*[\"']?[A-Za-z0-9_./+=-]{12,}[\"']?|bearer\s+[\"']?[A-Za-z0-9_./+=-]{12,}[\"']?)",
    re.IGNORECASE,
)


class DuplicateKeyLoader(yaml.SafeLoader):
    pass


def _construct_mapping(loader: DuplicateKeyLoader, node: yaml.MappingNode, deep: bool = False) -> dict:
    mapping = {}
    for key_node, value_node in node.value:
        key = loader.construct_object(key_node, deep=deep)
        if key in mapping:
            raise yaml.constructor.ConstructorError("while constructing a mapping", node.start_mark, f"duplicate key: {key!r}", key_node.start_mark)
        mapping[key] = loader.construct_object(value_node, deep=deep)
    return mapping


DuplicateKeyLoader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, _construct_mapping)


def fail(message: str) -> None:
    raise ValueError(message)


def parse_yaml(path: Path) -> dict:
    try:
        value = yaml.load(path.read_text(encoding="utf-8"), Loader=DuplicateKeyLoader)
    except (OSError, UnicodeDecodeError, yaml.YAMLError) as exc:
        fail(f"invalid YAML {path}: {exc}")
    if not isinstance(value, dict):
        fail(f"YAML document must be a mapping: {path}")
    return value


def exact_mapping(actual: dict, expected: dict, name: str) -> None:
    if actual != expected:
        fail(f"unexpected {name} schema or value")


def validate_tree(root: Path) -> None:
    if not root.is_dir() or root.is_symlink():
        fail("template root is missing or a symlink")
    actual_files: set[str] = set()
    actual_dirs = {"."}
    for path in root.rglob("*"):
        relative = path.relative_to(root).as_posix()
        if path.is_symlink():
            fail(f"symlink is forbidden: {relative}")
        if path.is_dir():
            actual_dirs.add(relative)
        elif path.is_file():
            actual_files.add(relative)
        else:
            fail(f"unsupported template entry: {relative}")
        if FORBIDDEN_PATH.search(relative):
            fail(f"generated state or copied OpenSpec path is forbidden: {relative}")
    if actual_dirs != EXPECTED_DIRS:
        fail(f"unexpected template directories: {sorted(actual_dirs ^ EXPECTED_DIRS)}")
    if actual_files != EXPECTED_FILES:
        fail(f"unexpected template files: {sorted(actual_files ^ EXPECTED_FILES)}")
    for relative in actual_files:
        data = (root / relative).read_bytes()
        if SQLITE_MAGIC in data:
            fail(f"SQLite content is forbidden: {relative}")
        if SECRET.search(data):
            fail(f"probable secret or token is forbidden: {relative}")
    for relative, expected_digest in STATIC_CONTROL_DIGESTS.items():
        actual_digest = hashlib.sha256((root / relative).read_bytes()).hexdigest()
        if actual_digest != expected_digest:
            fail(f"static control content changed: {relative}")


def validate_content(root: Path, design: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    expected_design = repo_root / "planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md"
    if design.is_symlink() or not design.is_file():
        fail("governing design is missing or a symlink")
    try:
        resolved_design = design.resolve(strict=True)
        resolved_expected = expected_design.resolve(strict=True)
    except OSError as exc:
        fail(f"cannot resolve governing design identity: {exc}")
    if resolved_design != resolved_expected:
        fail("governing design is not the repo-owned canonical path")
    try:
        resolved_expected.relative_to(repo_root.resolve(strict=True))
    except ValueError:
        fail("governing design escapes repository root")
    exact_mapping(parse_yaml(root / "state.yaml"), {
        "schema_version": 3,
        "workspace_kind": "local-overlay",
        "template_status": "declaration-only",
        "core_authority": "external",
        "planning_authority": "planning/openspec",
        "planning_pointer": ".accelerate/planning-pointer.yaml",
        "gauntlet_state_root": ".accelerate/gauntlet",
        "harness_root": ".accelerate/harness",
        "runtime_enabled": False,
        "secrets_present": False,
    }, "state")
    digest = hashlib.sha256(design.read_bytes()).hexdigest()
    exact_mapping(parse_yaml(root / "planning-pointer.yaml"), {
        "schema_version": 1,
        "kind": "digest-bound-read-only-pointer",
        "intended_canonical_target": "planning/openspec",
        "target_artifact_digest": "unavailable-pending-activation",
        "target_artifact_digest_status": "no-target-artifact-before-d11-activation",
        "governing_design_path": "planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md",
        "governing_design_sha256": digest,
        "authority": "external-to-overlay",
        "fallback_root": "none",
        "local_copy_permitted": False,
        "writer": "selected-openspec-adapter-only",
    }, "planning pointer")
    exact_mapping(parse_yaml(root / "harness/declarations.yaml"), {
        "schema_version": 1,
        "kind": "local-harness-declarations",
        "authority_mode": "declaration-only",
        "declared_constraints": {
            "project_root": "explicit-required",
            "planning_root": "planning/openspec",
            "state_root": ".accelerate/gauntlet",
            "state_root_must_be_inside_workspace": True,
            "state_root_symlinks_allowed": False,
            "secrets_allowed": False,
            "executable_hooks_allowed": False,
        },
        "authority_grants": [],
    }, "harness declarations")
    exact_mapping(parse_yaml(root / "harness/overrides.yaml"), {
        "schema_version": 1,
        "kind": "local-harness-narrowing-overrides",
        "authority_mode": "may-narrow-never-widen",
        "narrowed_paths": [],
        "narrowed_operations": [],
        "forbidden_widening": [
            "canonical-writer", "provider-or-runtime-activation", "planning-root",
            "state-root", "external-effect-authorization",
        ],
    }, "harness overrides")
    exact_mapping(parse_yaml(root / "harness/receipts.yaml"), {
        "schema_version": 1,
        "kind": "local-harness-receipts",
        "authority_mode": "receipt-only",
        "receipts": [],
        "receipt_is_authorization": False,
    }, "harness receipts")
    expected_ignore = {
        "state.sqlite3", "state.sqlite3-*", "cas/**", "exports/**", "backups/**",
        "journals/**", "provider-payloads/**", "*.lock", "*.log", "private-evidence/**",
    }
    actual_ignore = set((root / "gauntlet/.gitignore").read_text(encoding="utf-8").splitlines())
    if not expected_ignore.issubset(actual_ignore):
        fail("gauntlet ignore policy is incomplete")


def main() -> int:
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} /path/to/v3-template/.accelerate /path/to/governing-design", file=sys.stderr)
        return 2
    try:
        validate_tree(Path(sys.argv[1]))
        validate_content(Path(sys.argv[1]), Path(sys.argv[2]))
    except ValueError as exc:
        print(f"v3 template invalid: {exc}", file=sys.stderr)
        return 1
    print("v3 template valid")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
