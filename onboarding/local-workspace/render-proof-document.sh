#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "usage: $0 /path/to/target-repo source.md output.md" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
source_path="$2"
output_path="$3"
case "${source_path}" in /*|*..*) echo "source path must be relative and cannot contain '..': ${source_path}" >&2; exit 1 ;; esac
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac
[ -f "${root}/${source_path}" ] || { echo "missing source: ${root}/${source_path}" >&2; exit 1; }
source_real="$(readlink -f "${root}/${source_path}")"
case "${source_real}" in "${root}"|"${root}"/*) ;; *) echo "resolved source escapes target repo: ${source_path}" >&2; exit 1 ;; esac
case "${output_path}" in .accelerate/*|.tmp/*) ;; *) echo "output must stay under .accelerate/ or .tmp/: ${output_path}" >&2; exit 1 ;; esac
mkdir -p "$(dirname "${root}/${output_path}")"
out_dir="$(cd "$(dirname "${root}/${output_path}")" && pwd)"
case "${out_dir}" in "${root}/.accelerate"|"${root}/.accelerate"/*|"${root}/.tmp"|"${root}/.tmp"/*) ;; *) echo "resolved output escapes allowed dirs: ${output_path}" >&2; exit 1 ;; esac
if [ -L "${root}/${output_path}" ]; then
  echo "output path must not be a symlink: ${output_path}" >&2
  exit 1
fi
cp "${root}/${source_path}" "${root}/${output_path}"
printf '%s\n' "${output_path}"
