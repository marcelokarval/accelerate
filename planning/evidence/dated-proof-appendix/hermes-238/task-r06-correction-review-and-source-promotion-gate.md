# HERMES-238 — TASK-R06 Correction Review and Source-Promotion Gate

## Decision

`GO_LOCAL_CANDIDATE_TO_SOURCE_PROMOTION_REVIEW`

The sparse lifecycle correction resolves the independent review's original P1:
the real, packaged and allowlisted sparse profile can represent semantic REVIEW
as evidence while the provider remains in `In Progress`, then execute exactly
one `Done` PATCH for FINISH. This is a local-candidate decision only. It does
not authorize a commit, push, runtime promotion, MCP restart, or retry of
CODEX-26 closure.

## Authority and work item

- Governing source target: `~/.hermes/apps/mcp-servers/plane-mcp-karval/`
- Governed remediation issue: `HERMES-238` /
  `0422f8c3-4c7b-48e8-8018-682ae32c4229`
- Provider lifecycle mutation in this wave: none.
- Runtime mutation in this wave: none.

## Corrected candidate freeze

| Surface | SHA-256 |
| --- | --- |
| `pyproject.toml` | `66f884bc5a276d7a4e9967ce1a683291604ca63bfec9a472895da301d1e7a46c` |
| lifecycle contract | `2d081fc65d8de1b67cc510284db84e03b79436a390ba47a9d3e2afb9c10190ec` |
| MCP server | `1341d58a9851d31df475703573df086f1881823c12551c6953da40e111e5323f` |
| canonical registry | `c52cfd2ec5db3fe78844dc4c89f3482e665b8d4aa4b2ab82008ff0e9ef8283b2` |
| sparse fixture registry | `d8730e4f20432c3687ec3d439d314eebab63bb0f30df1375760e0bf9c53e6bc3` |
| lifecycle tests | `2566e51552d2765ba0174314c83fc9a7b5f3c271763fa66cb1a2a8043beeac3b` |
| MCP tests | `c1a5e7eda736be27ebb621485da30c66d1182c6880f6bb0946c0d272437e0f33` |

## Correction and independent re-review

The first independent review rejected the candidate because a sparse registry
was an empty/identity-mismatched placeholder, the integration route hid that
fact with a loader monkeypatch, and the asset was not packaged.

The corrected candidate:

- resolves an allowlisted fixed-name profile; callers cannot supply a path or
  live provider identifier;
- verifies provider, workspace, project, catalog and approved revision against
  the trusted profile; a foreign identity fails closed;
- explicitly includes both registry assets in the wheel;
- uses the real loader and verifier in the sparse-path test;
- proves ordered subactions: REVIEW evidence comment, one state PATCH, FINISH
  comment, with readbacks; and
- retains dense-path and recovery coverage.

The second independent reviewer returned `PASS` with the above boundary
checks. The root independently reran:

```text
uv run pytest -q tests/test_plane_lifecycle_contract_v2.py tests/test_plane_mcp_karval.py
# 88 passed, 1 third-party AuthlibDeprecationWarning
uv run python -m compileall -q src/plane_mcp_karval
# pass
git diff --check -- <TASK-R03 allowlist>
# pass
```

## Open source-promotion gate

The reviewed content is not yet an immutable source candidate:

- `lifecycle_transition_contract.py` and
  `test_plane_lifecycle_contract_v2.py` are untracked;
- `pyproject.toml`, `server.py`, and `test_plane_mcp_karval.py` have unstaged
  worktree deltas; and
- the target checkout contained unrelated pre-existing staged, unstaged and
  untracked material before this remediation.

The next governed task must establish exact ownership, stage only the approved
allowlist after a fresh index/worktree readback, freeze the staged diff, and
perform source-promotion review. It must not absorb unrelated dirty work.
Runtime promotion, fresh MCP injection, operational lifecycle retry and Plane
closure remain separate future gates.

## TASK-R07 provenance preflight

`NO_GO_SOURCE_PROMOTION_PROVENANCE_UNRESOLVED`

An independent read-only preflight established that `HEAD`
(`5273a725…`) has no `apps/mcp-servers/plane-mcp-karval` tree. The shared
index instead contains a 21-file initial import for that application. The
frozen remediation is split across staged-and-worktree-different files,
untracked files and staged matching assets, while its server imports several
other modules from the same uncommitted initial import.

Consequently, promoting only the sparse-lifecycle files cannot establish a
runnable, attributable source candidate. No historical ref establishes
provenance for the current imported blobs. The safe successor is a separate
source-provenance reconciliation: freeze the entire runnable denominator,
obtain explicit owner disposition for it, construct an isolated candidate
without changing the shared index, then re-run proof and independent
source-promotion review. No source or runtime promotion was attempted.
