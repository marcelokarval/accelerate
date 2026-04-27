#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
latest="$(ls -1t "${root}/.accelerate/status/checkpoints"/*.md 2>/dev/null | head -n 1 || true)"
[ -n "${latest}" ] || { echo "no context checkpoints found" >&2; exit 1; }
printf '%s\n' "${latest#${root}/}"
sed -n '1,80p' "${latest}"
