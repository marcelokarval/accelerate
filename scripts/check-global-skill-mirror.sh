#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="${ROOT_DIR}/skills"
ROOT_RUNTIME_DIR="${ROOT_DIR}/global-runtime/accelerate"
GLOBAL_SKILLS_DIR="${CODEX_SKILLS_DIR:-${GLOBAL_SKILLS_DIR:-${HOME}/.codex/skills}}"

if [[ ! -d "${SKILLS_DIR}" ]]; then
  echo "Missing local skills directory: ${SKILLS_DIR}" >&2
  exit 1
fi

missing=0
different=0
runtime_expected=0
runtime_verified=0

for skill_dir in "${SKILLS_DIR}"/*/*; do
  [[ -d "${skill_dir}" ]] || continue
  skill_name="$(basename "${skill_dir}")"
  target_dir="${GLOBAL_SKILLS_DIR}/${skill_name}"

  for file_name in SKILL.md metadata.yaml; do
    source_file="${skill_dir}/${file_name}"
    target_file="${target_dir}/${file_name}"

    if [[ ! -f "${source_file}" ]]; then
      continue
    fi

    if [[ ! -f "${target_file}" ]]; then
      echo "missing: ${target_file}" >&2
      missing=1
      continue
    fi

    if ! cmp -s "${source_file}" "${target_file}"; then
      echo "different: ${source_file} != ${target_file}" >&2
      different=1
    fi
  done
done

if [[ -d "${ROOT_RUNTIME_DIR}" ]]; then
  target_dir="${GLOBAL_SKILLS_DIR}/accelerate"

  for file_name in SKILL.md README.md metadata.yaml; do
    source_file="${ROOT_RUNTIME_DIR}/${file_name}"
    target_file="${target_dir}/${file_name}"

    [[ -f "${source_file}" ]] || continue
    runtime_expected=$((runtime_expected + 1))

    if [[ ! -f "${target_file}" ]]; then
      echo "missing: ${target_file}" >&2
      missing=1
      continue
    fi

    if ! cmp -s "${source_file}" "${target_file}"; then
      echo "different: ${source_file} != ${target_file}" >&2
      different=1
    else
      runtime_verified=$((runtime_verified + 1))
    fi
  done

  for support_dir in assets evals scripts templates; do
    source_dir="${ROOT_RUNTIME_DIR}/${support_dir}"
    [[ -d "${source_dir}" ]] || continue

    while IFS= read -r source_file; do
      target_file="${target_dir}/${support_dir}/${source_file#${source_dir}/}"
      runtime_expected=$((runtime_expected + 1))

      if [[ ! -f "${target_file}" ]]; then
        echo "missing: ${target_file}" >&2
        missing=1
        continue
      fi

      if ! cmp -s "${source_file}" "${target_file}"; then
        echo "different: ${source_file} != ${target_file}" >&2
        different=1
      else
        runtime_verified=$((runtime_verified + 1))
      fi
    done < <(find "${source_dir}" -type f | sort)
  done

  while IFS= read -r source_file; do
    target_file="${GLOBAL_SKILLS_DIR}/accelerate/references/${source_file#${ROOT_DIR}/references/}"
    runtime_expected=$((runtime_expected + 1))

    if [[ ! -f "${target_file}" ]]; then
      echo "missing: ${target_file}" >&2
      missing=1
      continue
    fi

    if ! cmp -s "${source_file}" "${target_file}"; then
      echo "different: ${source_file} != ${target_file}" >&2
      different=1
    else
      runtime_verified=$((runtime_verified + 1))
    fi
  done < <(find "${ROOT_DIR}/references" -type f | sort)

  codex_collaboration_policy="${ROOT_DIR}/adapters/runtime/codex-collaboration/role-policy.json"
  if [[ -f "${codex_collaboration_policy}" ]]; then
    target_file="${GLOBAL_SKILLS_DIR}/accelerate/references/codex-collaboration-role-policy.json"
    runtime_expected=$((runtime_expected + 1))
    if [[ ! -f "${target_file}" ]]; then
      echo "missing: ${target_file}" >&2
      missing=1
    elif ! cmp -s "${codex_collaboration_policy}" "${target_file}"; then
      echo "different: ${codex_collaboration_policy} != ${target_file}" >&2
      different=1
    else
      runtime_verified=$((runtime_verified + 1))
    fi
  fi

  if [[ -f "${ROOT_DIR}/agents/openai.yaml" ]]; then
    source_file="${ROOT_DIR}/agents/openai.yaml"
    target_file="${GLOBAL_SKILLS_DIR}/accelerate/agents/openai.yaml"
    runtime_expected=$((runtime_expected + 1))

    if [[ ! -f "${target_file}" ]]; then
      echo "missing: ${target_file}" >&2
      missing=1
    elif ! cmp -s "${source_file}" "${target_file}"; then
      echo "different: ${source_file} != ${target_file}" >&2
      different=1
    else
      runtime_verified=$((runtime_verified + 1))
    fi
  fi
fi

if [[ "${missing}" -ne 0 || "${different}" -ne 0 ]]; then
  echo "Global skill mirror is out of sync." >&2
  exit 1
fi

echo "Accelerate runtime mirror: expected=${runtime_expected} verified=${runtime_verified}"
echo "Global skill mirror is in sync."
