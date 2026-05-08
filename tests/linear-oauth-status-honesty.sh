#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CAPABILITIES="${ROOT}/adapters/workflow/linear/capabilities.yaml"
README="${ROOT}/adapters/workflow/linear/README.md"
CAP_DASHBOARD="${ROOT}/core/control-plane/capability-maturity-dashboard.md"
SITUATION_DASHBOARD="${ROOT}/core/control-plane/recursive-improvement-situation-dashboard.md"
READINESS="${ROOT}/.accelerate/status/readiness-dashboard.yaml"
PROOF="${ROOT}/planning/evidence/dated-proof-appendix/linear-mcp-oauth-validation-2026-05-08.md"

python3 - "${CAPABILITIES}" "${README}" "${CAP_DASHBOARD}" "${SITUATION_DASHBOARD}" "${READINESS}" "${PROOF}" <<'PY'
from pathlib import Path
import re
import sys

capabilities, readme, cap_dashboard, situation, readiness, proof = [Path(p) for p in sys.argv[1:]]
files = {
    "capabilities": capabilities.read_text(encoding="utf-8"),
    "readme": readme.read_text(encoding="utf-8"),
    "cap_dashboard": cap_dashboard.read_text(encoding="utf-8"),
    "situation": situation.read_text(encoding="utf-8"),
    "readiness": readiness.read_text(encoding="utf-8"),
    "proof": proof.read_text(encoding="utf-8"),
}


def fail(message: str) -> None:
    print(f"linear-oauth-status-honesty failed: {message}", file=sys.stderr)
    raise SystemExit(1)

for name, text in files.items():
    for required in ("linear-oauth-mcp", "linear-api-key-graphql"):
        if required not in text:
            fail(f"{name} missing lane marker {required}")

proof_text = files["proof"]
for required in (
    "raw_email_committed=false",
    "raw_provider_payload_committed=false",
    "raw_status_ids_committed=false",
    "issue=P4Y-1298",
    "issue=P4Y-1299",
    "status_observed_at_rc24=In Progress",
    "Do **not** claim portable CI availability or script availability from OAuth MCP host proof.",
):
    if required not in proof_text:
        fail(f"proof appendix missing sanitized proof marker: {required}")

for forbidden in (
    "@gmail.com",
    '"description"',
    '"email"',
    "Bearer ",
):
    if forbidden in proof_text:
        fail(f"proof appendix contains forbidden raw/private marker: {forbidden}")

if re.search(r"\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b", proof_text, re.IGNORECASE):
    fail("proof appendix contains a raw provider UUID")

cap_text = files["cap_dashboard"]
if "| Linear OAuth MCP read/discovery | Linear (`linear-oauth-mcp`) | `conditional` |" not in cap_text:
    fail("capability dashboard does not mark OAuth MCP read/discovery as conditional")
if "| Linear API-key GraphQL read/lookup | Linear (`linear-api-key-graphql`) | `planned` |" not in cap_text:
    fail("capability dashboard does not keep API-key GraphQL read/lookup planned")
if "OAuth host proof does not satisfy this fallback" not in cap_text:
    fail("capability dashboard missing fallback non-conflation language")

readiness_text = files["readiness"]
if re.search(r"linear_api_key_graphql_fallback:\n\s+status:\s+available", readiness_text):
    fail("readiness dashboard promotes API-key GraphQL fallback to available")
if re.search(r"linear_oauth_mcp_host_lane:\n\s+status:\s+available", readiness_text):
    fail("readiness dashboard overpromotes host OAuth MCP lane to available")
if "not portable repo-local shell or CI proof" not in readiness_text:
    fail("readiness dashboard missing host-only OAuth boundary")

combined = "\n".join(files.values()).lower()
for phrase in (
    "oauth mcp host proof does not promote this fallback",
    "not portable ci/script proof",
    "not repo-local shell",
):
    if phrase not in combined:
        fail(f"combined docs missing non-conflation phrase: {phrase}")

print("linear oauth status honesty passed")
PY
