"""Native AGY installation in disposable fixture homes; never live user config."""
import importlib.util
import json
from pathlib import Path
import signal
import subprocess
import sys

import pytest

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / 'scripts/install-agy-entry.py'
spec = importlib.util.spec_from_file_location('agy_entry', SCRIPT)
installer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(installer)


def cli(home, *args):
    return subprocess.run([sys.executable, '-B', str(SCRIPT), '--home', str(home), *args],
                          text=True, capture_output=True)


def official(home):
    return home / installer.OFFICIAL_SKILL


def legacy(home):
    return home / installer.LEGACY_SKILL


def rule(home):
    return home / installer.ENTRY_RULE


def interrupted_apply(home, legacy_hash, point, interruption):
    program = r'''import importlib.util, os, signal, sys
from pathlib import Path
spec = importlib.util.spec_from_file_location("agy_entry_child", sys.argv[1])
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
entries, _ = module.plan(Path(sys.argv[2]), migrate_legacy_skill_sha256=sys.argv[3])
def stop(name):
    if name != sys.argv[4]:
        return
    if sys.argv[5] == "keyboard":
        raise KeyboardInterrupt()
    os.kill(os.getpid(), getattr(signal, sys.argv[5]))
module.checkpoint = stop
module.apply(entries)
'''
    return subprocess.run([sys.executable, '-B', '-c', program, str(SCRIPT), str(home),
                           legacy_hash, point, interruption], capture_output=True,
                          text=True, timeout=10)


