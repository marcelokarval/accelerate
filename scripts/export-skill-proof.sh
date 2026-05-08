#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT=""
SELECTED="all"
CHECK_DRIFT=0
VERIFY_EXISTING=0
HOST_RUNTIME_TARGET=""
APPROVE_GENERATED_HOST_TARGET=0
CLEANUP_HOST_TARGET=0

usage() {
  cat <<'USAGE'
Usage: scripts/export-skill-proof.sh --output <dir> [--selected all|skill-a,skill-b] [--check-drift] [--verify-existing]
       scripts/export-skill-proof.sh --output <dir> --host-runtime-target <temp-dir> --approve-generated-host-target [--cleanup-host-target]

Creates a repo-local generated skill export proof bundle. The generated output is
an artifact boundary only; it is not source authority and is safe to run against a
temporary directory for tests.

--verify-existing checks an existing generated export against repo-local source
without regenerating it; use it to catch stale or hand-edited exports.

--host-runtime-target copies the generated bundle into an explicitly approved
temporary/generated host-runtime target for proof only. User-home runtime catalogs
are refused. --cleanup-host-target removes the generated host copy after verifying
it and records rollback/cleanup proof.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      OUTPUT="${2:-}"
      shift 2
      ;;
    --selected)
      SELECTED="${2:-}"
      shift 2
      ;;
    --check-drift)
      CHECK_DRIFT=1
      shift
      ;;
    --verify-existing)
      VERIFY_EXISTING=1
      shift
      ;;
    --host-runtime-target)
      HOST_RUNTIME_TARGET="${2:-}"
      shift 2
      ;;
    --approve-generated-host-target)
      APPROVE_GENERATED_HOST_TARGET=1
      shift
      ;;
    --cleanup-host-target)
      CLEANUP_HOST_TARGET=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$OUTPUT" ]]; then
  echo "--output is required" >&2
  exit 2
fi

case "$OUTPUT" in
  "$HOME"/.codex/skills*|"$HOME"/.claude/skills*|"$HOME"/.agents/skills*)
    echo "refusing to write proof export into a user-home runtime catalog: $OUTPUT" >&2
    exit 2
    ;;
esac

if [[ -n "$HOST_RUNTIME_TARGET" ]]; then
  case "$HOST_RUNTIME_TARGET" in
    "$HOME"/.codex/skills*|"$HOME"/.claude/skills*|"$HOME"/.agents/skills*)
      echo "refusing to write generated host proof into a user-home runtime catalog: $HOST_RUNTIME_TARGET" >&2
      exit 2
      ;;
  esac
fi

"$ROOT/scripts/validate-skill-registry.sh" >/dev/null

python3 - "$ROOT" "$OUTPUT" "$SELECTED" "$CHECK_DRIFT" "$VERIFY_EXISTING" "$HOST_RUNTIME_TARGET" "$APPROVE_GENERATED_HOST_TARGET" "$CLEANUP_HOST_TARGET" <<'PY'
from __future__ import annotations

import hashlib
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

root = Path(sys.argv[1]).resolve()
output = Path(sys.argv[2]).resolve()
selected_arg = sys.argv[3]
check_drift = sys.argv[4] == "1"
verify_existing = sys.argv[5] == "1"
host_runtime_target_arg = sys.argv[6]
approve_generated_host_target = sys.argv[7] == "1"
cleanup_host_target = sys.argv[8] == "1"

skills_root = root / "skills"
export_root = output / "generated-skill-export"
source_manifest = root / "skills/_registry/manifest.md"

def is_relative_to(path: Path, parent: Path) -> bool:
    try:
        path.relative_to(parent)
        return True
    except ValueError:
        return False

if not skills_root.is_dir():
    raise SystemExit("missing repo-local skills directory")
if not source_manifest.is_file():
    raise SystemExit("missing repo-local skill registry manifest")

all_skill_dirs = sorted(
    p for p in skills_root.glob("*/*")
    if p.is_dir()
    and p.parent.name not in {"_registry", "overlays"}
    and (p / "SKILL.md").is_file()
)

if selected_arg == "all":
    selected = all_skill_dirs
else:
    wanted = {item.strip() for item in selected_arg.split(",") if item.strip()}
    by_name = {p.name: p for p in all_skill_dirs}
    missing = sorted(wanted - set(by_name))
    if missing:
        raise SystemExit(f"selected skills are not repo-local/registered candidates: {', '.join(missing)}")
    selected = [by_name[name] for name in sorted(wanted)]

