# Linear MCP Live Validation — 2026-05-08

## Scope

RC7 attempted to prove the repo-local Linear structured helper path for:

- issue read
- issue create
- artifact comment
- closure comment
- status transition

The helper implementation is intentionally non-LLM and uses direct GraphQL-over-curl bindings.

## Sanitized Credential / Fixture Decision

- `LINEAR_API_KEY` in the shell environment used by the repo-local helper scripts: **absent**.
- Linear MCP metadata lookup was available through the host tool and showed a candidate non-sensitive team plus safe workflow statuses, but that is not equivalent to proving the repo-local helper scripts because the scripts explicitly require `LINEAR_API_KEY` before live calls.
- No private Linear payloads, tokens, or raw provider JSON are committed in this appendix.

## Live Fixture Result

Live fixture follow-through through the repo-local scripts was **blocked**.

Reason:

```text
LINEAR_API_KEY is not set
```

Observed during an attempted helper-chain run using a temporary target workspace and a public/export-approved fixture artifact. The chain stopped at `create-linear-mcp-issue.sh` before any remote helper write could occur.

## Local Structured Binding Proof

Local contract proof was completed instead:

```text
bash tests/linear-structured-mcp-binding.sh
linear structured mcp binding tests passed
```

Covered local guarantees:

- dry-run JSONL emits `remote_calls:false`
- closure comment helper emits structured GraphQL dry-run rows
- status transition helper emits structured GraphQL dry-run rows
- live mode rejects missing `LINEAR_API_KEY` before remote calls
- output paths must stay under `.accelerate/workflow/`
- symlink/escaping output paths are rejected
- registry keeps Linear writes `planned` with `live_proof: none`
- helper path has no opencode / LLM-host dependency

## Promotion Decision

Do **not** promote Linear helper capabilities to `available` from this appendix. The correct status remains `planned` until a future run supplies `LINEAR_API_KEY`, performs a non-sensitive live fixture through the repo-local helper scripts, and records sanitized durable evidence.
