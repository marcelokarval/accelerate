#!/usr/bin/env python3
"""Render or verify the staged Hermes delegate_task bootstrap fragment."""
from __future__ import annotations

import argparse
import json
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
MANIFEST = REPO / "adapters/runtime/hermes/hermes-delegate-task.manifest.json"
OUTPUT = REPO / "adapters/runtime/hermes/hermes-delegate-task-bootstrap.fragment.md"


def render(manifest: dict[str, object]) -> str:
    batch = manifest["batch"]
    assignment = manifest["assignment"]
    execution = manifest["execution"]
    return f"""<!-- generated from hermes-delegate-task.manifest.json; do not treat as runtime proof -->
# Hermes Delegate Task Adapter (Staged)

Use the repository-owned `hermes-delegate-task` contract only after runtime
truth identifies the active Hermes checkout, profile, and PostgreSQL authority.
Keep each batch homogeneous by `agent_role`, inherit the parent toolsets, cap
children at {manifest['policy_cap']}, and use `leaf` or `orchestrator` with depth {assignment['max_depth']} by default.
Nested delegation is forbidden unless the root records an explicit grant.

Start with effective synchronous delivery. A background request may become
synchronous; async cannot claim sync-first and is allowed only after delivery
ACK, reconciliation, and live PostgreSQL lineage. Return requested/effective
provider, model, and reasoning-effort receipts, policy references, and native
routing/result evidence. `unknown` delivery/execution blocks closure.
Do not claim a native root-write-lock: it is adapter/prompt-only and native
enforcement is unsupported. This fragment neither installs nor activates
anything in Hermes.
"""


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    expected = render(json.loads(MANIFEST.read_text(encoding="utf-8")))
    if args.check:
        if not OUTPUT.is_file() or OUTPUT.read_text(encoding="utf-8") != expected:
            raise SystemExit("generated Hermes bootstrap fragment is stale")
        print("PASS: generated Hermes bootstrap fragment is current")
        return 0
    OUTPUT.write_text(expected, encoding="utf-8")
    print(OUTPUT)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
