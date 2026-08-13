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
rg -n 'logical-agent-topology.toml' "$policy" >/dev/null || fail 'logical topology is not bound'
rg -n 'status: experimental' "$capabilities" >/dev/null || fail 'adapter must remain experimental'
rg -n 'allowed_tools:' "$capabilities" >/dev/null || fail 'capabilities must declare allowed tools'
rg -n 'suppressed_capabilities:' "$capabilities" >/dev/null || fail 'capabilities must declare suppressed capabilities'
rg -n 'codex-collaboration/role-policy.json' core/delegation/subagent-model.md agents/doctrine/selection-policy.md >/dev/null || fail 'selection is not integrated'
rg -n 'references/codex-collaboration-routing.md' global-runtime/accelerate/SKILL.md >/dev/null || fail 'runtime reference is not reachable'
rg -F 'An interruption is not a rollback.' adapters/runtime/codex-collaboration/README.md core/delegation/subagent-model.md >/dev/null || fail 'interruption boundary is missing'
rg -F 'Do not start a replacement writer until root has inspected and reconciled partial shared-filesystem changes.' adapters/runtime/codex-collaboration/README.md core/delegation/subagent-model.md >/dev/null || fail 'replacement writer reconciliation is missing'
rg -F 'Do not create a duplicate active lane' adapters/runtime/codex-collaboration/README.md core/delegation/subagent-model.md >/dev/null || fail 'duplicate active lane rule is missing'

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

if base["role_bindings"].get("research") != ["explorer", "librarian"]:
    raise SystemExit("research must bind exactly explorer and librarian")
for role, choices in base["role_bindings"].items():
    if role != "research" and ({"explorer", "librarian"} & set(choices)):
        raise SystemExit(f"research profile leaked into {role}")

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

def reject_cleanly(label, mutate):
    candidate = json.loads(json.dumps(base))
    mutate(candidate)
    target = tmp_dir / f"{label}.json"
    target.write_text(json.dumps(candidate))
    probe = subprocess.run(
        [sys.executable, str(validator), str(target)], capture_output=True, text=True
    )
    if probe.returncode == 0:
        raise SystemExit(f"validator accepted malformed case: {label}")
    if "Traceback" in probe.stderr or "Traceback" in probe.stdout:
        raise SystemExit(f"validator leaked traceback for malformed case: {label}")
    if "codex collaboration policy invalid:" not in probe.stderr:
        raise SystemExit(f"validator omitted governed diagnostic for malformed case: {label}")

