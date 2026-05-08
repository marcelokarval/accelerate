# Linear OAuth MCP + Runtime Proof Gates Final Review — 2026-05-08

Governing issue: P4Y-1298
Child issues: P4Y-1299, P4Y-1300, P4Y-1301, P4Y-1302
Executive plan: `planning/executive/2026-05-08-linear-oauth-runtime-proof-executive-plan.md`
Task ledger: `planning/executive/2026-05-08-linear-oauth-runtime-proof-task-ledger.md`
Root reviewer: Claw

## Orchestration Summary

- Execution was split into bounded implementation tasks RC24..RC27.
- Independent review subagents reviewed RC24, RC25, and combined RC26/RC27.
- The runtime allowed three simultaneous delegated subagents in this environment, so RC27 was queued until the first implementation wave closed; this still stayed under Karval's cap of four simultaneous agents.
- No delegated background process remained under root process management; browser-proof temp directories were checked after verification.

## Accepted Work

### RC24 — Linear OAuth MCP lane

Accepted.

The implementation separates:

- `linear-oauth-mcp`: host-authenticated OAuth MCP lane, status `conditional`, proven only for this authenticated environment and sanitized read/discovery/governing issue operations.
- `linear-api-key-graphql`: repo-local shell/CI fallback lane, still `planned` until explicit API-key fixture proof exists.

Proof locators:

- `planning/evidence/dated-proof-appendix/linear-mcp-oauth-validation-2026-05-08.md`
- `tests/linear-oauth-status-honesty.sh`
- `adapters/workflow/linear/README.md`
- `adapters/workflow/linear/capabilities.yaml`
- `core/control-plane/capability-maturity-dashboard.md`

Privacy review: accepted. The committed OAuth proof is sanitized and does not include raw provider JSON, email, bearer token, raw UUID IDs, or private descriptions.

### RC25 — Browser-proof server monitoring

Accepted.

The browser-proof helper now records honest correction data for missing server, failed readiness, capture-failed, server-crash-after-readiness, stdout/stderr tail sanitization, and cleanup disposition. It also avoids treating a one-off capture as persistent E2E availability.

Proof locators:

- `onboarding/local-workspace/capture-browser-proof.sh`
- `tests/browser-proof-monitoring.sh`
- `core/runtime-packets/browser-proof-packet.md`
- `adapters/runtime/browser/browser-truth-contract.md`
- `core/control-plane/runtime-adapter-maturity-dashboard.md`

Process review: accepted. `tests/browser-proof-monitoring.sh` passed, and `/tmp` had no `accelerate-browser-proof.*` / `browser-proof-*` temp leftovers after the full suite.

### RC26 — Boundary preservation

Accepted after root integration fixes.

The implementation keeps these gates separate and unpromoted:

- persistent E2E remains planned unless a separate persisted regression proof exists;
- generated-host export remains available only for repo-local/temp approved generated host proof;
- autonomous/physical agent runtime remains blocked/proof-replay unless real invocation, lifecycle, idle cleanup, demotion route, and root acceptance are proven.

Root fixed two integration nits found during review/full-suite verification:

1. Removed raw Linear UUID literals from `tests/linear-oauth-status-honesty.sh` while preserving generic UUID-leak detection.
2. Restored exact full-suite guard phrases in `core/control-plane/agent-factory-promotion-pipeline.md` and `core/control-plane/capability-maturity-dashboard.md`.

### RC27 — Dogfood governance integration

Accepted.

The local `.accelerate` dogfood state points to P4Y-1298 / RC24..RC27 and preserves next-queue truth from the updated cycle.

Proof locators:

- `.accelerate/README.md`
- `.accelerate/status/readiness-dashboard.yaml`
- `.accelerate/workflow/active-work-item.yaml`
- `core/control-plane/recursive-improvement-situation-dashboard.md`
- `tests/dogfood-workspace-contract.sh`
- `tests/recursive-self-improvement-contract.sh`

## Verification Run

Targeted verification:

```txt
bash tests/linear-structured-mcp-binding.sh
bash tests/linear-oauth-status-honesty.sh
bash tests/browser-proof-monitoring.sh
bash tests/semantic-negative-fixtures.sh
bash tests/promotion-replay-fixtures.sh
bash tests/skill-export-proof.sh
bash tests/dogfood-workspace-contract.sh
bash tests/recursive-self-improvement-contract.sh
git diff --check
```

Result: passed.

Full suite:

```txt
bash tests/all.sh
```

Result: `all tests passed`.

Cleanup check:

```txt
python3 - <<'PY'
from pathlib import Path
leftovers=[]
for p in Path('/tmp').iterdir():
    if p.name.startswith('accelerate-browser-proof.') or p.name.startswith('browser-proof-'):
        leftovers.append(str(p))
print('\n'.join(leftovers[:50]) if leftovers else 'no browser-proof temp dirs detected')
PY
```

Result: `no browser-proof temp dirs detected`.

## Residuals

1. Linear OAuth MCP is conditional to the authenticated host. It is not portable shell/CI proof.
2. Linear API-key GraphQL write path remains planned until safe fixture env vars and `LINEAR_API_KEY` are available and live proof is recorded.
3. Browser-proof now has stronger correction packets, but persistent E2E remains a separate gate.
4. Autonomous agent runtime remains blocked/proof-replay; delegated subagents here were synchronous orchestration, not a promoted autonomous runtime.

## Next Queue

1. Build a repo-owned `linear-oauth-mcp` invocation manifest/adapter shape if host-authenticated Linear writes should become a first-class Accelerate lane.
2. Add persisted E2E regression proof as a separate gate, not via browser-proof capture.
3. Prove generated-host export against an approved non-user-home host target before any real host install promotion.
4. Design the autonomous agent runtime lifecycle monitor separately: invocation, heartbeat/progress, idle detection, safe termination, replacement, and root acceptance.

## Root Decision

Accepted for commit/push readiness after full-suite verification.
