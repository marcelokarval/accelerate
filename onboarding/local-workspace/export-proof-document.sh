#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "usage: $0 /path/to/target-repo source.md output.html" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
source_path="$2"
output_path="$3"

case "${source_path}" in /*|*..*) echo "source path must be relative and cannot contain '..': ${source_path}" >&2; exit 1 ;; esac
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac
case "${output_path}" in .accelerate/*|.tmp/*) ;; *) echo "output must stay under .accelerate/ or .tmp/: ${output_path}" >&2; exit 1 ;; esac
case "${output_path}" in *.html) ;; *) echo "output must be .html for the built-in exporter: ${output_path}" >&2; exit 1 ;; esac

source_abs="${root}/${source_path}"
[ -f "${source_abs}" ] || { echo "missing source: ${source_abs}" >&2; exit 1; }
source_real="$(readlink -f "${source_abs}")"
case "${source_real}" in "${root}"|"${root}"/*) ;; *) echo "resolved source escapes target repo: ${source_path}" >&2; exit 1 ;; esac
privacy_map="${root}/.accelerate/status/privacy-map.yaml"
[ -f "${privacy_map}" ] || { echo "missing privacy map: ${privacy_map}" >&2; exit 1; }
bash "$(dirname "${BASH_SOURCE[0]}")/require-export-approved.sh" "${root}" "${source_path}"

mkdir -p "$(dirname "${root}/${output_path}")"
out_dir="$(cd "$(dirname "${root}/${output_path}")" && pwd)"
case "${out_dir}" in "${root}/.accelerate"|"${root}/.accelerate"/*|"${root}/.tmp"|"${root}/.tmp"/*) ;; *) echo "resolved output escapes allowed dirs: ${output_path}" >&2; exit 1 ;; esac
if [ -L "${root}/${output_path}" ]; then
  echo "output path must not be a symlink: ${output_path}" >&2
  exit 1
fi

python3 - "$source_abs" "${root}/${output_path}" <<'PY'
import html
import sys
from pathlib import Path

source = Path(sys.argv[1])
output = Path(sys.argv[2])
text = source.read_text(encoding="utf-8")
body = []
for raw in text.splitlines():
    line = html.escape(raw)
    if line.startswith("# "):
        body.append(f"<h1>{line[2:]}</h1>")
    elif line.startswith("## "):
        body.append(f"<h2>{line[3:]}</h2>")
    elif line.startswith("### "):
        body.append(f"<h3>{line[4:]}</h3>")
    elif line.startswith("- "):
        body.append(f"<p class=\"bullet\">{line}</p>")
    elif line.strip() == "":
        body.append("")
    else:
        body.append(f"<p>{line}</p>")

doc = """<!doctype html>
<html lang=\"en\">
<head>
<meta charset=\"utf-8\">
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
<title>Accelerate Proof Export</title>
<style>
body { font-family: ui-sans-serif, system-ui, sans-serif; margin: 40px; line-height: 1.55; color: #111827; }
h1, h2, h3 { line-height: 1.2; }
.bullet { margin-left: 1rem; }
code { background: #f3f4f6; padding: 0.1rem 0.25rem; border-radius: 0.25rem; }
</style>
</head>
<body>
%s
</body>
</html>
""" % "\n".join(body)
output.write_text(doc, encoding="utf-8")
PY

packet="${root}/.accelerate/review/document-export-packet.md"
cat > "${packet}" <<MD
# Document Export Packet

- source artifact: ${source_path}
- output artifact: ${output_path}
- privacy class: generated-export
- export approver/source: local-script
- renderer: export-proof-document.sh
- network asset policy: disabled
- generated timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
MD

printf '%s\n' "${output_path}"
