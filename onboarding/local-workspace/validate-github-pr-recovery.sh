#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 /path/to/target-repo recovery-packet" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
packet_path="$2"
case "${packet_path}" in -*|/*|*..*) echo "recovery packet path must be relative, cannot start with '-', and cannot contain '..': ${packet_path}" >&2; exit 1 ;; esac
packet_abs="${root}/${packet_path}"
[ -f "${packet_abs}" ] || { echo "missing recovery packet: ${packet_path}" >&2; exit 2; }

python3 - "${packet_abs}" <<'PY'
from pathlib import Path
import re
import sys

text = Path(sys.argv[1]).read_text(errors="replace")
required = [
    "# GitHub PR Recovery Packet",
    "- schema_version: 1",
    "- adapter: github-pr",
    "- operation:",
    "- reason:",
    "- recorded_at:",
    "- retry_required: true",
    "- retry_command:",
    "- remote_write_allowed: false",
    "- zero_context_resume:",
]
missing = [item for item in required if item not in text]
if missing:
    print("recovery packet missing required fields: " + ", ".join(missing), file=sys.stderr)
    raise SystemExit(2)
if not re.search(r"(?m)^- repo: [^\s]+/[^\s]+$", text):
    print("recovery packet missing repo owner/name", file=sys.stderr)
    raise SystemExit(2)
if re.search(r"(?m)^- repo: unknown/unknown$", text):
    print("recovery packet repo cannot be unknown/unknown", file=sys.stderr)
    raise SystemExit(2)
operation_match = re.search(r"(?m)^- operation: (.+)$", text)
allowed_operations = {"read", "create", "attach", "rehydrate", "ship-readiness", "closure-comment", "land", "probe", "comment"}
if not operation_match or operation_match.group(1).strip() not in allowed_operations:
    print("recovery packet has invalid operation", file=sys.stderr)
    raise SystemExit(2)
if not re.search(r"(?m)^- branch: .+", text):
    print("recovery packet missing branch", file=sys.stderr)
    raise SystemExit(2)
PY