def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

if verify_existing:
    if host_runtime_target_arg:
        raise SystemExit("--host-runtime-target cannot be combined with --verify-existing; verify the generated export first, then run a new approved host proof")
    provenance_path = export_root / "provenance.json"
    if not provenance_path.is_file():
        raise SystemExit(f"missing existing provenance: {provenance_path}")
    provenance = json.loads(provenance_path.read_text())
    included_files = provenance.get("included_files", [])
    drift = []
    for entry in included_files:
        src = root / entry["source"]
        dst = export_root / entry["export"]
        if not src.is_file():
            drift.append({"file": entry["source"], "reason": "missing repo source"})
        elif not dst.is_file():
            drift.append({"file": entry["export"], "reason": "missing export"})
        elif sha256(src) != sha256(dst):
            drift.append({"file": entry["export"], "reason": "content differs from repo source"})
    summary = {
        "drift_detected": bool(drift),
        "drift": drift,
        "provenance": str(provenance_path.relative_to(output)),
        "generated_target": str(export_root),
        "selected_skill_count": len(provenance.get("selected_skill_set", [])),
        "included_file_count": len(included_files),
        "verify_existing": True,
    }
    (export_root / "drift-report.json").write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print(json.dumps(summary, indent=2, sort_keys=True))
    if check_drift and drift:
        raise SystemExit(1)
    raise SystemExit(0)

if export_root.exists():
    shutil.rmtree(export_root)
(export_root / "skills").mkdir(parents=True, exist_ok=True)

included_files: list[dict[str, str]] = []

def copy_file(src: Path, dst: Path) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)
    included_files.append({
        "source": str(src.relative_to(root)),
        "export": str(dst.relative_to(export_root)),
        "sha256": sha256(src),
    })

# Root runtime seed stays explicit and repo-local.
copy_file(root / "SKILL.md", export_root / "root" / "SKILL.md")
copy_file(root / "README.md", export_root / "root" / "README.md")
copy_file(source_manifest, export_root / "registry" / "manifest.md")

for skill_dir in selected:
    target_dir = export_root / "skills" / skill_dir.name
    for src in sorted(skill_dir.rglob("*")):
        if src.is_file():
            copy_file(src, target_dir / src.relative_to(skill_dir))

try:
    source_commit = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip()
except Exception:
    source_commit = "unknown"
try:
    source_tree = subprocess.check_output(["git", "rev-parse", "HEAD^{tree}"], cwd=root, text=True).strip()
except Exception:
    source_tree = "unknown"
try:
    status_short = subprocess.check_output(["git", "status", "--short"], cwd=root, text=True).splitlines()
except Exception:
    status_short = []

provenance = {
    "artifact_type": "accelerate-generated-skill-export-proof",
    "authority": "repo-local source only; generated export is not source truth",
    "source_root": str(root),
    "source_commit": source_commit,
    "source_tree": source_tree,
    "worktree_status_short": status_short,
    "selected_skill_set": [p.name for p in selected],
    "generated_target": str(export_root),
    "generated_boundary": "deployment/runtime export artifact; not governing documentation",
    "user_home_catalogs_authoritative": False,
    "forbidden_authority_examples": ["~/.claude/skills", "~/.codex/skills", "~/.agents/skills"],
    "included_file_count": len(included_files),
    "included_files": included_files,
}

(export_root / "provenance.json").write_text(json.dumps(provenance, indent=2, sort_keys=True) + "\n")

# Drift check: every exported file must still match its repo-local source hash.
drift = []
for entry in included_files:
    src = root / entry["source"]
    dst = export_root / entry["export"]
    if not dst.is_file():
        drift.append({"file": entry["export"], "reason": "missing export"})
    elif sha256(src) != sha256(dst):
        drift.append({"file": entry["export"], "reason": "content differs from repo source"})

