#!/usr/bin/env python3
"""Restore missing DSH support documents, never replace runtime policy.

Default is a zero-write plan. Source is this checkout. Existing target files
are preserved. This is a repair, not the general runtime bootstrap installer.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re

SOURCE = Path(__file__).resolve().parents[1]
ENTRY = re.compile(r'references/[A-Za-z0-9_./-]+\.md')
LINK = re.compile(r'(?:\.\./|\./)?(?:core|references|adapters|profiles|onboarding|skills|docs)/[A-Za-z0-9_./-]+\.(?:md|json|yaml|toml)')


def plan(source, target):
    source, target = source.resolve(), target.resolve()
    pending = [(Path(p), True) for p in sorted(set(ENTRY.findall((target / 'SKILL.md').read_text())))]
    seen, copies = set(), {}
    while pending:
        rel, required = pending.pop()
        if rel in seen:
            continue
        seen.add(rel)
        src, dst = source / rel, target / rel
        for base, path in ((source, src), (target, dst)):
            if not path.resolve().is_relative_to(base):
                raise ValueError(f'path escapes root: {rel}')
        if dst.is_file():
            text = dst.read_text()
        elif src.is_file():
            data = src.read_bytes()
            copies[rel] = data
            text = data.decode()
        elif required:
            raise ValueError(f'missing source for required document: {rel}')
        else:
            continue
        for raw in LINK.findall(text):
            # Explicit dot paths are relative to the referring document.
            candidate = ((src.parent / raw) if raw.startswith('.') else (source / raw)).resolve()
            if candidate.is_relative_to(source) and candidate.is_file():
                pending.append((candidate.relative_to(source), False))
    return copies


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--target', type=Path, required=True)
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    copies = plan(SOURCE, args.target)
    manifest = {str(p): hashlib.sha256(b).hexdigest() for p, b in sorted(copies.items())}
    if args.apply:
        # Preflight all dependencies before any mutation; exclusive creation
        # prevents overwriting files that appeared after planning.
        for rel, data in sorted(copies.items()):
            dst = args.target / rel
            dst.parent.mkdir(parents=True, exist_ok=True)
            with dst.open('xb') as stream:
                stream.write(data)
        for rel, data in copies.items():
            assert (args.target / rel).read_bytes() == data
        assert not plan(SOURCE, args.target), 'repair is not idempotent'
    print(json.dumps({'mode': 'apply' if args.apply else 'dry-run', 'source': str(SOURCE), 'files': manifest, 'count': len(manifest)}, indent=2))


if __name__ == '__main__':
    main()
