#!/usr/bin/env python3
"""Install repository skills using a cooperative recoverable batch.

The protocol deliberately makes no claim of ACID semantics or power-loss proof.
Each filesystem step is rename-atomic, journaled before the step, and recovered
by the next invocation while holding the same cooperative lock.
"""
from __future__ import annotations

import argparse
import fcntl
import hashlib
import json
import os
import re
import shutil
import sys
import tempfile
import tomllib
import uuid
from datetime import UTC, datetime
from pathlib import Path
from typing import Any, NoReturn

REPO = Path(__file__).resolve().parents[1]
REGISTRY = REPO / "adapters/runtime/operational-skill-projections.toml"
MARKER = ".accelerate-operational-skill.json"
MANAGED_BY = "accelerate"
MANAGED_SCHEMA = 1
JOURNAL_SCHEMA = 2
VALID_NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
VALID_RUN = re.compile(r"^\d{8}T\d{6}Z-[a-z0-9-]+$")


def _is_cache(p: Path, root: Path) -> bool:
    if p.is_symlink(): return False
    parts = p.relative_to(root).parts
    return "__pycache__" in parts or (p.is_file() and p.name.endswith((".pyc", ".pyo")))


def assert_regular_tree(path: Path) -> None:
    if path.is_symlink() or not path.is_dir(): raise ValueError(f"unsafe source tree: {path}")
    marker = path / "SKILL.md"
    if marker.is_symlink() or not marker.is_file(): raise ValueError(f"unsafe source tree lacks regular SKILL.md: {path}")
    for p in path.rglob("*"):
        if _is_cache(p, path): continue
        if p.is_symlink() or not (p.is_file() or p.is_dir()): raise ValueError(f"unsafe source entry: {p}")
        st = p.stat()
        if p.is_file() and st.st_nlink != 1: raise ValueError(f"unsafe hardlink: {p}")


def tree_digest(path: Path) -> str:
    assert_regular_tree(path)
    h = hashlib.sha256()
    for p in sorted(path.rglob("*")):
        if _is_cache(p, path): continue
        rel = p.relative_to(path).as_posix()
        if rel == MARKER: continue
        h.update(rel.encode()); h.update(b"\0")
        if p.is_file(): h.update(p.read_bytes()); h.update(b"\0")
    return h.hexdigest()


def _safe_relative(value: str, label: str) -> Path:
    p = Path(value)
    if not isinstance(value, str) or p.is_absolute() or not p.parts or ".." in p.parts:
        raise ValueError(f"invalid {label} path: {value}")
    return p


def _safe_repo_source(repo_root: Path, relative: Path) -> Path:
    root = repo_root.resolve()
    candidate = repo_root / relative
    current = repo_root
    for part in relative.parts:
        current /= part
        if _lexists(current) and current.is_symlink():
            raise ValueError(f"source path contains symlink: {current}")
    resolved = candidate.resolve()
    try: resolved.relative_to(root)
    except ValueError as error: raise ValueError(f"source path escapes repository root: {candidate}") from error
    return candidate


def load_registry(registry_path: Path = REGISTRY, repo_root: Path = REPO) -> tuple[dict[str, Path], dict[str, Path]]:
    with registry_path.open("rb") as f: payload = tomllib.load(f)
    if set(payload) != {"schema_version", "managed_by", "marker", "skills", "targets"} or payload["schema_version"] != 1 or payload["managed_by"] != MANAGED_BY or payload["marker"] != MARKER:
        raise ValueError("projection registry schema drift")
    skills: dict[str, Path] = {}; targets: dict[str, Path] = {}
    for item in payload["skills"]:
        if set(item) != {"name", "source"} or not isinstance(item["name"], str) or not VALID_NAME.fullmatch(item["name"]) or item["name"] in skills:
            raise ValueError("invalid or duplicate skill name")
        skills[item["name"]] = _safe_repo_source(repo_root, _safe_relative(item["source"], "source"))
    for item in payload["targets"]:
        if set(item) != {"runtime", "home_suffix"} or not isinstance(item["runtime"], str) or not VALID_NAME.fullmatch(item["runtime"]) or item["runtime"] in targets:
            raise ValueError("invalid or duplicate runtime")
        targets[item["runtime"]] = _safe_relative(item["home_suffix"], "target")
    if not skills or not ({"opencode", "agents", "hermes"} <= set(targets) <= {"opencode", "agents", "codex", "hermes", "claude"}): raise ValueError("projection denominator drift")
    return skills, targets


