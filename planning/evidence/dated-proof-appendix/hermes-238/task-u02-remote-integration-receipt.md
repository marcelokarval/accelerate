# HERMES-238 — TASK-U02 Remote Integration Receipt

## Frozen integrated candidate

- Fresh remote parent: `8a661a02563b62e926a91a11122719e569bbbb3b`
- Isolated branch: `codex/hermes-238-plane-mcp-import-remote`
- Commit: `65f3824ee0dfd69f246c50616c9af0bfa08ab0fc`
- Target subtree: `29688e9fbf65f9ee4c8990e451fb475c99a1298e`

The fresh parent has no Plane MCP target tree. The new commit adds exactly 29
paths, all under `apps/mcp-servers/plane-mcp-karval/`. Its binary patch and
target subtree are byte-identical to the reviewed v2 candidate.

## Remote-base proof

```text
uv sync --locked               # pass
uv lock --check                # pass
uv build --wheel               # pass
installed-wheel import         # pass
uv run pytest tests            # 133 passed, 5 skipped
external parity audit          # 1 failed, 4 passed; known external drift
```

The external audit stays opt-in, visible and fail-closed. `git diff --check`
has the same four inherited whitespace findings as the reviewed source; no
content was normalized during transplant.

## Preservation

The source v1/v2 candidate branches/worktrees and shared Hermes target remain
unchanged. No push, PR, merge, runtime, provider or catalog mutation occurred
in U02. This receipt removes ambiguity between prior local proof and the fresh
remote-base integration; publication remains a separate U05 gate.
