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
| PR land/merge | GitHub PR | `planned` | none | none | only dry-run proof exists | create separate disposable playground PR and land it for live proof |
| Linear read/lookup | Linear | `planned` | `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-04-27.md` | 2026-04-27 external host | repo-local helper still lacks decisive read proof | run repo-local structured read proof with non-sensitive fixture |
| Linear create/update | Linear | `blocked` | `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-04-27.md` | 2026-04-27 external host | `structured_non_llm_mcp_write_binding_required` | add structured non-LLM MCP write binding and live fixture proof |
| Linear artifact attachment | Linear | `blocked` | `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-04-27.md` | 2026-04-27 external host | `structured_non_llm_mcp_write_binding_required` | add structured non-LLM MCP attachment binding and live fixture proof |
| Linear closure comment | Linear | `blocked` | `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-04-27.md` | 2026-04-27 external host | `structured_non_llm_mcp_write_binding_required` | prove structured closure write with privacy gate |
| Linear status transition | Linear | `blocked` | `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-04-27.md` | 2026-04-27 external host | `structured_non_llm_mcp_write_binding_required` | prove structured status transition on fixture issue |

## Remote Write Registry Summary

| Registry ID | Provider | Operation | Status | Proof locator | Residual |
| --- | --- | --- | --- | --- | --- |
| `github-pr-create` | GitHub | create PR | `available` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | opt-in required |
| `github-pr-comment-artifact` | GitHub | comment artifact | `available` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | privacy gate required |
| `github-pr-closure-comment` | GitHub | closure comment | `available` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | opt-in required |
| `github-pr-land` | GitHub | merge PR | `planned` | none | live merge proof absent |
| `linear-graphql-comment-artifact` | Linear | comment artifact | `planned` | none | requires `LINEAR_API_KEY` and live proof |
| `linear-mcp-create` | Linear | create issue | `blocked` | `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-04-27.md` | structured write is `no` |
| `linear-mcp-comment-artifact` | Linear | comment artifact | `blocked` | `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-04-27.md` | structured write is `no` |

## Current Priority Follow-ups

1. Keep GitHub PR land/merge `planned` until a separate disposable playground PR
   is landed for real.
2. Keep Linear writes `blocked` until structured non-LLM MCP write bindings exist
   and are proven through a non-sensitive fixture.
3. Do not promote any capability using only local substitute evidence.
4. Update this dashboard whenever `adapters/workflow/*/capabilities.yaml` or
   `adapters/workflow/remote-write-registry.yaml` changes.
