#!/usr/bin/env python3
"""Preview/apply Accelerate to Antigravity's native user paths, without backups.

Only the portable entry skill and optional managed GEMINI.md block are written.
Preview has no filesystem effects. Apply checks an exact preview fingerprint.
Ordinary failures restore prior bytes from memory and remove created paths;
crash recovery and hostile concurrent filesystem mutation are not guaranteed.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import stat
import tempfile

ROOT = Path(__file__).resolve().parents[1]
START = b'<!-- accelerate-agy-entry:start -->'
END = b'<!-- accelerate-agy-entry:end -->'
DISABLED = b'No global skill or workflow bootstrap is configured.'


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def snapshot(file: Path) -> tuple[bytes | None, int | None]:
    """Reject links/special files at every component before reading a target."""
    for part in [*reversed(file.parents), file]:
        try:
            info = part.lstat()
        except FileNotFoundError:
            continue
        if stat.S_ISLNK(info.st_mode):
            raise ValueError(f'symlink refused: {part}')
        if part != file:
            if not stat.S_ISDIR(info.st_mode):
                raise ValueError(f'not a directory: {part}')
        elif not stat.S_ISREG(info.st_mode) or info.st_nlink != 1:
            raise ValueError(f'target must be a regular unlinked file: {part}')
    if not file.exists():
        return None, None
    return file.read_bytes(), stat.S_IMODE(file.stat().st_mode)


def render_rule(before: bytes | None, block: bytes) -> bytes:
    """Preserve outside bytes, replacing only the exact disabled sentinel if present."""
    original = before or b''
    original.decode('utf-8')
    count = (original.count(START), original.count(END))
    if count != (0, 0):
        if count != (1, 1):
            raise ValueError('ambiguous managed rule markers')
        start, end = original.index(START), original.index(END)
        if end < start or original[start:end + len(END)] != block.rstrip(b'\n'):
            raise ValueError('modified managed rule; reconcile explicitly')
        return original
    # Replace a complete exact line only, never text embedded in an owner policy.
    lines = original.splitlines(keepends=True)
    indexes = [i for i, line in enumerate(lines) if line.rstrip(b'\r\n') == DISABLED]
    if len(indexes) > 1:
        raise ValueError('ambiguous disabled-entry declarations')
    if indexes:
        lines[indexes[0]] = block
        return b''.join(lines)
    separator = b'' if not original else (b'\n' if original.endswith(b'\n') else b'\n\n')
    return original + separator + block


def plan(home: Path, with_entry_rule: bool) -> tuple[list[dict], dict]:
    """Prepare an exact native-path plan; do not create directories or receipts."""
    home = Path(os.path.abspath(home.expanduser()))
    skill = (ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes()
    rule = (ROOT / 'adapters/runtime/agy/entry-rule.md').read_bytes()
    entries = []
    destinations = [(home / '.gemini/config/skills/accelerate/SKILL.md', skill, False)]
    if with_entry_rule:
        destinations.append((home / '.gemini/GEMINI.md', rule, True))
    for target, source, is_rule in destinations:
        before, mode = snapshot(target)
        if is_rule:
            after = render_rule(before, source)
            if len(after) > 24000:
                raise ValueError('GEMINI.md would exceed the documented 24000-byte rule limit')
        else:
            if before is not None and before != source:
                raise ValueError(f'existing skill differs; reconcile explicitly: {target}')
            after = source
        entries.append(dict(path=target, before=before, after=after, mode=mode))
    public = dict(format=1, adapter='agy-native-entry', with_entry_rule=with_entry_rule,
                  files=[dict(path=str(e['path']), before_sha256=None if e['before'] is None else digest(e['before']),
                              after_sha256=digest(e['after']), before_bytes=0 if e['before'] is None else len(e['before']),
                              after_bytes=len(e['after']), mode=e['mode'],
                              action='unchanged' if e['before'] == e['after'] else 'create' if e['before'] is None else 'update')
                         for e in entries])
    public['plan_sha256'] = digest(json.dumps(public, sort_keys=True, separators=(',', ':')).encode())
    return entries, public


def atomic_write(target: Path, data: bytes, mode: int | None) -> None:
    """Replace one regular file via a cleaned sibling temporary file."""
    fd, name = tempfile.mkstemp(prefix='.accelerate-write-', dir=target.parent)
    try:
        with os.fdopen(fd, 'wb') as stream:
            stream.write(data)
            os.fchmod(stream.fileno(), 0o644 if mode is None else mode)
        os.replace(name, target)
    finally:
        if os.path.exists(name):
            os.unlink(name)


def apply(entries: list[dict]) -> None:
    """Apply a quiescent plan; rollback only this call's successful writes on error."""
    written, directories = [], []
    try:
        for entry in entries:
            target = entry['path']
            if snapshot(target) != (entry['before'], entry['mode']):
                raise ValueError(f'target changed since preview: {target}')
            if entry['before'] == entry['after']:
                continue
            missing = []
            parent = target.parent
            while not parent.exists():
                missing.append(parent)
                parent = parent.parent
            for directory in reversed(missing):
                directory.mkdir()
                directories.append(directory)
            # Recheck after creating ancestors, before the atomic replacement.
            if snapshot(target) != (entry['before'], entry['mode']):
                raise ValueError(f'target changed during apply: {target}')
            atomic_write(target, entry['after'], entry['mode'])
            written.append(entry)
    except Exception as failure:
        rollback_errors = []
        for entry in reversed(written):
            try:
                if snapshot(entry['path'])[0] != entry['after']:
                    raise ValueError(f'concurrent change retained: {entry["path"]}')
                if entry['before'] is None:
                    entry['path'].unlink()
                else:
                    atomic_write(entry['path'], entry['before'], entry['mode'])
            except Exception as error:
                rollback_errors.append(str(error))
        for directory in reversed(directories):
            try:
                directory.rmdir()
            except OSError as error:
                rollback_errors.append(str(error))
        if rollback_errors:
            raise ValueError(f'{failure}; incomplete cleanup: {rollback_errors}') from failure
        raise


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--home', type=Path, default=Path.home(), help='User home; override for fixtures')
    parser.add_argument('--with-entry-rule', action='store_true', help='Explicitly manage a conditional GEMINI.md block')
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--expect-plan-sha256', help='Exact fingerprint from the approved preview; required to apply')
    args = parser.parse_args()
    try:
        entries, report = plan(args.home, args.with_entry_rule)
        if args.apply:
            if args.expect_plan_sha256 != report['plan_sha256']:
                raise ValueError('apply requires the current preview --expect-plan-sha256')
            apply(entries)
        report['mode'] = 'applied' if args.apply else 'preview'
        print(json.dumps(report, indent=2))
        return 0
    except (OSError, ValueError) as error:
        parser.exit(1, f'{error}\n')


if __name__ == '__main__':
    raise SystemExit(main())
