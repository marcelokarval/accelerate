#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

python3 - <<'PY'
from pathlib import Path
import hashlib
import re
import sys

root = Path.cwd()
failures = []

skip_dirs = {'.git', '.tmp', '.backups', 'node_modules', '.venv'}
historical_verbatim_path = Path('planning/architecture/2026-09-05-accelerate-consolidation-discussion-verbatim.md')
historical_verbatim_sha256 = 'f17ef66a8959eba1b3c60499d0d0c078ed59f809cf3e510d7e1ac833b3909e0c'


def permits_historical_absolute_link(relative_path: Path, content_sha256: str) -> bool:
    return relative_path == historical_verbatim_path and content_sha256 == historical_verbatim_sha256


# The exception is intentionally exact: any source edit or any other document
# must return to ordinary portable-link validation.
assert permits_historical_absolute_link(historical_verbatim_path, historical_verbatim_sha256)
assert not permits_historical_absolute_link(historical_verbatim_path, '0' * 64)
assert not permits_historical_absolute_link(Path('README.md'), historical_verbatim_sha256)

for md in root.rglob('*.md'):
    relative_md = md.relative_to(root)
    if any(part in skip_dirs for part in relative_md.parts):
        continue
    raw = md.read_bytes()
    text = raw.decode(errors='ignore')
    content_sha256 = hashlib.sha256(raw).hexdigest()
    is_historical_verbatim = relative_md == historical_verbatim_path
    if is_historical_verbatim and content_sha256 != historical_verbatim_sha256:
        failures.append((md, '<document>', 'historical verbatim digest mismatch'))
    pinned_historical_verbatim = permits_historical_absolute_link(relative_md, content_sha256)
    for match in re.finditer(r'\[[^\]]+\]\(([^)]+)\)', text):
        target = match.group(1).strip()
        if not target or target.startswith(('#', 'http://', 'https://', 'mailto:')):
            continue
        if target.startswith('/'):
            if pinned_historical_verbatim:
                continue
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