host_runtime_proof = None
if host_runtime_target_arg:
    host_runtime_target = Path(host_runtime_target_arg).resolve()
    temp_root = Path(os.environ.get("TMPDIR", "/tmp")).resolve()
    home = Path.home().resolve()
    forbidden_home_catalogs = [
        home / ".claude" / "skills",
        home / ".codex" / "skills",
        home / ".agents" / "skills",
    ]
    if not approve_generated_host_target:
        raise SystemExit("--host-runtime-target requires --approve-generated-host-target")
    if any(is_relative_to(host_runtime_target, forbidden) for forbidden in forbidden_home_catalogs):
        raise SystemExit(f"refusing to write generated host proof into user-home runtime catalog: {host_runtime_target}")
    if not (is_relative_to(host_runtime_target, temp_root) or is_relative_to(host_runtime_target, output)):
        raise SystemExit(f"host runtime target must be temporary/generated for proof: {host_runtime_target}")
    if host_runtime_target == export_root or is_relative_to(host_runtime_target, export_root):
        raise SystemExit("host runtime target must be outside the generated export bundle")
    if host_runtime_target == root or is_relative_to(host_runtime_target, root):
        raise SystemExit("host runtime target must not be inside the repo source tree")

    rollback_snapshot = output / "host-runtime-rollback-snapshot"
    if rollback_snapshot.exists():
        shutil.rmtree(rollback_snapshot)
    target_existed_before = host_runtime_target.exists()
    if target_existed_before:
        shutil.copytree(host_runtime_target, rollback_snapshot)
        shutil.rmtree(host_runtime_target)
    host_runtime_target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copytree(export_root, host_runtime_target)

    host_drift = []
    for entry in included_files:
        src = root / entry["source"]
        dst = host_runtime_target / entry["export"]
        if not dst.is_file():
            host_drift.append({"file": entry["export"], "reason": "missing host runtime copy"})
        elif sha256(src) != sha256(dst):
            host_drift.append({"file": entry["export"], "reason": "host runtime copy differs from repo source"})
    host_provenance = host_runtime_target / "provenance.json"
    if not host_provenance.is_file():
        host_drift.append({"file": "provenance.json", "reason": "missing host runtime provenance"})

    cleanup_action = "retained generated host target for external inspection"
    target_exists_after_cleanup = host_runtime_target.exists()
    rollback_restored = False
    if cleanup_host_target:
        if host_runtime_target.exists():
            shutil.rmtree(host_runtime_target)
        if target_existed_before:
            shutil.copytree(rollback_snapshot, host_runtime_target)
            rollback_restored = True
        cleanup_action = "removed generated host target and restored prior target snapshot" if target_existed_before else "removed generated host target"
        target_exists_after_cleanup = host_runtime_target.exists()

    host_runtime_proof = {
        "artifact_type": "accelerate-generated-host-runtime-export-proof",
        "authority": "repo-local source only; generated host target is not source truth",
        "generated_export_source": str(export_root),
        "host_runtime_target": str(host_runtime_target),
        "approved_generated_host_target": approve_generated_host_target,
        "temporary_or_generated_target_only": True,
        "user_home_catalogs_authoritative": False,
        "forbidden_authority_examples": ["~/.claude/skills", "~/.codex/skills", "~/.agents/skills"],
        "target_existed_before": target_existed_before,
        "host_drift_detected": bool(host_drift),
        "host_drift": host_drift,
        "cleanup_requested": cleanup_host_target,
        "cleanup_action": cleanup_action,
        "target_exists_after_cleanup": target_exists_after_cleanup,
        "rollback_restored": rollback_restored,
    }
    (export_root / "host-runtime-proof.json").write_text(json.dumps(host_runtime_proof, indent=2, sort_keys=True) + "\n")
    if rollback_snapshot.exists():
        shutil.rmtree(rollback_snapshot)
    if check_drift and host_drift:
        raise SystemExit(1)

summary = {
    "drift_detected": bool(drift),
    "drift": drift,
    "provenance": str((export_root / "provenance.json").relative_to(output)),
    "generated_target": str(export_root),
    "selected_skill_count": len(selected),
    "included_file_count": len(included_files),
}
if host_runtime_proof is not None:
    summary["host_runtime_proof"] = "generated-skill-export/host-runtime-proof.json"
    summary["host_runtime_target"] = host_runtime_proof["host_runtime_target"]
    summary["host_drift_detected"] = host_runtime_proof["host_drift_detected"]
    summary["host_cleanup_action"] = host_runtime_proof["cleanup_action"]
    summary["host_target_exists_after_cleanup"] = host_runtime_proof["target_exists_after_cleanup"]
(export_root / "drift-report.json").write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")

print(json.dumps(summary, indent=2, sort_keys=True))
if check_drift and drift:
    raise SystemExit(1)
PY
