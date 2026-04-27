# Live Workflow Adapter Progressive Task Ledger

## Ledger Rule

This ledger follows the `One-Shot Side-By-Side Gate`: every task compares
requested vs implemented, records defects, corrects in-scope gaps, and reproves
before closure.

## Tasks

| ID | Requested Outcome | Implemented Evidence | Expected Proof | Actual Proof | Side-By-Side Judgment | Defects Found | Correction Owner | Correction Summary | Reproof Evidence | Closure Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| W1 | Define progressive complete-goal plan | `planning/executive/live-workflow-adapter-progressive-executive-plan.md` | Plan names complete goal and sequential phases | plan created | met | none | n/a | n/a | n/a | closed |
| W2 | Add local workflow adapter contract and emitted workspace shape | `adapters/workflow/local/README.md`, `.accelerate/workflow/` template files, `validate-v2.sh` | `.accelerate/workflow/` is materialized and validated | template and validator updated | met | none | n/a | n/a | local workflow test passed | closed |
| W3 | Add local work-item commands | `init-local-workflow.sh`, `create-local-work-item.sh`, `transition-local-work-item.sh`, `render-local-work-item.sh` | Work item can be created, transitioned, and rendered | commands added | met | init originally risked truncating existing ledgers | master | changed init to `touch` existing ledgers instead of truncating | local workflow test passed | closed |
| W4 | Add tests proving local workflow lifecycle | `tests/local-workflow-adapter.sh` | Tests cover emit, create, transition, render, invalid transition | test added and passed | met | grep failed on hyphen-leading assertion | master | added `grep --` in assertion helper | local workflow test passed | closed |
| W5 | Validate and forensic-review Phase 1 | validation outputs and review log | All tests pass and side-by-side review complete | validation passed | met | none open | n/a | n/a | full shell suite passed | closed |
| W6 | Attach local workflow identity to review and closure surfaces | review/closure packets, bundles, handoff summary, prepare flows | Work item ID/locator/state are visible in review and closure handoffs | workflow identity rendered and prepare flows transition state | met | prepare tests needed stabilized plan/onboarding truth | master | added test stabilization helper and packet fields | full shell suite passed | closed |
| W7 | Add local topology and one-shot ledger links | `link-local-work-item.sh`, workflow topology template, validator, tests | Parent/child/related/task-ledger links persist and rehydrate | topology command and fields added | met | none open | n/a | n/a | full shell suite passed | closed |
| W8 | Stabilize shared adapter contract from local reference | `adapter-contract.md`, `local/capabilities.yaml`, `tests/workflow-adapter-contract.sh` | Adapters expose machine-readable capability manifests before runtime claims | manifest contract and local manifest added | met | parallel validation temp-dir race | master | reran validation sequentially | full shell suite passed | closed |
| W9 | Start Linear adapter safely with planned manifest and read-first contract | `linear/capabilities.yaml`, `linear/operational-contract.md`, workflow adapter tests | Linear is planned, not fake-implemented; first implementation slice is read/rehydration | manifest and operational contract added | met | parallel validation temp-dir race repeated | master | sequential validation used for proof | full shell suite passed | closed |

## Review Log

### W1 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Avoid permanent minimum mindset | Plan states complete goal first and treats Phase 1 as sequential foundation | met |
| Progressive path | Plan names seven phases from local identity through Linear/GitHub/Jira/Notion targets | met |
| Honest first slice | Phase 1 avoids fake external backend claims | met |

No correction required.

### W2 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Local workflow adapter contract | `adapters/workflow/local/README.md` defines purpose, lifecycle states, commands, deferred scope, and complete-goal role | met |
| Emitted local workflow shape | Template now emits `.accelerate/workflow/README.md`, `adapter.yaml`, `active-work-item.yaml`, `work-items.jsonl`, `events.jsonl` | met |
| State pointers | `state.yaml` now points to workflow adapter, active work item, events, and work-item ledger | met |
| Validation | `validate-v2.sh` requires workflow files, keys, enum values, list-shaped labels, and pointer existence | met |

