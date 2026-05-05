# Runtime, Adapter, References, and Agent Promotion Hardening Task Ledger

## Purpose

One-shot task ledger for the 2026-05-05 hardening run. The master session is orchestrator/final reviewer. Execution and skeptical review were delegated to bounded subagents.

## Task Breakdown

| ID | Task | Goal | Executor scope | Dependencies | Files or surfaces | Acceptance | Proof | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| T0 | Plan and orchestration artifacts | Persist executive plan and task ledger | master/orchestrator only | none | `planning/executive/2026-05-05-runtime-adapter-hardening-executive-plan.md`, this file | Plan states scope, success, risks, proof, batches | file exists; final review references it | done |
| T1 | Seal GitHub PR adapter safety | Strict args/modes/repo slug checks and default test coverage | implementation subagent | T0 | GitHub PR helper scripts, `tests/github-pr-*`, `tests/all.sh` | Fail-closed parsing; canonical tests include adapter safety | `tests/github-pr-adapter-safety.sh`, `tests/all.sh` | done |
| T2 | Align local workspace V2 docs and schema init | Remove stale V2/V3 ambiguity and make init workflow validator-safe | implementation subagent | T0 | local workspace docs, v2 contract, `init-local-workflow.sh`, local workflow tests | Init-created active work item validates; docs acknowledge V2 local workflow identity | `tests/local-workflow-adapter.sh` | done |
| T3 | Promote production readiness into local runtime truth | Make production/deploy readiness visible in dashboard/evidence/handoff/closure | implementation subagent | T2 | status templates, readiness scripts, handoff/closure renderers, production tests | Production readiness remains optional unless in scope but visible when used | `tests/production-readiness-gate.sh`, `tests/local-workspace-proof-gates.sh` | done |
| T4 | Add deploy verification packet helper | Deterministic render/persist/prep flow for deploy verification packet | implementation subagent | T3 | deploy helper, README, production readiness tests | Generated packet can satisfy checker; placeholder remains blocked | `tests/production-readiness-gate.sh` | done |
| T5 | Strengthen rehydration/reentry and dashboard cockpit | Better restore/read-handoff/context/dashboard status | implementation subagent | T2/T3 | handoff/context/bootstrap/status scripts/templates/tests | Fresh session can see active work item, readiness, evidence, next action | `tests/local-workflow-adapter.sh`, `tests/local-workspace-scenario-matrix.sh` | done |
| T6 | Harden local work-item lifecycle | Allowed transitions, done proof guard, list/select/recovery helpers | implementation subagent | T2 | local work-item scripts/docs/tests | Direct unsafe done blocked unless explicit exception; prior work items discoverable | `tests/local-workflow-adapter.sh` | done |
| T7 | Remove or isolate dead proof-writing function | Resolve unused `auto_prepare_theme_portability()` safely | implementation subagent | T0 | `check-evidence-gate.sh`, proof gate tests | No dead proof-writing function in gate; deterministic evidence gate | `tests/local-workspace-proof-gates.sh` | done |
| T8 | Add Authority Set Gate | Classify authorities/references/decision/backend/forbidden sources | implementation subagent | T0 | new gate doc, root docs, packet templates, references docs, global runtime mirrors | No unqualified `active references` terminology remains except deprecation notes | `tests/authority-set-gate.sh` | done |
| T9 | Neutralize Linear-shaped leakage | Backend-neutral lifecycle semantics; Linear-specific mapping isolated | implementation subagent | T8 | core issue topology, adapter contract, Linear docs | Core no longer names Linear as unqualified default backend | `tests/workflow-backend-neutrality.sh` + manual grep | done |
| T10 | Expand workflow capability manifests | Exact capability matrix and schema/test enforcement | implementation subagent | T8/T9 | capability manifests/schema/tests | Every adapter declares requested capabilities with honest statuses/proofs | `tests/workflow-adapter-contract.sh`, `tests/manifest-truth-gate.sh` | done |
| T11 | Normalize remote rehydration packets | GitHub PR rehydration writes normalized Accelerate packet plus raw evidence | implementation subagent | T10 | rehydrate helper, provider-state contract, validator/tests | Packet has identity/url/lifecycle/artifacts/gaps/raw path | `tests/github-pr-adapter-safety.sh`, `tests/workflow-adapter-contract.sh` | done |
| T12 | Split review artifact vs closure comment | Separate closure traceability from generic review comments | implementation subagent | T10 | provider comment contract, closure helper, registry, tests | Closure helper requires approved closure artifact/markers; review attach unchanged | `tests/github-pr-adapter-safety.sh`, `tests/remote-write-registry.sh` | done |
| T13 | Make recovery packets retry-ready | Recovery helpers emit schema-rich retry artifacts | implementation subagent | T10 | recovery helpers, validator/tests/contracts | Zero-context retry data present; invalid unknown packets rejected | `tests/github-pr-adapter-safety.sh` | done |
| T14 | Harden GitHub PR create/update capability | Default branch/base handling, update helper, manifest honesty | implementation subagent | T10 | create/update helper, manifest, registry, tests | Guarded create/update path; planned status honest without live proof | `tests/github-pr-adapter-safety.sh`, `tests/remote-write-registry.sh` | done |
| T15 | Require closure proof before GitHub PR land | Land gate checks closure proof before merge | implementation subagent | T12/T14 | `land-github-pr.sh`, ship/production checks, registry/tests | Dry-run and real land fail closed without closure proof/export approval | `tests/github-pr-adapter-safety.sh`, `tests/production-readiness-gate.sh` | done |
| T16 | Add adapter capability selection summary | Machine-readable command for root capability decisions | implementation subagent | T10 | capability read/select helpers, docs/tests | Requested unavailable capability returns planned/blocked/none fail-closed | manual final probe + `tests/workflow-adapter-contract.sh` | done |
| T17 | Add agent promotion/install/export contract | Explicit states from template-only to promoted and rollback/export proof | implementation subagent | T0 | agent promotion docs, template packet, runtime adapter docs, tests | Reader can distinguish doctrine/candidate/runtime-bound/installed/exported/promoted | `tests/agent-install-export-contract.sh` | done |
| T18 | Enforce host export schema | Strengthen generic host export manifest without implying promoted agents | implementation subagent | T17 | host export contract, export script, host export tests | Output includes source/target/authority/privacy/validation; path traversal blocked; validation command self-contained | `tests/host-export-contract.sh` + manual neutral-cwd validation | done |
| T19 | Integration reconciliation | Resolve cross-task conflicts, update indexes/tests, run full suite | integration/fix subagents + root | T1-T18 | overlapping docs/tests/manifests | `tests/all.sh` passes and docs/tests agree | `bash tests/all.sh`, `git diff --check` | done |
| T20 | Independent review wave | Skeptical review per changed workstream | reviewer subagents | T1-T19 | git diff, tests, task ledger | Defects recorded with correction owner/reproof | reviewer summaries + correction subagent | done |
| T21 | Master final forensic review | Final requested-vs-implemented and closure judgment | master/orchestrator | T20 | full diff/proof/reviews | Done only if evidence supports it | final review artifact | done |

