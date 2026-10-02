"""Native Agy installation in disposable fixture homes; never live user config."""
import importlib.util
import json
from pathlib import Path
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


def test_preview_creates_nothing_and_default_apply_installs_only_self_contained_skill(tmp_path):
    home = tmp_path / 'new-home'
    preview = cli(home)
    assert preview.returncode == 0, preview.stderr
    assert not home.exists()
    plan = json.loads(preview.stdout)
    assert len(plan['files']) == 1
    applied = cli(home, '--apply', '--expect-plan-sha256', plan['plan_sha256'])
    assert applied.returncode == 0, applied.stderr
    assert (home / '.gemini/config/skills/accelerate/SKILL.md').read_bytes() == (ROOT / 'global-runtime/accelerate/SKILL.md').read_bytes()
    assert not (home / '.gemini/GEMINI.md').exists()
    assert len([p for p in home.rglob('*') if p.is_file()]) == 1


def test_rule_is_opt_in_preserves_owner_bytes_mode_and_is_idempotent(tmp_path):
    file = tmp_path / '.gemini/GEMINI.md'
    file.parent.mkdir()
    prefix, suffix = b'# Owner\r\nNever install without approval.\r\n', b'\r\nEnd owner text.\r\n'
    file.write_bytes(prefix + installer.DISABLED + b'\r\n' + suffix)
    file.chmod(0o600)
    entries, report = installer.plan(tmp_path, True)
    installer.apply(entries)
    block = (ROOT / 'adapters/runtime/agy/entry-rule.md').read_bytes()
    assert file.read_bytes() == prefix + block + suffix
    assert file.stat().st_mode & 0o777 == 0o600
    entries2, report2 = installer.plan(tmp_path, True)
    assert all(item['action'] == 'unchanged' for item in report2['files'])
    installer.apply(entries2)
    assert file.read_bytes() == prefix + block + suffix
    assert not list(tmp_path.rglob('*.bak'))
    assert not list(tmp_path.rglob('.accelerate-write-*'))


def test_rule_without_sentinel_appends_without_rewriting_existing_policy(tmp_path):
    file = tmp_path / '.gemini/GEMINI.md'; file.parent.mkdir()
    file.write_bytes(b'Owner instruction without final newline')
    entries, _ = installer.plan(tmp_path, True)
    assert entries[1]['after'].startswith(file.read_bytes() + b'\n\n')
    assert file.read_bytes() == b'Owner instruction without final newline'


def test_apply_requires_exact_preview_including_rule_opt_in_and_current_owner_text(tmp_path):
    before = cli(tmp_path)
    token = json.loads(before.stdout)['plan_sha256']
    assert cli(tmp_path, '--apply').returncode != 0
    assert cli(tmp_path, '--apply', '--with-entry-rule', '--expect-plan-sha256', token).returncode != 0
    entries, report = installer.plan(tmp_path, True)
    file = tmp_path / '.gemini/GEMINI.md'; file.parent.mkdir(); file.write_text('New owner rule\n')
    assert cli(tmp_path, '--apply', '--with-entry-rule', '--expect-plan-sha256', report['plan_sha256']).returncode != 0
    assert not (tmp_path / '.gemini/config').exists()


@pytest.mark.parametrize('content', [b'user skill', b''])
def test_conflicting_skill_aborts_before_any_rule_write(tmp_path, content):
    file = tmp_path / '.gemini/config/skills/accelerate/SKILL.md'; file.parent.mkdir(parents=True)
    file.write_bytes(content)
    with pytest.raises(ValueError, match='existing skill differs'):
        installer.plan(tmp_path, True)
    assert not (tmp_path / '.gemini/GEMINI.md').exists()


@pytest.mark.parametrize('content', [installer.START, installer.END, installer.END + installer.START,
    installer.START + b'user changed block' + installer.END,
    installer.DISABLED + b'\n' + installer.DISABLED + b'\n', b'\xff', b'x' * 24000])
def test_malformed_modified_or_oversized_rule_is_not_overwritten(tmp_path, content):
    file = tmp_path / '.gemini/GEMINI.md'; file.parent.mkdir(); file.write_bytes(content)
    with pytest.raises(ValueError):
        installer.plan(tmp_path, True)
    assert file.read_bytes() == content
    assert not (tmp_path / '.gemini/config').exists()


def test_symlink_ancestor_and_hardlinked_file_are_refused(tmp_path):
    outside = tmp_path / 'outside'; outside.mkdir()
    home = tmp_path / 'home'; home.mkdir()
    (home / '.gemini').symlink_to(outside, target_is_directory=True)
    with pytest.raises(ValueError, match='symlink'):
        installer.plan(home, True)
    (home / '.gemini').unlink(); (home / '.gemini').mkdir()
    source = outside / 'policy'; source.write_text('Owner\n')
    (home / '.gemini/GEMINI.md').hardlink_to(source)
    with pytest.raises(ValueError, match='regular unlinked'):
        installer.plan(home, True)
    assert source.read_text() == 'Owner\n'


def test_apply_detects_changes_and_rolls_back_new_files_and_directories(tmp_path, monkeypatch):
    file = tmp_path / '.gemini/GEMINI.md'; file.parent.mkdir(); file.write_text('Owner\n')
    entries, _ = installer.plan(tmp_path, True)
    original = installer.atomic_write
    def fail_rule(target, data, mode):
        if target == file:
            raise OSError('simulated rule write error')
        original(target, data, mode)
    monkeypatch.setattr(installer, 'atomic_write', fail_rule)
    with pytest.raises(OSError, match='simulated'):
        installer.apply(entries)
    assert file.read_text() == 'Owner\n'
    assert list(file.parent.iterdir()) == [file]


def test_changed_target_after_plan_is_not_replaced(tmp_path):
    entries, _ = installer.plan(tmp_path, False)
    target = entries[0]['path']; target.parent.mkdir(parents=True); target.write_text('User content')
    with pytest.raises(ValueError, match='changed since preview'):
        installer.apply(entries)
    assert target.read_text() == 'User content'


def test_failed_atomic_replace_removes_temporary_and_keeps_owner_file(tmp_path, monkeypatch):
    file = tmp_path / 'GEMINI.md'; file.write_bytes(b'Owner rules\n')
    def fail_replace(*args):
        raise OSError('replace failed')
    monkeypatch.setattr(installer.os, 'replace', fail_replace)
    with pytest.raises(OSError, match='replace failed'):
        installer.atomic_write(file, b'changed', 0o600)
    assert file.read_bytes() == b'Owner rules\n'
    assert list(tmp_path.iterdir()) == [file]
