#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stage_root="$(mktemp -d)"
trap 'rm -rf -- "$stage_root"' EXIT

generation_root="$stage_root/generation-root"
mkdir -p "$generation_root"
for source_dir in adapters agents global-runtime references scripts skills; do
  cp -a "$ROOT/$source_dir" "$generation_root/$source_dir"
done
find "$generation_root/skills" -type d -name __pycache__ -prune -exec rm -rf -- {} +
find "$generation_root/skills" -type f -name '*.pyc' -delete
python3 - "$generation_root" <<'PY'
import re
import shutil
import sys
from pathlib import Path

root = Path(sys.argv[1])
manifest = (root / "skills/_registry/manifest.md").read_text()
local_section = manifest.split("## Local Skills", 1)[1].split("## Migration Backlog", 1)[0]
registered = set(re.findall(r"^\| `([^`]+)` \|", local_section, re.MULTILINE))
for category in (root / "skills").iterdir():
    if not category.is_dir() or category.name in {"_registry", "overlays"}:
        continue
    for skill in category.iterdir():
        if skill.is_dir() and (skill.name not in registered or not (skill / "SKILL.md").is_file()):
            shutil.rmtree(skill)
PY

codex_home="$stage_root/runtime/.codex"
target="$codex_home/skills"
backup="$stage_root/backups/generation-2"
receipt="$backup/sync-receipt.json"
mkdir -p "$target/accelerate/references"
printf 'generation-zero package\n' >"$target/accelerate/references/original-sentinel.md"
printf 'model = "generation-zero"\n' >"$codex_home/config.toml"
cp -a "$target" "$stage_root/expected-original-target"
cp "$codex_home/config.toml" "$stage_root/expected-original-config.toml"

CODEX_HOME="$codex_home" \
CODEX_SKILLS_DIR="$target" \
CODEX_SKILLS_BACKUP_DIR="$backup" \
CODEX_SKILLS_RECEIPT_FILE="$receipt" \
CODEX_SKILL_SYNC_ALLOWED_ROOT="$stage_root" \
  "$generation_root/scripts/sync-skills-to-global.sh" >/dev/null

python3 - "$receipt" "$generation_root" <<'PY'
import json
import re
import sys
from pathlib import Path

receipt_path = Path(sys.argv[1]).resolve()
source_root = Path(sys.argv[2]).resolve()
receipt = json.loads(receipt_path.read_text())
if receipt.get("schema_version") != 4:
    raise SystemExit("generation rollback RED: receipt schema is not generation-bound v4")
generation = receipt.get("generation")
required_generation = {
    "package_denominator", "runtime_denominator", "source_snapshots",
    "operation_plan_digest",
}
if not isinstance(generation, dict) or set(generation) != required_generation:
    raise SystemExit("generation rollback RED: exact generation contract is missing")
if generation["package_denominator"] != receipt.get("changed_packages"):
    raise SystemExit("package denominator is not frozen in the receipt generation")
if generation["runtime_denominator"] != receipt.get("runtime_files"):
    raise SystemExit("runtime denominator is not frozen in the receipt generation")
required_receipts = {"skill-catalog-install-receipt.json", "logical-agent-install-receipt.json"}
if not required_receipts <= set(generation["runtime_denominator"]):
    raise SystemExit("runtime generation omitted current ownership receipts")
snapshots = generation["source_snapshots"]
if not isinstance(snapshots, dict) or set(snapshots) != {"catalog", "topology", "rollback"}:
    raise SystemExit("receipt source snapshots are incomplete")
expected_paths = {
    "catalog": source_root / "adapters/runtime/codex/skill-catalog-manifest.toml",
    "topology": source_root / "adapters/runtime/codex/logical-agent-topology.toml",
    "rollback": source_root / "scripts/rollback-global-skill-sync.sh",
}
for name, expected_path in expected_paths.items():
    snapshot = snapshots[name]
    if set(snapshot) != {"path", "sha256"} or Path(snapshot["path"]) != expected_path:
        raise SystemExit(f"invalid {name} source snapshot path")
    if re.fullmatch(r"[0-9a-f]{64}", snapshot["sha256"]) is None:
        raise SystemExit(f"invalid {name} source snapshot digest")
if re.fullmatch(r"[0-9a-f]{64}", generation["operation_plan_digest"]) is None:
    raise SystemExit("invalid generation operation-plan digest")
expected_command = [
    "/bin/bash",
    str(source_root / "scripts/rollback-global-skill-sync.sh"),
    str(receipt_path),
]
if receipt.get("rollback_command") != expected_command:
    raise SystemExit("rollback_command is not the exact governed argv")
