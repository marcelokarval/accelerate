# Runtime Adapter Maturity Dashboard

This dashboard is the control-plane inventory for Accelerate runtime adapters. It
records what the repository can truthfully execute, what is only a substitute,
and what remains planned or blocked. It does not claim an autonomous runtime or
provider runtime exists beyond the proof locators listed here.

Use this file when shaping runtime work, reviewing runtime packets, or deciding
whether a runtime adapter may be promoted, demoted, or cleaned up.

## Status Vocabulary

| Status | Meaning | Status honesty rule |
| --- | --- | --- |
| `native` | Repo-owned scripts, contracts, or tests exist and can be run locally without pretending to be a remote/provider runtime. | Must have a proof locator to a repo test, script, or contract. |
| `available` | The adapter is usable for the named bounded purpose with current proof. | Must have live or fixture proof and an explicit scope boundary. |
| `substitute` | Local, dry-run, fixture, screenshot, or manual evidence exists but is not equivalent to runtime truth. | Must name the substitute boundary and promotion condition. |
| `planned` | Architecture or task intent exists, but decisive implementation/proof is absent. | Must not be used as an operational runtime adapter. |
| `blocked` | A named blocker prevents safe or honest use. | Must name blocker removal and proof needed before promotion. |
| `linked` | Governance is owned by another dashboard or manifest. | Must keep the proof locator pointing to the owning surface. |
| `deprecated` | The adapter path should no longer be selected. | Must provide cleanup or migration rule. |

## Runtime Adapter Inventory

RC14/RC19/RC25 browser-proof monitoring improvements are intentionally recorded as
contract-level runtime governance: missing server, supplied dead server PID,
server readiness, crash-after-readiness, capture-failed correction packets,
dedicated browser profile cleanup, and fixture leak checks are tested, while
persistent browser/E2E availability remains planned/unpromoted without separate
durable proof. A one-off browser capture, server-readiness packet, or
capture-failed correction packet is never a persistent E2E proof locator by
itself.

RC26 boundary preservation: this dashboard keeps three gates intentionally
separate after Linear/browser proof hardening. Persistent E2E remains `planned`
unless a repo-owned persisted regression proof is added; generated host export is
governed by `core/control-plane/skill-sync-topology.md` and is available only for
temp/approved generated targets, not user-home authority; autonomous/physical
agent runtime remains `blocked` until actual runtime adapter invocation,
lifecycle monitoring, idle cleanup, demotion routing, and root acceptance are all
proven by durable proof locators.

