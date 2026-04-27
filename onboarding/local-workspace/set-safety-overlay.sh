#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "usage: $0 /path/to/target-repo mode owner reason [allowed_path]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
mode="$2"
owner="$3"
reason="$4"
allowed="${5:-}"
case "${mode}" in none|careful|freeze|guard) ;; *) echo "invalid safety mode: ${mode}" >&2; exit 1 ;; esac
if { [ "${mode}" = "freeze" ] || [ "${mode}" = "guard" ]; } && [ -z "${allowed}" ]; then
  echo "freeze/guard require allowed_path" >&2
  exit 1
fi
cat > "${root}/.accelerate/status/safety-overlay.yaml" <<YAML
schema_version: 1
mode: ${mode}
active: true
owner: ${owner}
reason: ${reason}
allowed_paths: [${allowed}]
started_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)
stop_condition: explicit-unfreeze
YAML
