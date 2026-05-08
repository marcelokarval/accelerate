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
| Linear read/lookup | Linear | `planned` | blocked readiness appendix: `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md`; historical external-host proof remains `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-04-27.md` | none for repo-local path | structured GraphQL helper exists and RC13 preflight fails closed without `LINEAR_API_KEY`/safe fixture; no live non-sensitive fixture proof has been recorded | run repo-local `preflight-linear-mcp-live-fixture.sh`, then `read-linear-mcp-adapter.sh` live proof with non-sensitive fixture |
| Linear create/update | Linear | `planned` | blocked readiness appendix: `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` | none | `LINEAR_API_KEY`, `ACCELERATE_LINEAR_LIVE_FIXTURE=1`, fixture team, and fixture status are required; no live fixture proof yet; `structured_non_llm_mcp_write_binding_required` remains the promotion gate until live proof is recorded | pass repo-local preflight, create a fixture issue through `create-linear-mcp-issue.sh`, and record proof locator |
| Linear artifact attachment | Linear | `planned` | blocked readiness appendix: `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` | none | export approval, `LINEAR_API_KEY`, explicit live-fixture opt-in, fixture team, and fixture status required; no live fixture proof yet | comment an export-approved fixture artifact through `attach-linear-mcp-artifact.sh` and record proof locator |
| Linear closure comment | Linear | `planned` | blocked readiness appendix: `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` | none | structured GraphQL helper exists; `LINEAR_API_KEY`, explicit live-fixture opt-in, privacy gate, and no live fixture proof yet | write a non-sensitive closure comment through `comment-linear-mcp-closure.sh` and record proof locator |
| Linear status transition | Linear | `planned` | blocked readiness appendix: `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` | none | structured GraphQL helper exists; preflight requires safe target status and no live fixture proof yet | transition a non-sensitive fixture through `update-linear-mcp-status.sh` and record proof locator |

## Remote Write Registry Summary

| Registry ID | Provider | Operation | Status | Proof locator | Residual |
| --- | --- | --- | --- | --- | --- |
| `github-pr-create` | GitHub | create PR | `available` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | opt-in required |
| `github-pr-comment-artifact` | GitHub | comment artifact | `available` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | privacy gate required |
| `github-pr-closure-comment` | GitHub | closure comment | `available` | `planning/evidence/dated-proof-appendix/github-playground-live-validation-2026-05-05.md` | opt-in required |
| `github-pr-land` | GitHub | merge PR | `available` | `planning/evidence/dated-proof-appendix/github-pr-land-live-validation-2026-05-07.md` | explicit opt-in `ACCELERATE_ALLOW_LAND` still required |
| `linear-graphql-comment-artifact` | Linear | comment artifact | `planned` | blocked readiness appendix: `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` | requires `LINEAR_API_KEY` and live proof |
| `linear-mcp-create` | Linear | create issue | `planned` | blocked readiness appendix: `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` | structured non-LLM GraphQL path exists; live fixture proof still required |
| `linear-mcp-comment-artifact` | Linear | comment artifact | `planned` | blocked readiness appendix: `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` | structured non-LLM GraphQL path exists; export-approved live fixture proof still required |
| `linear-mcp-closure-comment` | Linear | closure comment | `planned` | blocked readiness appendix: `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` | structured non-LLM GraphQL path exists; live fixture proof still required |
| `linear-mcp-status-transition` | Linear | status transition | `planned` | blocked readiness appendix: `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md` | structured non-LLM GraphQL path exists; safe status and live fixture proof still required |

## Current Priority Follow-ups

1. Keep GitHub PR land/merge available only through the guarded adapter path and
   durable proof in `planning/evidence/dated-proof-appendix/github-pr-land-live-validation-2026-05-07.md`.
2. Keep Linear structured paths `planned` until non-sensitive live fixture proof is
   recorded with durable proof locators; RC13 adds repo-local live-fixture
   preflight for credential/opt-in/team/status readiness, but live availability
   remains unpromoted while `LINEAR_API_KEY` and safe fixture settings are absent.
3. Treat RC9/RC15 skill generated export as `available` only for repo-local proof
   artifacts and temp/approved generated host-runtime proof
   (`scripts/export-skill-proof.sh`, `tests/skill-export-proof.sh`, and
   `planning/evidence/dated-proof-appendix/skill-export-proof-2026-05-08.md`);
   real user-home host runtime installation remains `planned`.
4. Treat RC10 agent factory replay as fixture-scoped `proof-replay` only; the
   autonomous runtime stays `blocked` until runtime binding proof exists.
5. Do not promote any capability using only local substitute evidence.
6. Update this dashboard whenever `adapters/workflow/*/capabilities.yaml` or
   `adapters/workflow/remote-write-registry.yaml` changes.

## Control Plane Proof Follow-through

| Capability | Status | Proof locator | Residual | Next promotion condition |
| --- | --- | --- | --- | --- |
| Skill generated export proof | `available` for repo-local proof artifact and temp/approved generated host-runtime proof only | `scripts/export-skill-proof.sh`; `tests/skill-export-proof.sh`; `planning/evidence/dated-proof-appendix/skill-export-proof-2026-05-08.md` | Real host/user-home runtime catalogs are not authority and were not written by the proof; generated host target is cleaned up/rolled back. | Run the same provenance/drift/cleanup contract against a real approved non-user-home generated host target before any host install promotion. |
| Bounded proof-auditor candidate replay | `proof-replay` | `agents/promotion/bounded-proof-auditor-replay.md`; `planning/promotion/replay-fixtures/bounded-proof-auditor.md`; `planning/evidence/dated-proof-appendix/agent-factory-replay-2026-05-08.md`; `tests/promotion-replay-fixtures.sh` | Fixture-scoped only; no runtime binding, installation, persistent agent, or autonomous availability. | Add real runtime binding, lifecycle monitoring, cleanup/idle-agent proof, demotion route, and root acceptance. |
