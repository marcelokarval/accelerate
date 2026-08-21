#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_target_root="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
hermes_target_root="${HERMES_SKILLS_DIR:-$HOME/.hermes/skills}"
root_runtime_dir="$root_dir/global-runtime/accelerate"

if [[ "$#" -eq 0 ]]; then
  echo "Accelerate export is fail-closed here; run scripts/sync-accelerate-governed-drift.py for the three governed drift paths." >&2
  exit 1
fi
if [[ "$#" -ne 1 || "$1" != "--capabilities-only" ]]; then
  echo "Usage: sync-skills-to-global.sh --capabilities-only" >&2
  exit 2
fi

"$root_dir/scripts/validate-skill-registry.sh"

for target_root in "$codex_target_root" "$hermes_target_root"; do
  while IFS= read -r skill_file; do
    skill_dir="$(dirname "$skill_file")"
    skill_name="$(basename "$skill_dir")"
    target_dir="$target_root/$skill_name"

    mkdir -p "$target_dir"
    cp "$skill_file" "$target_dir/SKILL.md"

    if [[ -f "$skill_dir/metadata.yaml" ]]; then
      cp "$skill_dir/metadata.yaml" "$target_dir/metadata.yaml"
    fi

    for support_dir in agents references examples tests evals assets scripts templates; do
      if [[ -d "$skill_dir/$support_dir" ]]; then
        mkdir -p "$target_dir/$support_dir"
        cp -r "$skill_dir/$support_dir/." "$target_dir/$support_dir/"
      fi
    done
  done < <(find "$root_dir/docs/codex-skill-seeds/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | sort)
done

# Standalone Accelerate skills remain Codex-only; capability seed packages
# above are the governed surface intentionally exported to both runtimes.
while IFS= read -r skill_file; do
  skill_dir="$(dirname "$skill_file")"
  skill_name="$(basename "$skill_dir")"
  target_dir="$codex_target_root/$skill_name"

  mkdir -p "$target_dir"
  cp "$skill_file" "$target_dir/SKILL.md"

  if [[ -f "$skill_dir/metadata.yaml" ]]; then
    cp "$skill_dir/metadata.yaml" "$target_dir/metadata.yaml"
  fi

  for support_dir in agents references examples tests evals assets scripts templates; do
    if [[ -d "$skill_dir/$support_dir" ]]; then
      mkdir -p "$target_dir/$support_dir"
      cp -r "$skill_dir/$support_dir/." "$target_dir/$support_dir/"
    fi
  done
done < <(find "$root_dir/skills" -mindepth 3 -maxdepth 3 -name SKILL.md | sort)

echo "Synced capability and standalone skills only to $codex_target_root and $hermes_target_root; Accelerate runtime was not touched."
