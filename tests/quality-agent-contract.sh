#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

failures=0
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

run_case() {
  local id="$1" label="$2"
  shift 2
  if "$@" >"$tmp_dir/$id.out" 2>&1; then
    printf 'PASS %s %s\n' "$id" "$label"
  else
    printf 'RED  %s %s\n' "$id" "$label" >&2
    sed 's/^/     /' "$tmp_dir/$id.out" >&2
    failures=$((failures + 1))
  fi
}

need_file() { [ -f "$1" ] || { printf 'missing %s\n' "$1" >&2; return 1; }; }
need_pattern() {
  need_file "$2" || return 1
  rg -ni "$1" "$2" >/dev/null || { printf 'missing pattern %s in %s\n' "$1" "$2" >&2; return 1; }
}

common_template_contract() {
  local path="$1"
  need_file "$path" || return 1
  for marker in '../base-agent-contract.md' 'selected role family:' 'Required Skills / Profiles' 'Prohibited Authority' 'Return Contract' 'Cleanup Behavior' 'self-review' 'self-forensic' 'root-owned'; do
    need_pattern "$marker" "$path" || return 1
  done
}

policy_profile_rejects() {
  local profile="$1" mutation="$2"
  python3 - adapters/runtime/codex-collaboration/role-policy.json scripts/validate-codex-collaboration-policy.py "$tmp_dir" "$profile" "$mutation" <<'PY'
import copy
import json
import subprocess
import sys
from pathlib import Path

policy_path, validator_path, target_dir, profile_name, mutation = sys.argv[1:]
value = json.loads(Path(policy_path).read_text())
profile = value.get("profiles", {}).get(profile_name)
if not profile:
    raise SystemExit(f"missing profile {profile_name}")
candidate = copy.deepcopy(value)
target_profile = candidate["profiles"][profile_name]
if mutation == "remove-security-evidence":
    target_profile["return_fields"].remove("negative_proof")
elif mutation == "allow-test-writer-self-review":
    target_profile.update(write_mode="bounded-write", requires_write_scope=True)
elif mutation == "remove-metric-sources":
    target_profile["return_fields"].remove("metric_sources")
else:
    raise SystemExit(f"unknown mutation {mutation}")
target = Path(target_dir) / f"{profile_name}-{mutation}.json"
target.write_text(json.dumps(candidate))
probe = subprocess.run([sys.executable, validator_path, str(target)], capture_output=True, text=True)
if probe.returncode == 0:
    raise SystemExit(f"validator accepted invalid {profile_name} mutation {mutation}")
PY
}

case_agent_001() {
  for path in \
    agents/templates/specification-engineer.md \
    agents/templates/code-reviewer.md \
    agents/templates/test-engineer.md \
    agents/templates/security-reviewer.md \
    agents/templates/web-performance-auditor.md; do
    common_template_contract "$path" || return 1
  done
  for capability in specification-engineer code-quality-reviewer test-engineer web-performance-auditor; do
    need_pattern "$capability" agents/doctrine/capability-matrix.md || return 1
  done
}

case_agent_002() {
  need_pattern 'template-only' agents/templates/README.md || return 1
  need_pattern 'empirical replay' agents/templates/README.md || return 1
  need_pattern 'configuration is not isolation|configuration.*does not.*prove.*isolation' agents/templates/README.md || return 1
  if rg -n 'physical promotion: *(complete|promoted)|isolation: *proven' agents/templates >/dev/null; then
    printf 'template overclaims promotion or isolation\n' >&2
    return 1
  fi
}

