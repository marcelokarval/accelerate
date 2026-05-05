#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

usage() {
  echo "usage: $0 adapter capability" >&2
}

if [ "$#" -ne 2 ]; then
  usage
  exit 1
fi

adapter="$1"
capability="$2"
case "${adapter}" in -*|*/*|*..*|"") echo "invalid adapter: ${adapter}" >&2; exit 1 ;; esac
case "${capability}" in read_lookup|create_update|review_artifact_attachment|rehydration|write_recovery|closure_comment|status_transition|production_merge_land_gate) ;;
  *) echo "unknown workflow capability: ${capability}" >&2; exit 2 ;;
esac
manifest="${ROOT}/adapters/workflow/${adapter}/capabilities.yaml"
[ -f "${manifest}" ] || { echo "unknown workflow adapter: ${adapter}" >&2; exit 2; }

python3 - "${manifest}" "${capability}" <<'PY'
from pathlib import Path
import json
import sys

manifest = Path(sys.argv[1])
capability = sys.argv[2]
values = {}
for line in manifest.read_text().splitlines():
    if not line.strip() or line.lstrip().startswith('#') or ':' not in line:
        continue
    key, value = line.split(':', 1)
    values[key.strip()] = value.strip()
status = values.get(capability)
if not status:
    print(f"capability missing from manifest: {capability}", file=sys.stderr)
    raise SystemExit(2)
result = {
    "adapter": values.get("adapter"),
    "capability": capability,
    "status": status,
    "command": values.get(f"{capability}_command", "none"),
    "proof": values.get(f"{capability}_proof", "none"),
    "runtime_truth": values.get("runtime_truth"),
    "available": status in {"native", "linked", "substitute"},
}
json.dump(result, sys.stdout, indent=2)
sys.stdout.write("\n")
if status not in {"native", "linked", "substitute"}:
    raise SystemExit(3)
PY