reject("wildcard", lambda value: value["profiles"]["explorer"]["skill_allowlist"].append("*"))
reject("luna-high", lambda value: value["profiles"]["mechanical-fixer"].update(reasoning_effort="high"))
reject("direct-binding", lambda value: value["routes"]["direct-fast-path"].update(physical_binding_allowed=True))
reject("ungated-high", lambda value: value["profiles"]["high-stakes-review"].update(requires_reasoning_receipt=False))
reject("direct-fallback", lambda value: value["fallback"].append("root-direct-fast-path"))
reject("bound-other", lambda value: value["role_bindings"].update(other=["architecture-review"]))
reject("bound-provider-boundary", lambda value: value["role_bindings"]["provider-boundary"].append("architecture-review"))
reject("wide-scoped", lambda value: value["routes"]["scoped"].update(delegation_budget=99))
reject("disabled-orchestrated", lambda value: value["routes"]["orchestrated"].update(physical_binding_allowed=False))
reject("unbound-profile", lambda value: value["role_bindings"]["research"].remove("explorer"))
reject("orphan-profile", lambda value: value["profiles"].update({"orphan-probe": json.loads(json.dumps(value["profiles"]["explorer"]))}))
reject("missing-return-fields", lambda value: value["profiles"]["explorer"].pop("return_fields"))
reject("missing-root-closure-field", lambda value: value["profiles"]["explorer"]["return_fields"].remove("root_closure_boundary"))
reject("invalid-write-mode", lambda value: value["profiles"]["explorer"].update(write_mode="unbounded-write"))
reject("missing-explorer-answer", lambda value: value["profiles"]["explorer"]["return_fields"].remove("answer"))
reject("wrong-explorer-return-contract", lambda value: value["profiles"]["explorer"].update(return_contract="Task Execution Return Packet"))
reject("unexpected-explorer-return-field", lambda value: value["profiles"]["explorer"]["return_fields"].append("implementation"))
reject("interrupt-treated-as-rollback", lambda value: value["session_lifecycle"].update(interrupt_semantics="rollback"))
reject("interrupted-writer-without-reconciliation", lambda value: value["session_lifecycle"].update(interrupted_writer_reconciliation="replacement-without-reconciliation"))
reject("duplicate-active-lane", lambda value: value["session_lifecycle"].update(duplicate_active_lane="allowed"))
reject("authority-escalation", lambda value: value.update(authority_boundary="root-can-close"))
reject("implicit-reasoning-override", lambda value: value["binding"].update(reasoning_effort_override="inherit-parent"))
reject("global-skill-visibility", lambda value: value["binding"].update(skill_visibility="global-always-on"))
reject("global-mcp-visibility", lambda value: value["binding"].update(mcp_visibility="global-always-on"))
reject("close-issue-tool", lambda value: value["profiles"]["code-review"]["tool_policy"].append("close-issue"))
reject("tracker-write-skill", lambda value: value["profiles"]["code-review"]["skill_allowlist"].append("plane"))
reject("delivery-skill", lambda value: value["profiles"]["code-review"]["skill_allowlist"].append("github:yeet"))
reject("closure-eligibility", lambda value: value["profiles"]["code-review"]["eligibility"].append("may close issue after review"))
reject("unknown-policy-authority", lambda value: value.update(closure_authority=True))
reject("unknown-binding-authority", lambda value: value["binding"].update(root_authority=True))
reject("unknown-route-authority", lambda value: value["routes"]["scoped"].update(external_writes=True))
reject("unknown-profile-authority", lambda value: value["profiles"]["code-review"].update(closure_authority=True))
reject("unknown-profile-external-writes", lambda value: value["profiles"]["code-review"].update(external_writes=True))
reject("unknown-profile-tools", lambda value: value["profiles"]["code-review"].update(tools=["close-issue"]))
reject("unknown-profile-mcps", lambda value: value["profiles"]["code-review"].update(mcps=["plane"]))
reject("specialist-model-drift", lambda value: value["profiles"]["security-review"].update(model="gpt-5.6-luna", reasoning_effort="low"))
reject("specialist-effort-drift", lambda value: value["profiles"]["code-review"].update(model="gpt-5.6-luna"))
reject("specialist-sol-high-drift", lambda value: value["profiles"]["code-review"].update(model="gpt-5.6-sol", reasoning_effort="high", requires_reasoning_receipt=True))
reject("fallback-authority", lambda value: value["fallback"].append("root-can-close"))
reject("fallback-missing-scoped", lambda value: value["fallback"].remove("scoped-root-only"))
reject("boolean-schema-version", lambda value: value.update(schema_version=True))
reject("boolean-direct-budget", lambda value: value["routes"]["direct-fast-path"].update(delegation_budget=False))
reject("boolean-scoped-budget", lambda value: value["routes"]["scoped"].update(delegation_budget=True))
reject("integer-lifecycle-boolean", lambda value: value["session_lifecycle"].update(reuse_relevant_agent_context=1))
reject("integer-reasoning-receipt", lambda value: value["profiles"]["code-review"].update(requires_reasoning_receipt=0))
reject("integer-write-scope", lambda value: value["profiles"]["code-review"].update(requires_write_scope=0))
reject("integer-physical-binding", lambda value: value["routes"]["scoped"].update(physical_binding_allowed=1))
reject("float-schema-version", lambda value: value.update(schema_version=1.0))
reject_cleanly("missing-route-field", lambda value: value["routes"]["scoped"].pop("physical_binding_allowed"))
reject_cleanly("null-route", lambda value: value["routes"].update(scoped=None))
reject_cleanly("null-session-lifecycle", lambda value: value.update(session_lifecycle=None))
PY

printf 'codex collaboration policy tests passed\n'