## One-Shot Review Ledger

| Task ID | Requested Outcome | Executor Mode | Executor Identity | Implemented Evidence | Expected Proof | Actual Proof | Reviewer Mode | Reviewer Identity | Review Independence | Side-By-Side Judgment | Review-Of-Review Status | Defects Found | Correction Owner | Correction Summary | Reproof Evidence | Closure Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| T0 | Plan artifacts | master orchestration | root | executive plan + task ledger | file read | files persisted and indexed | n/a | n/a | n/a | accepted | accepted | none | n/a | n/a | final review references plan | closed |
| T1-T19 | Implement bounded hardening slices | physical delegated subagents | implementation agents | broad docs/scripts/manifests/tests changed | focused tests + full suite | focused tests and `tests/all.sh` passed | physical delegated reviewers | reviewer agents | independent of executor | accepted after corrections | accepted | selector fail-open; land/export proof gap; recovery validation gap; Linear leakage; host export validation gap; duplicate manifest key | bounded correction subagent | fixed fail-closed selector, land export approval, recovery enum/unknown rejection, Linear wording/tests, host export validation command, duplicate key detection | focused tests, `tests/all.sh`, manual root probes | closed |
| T20 | Independent review wave | physical delegated reviewers | reviewer agents | review summaries | review evidence | two substantive reviews + one wrong-worktree review discarded as evidence | master | root | independent-of-execution | accepted with caveat | accepted | wrong-worktree local workspace review was not counted | root | compensated with direct final tests/probes | local workspace/proof/production tests + full suite | closed |
| T21 | Final forensic closure | master | root | final review artifact | full suite + review-of-review | `tests/all.sh`, manual probes, `git diff --check`, process list empty | n/a | n/a | n/a | supported after residual correction | supported | D8-D10 found in replacement local-workspace review and fixed | root | fixed production readiness semantics, current-state list/select, and done proof guard | focused local workspace/production tests + full suite | closed |