No correction required.

### W3 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Initialize local workflow | `init-local-workflow.sh` materializes `.accelerate/workflow/` for existing workspaces | met |
| Create stable work item | `create-local-work-item.sh` creates `LWI-YYYYMMDD-NNN` IDs and `local:<id>` locators | met |
| Lifecycle transition | `transition-local-work-item.sh` supports planned/ready/in_progress/review/closure/done/blocked/cancelled | met |
| Rehydration/render | `render-local-work-item.sh` renders the active local work-item packet | met |
| Timeline trace | Create and transition commands append local timeline events | met |

Defect found: initial `init-local-workflow.sh` used truncating redirects for
existing ledgers. That would have erased local workflow history if run again.

Correction: changed ledger initialization to `touch` so existing JSONL history is
preserved.

Reproof: `bash tests/local-workflow-adapter.sh` passed.

### W4 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Emit coverage | Test verifies `.accelerate/workflow/` files exist after `emit-v2.sh` | met |
| Create coverage | Test creates `live-workflow-adapter` work item and verifies adapter pointer, active item state, and ledger event | met |
| Render coverage | Test renders active work item and verifies slug/state | met |
| Transition coverage | Test transitions to `in_progress`, verifies active item and events/timeline | met |
| Invalid transition coverage | Test rejects invalid `shipped` lifecycle state | met |
| Done closure summary | Test transitions to `done` and verifies closure summary | met |

Defect found: assertion helper used `grep` without `--`, so a needle beginning
with `-` was interpreted as a grep option.

Correction: assertion helper now uses `grep -Fq --`.

Reproof: `bash tests/local-workflow-adapter.sh` passed.

### W5 Validation Evidence

| Validation | Result |
| --- | --- |
| `bash tests/local-workflow-adapter.sh` | passed |
| `bash tests/doctrine-integrity.sh` | passed and includes local workflow adapter test |
| `bash tests/local-workspace-proof-gates.sh` | passed |
| `bash tests/profile-integrity.sh` | passed |
| `git diff --check` | passed |
| `for test_file in tests/*.sh; do bash "$test_file"; done` | passed |

## Phase 1 Forensic Reconciliation

| Comparison | Expected | Actual | Judgment |
| --- | --- | --- | --- |
| User direction | Progress toward complete Goal, not a permanent minimum | Plan names complete live workflow adapter goal and seven sequential phases | met |
| Honest first slice | Start local but do not fake remote adapters | Local adapter documented as substitute backend; Linear/GitHub remain future phases | met |
| Stable identity | Work item must not be inferred from title alone | `LWI-YYYYMMDD-NNN` ID and `local:<id>` locator are persisted | met |
| Lifecycle truth | Local workflow must support state transitions | Transition command updates active item and appends workflow events | met |
| Rehydration | Fresh session must render active workflow packet | `render-local-work-item.sh` prints active work item from persisted YAML | met |
| Validation | Emitted workspace must prove workflow files and schema | `validate-v2.sh` enforces workflow shape and pointers | met |
| Sequential extensibility | Phase 2 should attach review/closure without rewrite | Workflow events and active item are separate from readiness/proof gates, enabling later attachment | met |

No open in-scope defects remain for Phase 1.

## Phase 2 Review Log

### W6 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Continue progressively toward full goal | Phase 2 attaches local workflow identity to review/closure surfaces instead of stopping at local work-item creation | met |
| Review packet identity | `render-review-ready-packet.sh` now includes work item ID, locator, and lifecycle state | met |
| Closure packet identity | `render-closure-packet.sh` now includes work item ID, locator, and lifecycle state | met |
| Handoff identity | `render-handoff-summary.sh` now includes a `Workflow Identity` section | met |
| Prepare review lifecycle | `prepare-review.sh` transitions active local work item to `review` before persisting artifacts | met |
| Prepare closure lifecycle | `prepare-closure.sh` transitions active local work item to `closure` before persisting artifacts | met |
| Test coverage | `tests/local-workflow-adapter.sh` verifies review/closure packets, bundles, handoff summary, and lifecycle transitions | met |

