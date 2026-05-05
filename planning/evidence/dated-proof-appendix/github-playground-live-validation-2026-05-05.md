# GitHub Playground Live Validation — 2026-05-05

## Status

- provider: GitHub
- playground repository: `marcelokarval/accelerate-playground`
- repository URL: <https://github.com/marcelokarval/accelerate-playground>
- playground policy: persistent; do not delete after test runs
- PR URL: <https://github.com/marcelokarval/accelerate-playground/pull/1>
- branch: `accelerate/live-proof-2026-05-05`
- local proof workspace: `/tmp/acc-live-b`
- sensitivity: redacted/non-sensitive summary only

## Actions Proven

- repository creation: passed
- README initialization: passed
- branch push: passed
- PR creation through `create-github-pr-adapter.sh`: passed
- PR read/lookup through `read-github-pr-adapter.sh`: passed
- PR artifact comment through `attach-github-pr-artifact.sh`: passed
- PR closure comment through `comment-github-pr-closure.sh`: passed
- PR rehydration through `rehydrate-github-pr-adapter.sh`: passed
- ship-readiness read through `check-ship-readiness.sh`: passed, not ready because the playground PR intentionally has no approval requirement satisfied
- land command: dry-run only; live merge intentionally not executed so the PR remains available for future sessions

## Durable Remote Handles

- repository: `marcelokarval/accelerate-playground`
- initial README commit: `ddea5fcb16a79de345cf1ba0f3f6ea5dec1701e2`
- proof branch commits:
  - `ea03aff` — test fixture
  - `75be7c0` — live proof artifacts
  - `fbfd89b` — closure verification artifacts
- PR: `#1`
- artifact comment: <https://github.com/marcelokarval/accelerate-playground/pull/1#issuecomment-4383763070>
- closure comment: <https://github.com/marcelokarval/accelerate-playground/pull/1#issuecomment-4383766925>

## Proof Boundary

This proof confirms controlled GitHub remote-provider behavior for the GitHub PR adapter family.

It does not prove Linear write behavior, production deploy behavior, or GitHub PR merge/land behavior.
Those capabilities remain separately governed by their own status, proof, and opt-in gates.
