# Capability Maturity Dashboard

This dashboard summarizes remote-write and workflow-adapter maturity without
promoting anything beyond proven capability. It is intentionally conservative:
`available` requires durable, non-sensitive proof; `planned` means the command or
shape exists but lacks decisive live proof; `blocked` means a named blocker must
be removed first; `substitute` means local recovery or non-remote evidence only.

## Status Vocabulary

| Status | Meaning |
| --- | --- |
| `available` / `native` | Live or native proof exists and the capability may be used under its gates. |
| `linked` | Capability is derived from another local gate/artifact rather than direct remote mutation. |
| `planned` | Intended surface exists but proof is absent or incomplete. |
| `blocked` | Must not be used as a real remote write until the named blocker is removed. |
| `substitute` | Local substitute/recovery only; not equivalent to remote provider truth. |

## Workflow Adapter Summary

| Capability | Adapter | Status | Proof locator | Last live test | Residual | Next promotion condition |
| --- | --- | --- | --- | --- | --- | --- |
| PR read/lookup | GitHub PR | `native` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | 2026-05-05 | none known | keep proof locator durable |
| PR create/update | GitHub PR | `native` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | 2026-05-05 | opt-in required for creation | preserve playground proof and privacy gate |
| PR review artifact comment | GitHub PR | `native` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | 2026-05-05 | privacy gate required | keep artifact body non-sensitive |
| PR closure comment | GitHub PR | `native` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | 2026-05-05 | opt-in required for closure comment | keep closure comment proof linked |
| PR metadata rehydration | GitHub PR | `native` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | 2026-05-05 | none known | preserve PR fixture or replacement fixture |
| PR land/merge | GitHub PR | `native` | `planning/evidence/dated-proof-appendix/github-pr-land-live-validation-2026-05-07.md` | 2026-05-07 | bounded to disposable playground PR proof; still requires `ACCELERATE_ALLOW_LAND` and land gates | keep proof locator durable and use only through guarded adapter path |
| Linear read/lookup | Linear | `planned` | none for repo-local structured path; historical external-host proof remains `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-04-27.md` | none for repo-local path | structured GraphQL helper exists but no live non-sensitive fixture proof has been recorded | run repo-local `read-linear-mcp-adapter.sh` live proof with non-sensitive fixture |
| Linear create/update | Linear | `planned` | none for repo-local structured path | none | `LINEAR_API_KEY` and explicit non-sensitive fixture are required; no live fixture proof yet | create a fixture issue through `create-linear-mcp-issue.sh` and record proof locator |
| Linear artifact attachment | Linear | `planned` | none for repo-local structured path | none | export approval and `LINEAR_API_KEY` required; no live fixture proof yet | comment an export-approved fixture artifact through `attach-linear-mcp-artifact.sh` and record proof locator |
| Linear closure comment | Linear | `blocked` | none | none | dedicated closure-comment script not implemented in this cycle | implement guarded structured closure-comment helper and prove fixture write |
| Linear status transition | Linear | `blocked` | none | none | dedicated status-transition script not implemented in this cycle | implement guarded structured status-transition helper and prove fixture transition |

## Remote Write Registry Summary

| Registry ID | Provider | Operation | Status | Proof locator | Residual |
| --- | --- | --- | --- | --- | --- |
| `github-pr-create` | GitHub | create PR | `available` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | opt-in required |
| `github-pr-comment-artifact` | GitHub | comment artifact | `available` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | privacy gate required |
| `github-pr-closure-comment` | GitHub | closure comment | `available` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | opt-in required |
| `github-pr-land` | GitHub | merge PR | `available` | `planning/evidence/dated-proof-appendix/github-pr-land-live-validation-2026-05-07.md` | explicit opt-in `ACCELERATE_ALLOW_LAND` still required |
| `linear-graphql-comment-artifact` | Linear | comment artifact | `planned` | none | requires `LINEAR_API_KEY` and live proof |
| `linear-mcp-create` | Linear | create issue | `planned` | none | structured non-LLM GraphQL path exists; live fixture proof still required |
| `linear-mcp-comment-artifact` | Linear | comment artifact | `planned` | none | structured non-LLM GraphQL path exists; export-approved live fixture proof still required |

## Current Priority Follow-ups

1. Keep GitHub PR land/merge available only through the guarded adapter path and
   durable proof in `planning/evidence/dated-proof-appendix/github-pr-land-live-validation-2026-05-07.md`.
2. Keep Linear structured paths `planned` (or `blocked` for unimplemented operations)
   until non-sensitive live fixture proof is recorded with durable proof locators;
   the former `structured_non_llm_mcp_write_binding_required` blocker is only
   cleared for the repo-local read/create/artifact-comment helper shape, not for
   live availability, closure comments, or status transitions.
3. Do not promote any capability using only local substitute evidence.
4. Update this dashboard whenever `adapters/workflow/*/capabilities.yaml` or
   `adapters/workflow/remote-write-registry.yaml` changes.
