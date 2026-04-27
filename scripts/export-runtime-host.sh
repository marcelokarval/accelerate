#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <host> <output-dir>" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
host="$1"
out_dir="$2"
case "${host}" in *[!a-z0-9-]*|""|-*) echo "invalid host: ${host}" >&2; exit 1 ;; esac
manifest="${ROOT}/adapters/runtime/${host}/capabilities.yaml"

[ -f "${manifest}" ] || { echo "unknown runtime host: ${host}" >&2; exit 1; }
case "${out_dir}" in /*) ;; *) out_dir="${ROOT}/${out_dir}" ;; esac
mkdir -p "${out_dir}"

status="$(sed -n 's/^status: //p' "${manifest}" | head -n 1)"
cat > "${out_dir}/accelerate-${host}-export.md" <<MD
# Accelerate ${host} Runtime Export

- source repository: accelerate
- host: ${host}
- status: ${status}
- source manifest: adapters/runtime/${host}/capabilities.yaml
- authority: generated outward only; repository files remain source of truth

## Root Instruction

Use Accelerate as the root workflow classifier. Do not treat this export as
canonical doctrine if it diverges from the repository source.
MD

printf '%s\n' "${out_dir}/accelerate-${host}-export.md"
