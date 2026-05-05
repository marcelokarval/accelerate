#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

usage() {
  echo "usage: $0 adapter" >&2
}

if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

adapter="$1"
case "${adapter}" in -*|*/*|*..*|"") echo "invalid adapter: ${adapter}" >&2; exit 1 ;; esac
manifest="${ROOT}/adapters/workflow/${adapter}/capabilities.yaml"
[ -f "${manifest}" ] || { echo "unknown workflow adapter: ${adapter}" >&2; exit 2; }

python3 - "${manifest}" <<'PY'
from pathlib import Path
import json
import sys

manifest = Path(sys.argv[1])
values = {}
for line in manifest.read_text().splitlines():
    if not line.strip() or line.lstrip().startswith('#') or ':' not in line:
        continue
    key, value = line.split(':', 1)
    values[key.strip()] = value.strip()
capabilities = [
    "read_lookup",
    "create_update",
    "review_artifact_attachment",
    "rehydration",
    "write_recovery",
    "closure_comment",
    "status_transition",
    "production_merge_land_gate",
]
summary = {
    "schema_version": values.get("schema_version"),
    "adapter": values.get("adapter"),
    "status": values.get("status"),
    "runtime_truth": values.get("runtime_truth"),
    "substitute_evidence": values.get("substitute_evidence"),
    "capabilities": {},
}
for capability in capabilities:
    summary["capabilities"][capability] = {
        "status": values.get(capability, "none"),
        "command": values.get(f"{capability}_command", "none"),
        "proof": values.get(f"{capability}_proof", "none"),
    }
json.dump(summary, sys.stdout, indent=2)
sys.stdout.write("\n")
PY
