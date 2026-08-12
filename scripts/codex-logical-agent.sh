#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOPOLOGY="${ROOT}/adapters/runtime/codex/logical-agent-topology.toml"
CATALOG="${ROOT}/adapters/runtime/codex/skill-catalog-manifest.toml"
CODEX_HOME_TARGET="${CODEX_HOME:-${HOME}/.codex}"
dry_run=false

if [ "${1:-}" = "--codex-home" ]; then
  CODEX_HOME_TARGET="${2:?missing value for --codex-home}"
  shift 2
fi
if [ "${1:-}" = "--dry-run" ]; then
  dry_run=true
  shift
fi
agent="${1:?usage: codex-logical-agent.sh [--codex-home PATH] [--dry-run] AGENT [codex args...]}"
shift

python3 "${ROOT}/scripts/check-codex-logical-agent-install.py" "${TOPOLOGY}" "${CATALOG}" \
  --codex-home "${CODEX_HOME_TARGET}" --agent "${agent}" >/dev/null

if [ "${dry_run}" = true ]; then
  printf 'CODEX_HOME=%q codex -p %q' "${CODEX_HOME_TARGET}" "${agent}"
  printf ' %q' "$@"
  printf '\n'
  exit 0
fi
exec env CODEX_HOME="${CODEX_HOME_TARGET}" codex -p "${agent}" "$@"
