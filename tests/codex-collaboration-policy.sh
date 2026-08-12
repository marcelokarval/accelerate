#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'codex-collaboration-policy failed: %s\n' "$1" >&2
  exit 1
}

policy="adapters/runtime/codex-collaboration/role-policy.json"
adapter="adapters/runtime/codex-collaboration/README.md"
capabilities="adapters/runtime/codex-collaboration/capabilities.yaml"
validator="scripts/validate-codex-collaboration-policy.py"

for path in "$policy" "$adapter" "$capabilities" "$validator"; do
  [ -f "$path" ] || fail "missing $path"
done

python3 "$validator"
rg -n 'assignment-contract-only' "$adapter" "$capabilities" >/dev/null || fail 'missing honest tool-enforcement boundary'
rg -n 'never `direct-fast-path`' "$adapter" >/dev/null || fail 'direct route is not blocked'
rg -n 'never use `\*`' "$adapter" >/dev/null || fail 'wildcards are not prohibited'
rg -n 'status: experimental' "$capabilities" >/dev/null || fail 'adapter must remain experimental'
rg -n 'allowed_tools:' "$capabilities" >/dev/null || fail 'capabilities must declare allowed tools'
rg -n 'suppressed_capabilities:' "$capabilities" >/dev/null || fail 'capabilities must declare suppressed capabilities'
rg -n 'codex-collaboration/role-policy.json' core/delegation/subagent-model.md agents/doctrine/selection-policy.md >/dev/null || fail 'selection is not integrated'
rg -n 'references/codex-collaboration-routing.md' global-runtime/accelerate/SKILL.md >/dev/null || fail 'runtime reference is not reachable'

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

python3 - "$policy" "$validator" "$tmp_dir" <<'PY'
import json
import subprocess
import sys
from pathlib import Path

source = Path(sys.argv[1])
validator = Path(sys.argv[2])
tmp_dir = Path(sys.argv[3])
base = json.loads(source.read_text())

def reject(label, mutate):
    candidate = json.loads(json.dumps(base))
    mutate(candidate)
    target = tmp_dir / f"{label}.json"
    target.write_text(json.dumps(candidate))
    text = validator.read_text().replace(
        'POLICY_PATH = ROOT / "adapters/runtime/codex-collaboration/role-policy.json"',
        f'POLICY_PATH = Path({str(target)!r})',
    )
    probe = tmp_dir / f"{label}.py"
    probe.write_text(text)
    if subprocess.run([sys.executable, str(probe)], capture_output=True).returncode == 0:
        raise SystemExit(f"validator accepted invalid case: {label}")

reject("wildcard", lambda value: value["profiles"]["explorer"]["skill_allowlist"].append("*"))
reject("luna-high", lambda value: value["profiles"]["mechanical-fixer"].update(reasoning_effort="high"))
reject("direct-binding", lambda value: value["routes"]["direct-fast-path"].update(physical_binding_allowed=True))
reject("ungated-high", lambda value: value["profiles"]["high-stakes-review"].update(requires_reasoning_receipt=False))
reject("direct-fallback", lambda value: value["fallback"].append("root-direct-fast-path"))
reject("bound-other", lambda value: value["role_bindings"].update(other=["architecture-review"]))
reject("bound-provider-boundary", lambda value: value["role_bindings"]["provider-boundary"].append("architecture-review"))
reject("wide-scoped", lambda value: value["routes"]["scoped"].update(delegation_budget=99))
reject("disabled-orchestrated", lambda value: value["routes"]["orchestrated"].update(physical_binding_allowed=False))
PY

printf 'codex collaboration policy tests passed\n'
