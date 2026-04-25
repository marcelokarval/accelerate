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

  [[ -f "$skill_dir/metadata.yaml" ]] || {
    echo "Missing metadata.yaml in $skill_dir" >&2
    status=1
  }

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

exit "$status"
