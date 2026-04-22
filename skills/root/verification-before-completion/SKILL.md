---
name: verification-before-completion
description: Codex-native verification gate before claiming completion. Use when a slice, issue, PR, or runtime-facing change is about to be called done and you need decisive evidence before closure.
metadata:
  category: root
  origin: accelerate-native
---
# verification-before-completion

Use this skill when someone wants to mark a slice, issue, PR, or runtime-facing
change as complete.

## Purpose

Make `done` mean evidenced, reviewed, and proportionate to the claim being made.

## Verification Ladder

1. restate the completion claim
2. confirm the changed surfaces
3. classify which surfaces require decisive evidence
4. run or collect the narrowest decisive validation
5. check acceptance and regression impact
6. record review / QA outcome
7. state whether completion is actually supported

## Compatible Companion Skills

- `python-testing`
- `requesting-code-review`
- `dogfood`
- `product-runtime-review`
- `linear-pm`
- `systematic-debugging`
- `code-audit`

## Verdicts

- `supported`
- `incomplete`
- `blocked`

## Rules

1. Completion without evidence is `incomplete`.
2. One narrow passing check does not erase unverified acceptance, runtime, or regression risk.
3. If a reviewer or QA lane is required, completion waits for that lane.
4. Keep verification proportional, but never fictional.
5. Say which surfaces were proven, which were inferred, and which were left open.

## Output Format

- completion claim
- surfaces checked
- evidence checked
- gaps
- verdict
- next required move

## Relationship To Other Skills

- `requesting-code-review` is the local pre-commit verification lane
- `github-code-review` is the PR-review lane for already-published diffs
- `dogfood` is a strong companion when browser QA and issue capture are needed
- `product-runtime-review` governs user-facing runtime truth
- the active workflow adapter keeps issue state and closure language honest
- `accelerate` uses this skill as the closure-verdict lane when evidence, not optimism, must decide `Done`

## Verification

This skill is being used correctly if:

- the closure claim is explicit
- evidence is tied to the actual changed surface
- open gaps are named instead of hidden behind confidence language
- the final verdict is stricter than narrative optimism
