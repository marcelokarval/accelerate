#!/usr/bin/env python3
"""Render a compact global skills config or one additive specialist profile."""

from __future__ import annotations

import argparse
import tomllib
from pathlib import Path


def path_for(source: dict[str, object], group: dict[str, object], skill_id: str) -> str:
    parts = [str(source["base_path"])]
    if prefix := group.get("path_prefix"):
        parts.append(str(prefix))
    parts.extend([skill_id, "SKILL.md"])
    return "/".join(parts)


parser = argparse.ArgumentParser()
parser.add_argument("manifest", type=Path)
parser.add_argument("--mode", choices=("global", "profile"), required=True)
parser.add_argument("--profile")
parser.add_argument("--output", type=Path)
parser.add_argument("--list-profiles", action="store_true")
parser.add_argument("--list-hidden-profiles", action="store_true")
args = parser.parse_args()

manifest = tomllib.loads(args.manifest.read_text())
sources = {source["id"]: source for source in manifest["sources"]}
entries: list[tuple[str, bool]] = []

if args.list_profiles or args.list_hidden_profiles:
    if args.mode != "profile" or args.profile or args.output or (args.list_profiles and args.list_hidden_profiles):
        parser.error("profile listing requires --mode profile, one listing flag, and no --profile/--output")
    for group in manifest["groups"]:
        public = group.get("public_profile") is True
        if (args.list_profiles and public) or (args.list_hidden_profiles and group.get("profile") and not public):
            profile = group["profile"]
            print(profile)
    raise SystemExit(0)
if not args.output:
    parser.error("--output is required unless --list-profiles is used")

if args.mode == "global":
    if args.profile:
        parser.error("--profile is only valid with --mode profile")
    for group in manifest["groups"]:
        if group["classification"] != "host-injected" and not group["enabled_by_default"]:
            entries.extend((path_for(sources[group["source"]], group, skill_id), False) for skill_id in group["skill_ids"])
else:
    if not args.profile:
        parser.error("--profile is required with --mode profile")
    for group in manifest["groups"]:
        if group.get("profile") == args.profile and group.get("public_profile") is True:
            entries.extend((path_for(sources[group["source"]], group, skill_id), True) for skill_id in group["skill_ids"])
    if not entries:
        parser.error(f"unknown specialist profile: {args.profile}")

lines = ["# Generated from the governed CODEX-1 catalog manifest. Do not edit by hand.", "[skills]", "config = ["]
lines.extend(f'  {{ path = "{path}", enabled = {str(enabled).lower()} }},' for path, enabled in entries)
lines.append("]")
args.output.write_text("\n".join(lines) + "\n")
