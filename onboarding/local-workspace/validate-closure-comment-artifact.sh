#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 /path/to/target-repo closure-artifact" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
artifact_path="$2"
case "${artifact_path}" in -*|/*|*..*) echo "closure artifact path must be relative, cannot start with '-', and cannot contain '..': ${artifact_path}" >&2; exit 1 ;; esac
artifact_abs="${root}/${artifact_path}"
[ -f "${artifact_abs}" ] || { echo "missing closure artifact: ${artifact_path}" >&2; exit 2; }
artifact_real="$(readlink -f "${artifact_abs}")"
case "${artifact_real}" in "${root}"|"${root}"/*) ;; *) echo "resolved closure artifact escapes target repo: ${artifact_path}" >&2; exit 1 ;; esac

python3 - "${artifact_abs}" <<'PY'
from pathlib import Path
import re
import sys

text = Path(sys.argv[1]).read_text(errors="replace")
required_markers = [
    r"(?im)^# .*Closure",
    r"(?im)(tests?|proof|verification)",
    r"(?im)(self[- ]review|forensic|residual risks?|blockers?)",
]
missing = [marker for marker in required_markers if not re.search(marker, text)]
if missing:
    print("closure artifact is missing required closure/proof/review markers", file=sys.stderr)
    raise SystemExit(2)
if re.search(r"(?im)\b(TODO|TBD|placeholder)\b", text):
    print("closure artifact contains TODO/TBD/placeholder marker", file=sys.stderr)
    raise SystemExit(2)
PY
