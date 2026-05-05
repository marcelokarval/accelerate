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
case "${out_dir}" in
  ""|*"/../"*|../*|*/..|..|*"/.."|*"../"*) echo "invalid output dir traversal: ${out_dir}" >&2; exit 1 ;;
esac
manifest="${ROOT}/adapters/runtime/${host}/capabilities.yaml"

[ -f "${manifest}" ] || { echo "unknown runtime host: ${host}" >&2; exit 1; }
case "${out_dir}" in /*) ;; *) out_dir="${ROOT}/${out_dir}" ;; esac
mkdir -p "${out_dir}"

status="$(sed -n 's/^status: //p' "${manifest}" | head -n 1)"
[ -n "${status}" ] || status="unknown"
export_md="${out_dir}/accelerate-${host}-export.md"
export_manifest="${out_dir}/accelerate-${host}-export-manifest.yaml"
shell_quote() {
  printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\''/g")"
}
validation_command="test -f $(shell_quote "${export_md}") && test -f $(shell_quote "${export_manifest}")"

cat > "${export_md}" <<MD
# Accelerate ${host} Runtime Export

- source repository: accelerate
- host: ${host}
- status: ${status}
- source manifest: adapters/runtime/${host}/capabilities.yaml
- authority: generated-export; repository remains source of truth
- privacy classification: public-repo-derived
- validation command: ${validation_command}

## Root Instruction

Use Accelerate as the root workflow classifier. This file is generated outward
only. Do not treat this export as canonical doctrine if it diverges from the
repository source, and do not treat it as proof of promoted physical agents.
MD

cat > "${export_manifest}" <<YAML
schema_version: 1
export_identity: accelerate-runtime-host-export
source_repository: accelerate
source_artifacts:
  - adapters/runtime/${host}/capabilities.yaml
target_host: ${host}
target_path: ${out_dir}
generated_files:
  - ${export_md}
  - ${export_manifest}
authority: generated-export; repository remains source of truth
privacy_classification: public-repo-derived
suppressed_capabilities:
  - none
rewritten_tools:
  - none
validation_command: ${validation_command}
YAML

printf '%s\n' "${export_md}"
printf '%s\n' "${export_manifest}"