Defect found: the Phase 2 test target initially lacked completed onboarding and
current-plan sufficiency, so `prepare-review.sh` correctly blocked on readiness.

Correction: added a test helper that stabilizes onboarding and current-plan truth
before seeding proof evidence.

Reproof:

| Validation | Result |
| --- | --- |
| `bash tests/local-workflow-adapter.sh` | passed |
| `bash tests/doctrine-integrity.sh` | passed |
| `bash tests/local-workspace-proof-gates.sh` | passed |
| `bash tests/profile-integrity.sh` | passed |
| `git diff --check` | passed |
| `for test_file in tests/*.sh; do bash "$test_file"; done` | passed |

## Phase 2 Forensic Reconciliation

| Comparison | Expected | Actual | Judgment |
| --- | --- | --- | --- |
| Workflow identity in review | Review handoff should not be packet-only without work-item identity | Review-ready packet and pre-review bundle include local work item ID/locator/state | met |
| Workflow identity in closure | Closure should rehydrate active workflow context | Closure packet and closure bundle include local work item ID/locator/state | met |
| Handoff summary | Fresh session should see workflow identity immediately | Handoff summary has `Workflow Identity` section | met |
| Lifecycle attachment | Prepare flows should move active local work item with the workflow phase | Prepare review -> `review`; prepare closure -> `closure` | met |
| Sequential extensibility | Future Phase 3 topology should build on current identity | Active item remains separate YAML with parent/labels fields already present | met |

No open in-scope defects remain for Phase 2.

## Phase 3 Review Log

### W7 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Local parent/child topology | Active work item has `parent_id`, `child_ids`; topology events persist in `topology.jsonl` | met |
| Related work items | Active work item has `related_ids`; `link-local-work-item.sh --related` appends relation | met |
| One-shot ledger link | Active work item has `one_shot_task_ledger`; command accepts repo-local `.accelerate/` or `planning/` paths | met |
| Rehydration | `render-local-work-item.sh` prints parent, child, related, and one-shot ledger fields | met |
| Validation | `validate-v2.sh` requires topology file, state pointer, topology fields, and list-shaped child/related IDs | met |
| Tests | `tests/local-workflow-adapter.sh` covers topology links, invalid ID rejection, render output, and validation | met |

No correction required.

Reproof:

| Validation | Result |
| --- | --- |
| `bash tests/local-workflow-adapter.sh` | passed |
| `bash tests/doctrine-integrity.sh` | passed |
| `bash tests/local-workspace-proof-gates.sh` | passed |
| `bash tests/profile-integrity.sh` | passed |
| `git diff --check` | passed |
| `for test_file in tests/*.sh; do bash "$test_file"; done` | passed |

## Phase 3 Forensic Reconciliation

| Comparison | Expected | Actual | Judgment |
| --- | --- | --- | --- |
| Topology | Local workflow must support parent/child/related substitute topology | Active item fields plus append-only topology ledger | met |
| One-shot linkage | Local workflow should connect to task ledger execution truth | `one_shot_task_ledger` field and link command | met |
| Stable future adapter path | Topology should map to Linear/GitHub later | IDs and JSONL events are explicit and backend-neutral | met |
| Invalid relation safety | Bad IDs should fail closed | `bad-id` parent rejected by test | met |

No open in-scope defects remain for Phase 3.

## Phase 4 Review Log

### W8 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Stabilize shared contract | `adapter-contract.md` now defines required `capabilities.yaml` schema | met |
| Use local adapter as concrete reference | `adapters/workflow/local/capabilities.yaml` declares implemented local substitute capabilities | met |
| Prevent fake remote claims | Manifest rules distinguish implemented/planned/blocked and native/linked/substitute/none | met |
| Validate manifests | `tests/workflow-adapter-contract.sh` checks required keys, enums, implemented-adapter support, adapter directory match, and local external API boundary | met |
| Wire into doctrine tests | `tests/doctrine-integrity.sh` now requires and runs workflow adapter contract test | met |

