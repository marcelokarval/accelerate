#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT=""
SELECTED="all"
CHECK_DRIFT=0
VERIFY_EXISTING=0

usage() {
  cat <<'USAGE'
Usage: scripts/export-skill-proof.sh --output <dir> [--selected all|skill-a,skill-b] [--check-drift] [--verify-existing]

Creates a repo-local generated skill export proof bundle. The generated output is
an artifact boundary only; it is not source authority and is safe to run against a
temporary directory for tests.

--verify-existing checks an existing generated export against repo-local source
without regenerating it; use it to catch stale or hand-edited exports.
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

"$ROOT/scripts/validate-skill-registry.sh" >/dev/null

python3 - "$ROOT" "$OUTPUT" "$SELECTED" "$CHECK_DRIFT" "$VERIFY_EXISTING" <<'PY'
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

skills_root = root / "skills"
export_root = output / "generated-skill-export"
source_manifest = root / "skills/_registry/manifest.md"

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

summary = {
    "drift_detected": bool(drift),
    "drift": drift,
    "provenance": str((export_root / "provenance.json").relative_to(output)),
    "generated_target": str(export_root),
    "selected_skill_count": len(selected),
    "included_file_count": len(included_files),
}
(export_root / "drift-report.json").write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")

print(json.dumps(summary, indent=2, sort_keys=True))
if check_drift and drift:
    raise SystemExit(1)
PY
