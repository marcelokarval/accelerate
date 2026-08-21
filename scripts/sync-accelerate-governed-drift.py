#!/usr/bin/env python3
"""Repair only the three audited Accelerate mirror drifts, transactionally."""
from __future__ import annotations

import argparse
import base64
import hashlib
import json
import os
import pwd
import shutil
import stat
import subprocess
import sys
import tempfile
import time
import uuid
from pathlib import Path, PurePosixPath
from typing import Any

REPO = Path(__file__).resolve().parents[1]
PIN = "a66659c82759cd5b5615c5524fdb5c071eb722d2"
CONTRACT = "accelerate-governed-drift-v1"
MARKER = ".accelerate-test-root"
PATHS = {
    "references/subagent-model.md": "references/subagent-model.md",
    "core/runtime-packets/delegation-dispatch-receipt.schema.json": "assets/delegation-dispatch-receipt.schema.json",
    "scripts/validate-delegation-dispatch-receipt.py": "scripts/validate-delegation-dispatch-receipt.py",
}


class Error(RuntimeError):
    pass


def die(message: str) -> None:
    raise Error(message)


def present(path: Path) -> bool:
    return path.exists() or path.is_symlink()


def fsync_dir(path: Path) -> None:
    descriptor = os.open(path, os.O_RDONLY | os.O_DIRECTORY)
    try:
        os.fsync(descriptor)
    finally:
        os.close(descriptor)


def safe_dir(path: Path, label: str) -> None:
    try:
        information = path.lstat()
    except FileNotFoundError:
        die(f"missing {label}: {path}")
    if stat.S_ISLNK(information.st_mode) or not stat.S_ISDIR(information.st_mode):
        die(f"unsafe {label}: {path}")


def safe_file(path: Path, label: str) -> os.stat_result:
    try:
        information = path.lstat()
    except FileNotFoundError:
        die(f"missing {label}: {path}")
    if stat.S_ISLNK(information.st_mode) or not stat.S_ISREG(information.st_mode) or information.st_nlink != 1:
        die(f"unsafe {label}: {path}")
    return information


def safe_ancestors(root: Path, path: Path) -> None:
    root = root.resolve(strict=True)
    try:
        relative = path.relative_to(root)
    except ValueError:
        die("target escapes canonical root")
    current = root
    safe_dir(current, "canonical root")
    for part in relative.parts[:-1]:
        current /= part
        safe_dir(current, "target ancestor")


def contained_directory(base: Path, directory: Path, *, create: bool) -> tuple[int, int]:
    """Create a backup/control ancestor only after every existing segment is safe.

    The returned device/inode binds the post-create directory used by this
    transaction, preventing a symlink replacement from silently retargeting it.
    """
    resolved_base = base.resolve(strict=True)
    try:
        relative = directory.relative_to(base)
    except ValueError:
        die("directory escapes canonical base")
    current = base
    safe_dir(current, "canonical mirror base")
    for part in relative.parts:
        current /= part
        if present(current):
            safe_dir(current, "backup/control ancestor")
        elif create:
            current.mkdir()
            safe_dir(current, "created backup/control ancestor")
        else:
            die(f"missing backup/control ancestor: {current}")
        try:
            current.resolve(strict=True).relative_to(resolved_base)
        except ValueError:
            die("backup/control ancestor escapes canonical base")
    information = current.lstat()
    return information.st_dev, information.st_ino


def xattrs(path: Path) -> dict[str, str]:
    try:
        return {name: base64.b64encode(os.getxattr(path, name, follow_symlinks=False)).decode() for name in sorted(os.listxattr(path, follow_symlinks=False))}
    except (AttributeError, NotImplementedError):
        return {}
    except OSError as error:
        die(f"cannot read xattrs for {path}: {error}")


def digest(path: Path) -> str:
    hasher = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            hasher.update(block)
    return hasher.hexdigest()


def record(path: Path) -> dict[str, Any]:
    information = safe_file(path, "file")
    return {"sha256": digest(path), "mode": stat.S_IMODE(information.st_mode), "uid": information.st_uid, "gid": information.st_gid, "xattrs": xattrs(path)}


def matches(path: Path, expected: dict[str, Any]) -> bool:
    return present(path) and record(path) == expected


