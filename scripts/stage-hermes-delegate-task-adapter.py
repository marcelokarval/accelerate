#!/usr/bin/env python3
"""Emit a read-only projection plan for the staged Hermes delegate_task adapter."""
from __future__ import annotations

import argparse
import json
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
MANIFEST = REPO / "adapters/runtime/hermes/hermes-delegate-task.manifest.json"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true", required=True)
    args = parser.parse_args()
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    print(json.dumps({
        "status": "BLOCKED_PENDING_RUNTIME_TRUTH",
        "mode": "dry-run",
        "adapter": manifest["adapter"],
        "writes": [],
        "readback_required": ["active-source-cleanliness", "profile", "postgres-lineage", "sync-result-projection", "reconciliation"],
        "rollback": manifest["projection"]["rollback"],
    }, sort_keys=True))
    return 3


if __name__ == "__main__":
    raise SystemExit(main())