def _marker(name: str, runtime: str, digest: str) -> str:
    return json.dumps({"managed_by": MANAGED_BY, "managed_schema": MANAGED_SCHEMA, "name": name, "runtime": runtime, "source_digest": digest}, indent=2, sort_keys=True) + "\n"


def _managed_payload(path: Path, name: str, runtime: str) -> dict[str, Any] | None:
    m = path / MARKER
    if m.is_symlink() or not m.is_file() or m.stat().st_nlink != 1: return None
    try: p = json.loads(m.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError): return None
    if set(p) != {"managed_by", "managed_schema", "name", "runtime", "source_digest"} or p.get("managed_by") != MANAGED_BY or p.get("managed_schema") != MANAGED_SCHEMA or p.get("name") != name or p.get("runtime") not in {runtime, "hermes"} or not isinstance(p.get("source_digest"), str): return None
    return p


def _lexists(path: Path) -> bool:
    return os.path.lexists(path)


def _assert_safe_root(home: Path, target: Path, *, create: bool) -> None:
    if home.is_symlink() or not home.is_dir(): raise ValueError(f"home must be a regular directory: {home}")
    rel = target.relative_to(home); cur = home
    for part in rel.parts:
        cur /= part
        if cur.exists() and (cur.is_symlink() or not cur.is_dir()): raise ValueError(f"unsafe target path: {cur}")
    if create: target.mkdir(mode=0o700, parents=True, exist_ok=True)
    if target.exists() and (target.is_symlink() or not target.is_dir()): raise ValueError(f"target root is not a directory: {target}")
    if target.exists(): os.chmod(target, 0o700)


def _fsync_dir(path: Path) -> None:
    try:
        fd = os.open(path, os.O_RDONLY | getattr(os, "O_DIRECTORY", 0)); os.fsync(fd); os.close(fd)
    except OSError: pass


def _test_fault(boundary: str, root: Path) -> None:
    """Crash hook used only by subprocess tests in an explicitly allowed root."""
    if os.environ.get("ACCELERATE_TEST_MODE") != "1":
        return
    requested = os.environ.get("ACCELERATE_TEST_FAULT_BOUNDARY")
    allow = os.environ.get("ACCELERATE_TEST_ALLOW_ROOT")
    if requested != boundary or not allow:
        return
    try:
        allowed = Path(allow).resolve()
        observed = root.resolve()
        observed.relative_to(allowed)
    except (OSError, ValueError):
        return
    event = os.environ.get("ACCELERATE_TEST_FAULT_EVENT")
    if event:
        Path(event).write_text(boundary, encoding="utf-8")
    os.kill(os.getpid(), 9)


def _atomic_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(mode=0o700, parents=True, exist_ok=True); os.chmod(path.parent, 0o700)
    fd = os.open(path.parent / ("." + path.name + ".tmp-" + uuid.uuid4().hex), os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600)
    tmp = Path(os.readlink(f"/proc/self/fd/{fd}"))
    try:
        os.write(fd, (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()); os.fsync(fd); os.close(fd); os.replace(tmp, path); os.chmod(path, 0o600); _fsync_dir(path.parent)
    except Exception:
        try: os.close(fd)
        except OSError: pass
        tmp.unlink(missing_ok=True); raise


def _validate_state_dir(path: Path, *, missing_ok: bool = False) -> bool:
    if not _lexists(path):
        if missing_ok: return False
        raise ValueError(f"missing operational-skills state directory: {path.name}")
    st = path.lstat()
    if path.is_symlink() or not path.is_dir() or st.st_uid != os.getuid() or st.st_mode & 0o777 != 0o700:
        raise ValueError(f"unsafe operational-skills state directory: {path.name}")
    return True


def _read_private_json(path: Path) -> dict[str, Any]:
    st = path.lstat()
    if path.is_symlink() or not path.is_file() or st.st_uid != os.getuid() or st.st_mode & 0o777 != 0o600:
        raise ValueError(f"unsafe metadata file: {path.name}")
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict): raise ValueError(f"metadata file is not an object: {path.name}")
    return value


