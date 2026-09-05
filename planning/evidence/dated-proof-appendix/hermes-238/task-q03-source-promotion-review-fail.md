# HERMES-238 — TASK-Q03 Source-Promotion Review Failure

## Verdict

`FAIL_P1_WRONG_REPOSITORY_PATH`

The local commit `07d3b81cfa8104466c0c995d2ce9076d7c18ee31` has the correct
parent, branch and 29 file contents, but it is not promotable. The files were
transplanted into the Hermes repository root instead of the required path
`apps/mcp-servers/plane-mcp-karval/`.

Evidence:

```text
git ls-tree -r HEAD -- apps/mcp-servers/plane-mcp-karval  # zero paths
git cat-file -e HEAD:apps/mcp-servers/plane-mcp-karval/pyproject.toml
# fails
```

The root-level contents hash-match the frozen P04 manifest, proving a path
transplant error rather than content corruption. The malformed commit was not
pushed, merged, activated or used for a runtime action. It is preserved as
forensic evidence and is explicitly excluded from promotion.

## Additional findings

- P2: the shared porcelain changed during Q02 but only truncated pre/post
  hashes were retained. The target app still matches its original dirty 29-path
  topology; the unrelated delta cannot be attributed retrospectively.
- P2: four trailing-whitespace additions are in frozen documentation under the
  malformed commit. They are not normalized in the correction because content
  changes would invalidate the frozen denominator.

## TASK-Q04 correction

1. Create a new isolated worktree from base
   `5273a7250dc1166381f306f43245817ac80251e6` on a distinct correction branch.
2. Transplant every manifest path under the required full repository prefix
   `apps/mcp-servers/plane-mcp-karval/`.
3. Verify both full prefixed path-set equality and content-hash equality before
   staging/commit.
4. Run package proof from the prefixed app directory and keep the external
   audit separate/failing-visible.
5. Retain full pre/post shared porcelain listings and their diff, in addition
   to index/diff fingerprints.
6. Preserve the no-push/no-merge/no-runtime/no-provider boundary.
