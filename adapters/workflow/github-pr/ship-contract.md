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

This proves the read/comment helper layer. The adapter remains `planned` as a
full workflow adapter until PR create/update, failure recovery, and closure
truth are adopted as governed workflow behavior.
