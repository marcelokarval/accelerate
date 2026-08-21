#!/usr/bin/env python3
"""Fail-closed live PostgreSQL preflight; never prints a DSN or mutates state."""
from __future__ import annotations
import json, os, re, sys
from pathlib import Path

def main() -> int:
    if len(sys.argv) != 2:
        print("BLOCKED: receipt path plus governed runtime truth and read-only PostgreSQL lineage evidence are required")
        return 3
    receipt = json.loads(Path(sys.argv[1]).read_text())
    lineage = receipt.get("postgres_lineage", {})
    required = (lineage.get("proof_class") == "live-postgres" and re.fullmatch(r"[0-9a-f]{64}", str(lineage.get("evidence_sha256", ""))) and re.fullmatch(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z", str(lineage.get("readback_at", ""))) and isinstance(lineage.get("evidence_locator"), str))
    if not required or not os.environ.get("HERMES_STATE_DATABASE_URL") or os.environ.get("HERMES_RUNTIME_TRUTH_APPROVED") != "1":
        print("BLOCKED: governed runtime truth and read-only PostgreSQL lineage evidence are required")
        return 3
    print("BLOCKED: live query execution requires an approved runtime-specific query binding")
    return 3
if __name__ == "__main__": raise SystemExit(main())
