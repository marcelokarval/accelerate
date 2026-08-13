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

case_rev_001() {
  need_file skills/review/code-audit/references/review-axes.md
  for axis in correctness legibility architecture security performance tests 'verification story'; do
    need_pattern "$axis" skills/review/code-audit/references/review-axes.md || return 1
  done
}

case_rev_002() {
  local skill=skills/review/code-audit/SKILL.md
  need_pattern 'severity.*impact|impact.*severity' "$skill" || return 1
  need_pattern 'reach' "$skill" || return 1
  need_pattern 'exploitability' "$skill" || return 1
  need_pattern 'candidate signal' "$skill" || return 1
  if rg -n 'P0[^\n]*Security|P1[^\n]*Architecture|P2[^\n]*Maintainability|P3[^\n]*Documentation|Every domain app must have `services/`|Files >400 lines|COMMIT BLOCKED' "$skill" >/dev/null; then
    printf 'category-derived severity or universal heuristic remains\n' >&2
    return 1
  fi
}

case_rev_003() {
  local schema=skills/review/code-audit/references/review-finding-schema.md
  local validator=scripts/validate-review-finding.py
  for field in location category 'affected behavior' scenario evidence confidence severity correction proof 'false-positive' waiver; do
    need_pattern "$field" "$schema" || return 1
  done
  need_file "$validator" || return 1
  python3 - "$tmp_dir" <<'PY'
import json
import sys
from pathlib import Path

target = Path(sys.argv[1])
valid = {
    "id": "FINDING-001", "location": "path.py:10", "category": "correctness",
    "affected_behavior": "reject invalid state", "failure_scenario": "invalid state is persisted",
    "evidence": ["test:tests/test_review.py::test_invalid_state"],
    "confidence": "high", "severity": "P1",
    "severity_rationale": {
        "impact": "invalid state persists and violates the domain integrity contract",
        "reach": "all callers share the affected transition boundary",
        "reproducibility": "the focused negative test fails deterministically before correction",
        "exploitability_basis": "no hostile actor path is required for this integrity defect",
    },
    "exploitability": {
        "status": "not-applicable",
        "rationale": "the correctness defect has no hostile actor or trust-boundary path",
    },
    "finding_state": "confirmed", "correction": "validate at boundary",
    "required_proof": ["test:tests/test_review.py::test_rejects_invalid_state"],
    "false_positive_disposition": "inspected-confirmed", "waiver": None,
}
(target / "valid-finding.json").write_text(json.dumps(valid))
valid_candidate = dict(valid); valid_candidate.update(
    id="FINDING-CANDIDATE-001", finding_state="candidate",
    false_positive_disposition="candidate remains unconfirmed pending evidence inspection")
(target / "valid-candidate.json").write_text(json.dumps(valid_candidate))
valid_rejected = dict(valid); valid_rejected.update(
    id="FINDING-REJECTED-001", finding_state="rejected",
    false_positive_disposition="rejected as a false positive after focused proof disproved affected behavior")
(target / "valid-rejected.json").write_text(json.dumps(valid_rejected))
valid_waived = dict(valid); valid_waived.update(
    id="FINDING-WAIVED-001", finding_state="waived",
    false_positive_disposition="accepted exception and waived by the root reviewer",
    waiver={"reason": "bounded compatibility exception for a legacy caller",
            "approver": "independent root reviewer", "expires": "2999-12-31",
            "residual_risk": "legacy caller retains the documented integrity exposure"})
(target / "valid-waived.json").write_text(json.dumps(valid_waived))
invalid = dict(valid)
invalid.pop("evidence")
(target / "invalid-finding.json").write_text(json.dumps(invalid))

mutations = {}
value = dict(valid); value["unexpected"] = "accepted by weak schemas"; mutations["unknown-key"] = value
value = dict(valid); value["confidence"] = "HIGH"; mutations["noncanonical-confidence"] = value
value = dict(valid); value["severity"] = "p3"; mutations["noncanonical-severity"] = value
value = dict(valid); value["correction"] = "x"; mutations["trivial-content"] = value
value = dict(valid); value["location"] = "x"; mutations["trivial-location"] = value
value = dict(valid); value["evidence"] = ["test:abcdefgh"]; mutations["placeholder-evidence"] = value
value = dict(valid); value["required_proof"] = ["test:abcdefgh"]; mutations["placeholder-proof"] = value
value = dict(valid); value["exploitability"] = "not-applicable"; mutations["bare-not-applicable"] = value
value = dict(valid); value["finding_state"] = "accepted"; mutations["noncanonical-state"] = value
value = dict(valid); value["finding_state"] = "candidate"; mutations["candidate-with-confirmed-disposition"] = value
value = dict(valid); value["finding_state"] = "rejected"; mutations["rejected-with-confirmed-disposition"] = value
value = dict(valid); value["finding_state"] = "waived"; mutations["waived-without-waiver"] = value
value = dict(valid); value["finding_state"] = "confirmed"; value["waiver"] = {
    "reason": "bounded compatibility exception", "approver": "root reviewer",
    "expires": "2026-12-31", "residual_risk": "legacy callers remain exposed",
}; mutations["waiver-without-waived-state"] = value
value = dict(valid); value["finding_state"] = "waived"; value["waiver"] = {
    "reason": "bounded compatibility exception", "approver": "root reviewer",
    "expires": "2026-08-13", "residual_risk": "legacy callers remain exposed",
}; mutations["expired-waiver"] = value
value = dict(valid); value["finding_state"] = "waived"; value["waiver"] = {
    "reason": "bounded compatibility exception", "approver": "root reviewer",
    "expires": "tomorrow", "residual_risk": "legacy callers remain exposed",
}; mutations["malformed-waiver-date"] = value
value = dict(valid); value.update({
    "location": "xxx", "category": "foobar", "severity": "P0",
    "evidence": ["abcdefgh"],
    "severity_rationale": {
        "impact": "generic rationale without concrete observed impact",
        "reach": "generic rationale without a bounded affected population",
        "reproducibility": "generic rationale without a reproducible scenario",
        "exploitability_basis": "generic rationale without exploitability analysis",
    },
    "exploitability": {
        "status": "exploitable",
        "rationale": "generic rationale without an attacker path",
    },
}); mutations["placeholder-p0"] = value
value = dict(valid); value["severity_rationale"] = {
    "impact": "generic placeholder rationale without concrete evidence",
    "reach": "generic placeholder rationale without concrete evidence",
    "reproducibility": "generic placeholder rationale without concrete evidence",
    "exploitability_basis": "generic placeholder rationale without concrete evidence",
}; mutations["generic-rationale"] = value
value = dict(valid); value["exploitability"] = {
    "status": "not-applicable",
    "rationale": "an authenticated hostile actor can cross the ownership boundary",
}; mutations["contradictory-not-applicable"] = value
value = dict(valid); value["exploitability"] = {
    "status": "exploitable",
    "rationale": "no hostile actor or trust boundary path exists for this defect",
}; mutations["contradictory-exploitable"] = value
value = dict(valid); value["severity_rationale"] = dict(valid["severity_rationale"]); value["severity_rationale"]["exploitability_basis"] = "no hostile actor path applies in the baseline but a hostile tenant actor has a direct attack path through missing authorization"; value["exploitability"] = {
    "status": "not-applicable",
    "rationale": "no hostile actor path applies in the baseline but a hostile tenant actor can control the target across the authorization boundary",
}; mutations["mixed-not-applicable"] = value
value = dict(valid); value["severity_rationale"] = dict(valid["severity_rationale"]); value["severity_rationale"]["exploitability_basis"] = "no hostile actor path applies except a hostile tenant actor can directly attack the missing authorization boundary"; value["exploitability"] = {
    "status": "not-applicable",
    "rationale": "no hostile actor path applies unless a hostile tenant actor can control the target across the authorization boundary",
}; mutations["except-unless-not-applicable"] = value
value = dict(valid); value["severity_rationale"] = dict(valid["severity_rationale"]); value["severity_rationale"]["exploitability_basis"] = "no hostile actor path exists because a hostile tenant actor can directly attack the missing authorization boundary"; value["exploitability"] = {
    "status": "not-applicable",
    "rationale": "no hostile actor path applies because a hostile tenant actor can control the target across the authorization boundary",
}; mutations["because-not-applicable"] = value
value = dict(valid); value["severity_rationale"] = dict(valid["severity_rationale"]); value["severity_rationale"]["exploitability_basis"] = "no hostile actor path exists because an unauthenticated tenant directly accesses another user record through missing authorization"; value["exploitability"] = {
    "status": "not-applicable",
    "rationale": "no hostile actor path applies because an external tenant selects a target across the missing authorization boundary",
}; mutations["tenant-subject-not-applicable"] = value
value = dict(valid); value["severity_rationale"] = dict(valid["severity_rationale"]); value["severity_rationale"]["exploitability_basis"] = "no hostile actor path exists because a malicious adversary can bypass authorization and read another user record"; value["exploitability"] = {
    "status": "not-applicable",
    "rationale": "no hostile actor path applies because an external adversary directly modifies a target across the missing authorization boundary",
}; mutations["adversary-subject-not-applicable"] = value
value = dict(valid); value["severity_rationale"] = dict(valid["severity_rationale"]); value["severity_rationale"]["exploitability_basis"] = "no hostile actor path exists because an authenticated user directly accesses another user record through missing authorization"; value["exploitability"] = {
    "status": "not-applicable",
    "rationale": "no hostile actor path applies because an authenticated user selects a target across the missing authorization boundary",
}; mutations["authenticated-user-not-applicable"] = value
value = dict(valid); value["severity_rationale"] = dict(valid["severity_rationale"]); value["severity_rationale"]["exploitability_basis"] = "no hostile actor path exists because a customer directly accesses another user record through missing authorization"; value["exploitability"] = {
    "status": "not-applicable",
    "rationale": "no hostile actor path applies because a customer selects a target across the missing authorization boundary",
}; mutations["customer-not-applicable"] = value
value = dict(valid); value["severity_rationale"] = dict(valid["severity_rationale"]); value["severity_rationale"]["exploitability_basis"] = "no hostile actor path exists because a workspace member directly accesses another user record through missing authorization"; value["exploitability"] = {
    "status": "not-applicable",
    "rationale": "no hostile actor path applies because a workspace member selects a target across the missing authorization boundary",
}; mutations["workspace-member-not-applicable"] = value
value = dict(valid); value["severity_rationale"] = dict(valid["severity_rationale"]); value["severity_rationale"]["exploitability_basis"] = "no hostile actor path exists because a requester directly accesses another user record through missing authorization"; value["exploitability"] = {
    "status": "not-applicable",
    "rationale": "no hostile actor path applies because a requester selects a target across the missing authorization boundary",
}; mutations["requester-not-applicable"] = value
for name, value in mutations.items():
    (target / f"invalid-{name}.json").write_text(json.dumps(value))

duplicate = [dict(valid), dict(valid)]
(target / "invalid-duplicate-within.json").write_text(json.dumps(duplicate))
(target / "duplicate-across-a.json").write_text(json.dumps(valid))
(target / "duplicate-across-b.json").write_text(json.dumps(valid))
PY
  python3 "$validator" "$tmp_dir/valid-finding.json" || return 1
  python3 "$validator" "$tmp_dir/valid-candidate.json" || return 1
  python3 "$validator" "$tmp_dir/valid-rejected.json" || return 1
  python3 "$validator" "$tmp_dir/valid-waived.json" || return 1
  if python3 "$validator" "$tmp_dir/invalid-finding.json"; then
    printf 'finding validator accepted missing evidence\n' >&2
    return 1
  fi
  local fixture
  for fixture in \
    invalid-unknown-key invalid-noncanonical-confidence invalid-noncanonical-severity \
    invalid-trivial-content invalid-trivial-location invalid-placeholder-evidence invalid-placeholder-proof \
    invalid-bare-not-applicable \
    invalid-noncanonical-state invalid-candidate-with-confirmed-disposition \
    invalid-rejected-with-confirmed-disposition invalid-waived-without-waiver \
    invalid-waiver-without-waived-state \
    invalid-expired-waiver invalid-malformed-waiver-date invalid-placeholder-p0 invalid-generic-rationale \
    invalid-contradictory-not-applicable invalid-contradictory-exploitable \
    invalid-mixed-not-applicable invalid-except-unless-not-applicable \
    invalid-because-not-applicable invalid-tenant-subject-not-applicable \
    invalid-adversary-subject-not-applicable invalid-authenticated-user-not-applicable \
    invalid-customer-not-applicable invalid-workspace-member-not-applicable \
    invalid-requester-not-applicable \
    invalid-duplicate-within; do
    if python3 "$validator" "$tmp_dir/$fixture.json"; then
      printf 'finding validator accepted adversarial fixture %s\n' "$fixture" >&2
      return 1
    fi
  done
  if python3 "$validator" "$tmp_dir/duplicate-across-a.json" "$tmp_dir/duplicate-across-b.json"; then
    printf 'finding validator accepted duplicate IDs across files\n' >&2
    return 1
  fi
  python3 - "$schema" "$tmp_dir/documented-example.json" <<'PY'
import json
import re
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text()
blocks = re.findall(r"```json\s*(\{.*?\})\s*```", text, re.S)
if len(blocks) != 1:
    raise SystemExit("review finding schema must contain exactly one JSON example")
Path(sys.argv[2]).write_text(json.dumps(json.loads(blocks[0])))
PY
  python3 "$validator" "$tmp_dir/documented-example.json" || return 1
}

