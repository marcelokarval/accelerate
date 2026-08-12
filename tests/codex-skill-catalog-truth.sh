#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="${ROOT}/adapters/runtime/codex/skill-catalog-manifest.toml"

test -f "${MANIFEST}"
python3 "${ROOT}/scripts/validate-codex-skill-catalog.py" "${MANIFEST}"

TMP_DIR="${ROOT}/.tmp/codex-skill-catalog-truth"
mkdir -p "${TMP_DIR}"
trap 'rm -rf "${TMP_DIR}"' EXIT

python3 "${ROOT}/scripts/render-codex-skill-profile.py" "${MANIFEST}" \
  --mode global --output "${TMP_DIR}/global-skills.config.toml"
test "$(rg -c 'enabled = false' "${TMP_DIR}/global-skills.config.toml")" -eq 88

python3 "${ROOT}/scripts/render-codex-skill-profile.py" "${MANIFEST}" \
  --mode profile --profile django-backend --output "${TMP_DIR}/django-backend.config.toml"
rg -F 'python-pro/SKILL.md", enabled = true' "${TMP_DIR}/django-backend.config.toml" >/dev/null
! rg -F 'nextjs-app-router-patterns/SKILL.md' "${TMP_DIR}/django-backend.config.toml" >/dev/null

python3 "${ROOT}/scripts/render-codex-skill-profile.py" "${MANIFEST}" \
  --mode profile --profile on-demand --output "${TMP_DIR}/on-demand.config.toml"
rg -F 'linear-pm/SKILL.md", enabled = true' "${TMP_DIR}/on-demand.config.toml" >/dev/null
