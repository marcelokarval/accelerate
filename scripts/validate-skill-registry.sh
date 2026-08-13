#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="$root_dir/skills/_registry/manifest.md"

if [[ ! -f "$manifest" ]]; then
  echo "Missing skill registry manifest: $manifest" >&2
  exit 1
fi

status=0
root_runtime_bundle="$root_dir/global-runtime/accelerate"

while IFS= read -r skill_dir; do
  [[ -f "$skill_dir/SKILL.md" ]] || {
    echo "Missing SKILL.md in $skill_dir" >&2
    status=1
  }

  # Metadata is recommended for runtime export, but repo-local skill authority is
  # the SKILL.md plus registry row. Native skills may temporarily lack metadata
  # while the registry remains authoritative.
  if [[ -f "$skill_dir/metadata.yaml" ]]; then
    if grep -Eq '^source: ~/' "$skill_dir/metadata.yaml"; then
      echo "Metadata source must be repo-local in $skill_dir/metadata.yaml" >&2
      status=1
    fi

    if grep -Eq '^runtime_mirror:' "$skill_dir/metadata.yaml"; then
      echo "Metadata must use runtime_export, not runtime_mirror, in $skill_dir/metadata.yaml" >&2
      status=1
    fi
  fi

  skill_name="$(basename "$skill_dir")"
  if ! grep -Fq "| \`$skill_name\` |" "$manifest"; then
    echo "Skill not registered in manifest: $skill_name" >&2
    status=1
  fi
done < <(find "$root_dir/skills" -mindepth 2 -maxdepth 2 -type d \
  ! -path "$root_dir/skills/_registry/*" \
  ! -path "$root_dir/skills/overlays/*" \
  | sort)

if [[ ! -f "$root_runtime_bundle/SKILL.md" ]]; then
  echo "Missing global runtime accelerate SKILL.md in $root_runtime_bundle" >&2
  status=1
fi

if [[ ! -f "$root_runtime_bundle/README.md" ]]; then
  echo "Missing global runtime accelerate README.md in $root_runtime_bundle" >&2
  status=1
fi

if grep -Fq '~/.codex/skills/' "$manifest"; then
  echo "Manifest must not list user-home runtime paths as governed skill authority" >&2
  status=1
fi

if ! python3 - "$root_dir" "$manifest" <<'PY'
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
manifest = Path(sys.argv[2])
text = manifest.read_text(encoding="utf-8")
local_section = text.split("## Local Skills", 1)[1].split("## Migration Backlog", 1)[0]
rows = re.findall(r"^\| `([^`]+)` \| `([^`]+)` \| `([^`]+)` \|", local_section, re.MULTILINE)
row_names = [row[0] for row in rows]
if len(row_names) != len(set(row_names)):
    raise SystemExit("duplicate skill rows in Local Skills registry")

directories = [path.parent for path in root.glob("skills/*/*/SKILL.md")]
actual: dict[str, Path] = {}
for directory in directories:
    name = directory.name
    if name in actual:
        raise SystemExit(f"duplicate governed skill folder name: {name}")
    actual[name] = directory

registered = {name: (category, path) for name, category, path in rows}
missing = sorted(set(actual) - set(registered))
stale = sorted(set(registered) - set(actual))
if missing or stale:
    raise SystemExit(f"registry mismatch: missing={missing} stale={stale}")

quality = {
    "specification-lifecycle", "test-driven-development", "test-engineering",
    "source-verification", "solution-minimalism", "web-performance-review",
}
for name, directory in sorted(actual.items()):
    skill_text = (directory / "SKILL.md").read_text(encoding="utf-8")
    match = re.search(r"^name:\s*(.+?)\s*$", skill_text, re.MULTILINE)
    if not match or match.group(1) != name:
        raise SystemExit(f"folder/frontmatter name mismatch: {directory}")
    category, registered_path = registered[name]
    expected = (manifest.parent / registered_path).resolve()
    if expected != directory.resolve() or category != directory.parent.name:
        raise SystemExit(f"registry category/path mismatch: {name}")
    metadata = directory / "metadata.yaml"
    if metadata.is_file():
        metadata_text = metadata.read_text(encoding="utf-8")
        metadata_name = re.search(r"^name:\s*(.+?)\s*$", metadata_text, re.MULTILINE)
        if not metadata_name or metadata_name.group(1) != name:
            raise SystemExit(f"folder/metadata name mismatch: {directory}")
    if name in quality:
        required = [metadata, directory / "agents/openai.yaml", directory / "evals/evals.json"]
        absent = [str(path) for path in required if not path.is_file()]
        if absent:
            raise SystemExit(f"incomplete governed quality skill {name}: {absent}")
        if len(skill_text.splitlines()) > 220 or len(skill_text.encode()) > 10240:
            raise SystemExit(f"quality skill router exceeds local size target: {name}")
        if (directory / "README.md").exists():
            raise SystemExit(f"forbidden skill README: {directory}")
    for path in directory.rglob("*"):
        if path.name == "__pycache__" or path.suffix == ".pyc":
            raise SystemExit(f"generated cache inside governed skill: {path}")
PY
then
  status=1
fi

exit "$status"