| Runtime adapter / posture | Status | Proof locator | Blocker | Promotion condition | Demotion condition | Cleanup rule | Owner lane |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Browser proof packet and browser truth contract | `linked` | `core/runtime-packets/browser-proof-packet.md`; `adapters/runtime/browser/browser-truth-contract.md`; `tests/browser-proof-monitoring.sh`; RC19/RC20/RC25 evidence in current cycle plan/ledger | Server readiness, server-crash-after-readiness, capture-failed correction, dedicated browser profile cleanup, and fixture leak checks are contract-tested; persistent browser/E2E availability remains planned/unpromoted unless separate persistent regression proof exists. | Promote a browser capture path only when bounded server readiness, console/network output, failure packet capture, cleanup, corrective routing, and real-capture fixture evidence all pass in the target runtime; do not promote persistent E2E from that browser capture path. | Demote to `substitute` if proof only contains screenshots, stale artifacts, no cleanup result, no server readiness/crash result, no correction signal, or no separate persisted E2E proof locator for regression claims. | Remove stale captures and temporary browser profiles from generated proof locations; retain only durable packet contracts and non-sensitive fixtures. | runtime/browser governance + QA proof lane |
| Playwright / Chrome DevTools inspection posture | `substitute` | Tooling may be available in the execution host, but repo-owned proof is only through browser truth contracts and tests, not a permanent runtime service. | No repo-owned autonomous Playwright/Chrome runtime binding is promoted here. | Add a repo-owned adapter contract, bounded fixture, cleanup trap, console/network proof, and status-honesty test. | Demote to `planned` if inspection is referenced only as an operator tool with no repo contract. | Close browser sessions after proofs; do not persist private screenshots or provider data in source control. | runtime adapter governance |
| Local shell/runtime scripts | `native` | `tests/all.sh`; `tests/recursive-self-improvement-contract.sh`; `onboarding/local-workspace/` scripts where present | Shell scripts are local helpers, not remote runtime truth. | Keep shellcheck-equivalent parse tests or direct contract tests for each promoted helper; document dry-run/live boundaries. | Demote individual helpers if parse tests fail, cleanup traps are missing, or output claims unsupported provider state. | Bounded scripts must clean temp dirs and child processes; generated outputs belong in ignored/local proof paths unless explicitly approved. | local runtime maintenance |
| Workflow adapter runtime execution | `linked` | `adapters/workflow/README.md`; `adapters/workflow/remote-write-registry.yaml`; `core/control-plane/capability-maturity-dashboard.md` | Remote write capabilities remain governed by workflow adapter proof, not by this runtime dashboard. | Promote only through adapter-specific structured proof and capability dashboard update. | Demote if manifest/proof drift is detected or provider write proof is missing. | Keep provider responses out of generic runtime docs; store approved proof under planning evidence only when safe. | workflow adapter owner lane |
| Remote runtime adapters beyond browser/workflow | `planned` | This dashboard; target architecture references in `docs/architecture/accelerate-control-plane.md` | No implemented remote runtime adapter stack is proven in this cycle. | Create adapter manifest, fixture/live proof, failure mode, cleanup rule, and tests before any `available` status. | Demote to `blocked` if remote execution requires secrets, unsafe side effects, or unverifiable provider state. | Delete generated credentials, tokens, screenshots, and private payloads; never commit them. | runtime architecture lane |
| Autonomous agent runtime | `blocked` | `core/control-plane/agent-factory-promotion-pipeline.md`; fixture replay appendix `planning/evidence/dated-proof-appendix/agent-factory-replay-2026-05-08.md`; `tests/promotion-replay-fixtures.sh` prove only candidate proof-replay and RC16/RC26 runtime-bound checklist criteria. | This repository is still pre-agents; replay is fixture-scoped, the physical-agent adapter is planned/not implemented, and no autonomous runtime binding exists. | Requires actual runtime adapter invocation plus lifecycle monitor, idle detection, cleanup, demotion route, and root acceptance proof before `runtime-bound` or `available`. | Any claim of autonomous execution, physical-agent availability, `runtime-bound`, or `available` without invocation/lifecycle/idle/cleanup/demotion/root-acceptance proof demotes to `blocked` and triggers forensic review. | Kill unmanaged processes; retire unbound role drafts; preserve only approved docs/tests; remove generated transcripts/caches/private payloads unless explicitly approved. | agent-factory governance |

## Drift Detection Contract

Run these checks before promoting a runtime adapter:

```bash
bash tests/control-plane-rc4-rc6.sh
bash tests/recursive-self-improvement-contract.sh
git diff --check
```

The drift check must compare this dashboard with adapter manifests and proof
packets. A row is drifting when it claims `native` or `available` while the proof
locator is missing, points only to a plan, or names a substitute as if it were
runtime truth.

## Promotion And Demotion Rules

Promotion requires all of the following:

1. Status vocabulary row chosen conservatively.
2. Durable proof locator exists in this repository or in an approved evidence
   appendix.
3. Promotion condition is met by a bounded test, fixture, or live non-sensitive
   proof.
4. Blocker is removed or explicitly downgraded with rationale.
5. Cleanup rule proves no unmanaged server, browser, child process, secret,
   screenshot, or provider payload remains in source control.

Demotion is required when proof is stale, adapter manifests drift, test coverage
is removed, generated outputs are committed accidentally, or a row claims runtime
capability without proof.
