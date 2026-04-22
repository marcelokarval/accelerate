#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="$root_dir/skills/_registry/manifest.md"

if [[ ! -f "$manifest" ]]; then
  echo "Missing skill registry manifest: $manifest" >&2
  exit 1
fi

status=0

while IFS= read -r skill_dir; do
  [[ -f "$skill_dir/SKILL.md" ]] || {
    echo "Missing SKILL.md in $skill_dir" >&2
    status=1
  }

  [[ -f "$skill_dir/metadata.yaml" ]] || {
    echo "Missing metadata.yaml in $skill_dir" >&2
    status=1
  }

  skill_name="$(basename "$skill_dir")"
  if ! grep -Fq "| \`$skill_name\` |" "$manifest"; then
    echo "Skill not registered in manifest: $skill_name" >&2
    status=1
  fi
done < <(find "$root_dir/skills" -mindepth 2 -maxdepth 2 -type d \
  ! -path "$root_dir/skills/_registry/*" \
  ! -path "$root_dir/skills/overlays/*" \
  | sort)

exit "$status"