case_rev_004() {
  local skill=skills/review/requesting-code-review/SKILL.md
  need_pattern 'docs.*config.*workflow' "$skill" || return 1
  need_pattern 'does not authorize commit' "$skill" || return 1
  if rg -n 'Skip for:[^\n]*documentation|git stash|git reset|git commit|git add -A|\[verified\]' "$skill" >/dev/null; then
    printf 'review still skips governed surfaces or mutates git state\n' >&2
    return 1
  fi
  need_pattern 'GitHub.*published.*PR|published.*PR.*GitHub' "$skill" || return 1
  need_pattern 'github-code-review' "$skill" || return 1
  need_pattern 'github-code-review' skills/review/requesting-code-review/evals/evals.json || return 1
  need_pattern 'security-patterns' skills/review/code-audit/SKILL.md || return 1
  need_pattern 'browser QA' skills/review/test-engineering/SKILL.md || return 1
  need_pattern 'browser QA' skills/review/web-performance-review/SKILL.md || return 1
  for browser_skill in skills/review/test-engineering/SKILL.md skills/review/web-performance-review/SKILL.md; do
    need_pattern 'product-browser-qa' "$browser_skill" || return 1
    need_pattern 'product-runtime-review' "$browser_skill" || return 1
    need_pattern 'dogfood' "$browser_skill" || return 1
  done
  for browser_evals in skills/review/test-engineering/evals/evals.json skills/review/web-performance-review/evals/evals.json; do
    need_pattern 'product-browser-qa' "$browser_evals" || return 1
    need_pattern 'product-runtime-review' "$browser_evals" || return 1
    need_pattern 'dogfood' "$browser_evals" || return 1
  done
  need_pattern 'security-patterns|security review' skills/review/solution-minimalism/SKILL.md || return 1
  printf '%s  %s\n' \
    '29b59f01d85594886d92a6f5fb3c062b600bb2089b22f506d859f2fb73d77d62' \
    skills/review/code-audit/references/full-procedure.md | sha256sum -c - || return 1
  printf '%s  %s\n' \
    '6876aa0782d41b43235affff327a0ed4917544b2949d624d5a8f398160b99573' \
    skills/review/requesting-code-review/references/full-procedure.md | sha256sum -c - || return 1
}

