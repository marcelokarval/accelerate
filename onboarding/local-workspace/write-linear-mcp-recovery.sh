#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: $0 /path/to/target-repo operation reason [output-path]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
operation="$2"
reason="$3"
output_path="${4:-.accelerate/workflow/linear-mcp-recovery.md}"
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac
mkdir -p "$(dirname "${root}/${output_path}")"
cat >"${root}/${output_path}" <<EOF
# Linear MCP Recovery Packet

- operation: ${operation}
- reason: ${reason}
- recorded_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)
- retry_required: true
EOF
printf '%s\n' "${output_path}"
