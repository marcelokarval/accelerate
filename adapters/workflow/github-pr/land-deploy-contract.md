# GitHub PR Land Deploy Contract

`onboarding/local-workspace/check-ship-readiness.sh` reads GitHub PR state and
status checks into a governed ship-readiness artifact.

`onboarding/local-workspace/land-github-pr.sh` is fail-closed. It supports
`--dry-run` without remote writes and refuses real merge unless
`ACCELERATE_ALLOW_LAND=1` is set. Deploy remains outside this adapter unless a
separate deploy target adapter is present.

Land/deploy through GitHub PRs is planned. It requires CI status, merge policy,
deploy target, canary proof, and rollback/investigate posture.