case_lean_001() {
  local path=skills/review/solution-minimalism/references/decision-ladder.md
  for step in 'real need' 'project reuse' 'standard library' 'native platform' 'approved.*dependency' 'smallest legible'; do
    need_pattern "$step" "$path" || return 1
  done
}

case_lean_002() {
  local skill=skills/review/solution-minimalism/SKILL.md
  need_pattern 'post-spec.*post-green' "$skill" || return 1
  for guard in security authorization observability rollback accessibility compatibility proof; do
    need_pattern "$guard" "$skill" || return 1
  done
}

case_lean_003() {
  need_pattern 'upgrade trigger' skills/review/solution-minimalism/references/decision-ladder.md || return 1
  need_pattern 'line count|LOC' skills/review/solution-minimalism/SKILL.md || return 1
  need_pattern 'strictly read-only|read-only.*review' skills/review/solution-minimalism/SKILL.md || return 1
  need_pattern 'separate executor' skills/review/solution-minimalism/SKILL.md || return 1
  need_pattern 'bounded correction packet' skills/review/solution-minimalism/SKILL.md || return 1
  if rg -ni 'keep the write scope bounded|run the proof.*after the change' skills/review/solution-minimalism/SKILL.md skills/review/solution-minimalism/evals/evals.json >/dev/null; then
    printf 'minimalism review still implies a write lane\n' >&2
    return 1
  fi
}

