# Runtime Packets

This layer is the native home of packet schemas, cadence rules, and explicit
QA/proof-lane ownership that keep the `accelerate` control plane visible during
execution.

Runtime packets are not prose decoration. A packet is a compact contract that
names the decision surface, binding, proof expectation, and residuals needed to
keep a branch rehydratable.

## Packet Index

| Packet | Trigger | Required fields | Gate / owner | Test coverage |
| --- | --- | --- | --- | --- |
| `templates.md` | Canonical generic packet shapes | Branch Entry, Runtime Delta, Closure and review packet fields | `accelerate` root runtime | `tests/doc-snippet-integrity.sh`, `tests/generated-docs-integrity.sh` |
| `cadence.md` | Long-running execution needs visibility cadence | checkpoint type, elapsed time, next proof | Runtime observability cadence | `tests/all.sh` indirect integrity |
| `prompt-upgrade-approval-packet.md` | Prompt hardening changes scope/authority | original prompt, upgrade, approval state | Prompt Hardening Gate | `tests/all.sh` indirect integrity |
| `agent-promotion-packet.md` | Agent/template promotion is proposed | source, evidence, export scope, rollback | Agent promotion governance | `tests/agent-install-export-contract.sh`, `tests/template-promotion-readiness.sh` |
| `agent-return-packet.md` | Delegated lane returns work | scope, evidence, residuals, handoff | Subagent return contract | `tests/subagent-routing-policy.sh` |
| `qa-proof-stack.md` | QA/proof lane is opened | proof type, order, artifact locator | QA Proof Stack | `tests/runtime-proof-fixtures.sh` |
| `browser-proof-packet.md` | Browser truth is required | browser target, observed behavior, capture/proof | Browser proof routing | `tests/runtime-proof-fixtures.sh` |
| `visual-modeling-packet.md` | Structural diagram is required before implementation or closure | diagram type, source truth, binding, residual ambiguity | Visual Modeling Gate | `tests/visual-modeling-contract.sh` |
| `observability-performance-packet.md` | Performance/observability behavior matters | metric, trace/log source, threshold, residual | Observability/performance review | `tests/all.sh` indirect integrity |
| `design-implementation-proof-packet.md` | Design implementation proof is needed | reference, implementation proof, comparison | Design implementation proof | `tests/design-system-artifact-consistency.sh` |
| `ux-ui-fullstack-surface-packet.md` | UI and backend truth interact | surface, props/API binding, runtime proof | Product/runtime review | `tests/all.sh` indirect integrity |
| `product-critical-closure-packet.md` | Product-critical flow is closing | acceptance, QA proof, residual risk | Product critical closure | `tests/all.sh` indirect integrity |
| `requested-vs-implemented-packet.md` | Review must compare ask vs delivery | requested, implemented, gap, resolution | Requested vs implemented review | `tests/all.sh` indirect integrity |
| `defect-ledger-packet.md` | Defect correction loop opens | defect, reproduction, fix, regression proof | Correction loop | `tests/all.sh` indirect integrity |
| `correction-loop-packet.md` | Review finds semantic residuals | finding, correction, proof, closure | Correction loop | `tests/all.sh` indirect integrity |
| `seam-proof-packet.md` | Integration seam must be proven | seam, fixture, proof artifact, residual | Seam proof | `tests/local-workspace-proof-gate.sh` |
| `ship-readiness-packet.md` | Landing/release readiness is checked | readiness gates, approvals, rollback | Production readiness gate | `tests/production-readiness-gate.sh` |
| `deploy-verification-packet.md` | Deployment/provider verification is required | provider, build/deploy result, runtime check | Deploy verification | `tests/all.sh` indirect integrity |
| `review-readiness-dashboard.md` | Review lane needs status dashboard | readiness status, blockers, evidence | Review readiness | `tests/all.sh` indirect integrity |
| `review-finding-schema.md` | Findings need durable structure | severity, file/surface, evidence, resolution | Review architecture | `tests/all.sh` indirect integrity |
| `task-ledger-schema.md` | Multi-task execution needs durable ledger | task, owner, status, proof | Task ledger | `tests/all.sh` indirect integrity |
| `context-checkpoint-packet.md` | Context handoff is needed | state, decisions, next action, proof | Runtime continuity | `tests/all.sh` indirect integrity |
| `learning-record-schema.md` | Reusable learning is captured | lesson, scope, promotion status | Learning disposition | `tests/all.sh` indirect integrity |
| `timeline-event-schema.md` | Timeline needs durable events | event, timestamp, actor, evidence | Timeline checkpoint | `tests/all.sh` indirect integrity |
| `decision-audit-trail.md` | Decisions need traceability | decision, alternatives, authority, residual | Architecture/review governance | `tests/all.sh` indirect integrity |
| `theme-swap-proof-packet.md` | Theme changes need proof | before/after, tokens, visual check | Theme/template portability | `tests/theme-template-portability.sh` |
| `template-swap-proof-packet.md` | Template changes need proof | source, swap, compatibility, proof | Theme/template portability | `tests/theme-template-portability.sh` |
| `document-cohesion-size-packet.md` | Document split/merge/cohesion matters | file, size, cohesion claim, action | Document Cohesion Size Gate | `tests/doc-snippet-integrity.sh` |
| `manual-review-contradiction-packet.md` | Manual review contradicts automation | contradiction, source, resolution | Review architecture | `tests/all.sh` indirect integrity |
| `execution-to-spec-loop-packet.md` | Implementation must reconcile to spec | spec, implementation, mismatch, proof | Execution/spec loop | `tests/all.sh` indirect integrity |
| `systemic-ui-inconsistency-audit-packet.md` | UI inconsistency audit is required | surface, inconsistency, correction, proof | Premium/product review | `tests/all.sh` indirect integrity |
| `document-export-packet.md` | Document export/publication is required | source, target, verification, residual | Document export | `tests/all.sh` indirect integrity |
| `design-baseline-packet.md` | Baseline design truth is captured | benchmark, tokens, reference, residual | Design baseline | `tests/design-md-corpus-integrity.sh` |
| `design-feedback-packet.md` | Design feedback is received | feedback, target, decision, residual | Design review | `tests/all.sh` indirect integrity |
| `design-approval-packet.md` | Design approval is recorded | approver, surface, conditions, residual | Design approval | `tests/all.sh` indirect integrity |
| `qa-report-packet.md` | QA report is emitted | scope, tests, findings, verdict | QA proof stack | `tests/all.sh` indirect integrity |
| `safety-overlay-state.md` | Safety overlay is active | overlay, trigger, action, residual | Safety overlay | `tests/all.sh` indirect integrity |

## Required Maintenance Rule

When adding a new packet file under `core/runtime-packets/`, update this index
with:

- trigger;
- required fields or packet contract summary;
- gate/owner;
- test coverage, even if indirect.

## Inherited References

Supporting inherited detail may still exist in:

- `references/runtime-packet-templates.md`
- `references/runtime-observability-cadence.md`
