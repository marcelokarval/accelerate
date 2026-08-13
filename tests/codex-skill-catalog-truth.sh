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
test "$(rg -c 'enabled = false' "${TMP_DIR}/global-skills.config.toml")" -eq 118
! rg -F 'enabled = true' "${TMP_DIR}/global-skills.config.toml" >/dev/null
python3 - "${MANIFEST}" <<'PY'
import sys
import tomllib
from pathlib import Path

manifest = tomllib.loads(Path(sys.argv[1]).read_text())
root = next(group for group in manifest["groups"] if group["id"] == "root-core")
if root["classification"] != "core" or root["enabled_by_default"] is not True:
    raise SystemExit("root-core must remain enabled by default in manifest semantics")
expected_root = {
    "accelerate", "plane", "prompt-hardening", "skill-catalog-router",
    "subagent-governance", "specification-lifecycle",
    "test-driven-development", "verification-before-completion",
}
if set(root["skill_ids"]) != expected_root:
    raise SystemExit(
        f"root-core must be the exact compact orchestrator set: "
        f"actual={sorted(root['skill_ids'])} expected={sorted(expected_root)}"
    )
superpowers = next(group for group in manifest["groups"] if group["id"] == "host-superpowers")
if (
    superpowers["classification"] != "on-demand"
    or superpowers["enabled_by_default"] is not False
    or superpowers.get("profile") != "superpowers-on-demand"
    or superpowers.get("public_profile") is not True
    or superpowers.get("recovery_route") != "skill-catalog-router"
):
    raise SystemExit("host-superpowers must be disabled, profile-addressable, and router-recoverable")
PY

python3 "${ROOT}/scripts/render-codex-skill-profile.py" "${MANIFEST}" \
  --mode profile --list-profiles >"${TMP_DIR}/profiles.txt"
diff -u <(printf 'on-demand\nsuperpowers-on-demand\n') "${TMP_DIR}/profiles.txt"

if python3 "${ROOT}/scripts/render-codex-skill-profile.py" "${MANIFEST}" \
  --mode profile --profile django-backend --output "${TMP_DIR}/django-backend.config.toml" >/dev/null 2>&1; then
  echo 'hidden django-backend raw alias rendered unexpectedly' >&2
  exit 1
fi

python3 "${ROOT}/scripts/render-codex-skill-profile.py" "${MANIFEST}" \
  --mode profile --profile on-demand --output "${TMP_DIR}/on-demand.config.toml"
rg -F 'linear-pm/SKILL.md", enabled = true' "${TMP_DIR}/on-demand.config.toml" >/dev/null

python3 "${ROOT}/scripts/render-codex-skill-profile.py" "${MANIFEST}" \
  --mode profile --profile superpowers-on-demand --output "${TMP_DIR}/superpowers-on-demand.config.toml"
rg -F 'superpowers/brainstorming/SKILL.md", enabled = true' "${TMP_DIR}/superpowers-on-demand.config.toml" >/dev/null
rg -F 'superpowers/verification-before-completion/SKILL.md", enabled = true' "${TMP_DIR}/superpowers-on-demand.config.toml" >/dev/null