def test_preview_creates_nothing_and_default_apply_installs_skill_and_always_on_rule(tmp_path):
    home = tmp_path / 'new-home'
    preview = cli(home)
    assert preview.returncode == 0, preview.stderr
    assert not home.exists()
    plan = json.loads(preview.stdout)
    assert plan['format'] == 2
    assert plan['entry_rule'] == 'always-on'
    assert [item['action'] for item in plan['files']] == ['unchanged', 'create', 'create']
    applied = cli(home, '--apply', '--expect-plan-sha256', plan['plan_sha256'])
    assert applied.returncode == 0, applied.stderr
    result = json.loads(applied.stdout)
    assert all(item['verified'] for item in result['readback'])
    assert official(home).read_bytes() == (ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes()
    assert rule(home).read_bytes() == (ROOT / 'adapters/runtime/agy/entry-rule.md').read_bytes()
    assert not legacy(home).exists()


def test_legacy_with_entry_rule_switch_is_a_compatible_no_op(tmp_path):
    default = json.loads(cli(tmp_path).stdout)
    legacy_command = json.loads(cli(tmp_path, '--with-entry-rule').stdout)
    assert legacy_command == default


def test_always_on_rule_admits_entry_then_progressively_loads_planning_only_stack():
    block = (ROOT / 'adapters/runtime/agy/entry-rule.md').read_text()
    readme = (ROOT / 'adapters/runtime/agy/README.md').read_text()
    assert '~/.gemini/config/plugins/accelerate-entry/skills/accelerate/SKILL.md' in block
    assert 'login-button rule that rejects credentials' in block
    assert 'spec-driven-superpowers (ASDS)' in block
    assert 'caller-selected implementation consumer' in block
    assert 'supported global plugin location is' in readme
    assert 'Previous loose adapters may have' in readme
    assert 'remains only for recognizing and auditing legacy loose state' in readme


def test_rule_preserves_owner_bytes_mode_and_is_idempotent(tmp_path):
    file = rule(tmp_path)
    file.parent.mkdir()
    prefix, suffix = b'# Owner\r\nNever install without approval.\r\n', b'\r\nEnd owner text.\r\n'
    file.write_bytes(prefix + installer.DISABLED + b'\r\n' + suffix)
    file.chmod(0o600)
    entries, _ = installer.plan(tmp_path)
    installer.apply(entries)
    block = (ROOT / 'adapters/runtime/agy/entry-rule.md').read_bytes()
    assert file.read_bytes() == prefix + block + suffix
    assert file.stat().st_mode & 0o777 == 0o600
    entries2, report2 = installer.plan(tmp_path)
    assert all(item['action'] == 'unchanged' for item in report2['files'])
    installer.apply(entries2)
    assert file.read_bytes() == prefix + block + suffix
    assert not list(tmp_path.rglob('*.bak'))
    assert not list(tmp_path.rglob('.accelerate-write-*'))


def test_rule_without_sentinel_appends_without_rewriting_existing_policy(tmp_path):
    file = rule(tmp_path)
    file.parent.mkdir()
    file.write_bytes(b'Owner instruction without final newline')
    entries, _ = installer.plan(tmp_path)
    rule_entry = next(entry for entry in entries if entry['path'] == file)
    assert rule_entry['after'].startswith(file.read_bytes() + b'\n\n')
    assert file.read_bytes() == b'Owner instruction without final newline'


def test_apply_requires_exact_preview_and_current_owner_text(tmp_path):
    preview = cli(tmp_path)
    token = json.loads(preview.stdout)['plan_sha256']
    assert cli(tmp_path, '--apply').returncode != 0
    rule(tmp_path).parent.mkdir()
    rule(tmp_path).write_text('New owner rule\n')
    assert cli(tmp_path, '--apply', '--expect-plan-sha256', token).returncode != 0
    assert not official(tmp_path).exists()


@pytest.mark.parametrize('content', [b'user skill', b''])
def test_conflicting_official_skill_aborts_before_any_rule_write(tmp_path, content):
    file = official(tmp_path)
    file.parent.mkdir(parents=True)
    file.write_bytes(content)
    with pytest.raises(ValueError, match='existing official skill differs'):
        installer.plan(tmp_path)
    assert not rule(tmp_path).exists()


def test_legacy_skill_with_uncertain_ownership_fails_closed(tmp_path):
    file = legacy(tmp_path)
    file.parent.mkdir(parents=True)
    file.write_bytes(b'unknown owner skill')
    with pytest.raises(ValueError, match='ownership is uncertain'):
        installer.plan(tmp_path)
    assert file.read_bytes() == b'unknown owner skill'
    assert not official(tmp_path).exists()
    assert not rule(tmp_path).exists()


def test_source_identical_legacy_skill_is_migrated_without_parallel_copy(tmp_path):
    file = legacy(tmp_path)
    file.parent.mkdir(parents=True)
    file.write_bytes((ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes())
    entries, report = installer.plan(tmp_path)
    assert report['files'][0]['action'] == 'delete'
    assert report['files'][0]['ownership'] == 'source-identical'
    readback = installer.apply(entries)
    assert not file.exists()
    assert not file.parent.exists()
    assert official(tmp_path).is_file()
    assert rule(tmp_path).is_file()
    assert all(item['verified'] for item in readback)


def test_hash_bound_legacy_migration_deletes_only_exact_bytes(tmp_path):
    file = legacy(tmp_path)
    file.parent.mkdir(parents=True)
    file.write_bytes(b'previous Accelerate payload\n')
    old_hash = installer.digest(file.read_bytes())
    preview = cli(tmp_path, '--migrate-legacy-skill-sha256', old_hash)
    assert preview.returncode == 0, preview.stderr
    plan = json.loads(preview.stdout)
    assert plan['files'][0]['ownership'] == 'explicit-sha256'
    result = cli(tmp_path, '--migrate-legacy-skill-sha256', old_hash, '--apply',
                 '--expect-plan-sha256', plan['plan_sha256'])
    assert result.returncode == 0, result.stderr
    assert not file.exists()
    assert official(tmp_path).is_file()
    assert rule(tmp_path).is_file()
    assert len([p for p in tmp_path.rglob('SKILL.md')]) == 1


@pytest.mark.parametrize('point', [
    'after_migration_move',
    'after_official_publish',
    'before_rule_write',
    'after_rule_write',
    'before_readback',
    'after_readback',
    'before_cleanup',
    'after_cleanup',
])
def test_sigkill_keeps_a_discovered_copy_and_hash_bound_rerun_resumes(tmp_path, point):
    old = legacy(tmp_path)
    old.parent.mkdir(parents=True)
    old.write_bytes(b'previous authorized Accelerate payload\n')
    old_hash = installer.digest(old.read_bytes())
    result = interrupted_apply(tmp_path, old_hash, point, 'SIGKILL')
    assert result.returncode == -signal.SIGKILL
    assert old.is_file() or official(tmp_path).is_file()
    assert not (old.is_file() and official(tmp_path).is_file())
    if point == 'after_migration_move':
        assert official(tmp_path).read_bytes() == b'previous authorized Accelerate payload\n'
        assert cli(tmp_path).returncode != 0

    if point == 'after_migration_move':
        resume_args = ('--migrate-legacy-skill-sha256', old_hash)
    elif point == 'after_cleanup':
        assert cli(tmp_path, '--migrate-legacy-skill-sha256', old_hash).returncode != 0
        resume_args = ()
    else:
        assert cli(tmp_path, '--migrate-legacy-skill-sha256', old_hash).returncode != 0
        wrong_cleanup = cli(tmp_path, '--cleanup-empty-legacy-dir-sha256', '0' * 64)
        assert wrong_cleanup.returncode != 0
        assert old.parent.is_dir()
        resume_args = ('--cleanup-empty-legacy-dir-sha256',
                       installer.digest((ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes()))
    preview = cli(tmp_path, *resume_args)
    assert preview.returncode == 0, preview.stderr
    plan = json.loads(preview.stdout)
    resumed = cli(tmp_path, *resume_args, '--apply',
                  '--expect-plan-sha256', plan['plan_sha256'])
    assert resumed.returncode == 0, resumed.stderr
    assert not old.exists()
    assert not old.parent.exists()
    assert official(tmp_path).read_bytes() == (ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes()
    assert rule(tmp_path).is_file()
    assert len([path for path in tmp_path.rglob('SKILL.md')]) == 1


def test_sigkill_owned_temp_is_verified_removed_and_migration_resumes(tmp_path):
    old = legacy(tmp_path)
    old.parent.mkdir(parents=True)
    old.write_bytes(b'previous authorized Accelerate payload\n')
    old_hash = installer.digest(old.read_bytes())
    result = interrupted_apply(tmp_path, old_hash, 'after_temp_fsync', 'SIGKILL')
    assert result.returncode == -signal.SIGKILL
    assert official(tmp_path).read_bytes() == b'previous authorized Accelerate payload\n'
    temps = list(official(tmp_path).parent.glob('.accelerate-write-*'))
    assert len(temps) == 1

    preview = cli(tmp_path, '--migrate-legacy-skill-sha256', old_hash)
    assert preview.returncode == 0, preview.stderr
    plan = json.loads(preview.stdout)
    temp_rows = [item for item in plan['files'] if item['role'] == 'orphan-temp']
    assert len(temp_rows) == 1
    assert temp_rows[0]['ownership'] == 'verified-temp-fingerprint'
    resumed = cli(tmp_path, '--migrate-legacy-skill-sha256', old_hash, '--apply',
                  '--expect-plan-sha256', plan['plan_sha256'])
    assert resumed.returncode == 0, resumed.stderr
    assert not list(tmp_path.rglob('.accelerate-write-*'))
    assert official(tmp_path).read_bytes() == (ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes()


@pytest.mark.parametrize('name', [
    '.accelerate-write-unknown',
    '.accelerate-write-v2-SKILL.md-' + ('0' * 64) + '-forged.tmp',
])
def test_unknown_or_unverifiable_temp_fails_closed_without_removal(tmp_path, name):
    directory = official(tmp_path).parent
    directory.mkdir(parents=True)
    candidate = directory / name
    candidate.write_bytes(b'unknown temporary bytes')
    preview = cli(tmp_path)
    assert preview.returncode != 0
    assert 'unverifiable installer temporary file' in preview.stderr
    assert candidate.read_bytes() == b'unknown temporary bytes'


def test_matching_temp_name_and_bytes_with_wrong_mode_fails_closed(tmp_path):
    payload = (ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes()
    directory = official(tmp_path).parent
    directory.mkdir(parents=True)
    candidate = directory / (
        f'.accelerate-write-v2-SKILL.md-{installer.digest(payload)}-owned.tmp')
    candidate.write_bytes(payload)
    candidate.chmod(0o600)
    preview = cli(tmp_path)
    assert preview.returncode != 0
    assert 'unverifiable installer temporary file' in preview.stderr
    assert candidate.read_bytes() == payload
    assert candidate.stat().st_mode & 0o777 == 0o600


def test_preexisting_empty_legacy_directory_is_not_removed_without_skill_mutation(tmp_path):
    directory = legacy(tmp_path).parent
    directory.mkdir(parents=True)
    preview = cli(tmp_path)
    plan = json.loads(preview.stdout)
    applied = cli(tmp_path, '--apply', '--expect-plan-sha256', plan['plan_sha256'])
    assert applied.returncode == 0, applied.stderr
    assert directory.is_dir()
    assert not list(directory.iterdir())


@pytest.mark.parametrize('migration_hash', ['0' * 64, 'current'])
def test_current_official_rejects_migration_hash_and_requests_flagless_idempotence(tmp_path,
                                                                                  migration_hash):
    file = official(tmp_path)
    file.parent.mkdir(parents=True)
    file.write_bytes((ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes())
    if migration_hash == 'current':
        migration_hash = installer.digest(file.read_bytes())
    rejected = cli(tmp_path, '--migrate-legacy-skill-sha256', migration_hash)
    assert rejected.returncode != 0
    assert 'already current' in rejected.stderr
    assert 'without --migrate-legacy-skill-sha256' in rejected.stderr
    accepted = cli(tmp_path)
    assert accepted.returncode == 0, accepted.stderr
    unnecessary_cleanup = cli(
        tmp_path, '--cleanup-empty-legacy-dir-sha256', installer.digest(file.read_bytes()))
    assert unnecessary_cleanup.returncode != 0
    assert 'exact empty legacy directory' in unnecessary_cleanup.stderr


def test_current_official_with_legacy_copy_requires_correct_migration_hash(tmp_path):
    current = (ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes()
    official(tmp_path).parent.mkdir(parents=True)
    official(tmp_path).write_bytes(current)
    old = legacy(tmp_path)
    old.parent.mkdir(parents=True)
    old.write_bytes(b'previous owned payload\n')
    old_hash = installer.digest(old.read_bytes())

    wrong = cli(tmp_path, '--migrate-legacy-skill-sha256', '0' * 64)
    assert wrong.returncode != 0
    assert old.read_bytes() == b'previous owned payload\n'
    assert official(tmp_path).read_bytes() == current

    preview = cli(tmp_path, '--migrate-legacy-skill-sha256', old_hash)
    assert preview.returncode == 0, preview.stderr
    plan = json.loads(preview.stdout)
    applied = cli(tmp_path, '--migrate-legacy-skill-sha256', old_hash, '--apply',
                  '--expect-plan-sha256', plan['plan_sha256'])
    assert applied.returncode == 0, applied.stderr
    assert not old.exists()
    assert not old.parent.exists()
    assert official(tmp_path).read_bytes() == current


def test_interrupt_before_atomic_move_is_compensated_from_preregistered_intent(tmp_path, monkeypatch):
    old = legacy(tmp_path)
    old.parent.mkdir(parents=True)
    old.write_bytes((ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes())
    entries, _ = installer.plan(tmp_path)
    original_replace = installer.os.replace

    def interrupt_move(source, target):
        if Path(source) == old and Path(target) == official(tmp_path):
            raise KeyboardInterrupt()
        original_replace(source, target)

    monkeypatch.setattr(installer.os, 'replace', interrupt_move)
    with pytest.raises(KeyboardInterrupt):
        installer.apply(entries)
    assert old.is_file()
    assert not official(tmp_path).exists()
    assert not rule(tmp_path).exists()


@pytest.mark.parametrize(('point', 'interruption'), [
    ('after_migration_move', 'keyboard'),
    ('after_rule_write', 'keyboard'),
    ('after_official_publish', 'SIGTERM'),
    ('before_cleanup', 'SIGTERM'),
])
def test_compensatable_interruptions_restore_the_original_single_copy(tmp_path, point, interruption):
    old = legacy(tmp_path)
    old.parent.mkdir(parents=True)
    old.write_bytes(b'previous authorized Accelerate payload\n')
    old_hash = installer.digest(old.read_bytes())
    result = interrupted_apply(tmp_path, old_hash, point, interruption)
    assert result.returncode != 0
    assert old.read_bytes() == b'previous authorized Accelerate payload\n'
    assert not official(tmp_path).exists()
    assert not rule(tmp_path).exists()
    assert len([path for path in tmp_path.rglob('SKILL.md')]) == 1


@pytest.mark.parametrize('old_hash', ['bad', 'F' * 64, '0' * 64])
def test_legacy_migration_rejects_invalid_or_mismatched_hash(tmp_path, old_hash):
    file = legacy(tmp_path)
    file.parent.mkdir(parents=True)
    file.write_bytes(b'Owner skill')
    assert cli(tmp_path, '--migrate-legacy-skill-sha256', old_hash).returncode != 0
    assert file.read_bytes() == b'Owner skill'
    assert not official(tmp_path).exists()
    assert not rule(tmp_path).exists()


def test_legacy_migration_hash_requires_existing_target(tmp_path):
    old_hash = installer.digest(b'Old skill')
    assert cli(tmp_path, '--migrate-legacy-skill-sha256', old_hash).returncode != 0


def test_supplied_legacy_hash_must_match_even_when_payload_is_source_identical(tmp_path):
    file = legacy(tmp_path)
    file.parent.mkdir(parents=True)
    file.write_bytes((ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes())
    with pytest.raises(ValueError, match='does not match migration SHA256'):
        installer.plan(tmp_path, migrate_legacy_skill_sha256='0' * 64)


def test_modified_managed_rule_requires_hash_bound_replacement(tmp_path):
    file = rule(tmp_path)
    file.parent.mkdir()
    managed = installer.START + b'\nold managed content\n' + installer.END
    file.write_bytes(b'Owner before\n' + managed + b'\nOwner after\n')
    with pytest.raises(ValueError, match='exact replacement SHA256'):
        installer.plan(tmp_path)
    entries, report = installer.plan(tmp_path, replace_rule_sha256=installer.digest(managed))
    installer.apply(entries)
    assert file.read_bytes().startswith(b'Owner before\n' + installer.START)
    assert file.read_bytes().endswith(b'\nOwner after\n')
    assert report['replace_rule_sha256'] == installer.digest(managed)


def test_rule_replacement_hash_requires_the_exact_existing_managed_block(tmp_path):
    with pytest.raises(ValueError, match='is missing'):
        installer.plan(tmp_path, replace_rule_sha256='0' * 64)
    file = rule(tmp_path)
    file.parent.mkdir()
    managed = installer.START + b'\nold\n' + installer.END
    file.write_bytes(managed)
    with pytest.raises(ValueError, match='does not match'):
        installer.plan(tmp_path, replace_rule_sha256='0' * 64)


@pytest.mark.parametrize('content', [installer.START, installer.END, installer.END + installer.START,
    installer.DISABLED + b'\n' + installer.DISABLED + b'\n', b'\xff', b'x' * 24000])
def test_malformed_or_oversized_rule_is_not_overwritten(tmp_path, content):
    file = rule(tmp_path)
    file.parent.mkdir()
    file.write_bytes(content)
    with pytest.raises(ValueError):
        installer.plan(tmp_path)
    assert file.read_bytes() == content
    assert not official(tmp_path).exists()


def test_symlink_ancestor_and_hardlinked_file_are_refused(tmp_path):
    outside = tmp_path / 'outside'
    outside.mkdir()
    home = tmp_path / 'home'
    home.mkdir()
    (home / '.gemini').symlink_to(outside, target_is_directory=True)
    with pytest.raises(ValueError, match='symlink'):
        installer.plan(home)
    (home / '.gemini').unlink()
    (home / '.gemini').mkdir()
    source = outside / 'policy'
    source.write_text('Owner\n')
    rule(home).hardlink_to(source)
    with pytest.raises(ValueError, match='regular unlinked'):
        installer.plan(home)
    assert source.read_text() == 'Owner\n'


def test_failed_rule_write_restores_deleted_legacy_and_removes_new_official(tmp_path, monkeypatch):
    old = legacy(tmp_path)
    old.parent.mkdir(parents=True)
    old.write_bytes((ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes())
    rule(tmp_path).parent.mkdir(exist_ok=True)
    rule(tmp_path).write_text('Owner\n')
    entries, _ = installer.plan(tmp_path)
    original = installer.atomic_write

    def fail_rule(target, data, mode):
        if target == rule(tmp_path):
            raise OSError('simulated rule write error')
        original(target, data, mode)

    monkeypatch.setattr(installer, 'atomic_write', fail_rule)
    with pytest.raises(OSError, match='simulated'):
        installer.apply(entries)
    assert old.read_bytes() == (ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes()
    assert not official(tmp_path).exists()
    assert rule(tmp_path).read_text() == 'Owner\n'


def test_changed_target_after_plan_is_not_replaced(tmp_path):
    entries, _ = installer.plan(tmp_path)
    target = official(tmp_path)
    target.parent.mkdir(parents=True)
    target.write_text('User content')
    with pytest.raises(ValueError, match='changed since preview'):
        installer.apply(entries)
    assert target.read_text() == 'User content'


def test_failed_atomic_replace_removes_temporary_and_keeps_owner_file(tmp_path, monkeypatch):
    file = tmp_path / 'GEMINI.md'
    file.write_bytes(b'Owner rules\n')

    def fail_replace(*args):
        raise OSError('replace failed')

    monkeypatch.setattr(installer.os, 'replace', fail_replace)
    with pytest.raises(OSError, match='replace failed'):
        installer.atomic_write(file, b'changed', 0o600)
    assert file.read_bytes() == b'Owner rules\n'
    assert list(tmp_path.iterdir()) == [file]


def test_explicit_official_upgrade_binds_old_bytes_and_preserves_mode(tmp_path):
    skill = official(tmp_path)
    skill.parent.mkdir(parents=True)
    skill.write_bytes(b'Previous reviewed skill\n')
    skill.chmod(0o600)
    old_hash = installer.digest(skill.read_bytes())
    preview = cli(tmp_path, '--replace-skill-sha256', old_hash)
    assert preview.returncode == 0, preview.stderr
    token = json.loads(preview.stdout)['plan_sha256']
    result = cli(tmp_path, '--replace-skill-sha256', old_hash, '--apply',
                 '--expect-plan-sha256', token)
    assert result.returncode == 0, result.stderr
    assert skill.read_bytes() == (ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes()
    assert skill.stat().st_mode & 0o777 == 0o600
    assert rule(tmp_path).is_file()
    assert not list(tmp_path.rglob('*.bak'))
    assert not list(tmp_path.rglob('.accelerate-write-*'))


def test_official_upgrade_requires_existing_target_and_stale_preview_cannot_write(tmp_path):
    old_hash = installer.digest(b'Old skill')
    assert cli(tmp_path, '--replace-skill-sha256', old_hash).returncode != 0
    skill = official(tmp_path)
    skill.parent.mkdir(parents=True)
    skill.write_bytes(b'Old skill')
    result = cli(tmp_path, '--replace-skill-sha256', old_hash)
    token = json.loads(result.stdout)['plan_sha256']
    skill.write_bytes(b'Concurrent owner edit')
    assert cli(tmp_path, '--replace-skill-sha256', old_hash, '--apply',
               '--expect-plan-sha256', token).returncode != 0
    assert skill.read_bytes() == b'Concurrent owner edit'