quality_skills=(
  skills/workflow/specification-lifecycle
  skills/workflow/test-driven-development
  skills/review/test-engineering
  skills/review/source-verification
  skills/review/solution-minimalism
  skills/review/web-performance-review
  skills/review/code-audit
  skills/review/requesting-code-review
  skills/security/security-patterns
)

case_skill_001() {
  for dir in "${quality_skills[@]}"; do
    local skill="$dir/SKILL.md" folder
    folder="$(basename "$dir")"
    need_file "$skill" || return 1
    need_file "$dir/metadata.yaml" || return 1
    need_file "$dir/agents/openai.yaml" || return 1
    need_file "$dir/evals/evals.json" || return 1
    need_pattern "^name: ${folder}$" "$skill" || return 1
    need_pattern '^description: ' "$skill" || return 1
    [ "$(wc -l < "$skill")" -le 220 ] || { printf '%s exceeds 220 lines\n' "$skill" >&2; return 1; }
    [ "$(wc -c < "$skill")" -le 10240 ] || { printf '%s exceeds 10KB\n' "$skill" >&2; return 1; }
    [ ! -f "$dir/README.md" ] || { printf 'forbidden README in %s\n' "$dir" >&2; return 1; }
    if find "$dir" \( -type d -name __pycache__ -o -type f -name '*.pyc' \) | grep -q .; then
      printf 'generated cache in %s\n' "$dir" >&2
      return 1
    fi
    need_pattern "[|] \`${folder}\` [|]" skills/_registry/manifest.md || return 1
  done
  bash scripts/validate-skill-registry.sh
}

