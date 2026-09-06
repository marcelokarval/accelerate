# HERMES-238 — Wave Q Local Source-Promotion Closure Packet

## Decision

`LOCAL_SOURCE_PROMOTION_COMPLETE`

The authoritative local source candidate is:

```text
branch: codex/hermes-238-plane-mcp-import-v2
base/parent: 5273a7250dc1166381f306f43245817ac80251e6
commit: 4e0001e094f0b40e3a1a1d94c8c75667ba57e1b8
tree: 0a403b8d694d76333c87c512239b60a93faa40a9
```

It contains exactly the frozen 29 paths under
`apps/mcp-servers/plane-mcp-karval/`; full paths and blob contents match the
P04 manifest. The earlier malformed root-level commit
`07d3b81cfa8104466c0c995d2ce9076d7c18ee31` is preserved as evidence and
explicitly excluded from promotion.

## Gate ledger

| Gate | Result |
| --- | --- |
| base/branch/worktree isolation | pass |
| exact prefixed 29-file transplant | pass |
| local commit/tree/parent readback | pass |
| sync, lock, wheel and installed-wheel import | pass |
| hermetic package suite | pass: 133 passed, 5 skipped |
| external parity audit | visible residual: 1 failed, 4 passed |
| independent immutable-commit review | pass |
| root review-of-review | pass for local source promotion |

## Residuals

1. Four trailing-whitespace lines are frozen reviewed content in a lifecycle
   design document. They are non-blocking but should be normalized only in a
   separately scoped documentation cleanup.
2. The external parity audit remains an opt-in, fail-closed external-runtime
   drift detector; its stale OpenCode hash was not changed or accepted as a
   runtime claim.
3. The shared global porcelain changed only through unrelated cron output
   rotation. Its target-app fingerprint remains the original `54a9263f…`;
   index and diff fingerprints remained unchanged. The complete historical raw
   global listings live only in `/tmp`; this is a forensic retention gap for
   broad Hermes closure, not a defect in the isolated Plane MCP commit.

## Explicitly not promoted

- no remote push, PR, merge, rebase, tag or release;
- no runtime promotion/restart/canary/current-session MCP refresh;
- no Plane provider action, issue transition/comment, HERMES-238 closure,
  CODEX-26 retry or Phase-2 start;
- no external catalog update.

## Next gates

Remote publication/merge, then runtime promotion and an exact governed
CODEX-26 lifecycle retry each require separate explicit authorization and fresh
preflight. The malformed G1 branch/worktree must be retained until an operator
authorizes recoverable cleanup after confirming it is not needed for audit.
