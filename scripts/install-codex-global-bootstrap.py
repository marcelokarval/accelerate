#!/usr/bin/env python3
"""Stage or install the repo-owned delegation policy into an explicit AGENTS file."""

from __future__ import annotations

import argparse
import importlib.util
import json
import os
import shutil
import stat
from datetime import UTC, datetime
from pathlib import Path

RENDERER_PATH = Path(__file__).with_name("render-codex-global-bootstrap.py")
RENDERER_SPEC = importlib.util.spec_from_file_location(
    "render_codex_global_bootstrap", RENDERER_PATH
)
if RENDERER_SPEC is None or RENDERER_SPEC.loader is None:
    raise RuntimeError("cannot load codex global bootstrap renderer")
RENDERER = importlib.util.module_from_spec(RENDERER_SPEC)
RENDERER_SPEC.loader.exec_module(RENDERER)
RenderError = RENDERER.RenderError
load_fragment = RENDERER.load_fragment
render_target = RENDERER.render_target
sha256 = RENDERER.sha256


def write_atomic(path: Path, data: bytes, mode: int | None = None) -> None:
    temporary = path.with_name(f".{path.name}.accelerate-tmp-{os.getpid()}")
    try:
        temporary.write_bytes(data)
        if mode is not None:
            os.chmod(temporary, mode)
        os.replace(temporary, path)
    finally:
        if temporary.exists():
            temporary.unlink()


def validate_preflight(path: Path, expected: dict[str, object]) -> None:
    try:
        candidate = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise RenderError("apply requires a readable dry-run preflight receipt") from exc
    if not isinstance(candidate, dict):
        raise RenderError("apply preflight receipt must be a JSON object")
    required = {
        "mode": "dry-run",
        "backup_path": None,
        "source_before_sha256": expected["source_before_sha256"],
        "source_after_sha256": expected["source_after_sha256"],
        "target_before_sha256": expected["target_before_sha256"],
        "target_after_sha256": expected["target_after_sha256"],
        "changed": expected["changed"],
        "target_identity": expected["target_identity"],
    }
    for key, value in required.items():
        if candidate.get(key) != value:
            raise RenderError(f"apply preflight receipt mismatch: {key}")


def load_apply_receipt(path: Path, source_hash: str, current_target_hash: str, target_identity: str) -> dict[str, object]:
    try:
        candidate = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise RenderError("rollback requires a readable apply receipt") from exc
    if not isinstance(candidate, dict) or candidate.get("mode") != "apply":
        raise RenderError("rollback requires an apply receipt")
    if candidate.get("changed") is not True:
        raise RenderError("rollback requires a changed apply receipt")
    if candidate.get("source_before_sha256") != source_hash or candidate.get("source_after_sha256") != source_hash:
        raise RenderError("rollback apply receipt source fingerprint mismatch")
    if candidate.get("target_after_sha256") != current_target_hash:
        raise RenderError("rollback current target fingerprint mismatch")
    if candidate.get("target_identity") != target_identity:
        raise RenderError("rollback apply receipt target identity mismatch")
    backup_value = candidate.get("backup_path")
    if not isinstance(backup_value, str) or not backup_value:
        raise RenderError("rollback apply receipt lacks a backup path")
    backup = Path(backup_value)
    if not backup.is_file():
        raise RenderError("rollback backup is unavailable")
    if sha256(backup.read_bytes()) != candidate.get("target_before_sha256"):
        raise RenderError("rollback backup fingerprint mismatch")
    return candidate


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target", required=True, type=Path)
    parser.add_argument("--receipt", required=True, type=Path)
    parser.add_argument("--rollback-receipt", type=Path)
    parser.add_argument(
        "--fragment",
        type=Path,
        default=Path(__file__).resolve().parents[1]
        / "adapters/runtime/codex/global-bootstrap-orchestration.fragment.md",
    )
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--dry-run", action="store_true")
    mode.add_argument("--apply", action="store_true")
    mode.add_argument("--rollback", action="store_true")
    args = parser.parse_args()
    try:
        if not args.target.is_file():
            raise RenderError("target must be an existing regular file")
        if args.target.resolve() == args.receipt.resolve():
            raise RenderError("receipt path must not equal target path")
        fragment = load_fragment(args.fragment)
        target_identity = str(args.target.resolve())
        target_before = args.target.read_bytes()
        if args.rollback:
            if args.rollback_receipt is None:
                raise RenderError("rollback requires --rollback-receipt")
            if args.rollback_receipt.resolve() in {args.target.resolve(), args.receipt.resolve()}:
                raise RenderError("rollback receipt path must be separate from target and apply receipt")
            apply_receipt = load_apply_receipt(
                args.receipt, sha256(fragment), sha256(target_before), target_identity
            )
            backup = Path(str(apply_receipt["backup_path"]))
            restored = backup.read_bytes()
            rollback_receipt = {
                "apply_receipt_path": str(args.receipt),
                "backup_path": str(backup),
                "changed": True,
                "mode": "rollback",
                "source_after_sha256": sha256(fragment),
                "source_before_sha256": sha256(fragment),
                "target_after_sha256": sha256(restored),
                "target_before_sha256": sha256(target_before),
                "target_identity": target_identity,
                "timestamp": datetime.now(UTC).isoformat().replace("+00:00", "Z"),
            }
            write_atomic(args.target, restored, stat.S_IMODE(args.target.stat().st_mode))
            write_atomic(
                args.rollback_receipt,
                (json.dumps(rollback_receipt, indent=2, sort_keys=True) + "\n").encode(),
            )
            print(json.dumps(rollback_receipt, sort_keys=True))
            return 0
        if args.rollback_receipt is not None:
            raise RenderError("--rollback-receipt is only valid with --rollback")
        target_after = render_target(target_before, fragment)
    except (OSError, RenderError) as exc:
        parser.error(str(exc))

    timestamp = datetime.now(UTC).isoformat().replace("+00:00", "Z")
    receipt = {
        "backup_path": None,
        "changed": target_after != target_before,
        "mode": "apply" if args.apply else "dry-run",
        "source_after_sha256": sha256(fragment),
        "source_before_sha256": sha256(fragment),
        "target_after_sha256": sha256(target_after),
        "target_before_sha256": sha256(target_before),
        "target_identity": target_identity,
        "timestamp": timestamp,
    }
    if args.dry_run:
        write_atomic(args.receipt, (json.dumps(receipt, indent=2, sort_keys=True) + "\n").encode())
        print(json.dumps(receipt, sort_keys=True))
        return 0

    try:
        validate_preflight(args.receipt, receipt)
    except RenderError as exc:
        parser.error(str(exc))

    if not receipt["changed"]:
        write_atomic(args.receipt, (json.dumps(receipt, indent=2, sort_keys=True) + "\n").encode())
        print(json.dumps(receipt, sort_keys=True))
        return 0

    stamp = datetime.now(UTC).strftime("%Y%m%dT%H%M%S%fZ")
    backup = args.target.with_name(f"{args.target.name}.accelerate-delegation-policy.{stamp}.bak")
    shutil.copy2(args.target, backup)
    write_atomic(args.target, target_after, stat.S_IMODE(args.target.stat().st_mode))
    receipt["backup_path"] = str(backup)
    write_atomic(args.receipt, (json.dumps(receipt, indent=2, sort_keys=True) + "\n").encode())
    print(json.dumps(receipt, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
