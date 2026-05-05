# GitHub PR Read Live Proof — 2026-04-27

## Status

- provider: GitHub
- surface: GitHub PR read/lookup helper
- result: passed
- sensitivity: redacted/non-sensitive summary only

## Evidence Boundary

The live proof was captured during the runtime adapter implementation closure and
used a temporary repository PR. This appendix intentionally stores only the
non-sensitive proof summary required by the capability manifest; repository,
branch, PR number, comments, tokens, account identifiers, and any provider
response payloads are not stored here.

## Source Closure

See `planning/executive/2026-04-27-runtime-adapter-implementation-closure.md`,
section "Live Proof Already Captured".

## Promotion Boundary

This proof supports `github-pr.read_lookup`. It does not promote GitHub PR
create/update, closure comments, or land/merge behavior.
