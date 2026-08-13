#!/usr/bin/env python3
"""Validate the source-owned Codex routing and specialist-profile catalog."""

from __future__ import annotations

import sys
import tomllib
from pathlib import Path


VALID_CLASSES = {"core", "specialist", "on-demand", "host-injected"}
ROOT_SKILLS = {
    "accelerate", "plane", "prompt-hardening", "skill-catalog-router",
    "subagent-governance", "specification-lifecycle",
    "test-driven-development", "verification-before-completion",
}


def fail(message: str) -> None:
    raise SystemExit(f"codex skill catalog validation failed: {message}")


def expanded_path(source: dict[str, object], group: dict[str, object], skill_id: str) -> str:
    prefix = group.get("path_prefix")
    segments = [str(source["base_path"])]
    if prefix:
        segments.append(str(prefix))
    segments.extend([skill_id, "SKILL.md"])
    return "/".join(segments)


document = tomllib.loads(Path(sys.argv[1]).read_text())
if document.get("schema_version") != 2:
    fail("schema_version must equal 2")
if document.get("catalog_identity") != "codex-runtime-skill-catalog":
    fail("catalog_identity is invalid")
if document.get("root_route") != "skill-catalog-router":
    fail("root_route must use skill-catalog-router")
if not str(document.get("discovery_command") or "").strip():
    fail("discovery_command is required")

sources = document.get("sources")
if not isinstance(sources, list) or not sources:
    fail("sources must be a non-empty list")
source_by_id: dict[str, dict[str, object]] = {}
for source in sources:
    if not isinstance(source, dict):
        fail("each source must be an object")
    source_id = source.get("id")
    if not isinstance(source_id, str) or not source_id or source_id in source_by_id:
        fail("source ids must be unique and non-empty")
    if not str(source.get("base_path") or "").startswith("/"):
        fail(f"source {source_id} must have an absolute base_path")
    source_by_id[source_id] = source

groups = document.get("groups")
if not isinstance(groups, list) or not groups:
    fail("groups must be a non-empty list")

seen_ids: set[str] = set()
seen_paths: set[str] = set()
group_by_id: dict[str, dict[str, object]] = {}
enabled_count = 0
for group in groups:
    if not isinstance(group, dict):
        fail("each group must be an object")
    group_id = group.get("id")
    source_id = group.get("source")
    classification = group.get("classification")
    enabled = group.get("enabled_by_default")
    skill_ids = group.get("skill_ids")
    if not isinstance(group_id, str) or not group_id:
        fail("each group requires a non-empty id")
    if group_id in group_by_id:
        fail(f"duplicate group id: {group_id}")
    if source_id not in source_by_id:
        fail(f"group {group_id} uses an unknown source")
    if classification not in VALID_CLASSES:
        fail(f"group {group_id} has an invalid classification")
    if not isinstance(enabled, bool):
        fail(f"group {group_id} must declare enabled_by_default")
    if not isinstance(skill_ids, list) or not skill_ids or not all(isinstance(item, str) and item for item in skill_ids):
        fail(f"group {group_id} must have non-empty skill_ids")
    if classification == "core" and not enabled:
        fail(f"core group {group_id} must stay enabled")
    if classification == "host-injected" and not enabled:
        fail(f"host-injected group {group_id} must stay enabled")
    if classification == "specialist" and (enabled or not isinstance(group.get("profile"), str)):
        fail(f"specialist group {group_id} needs a disabled named profile")
    if classification == "specialist" and group.get("public_profile") is not False:
        fail(f"specialist group {group_id} must keep its catalog profile internal")
    if classification == "on-demand" and (enabled or group.get("recovery_route") != "skill-catalog-router"):
        fail(f"on-demand group {group_id} must be disabled and router-recoverable")
    if classification == "on-demand" and (not isinstance(group.get("profile"), str) or group.get("public_profile") is not True):
        fail(f"on-demand group {group_id} must expose one public recovery profile")
    group_by_id[group_id] = group
    for skill_id in skill_ids:
        identifier = f"{group.get('identifier_prefix', '')}{skill_id}"
        if identifier in seen_ids:
            fail(f"duplicate skill id: {identifier}")
        path = expanded_path(source_by_id[source_id], group, skill_id)
        if path in seen_paths:
            fail(f"duplicate skill path: {path}")
        seen_ids.add(identifier)
        seen_paths.add(path)
        enabled_count += int(enabled)

if document.get("runtime_skill_count") != len(seen_ids):
    fail(f"runtime_skill_count={document.get('runtime_skill_count')} does not match inventory={len(seen_ids)}")
root = group_by_id.get("root-core", {})
if root.get("classification") != "core" or set(root.get("skill_ids", [])) != ROOT_SKILLS:
    fail("root-core must equal the compact eight-skill orchestrator contract")
superpowers = group_by_id.get("host-superpowers", {})
if (
    superpowers.get("classification") != "on-demand"
    or superpowers.get("profile") != "superpowers-on-demand"
    or superpowers.get("public_profile") is not True
    or superpowers.get("enabled_by_default") is not False
    or superpowers.get("recovery_route") != "skill-catalog-router"
):
    fail("host-superpowers must be a disabled router-recoverable profile")
if enabled_count != 13:
    fail(f"enabled catalog must equal the 13-skill root budget: {enabled_count}")
print(f"codex skill catalog truth gate passed: inventory={len(seen_ids)} enabled={enabled_count}")