case_skill_002() {
  local brownfield="$tmp_dir/brownfield"
  mkdir -p "$brownfield"
  git -C "$brownfield" init -q || return 1
  git -C "$brownfield" config user.name 'Quality Fixture' || return 1
  git -C "$brownfield" config user.email 'quality-fixture@example.invalid' || return 1
  printf 'baseline\n' >"$brownfield/tracked.txt"
  git -C "$brownfield" add tracked.txt || return 1
  git -C "$brownfield" commit -qm baseline || return 1
  printf 'user-owned change\n' >"$brownfield/tracked.txt"
  [ -n "$(git -C "$brownfield" status --porcelain)" ] || {
    printf 'brownfield fixture is unexpectedly clean\n' >&2
    return 1
  }
  need_file scripts/validate-quality-skill-evals.py || return 1
  need_file skills/_registry/quality-skill-reviewed-snapshot.json || return 1
  need_pattern 'reviewed package integrity|package-integrity' skills/_registry/README.md || return 1
  need_pattern 'not proof of LLM behavior|not-llm-behavior' \
    skills/_registry/README.md skills/_registry/quality-skill-reviewed-snapshot.json || return 1
  python3 scripts/validate-quality-skill-evals.py \
    --brownfield-repo "$brownfield" "${quality_skills[@]}" || return 1

  python3 - scripts/validate-quality-skill-evals.py "$tmp_dir" \
    skills/review/test-engineering <<'PY'
import json
import shutil
import subprocess
import sys
from pathlib import Path

validator, target_root, source = Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])

def rejected(name, mutate):
    target = target_root / f"quality-eval-{name}" / source.name
    shutil.copytree(source, target)
    mutate(target)
    result = subprocess.run([sys.executable, str(validator), str(target)], capture_output=True, text=True)
    if result.returncode == 0:
        raise SystemExit(f"quality eval validator accepted adversarial fixture {name}")

def rejected_with(name, mutate, marker):
    target = target_root / f"quality-eval-{name}" / source.name
    shutil.copytree(source, target)
    mutate(target)
    result = subprocess.run([sys.executable, str(validator), str(target)], capture_output=True, text=True)
    output = f"{result.stdout}\n{result.stderr}".lower()
    if result.returncode == 0:
        raise SystemExit(f"quality eval validator accepted adversarial fixture {name}")
    if marker.lower() not in output:
        raise SystemExit(
            f"quality eval validator rejected {name} for the wrong reason: {output.strip()}"
        )

rejected("empty-metadata", lambda d: (d / "metadata.yaml").write_text(""))
rejected("unknown-metadata-key", lambda d: (d / "metadata.yaml").write_text((d / "metadata.yaml").read_text() + "unexpected: true\n"))
rejected("invalid-metadata-type", lambda d: (d / "metadata.yaml").write_text((d / "metadata.yaml").read_text().replace("runtime_export: optional", "runtime_export: true")))
rejected("category-path-mismatch", lambda d: (d / "metadata.yaml").write_text((d / "metadata.yaml").read_text().replace("category: review", "category: security")))
rejected("nonsense-status", lambda d: (d / "metadata.yaml").write_text((d / "metadata.yaml").read_text().replace("status: native", "status: nonsense")))
rejected("missing-local-owner", lambda d: (d / "metadata.yaml").write_text((d / "metadata.yaml").read_text().replace("local_native_owner: core/review/", "local_native_owner: missing/not-real.md")))
rejected("global-first", lambda d: (d / "metadata.yaml").write_text((d / "metadata.yaml").read_text().replace("sync_policy: repo-first", "sync_policy: global-first")))
rejected("future-last-reviewed", lambda d: (d / "metadata.yaml").write_text((d / "metadata.yaml").read_text() + "last_reviewed: 2999-01-01\n"))
rejected("invalid-openai", lambda d: (d / "agents/openai.yaml").write_text("interface: {}\n"))
rejected("unknown-openai-key", lambda d: (d / "agents/openai.yaml").write_text((d / "agents/openai.yaml").read_text() + "unexpected: true\n"))
rejected("empty-dir", lambda d: (d / "assets").mkdir())
rejected("scripts-readme", lambda d: ((d / "scripts").mkdir(), (d / "scripts/README.md").write_text("# Scripts\n")))
rejected("broken-reference", lambda d: (d / "SKILL.md").write_text((d / "SKILL.md").read_text() + "\n[missing](references/missing.md)\n"))
rejected("unreferenced-reference", lambda d: (d / "references/orphan.md").write_text("# Orphan\n\nNot routed.\n"))
rejected("unreferenced-text-resource", lambda d: (d / "references/orphan.txt").write_text("unrouted reference resource\n"))
def nested_reference(d):
    nested = d / "references/nested"
    nested.mkdir()
    (nested / "deep.md").write_text("# Deep reference\n\nNested content.\n")
    (d / "SKILL.md").write_text((d / "SKILL.md").read_text() + "\n[deep](references/nested/deep.md)\n")
rejected("nested-reference", nested_reference)
def minimal_skill(d):
    (d / "SKILL.md").write_text("---\nname: test-engineering\ndescription: x\n---\n")
    shutil.rmtree(d / "references")
rejected("minimal-skill", minimal_skill)
def culinary_skill(d):
    (d / "SKILL.md").write_text("""---
name: test-engineering
description: Prepare elaborate seasonal meals with careful ingredient selection, knife technique, heat control, plating, and service timing for a professional kitchen workflow. Test strategy.
---

# Seasonal Kitchen Service

Plan a complete dinner by selecting fresh produce, balancing salt and acidity,
preparing sauces, controlling oven temperature, resting proteins, arranging
plates, coordinating courses, and serving each guest at the correct moment.
Document ingredient substitutions, allergy notes, preparation order, equipment,
holding temperatures, garnish choices, cleanup duties, and leftover storage.
Repeat the tasting process before service and adjust seasoning with restraint.
Test strategy.
""")
    shutil.rmtree(d / "references")
