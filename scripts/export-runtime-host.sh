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
catalog_manifest="${ROOT}/adapters/runtime/${host}/skill-catalog-manifest.toml"

[ -f "${manifest}" ] || { echo "unknown runtime host: ${host}" >&2; exit 1; }
case "${out_dir}" in /*) ;; *) out_dir="${ROOT}/${out_dir}" ;; esac
mkdir -p "${out_dir}"

status="$(sed -n 's/^status: //p' "${manifest}" | head -n 1)"
[ -n "${status}" ] || status="unknown"
export_md="${out_dir}/accelerate-${host}-export.md"
export_manifest="${out_dir}/accelerate-${host}-export-manifest.yaml"
catalog_renderer="${ROOT}/scripts/render-codex-skill-profile.py"
generated_catalog_files=()
catalog_digest="not-applicable"
source_artifacts_yaml="  - adapters/runtime/${host}/capabilities.yaml"
shell_quote() {
  printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\''/g")"
}
validation_command="test -f $(shell_quote "${export_md}") && test -f $(shell_quote "${export_manifest}")"

if [ "${host}" = "codex" ]; then
  [ -f "${catalog_manifest}" ] || { echo "missing Codex catalog manifest" >&2; exit 1; }
  [ -f "${catalog_renderer}" ] || { echo "missing Codex catalog renderer" >&2; exit 1; }
  catalog_digest="$(sha256sum "${catalog_manifest}" | awk '{print $1}')"
  source_artifacts_yaml+=$'\n  - adapters/runtime/codex/skill-catalog-manifest.toml\n  - scripts/render-codex-skill-profile.py'
  root_config="${out_dir}/codex-root-skills.config.toml"
  python3 "${catalog_renderer}" "${catalog_manifest}" --mode global --output "${root_config}"
  generated_catalog_files+=("${root_config}")
  validation_command+=" && test -f $(shell_quote "${root_config}")"
  while IFS= read -r profile; do
    profile_config="${out_dir}/codex-${profile}.config.toml"
    python3 "${catalog_renderer}" "${catalog_manifest}" --mode profile --profile "${profile}" --output "${profile_config}"
    generated_catalog_files+=("${profile_config}")
    validation_command+=" && test -f $(shell_quote "${profile_config}")"
  done < <(python3 "${catalog_renderer}" "${catalog_manifest}" --mode profile --list-profiles)
fi

generated_files_yaml="  - ${export_md}"$'\n'"  - ${export_manifest}"
for generated_catalog_file in "${generated_catalog_files[@]}"; do
  generated_files_yaml+=$'\n'"  - ${generated_catalog_file}"
done

cat > "${export_md}" <<MD
# Accelerate ${host} Runtime Export

- source repository: accelerate
- host: ${host}
- status: ${status}
- source manifest: adapters/runtime/${host}/capabilities.yaml
- authority: generated-export; repository remains source of truth
- privacy classification: public-repo-derived
- validation command: ${validation_command}

## Catalog Export

For Codex, generated profile files are additive profile configuration layers.
They select skills; they do not establish technical MCP, tool, credential, or
physical-agent isolation. Their input manifest digest is
${catalog_digest}.

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
${source_artifacts_yaml}
target_host: ${host}
target_path: ${out_dir}
generated_files:
${generated_files_yaml}
authority: generated-export; repository remains source of truth
privacy_classification: public-repo-derived
suppressed_capabilities:
  - none
rewritten_tools:
  - none
validation_command: ${validation_command}
catalog_manifest_sha256: ${catalog_digest}
YAML

printf '%s\n' "${export_md}"
printf '%s\n' "${export_manifest}"
printf '%s\n' "${generated_catalog_files[@]}"