def desired_metadata(source: dict[str, Any], before: dict[str, Any] | None) -> dict[str, Any]:
    """Git supplies bytes/mode; deployment supplies owner and strips xattrs."""
    owner = before or {"uid": os.geteuid(), "gid": os.getegid()}
    return {"sha256": source["sha256"], "mode": source["mode"], "uid": owner["uid"], "gid": owner["gid"], "xattrs": {}}


def copy_metadata(source: Path, destination: Path) -> None:
    information = safe_file(source, "source")
    os.chmod(destination, stat.S_IMODE(information.st_mode), follow_symlinks=False)
    try:
        os.chown(destination, information.st_uid, information.st_gid, follow_symlinks=False)
    except PermissionError:
        current = destination.lstat()
        if (current.st_uid, current.st_gid) != (information.st_uid, information.st_gid):
            die(f"cannot preserve owner for {destination}")
    expected = xattrs(source)
    try:
        for name in os.listxattr(destination, follow_symlinks=False):
            if name not in expected:
                os.removexattr(destination, name, follow_symlinks=False)
        for name, value in expected.items():
            os.setxattr(destination, name, base64.b64decode(value), follow_symlinks=False)
    except (AttributeError, NotImplementedError):
        if expected:
            die("host cannot preserve required xattrs")


def copy_file(source: Path, destination: Path) -> None:
    safe_file(source, "source")
    with source.open("rb") as input_stream, destination.open("xb") as output_stream:
        shutil.copyfileobj(input_stream, output_stream)
        output_stream.flush()
        os.fsync(output_stream.fileno())
    copy_metadata(source, destination)
    with destination.open("rb") as stream:
        os.fsync(stream.fileno())


def copy_authoritative(source: Path, destination: Path, expected: dict[str, Any]) -> None:
    """Copy only pinned bytes; do not import working-tree owners or xattrs."""
    safe_file(source, "governed source")
    with source.open("rb") as input_stream, destination.open("xb") as output_stream:
        shutil.copyfileobj(input_stream, output_stream)
        output_stream.flush()
        os.fsync(output_stream.fileno())
    os.chmod(destination, expected["mode"], follow_symlinks=False)
    try:
        os.chown(destination, expected["uid"], expected["gid"], follow_symlinks=False)
    except PermissionError:
        actual = destination.lstat()
        if (actual.st_uid, actual.st_gid) != (expected["uid"], expected["gid"]):
            die("cannot apply canonical target owner")
    for name in os.listxattr(destination, follow_symlinks=False):
        os.removexattr(destination, name, follow_symlinks=False)
    with destination.open("rb") as stream:
        os.fsync(stream.fileno())


