# HERMES-238 — TASK-Q02 Local Source-Promotion Receipt

## Local promotion

- Isolated worktree:
  `/home/marcelo-karval/worktrees/hermes-238-plane-mcp-import`
- Branch: `codex/hermes-238-plane-mcp-import`
- Parent/base: `5273a7250dc1166381f306f43245817ac80251e6`
- Commit: `07d3b81cfa8104466c0c995d2ce9076d7c18ee31`
- Tree: `c36ca04f2f42b9b1703e24bf6e2135350f69575a`
- Subject: `feat(plane): import HERMES-238 MCP source contract`

The committed tree contains exactly 29 paths. Its path set and content hashes
match P04 candidate manifest
`e6aa1f9fdd2d1786033b53f41b5f4f74bcc688f613f2de3fbd78bc9f843b2d05`.
The isolated worktree is clean after commit.

## Committed-tree proof

```text
uv sync --frozen --all-groups  # pass
uv lock --check                # pass
uv build --wheel               # pass
installed-wheel import         # pass
uv run pytest tests            # 133 passed, 5 skipped
```

The external audit remains opt-in and unchanged: `1 failed, 4 passed` for the
known stale OpenCode destination hash. It is not a package-test failure or a
runtime/catalog health claim.

`git diff --check` reports four inherited trailing-whitespace lines in an
immutable manifest document. They were preserved to maintain the frozen
candidate rather than silently normalized.

## Shared-worktree preservation caveat

The shared Hermes index-tree, unstaged-diff and cached-diff fingerprints were
unchanged across the operation. Its porcelain fingerprint changed concurrently
from `03694a…` to `e4b94d…`, and was stable on a second read. This is an
unattributed untracked-status delta; it was neither cleared nor included in the
commit. TASK-Q03 must independently classify it before source-promotion
closure.

## Explicitly unperformed

No push, PR, merge, rebase, tag, runtime promotion/restart, provider/Plane
action, external catalog change, HERMES-238 closure or CODEX-26 retry occurred.
