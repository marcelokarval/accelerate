#!/usr/bin/env python3
"""Preview/apply the official AGY 1.3.3 Accelerate plugin lifecycle."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import stat
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "adapters" / "runtime" / "agy"
PLUGIN_NAME = "accelerate-entry"
AGY_VERSION = "1.3.3"
AGY_VERSIONS = ("1.3.3", "1.3.4")
START = b"<!-- accelerate-agy-entry:start -->"
END = b"<!-- accelerate-agy-entry:end -->"


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def regular(path: Path) -> os.stat_result:
    info = path.lstat()
    if not stat.S_ISREG(info.st_mode) or stat.S_ISLNK(info.st_mode) or info.st_nlink != 1:
        raise ValueError(f"refusing non-regular or linked file: {path}")
    return info


def secure_under(home: Path, target: Path) -> None:
    try:
        relative = target.relative_to(home)
    except ValueError as exc:
        raise ValueError(f"target escapes selected home: {target}") from exc
    cursor = home
    for part in relative.parts:
        cursor /= part
        if not cursor.exists() and not cursor.is_symlink():
            break
        if stat.S_ISLNK(cursor.lstat().st_mode):
            raise ValueError(f"symlink path component refused: {cursor}")


def tree_rows(root: Path) -> list[dict]:
    if not root.is_dir() or root.is_symlink():
        raise ValueError(f"plugin tree is not a regular directory: {root}")
    rows = []
    for path in sorted(root.rglob("*")):
        relative = path.relative_to(root).as_posix()
        info = path.lstat()
        if stat.S_ISLNK(info.st_mode):
            raise ValueError(f"plugin tree contains a symlink: {relative}")
        if path.is_dir():
            continue
        regular(path)
        if "__pycache__" in path.parts or path.suffix == ".pyc":
            raise ValueError(f"generated Python cache in plugin tree: {relative}")
        data = path.read_bytes()
        rows.append({"path": relative, "sha256": digest(data), "size": len(data),
                     "mode": oct(info.st_mode & 0o777)})
    if not rows:
        raise ValueError("plugin tree is empty")
    return rows


def tree_hash(rows: list[dict]) -> str:
    return digest(json.dumps(rows, sort_keys=True, separators=(",", ":")).encode())


def managed_block(data: bytes) -> tuple[int, int, bytes] | None:
    if data.count(START) != data.count(END):
        raise ValueError("malformed loose Accelerate rule markers")
    if not data.count(START):
        return None
    if data.count(START) != 1:
        raise ValueError("duplicate loose Accelerate rule markers")
    begin = data.index(START)
    finish = data.index(END, begin) + len(END)
    return begin, finish, data[begin:finish]


def require_hash(actual: str, expected: str | None, label: str) -> None:
    valid = expected is not None and len(expected) == 64 and expected == expected.lower()
    valid = valid and all(character in "0123456789abcdef" for character in expected)
    if not valid:
        raise ValueError(f"{label} exists; provide its exact SHA256: {actual}")
    if actual != expected:
        raise ValueError(f"{label} SHA256 mismatch")


def locations(home: Path) -> dict[str, Path]:
    config = home / ".gemini" / "config"
    return {
        "installed": config / "plugins" / PLUGIN_NAME,
        "manifest": config / "import_manifest.json",
        "config": config / "config.json",
        "nativeLooseSkill": home / ".gemini" / "antigravity-cli" / "skills" / "accelerate" / "SKILL.md",
        "configLooseSkill": config / "skills" / "accelerate" / "SKILL.md",
        "looseRule": home / ".gemini" / "GEMINI.md",
    }


def executable_record(value: str, env: dict[str, str]) -> dict:
    found = value if "/" in value else shutil.which(value, path=env.get("PATH"))
    if not found:
        raise ValueError("AGY executable not found")
    path = Path(found).expanduser().resolve(strict=True)
    info = regular(path)
    if not os.access(path, os.X_OK):
        raise ValueError("AGY executable is not executable")
    result = subprocess.run([str(path), "--version"], text=True, capture_output=True, env=env, timeout=20)
    version = result.stdout.strip()
    if result.returncode or version not in AGY_VERSIONS:
        raise ValueError(f"expected AGY {AGY_VERSION}, got {version or result.stderr.strip()}")
    return {"path": str(path), "version": version, "sha256": digest(path.read_bytes()),
            "device": info.st_dev, "inode": info.st_ino, "size": info.st_size,
            "mode": oct(info.st_mode & 0o777)}


def read_object(path: Path, label: str) -> dict:
    regular(path)
    try:
        value = json.loads(path.read_bytes())
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise ValueError(f"invalid {label} JSON") from exc
    if not isinstance(value, dict):
        raise ValueError(f"invalid {label} object")
    return value


def plugin_imports(manifest: dict) -> list[dict]:
    imports = manifest.get("imports")
    if imports is None:
        return []
    if not isinstance(imports, list):
        raise ValueError("import_manifest imports must be a list")
    matches = []
    for row in imports:
        if not isinstance(row, dict):
            raise ValueError("import_manifest entry must be an object")
        identity = row.get("name") == PLUGIN_NAME or Path(str(row.get("path", ""))).name == PLUGIN_NAME
        if identity:
            matches.append(row)
    return matches


def registry_state(paths: dict[str, Path], *, present: bool) -> bool | None:
    manifest_path, config_path = paths["manifest"], paths["config"]
    if not manifest_path.exists() and not manifest_path.is_symlink():
        if present:
            raise ValueError("AGY import_manifest is absent")
        manifest_matches = []
    else:
        manifest_matches = plugin_imports(read_object(manifest_path, "import_manifest"))
    config_plugins = {}
    if config_path.exists() or config_path.is_symlink():
        config = read_object(config_path, "AGY config")
        config_plugins = config.get("plugins", {})
        if not isinstance(config_plugins, dict):
            raise ValueError("AGY config plugins must be an object")
    entry_present = PLUGIN_NAME in config_plugins
    entry = config_plugins.get(PLUGIN_NAME)
    if present:
        if len(manifest_matches) != 1 or manifest_matches[0].get("source") != "antigravity":
            raise ValueError("plugin must have exactly one antigravity import_manifest entry")
        if not entry_present:
            return True  # AGY's documented default when no override exists.
        if not isinstance(entry, dict) or not isinstance(entry.get("enabled"), bool):
            raise ValueError("plugin enablement override is invalid in AGY config")
        return entry["enabled"]
    if manifest_matches or entry_present:
        raise ValueError("plugin registry residue remains after uninstall")
    return None


def cleanup_candidates(args: argparse.Namespace, paths: dict[str, Path]) -> list[dict]:
    result = []
    pairs = (
        ("native-loose-skill", paths["nativeLooseSkill"], args.cleanup_native_loose_skill_sha256),
        ("config-loose-skill", paths["configLooseSkill"], args.cleanup_config_loose_skill_sha256),
    )
    for kind, path, expected in pairs:
        if path.exists() or path.is_symlink():
            regular(path)
            actual = digest(path.read_bytes())
            require_hash(actual, expected, kind)
            result.append({"kind": kind, "path": str(path), "sha256": actual})
        elif expected:
            raise ValueError(f"{kind} cleanup hash supplied but target is absent")
    rule = paths["looseRule"]
    if rule.exists() or rule.is_symlink():
        regular(rule)
        data = rule.read_bytes()
        block = managed_block(data)
        if block:
            actual = digest(block[2])
            require_hash(actual, args.cleanup_loose_rule_sha256, "loose rule block")
            result.append({"kind": "loose-rule-block", "path": str(rule), "sha256": actual})
        elif args.cleanup_loose_rule_sha256:
            raise ValueError("loose rule cleanup hash supplied but managed block is absent")
    elif args.cleanup_loose_rule_sha256:
        raise ValueError("loose rule cleanup hash supplied but target is absent")
    return result


def build_plan(args: argparse.Namespace) -> dict:
    home = Path(args.home).expanduser().resolve()
    paths = locations(home)
    for path in paths.values():
        secure_under(home, path)
    env = os.environ.copy()
    env["HOME"] = str(home)
    agy = executable_record(args.agy, env)
    source_hash = tree_hash(tree_rows(SOURCE))
    installed_hash = (tree_hash(tree_rows(paths["installed"]))
                      if paths["installed"].exists() or paths["installed"].is_symlink() else None)
    enabled_before = None
    if args.operation == "install" and installed_hash:
        raise ValueError("plugin is already installed; use --operation update")
    if args.operation == "install":
        registry_state(paths, present=False)
    if args.operation in {"update", "uninstall"}:
        if not installed_hash:
            raise ValueError("plugin is not installed")
        require_hash(installed_hash, args.expect_installed_tree_sha256, "installed plugin tree")
        enabled_before = registry_state(paths, present=True)
    cleanup = cleanup_candidates(args, paths) if args.operation in {"install", "update"} else []
    commands = ["plugin validate", "plugin install"] if args.operation == "install" else (
        ["plugin validate", "plugin uninstall", "plugin install"] if args.operation == "update"
        else ["plugin uninstall"])
    plan = {
        "schema": "accelerate-agy-plugin-plan/v2", "operation": args.operation,
        "agy": agy, "source": str(SOURCE), "sourceTreeSha256": source_hash,
        "installed": str(paths["installed"]), "installedTreeSha256": installed_hash,
        "enabledBefore": enabled_before, "officialCommands": commands, "cleanup": cleanup,
        "limitations": [
            "AGY 1.3.3 update is an official uninstall/install sequence and is not atomic",
            "hook process failure semantics and shell containment remain AGY/host responsibilities",
            "python3 in hook commands is resolved by the host PATH; -I isolates Python environment imports",
        ],
    }
    plan["planSha256"] = digest(json.dumps(plan, sort_keys=True, separators=(",", ":")).encode())
    return plan


def run_checked(command: list[str], env: dict[str, str]) -> dict:
    result = subprocess.run(command, text=True, capture_output=True, env=env, timeout=120)
    if result.returncode:
        raise RuntimeError(f"official AGY command failed ({result.returncode}): {' '.join(command)}\n{result.stderr.strip()}")
    return {"command": command, "returncode": 0, "stdoutSha256": digest(result.stdout.encode()),
            "stderrSha256": digest(result.stderr.encode())}


def atomic_write(path: Path, data: bytes, mode: int) -> None:
    temp = path.parent / f".{path.name}.accelerate-plugin-{os.getpid()}.tmp"
    fd = os.open(temp, os.O_WRONLY | os.O_CREAT | os.O_EXCL, mode)
    try:
        os.fchmod(fd, mode)
        with os.fdopen(fd, "wb") as stream:
            stream.write(data)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temp, path)
        os.chmod(path, mode)
    finally:
        try:
            temp.unlink()
        except FileNotFoundError:
            pass


def cleanup_loose(rows: list[dict], home: Path) -> list[dict]:
    readback = []
    for row in rows:
        path = Path(row["path"])
        secure_under(home, path)
        if row["kind"].endswith("loose-skill"):
            regular(path)
            require_hash(digest(path.read_bytes()), row["sha256"], row["kind"] + " at apply")
            path.unlink()
            if path.parent.exists() and not any(path.parent.iterdir()):
                path.parent.rmdir()
            readback.append({"path": str(path), "absent": not path.exists()})
            continue
        info = regular(path)
        data = path.read_bytes()
        block = managed_block(data)
        if block is None:
            raise ValueError("loose rule block disappeared before apply")
        require_hash(digest(block[2]), row["sha256"], "loose rule block at apply")
        before, after = data[:block[0]], data[block[1]:]
        if before.endswith(b"\n\n") and after.startswith(b"\n"):
            before = before[:-1]
        atomic_write(path, before + after, info.st_mode & 0o777)
        readback.append({"path": str(path), "managedBlockAbsent": managed_block(path.read_bytes()) is None,
                         "mode": oct(path.stat().st_mode & 0o777)})
    return readback


def assert_executable(expected: dict, args: argparse.Namespace, env: dict[str, str]) -> str:
    current = executable_record(args.agy, env)
    if current != expected:
        raise ValueError("AGY executable identity or version changed after preview")
    return current["path"]


def assert_source(plan: dict) -> None:
    if tree_hash(tree_rows(SOURCE)) != plan["sourceTreeSha256"]:
        raise ValueError("plugin source changed after preview")


def assert_installed(plan: dict, paths: dict[str, Path]) -> None:
    actual = tree_hash(tree_rows(paths["installed"]))
    if actual != plan["installedTreeSha256"]:
        raise ValueError("installed plugin changed after preview")
    if registry_state(paths, present=True) != plan["enabledBefore"]:
        raise ValueError("installed plugin registry or enablement changed after preview")


def refresh_active_state_receipts(home: Path, installed: Path) -> None:
    import hmac

    state_root = home / ".gemini" / "antigravity-cli" / "accelerate-entry-state"
    if not state_root.is_dir() or state_root.is_symlink():
        return
    hook_sha = digest((installed / "scripts" / "entry_hook.py").read_bytes())
    classifier_sha = digest((installed / "core" / "entry.py").read_bytes())
    routing_sha = digest((installed / "core" / "routing.py").read_bytes())

    def canonical(value: object) -> bytes:
        return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode()

    for conv_dir in sorted(state_root.iterdir()):
        if not conv_dir.is_dir() or conv_dir.is_symlink():
            continue
        seed_path = conv_dir / "seed.json"
        receipt_path = conv_dir / "receipt.json"
        if not seed_path.is_file() or not receipt_path.is_file():
            continue
        try:
            seed = read_object(seed_path, "seed")
            nonce = seed.get("nonce")
            if not isinstance(nonce, str):
                continue
            key = bytes.fromhex(nonce)
            receipt = read_object(receipt_path, "receipt")
            mac = receipt.pop("mac", None)
            expected = hmac.new(key, canonical(receipt), hashlib.sha256).hexdigest()
            if not isinstance(mac, str) or not hmac.compare_digest(mac, expected):
                continue
            receipt["hookSha256"] = hook_sha
            receipt["classifierSha256"] = classifier_sha
            receipt["routingSha256"] = routing_sha
            receipt["mac"] = hmac.new(key, canonical(receipt), hashlib.sha256).hexdigest()
            atomic_write(receipt_path, canonical(receipt) + b"\n", 0o600)

            carrier_path = conv_dir / "reclassification-carrier.json"
            if carrier_path.is_file():
                carrier = read_object(carrier_path, "carrier")
                c_mac = carrier.pop("mac", None)
                c_expected = hmac.new(key, canonical(carrier), hashlib.sha256).hexdigest()
                if isinstance(c_mac, str) and hmac.compare_digest(c_mac, c_expected):
                    carrier["hookSha256"] = hook_sha
                    carrier["receiptSha256"] = digest(canonical(receipt))
                    carrier["mac"] = hmac.new(key, canonical(carrier), hashlib.sha256).hexdigest()
                    atomic_write(carrier_path, canonical(carrier) + b"\n", 0o600)
        except (ValueError, OSError):
            continue


def apply(plan: dict, args: argparse.Namespace) -> dict:
    if args.expect_plan_sha256 != plan["planSha256"]:
        raise ValueError("preview fingerprint mismatch")
    home = Path(args.home).expanduser().resolve()
    paths = locations(home)
    env = os.environ.copy()
    env["HOME"] = str(home)
    agy = assert_executable(plan["agy"], args, env)
    assert_source(plan)
    commands = []
    if args.operation in {"install", "update"}:
        commands.append(run_checked([agy, "plugin", "validate", str(SOURCE)], env))
        assert_executable(plan["agy"], args, env)
        assert_source(plan)
    if args.operation in {"update", "uninstall"}:
        assert_executable(plan["agy"], args, env)
        assert_installed(plan, paths)  # immediately before destructive uninstall
        commands.append(run_checked([agy, "plugin", "uninstall", PLUGIN_NAME], env))
        if paths["installed"].exists() or paths["installed"].is_symlink():
            raise RuntimeError("official uninstall returned success but plugin remains")
        registry_state(paths, present=False)
    if args.operation == "uninstall":
        return {"operation": "uninstall", "commands": commands,
                "readback": {"installedAbsent": True, "registryAbsent": True}, "cleanup": []}
    assert_executable(plan["agy"], args, env)
    assert_source(plan)
    commands.append(run_checked([agy, "plugin", "install", str(SOURCE)], env))
    if not paths["installed"].is_dir():
        raise RuntimeError("official install returned success but plugin is absent")
    actual = tree_hash(tree_rows(paths["installed"]))
    if actual != plan["sourceTreeSha256"]:
        raise RuntimeError("installed plugin tree does not match reviewed source")
    enabled = registry_state(paths, present=True)
    if args.operation == "update" and plan["enabledBefore"] is False:
        commands.append(run_checked([agy, "plugin", "disable", PLUGIN_NAME], env))
        enabled = registry_state(paths, present=True)
        if enabled is not False:
            raise RuntimeError("official update did not preserve disabled state")
    elif enabled is not True:
        raise RuntimeError("official install did not enable the plugin")
    refresh_active_state_receipts(home, paths["installed"])
    cleanup = cleanup_loose(plan["cleanup"], home)
    return {"operation": args.operation, "commands": commands, "cleanup": cleanup,
            "readback": {"installedTreeSha256": actual, "enabled": enabled,
                         "manifestSource": "antigravity", "verified": True}}


def parser() -> argparse.ArgumentParser:
    value = argparse.ArgumentParser()
    value.add_argument("--operation", choices=("install", "update", "uninstall"), default="install")
    value.add_argument("--agy", default=shutil.which("agy") or "agy")
    value.add_argument("--home", default=str(Path.home()))
    value.add_argument("--expect-installed-tree-sha256")
    value.add_argument("--cleanup-native-loose-skill-sha256")
    value.add_argument("--cleanup-config-loose-skill-sha256")
    value.add_argument("--cleanup-loose-rule-sha256")
    value.add_argument("--apply", action="store_true")
    value.add_argument("--expect-plan-sha256")
    return value


def main() -> int:
    args = parser().parse_args()
    try:
        plan = build_plan(args)
        if not args.apply:
            print(json.dumps(plan, indent=2, sort_keys=True))
            return 0
        if not args.expect_plan_sha256:
            raise ValueError("--apply requires --expect-plan-sha256")
        print(json.dumps(apply(plan, args), indent=2, sort_keys=True))
        return 0
    except (ValueError, OSError, RuntimeError, subprocess.TimeoutExpired) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