def json_read(path: Path, label: str) -> dict[str, Any]:
    safe_file(path, label)
    try:
        result = json.loads(path.read_text(encoding="utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as error:
        die(f"invalid {label}: {error}")
    if not isinstance(result, dict):
        die(f"invalid {label}")
    return result


def json_write(path: Path, value: dict[str, Any]) -> None:
    contained_directory(path.parent, path.parent, create=False)
    if present(path):
        safe_file(path, "control file")
    temporary = path.with_name(f".{path.name}.{uuid.uuid4().hex}.tmp")
    with temporary.open("x", encoding="utf-8") as stream:
        json.dump(value, stream, sort_keys=True, separators=(",", ":"))
        stream.write("\n")
        stream.flush()
        os.fsync(stream.fileno())
    os.replace(temporary, path)
    fsync_dir(path.parent)


def transaction_hash(value: dict[str, Any]) -> str:
    stable = {key: data for key, data in value.items() if key not in {"state", "receipt_pending_at", "committed_at", "transaction_sha256"}}
    return hashlib.sha256(json.dumps(stable, sort_keys=True, separators=(",", ":")).encode()).hexdigest()


def git_output(*arguments: str) -> str:
    return subprocess.run(["git", "-C", str(REPO), *arguments], check=True, capture_output=True, text=True).stdout.strip()


def sources() -> dict[str, dict[str, Any]]:
    output: dict[str, dict[str, Any]] = {}
    for source_relative, target_relative in PATHS.items():
        tree = git_output("ls-tree", PIN, "--", source_relative).split()
        if len(tree) != 4 or tree[0] not in {"100644", "100755"}:
            die(f"unsupported or unavailable pinned source mode: {source_relative}")
        pinned_mode, _, pinned_blob, pinned_path = tree
        if pinned_path != source_relative:
            die(f"pinned source path mismatch: {source_relative}")
        head_blob = git_output("rev-parse", f"HEAD:{source_relative}")
        source = REPO / source_relative
        safe_file(source, "governed source")
        working_blob = git_output("hash-object", str(source))
        if pinned_blob != head_blob or pinned_blob != working_blob:
            die(f"source is not immutably bound to {PIN}: {source_relative}")
        output[source_relative] = {
            "source": source_relative,
            "git_blob": pinned_blob,
            "sha256": digest(source),
            "mode": int(pinned_mode[-3:], 8),
        }
    return output


def roots(args: argparse.Namespace) -> tuple[Path, Path, bool]:
    if args.test_root:
        root = args.test_root.absolute()
        safe_dir(root, "test root")
        marker = root / MARKER
        safe_file(marker, "test marker")
        if marker.read_text() != "accelerate-test-root-v1\n":
            die("marked test root required")
        return root, root / (".codex/skills" if args.mirror == "codex" else ".agents/skills"), True
    account_home = Path(pwd.getpwuid(os.getuid()).pw_dir).resolve()
    supplied_home = os.environ.get("HOME")
    if supplied_home and Path(supplied_home).resolve() != account_home:
        die("HOME override ambiguity")
    safe_dir(account_home, "account home")
    return account_home, account_home / (".codex/skills" if args.mirror == "codex" else ".agents/skills"), False


def control(base: Path, mirror: str) -> tuple[Path, Path]:
    return base / f".accelerate-governed-drift-{mirror}.journal.json", base / f".accelerate-governed-drift-{mirror}.receipt.json"


def validate_record(value: dict[str, Any], base: Path, target: Path, mirror: str, authority: dict[str, dict[str, Any]]) -> None:
    if value.get("contract") != CONTRACT or value.get("mirror") != mirror or value.get("target") != str(target):
        die("journal or receipt is not bound to this exact target")
    if set(value.get("files", {})) != set(PATHS):
        die("journal or receipt allowlist mismatch")
    for source_relative, destination in PATHS.items():
        item = value["files"].get(source_relative)
        required = {"target_relative", "destination", "source_commit", "source_path", "source_blob", "source_sha256", "source_metadata", "before", "backup", "backup_metadata", "phase"}
        if not isinstance(item, dict) or set(item) != required:
            die("closed per-item journal/receipt schema mismatch")
        if item["target_relative"] != destination or item["destination"] != destination or item["source_commit"] != PIN or item["source_path"] != source_relative:
            die("journal/receipt source or destination mismatch")
        if item["source_blob"] != authority[source_relative]["git_blob"] or item["source_sha256"] != authority[source_relative]["sha256"]:
            die("journal/receipt is not bound to the pinned source")
        if not isinstance(item["source_blob"], str) or len(item["source_blob"]) != 40 or not isinstance(item["source_sha256"], str) or len(item["source_sha256"]) != 64:
            die("journal/receipt source hash mismatch")
        if item["phase"] not in {"planned", "backup_ready", "replace_pending", "replaced"}:
            die("journal/receipt phase mismatch")
        backup = item.get("backup")
        if backup is not None:
            candidate = PurePosixPath(backup)
            if candidate.is_absolute() or ".." in candidate.parts:
                die("unsafe backup path")
            candidate_path = base / candidate
            try:
                candidate_path.resolve(strict=False).relative_to(base.resolve(strict=True))
            except ValueError:
                die("backup escapes canonical base")


def failpoint(name: str, is_test: bool) -> None:
    if os.environ.get("ACCELERATE_GOVERNED_DRIFT_FAIL_AFTER") == name:
        if not is_test:
            die("fault injection is test-only")
        die(f"injected interruption after {name}")


def preflight(base: Path, target: Path) -> None:
    safe_dir(base, "canonical mirror base")
    for target_relative in PATHS.values():
        candidate = target / target_relative
        safe_ancestors(base, candidate)
        if present(candidate):
            safe_file(candidate, "governed target")


def restore_one(base: Path, target: Path, item: dict[str, Any]) -> None:
    path = target / item["target_relative"]
    safe_ancestors(base, path)
    before = item["before"]
    backup_relative = item.get("backup")
    if before is None:
        if present(path):
            if not matches(path, item["source_metadata"]):
                die("missing-target recovery found an unexpected file")
            path.unlink()
            fsync_dir(path.parent)
        return
    if not backup_relative:
        die("existing target has no backup")
    backup = base / backup_relative
    safe_ancestors(base, backup)
    if not matches(backup, before):
        die("backup tampered or does not match journal")
    temporary = path.with_name(f".{path.name}.{uuid.uuid4().hex}.restore")
    copy_file(backup, temporary)
    if present(path):
        safe_file(path, "restore target")
    os.replace(temporary, path)
    fsync_dir(path.parent)
    if not matches(path, before):
        die("rollback readback mismatch")


def verify_backups(base: Path, transaction: dict[str, Any], *, changed_only: bool) -> None:
    """Preflight every needed backup before a rollback can alter any target."""
    for item in transaction["files"].values():
        if item["before"] is None or (changed_only and item["phase"] == "planned"):
            continue
        backup = base / item["backup"]
        safe_ancestors(base, backup)
        if not matches(backup, item["before"]):
            die("backup tampered or does not match journal")


def recover(base: Path, target: Path, mirror: str, authority: dict[str, dict[str, Any]]) -> dict[str, Any]:
    journal, receipt = control(base, mirror)
    if not present(journal):
        return {"mode": "recover", "state": "nothing-pending"}
    transaction = json_read(journal, "journal")
    validate_record(transaction, base, target, mirror, authority)
    def exact_committed_receipt() -> bool:
        if not present(receipt):
            return False
        candidate = json_read(receipt, "receipt")
        validate_record(candidate, base, target, mirror, authority)
        return candidate.get("state") == "committed" and candidate.get("transaction_sha256") == transaction_hash(transaction) and all(matches(target / PATHS[relative], transaction["files"][relative]["source_metadata"]) for relative in PATHS)

    if transaction.get("state") == "committed":
        if not exact_committed_receipt():
            die("committed journal has no exact committed receipt/readback")
        return {"mode": "recover", "state": "already-committed"}
    if transaction.get("state") == "rolled_back":
        return {"mode": "recover", "state": "already-rolled-back"}
    if transaction.get("state") == "receipt_pending" and exact_committed_receipt():
        committed = dict(transaction, state="committed", transaction_sha256=transaction_hash(transaction), committed_at=time.time())
        json_write(receipt, committed)
        json_write(journal, committed)
        return {"mode": "recover", "state": "receipt-finalized"}
    verify_backups(base, transaction, changed_only=True)
    for relative in reversed(list(PATHS)):
        item = transaction["files"][relative]
        if item["phase"] != "planned":
            restore_one(base, target, item)
    transaction["state"] = "rolled_back"
    transaction["recovered_at"] = time.time()
    json_write(journal, transaction)
    return {"mode": "recover", "state": "rolled-back"}


def apply(base: Path, target: Path, mirror: str, source: dict[str, dict[str, Any]], is_test: bool) -> dict[str, Any]:
    journal, receipt = control(base, mirror)
    if present(journal):
        existing = json_read(journal, "journal")
        validate_record(existing, base, target, mirror, source)
        if existing.get("state") not in {"committed", "rolled_back"}:
            die("unfinished transaction requires --recover")
    current = {relative: record(target / PATHS[relative]) if present(target / PATHS[relative]) else None for relative in PATHS}
    expected = {relative: desired_metadata(source[relative], current[relative]) for relative in PATHS}
    if all(current[relative] == expected[relative] for relative in PATHS):
        return {"mode": "noop", "mirror": mirror, "target": str(target), "files": len(PATHS)}
    transaction_id = uuid.uuid4().hex
    files: dict[str, dict[str, Any]] = {}
    for relative in PATHS:
        source_path = REPO / source[relative]["source"]
        files[relative] = {"target_relative": PATHS[relative], "destination": PATHS[relative], "source_commit": PIN, "source_path": relative, "source_blob": source[relative]["git_blob"], "source_sha256": source[relative]["sha256"], "source_metadata": expected[relative], "before": current[relative], "backup": f".accelerate-governed-drift-backups/{transaction_id}/{relative}" if current[relative] else None, "backup_metadata": None, "phase": "planned"}
        safe_file(source_path, "governed source")
    transaction: dict[str, Any] = {"contract": CONTRACT, "id": transaction_id, "mirror": mirror, "target": str(target), "state": "intent", "files": files, "created_at": time.time()}
    json_write(journal, transaction)
    temporary_files: dict[str, Path] = {}
    try:
        for index, relative in enumerate(PATHS):
            item = files[relative]
            target_path = target / PATHS[relative]
            if item["before"] is not None:
                backup = base / item["backup"]
                backup_parent_binding = contained_directory(base, backup.parent, create=True)
                copy_file(target_path, backup)
                now = backup.parent.lstat()
                if (now.st_dev, now.st_ino) != backup_parent_binding:
                    die("backup parent inode changed during transaction")
                item["backup_metadata"] = record(backup)
            item["phase"] = "backup_ready"
            json_write(journal, transaction)
            failpoint(f"backup-{index}", is_test)
            temporary = target_path.with_name(f".{target_path.name}.{transaction_id}.new")
            copy_authoritative(REPO / source[relative]["source"], temporary, item["source_metadata"])
            temporary_files[relative] = temporary
            item["phase"] = "replace_pending"
            json_write(journal, transaction)
            os.replace(temporary, target_path)
            fsync_dir(target_path.parent)
            if not matches(target_path, item["source_metadata"]):
                die("replace readback mismatch")
            item["phase"] = "replaced"
            json_write(journal, transaction)
            failpoint(f"replace-{index}", is_test)
        pending = dict(transaction, state="receipt_pending", receipt_pending_at=time.time(), transaction_sha256=transaction_hash(transaction))
        json_write(journal, pending)
        failpoint("receipt_pending", is_test)
        committed = dict(pending, state="committed", committed_at=time.time())
        json_write(receipt, committed)
        failpoint("receipt", is_test)
        json_write(journal, committed)
        failpoint("journal_committed", is_test)
        return {"mode": "apply", "mirror": mirror, "target": str(target), "files": len(PATHS)}
    except Exception:
        for temporary in temporary_files.values():
            if present(temporary):
                temporary.unlink()
        raise


def rollback(base: Path, target: Path, mirror: str, authority: dict[str, dict[str, Any]]) -> dict[str, Any]:
    journal, receipt = control(base, mirror)
    transaction = json_read(receipt, "receipt")
    validate_record(transaction, base, target, mirror, authority)
    if transaction.get("state") != "committed":
        die("rollback replay refused")
    for relative in PATHS:
        item = transaction["files"][relative]
        if not matches(target / PATHS[relative], item["source_metadata"]):
            die("rollback target does not match committed receipt")
    verify_backups(base, transaction, changed_only=False)
    for relative in reversed(list(PATHS)):
        restore_one(base, target, transaction["files"][relative])
    restored = dict(transaction, state="rolled_back", rolled_back_at=time.time())
    json_write(receipt, restored)
    json_write(journal, restored)
    return {"mode": "rollback", "mirror": mirror, "target": str(target)}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--mirror", choices=("codex", "agents"), required=True)
    parser.add_argument("--test-root", type=Path)
    operation = parser.add_mutually_exclusive_group(required=True)
    operation.add_argument("--dry-run", action="store_true")
    operation.add_argument("--apply", action="store_true")
    operation.add_argument("--recover", action="store_true")
    operation.add_argument("--rollback", action="store_true")
    args = parser.parse_args()
    try:
        root, base, is_test = roots(args)
        target = base / "accelerate"
        preflight(base, target)
        source = sources()
        if args.dry_run:
            result = {"mode": "dry-run", "mirror": args.mirror, "target": str(target), "contract": CONTRACT, "files": {key: source[key]["git_blob"] for key in PATHS}}
        elif args.apply:
            result = apply(base, target, args.mirror, source, is_test)
        elif args.recover:
            result = recover(base, target, args.mirror, source)
        else:
            result = rollback(base, target, args.mirror, source)
        print(json.dumps(result, sort_keys=True))
        return 0
    except (Error, subprocess.CalledProcessError) as error:
        print(f"sync-accelerate-governed-drift: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
