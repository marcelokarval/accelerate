#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

python3 - <<'PY'
from pathlib import Path
import re
import sys

root = Path.cwd()
failures = []

skip_dirs = {'.git', '.tmp', '.backups', 'node_modules', '.venv'}

for md in root.rglob('*.md'):
    if any(part in skip_dirs for part in md.relative_to(root).parts):
        continue
    text = md.read_text(errors='ignore')
    for match in re.finditer(r'\[[^\]]+\]\(([^)]+)\)', text):
        target = match.group(1).strip()
        if not target or target.startswith(('#', 'http://', 'https://', 'mailto:')):
            continue
        if target.startswith('/'):
            failures.append((md, target, 'absolute local link'))
            continue
        path_part = target.split('#', 1)[0]
        if not path_part:
            continue
        resolved = (md.parent / path_part).resolve()
        try:
            resolved.relative_to(root)
        except ValueError:
            failures.append((md, target, 'escapes repository'))
            continue
        if not resolved.exists():
            failures.append((md, target, 'missing target'))

if failures:
    for md, target, reason in failures:
        print(f"markdown-link-integrity failed: {md.relative_to(root)} -> {target} ({reason})", file=sys.stderr)
    raise SystemExit(1)

print('markdown link integrity passed')
PY