rejected("culinary-skill", culinary_skill)
rejected("unknown-eval-key", lambda d: (lambda p, v: (v[0].update(extra="x"), p.write_text(json.dumps(v))))(d / "evals/evals.json", json.loads((d / "evals/evals.json").read_text())))
rejected("invalid-eval-type", lambda d: (lambda p, v: (v[0].update(should_trigger=1), p.write_text(json.dumps(v))))(d / "evals/evals.json", json.loads((d / "evals/evals.json").read_text())))
rejected("missing-interface-prompt", lambda d: (d / "agents/openai.yaml").write_text('interface:\n  display_name: "Test Engineering"\n  short_description: "Design strategy and assess test proof"\n  default_prompt: "Design a test strategy."\n'))

def role_separated_filler(d):
    roles = ("positive", "negative", "collision", "brownfield", "pressure", "behavioral")
    cases = []
    for index, role in enumerate(roles):
        cases.append({
            "id": f"{role}-ordinary-{index}",
            "prompt": f"{role} ordinary alpha beta gamma delta epsilon zeta engineering words",
            "should_trigger": role != "negative",
            "expected_behavior": f"{'route' if role == 'collision' else 'preserve' if role == 'brownfield' else 'resist' if role == 'pressure' else 'perform'} ordinary eta theta iota kappa lambda mu behavior",
        })
    (d / "evals/evals.json").write_text(json.dumps(cases))
rejected("role-separated-filler", role_separated_filler)

def semantic_substring_filler(d):
    roles = ("positive", "negative", "collision", "brownfield", "pressure", "behavioral")
    cases = []
    for index, role in enumerate(roles):
        prompt = f"{role} contest ordinary alpha beta gamma delta epsilon zeta engineering words"
        if role == "brownfield":
            prompt = "brownfield contest existing ordinary alpha beta gamma delta epsilon words"
        if role == "pressure":
            prompt = "deadline pressure contest ordinary alpha beta gamma delta epsilon words"
        action = "route" if role == "collision" else "preserve" if role == "brownfield" else "resist" if role == "pressure" else "perform"
        cases.append({
            "id": f"{role}-contest-{index}", "prompt": prompt,
            "should_trigger": role != "negative",
            "expected_behavior": f"{action} contest ordinary eta theta iota kappa lambda mu behavior",
        })
    (d / "evals/evals.json").write_text(json.dumps(cases))
rejected("semantic-substring-filler", semantic_substring_filler)

def unique_lexical_filler(d):
    cases = [
        {"id": "positive-lexical-1", "prompt": "Arrange a luminous harbor mosaic test with amber copper silver stones today", "should_trigger": True, "expected_behavior": "Perform ordinary velvet cedar marble lantern actions with no operational meaning"},
        {"id": "negative-lexical-2", "prompt": "Describe a silent alpine meadow test with violet clouds and distant bells", "should_trigger": False, "expected_behavior": "Treat ordinary meadow language as outside without activating meaningful ownership"},
        {"id": "collision-lexical-3", "prompt": "Collision orchard compass river test with crimson leaves and wooden gates", "should_trigger": True, "expected_behavior": "Route ordinary orchard material toward an adjacent owner without naming one"},
        {"id": "brownfield-lexical-4", "prompt": "Brownfield dirty archive test contains bronze ribbons old maps and unrelated parchment", "should_trigger": True, "expected_behavior": "Preserve unrelated archive state and baseline while performing ordinary catalog words"},
        {"id": "pressure-lexical-5", "prompt": "Deadline pressure requests a sapphire observatory test with urgent celestial decoration", "should_trigger": True, "expected_behavior": "Resist ordinary decoration pressure while preserving an unnamed invariant and schedule"},
        {"id": "behavioral-lexical-6", "prompt": "A turquoise compass test rotates beside six ivory markers after sunset", "should_trigger": True, "expected_behavior": "Perform ordinary measurable looking words without a domain oracle or contract"},
    ]
    (d / "evals/evals.json").write_text(json.dumps(cases))
rejected("unique-lexical-filler", unique_lexical_filler)

