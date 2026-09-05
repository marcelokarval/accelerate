#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
marker_name=".accelerate-test-root"

usage() { echo "Usage: $0 --test-root ROOT --codex-root ROOT --hermes-root ROOT" >&2; exit 2; }
[[ "$#" -eq 6 ]] || usage
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --test-root) test_root="$2" ;;
    --codex-root) codex_root="$2" ;;
    --hermes-root) hermes_root="$2" ;;
    *) usage ;;
  esac
  shift 2
done

safe_directory() { [[ -d "$1" && ! -L "$1" ]] || { echo "unsafe directory: $1" >&2; exit 1; }; }
safe_directory "$test_root"
test_root="$(cd "$test_root" && pwd -P)"
[[ -f "$test_root/$marker_name" && ! -L "$test_root/$marker_name" ]] || { echo "missing fixture marker: $test_root/$marker_name" >&2; exit 1; }

assert_contained_target() {
  local declared_target="$1" target current relative part
  case "$declared_target" in "$test_root"/*) ;; *) echo "fixture target escapes marked root: $declared_target" >&2; exit 1 ;; esac
  relative="${declared_target#"$test_root"/}"
  current="$test_root"
  safe_directory "$current"
  IFS='/' read -r -a parts <<<"$relative"
  for part in "${parts[@]}"; do
    [[ -n "$part" && "$part" != "." && "$part" != ".." ]] || { echo "unsafe fixture target component: $declared_target" >&2; exit 1; }
    current="$current/$part"
    safe_directory "$current"
  done
  target="$(cd "$declared_target" && pwd -P)"
  case "$target" in "$test_root"/*) ;; *) echo "fixture target escapes marked root: $target" >&2; exit 1 ;; esac
  printf '%s\n' "$target"
}

codex_root="$(assert_contained_target "$codex_root")"
hermes_root="$(assert_contained_target "$hermes_root")"
CODEX_SKILLS_DIR="$codex_root" HERMES_SKILLS_DIR="$hermes_root" "$ROOT/scripts/sync-skills-to-global.sh" --capabilities-only >/dev/null

stage_accelerate() {
  local target_root="$1" target="$1/accelerate"
  mkdir -p "$target"
  cp -a "$ROOT/global-runtime/accelerate/." "$target/"
  mkdir -p "$target/references" "$target/assets" "$target/scripts"
  cp -a "$ROOT/references/." "$target/references/"
  cp "$ROOT/adapters/runtime/codex-collaboration/role-policy.json" "$target/references/codex-collaboration-role-policy.json"
  cp "$ROOT/core/runtime-packets/delegation-dispatch-receipt.schema.json" "$target/assets/delegation-dispatch-receipt.schema.json"
  cp "$ROOT/scripts/validate-delegation-dispatch-receipt.py" "$target/scripts/validate-delegation-dispatch-receipt.py"
  if [[ -f "$ROOT/agents/openai.yaml" ]]; then mkdir -p "$target/agents"; cp "$ROOT/agents/openai.yaml" "$target/agents/openai.yaml"; fi
}

stage_accelerate "$codex_root"
stage_accelerate "$hermes_root"