operation_keys = {
    "lane", "kind", "name", "target", "backup", "existed_before",
    "action", "backup_digest", "installed_digest",
}
for operation in receipt.get("operations", []):
    if set(operation) != operation_keys:
        raise SystemExit("generation operation schema is incomplete")
    if operation["action"] == "replace" and re.fullmatch(r"[0-9a-f]{64}", operation["installed_digest"] or "") is None:
        raise SystemExit(f"replacement is missing installed digest: {operation['name']}")
    if operation["action"] == "delete" and operation["installed_digest"] is not None:
        raise SystemExit(f"deletion fabricated an installed digest: {operation['name']}")
PY

cp -a "$target" "$stage_root/expected-installed-target"
cp "$codex_home/config.toml" "$stage_root/expected-installed-config.toml"
cp "$receipt" "$stage_root/clean-receipt.json"

capture_operation_state() {
  local output_file="$1"
  python3 - "$receipt" "$output_file" <<'PY'
import hashlib
import json
import os
import stat
import sys
from pathlib import Path


def governed_digest(path: Path, symlink_context: Path | None = None) -> str:
    digest = hashlib.sha256()

    def field(value: bytes) -> None:
        digest.update(len(value).to_bytes(8, "big"))
        digest.update(value)

    def visit(node: Path, relative: str) -> None:
        metadata = node.lstat()
        field(relative.encode())
        field(oct(stat.S_IMODE(metadata.st_mode)).encode())
        if stat.S_ISLNK(metadata.st_mode):
            field(b"symlink")
            field(os.readlink(node).encode())
        elif stat.S_ISDIR(metadata.st_mode):
            field(b"directory")
            for child in sorted(node.iterdir(), key=lambda item: item.name):
                child_relative = child.name if relative == "." else f"{relative}/{child.name}"
                visit(child, child_relative)
        elif stat.S_ISREG(metadata.st_mode):
            field(b"file")
            with node.open("rb") as handle:
                for chunk in iter(lambda: handle.read(1024 * 1024), b""):
                    digest.update(chunk)
        else:
            raise SystemExit(f"unsupported governed target node: {node}")

    root_metadata = path.lstat()
    visit(path, ".")
    if stat.S_ISLNK(root_metadata.st_mode):
        field(b"root-symlink-target")
        raw_target = Path(os.readlink(path))
        contextual_target = raw_target if raw_target.is_absolute() else (symlink_context or path.parent) / raw_target
        visit(contextual_target.resolve(strict=True), "@target")
    return digest.hexdigest()


receipt_data = json.loads(Path(sys.argv[1]).read_text())
state = []
for operation in receipt_data["operations"]:
    target_path = Path(operation["target"])
    exists = os.path.lexists(target_path)
    state.append({
        "kind": operation["kind"],
        "name": operation["name"],
        "action": operation["action"],
        "exists": exists,
        "digest": governed_digest(target_path, target_path.parent) if exists else None,
    })
Path(sys.argv[2]).write_text(json.dumps(state, sort_keys=True, separators=(",", ":")) + "\n")
PY
}

assert_installed_drift_rejected_without_mutation() {
  local scenario="$1"
  local before_state="$stage_root/$scenario-before.json"
  local after_state="$stage_root/$scenario-after.json"
  capture_operation_state "$before_state"
  if "$generation_root/scripts/rollback-global-skill-sync.sh" "$receipt" >/dev/null 2>&1; then
    printf 'generation rollback failed: installed %s drift was accepted\n' "$scenario" >&2
    exit 1
  fi
  capture_operation_state "$after_state"
  if ! cmp -s "$before_state" "$after_state"; then
    printf 'generation rollback failed: installed %s drift caused partial mutation\n' "$scenario" >&2
    exit 1
  fi
  if [[ -e "$backup/.rollback-displaced" || -L "$backup/.rollback-displaced" ]]; then
    printf 'generation rollback failed: installed %s drift created rollback displacement\n' "$scenario" >&2
    exit 1
  fi
  python3 - "$receipt" <<'PY'
import json
import sys
from pathlib import Path

if json.loads(Path(sys.argv[1]).read_text()).get("status") != "installed":
    raise SystemExit("rejected installed-state drift changed the receipt status")
PY
}

printf 'package drift\n' >"$target/accelerate/.rollback-drift-fixture"
assert_installed_drift_rejected_without_mutation package-content
rm -f -- "$target/accelerate/.rollback-drift-fixture"