def role_aware_culinary_evals(d):
    cases = [
        {"id": "positive-culinary-test", "prompt": "Design a seasonal test dinner with balanced courses, careful plating, and coordinated kitchen timing for tonight", "should_trigger": True, "expected_behavior": "Create a test strategy and regression tasting suite while documenting every fixture ingredient and service step"},
        {"id": "negative-culinary-unit", "prompt": "Explain a unit test tasting spoon and its place beside the dessert plate without changing the menu", "should_trigger": False, "expected_behavior": "Treat the unit tasting request as ordinary culinary explanation rather than activating an engineering workflow"},
        {"id": "collision-culinary-browser", "prompt": "Resolve a test menu collision between the dining room display and the kitchen ticket presentation", "should_trigger": True, "expected_behavior": "Route the product browser presentation to its adjacent owner while the chef keeps ordinary meal preparation"},
        {"id": "brownfield-culinary-suite", "prompt": "Brownfield existing test kitchen contains unrelated recipes, dirty utensils, and yesterday's baseline menu notes", "should_trigger": True, "expected_behavior": "Preserve the baseline suite notes and unrelated recipes while preparing the new seasonal dinner"},
        {"id": "pressure-culinary-acceptance", "prompt": "Deadline pressure demands immediate approval of the test banquet before guests arrive for service", "should_trigger": True, "expected_behavior": "Resist pressure and preserve independent acceptance while the chef finishes ordinary plating and seasoning"},
        {"id": "behavioral-culinary-suite", "prompt": "A changed test menu replaces the soup and dessert while keeping the dining room arrangement intact", "should_trigger": True, "expected_behavior": "Invalidate stale suite proof, rerun the tasting fixture, and preserve the final culinary presentation"},
    ]
    (d / "evals/evals.json").write_text(json.dumps(cases))
rejected_with("role-aware-culinary-evals", role_aware_culinary_evals, "reviewed snapshot mismatch")

def three_group_culinary_skill(d):
    (d / "SKILL.md").write_text("""---
name: test-engineering
description: Plan professional kitchen service with a test strategy, regression tasting suite, fixture control, independent acceptance, negative flavor checks, and nonfunctional boundary timing for elaborate seasonal meals.
---

# Culinary Test Engineering

Prepare a complete dinner by applying a test strategy to ingredient selection,
knife technique, heat control, plating, and service timing. Maintain a regression
tasting suite and a fixture list for every sauce, garnish, and substitution.

Use [test strategy](references/test-strategy.md) notes for kitchen sequencing and
[suite health](references/suite-health.md) notes for tasting rounds. Require an
independent chef to record acceptance, negative flavor observations, and the
nonfunctional dining-room boundary before guests receive each course.

Document allergens, temperatures, resting periods, cleanup duties, leftovers,
and final proof that every plate follows the seasonal menu. Repeat the test
when seasoning, presentation, or service order changes.
""")
rejected_with("three-group-culinary-skill", three_group_culinary_skill, "reviewed snapshot mismatch")

def symlink_resource(d):
    (d / "linked-skill.md").symlink_to("SKILL.md")
rejected_with("symlink-resource", symlink_resource, "symlink")

def marker_stuff(d):
    cases = []
    for index in range(6):
        cases.append({
            "id": f"positive-negative-collision-brownfield-pressure-{index}",
            "prompt": "positive negative collision brownfield pressure marker words with no realistic engineering request",
            "should_trigger": index != 1,
            "expected_behavior": "positive negative collision brownfield pressure marker words with no meaningful operational behavior",
        })
    (d / "evals/evals.json").write_text(json.dumps(cases))
rejected("marker-stuffed", marker_stuff)
PY
}

