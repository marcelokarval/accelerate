#!/usr/bin/env python3
"""Exact, closed-schema validator for generated U5/U6 runtime projections."""
from __future__ import annotations
import argparse, hashlib, importlib.util, json, re, sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("renderer", REPO / "scripts/render-other-runtime-adapters.py")
renderer = importlib.util.module_from_spec(spec); spec.loader.exec_module(renderer)
POLICY = "adapters/runtime/other-runtime-adapters.policy.json"; REGISTRY = "adapters/runtime/runtime-consumer-registry.json"; DASHBOARD = "core/control-plane/runtime-adapter-maturity-dashboard.md"
BASE = {"type","runtime_status","proof_class","projection_mode","loader","authority_boundary","current_tools","candidate_tools","allowed_roles","forbidden_roles","allowed_efforts","forbidden_efforts","suppressed_capabilities","nesting","max_assignment_depth","max_concurrent_children","named_model_allowlist","named_tool_allowlist","named_skill_allowlist","named_mcp_allowlist","timeout_required","cleanup_currently_allowed","root_only_synthesis","effective_model_receipt_required","callability_proven","loader_proven","privacy_notes","observed_version","candidate_note","registry_proof","registry_install","registry_rollback"}
APPROVED = {
 "opencode":{"runtime_status":"legacy-reference","proof_class":"static-contract","projection_mode":"generated-export","registry_proof":"static-contract-only; runtime callability unproven","registry_install":"denied/not-supported","registry_rollback":"not-supported"},
 "openclaw":{"runtime_status":"legacy-reference","proof_class":"static-contract","projection_mode":"reference-only","registry_proof":"static-contract-only; runtime callability unproven","registry_install":"denied/not-supported","registry_rollback":"not-supported"},
 "claude":{"runtime_status":"export-only","proof_class":"static-contract","projection_mode":"future-export","registry_proof":"static-contract-only; runtime callability unproven","registry_install":"denied/not-supported","registry_rollback":"not-supported"}}

def fail(message: str): raise ValueError(message)
def digest(text: str): return hashlib.sha256(text.encode()).hexdigest()
def validate(root: Path, registry_path: Path | None = None):
    policy_path=root/POLICY; source=json.loads(policy_path.read_text());
    if set(source)!={"schema_version","runtimes"} or source["schema_version"]!=1 or set(source["runtimes"])!={"opencode","openclaw","claude"}: fail("machine policy schema drift")
    registry=json.loads((registry_path or root/REGISTRY).read_text()); consumers={x["runtime"]:x for x in registry["consumers"]}
    dashboard=(root/DASHBOARD).read_text(); meta=re.search(r"<!-- accelerate-runtime-projection-status\s*(\{.*?\})\s*-->",dashboard,re.S)
    if not meta: fail("dashboard metadata missing")
    status_meta=json.loads(meta.group(1))
    for name,item in source["runtimes"].items():
        if set(item)!=BASE: fail(f"{name} machine policy contains unknown or missing key")
        for key,value in APPROVED[name].items():
            if item[key] != value: fail(f"{name} approved {key} invariant drift")
        if item["callability_proven"] or item["loader_proven"]: fail(f"{name} callability/loader overclaim")
        roles=["orchestrator","python-backend","nextjs-frontend","research","reviewer","qa","data-db","integrations-ops"]
        if item["allowed_roles"] != ([] if name == "claude" else roles) or item["forbidden_roles"] != ["designer","observer","council"]: fail(f"{name} role authority invariant drift")
        if item["forbidden_efforts"] != ["xhigh","max"] or item["allowed_efforts"] != ([] if name == "claude" else ["low","medium","high"]): fail(f"{name} effort invariant drift")
        if item["nesting"] != ("unavailable" if name == "claude" else "disabled") or item["max_assignment_depth"] != 0 or not item["root_only_synthesis"]: fail(f"{name} nesting/root synthesis invariant drift")
        if name != "claude" and (not item["named_skill_allowlist"] or not item["named_mcp_allowlist"]): fail(f"{name} named skill/MCP allowlist invariant drift")
        if name == "opencode" and item["candidate_tools"] != ["task","tasks","wait","cancel"]: fail("opencode candidate lifecycle invariant drift")
        if name=="opencode" and not item["effective_model_receipt_required"]: fail("opencode effective-model/effort receipt requirement removed")
        if {"*","all","xhigh","max"}&set(item["current_tools"]+item["allowed_efforts"]): fail(f"{name} unsafe wildcard/effort grant")
        manifest=root/f"adapters/runtime/{name}/capabilities.yaml"; contract=root/f"adapters/runtime/{name}/delegation-contract.md"
        expected_manifest=renderer.manifest(name,item); expected_contract=renderer.contract(name,item)
        if manifest.read_text()!=expected_manifest: fail(f"{name} manifest renderer hash mismatch")
        if contract.read_text()!=expected_contract: fail(f"{name} contract renderer hash mismatch")
        if not item["current_tools"]==[]: fail(f"{name} current tool claim is unsafe")
        proof=[f"adapters/runtime/{name}/delegation-contract.md","tests/test_other_runtime_adapters.py"]
        if not proof or any(not (root/p).is_file() for p in proof): fail(f"{name} proof artifacts are empty or missing")
        entry=consumers[name]
        required={"runtime","status","source_authority","projection","loader","native_primitive","adapter","proof","install","rollback"}
        if set(entry)!=required or entry["status"]!=item["runtime_status"] or entry["loader"]!=item["loader"] or entry["projection"]["mode"]!=item["projection_mode"]: fail(f"{name} registry status/projection drift")
        if entry["proof"]!=item["registry_proof"] or entry["install"]!=item["registry_install"] or entry["rollback"]!=item["registry_rollback"]: fail(f"{name} unsafe registry proof/install/readback/rollback claim")
        for p in (entry["source_authority"],entry["adapter"],entry["projection"]["path"],*proof):
            if p!="none" and not (root/p).exists(): fail(f"{name} nonexistent authority/projection/proof path")
        expected_status={"runtime_status":item["runtime_status"],"proof_class":item["proof_class"]}
        row={"opencode":"| OpenCode", "openclaw":"| OpenClaw", "claude":"| Claude Code"}[name]
        label={"opencode":"OpenCode", "openclaw":"OpenClaw", "claude":"Claude Code"}[name]
        visible=f"| {label} | `{item['runtime_status']}` | `{item['proof_class']}` | `{item['projection_mode']}` |"
        legacy_label={"opencode":"OpenCode / OMO-Slim task projection", "openclaw":"OpenClaw sessions-spawn projection", "claude":"Claude Code projection"}[name]
        legacy_status=f"| {legacy_label} | `{item['runtime_status']}` / `{item['proof_class']}` |"
        if visible not in dashboard or legacy_status not in dashboard or status_meta.get(name)!=expected_status: fail(f"{name} visible dashboard row or metadata drift")
def main():
    p=argparse.ArgumentParser();p.add_argument("--root",type=Path,default=REPO);p.add_argument("--registry",type=Path); args=p.parse_args(); validate(args.root,args.registry); print("PASS: exact generated U5/U6 projections validated")
if __name__=="__main__":
    try: main()
    except (OSError,ValueError,KeyError,json.JSONDecodeError) as e: print(f"FAIL: {e}",file=sys.stderr);sys.exit(1)