Defect found: one validation attempt ran `doctrine-integrity.sh` and
`local-workflow-adapter.sh` in parallel. Since doctrine also invokes the local
workflow test, both processes raced over the same `.tmp/local-workflow-adapter`
fixture directory.

Correction: reran validation sequentially. No code correction was required for
the production path; the issue was test invocation concurrency, not adapter
behavior.

Reproof:

| Validation | Result |
| --- | --- |
| `bash tests/workflow-adapter-contract.sh` | passed |
| `bash tests/doctrine-integrity.sh && bash tests/local-workflow-adapter.sh && bash tests/local-workspace-proof-gates.sh && bash tests/profile-integrity.sh && bash tests/workflow-adapter-contract.sh && git diff --check` | passed |
| `for test_file in tests/*.sh; do bash "$test_file"; done` | passed |

## Phase 4 Forensic Reconciliation

| Comparison | Expected | Actual | Judgment |
| --- | --- | --- | --- |
| Shared adapter contract | Future adapters need a comparable capability shape | `capabilities.yaml` schema in `adapter-contract.md` | met |
| Local reference | Local adapter should be the first concrete manifest | `adapters/workflow/local/capabilities.yaml` | met |
| Anti-fake remote posture | Remote adapters must not be claimed without API-tested behavior | Manifest status/capability rules encode `planned`, `blocked`, `none`, and `substitute` explicitly | met |
| Linear/GitHub readiness | Next remote phases can start from a stabilized manifest contract | Contract now names capabilities needed before runtime truth claims | met |

No open in-scope defects remain for Phase 4.

## Phase 5 Review Log

### W9 Side-By-Side Review

| Requested | Implemented | Judgment |
| --- | --- | --- |
| Start Linear adapter without fake runtime claims | `adapters/workflow/linear/capabilities.yaml` uses `status: planned` | met |
| Define safe first slice | `operational-contract.md` starts with read-only issue fetch and metadata rehydration | met |
| Prevent write-before-read | Operational contract forbids create/update/comment/transition in Phase 5A | met |
| Keep local substitute trace | Linear manifest points substitute evidence to `.accelerate/workflow/` until remote behavior is tested | met |
| Validate contract | `tests/workflow-adapter-contract.sh` accepts planned remote capabilities and blocks Linear from claiming implemented status prematurely | met |

Defect observed: running `doctrine-integrity.sh` and `local-workflow-adapter.sh`
in parallel still races over `.tmp/local-workflow-adapter`, because doctrine also
invokes the local workflow adapter test.

Correction: validation proof for this package uses sequential test execution.
Future test hardening can give each nested invocation an isolated temp root.

Reproof:

| Validation | Result |
| --- | --- |
| `bash tests/workflow-adapter-contract.sh` | passed |
| `bash tests/workflow-adapter-contract.sh && bash tests/doctrine-integrity.sh && bash tests/local-workflow-adapter.sh && bash tests/local-workspace-proof-gates.sh && bash tests/profile-integrity.sh && git diff --check` | passed |
| `for test_file in tests/*.sh; do bash "$test_file"; done` | passed |

## Phase 5 Forensic Reconciliation

| Comparison | Expected | Actual | Judgment |
| --- | --- | --- | --- |
| Linear status | Must not claim live remote adapter before API tests | Manifest says `planned` | met |
| First implementation posture | Read/rehydration comes before writes | Operational contract Phase 5A is read-only | met |
| Remote truth boundary | Linear cannot use local substitute as remote truth | Manifest says `runtime_truth: remote`; substitute evidence is only fallback trace | met |
| Next executable slice | Should be clear and sequential | Next slice is Linear issue read + local rehydration artifact, no writes | met |

No open in-scope defects remain for Phase 5 planning/readiness.