class _Lock:
    def __init__(self, path: Path): self.path = path; self.fd: int | None = None
    def __enter__(self):
        self.path.parent.mkdir(mode=0o700, parents=True, exist_ok=True); os.chmod(self.path.parent, 0o700)
        if self.path.exists():
            st = self.path.lstat()
            if not self.path.is_file() or self.path.is_symlink() or st.st_uid != os.getuid() or st.st_mode & 0o777 != 0o600:
                raise ValueError("unsafe operational skills lock")
        self.fd = os.open(self.path, os.O_RDWR | os.O_CREAT | os.O_NOFOLLOW, 0o600)
        try:
            fcntl.flock(self.fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            os.close(self.fd); self.fd = None
            raise ValueError("operational skills lock is held")
        os.fchmod(self.fd, 0o600); return self
    def __exit__(self, *_):
        if self.fd is not None:
            fcntl.flock(self.fd, fcntl.LOCK_UN); os.close(self.fd)
        _fsync_dir(self.path.parent)


def _stage(source: Path, parent: Path, name: str, runtime: str, digest: str, marker_bytes: bytes | None = None) -> Path:
    assert_regular_tree(source); root = Path(tempfile.mkdtemp(prefix=f".{name}-candidate-", dir=parent)); stage = root / name
    try:
        shutil.copytree(source, stage, ignore=shutil.ignore_patterns("__pycache__", "*.pyc", "*.pyo")); (stage / MARKER).write_bytes(marker_bytes if marker_bytes is not None else _marker(name, runtime, digest).encode()); os.chmod(stage, 0o700)
        if tree_digest(stage) != digest: raise ValueError(f"candidate digest mismatch for {name}")
        return stage
    except Exception: shutil.rmtree(root, ignore_errors=True); raise


def _replace(destination: Path, staged: Path) -> None:
    previous = staged.parent / (destination.name + ".displaced"); moved = False
    if destination.exists() or destination.is_symlink():
        os.replace(destination, previous); moved = True; _fsync_dir(destination.parent)
        _test_fault("after_target_displaced", staged.parent)
    try:
        os.replace(staged, destination); _fsync_dir(destination.parent)
        _test_fault("after_candidate_installed", staged.parent)
    except Exception:
        if moved and not destination.exists(): os.replace(previous, destination); _fsync_dir(destination.parent)
        raise
    if previous.exists():
        _test_fault("before_cleanup", staged.parent)
        shutil.rmtree(previous); _fsync_dir(destination.parent)
    # Candidate parents are disposable; the run directory itself is retained
    # as the terminal backup/manifest record.
    if staged.parent.name.startswith(".") or "candidate-" in staged.parent.name:
        shutil.rmtree(staged.parent, ignore_errors=True)


def _paths(home: Path, backup_root: Path | None) -> tuple[Path, Path, Path]:
    control = home / ".local/state/accelerate/operational-skills"; backup = backup_root or home / ".local/state/accelerate/backups/operational-skills"
    for root in (control, backup):
        try: relative = root.relative_to(home)
        except ValueError as error: raise ValueError("operational-skills state root escapes home") from error
        current = home
        for part in relative.parts:
            current /= part
            if _lexists(current) and (current.is_symlink() or not current.is_dir()): raise ValueError("unsafe operational-skills state root containment")
        root.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
        if _lexists(root) and (root.is_symlink() or not root.is_dir()): raise ValueError("unsafe operational-skills state root")
        root.mkdir(mode=0o700, exist_ok=True)
        st = root.lstat()
        if st.st_uid != os.getuid() or st.st_mode & 0o777 != 0o700: raise ValueError("unsafe operational-skills state root metadata")
    return control, backup, control / "active.json"


def _plan_digest(runtime: str, run: str, goal: str, entries: list[dict[str, Any]]) -> str:
    plan = {"runtime": runtime, "run_id": run, "goal": goal, "entries": entries}
    return hashlib.sha256(json.dumps(plan, sort_keys=True, separators=(",", ":")).encode()).hexdigest()


def _validate_journal(journal: dict[str, Any], runtime: str, run: str) -> None:
    required = {"schema_version", "runtime", "run_id", "goal", "state", "plan_digest", "entries"}
    if set(journal) - required - {"intent"} or set(journal) < required or journal["schema_version"] != JOURNAL_SCHEMA or journal["runtime"] != runtime or journal["run_id"] != run or journal["goal"] not in {"apply", "rollback"} or journal["state"] not in {"prepared", "applied", "rolled-back"}:
        raise ValueError("invalid current operational-skills journal schema")
    entries = journal["entries"]
    if not isinstance(entries, list) or not entries or any(not isinstance(e, dict) or set(e) != {"name", "previous", "previous_digest", "previous_marker_sha256", "installed_digest", "installed_marker_sha256"} for e in entries):
        raise ValueError("invalid current operational-skills journal entries")
    names = [e["name"] for e in entries]
    if len(names) != len(set(names)) or any(not isinstance(n, str) or not VALID_NAME.fullmatch(n) for n in names):
        raise ValueError("invalid current operational-skills entry identity")
    if journal["plan_digest"] != _plan_digest(runtime, run, journal["goal"], entries):
        raise ValueError("operational-skills plan digest mismatch")


def _validate_candidate(candidate: Path, entry: dict[str, Any], runtime: str, name: str) -> None:
    assert_regular_tree(candidate)
    if tree_digest(candidate) != entry["installed_digest"] or candidate.joinpath(MARKER).read_text(encoding="utf-8") != _marker(name, runtime, entry["installed_digest"]):
        raise ValueError(f"candidate integrity mismatch for {name}")


def _target_digest_state(dest: Path, entry: dict[str, Any], runtime: str) -> str | None:
    if not _lexists(dest): return None
    st = dest.lstat()
    if dest.is_symlink() or not dest.is_dir() or st.st_uid != os.getuid() or st.st_mode & 0o777 != 0o700: raise ValueError(f"recovery target type/ownership/mode is unsafe for {dest.name}")
    payload = _managed_payload(dest, dest.name, runtime)
    digest = tree_digest(dest)
    if payload is None: raise ValueError(f"recovery target marker is unsafe for {dest.name}")
    if payload["source_digest"] == entry["installed_digest"] and digest == entry["installed_digest"] and hashlib.sha256((dest / MARKER).read_bytes()).hexdigest() == entry["installed_marker_sha256"]: return "installed"
    if entry["previous"] and payload["source_digest"] == entry["previous_digest"] and digest == entry["previous_digest"] and hashlib.sha256((dest / MARKER).read_bytes()).hexdigest() == entry["previous_marker_sha256"]: return "previous"
    raise ValueError(f"recovery target state is ambiguous for {dest.name}")


def _validate_manifest(manifest: dict[str, Any], journal: dict[str, Any], runtime: str, run: str) -> None:
    if set(manifest) != {"schema_version", "runtime", "run_id", "state", "plan_digest", "entries"} or manifest["schema_version"] != JOURNAL_SCHEMA or manifest["runtime"] != runtime or manifest["run_id"] != run or manifest["state"] not in {"prepared", "applied"} or manifest["plan_digest"] != _plan_digest(runtime, run, "apply", manifest["entries"]) or manifest["entries"] != journal["entries"]:
        raise ValueError("operational-skills manifest mismatch")


def _validate_active(active: Path, run: str) -> None:
    st = active.lstat()
    if active.is_symlink() or not active.is_file() or st.st_uid != os.getuid() or st.st_mode & 0o777 != 0o600:
        raise ValueError("unsafe active operational-skills pointer")
    pointer = json.loads(active.read_text(encoding="utf-8"))
    if set(pointer) != {"schema_version", "run_id"} or pointer["schema_version"] != JOURNAL_SCHEMA or pointer["run_id"] != run or not VALID_RUN.fullmatch(run):
        raise ValueError("invalid active operational-skills pointer")


def _validate_terminal(journal: dict[str, Any], target_root: Path, backup: Path, runtime: str, run: str) -> None:
    _validate_journal(journal, runtime, run)
    if journal["state"] not in {"applied", "rolled-back"}: raise ValueError("terminal journal is not terminal")
    for e in journal["entries"]:
        dest = target_root / e["name"]
        if journal["state"] == "applied":
            if not dest.is_dir() or dest.is_symlink() or tree_digest(dest) != e["installed_digest"] or _managed_payload(dest, e["name"], runtime) is None or hashlib.sha256((dest / MARKER).read_bytes()).hexdigest() != e["installed_marker_sha256"]: raise ValueError("terminal target verification failed")
        elif e["previous"]:
            old = backup / run / f"{e['name']}.previous"
            if not dest.is_dir() or dest.is_symlink() or tree_digest(dest) != e["previous_digest"] or hashlib.sha256((dest / MARKER).read_bytes()).hexdigest() != e["previous_marker_sha256"]: raise ValueError("terminal rollback marker verification failed")
            assert_regular_tree(old)
            if tree_digest(old) != e["previous_digest"] or hashlib.sha256((old / MARKER).read_bytes()).hexdigest() != e["previous_marker_sha256"]: raise ValueError("terminal backup verification failed")
        elif dest.exists(): raise ValueError("terminal first-install rollback verification failed")


def _recover(control: Path, backup: Path, target_root: Path, runtime: str) -> None:
    active = control / "active.json"
    if not _lexists(active): return
    if active.is_symlink(): raise ValueError("unsafe active operational-skills pointer")
    try:
        st = active.lstat()
        if active.is_symlink() or not active.is_file() or st.st_uid != os.getuid() or st.st_mode & 0o777 != 0o600: raise ValueError("unsafe active operational-skills pointer")
        pointer = _read_private_json(active); run = pointer["run_id"]; _validate_active(active, run)
        _validate_state_dir(control / "journals")
        _validate_state_dir(backup / run)
        journal = _read_private_json(control / "journals" / f"{run}.json")
    except Exception as e: raise ValueError(f"invalid active operational-skills journal: {e}")
    _validate_journal(journal, runtime, run)
    manifest_path = backup / run / "manifest.json"
    try: _validate_manifest(_read_private_json(manifest_path), journal, runtime, run)
    except (OSError, json.JSONDecodeError, KeyError, TypeError) as e: raise ValueError(f"invalid operational-skills manifest: {e}") from e
    goal = journal["goal"]
    for e in journal["entries"]:
        name = e["name"]; dest = target_root / name; candidate = backup / run / f"{name}.candidate"; old = backup / run / f"{name}.previous"
        target_state = _target_digest_state(dest, e, runtime)
        if _lexists(candidate):
            if candidate.is_symlink(): raise ValueError(f"candidate path is unsafe for {name}")
            _validate_candidate(candidate, e, runtime, name)
        if goal == "rollback":
            if e["previous"]:
                assert_regular_tree(old)
                if tree_digest(old) != e["previous_digest"] or (e.get("previous_marker_sha256") and hashlib.sha256((old / MARKER).read_bytes()).hexdigest() != e["previous_marker_sha256"]):
                    raise ValueError(f"recovery backup integrity mismatch for {name}")
            if e["previous"] and old.exists() and (not dest.exists() or tree_digest(dest) != e["previous_digest"]):
                staged = _stage(old, target_root, name, journal["runtime"], e["previous_digest"], (old / MARKER).read_bytes()); _replace(dest, staged)
            elif not e["previous"] and dest.exists(): shutil.rmtree(dest); _fsync_dir(target_root)
        elif _lexists(candidate):
            if dest.exists() and tree_digest(dest) not in {e["installed_digest"], e["previous_digest"]}:
                raise ValueError(f"recovery target state is ambiguous for {name}")
            if target_state != "installed": _replace(dest, candidate)
        elif target_state != "installed":
            raise ValueError(f"recovery target state is ambiguous for {name}")
    run_root = backup / run
    for residual in run_root.iterdir():
        if residual.name.endswith((".displaced", ".candidate")) or residual.name.startswith("."):
            if residual.is_dir() and not residual.is_symlink(): shutil.rmtree(residual)
            elif residual.is_file(): residual.unlink()
    journal["state"] = "rolled-back" if goal == "rollback" else "applied"
    _validate_terminal(journal, target_root, backup, runtime, run)
    _atomic_json(control / "journals" / f"{run}.json", journal); active.unlink(missing_ok=True); _fsync_dir(control)


def reconcile(runtime: str, *, home: Path, registry_path: Path = REGISTRY, repo_root: Path = REPO, apply: bool, backup_root: Path | None = None, run_id: str | None = None) -> dict[str, object]:
    skills, targets = load_registry(registry_path, repo_root)
    if runtime == "codex": raise ValueError("codex runtime uses the shared '.agents/skills' hub; please use '--runtime agents'")
    if runtime not in targets: raise ValueError(f"unknown runtime: {runtime}")
    target_root = home / targets[runtime]; _assert_safe_root(home, target_root, create=False)
    control, backups, active = _paths(home, backup_root)
    _validate_state_dir(control); _validate_state_dir(backups)
    with _Lock(control / "lock"):
        _recover(control, backups, target_root, runtime)
        expected = {n: tree_digest(s) for n, s in skills.items()}; drift = []
        for n, d in expected.items():
            dest = target_root / n
            if dest.exists() or dest.is_symlink():
                if dest.is_symlink() or not dest.is_dir(): raise ValueError(f"refusing unmanaged target: {dest}")
                marker = _managed_payload(dest, n, runtime)
                if marker is None: raise ValueError(f"refusing unmanaged skill: {dest}")
                if tree_digest(dest) != d or marker["source_digest"] != d: drift.append(n)
            else: drift.append(n)
        if not apply or not drift: return {"drift": len(drift), "changed": [], "rollback_id": None}
        _assert_safe_root(home, target_root, create=True); run_id = run_id or f"{datetime.now(UTC).strftime('%Y%m%dT%H%M%SZ')}-{runtime}"
        if not VALID_RUN.fullmatch(run_id): raise ValueError("invalid rollback id")
        run = backups / run_id
        if run.exists() or run.is_symlink(): raise ValueError(f"rollback id already exists: {run_id}")
        run.mkdir(mode=0o700); entries = []
        for n in drift:
            dest = target_root / n; previous = dest.exists(); prev = tree_digest(dest) if previous else None
            previous_marker_sha256 = None
            if previous:
                source_marker_sha256 = hashlib.sha256((dest / MARKER).read_bytes()).hexdigest()
                shutil.copytree(dest, run / f"{n}.previous", ignore=shutil.ignore_patterns("__pycache__", "*.pyc", "*.pyo")); os.chmod(run / f"{n}.previous", 0o700)
                if tree_digest(run / f"{n}.previous") != prev: raise ValueError(f"backup copy integrity failed for {n}")
                previous_marker_sha256 = hashlib.sha256((run / f"{n}.previous" / MARKER).read_bytes()).hexdigest()
                if previous_marker_sha256 != source_marker_sha256: raise ValueError(f"backup marker copy failed for {n}")
            else:
                source_marker_sha256 = None
            staged = _stage(skills[n], run, n, runtime, expected[n]); shutil.move(str(staged), str(run / f"{n}.candidate")); shutil.rmtree(staged.parent, ignore_errors=True)
            installed_marker_sha256 = hashlib.sha256(_marker(n, runtime, expected[n]).encode()).hexdigest()
            entries.append({"name": n, "previous": previous, "previous_digest": prev, "previous_marker_sha256": previous_marker_sha256, "installed_digest": expected[n], "installed_marker_sha256": installed_marker_sha256})
        plan_digest = _plan_digest(runtime, run_id, "apply", entries)
        journal = {"schema_version": JOURNAL_SCHEMA, "runtime": runtime, "run_id": run_id, "goal": "apply", "state": "prepared", "plan_digest": plan_digest, "entries": entries}
        manifest = {"schema_version": JOURNAL_SCHEMA, "runtime": runtime, "run_id": run_id, "state": "prepared", "plan_digest": plan_digest, "entries": entries}
        _atomic_json(run / "manifest.json", manifest)
        _atomic_json(control / "journals" / f"{run_id}.json", journal); _atomic_json(active, {"schema_version": JOURNAL_SCHEMA, "run_id": run_id}); changed = []
        try:
            for e in entries:
                if tree_digest(skills[e["name"]]) != e["installed_digest"]: raise ValueError(f"source changed during apply: {e['name']}")
                journal["intent"] = {"action": "switch", "name": e["name"]}; _atomic_json(control / "journals" / f"{run_id}.json", journal)
                _test_fault("after_swap_intent", run)
                _replace(target_root / e["name"], run / f"{e['name']}.candidate"); changed.append(e["name"])
                _test_fault("between_entries", run)
            journal["state"] = "applied"; _atomic_json(control / "journals" / f"{run_id}.json", journal); manifest["state"] = "applied"; _atomic_json(run / "manifest.json", manifest); active.unlink(missing_ok=True); _fsync_dir(control)
        except Exception: raise
        return {"drift": len(drift), "changed": changed, "rollback_id": run_id}


def rollback(runtime: str, run_id: str, *, home: Path, registry_path: Path = REGISTRY, repo_root: Path = REPO, backup_root: Path | None = None) -> None:
    if not VALID_RUN.fullmatch(run_id): raise ValueError("invalid rollback id")
    _skills, targets = load_registry(registry_path, repo_root)
    if runtime not in targets: raise ValueError(f"unknown runtime: {runtime}")
    target = home / targets[runtime]; _assert_safe_root(home, target, create=False); control, backups, active = _paths(home, backup_root); run = backups / run_id; mp = run / "manifest.json"
    # v1 is intentionally importable only when it is already a complete, exact record.
    jp = control / "journals" / f"{run_id}.json"
    with _Lock(control / "lock"):
        _validate_state_dir(control / "journals")
        if not _validate_state_dir(run, missing_ok=True): raise ValueError("rollback record is missing or unsafe")
        _recover(control, backups, target, runtime)
        if _lexists(jp) and _read_private_json(jp).get("state") == "rolled-back":
            terminal = _read_private_json(jp); _validate_manifest(_read_private_json(mp), {**terminal, "goal": "apply", "plan_digest": _plan_digest(runtime, run_id, "apply", terminal["entries"])}, runtime, run_id)
            _validate_terminal(terminal, target, backups, runtime, run_id); return
        if _lexists(jp):
            journal = _read_private_json(jp); _validate_journal(journal, runtime, run_id)
            _validate_manifest(_read_private_json(mp), journal, runtime, run_id)
            if journal["state"] == "rolled-back": return
            if journal["state"] != "applied" or journal["goal"] != "apply": raise ValueError("current journal is not rollback-applicable")
        else:
            if not mp.exists(): raise ValueError("rollback record is missing or unsafe")
            old = _read_private_json(mp)
            if old.get("schema_version") == 1: raise ValueError("v1 rollback records are unsupported")
            raise ValueError("rollback record is not an exact current journal")
        # Complete preflight: no destination is touched until every target and
        # every retained backup is still exactly the recorded payload.
        for e in journal["entries"]:
            n = e["name"]; d = target / n
            try: _target_digest_state(d, e, runtime)
            except ValueError as error: raise ValueError("refusing rollback after target drift") from error
            marker = _managed_payload(d, n, runtime)
            if marker is None or marker.get("source_digest") != e.get("installed_digest") or tree_digest(d) != e.get("installed_digest"):
                raise ValueError("refusing rollback after target drift")
            if e.get("previous"):
                b = run / f"{n}.previous"; assert_regular_tree(b)
                if tree_digest(b) != e.get("previous_digest"): raise ValueError("refusing rollback: backup digest mismatch")
                if e.get("previous_marker_sha256") and hashlib.sha256((b / MARKER).read_bytes()).hexdigest() != e["previous_marker_sha256"]: raise ValueError("refusing rollback: backup marker tampered")
        # Arm rollback only after the complete preflight above succeeds.
        journal["goal"] = "rollback"; journal["state"] = "prepared"; journal["plan_digest"] = _plan_digest(runtime, run_id, "rollback", journal["entries"])
        _atomic_json(jp, journal); _atomic_json(active, {"schema_version": JOURNAL_SCHEMA, "run_id": run_id}); changed: list[tuple[str, Path]] = []
        try:
            for e in reversed(journal["entries"]):
                n = e["name"]; d = target / n; journal["intent"] = {"action": "rollback", "name": n}; _atomic_json(jp, journal)
                saved = run / f".{n}.rollback-original"
                if d.exists(): shutil.copytree(d, saved, ignore=shutil.ignore_patterns("__pycache__", "*.pyc", "*.pyo"))
                if e.get("previous"):
                    b = run / f"{n}.previous"; _replace(d, _stage(b, run, n, runtime, e["previous_digest"], (b / MARKER).read_bytes()))
                elif d.exists(): shutil.rmtree(d); _fsync_dir(target)
                changed.append((n, saved))
        except Exception:
            for n, saved in reversed(changed):
                d = target / n
                if d.exists(): shutil.rmtree(d)
                if saved.exists(): os.replace(saved, d); _fsync_dir(target)
            raise
        journal["state"] = "rolled-back"; _validate_terminal(journal, target, backups, runtime, run_id); _atomic_json(jp, journal); active.unlink(missing_ok=True); _fsync_dir(control)


class OperationalSkillsArgumentParser(argparse.ArgumentParser):
    def error(self, message: str) -> NoReturn:
        if "codex" in message.lower(): self.exit(2, "FAIL: codex runtime uses the shared '.agents/skills' hub; please use '--runtime agents'.\n")
        super().error(message)


def main() -> int:
    p = OperationalSkillsArgumentParser(); p.add_argument("--runtime", required=True, choices=("opencode", "agents", "hermes", "claude")); p.add_argument("--home", type=Path, default=Path.home()); p.add_argument("--registry", type=Path, default=REGISTRY); p.add_argument("--repo-root", type=Path, default=REPO); p.add_argument("--backup-root", type=Path); p.add_argument("--apply", action="store_true"); p.add_argument("--rollback")
    a = p.parse_args()
    try:
        if a.rollback:
            if a.apply: raise ValueError("--rollback and --apply are mutually exclusive")
            rollback(a.runtime, a.rollback, home=a.home, registry_path=a.registry, repo_root=a.repo_root, backup_root=a.backup_root); print(f"PASS: operational skills rolled back: {a.rollback}"); return 0
        r = reconcile(a.runtime, home=a.home, registry_path=a.registry, repo_root=a.repo_root, apply=a.apply, backup_root=a.backup_root)
    except (OSError, ValueError, KeyError, tomllib.TOMLDecodeError, json.JSONDecodeError) as e: print(f"FAIL: {e}", file=sys.stderr); return 2
    if r["drift"] and not a.apply: print(f"DRIFT: {r['drift']} operational skill(s) differ for {a.runtime}"); return 1
    print(f"PASS: operational skills {'applied' if r['changed'] else 'current'} for {a.runtime}" + (f"; rollback_id={r['rollback_id']}" if r["changed"] else "")); return 0


if __name__ == "__main__": raise SystemExit(main())