printf '\n# runtime drift\n' >>"$codex_home/config.toml"
assert_installed_drift_rejected_without_mutation runtime-content
cp "$stage_root/expected-installed-config.toml" "$codex_home/config.toml"

mv "$target/accelerate" "$stage_root/missing-installed-accelerate"
assert_installed_drift_rejected_without_mutation replace-missing
mv "$stage_root/missing-installed-accelerate" "$target/accelerate"

delete_target="$(python3 - "$receipt" <<'PY'
import json
import sys
from pathlib import Path

receipt = json.loads(Path(sys.argv[1]).read_text())
for operation in receipt["operations"]:
    if operation["action"] == "delete":
        print(operation["target"])
        break
else:
    raise SystemExit("generation rollback fixture has no delete operation")
PY
)"
printf 'recreated deleted runtime target\n' >"$delete_target"
assert_installed_drift_rejected_without_mutation delete-recreated
rm -f -- "$delete_target"

diff -qr "$stage_root/expected-installed-target" "$target"
cmp -s "$stage_root/expected-installed-config.toml" "$codex_home/config.toml"

assert_receipt_mutation_rejected() {
  local mutation="$1"
  cp "$stage_root/clean-receipt.json" "$receipt"
  python3 - "$receipt" "$mutation" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
receipt = json.loads(path.read_text())
mutation = sys.argv[2]
if mutation == "rollback-command":
    receipt["rollback_command"] = ["/bin/bash", "/tmp/not-governed-rollback.sh", str(path.resolve())]
elif mutation == "denominator":
    receipt["generation"]["runtime_denominator"] = receipt["generation"]["runtime_denominator"][:-1]
elif mutation == "lane":
    receipt["operations"][0]["lane"] = "logical"
elif mutation == "source-path":
    receipt["generation"]["source_snapshots"]["catalog"]["path"] = "/tmp/not-governed-catalog.toml"
elif mutation == "path-type":
    receipt["operations"][0]["target"] = 7
else:
    raise SystemExit(f"unknown receipt mutation fixture: {mutation}")
path.write_text(json.dumps(receipt, indent=2) + "\n")
PY
  if "$generation_root/scripts/rollback-global-skill-sync.sh" "$receipt" >/dev/null 2>&1; then
    printf 'generation rollback failed: %s receipt mutation was accepted\n' "$mutation" >&2
    exit 1
  fi
  diff -qr "$stage_root/expected-installed-target" "$target"
}

for receipt_mutation in rollback-command denominator lane source-path path-type; do
  assert_receipt_mutation_rejected "$receipt_mutation"
done
cp "$stage_root/clean-receipt.json" "$receipt"

mv "$backup/packages/accelerate" "$stage_root/withheld-accelerate-backup"
if "$generation_root/scripts/rollback-global-skill-sync.sh" "$receipt" >/dev/null 2>&1; then
  printf 'generation rollback failed: missing backup was accepted\n' >&2
  exit 1
fi
diff -qr "$stage_root/expected-installed-target" "$target"
mv "$stage_root/withheld-accelerate-backup" "$backup/packages/accelerate"

printf 'groups = []\n' >"$generation_root/adapters/runtime/codex/skill-catalog-manifest.toml"
printf 'agents = []\n' >"$generation_root/adapters/runtime/codex/logical-agent-topology.toml"
mkdir -p "$generation_root/skills/runtime/future-generation-only"
printf '%s\n' '---' 'name: future-generation-only' 'description: Future denominator drift fixture.' '---' \
  >"$generation_root/skills/runtime/future-generation-only/SKILL.md"

python3 - "$receipt" <<'PY'
import json
import subprocess
import sys
from pathlib import Path

receipt = json.loads(Path(sys.argv[1]).read_text())
subprocess.run(receipt["rollback_command"], check=True)
PY
diff -qr "$stage_root/expected-original-target" "$target"
cmp -s "$stage_root/expected-original-config.toml" "$codex_home/config.toml"

python3 - "$receipt" <<'PY'
import json
import subprocess
import sys
from pathlib import Path

receipt_path = Path(sys.argv[1])
receipt = json.loads(receipt_path.read_text())
if receipt.get("status") != "rolled_back":
    raise SystemExit("rollback receipt did not reach rolled_back")
subprocess.run(receipt["rollback_command"], check=True)
if json.loads(receipt_path.read_text()).get("status") != "rolled_back":
    raise SystemExit("idempotent rollback changed terminal receipt state")
PY
diff -qr "$stage_root/expected-original-target" "$target"
cmp -s "$stage_root/expected-original-config.toml" "$codex_home/config.toml"

printf 'global skill sync generation rollback test passed\n'
