# Linear MCP Live Validation — 2026-05-08

## Scope

RC13 reviewed and extended the repo-local Linear structured helper path for:

- live fixture readiness / preflight
- issue read
- issue create
- artifact comment
- closure comment
- status transition

The helper implementation remains intentionally non-LLM and uses direct GraphQL-over-curl bindings for provider calls.

## Sanitized Credential / Fixture Decision

Credential and fixture readiness were checked from the RC13 and RC18 subagent shells without printing secrets.

Sanitized result from the RC18 repo-local live preflight:

```text
operation=live-fixture-preflight
credential=absent
live_fixture_opt_in=False
fixture_team=absent
fixture_status=absent
fixture_project=none
fixture_assignee=none
ready=False
verified=False
blocked_reason=missing prerequisites: LINEAR_API_KEY, ACCELERATE_LINEAR_LIVE_FIXTURE=1, LINEAR_FIXTURE_TEAM_ID or LINEAR_FIXTURE_TEAM_KEY, LINEAR_FIXTURE_STATUS_ID
remote_calls=False
mode=live-preflight
```

No private Linear payloads, tokens, provider response bodies, issue titles, team names, user emails, raw fixture IDs, or raw GraphQL JSON are committed in this appendix.

## Live Fixture Result

Live fixture follow-through through the repo-local scripts was **blocked** in RC18.

Exact missing prerequisites from the credential-safe live preflight:

```text
LINEAR_API_KEY absent
ACCELERATE_LINEAR_LIVE_FIXTURE=1 absent
LINEAR_FIXTURE_TEAM_ID or LINEAR_FIXTURE_TEAM_KEY absent
LINEAR_FIXTURE_STATUS_ID absent
```

Because these prerequisites were absent, RC18 did not create, comment on, attach artifacts to, close/comment, transition, or otherwise mutate any Linear issue. The live chain correctly stopped before any remote call.

## Local Structured Binding Proof

Local contract proof was completed:

```text
bash tests/linear-structured-mcp-binding.sh
linear structured mcp binding tests passed
```

Covered local guarantees:

- dry-run JSONL emits `remote_calls:false`
- live-fixture preflight emits credential-safe readiness rows without secrets
- live-fixture preflight fails closed and reports the exact missing non-sensitive gates when token, explicit opt-in, team, or target status are absent
- issue read, issue create, artifact comment, closure comment, and status transition helpers reject missing `LINEAR_API_KEY` before remote work
- output paths must stay under `.accelerate/workflow/`
- symlink/escaping output paths are rejected
- artifact comments require an export-approved artifact
- registry keeps Linear writes `planned` with `live_proof: none`
- helper path has no opencode / LLM-host dependency

## Promotion Decision

Do **not** promote Linear helper capabilities to `available` from this appendix. The correct status remains `planned` until a future run supplies all of the following and records sanitized durable evidence:

1. `LINEAR_API_KEY` in the repo-local helper environment;
2. explicit live-fixture opt-in via `ACCELERATE_LINEAR_LIVE_FIXTURE=1`;
3. a non-sensitive fixture team via `LINEAR_FIXTURE_TEAM_ID` or `LINEAR_FIXTURE_TEAM_KEY`;
4. a safe target status via `LINEAR_FIXTURE_STATUS_ID` that the preflight verifies on the fixture team;
5. a full repo-local helper chain proof for read/create/artifact-comment/closure-comment/status-transition with provider responses sanitized before commit.
