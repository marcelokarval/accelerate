#!/usr/bin/env python3
"""Preview/apply Accelerate to Antigravity CLI's native user paths.

The portable skill is installed under Antigravity CLI's application-data root
and the managed GEMINI.md entry block is always present.  A legacy skill under
``~/.gemini/config`` is removed only when its bytes have explicit ownership
evidence.  Preview has no filesystem effects; apply is bound to the preview and
performs exact readback.  No disk backup or parallel runtime is created.
"""
from __future__ import annotations

import argparse
import errno
import hashlib
import json
import os
from pathlib import Path
import re
import signal
import stat
import tempfile

ROOT = Path(__file__).resolve().parents[1]
START = b'<!-- accelerate-agy-entry:start -->'
END = b'<!-- accelerate-agy-entry:end -->'
DISABLED = b'No global skill or workflow bootstrap is configured.'
OFFICIAL_SKILL = Path('.gemini/antigravity-cli/skills/accelerate/SKILL.md')
LEGACY_SKILL = Path('.gemini/config/skills/accelerate/SKILL.md')
ENTRY_RULE = Path('.gemini/GEMINI.md')
TEMP_RE = re.compile(r'^\.accelerate-write-v2-(SKILL\.md|GEMINI\.md)-([0-9a-f]{64})-[A-Za-z0-9_]+\.tmp$')


class TerminationRequested(BaseException):
    """Convert SIGTERM into a compensatable interruption inside apply()."""


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


def validate_sha256(value: str | None, option: str) -> None:
    if value is not None and (len(value) != 64 or any(c not in '0123456789abcdef' for c in value)):
        raise ValueError(f'{option} must be a lowercase SHA256')


def render_rule(before: bytes | None, block: bytes, replace_rule_sha256: str | None = None) -> bytes:
    """Preserve owner bytes and replace only a hash-bound managed block."""
    original = before or b''
    original.decode('utf-8')
    count = (original.count(START), original.count(END))
    if count != (0, 0):
        if count != (1, 1):
            raise ValueError('ambiguous managed rule markers')
        start, end = original.index(START), original.index(END)
        if end < start:
            raise ValueError('ambiguous managed rule markers')
        managed = original[start:end + len(END)]
        expected = block.rstrip(b'\n')
        if replace_rule_sha256 is not None and digest(managed) != replace_rule_sha256:
            raise ValueError('managed rule does not match replacement SHA256')
        if managed == expected:
            return original
        if replace_rule_sha256 is None:
            raise ValueError('modified managed rule; pass its exact replacement SHA256')
        return original[:start] + expected + original[end + len(END):]
    if replace_rule_sha256 is not None:
        raise ValueError('managed rule required by replacement SHA256 is missing')
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


