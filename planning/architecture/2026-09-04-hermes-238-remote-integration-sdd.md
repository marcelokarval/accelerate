# HERMES-238 — Remote Integration and Publication SDD

## Hardened Prompt

### Prompt A

Publish and merge the promoted Plane MCP source candidate remotely.

### Prompt B

Transplant the reviewed local commit
`4e0001e094f0b40e3a1a1d94c8c75667ba57e1b8` onto freshly fetched
`origin/main` `8a661a02563b62e926a91a11122719e569bbbb3b` in a new isolated
worktree. Reprove the resulting immutable commit, obtain independent review,
then publish its dedicated branch. Create and merge a PR only when the remote
provider and protection rules permit it with fresh readback. Preserve every
prior candidate/worktree and do not promote runtime.

## Scope

- fresh remote base: `origin/main` `8a661a02563b62e926a91a11122719e569bbbb3b`;
- transplant of the reviewed v2 commit only;
- isolated commit proof, independent review, push, PR and merge where provider
  policy permits;
- remote readbacks after every external mutation.

## Non-goals

- no mutation of shared `~/.hermes` checkout/index;
- no mutation, deletion or rewriting of v1/v2 forensic branches/worktrees;
- no runtime promotion/restart/canary/MCP refresh;
- no Plane lifecycle/provider mutation, CODEX-26 retry, external catalog update
  or secret exposure.

## Tasks

| Task | Owner | Result |
| --- | --- | --- |
| TASK-U01 | root | fresh remote/base ancestry and scope freeze |
| TASK-U02 | executor | isolated transplant onto fresh origin/main and proof |
| TASK-U03 | independent reviewer | immutable integrated snapshot review |
| TASK-U04 | executor | correction loop, max 3 generations |
| TASK-U05 | root | publish branch/PR/merge preflight and external readback |
| TASK-U06 | root | remote publication/merge closure, or precise provider-policy NO-GO |

## Acceptance

1. Fresh-base candidate has `origin/main` as parent and only the approved
   Plane MCP 29-path delta.
2. Content/path hashes remain equal to the P04 denominator; no target overlap
   from the three upstream commits is silently discarded.
3. Integrated candidate passes package proof and independent review.
4. Push, PR and merge are individually read back; a protected-branch or review
   requirement is a visible stop, never bypassed.
5. Runtime remains unpromoted.
