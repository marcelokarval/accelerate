#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_root="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
root_runtime_dir="$root_dir/global-runtime/accelerate"

"$root_dir/scripts/validate-skill-registry.sh"

while IFS= read -r skill_file; do
  skill_dir="$(dirname "$skill_file")"
  skill_name="$(basename "$skill_dir")"
  target_dir="$target_root/$skill_name"

  mkdir -p "$target_dir"
  cp "$skill_file" "$target_dir/SKILL.md"

  if [[ -f "$skill_dir/metadata.yaml" ]]; then
    cp "$skill_dir/metadata.yaml" "$target_dir/metadata.yaml"
  fi

  for support_dir in references examples tests evals assets scripts templates; do
    if [[ -d "$skill_dir/$support_dir" ]]; then
      cp -r "$skill_dir/$support_dir" "$target_dir/"
    fi
  done
done < <(find "$root_dir/skills" -mindepth 3 -maxdepth 3 -name SKILL.md | sort)

if [[ -d "$root_runtime_dir" ]]; then
  target_dir="$target_root/accelerate"
  mkdir -p "$target_dir" "$target_dir/references" "$target_dir/agents"

  cp "$root_runtime_dir/SKILL.md" "$target_dir/SKILL.md"
  cp "$root_runtime_dir/README.md" "$target_dir/README.md"

  if [[ -f "$root_runtime_dir/metadata.yaml" ]]; then
    cp "$root_runtime_dir/metadata.yaml" "$target_dir/metadata.yaml"
  fi

  for support_dir in assets evals scripts templates; do
    if [[ -d "$root_runtime_dir/$support_dir" ]]; then
      mkdir -p "$target_dir/$support_dir"
      cp -r "$root_runtime_dir/$support_dir/." "$target_dir/$support_dir/"
    fi
  done

  cp -r "$root_dir/references/." "$target_dir/references/"

  codex_collaboration_policy="$root_dir/adapters/runtime/codex-collaboration/role-policy.json"
  if [[ -f "$codex_collaboration_policy" ]]; then
    cp "$codex_collaboration_policy" "$target_dir/references/codex-collaboration-role-policy.json"
  fi

  if [[ -f "$root_dir/agents/openai.yaml" ]]; then
    cp "$root_dir/agents/openai.yaml" "$target_dir/agents/openai.yaml"
  fi
fi

echo "Synced Accelerate skills to $target_root"
