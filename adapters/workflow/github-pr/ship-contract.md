# GitHub PR Ship Contract

GitHub PR ship behavior is planned. It may create or update PRs only after ship
readiness gates pass and a live adapter implementation exists.

`onboarding/local-workspace/probe-github-pr-adapter.sh` is read-only. It can
verify local git/gh/PR visibility but does not make this adapter implemented.

`read-github-pr-adapter.sh` can read PR metadata. `attach-github-pr-artifact.sh`
can attach a local artifact as a PR comment when `gh` auth is available.

## Live Test Evidence

On 2026-04-27, the helper layer was live-tested against
`https://github.com/marcelokarval/accelerate/pull/1`:

- read: `read-github-pr-adapter.sh .tmp/github-live-pr` returned PR metadata
  for PR `#1`
- attach: `attach-github-pr-artifact.sh .tmp/github-live-pr .accelerate/review/qa-report.md ...`
  posted `https://github.com/marcelokarval/accelerate/pull/1#issuecomment-4329141970`

This proves the read/comment helper layer. Create, rehydration, recovery, and
guarded land helpers exist, but the adapter remains `planned` as full workflow
truth until those helper classes have their own live proof and recovery drills.

## Implemented Helper Set

The GitHub PR adapter is implemented as a remote workflow adapter when `gh` is
authenticated and the target repository has a GitHub `origin` remote:

- create: `create-github-pr-adapter.sh`
- read: `read-github-pr-adapter.sh`
- attach review/closure artifact: `attach-github-pr-artifact.sh`
- rehydrate: `rehydrate-github-pr-adapter.sh`
- recovery packet: `write-github-pr-recovery.sh`

Lifecycle/topology are `linked`, not fully native, because GitHub PRs do not own
the whole issue hierarchy by themselves. The adapter must still preserve closure
truth by attaching governed artifacts and rehydrating PR metadata before closure.

Real PR creation is blocked unless `ACCELERATE_ALLOW_GITHUB_PR_CREATE=1` is set
because creating a PR is an external provider write and the full adapter remains
planned as workflow truth.
