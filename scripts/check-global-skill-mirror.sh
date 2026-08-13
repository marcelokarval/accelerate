#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_home_input="${CODEX_HOME:-$HOME/.codex}"
target_input="${CODEX_SKILLS_DIR:-${GLOBAL_SKILLS_DIR:-$codex_home_input/skills}}"
if ! python3 - "$codex_home_input" "$target_input" <<'PY'
import sys
for value in sys.argv[1:]:
    if any(ord(character) < 32 or ord(character) == 127 for character in value):
        raise SystemExit("Refusing control character in global mirror path input")
PY
then
  exit 1
fi
codex_home_lexical="$(realpath -ms "$codex_home_input")"
target_lexical="$(realpath -ms "$target_input")"
if [[ "$target_lexical" != "$codex_home_lexical/skills" || -L "$codex_home_lexical/skills" ]]; then
  echo "Global skill target must be a non-symlink lexical skills child of CODEX_HOME" >&2
  exit 1
fi
codex_home="$(realpath -m "$codex_home_input")"
target_root="$(realpath -m "$target_input")"
root_runtime_dir="$root_dir/global-runtime/accelerate"
catalog="$root_dir/adapters/runtime/codex/skill-catalog-manifest.toml"
topology="$root_dir/adapters/runtime/codex/logical-agent-topology.toml"

if [[ "$target_root" != "$codex_home/skills" || "$target_root" != "$(realpath -m "$codex_home/skills")" ]]; then
  echo "Global skill target must be the active Codex home's skills directory: $codex_home/skills" >&2
  exit 1
fi
if [[ ! -d "$target_root" ]]; then
  echo "Missing global skill target: $target_root" >&2
  exit 1
fi

status=0
while IFS= read -r skill_file; do
  skill_dir="$(dirname "$skill_file")"
  skill_name="$(basename "$skill_dir")"
  target_dir="$target_root/$skill_name"
  if [[ ! -d "$target_dir" ]]; then
    echo "missing governed package: $target_dir" >&2
    status=1
  elif ! diff -qr "$skill_dir" "$target_dir"; then
    echo "different or stale governed package: $skill_name" >&2
    status=1
  fi
done < <(find "$root_dir/skills" -mindepth 3 -maxdepth 3 -name SKILL.md | sort)

expected_root="$(mktemp -d)"
trap 'rm -rf -- "$expected_root"' EXIT
expected_accelerate="$expected_root/accelerate"
mkdir -p "$expected_accelerate/references" "$expected_accelerate/agents"
for file_name in SKILL.md README.md metadata.yaml; do
  [[ -f "$root_runtime_dir/$file_name" ]] && cp -a "$root_runtime_dir/$file_name" "$expected_accelerate/$file_name"
done
for support_dir in assets evals scripts templates; do
  if [[ -d "$root_runtime_dir/$support_dir" ]]; then
    mkdir -p "$expected_accelerate/$support_dir"
    cp -a "$root_runtime_dir/$support_dir/." "$expected_accelerate/$support_dir/"
  fi
done
cp -a "$root_dir/references/." "$expected_accelerate/references/"
cp -a "$root_dir/adapters/runtime/codex-collaboration/role-policy.json" \
  "$expected_accelerate/references/codex-collaboration-role-policy.json"
[[ -f "$root_dir/agents/openai.yaml" ]] && cp -a "$root_dir/agents/openai.yaml" "$expected_accelerate/agents/openai.yaml"

if [[ ! -d "$target_root/accelerate" ]]; then
  echo "missing governed package: $target_root/accelerate" >&2
  status=1
elif ! diff -qr "$expected_accelerate" "$target_root/accelerate"; then
  echo "different or stale governed package: accelerate" >&2
  status=1
fi

if ! python3 "$root_dir/scripts/check-codex-skill-catalog-install.py" "$catalog" \
  --codex-home "$codex_home" --logical-topology "$topology"; then
  echo "Codex skill catalog config or profile is out of sync." >&2
  status=1
fi
while IFS= read -r agent; do
  if ! python3 "$root_dir/scripts/check-codex-logical-agent-install.py" \
    "$topology" "$catalog" --codex-home "$codex_home" --agent "$agent"; then
    echo "Codex logical agent is out of sync: $agent" >&2
    status=1
  fi
done < <(python3 - "$topology" <<'PY'
import sys
import tomllib
from pathlib import Path
for agent in tomllib.loads(Path(sys.argv[1]).read_text())["agents"]:
    print(agent["name"])
PY
)

if [[ "$status" -ne 0 ]]; then
  echo "Global Codex runtime mirror is out of sync." >&2
  exit 1
fi
echo "Global Codex runtime mirror is in sync. This is static installed-state proof only."