## Defect Ledger

| Defect ID | Task ID | Severity | Finding | Owner | Correction Status | Reproof Evidence | Residual Risk | Disposition |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| D1 | T16 | blocking | Capability selector exited 0 for planned unavailable capability | correction subagent | fixed | manual final probe exit `3`; `tests/workflow-adapter-contract.sh`; `tests/all.sh` | none known | closed |
| D2 | T15 | blocking | PR land accepted closure artifact without export approval | correction subagent | fixed | `tests/github-pr-adapter-safety.sh`; `tests/all.sh` | no real remote land executed | closed |
| D3 | T13 | blocking | Recovery validation accepted unknown repo/invalid operation | correction subagent | fixed | `tests/github-pr-adapter-safety.sh`; `tests/all.sh` | operation enum may need future expansion | closed |
| D4 | T9 | blocking | Workflow README leaked Linear/default backend language | correction subagent | fixed | `tests/workflow-backend-neutrality.sh`; manual grep | none known | closed |
| D5 | T18 | blocking | Host export validation command was not self-contained | correction subagent | fixed | `tests/host-export-contract.sh`; manual neutral-cwd command execution | none known | closed |
| D6 | T10 | non-blocking | Duplicate YAML key in GitHub PR capabilities | correction subagent | fixed | duplicate-key detection in `tests/workflow-adapter-contract.sh`; `tests/all.sh` | none known | closed |
| D7 | T20 | process | One reviewer inspected wrong worktree for local workspace review | root | mitigated then replaced | replacement local-workspace review plus focused regression tests | none known after replacement review fixes | closed |
| D8 | T3/T4 | blocking | Production readiness accepted failed CI / weak deploy evidence because packet markers were treated as truth | root | fixed | `tests/production-readiness-gate.sh` negative cases for failed CI, weak canary, weak rollback | still contract-level, not live provider deployment proof | closed |
| D9 | T5/T6 | blocking | Local work item list/select reconstructed creation-time state and could stale/revert lifecycle/topology | root | fixed | `tests/local-workflow-adapter.sh` list/select-after-transition and topology-preservation checks | none known | closed |
| D10 | T6 | blocking | Non-planned transitions into `done` bypassed closure-ready proof | root | fixed | `tests/local-workflow-adapter.sh` blocked `in_progress -> done`, blocked `review -> done`, allowed proof-backed `closure -> done` | none known | closed |

## Verification Plan

Final root verification completed:

- `bash tests/local-workspace-proof-gates.sh` — passed.
- `bash tests/local-workspace-scenario-matrix.sh` — passed.
- `bash tests/production-readiness-gate.sh` — passed, including failed-CI/weak-canary/weak-rollback negative cases.
- `bash tests/local-workflow-adapter.sh` — passed, including list/select current-state preservation and done-proof guard regressions.
- `bash tests/all.sh` — passed after final-review artifact update.
- `git diff --check` — passed after final-review artifact update.
- Planned capability selection manual probe — failed closed with exit `3`.
- Host export manifest validation command manual probe — passed from neutral cwd.
- Linear/default leakage manual grep — passed.
- `process list` — empty before closure.

## Active Agent Cleanup Rule

Every delegated subagent result returned through the delegation tool and no background process remains active. `process list` was empty before final closure.