case_agent_003() {
  python3 scripts/validate-codex-collaboration-policy.py || return 1
  python3 - adapters/runtime/codex-collaboration/role-policy.json <<'PY'
import json
import sys
from pathlib import Path

policy = json.loads(Path(sys.argv[1]).read_text())
expected = {
    "specification-review": "architecture",
    "code-review": "governance",
    "test-strategy": "qa-regression",
    "security-review": "security",
    "web-performance-review": "product-runtime",
}
required = {"requested_vs_implemented", "evidence", "self_review", "self_forensic_review", "defects", "residual_risks", "root_closure_boundary"}
for profile, role in expected.items():
    value = policy.get("profiles", {}).get(profile)
    if not value:
        raise SystemExit(f"missing profile {profile}")
    if value.get("write_mode") != "read-only" or value.get("requires_write_scope") is not False:
        raise SystemExit(f"profile is not fail-closed read-only: {profile}")
    if profile not in policy.get("role_bindings", {}).get(role, []):
        raise SystemExit(f"profile {profile} is not bound to {role}")
    missing = required - set(value.get("return_fields", []))
    if missing:
        raise SystemExit(f"profile {profile} misses return fields {sorted(missing)}")
    if any(item == "*" for field in ("skills", "tools", "mcps") for item in value.get(field, [])):
        raise SystemExit(f"profile {profile} has wildcard capability")
PY
  local policy_status=$?
  [ "$policy_status" -eq 0 ] || return 1
  if rg -n 'closure_authority\s*=\s*true' adapters/runtime/codex/logical-agent-topology.toml | tail -n +2 | grep -q .; then
    printf 'non-root logical agent claims closure authority\n' >&2
    return 1
  fi
}

case_sec_001() {
  local path=agents/templates/security-reviewer.md
  for marker in 'trust boundar' 'STRIDE' 'supply.chain' 'exploitability' 'safe PoC' 'negative proof' 'variant'; do
    need_pattern "$marker" "$path" || return 1
  done
  python3 scripts/validate-codex-collaboration-policy.py || return 1
  policy_profile_rejects security-review remove-security-evidence || return 1
  local skill=skills/security/security-patterns/SKILL.md
  for marker in 'trust boundar' 'STRIDE' 'supply.chain' 'exploitability' 'safe PoC' 'negative proof' 'abuse.*variant'; do
    need_pattern "$marker" "$skill" || return 1
  done
  need_file skills/security/security-patterns/agents/openai.yaml || return 1
  need_file skills/security/security-patterns/evals/evals.json || return 1
  need_file skills/security/security-patterns/references/threat-review-contract.md || return 1
  need_pattern 'does not duplicate.*security reviewer|security reviewer.*authority' "$skill" || return 1
  printf '%s  %s\n' \
    '23b1134fb11b2e911d8485f9f66f0ff8d77ec4d866d26677793ddba77c70f2f8' \
    skills/security/security-patterns/references/full-procedure.md | sha256sum -c - || return 1
}

case_qa_001() {
  local path=agents/templates/test-engineer.md
  need_pattern 'test-design.*regression-proof' "$path" || return 1
  need_pattern 'lowest effective' "$path" || return 1
  need_pattern 'loses independent review authority' "$path" || return 1
  need_pattern 'test-only' "$path" || return 1
  python3 scripts/validate-codex-collaboration-policy.py || return 1
  policy_profile_rejects test-strategy allow-test-writer-self-review || return 1
}

case_perf_001() {
  local path=agents/templates/web-performance-auditor.md
  need_pattern 'quick-static.*deep-measured' "$path" || return 1
  need_pattern 'source.*metric|metric.*source' "$path" || return 1
  need_pattern 'unmeasured' "$path" || return 1
  need_pattern 'CrUX.*Lighthouse.*trace|Lighthouse.*CrUX.*trace' "$path" || return 1
  python3 scripts/validate-codex-collaboration-policy.py || return 1
  policy_profile_rejects web-performance-review remove-metric-sources || return 1
}

run_case CASE-AGENT-001 'bounded specialist templates and capability mappings exist' case_agent_001
run_case CASE-AGENT-002 'template presence does not claim promotion or isolation' case_agent_002
run_case CASE-AGENT-003 'profiles are read-only, explicit and return complete packets' case_agent_003
run_case CASE-SEC-001 'security review covers threat, exploit and provenance evidence' case_sec_001
run_case CASE-QA-001 'test writer and independent reviewer authority stay separated' case_qa_001
run_case CASE-PERF-001 'web performance metrics remain source-labelled and honest' case_perf_001

if [ "$failures" -ne 0 ]; then
  printf 'quality agent contract: %s case(s) failed\n' "$failures" >&2
  exit 1
fi

printf 'quality agent contract passed (6 cases)\n'