def plan(home: Path, replace_skill_sha256: str | None = None,
         migrate_legacy_skill_sha256: str | None = None,
         replace_rule_sha256: str | None = None,
         cleanup_empty_legacy_dir_sha256: str | None = None) -> tuple[list[dict], dict]:
    """Prepare an exact official-path plan; do not create directories or receipts."""
    home = Path(os.path.abspath(home.expanduser()))
    validate_sha256(replace_skill_sha256, 'replace-skill-sha256')
    validate_sha256(migrate_legacy_skill_sha256, 'migrate-legacy-skill-sha256')
    validate_sha256(replace_rule_sha256, 'replace-rule-sha256')
    validate_sha256(cleanup_empty_legacy_dir_sha256,
                    'cleanup-empty-legacy-dir-sha256')
    if (migrate_legacy_skill_sha256 is not None and
            cleanup_empty_legacy_dir_sha256 is not None):
        raise ValueError('migration and empty-directory reconciliation options are mutually exclusive')
    skill = (ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes()
    rule = (ROOT / 'adapters/runtime/agy/entry-rule.md').read_bytes()
    official = home / OFFICIAL_SKILL
    legacy = home / LEGACY_SKILL
    rule_target = home / ENTRY_RULE
    official_before, official_mode = snapshot(official)
    legacy_before, legacy_mode = snapshot(legacy)
    rule_before, rule_mode = snapshot(rule_target)

    legacy_ownership = None
    if legacy_before is not None:
        if migrate_legacy_skill_sha256 is not None:
            if digest(legacy_before) != migrate_legacy_skill_sha256:
                raise ValueError(f'legacy skill does not match migration SHA256: {legacy}')
            legacy_ownership = 'explicit-sha256'
        elif legacy_before == skill:
            legacy_ownership = 'source-identical'
        else:
            raise ValueError(
                f'legacy skill ownership is uncertain; pass its exact migration SHA256: {legacy}')
    elif migrate_legacy_skill_sha256 is not None:
        # A SIGKILL after the atomic legacy->official move leaves the authorized
        # legacy bytes at the official discovery path.  Recognize only that exact
        # resumable intermediate state.  A published current payload uses either
        # flagless idempotence or explicit empty-directory reconciliation.
        if official_before is None:
            raise ValueError(f'legacy skill required by migration SHA256 is missing: {legacy}')
        if official_before == skill:
            raise ValueError('official skill is already current; rerun idempotently without '
                             '--migrate-legacy-skill-sha256')
        if digest(official_before) != migrate_legacy_skill_sha256:
            raise ValueError(f'official intermediate does not match migration SHA256: {official}')
        legacy_ownership = 'resumed-intermediate-sha256'

    if replace_skill_sha256 is not None and (
            official_before is None or digest(official_before) != replace_skill_sha256):
        raise ValueError(f'existing official skill does not match replacement SHA256: {official}')
    official_is_resumable = (legacy_before is None and
                             migrate_legacy_skill_sha256 is not None and
                             official_before is not None and
                             digest(official_before) == migrate_legacy_skill_sha256)
    if (official_before is not None and official_before != skill and
            replace_skill_sha256 is None and not official_is_resumable):
        raise ValueError(f'existing official skill differs; reconcile explicitly: {official}')

    explicit_empty_dir_cleanup = False
    empty_legacy_dir_proof = None
    if cleanup_empty_legacy_dir_sha256 is not None:
        if legacy_before is not None:
            raise ValueError('empty-directory reconciliation requires an absent legacy skill')
        if official_before != skill:
            raise ValueError('empty-directory reconciliation requires the current official skill')
        if digest(official_before) != cleanup_empty_legacy_dir_sha256:
            raise ValueError('current official skill does not match empty-directory cleanup SHA256')
        legacy_directory = legacy.parent
        if not legacy_directory.is_dir() or any(legacy_directory.iterdir()):
            raise ValueError('empty-directory reconciliation requires the exact empty legacy directory')
        explicit_empty_dir_cleanup = True
        directory_info = legacy_directory.lstat()
        empty_legacy_dir_proof = dict(path=str(legacy_directory),
                                      device=directory_info.st_dev,
                                      inode=directory_info.st_ino,
                                      mode=stat.S_IMODE(directory_info.st_mode))

    rule_after = render_rule(rule_before, rule, replace_rule_sha256)
    if len(rule_after) > 24000:
        raise ValueError('GEMINI.md would exceed the documented 24000-byte rule limit')

    move_legacy = legacy_before is not None and official_before is None
    entries = [dict(path=legacy, before=legacy_before, after=None,
                    mode=legacy_mode, after_mode=None,
                    ownership=legacy_ownership or 'absent',
                    migration_move=move_legacy, role='legacy-skill',
                    cleanup_legacy_dir=(legacy_before is not None or official_is_resumable or
                                        explicit_empty_dir_cleanup),
                    cleanup_dir_proof=empty_legacy_dir_proof)]
    entries.extend([
        dict(path=official, before=official_before, after=skill,
             mode=official_mode,
             after_mode=(0o644 if official_mode is None or official_is_resumable
                         else official_mode),
             ownership=('resumable-' + legacy_ownership if official_is_resumable
                        else 'source-payload'), migration_move=move_legacy,
             role='official-skill', cleanup_legacy_dir=False, cleanup_dir_proof=None),
        dict(path=rule_target, before=rule_before, after=rule_after,
             mode=rule_mode, after_mode=0o644 if rule_mode is None else rule_mode,
             ownership='managed-markers', migration_move=False,
             role='entry-rule', cleanup_legacy_dir=False, cleanup_dir_proof=None),
    ])

    allowed_temps = {}
    for entry in entries:
        hashes = {}
        for data, mode in ((entry['before'], entry['mode']),
                           (entry['after'], entry['after_mode'])):
            if data is not None:
                hashes.setdefault(digest(data), set()).add(mode)
        allowed_temps[(entry['path'].parent, entry['path'].name)] = hashes
    temp_entries = []
    for parent in sorted({path for path, _name in allowed_temps}, key=str):
        if not parent.exists():
            continue
        for candidate in sorted(parent.iterdir(), key=lambda path: path.name):
            if not candidate.name.startswith('.accelerate-write-'):
                continue
            match = TEMP_RE.fullmatch(candidate.name)
            if match is None:
                raise ValueError(f'unverifiable installer temporary file: {candidate}')
            target_name, claimed_hash = match.groups()
            allowed = allowed_temps.get((parent, target_name))
            before, mode = snapshot(candidate)
            if (allowed is None or before is None or digest(before) != claimed_hash or
                    claimed_hash not in allowed or mode not in allowed[claimed_hash]):
                raise ValueError(f'unverifiable installer temporary file: {candidate}')
            temp_entries.append(dict(path=candidate, before=before, after=None,
                                     mode=mode, after_mode=None,
                                     ownership='verified-temp-fingerprint',
                                     migration_move=False, role='orphan-temp',
                                     cleanup_legacy_dir=False,
                                     cleanup_dir_proof=None))
    entries = temp_entries + entries

    def public_entry(entry: dict) -> dict:
        before, after = entry['before'], entry['after']
        action = ('unchanged' if before == after else 'delete' if after is None
                  else 'create' if before is None else 'update')
        return dict(path=str(entry['path']),
                    before_sha256=None if before is None else digest(before),
                    after_sha256=None if after is None else digest(after),
                    before_bytes=0 if before is None else len(before),
                    after_bytes=0 if after is None else len(after),
                    mode=entry['mode'], after_mode=entry['after_mode'],
                    action=action, ownership=entry['ownership'],
                    migration_move=entry['migration_move'], role=entry['role'])

    public = dict(format=2, adapter='agy-native-entry', entry_rule='always-on',
                  migration_strategy=('atomic-legacy-to-official-move' if move_legacy
                                      else 'in-place'),
                  official_skill_path=str(official), legacy_skill_path=str(legacy),
                  replace_skill_sha256=replace_skill_sha256,
                  migrate_legacy_skill_sha256=migrate_legacy_skill_sha256,
                  replace_rule_sha256=replace_rule_sha256,
                  cleanup_empty_legacy_dir_sha256=cleanup_empty_legacy_dir_sha256,
                  empty_legacy_dir_proof=empty_legacy_dir_proof,
                  files=[public_entry(e) for e in entries])
    public['plan_sha256'] = digest(json.dumps(public, sort_keys=True, separators=(',', ':')).encode())
    return entries, public


def atomic_write(target: Path, data: bytes, mode: int | None) -> None:
    """Replace one regular file via a cleaned sibling temporary file."""
    fingerprint = digest(data)
    fd, name = tempfile.mkstemp(
        prefix=f'.accelerate-write-v2-{target.name}-{fingerprint}-',
        suffix='.tmp', dir=target.parent)
    try:
        with os.fdopen(fd, 'wb') as stream:
            stream.write(data)
            os.fchmod(stream.fileno(), 0o644 if mode is None else mode)
            stream.flush()
            os.fsync(stream.fileno())
        checkpoint('after_temp_fsync')
        os.replace(name, target)
    finally:
        if os.path.exists(name):
            os.unlink(name)


def readback(entries: list[dict]) -> list[dict]:
    """Require the exact planned bytes, absence and modes after application."""
    result = []
    for entry in entries:
        data, mode = snapshot(entry['path'])
        if data != entry['after'] or mode != entry['after_mode']:
            raise ValueError(f'readback differs from approved plan: {entry["path"]}')
        result.append(dict(path=str(entry['path']), present=data is not None,
                           sha256=None if data is None else digest(data), mode=mode,
                           verified=True))
    return result


def checkpoint(_name: str) -> None:
    """No-op seam used by subprocess crash tests."""


def _ensure_parent(target: Path, mutations: list[dict]) -> None:
    missing = []
    parent = target.parent
    while not parent.exists():
        missing.append(parent)
        parent = parent.parent
    for directory in reversed(missing):
        # Register intent before the mutation so KeyboardInterrupt is compensable.
        mutations.append(dict(kind='mkdir', path=directory))
        directory.mkdir()


def _compensate(mutation: dict) -> None:
    kind = mutation['kind']
    if kind == 'mkdir':
        path = mutation['path']
        if not path.exists():
            return
        path.rmdir()
        return
    if kind == 'rmdir':
        path = mutation['path']
        if not mutation['existed_before']:
            if path.exists():
                raise ValueError(f'cleanup path appeared concurrently: {path}')
            return
        if not path.exists():
            path.mkdir()
        elif not path.is_dir():
            raise ValueError(f'cleanup path changed type: {path}')
        return
    if kind == 'move':
        source, target = mutation['source'], mutation['target']
        source_now, target_now = snapshot(source), snapshot(target)
        source_before = mutation['source_before']
        target_before = mutation['target_before']
        if source_now == source_before and target_now == target_before:
            return
        if source_now == (None, None) and target_now == source_before:
            source.parent.mkdir(parents=True, exist_ok=True)
            os.replace(target, source)
            return
        raise ValueError(f'concurrent move state retained: {source} -> {target}')
    if kind == 'write':
        path = mutation['path']
        current = snapshot(path)
        before, after = mutation['before'], mutation['after']
        if current == before:
            return
        if current != after:
            raise ValueError(f'concurrent change retained: {path}')
        if before == (None, None):
            path.unlink()
        elif after == (None, None):
            path.parent.mkdir(parents=True, exist_ok=True)
            atomic_write(path, before[0], before[1])
        else:
            atomic_write(path, before[0], before[1])
        return
    raise ValueError(f'unknown mutation kind: {kind}')


def apply(entries: list[dict]) -> list[dict]:
    """Apply with in-memory intent logging and crash-tolerant legacy publication."""
    mutations = []
    previous_sigterm = None
    sigterm_installed = False

    def terminate(_signum, _frame):
        raise TerminationRequested('SIGTERM during AGY entry migration')

    try:
        # Validate the complete approved state before the first mutation.
        for entry in entries:
            if snapshot(entry['path']) != (entry['before'], entry['mode']):
                raise ValueError(f'target changed since preview: {entry["path"]}')

        previous_sigterm = signal.getsignal(signal.SIGTERM)
        signal.signal(signal.SIGTERM, terminate)
        sigterm_installed = True

        legacy_entry = next((e for e in entries if e['role'] == 'legacy-skill'), None)
        official_entry = next((e for e in entries if e['role'] == 'official-skill'), None)
        if legacy_entry['cleanup_dir_proof'] is not None:
            proof = legacy_entry['cleanup_dir_proof']
            directory = legacy_entry['path'].parent
            info = directory.lstat()
            observed = dict(path=str(directory), device=info.st_dev, inode=info.st_ino,
                            mode=stat.S_IMODE(info.st_mode))
            if observed != proof or any(directory.iterdir()):
                raise ValueError(f'empty legacy directory changed since preview: {directory}')
        if legacy_entry is not None and legacy_entry.get('migration_move'):
            _ensure_parent(official_entry['path'], mutations)
            if snapshot(legacy_entry['path']) != (legacy_entry['before'], legacy_entry['mode']):
                raise ValueError(f'legacy source changed before atomic move: {legacy_entry["path"]}')
            if snapshot(official_entry['path']) != (official_entry['before'], official_entry['mode']):
                raise ValueError(f'official target changed before atomic move: {official_entry["path"]}')
            move = dict(kind='move', source=legacy_entry['path'],
                        target=official_entry['path'],
                        source_before=(legacy_entry['before'], legacy_entry['mode']),
                        target_before=(official_entry['before'], official_entry['mode']))
            mutations.append(move)
            os.replace(legacy_entry['path'], official_entry['path'])
            checkpoint('after_migration_move')

        for entry in entries:
            target = entry['path']
            if entry['before'] == entry['after']:
                continue
            if entry.get('migration_move') and entry['after'] is None:
                continue
            before = snapshot(target)
            if entry.get('migration_move') and entry['after'] is not None:
                expected = (legacy_entry['before'], legacy_entry['mode'])
                if before != expected:
                    raise ValueError(f'official move state changed before publication: {target}')
            elif before != (entry['before'], entry['mode']):
                raise ValueError(f'target changed during apply: {target}')
            if entry['after'] is None:
                mutations.append(dict(kind='write', path=target, before=before,
                                      after=(None, None)))
                target.unlink()
                continue
            _ensure_parent(target, mutations)
            if snapshot(target) != before:
                raise ValueError(f'target changed before atomic publication: {target}')
            after = (entry['after'], entry['after_mode'])
            mutations.append(dict(kind='write', path=target, before=before, after=after))
            if target.name == 'GEMINI.md':
                checkpoint('before_rule_write')
            atomic_write(target, entry['after'], entry['after_mode'])
            if entry.get('migration_move'):
                checkpoint('after_official_publish')
            if target.name == 'GEMINI.md':
                checkpoint('after_rule_write')
        checkpoint('before_readback')
        verified = readback(entries)
        checkpoint('after_readback')
        # Remove only the now-empty legacy package directory.  Parent config and
        # skills directories can contain unrelated owner state and are retained.
        legacy_cleanup = [(entry['path'].parent,
                           entry['cleanup_dir_proof'] is not None)
                          for entry in entries if entry['role'] == 'legacy-skill' and
                          entry['cleanup_legacy_dir']]
        checkpoint('before_cleanup')
        for directory, required in legacy_cleanup:
            existed_before = directory.exists()
            mutations.append(dict(kind='rmdir', path=directory,
                                  existed_before=existed_before))
            if not existed_before:
                continue
            try:
                directory.rmdir()
            except OSError as error:
                if required or error.errno not in (errno.ENOTEMPTY, errno.EEXIST):
                    raise
        checkpoint('after_cleanup')
        return verified
    except BaseException as failure:
        rollback_errors = []
        for mutation in reversed(mutations):
            try:
                _compensate(mutation)
            except BaseException as error:
                rollback_errors.append(str(error))
        if rollback_errors:
            raise ValueError(f'{failure}; incomplete cleanup: {rollback_errors}') from failure
        raise
    finally:
        if sigterm_installed:
            signal.signal(signal.SIGTERM, previous_sigterm)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--home', type=Path, default=Path.home(), help='User home; override for fixtures')
    parser.add_argument('--with-entry-rule', action='store_true', help=argparse.SUPPRESS)
    parser.add_argument('--replace-skill-sha256', help='Explicit replacement of the exact existing skill bytes; preview first')
    parser.add_argument('--migrate-legacy-skill-sha256',
                        help='Authorize removal of exact legacy ~/.gemini/config skill bytes')
    parser.add_argument('--replace-rule-sha256',
                        help='Authorize replacement of the exact existing managed rule block')
    parser.add_argument('--cleanup-empty-legacy-dir-sha256',
                        help='Explicitly reconcile an empty legacy directory against the current official skill hash')
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--expect-plan-sha256', help='Exact fingerprint from the approved preview; required to apply')
    args = parser.parse_args()
    try:
        entries, report = plan(args.home, args.replace_skill_sha256,
                               args.migrate_legacy_skill_sha256,
                               args.replace_rule_sha256,
                               args.cleanup_empty_legacy_dir_sha256)
        if args.apply:
            if args.expect_plan_sha256 != report['plan_sha256']:
                raise ValueError('apply requires the current preview --expect-plan-sha256')
            report['readback'] = apply(entries)
        report['mode'] = 'applied' if args.apply else 'preview'
        print(json.dumps(report, indent=2))
        return 0
    except KeyboardInterrupt:
        parser.exit(130, 'interrupted; planned mutations were compensated\n')
    except TerminationRequested:
        parser.exit(143, 'terminated; planned mutations were compensated\n')
    except (OSError, ValueError) as error:
        parser.exit(1, f'{error}\n')


if __name__ == '__main__':
    raise SystemExit(main())