case_runtime_001() {
  local skill_id
  for skill_id in specification-lifecycle test-driven-development test-engineering source-verification solution-minimalism web-performance-review; do
    need_pattern "${skill_id}" adapters/runtime/codex/skill-catalog-manifest.toml || return 1
  done
  local home="$tmp_dir/runtime-home/.codex"
  local target="$home/skills"
  local backup="$tmp_dir/runtime-backup"
  local receipt="$backup/sync-receipt.json"
  mkdir -p "$target/accelerate/references" "$target/user-owned-fixture"
  printf 'operator state\n' >"$target/accelerate/references/operator-sentinel.md"
  printf 'preserve me\n' >"$target/user-owned-fixture/SKILL.md"
  CODEX_HOME="$home" CODEX_SKILLS_DIR="$target" CODEX_SKILLS_BACKUP_DIR="$backup" \
    CODEX_SKILLS_RECEIPT_FILE="$receipt" CODEX_SKILL_SYNC_ALLOWED_ROOT="$tmp_dir" \
    bash scripts/sync-skills-to-global.sh || return 1
  [ -f "$backup/packages/accelerate/references/operator-sentinel.md" ] || {
    printf 'sync did not back up replaced governed state\n' >&2
    return 1
  }
  [ ! -f "$target/accelerate/references/operator-sentinel.md" ] || {
    printf 'sync left stale file inside governed package\n' >&2
    return 1
  }
  [ -f "$target/user-owned-fixture/SKILL.md" ] || {
    printf 'sync deleted unrelated user-owned package\n' >&2
    return 1
  }
  CODEX_HOME="$home" CODEX_SKILLS_DIR="$target" bash scripts/check-global-skill-mirror.sh || return 1
  mkdir -p "$target/specification-lifecycle/references"
  printf 'stale\n' >"$target/specification-lifecycle/references/stale.md"
  if CODEX_HOME="$home" CODEX_SKILLS_DIR="$target" bash scripts/check-global-skill-mirror.sh; then
    printf 'mirror checker accepted stale governed file\n' >&2
    return 1
  fi
  python3 - "$receipt" "$target" <<'PY'
import json
import subprocess
import sys
from pathlib import Path

receipt = json.loads(Path(sys.argv[1]).read_text())
required = {
    "source_authority", "target", "target_lexical", "backup", "allowed_root",
    "codex_home", "codex_home_lexical", "changed_packages", "runtime_files",
    "rollback_command",
}
missing = required - set(receipt)
if missing:
    raise SystemExit(f"receipt missing fields {sorted(missing)}")
if receipt["source_authority"] != "repo":
    raise SystemExit("receipt does not preserve repo source authority")
command = receipt["rollback_command"]
if not isinstance(command, list) or not command:
    raise SystemExit("rollback_command must be a non-empty argv list")
target = Path(sys.argv[2])
drift = target / "specification-lifecycle/references/stale.md"
rejected = subprocess.run(command, capture_output=True, text=True)
if rejected.returncode == 0:
    raise SystemExit("rollback accepted post-sync governed-package drift")
if not drift.is_file():
    raise SystemExit("rejected rollback mutated the post-sync drift")
if (target / "accelerate/references/operator-sentinel.md").exists():
    raise SystemExit("rejected rollback partially restored pre-sync state")
drift.unlink()
subprocess.run(command, check=True)
if not (target / "accelerate/references/operator-sentinel.md").is_file():
    raise SystemExit("rollback did not restore pre-sync governed state")
if not (target / "user-owned-fixture/SKILL.md").is_file():
    raise SystemExit("rollback removed unrelated user-owned package")
PY
}

case_runtime_002() {
  local path=planning/evidence/dated-proof-appendix/quality-stack-post-restart-runtime-proof-2026-08-13.md
  need_file "$path" || return 1
  need_pattern 'status.*observed-green|observed-green.*status' "$path" || return 1
  need_pattern 'orchestrator.*13|13.*orchestrator' "$path" || return 1
  need_pattern 'python-backend.*25|25.*python-backend' "$path" || return 1
  need_pattern 'nextjs-frontend.*30|30.*nextjs-frontend' "$path" || return 1
  need_pattern 'research.*19|19.*research' "$path" || return 1
  need_pattern 'reviewer.*26|26.*reviewer' "$path" || return 1
  need_pattern 'qa.*18|18.*qa' "$path" || return 1
  need_pattern 'Skill descriptions were shortened.*zero|zero.*Skill descriptions were shortened' "$path" || return 1
  need_pattern 'no-history.*spawn|spawn.*no-history' "$path" || return 1
  need_pattern 'Done state|state.*Done' "$path" || return 1
  need_pattern 'FINISH comment' "$path" || return 1
  need_pattern 'c93708e3-317f-41c0-8e0a-63667d578fb2' "$path" || return 1
  need_pattern 'final independent work-item GET.*Done|independent work-item GET.*remained Done' "$path" || return 1
  if rg -ni 'CODEX-1 remains open|only remaining operations are governed Plane' "$path" >/dev/null; then
    printf 'post-restart receipt still claims governed closure is pending\n' >&2
    return 1
  fi
  if rg -ni 'native spawn.*profile injection.*proven|physical-agent.*promoted|filesystem isolation.*proven' "$path" >/dev/null; then
    printf 'post-restart receipt overclaims profile isolation or promotion\n' >&2
    return 1
  fi
}

run_case CASE-REV-001 'review covers independent quality axes' case_rev_001
run_case CASE-REV-002 'severity derives from evidence and impact, not category' case_rev_002
run_case CASE-REV-003 'findings carry complete actionable evidence' case_rev_003
run_case CASE-REV-004 'review includes governed docs and never mutates git authority' case_rev_004
run_case CASE-LEAN-001 'minimal solution follows the reuse-first decision ladder' case_lean_001
run_case CASE-LEAN-002 'minimalism cannot delete required safety or proof' case_lean_002
run_case CASE-LEAN-003 'rejected complexity records a measurable upgrade trigger' case_lean_003
run_case CASE-SKILL-001 'quality skill packages follow progressive disclosure' case_skill_001
run_case CASE-SKILL-002 'skill eval fixture contracts cover routing roles without claiming replay' case_skill_002
run_case CASE-RUNTIME-001 'catalog and recursive mirror parity remain source-owned' case_runtime_001
run_case CASE-RUNTIME-002 'fresh-process inventory, startup and bounded spawn evidence are explicit' case_runtime_002

if [ "$failures" -ne 0 ]; then
  printf 'quality skill contract: %s case(s) failed\n' "$failures" >&2
  exit 1
fi

printf 'quality skill contract passed (11 cases)\n'
