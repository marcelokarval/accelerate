# Accelerate Portable Agent Fabric + OpenSpec Composition

## Document status

- proposal version: `0.7.25`
- date: 2026-09-01
- Karval work-item authority: `CODEX-25` / Plane is the current Phase-0 acceptance work-item, selected fail-closed by deployment policy; `CODEX-24` is its historical predecessor/lineage and `CODEX-17` and `CODEX-18` are earlier lineage only
- proposal location and authority: `planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md` is the single current governing proposal; the former `docs/superpowers/specs/` copy is historical-path retired and MUST NOT be read as a second authority
- status: v0.7.25 candidate pending independent Phase-0 acceptance under `CODEX-25`; `CODEX-24`, `CODEX-18`, and earlier items are historical lineage/scope only and do not apply to current candidate bytes or scope; installation, promotion, deployment, migration, WebUI exposure, runtime mutation, and new implementation remain separately blocked
- decision gate: every unresolved decision and every activation, migration, or acceptance contract requires its named disposition and receipt before its affected phase or effect
- governing repository: standalone `accelerate`

The supersession JSON is a historical receipt proving only the earlier successor; it does not bind current v0.7.25 bytes. The current candidate has no acceptance, digest, or predecessor-to-successor handoff receipt. Before Phase-0 acceptance, the future review-set/acceptance evidence MUST bind a closed digest-bound handoff record that identifies `CODEX-24` as predecessor, `CODEX-25` as successor acceptance authority, the current candidate/document digest, predecessor locator and digest or an explicit unavailable-state disposition, scope-lineage rationale, and issuing/verifying identities. This requirement does not claim that such a record already exists. The candidate MUST be hashed and bound by future Phase-0 acceptance. It grants no implementation or activation authority.

### v0.6 delta

This revision makes the prior approved intent machine-governable: a portable canonical
work-item binding replaces a universal Plane dependency; authority is
field-revisioned; candidates and evidence are content-addressed; the Gauntlet
has durable-state ADR requirements, DAG topology, per-node state machines,
physical lifecycle receipts, mission-wide budget control, independent review,
and hardened LAN-WebUI requirements. It remains a design proposal; no runtime,
profile, adapter, schema, WebUI, or provider effect is implemented or
authorized by this document.

This revision also defines the Semantic Implication Gate: prompt brevity never
proves bounded risk. It records the domain/capability, surfaces, seams,
authority and proof implications that a truthful completion entails. It adds
D12--D14 for catalog authority/projection, project-local `.accelerate`
overlays, and namespace/collision/retirement respectively. That v0.6 language
is historical lineage only; it does not authorize v0.7+ source implementation,
activation, installation, promotion, migration, retirement, or runtime effect.

The selected v3 local-workspace layouts and the D01/D08/D11 durable-store,
OpenSpec-delivery, and artifact-location filesystem layouts are target/test-root
contracts only. They remain inactive until their mapped phase implementation
and activation receipts exist. D01, D08, and D11 remain open decisions in this
proposal; naming a target path does not resolve, install, promote, or activate
it.

### v0.7 delta

This successor adds an operator-directed, cross-harness skill-curation
architecture. It turns a measured, heterogeneous corpus into a governed input
to D12--D14 without treating filesystem presence as loading, loading as
callability, or a donor package as a root/runtime dependency. It adds a
catalog ontology, capability rings, harness truth, a bounded semantic-review
queue, curation gates CG0--CG8, and explicit tester/reviewer separation. This is
still source architecture only: it authorizes neither catalog installation nor
runtime discovery, profile loading, adapter activation, dispatch, promotion,
migration, retirement, or external lifecycle change.

### v0.7.1 correction delta

This correction successor historically bound the v0.7 curation proposal to
`CODEX-24`,
corrects its audit and loader semantics, separates curation receipt families
from Domain-Gauntlet receipts, and makes role/state transitions explicit. It
is pending independent acceptance. It grants no new source implementation,
activation, installation, promotion, migration, retirement, dispatch, or
runtime authority.

### v0.7.2 correction delta

This correction makes historical authority non-transferable to the v0.7+
successor, defines CG8 as planning readiness rather than activation authority,
and closes the `TASKS_READY`, state-axis, and receipt-family contracts.
`CODEX-24` was the predecessor review authority only; current Phase-0 acceptance
is governed by `CODEX-25`. Future implementation requires independent
acceptance plus a valid canonical `phase_implementation_authorization_receipt`; neither is
invented by this proposal.

### v0.7.3 correction delta

This correction makes implementation authorization an explicit phase-entry
predicate, closes the versioned dispatch-readiness receipt and skill-loading
proof, and makes Domain-Gauntlet G4--G7 identifiers fully qualified. It remains
pending independent acceptance and grants no implementation or activation.

### v0.7.4 correction delta

This correction separates initial builder-dispatch readiness from post-builder
reviewer readiness, preventing future-reviewer objects from blocking initial
dispatch. It also closes the closure receipt family and removes duplicate
Phase-0 digest naming. It remains pending independent acceptance.

### v0.7.5 correction delta

This correction makes `TASKS_READY` strictly pre-spawn and introduces
post-spawn builder readiness, preserving causal proof before G3 activation. It
remains pending independent acceptance and grants no implementation or effect.

### v0.7.6 correction delta

This correction completes reviewer readiness identity/lease proof and reconciles
the Phase-0 machine-readable fixture matrix with the split readiness lifecycle.
It remains pending independent acceptance.

### v0.7.8 correction delta

This successor adds finite schema inventory and missing readiness/set-negative
fixtures. It is unaccepted: the current bytes require future Phase-0 hashing
and acceptance before any separately authorized implementation.

### v0.7.9 correction delta

This correction makes the A04/A05 fixture denominator explicit and narrows the
normative schema inventory to its twelve listed execution-control rows.

### v0.7.13 correction delta

v0.7.9 historically narrowed the inventory to 12; v0.7.11 through v0.7.13
expand the current normative denominator to 19 to close assignment, identity,
runtime, and independence gaps. The current 21-row authority controls; history
does not override it. No acceptance digest exists for current bytes.

### v0.7.23 correction delta

This correction makes Phase-1 and Phase-3 table entry bindings explicit: D12,
D14, and D13 remain current disposition/contract inputs bound inside the one
canonical phase implementation authorization receipt. It removes the residual
parallel-authorization wording from the corresponding resolved-decision
boundaries. The candidate remains unaccepted and authorizes no implementation
or runtime effect.

### v0.7.24 correction delta

This correction moves the current Phase-0 acceptance work-item to `CODEX-25`
and preserves `CODEX-24` as historical predecessor/lineage only. It requires a
future digest-bound predecessor-to-successor handoff without claiming that a
handoff receipt exists. It replaces trust-root uniqueness with executable
actor, epoch, runtime, and context-lineage independence: trust roots remain
recorded, but a shared runtime trust root alone neither proves nor defeats
independence. The candidate remains unaccepted and grants no implementation or
runtime effect.

### v0.7.25 correction delta

This correction resolves the Phase-0 marked-block digest ambiguity: canonical
normalization now explicitly excludes a terminal LF after the end-marker line.
It preserves the `CODEX-25` acceptance, predecessor-to-successor handoff, and
independent-review contracts. The candidate remains unaccepted and grants no
implementation or runtime effect.

### Normative convention

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHOULD**, **SHOULD NOT**,
and **MAY** in normative contracts are to be interpreted as described by RFC
2119 and RFC 8174 when, and only when, written in uppercase. Lowercase wording
is explanatory and nonnormative. A gate is satisfied only by its named
predicate and digest-bound receipt; terms such as “ready”, “valid”, “fresh”,
and “independent” have no gate effect unless their predicate is stated here or
in a referenced schema.

## Executive summary

This proposal evolves `accelerate` into a portable, runtime-agnostic control
plane for governed engineering work. It preserves Codex as the strongest and
first implementation target while defining contracts that can be adapted to
other LLM, AI, and harness runtimes without pretending that their execution,
isolation, model, or tool semantics are equivalent.

The proposed system combines five distinct layers:

1. **Accelerate** is the control plane and final authority for classification,
   hardening, task topology, delegation, gates, evidence, and closure.
2. **Canonical work-item binding** is the portable lifecycle boundary; Karval
   deployment policy selects Plane as its sole work-item and lifecycle authority.
3. **OpenSpec Core** is an optional specification-artifact engine.
4. **Accelerate Portable Agent Fabric (APAF)** materializes governed agent
   profiles, assignments, runtime instances, and return packets.
5. **OpenSpec WebUI** is a non-authoritative upstream interface, exposed only
   through enforced controls on the authorized private LAN with `--host 0.0.0.0`.

OpenSpec Plus is not adopted as a runtime dependency. Its best process ideas
are absorbed as Accelerate doctrine, normalized to the local authority model,
and enforced through concise skills, schemas, adapters, validators, and proof
packets.

The **Domain Gauntlet** is the governed state machine inside
Accelerate/Apply. It is not an agent, a prompt, or a standalone product loop:
prompts declare constraints; skills activate and route them; Accelerate Core
holds state, gates, budgets, candidates, and evidence; domain profiles supply
the applicable oracles; runtime adapters execute physical spawns and receipts;
OpenSpec governs planning artifacts; the deployment-selected canonical binding
governs lifecycle (Plane for Karval); and root
performs fan-in, review-of-review, and closure. Subagents are actors within
this protocol, never the protocol itself.

The central architectural rule is:

> A skill is a reusable capability contract. An agent profile is a persistent
> identity and authority contract. An assignment is bounded work. A runtime
> instance is the live worker. Evidence is what permits a gate to advance.

None of these objects substitutes for another.

## Problem statement

The existing `accelerate` corpus already contains mature orchestration,
classification, proof, risk, review, and closure doctrine. Its current shape,
however, still mixes several concerns:

- root control-plane policy;
- long operational procedures;
- stack-specific knowledge;
- agent-role descriptions;
- runtime-specific dispatch details;
- project overlays;
- specification and task artifacts.

The earlier discussion with Agy exposed a useful opportunity and a dangerous
ambiguity. A persistent subagent is not simply a skill. Treating it that way
collapses identity, permissions, runtime isolation, assignment scope, and
evidence into a Markdown package that has no intrinsic execution authority.

The target architecture must therefore make persistence and runtime execution
explicit, machine-readable, testable, and adapter-owned.

## Goals

This proposal must:

- keep Codex/root as the primary technical control plane;
- remain semantically portable across capable LLM and harness runtimes;
- preserve strong rules in both the root and specialist agent bodies;
- distinguish skills, profiles, assignments, instances, and evidence;
- support sequential and parallel multi-agent execution without hidden
  authority changes;
- require independent review and bounded correction loops;
- make local, seam, integration-flow, and global closure gates explicit;
- prevent a locally successful child from closing a parent or whole delivery;
- make specification state machine-readable and resumable;
- reconcile OpenSpec artifacts with Plane without creating dual authority;
- expose a useful LAN WebUI without pretending that upstream provides an
  authentication boundary;
- preserve source, installed package, active runtime, configuration, and
  authorized promotion as different evidence classes.

## Non-goals

This proposal does not authorize:

- installing or promoting OpenSpec, OpenSpec Plus, or OpenSpec WebUI;
- starting a WebUI process or opening a firewall;
- changing the global `~/.codex/skills/` mirror;
- implementing new agents, adapters, schemas, or services;
- replacing Plane as tracker authority;
- making OpenSpec validation equivalent to delivery acceptance;
- importing donor prompts, hooks, wildcard grants, wrappers, or runtime
  authority verbatim;
- assuming that another harness provides Codex-equivalent isolation,
  background execution, model selection, worktrees, or messaging.

## Architectural principles

### One authority per concern

| Concern | Authority |
| --- | --- |
| Run classification and route | Accelerate root |
| Objective, scope, risk, and non-goals | Hardened execution packet |
| Work item and lifecycle state | `canonical_work_item_binding`; Karval deployment policy selects Plane |
| Specification artifacts and deltas | OpenSpec adapter |
| Agent identity and permissions | APAF agent registry |
| Runtime dispatch semantics | Selected runtime adapter |
| Acceptance and closure | Accelerate proof stack + operator closure receipt; root recommends only |
| LAN access boundary | Operator-owned deployment policy |

No adapter is allowed to claim authority outside its row.

### Field authority, projection, and conflict resolution

Each canonical field is an append-only record with `field_revision`, payload
digest, writer identity, and predecessor revision. A projection carries its
source locator, revision, and digest and is never a writable peer. The only
legal mutation path is the canonical owner’s CAS write using the current
revision and, for active work, the current fencing token. A stale write is
rejected. Equal-precedence prose has no merge rule: root MUST create a conflict
receipt and return it to the operator; root cannot self-accept it.

| Field | Canonical owner / writer | Readers / projections | Legal mutation and conflict / escalation |
| --- | --- | --- | --- |
| user intent | operator / operator | root, binding, spec | operator acceptance receipt; conflicting intent returns to operator |
| scope and non-goals | hardened packet / root after operator acceptance | spec, task graph, assignments | CAS hardening from intent; conflict returns to operator |
| spec | spec authority / designated spec validator | root, graph, reviewers | validated revision bound to scope digest; equal-precedence conflict returns to operator |
| task graph | root / root | scheduler, assignments, binding projection | CAS from accepted spec; dependency/scope conflict returns to operator |
| execution input manifest | root / root freeze operation | builder, scheduler, evidence store | immutable pre-dispatch JCS manifest; accepted-input change creates an execution-input successor and replacement assignments |
| review candidate manifest | root / root freeze operation | reviewers, evidence store, closure | immutable post-build JCS manifest containing its execution-input digest and provisional output snapshot; output correction creates a review-candidate successor |
| root review candidate manifest | root / root fan-in freeze operation | whole-change reviewers, evidence store, closure | immutable root-level JCS manifest that enumerates the current child denominator and exact G4/G5/G6 receipts; it is the sole whole-change review candidate |
| go/no-go receipt | Phase-5 gauntlet validator / verifier | root, parent loops, fan-in validator | closed, signed, fresh receipt; only the named gate transition may consume it |
| assignment | scheduler / root-issued compiler | adapter, worker, reviewer | execution-input or review-candidate-bound immutable issue; correction creates successor |
| execution state | gauntlet store / scheduler or adapter | binding and OpenSpec projections | fenced CAS transition only; ambiguity becomes `UNKNOWN` |
| evidence | evidence store / producing actor then verifier | root, reviewers, lifecycle projection | candidate-bound append and verifier acceptance; disagreement opens finding |
| external-effect authorization | operator / operator | root, adapter, audit projection | separately signed, scoped receipt; any mismatch blocks and escalates |
| waiver | operator / operator | root, validators, binding projection | named predicate, expiry and scope; conflict or expiry blocks |
| lifecycle | canonical work-item binding / selected adapter | root, OpenSpec projection | adapter CAS/readback; Plane fields are REQUIRED only when Karval `policy_mode=required` |
| operator closure receipt | operator / authorized closure signer after root recommendation | root close transition, binding, archive projection | closed, signed receipt; only after G7, required proof and lifecycle readback; conflict returns to operator |

Bootstrap is exactly: operator accepts intent; root hardens it; the workflow
binding is read back when policy requires it; spec authority validates; root
freezes the `execution_input_manifest`; scheduler issues the builder assignment;
builder ACKs and returns a provisional output snapshot; root freezes the
`review_candidate_manifest`; candidate-bound proof runs or reruns; only then is
a reviewer assigned, leased, and ACKed. Builder pre-freeze test output is
diagnostic/provisional only and MUST NOT satisfy a gate. Root only sequences
these receipts and cannot accept a
conflict it raised. Every conflict receipt identifies the field, competing
revisions, digest, owner, and operator disposition.

### Explicit state beats prose inference

Every material transition has a packet, schema, validator, and readback. A
sentence saying "done" never constitutes proof of completion.

### Strong defaults, bounded escape hatches

The default route is opinionated. Degraded execution is allowed only through a
named, visible exception with an owner and consequence. Silent fallback is a
workflow defect.

### Portability without false parity

The semantic contracts are portable. Physical capabilities are adapter facts.
An adapter may be `supported`, `staged-only`, `export-only`, `blocked`, or
`unavailable`. It must never simulate a successful physical dispatch.

## Correct ontology

The gauntlet uses these terms consistently. A **domain** (or bounded context)
owns a coherent model and invariants; a **capability/use case** is an outcome
within that domain; an **adapter** realizes a contract against a runtime or
provider; a **technical surface** is an implementation or contract-facing
area; and a **seam** is the explicit boundary where independently owned
surfaces exchange a contract. These are not interchangeable task labels.

For example, `Financial` is the domain. `Refund` is a capability/use case.
The payment-gateway adapter is an adapter, not the domain. Backend, API, and
frontend are technical surfaces; the refund API schema, authorization,
idempotency, and error contract form seams between them. The gateway's
provider contract is another seam. A correct refund implementation therefore
needs its Financial invariants and its seams proved; a green frontend alone is
not evidence that the capability or delivery is closed.

### Semantic Implication Gate and domain expansion

The gate has two ordered stages. **Stage A: Semantic Pre-scan** runs against
the raw request before selecting micro- versus full-hardening. It is a
non-authorizing, lightweight detector for candidate domain/capability,
authority/effect boundary, seams, and risk signals. Its only routing outcomes
are a safe hardening level or `OPERATOR_ESCALATION`; it does not freeze scope,
classify the run, or produce a final domain claim.

**Stage B: Semantic Implication Receipt** runs after the hardened execution
packet and before run classification, task-graph construction, or assignment
compilation. It MUST produce the bounded implication record: requested
objective, inferred domain/capability, owned and implicated technical surfaces,
seams and their contract digests where known, authority/effect boundary, risk
class, and minimum proof lanes. A short prompt is not evidence that this
record is small.

The gate may expand only analysis, routing, safeguards, proof, and the task
denominator required to establish the requested outcome. It MUST NOT silently
expand product scope, mutate an implicated surface without assignment, or turn
an inference into authority. If multiple domains, a material seam, an external
effect, or the canonical authority are ambiguous, the gate returns
`OPERATOR_ESCALATION` before dispatch.

Examples: “correct an isolated README typo” can remain a local documentation
loop; “add a refund button” implies the Financial/Refund capability plus UI,
API, authorization, idempotency, and provider seams; “repair SSO redirect”
implies an authentication boundary and negative-path proof. The latter two may
be short prompts, but require full hardening and their implicated gate lanes.

### Domain Gauntlet state and loops

The gauntlet composes four nested layers, each with an explicit parent:

```text
global closure loop (root / whole delivery)
  └─ integration-flow loop (end-to-end capability flow)
       └─ seam loop (one frozen contract boundary)
            └─ local capability loop (one owned implementation surface)
```

A local `GO_TO_PARENT` permits only its direct parent to continue. It never
closes a seam, integration flow, canonical bound work item, or global delivery. The root may
close only after all applicable descendants, fan-in, review-of-review, and
global proof are eligible.

Every loop has a `loop_id`, a candidate lineage, a frozen scope and contract
digest, selected oracles, budget, parent link, and a structured verdict:
`GO_TO_PARENT`, `CORRECTION_REQUIRED`, `ESCALATED`, `BLOCKED`,
`BUDGET_EXHAUSTED`, or `CANCELLED`. A verdict is a receipt, not a conversational
claim.

`correction_key = loop_id + root_run_id` is the correction-cap bucket, not an
attempt identity. Each correction has an immutable, domain-separated
`correction_attempt_id = SHA-256("accelerate-correction-attempt-v1\\n" +
correction_key + predecessor-lineage-digest + origin-kind +
origin-evidence-or-revision-digest + requested-round)`. The serializable
correction transaction atomically validates/assigns the next round, records the
attempt, and increments the bucket counter. Same-attempt replay returns its
original receipt with no effect; distinct attempts may consume rounds 1--3,
and round 4 rejects. A successor inherits the full
mission and ancestor counters (`tokens`, `elapsed_ms`, `cost_minor_units`,
`spawns`, `corrections`, `successors`, `reproofs`, and `external_effects`) and
the remaining cap; no child, node, candidate, or retry may initialize or reset
one of those counters.

### Skill

A skill is a progressively disclosed capability package:

- concise `SKILL.md` activation and routing contract;
- one-hop `references/` for long procedures and policy;
- `scripts/` for deterministic executable helpers;
- `assets/` for templates, schemas, fixtures, and static resources.

A skill can be loaded by root or by an agent. It does not become a process and
does not intrinsically grant permissions.

### Cross-harness skill curation and catalog ontology (D12 evolution)

#### Audit denominator and review boundary

The curation baseline is a structural inventory observation, not a quality
score or an installation request. It observed **2,564 `SKILL.md` locators** and
**1,465 unique content hashes**. It found **997 duplicate groups / 2,096
files**, **114 divergent-name groups / 423 files**, **127** packages over 500
lines, **491** over 10 KB, **one invalid frontmatter**, **38 nested** packages,
and **291** valid non-vendor names absent from the canonical 103. The stated
classification is of the **1,465 unique-content hashes**, not the 2,564 files:
899 vendor; 109 invalid/unknown; 97 test/QA; 89 runtime adapter; 84
lifecycle/control; 79 review/security; 32 docs/media/productivity; 30
planning/spec; 24 provider workflow; and 22 implementation stack.

These are structural audit observations pending a digest-bound CG0 manifest
and classifier receipt; this proposal invents neither digest nor timestamp.
The reconciliation invariant is: every one of the 2,564 locators MUST map to
exactly one observed content hash or an explicit unreadable/invalid record;
each of the 1,465 hash classifications MUST expand to all mapped locators; and
the resulting locator count, duplicate-group membership, and hash-class count
MUST reconcile before CG0 can pass.

This establishes **full structural coverage**: every member is counted,
hashed, named, located, and classified sufficiently for routing. It does not
claim deep semantic review of 2,564 packages. Deep review MUST be limited to a
prioritized candidate queue: canonical gaps, conflicting/dominant duplicates,
security/lifecycle/runtime packages, packages selected by a profile, and every
candidate proposed for promotion. An unreviewed structural member is neither
approved nor rejected; it is `inventory-only`.

#### Harness truth: presence is not a loader

The following table is the portable fact model for this audit. `Presence` means
only that an inspected source, export, installed directory, or static
projection existed at audit time. `Loader` is the exact known mechanism, not an
inference from that presence. `No configured loader` and `not audited here`
both mean no activation or callability claim.

| Audit-family ID / harness family | Presence / projection fact | Loader fact | Curation consequence |
| --- | --- | --- | --- |
| HF01 / Codex | root `SKILL.md`, repository catalog, and a runtime Codex catalog are present | `AGENTS.md` is bootstrap-instruction policy, not a proven runtime skill loader; loader state is unproven without an exact runtime-loader receipt | source catalog is canonical; runtime listing is a projection only |
| HF02 / Gemini-Agy-Antigravity family | candidate harness material may be inventoried | no repository-owned loader was accepted in this proposal | `inventory-only`; no profile or dispatch eligibility |
| HF03 / Hermes | repository adapter/projection material is present | cross-runtime manifest says `runtime-truth-required`; consumer registry currently says no semantic-core loader | staged/reference facts do not load a skill or prove a Hermes turn |
| HF04 / Claude | export/projection material is present | no semantic-core loader is installed | export-only; background-agent observation is not governed activation |
| HF05 / OpenCode | generated/reference adapter material is present | no loader; task primitive remains static-contract evidence | legacy reference only, never inferred runtime parity |
| HF06 / DSH | donor/bootstrap planning material may be present | no accepted repository loader/readback in this proposal | candidate-only until a D12 projection and adapter receipt |
| HF07 / OpenHands | export/projection material is present | `binding_unavailable` / no semantic-core loader | export-only, no apply eligibility |
| HF08 / Paperclip | Karval overlay/work-item integrations may be present | no skill-catalog loader is granted by Plane/Paperclip presence | overlay only; it cannot become portable core |
| HF09 / OpenClaw | legacy-reference projection is present | no loader; observed `sessions-spawn` is unavailable | reference-only and not dispatchable |
| HF10 / Pi-Remote-Pi family | candidate source may be inventoried | not audited as a repository loader | no activation, profile, or callability claim |

Every future row MUST record `presence_locator`, `presence_kind`,
`loader_kind`, `loader_locator`, `load_scope`, `freshness_receipt`, and
`callability_receipt` separately. A loader can establish only load scope; a
fresh adapter probe is still required for callable capability, and an operator
authorization is still required for an effect.

HF01--HF10 are the frozen audit-family IDs; grouped names remain families, not
claims of individual-runtime equivalence. The D12 seven-harness registry is a
different subset and denominator from this ten-family audit. A future exact
manifest MUST enumerate the members, locators, identifiers, loader receipts,
and its relationship to both denominators before reconciliation or promotion.

#### Conflicting authorities and their resolution

The audit found incompatible denominators rather than a single ready catalog:
the standalone source reports 103; documentation seeds report 5; direct Codex
runtime discovery reports 126; catalog worktrees report 112/101; and the D12
catalog spans seven harnesses. Root `SKILL.md` versus global-runtime content is
therefore a drift risk, and the cross-runtime manifest versus the consumer
registry is a consumer-contract conflict rather than a harmless duplicate.

| Conflict | Normative resolution | Forbidden inference |
| --- | --- | --- |
| standalone 103 versus doc seeds 5 | the repository catalog owns canonical identifiers; seeds are historical/import inputs | adding seed count to canonical count |
| canonical 103 versus direct Codex 126 | runtime discovery is an observed projection and must reconcile entry by entry | treating installed/direct skills as source authority |
| catalog worktrees 112/101 | each is an import candidate with provenance and hash; neither wins by size | choosing a worktree as canonical without D12 disposition |
| D12 seven-harness catalog | it is a cross-harness inventory/projection matrix, not seven active catalogs | claiming all harnesses load or support the same skills |
| root `SKILL.md` versus global runtime | root source governs root behavior; mirror drift is a failed projection/readback | editing global runtime as source or accepting name-only parity |
| cross-runtime manifest versus consumer registry | both are consumers of the semantic core and MUST agree on status, loader, projection, and applicability before promotion | treating either static file as runtime proof |

Equal-precedence disagreement produces a D12 conflict receipt with both
locators, hashes, claimed scope, and owner disposition. It MUST NOT be
auto-merged by root, a loader, or a count heuristic.
External documentation seeds are import-only and never source authority; the
project-local repository `skills/` catalog remains authoritative.

#### Capability rings and portable boundaries

Each catalog entry has exactly one current ring and may be reclassified only by
an append-only, reviewed successor:

| Ring | Meaning and admission boundary |
| --- | --- |
| `minimal-resident-core` | small source-owned root contracts needed to classify, bind authority, route, and close; no vendor bootstrap dependency |
| `branch-required` | loaded only when a selected branch/accepted packet requires its capability |
| `profile-specialist` | selected by an approved role/profile and bounded assignment |
| `on-demand` | discoverable through the router after explicit need; not preloaded |
| `adapter-only` | runtime/deployment translation; cannot define portable policy or root authority |
| `reference-only` | donor, historical, or research material with no activation path |
| `quarantine` | malformed, ambiguous, unsafe, unproven, or collision-bearing input; unavailable to resolution |
| `retire-candidate` | retained reader/compatibility candidate pending D14 denominator and retirement proof |

Plane is a Karval deployment overlay selected by `canonical_work_item_binding`
policy. It is not a portable-core skill, a mandatory resident dependency, or a
cross-harness lifecycle fallback.

#### Catalog entities and required fields

The later machine-readable catalog MUST distinguish the following entity kinds:

| Kind | Required fields |
| --- | --- |
| `skill` | `id`, `namespace`, `version`, `content_digest`, `activation_contract`, `ring`, `source_locator`, `frontmatter_status`, `line_count`, `byte_count`, `semantic_status`, `artifact_state`, `artifact_receipt`, `retirement_state` |
| `source` | `source_id`, `kind`, `locator`, `harness`, `observed_at`, `provenance_digest`, `license_disposition`, `trust_state` |
| `duplicate_group` | `hash`, `member_ids`, `canonical_candidate`, `divergent_names`, `disposition`, `review_receipt` |
| `projection` | `projection_id`, `skill_id`, `target_harness`, `locator`, `catalog_revision`, `source_digest`, `projection_digest`, `presence_kind`, `loader_kind`, `artifact_state`, `loader_receipt`, `readback_receipt` |
| `loader` | `loader_id`, `harness`, `kind`, `locator`, `scope`, `precedence`, `freshness_receipt`, `loader_state`, `loader_receipt` |
| `session_resolution` | `session_id`, `skill_id`, `assignment_id`, `session_state`, `selection_receipt`, `prompt_load_receipt`, `blocked_reason` |
| `profile_binding` | `profile_id`, `skill_id`, `requirement`, `ring`, `assignment_predicate`, `effective_scope_digest` |
| `capability` | `capability_id`, `owner`, `generation`, `allowed_operations`, `denied_operations`, `freshness`, `capability_state`, `tool_resolution_receipt`, `callability_receipt`, `authentication_receipt`, `authorization_receipt`, `effect_receipt` |
| `review` | `review_id`, `subject_digest`, `review_kind`, `reviewer_identity`, `independence_receipt`, `findings_digest`, `verdict` |
| `retirement` | `entity_id`, `state`, `replacement_or_rationale`, `reader_denominator`, `expiry`, `owner`, `readback_receipt` |

Names are identifiers, not evidence of equivalence. Every relationship is
digest-bound; an imported path, a runtime list, and a profile reference remain
different entity kinds.

#### Donor-corpus disposition: Superpowers 14

The fourteen host `superpowers` packages are an evaluated donor corpus only.
They MUST NOT be made a mandatory root dependency, a runtime requirement, or a
portable loader assumption. This is a v0.7 proposed disposition pending current
Phase-0 acceptance under `CODEX-25`; `CODEX-24` is predecessor lineage only.
Acceptance and a manifest are required before any
implementation. It imports no prompts, hooks, wrappers, or authority.

| Donor package | Disposition |
| --- | --- |
| `brainstorming` | absorb into hardening/discovery doctrine |
| `dispatching-parallel-agents` | replace with Accelerate delegation policy and adapter facts |
| `executing-plans` | absorb as bounded execution doctrine |
| `finishing-a-development-branch` | absorb into closure doctrine |
| `receiving-code-review` | absorb as review-input discipline |
| `requesting-code-review` | absorb as independent-review request discipline |
| `subagent-driven-development` | replace with APAF assignments, V2 dispatch, and Gauntlet receipts |
| `systematic-debugging` | absorb as diagnostic doctrine |
| `test-driven-development` | absorb as branch-required test doctrine |
| `using-git-worktrees` | optional adapter/workspace practice |
| `using-superpowers` | retire as a root dependency; compatibility only through a runtime overlay if separately accepted |
| `verification-before-completion` | absorb as closure-proof doctrine |
| `writing-plans` | absorb as planning/spec doctrine |
| `writing-skills` | absorb as skill-authoring doctrine |

#### Non-collapsing roles and tester gap

The catalog MUST preserve separate assignment and independence identities for:
`implementer`, `test-engineer`, `adversarial-reviewer`, `qa-runtime-reviewer`,
`independent-reviewer`, and root `review-of-review`. An implementer can supply
implementation proof but cannot independently verify it; a test engineer owns
test design/fixtures; an adversarial reviewer searches for invalidating cases;
the QA/runtime reviewer evaluates runtime/browser proof; an independent
reviewer evaluates the candidate against its rubric; root reconciles conflicts
and performs review-of-review but cannot self-accept a conflict.

The audit identifies a tester-capability gap. Deep semantic candidates for the
`test-engineer` and related proof rings are `test-engineering`,
`test-driven-development`, `evidence-reconciliation`,
`specification-lifecycle`, `source-verification`, `solution-minimalism`,
`frontend-qa-accessibility`, and `api-contract-testing`. Candidate status does
not grant a profile binding; each needs provenance, semantic review, defined
activation contract, and D12 disposition.

#### Three orthogonal state axes

No catalog status may collapse these axes:

| Axis | Primary transitions / question |
| --- | --- |
| artifact | `defined -> registered -> projected -> loader-confirmed -> retired`: what governed artifact exists? |
| session | `eligible -> selected -> prompt-loaded`: what happened in this run? |
| capability | `tool-resolved -> callable -> authenticated -> authorized -> effect-verified`: what may this actor actually do now? |

For example, a canonical artifact may be unloaded in a session; a loaded skill
may have no callable tool; a callable capability may be unauthorized for a
write. Negative and auxiliary states (for example `inventory-only`,
`quarantine`, `blocked`, `expired`, `revoked`, `unknown`, and
`retire-candidate`) are not primary transitions and MUST carry their own
typed reason/receipt. Every primary transition needs a per-axis receipt.

The exact transition mapping is closed. Artifact `defined->registered` requires
a valid source locator/content digest and `artifact_registration_receipt`;
`registered->projected` requires a canonical catalog revision, target locator,
and `projection_receipt`; `projected->loader-confirmed` requires an exact
runtime loader, load scope, fresh readback, and `loader_confirmation_receipt`;
`loader-confirmed->retired` requires D14-compatible reader denominator,
replacement/rationale, and `retirement_receipt`. Session
`eligible->selected` requires resolved profile, assignment, and
`session_selection_receipt`; `selected->prompt-loaded` requires the selected
artifact/profile/assignment digests and `prompt_load_receipt`. Capability
`tool-resolved->callable->authenticated->authorized->effect-verified` requires,
in that order, `tool_resolution_receipt`, `callability_receipt`,
`authentication_receipt`, `authorization_receipt`, and `effect_receipt`, each
fresh for the stated actor, operation, scope, and candidate where applicable.

Any changed bound input creates a digest-bound successor and invalidates named
downstream receipts. A source/catalog/artifact change invalidates
`projection_receipt`, `loader_confirmation_receipt`, bound
`prompt_load_receipt`, `tasks_ready_receipt`, `builder_ready_receipt`,
`reviewer_ready_receipt`, and every bound
`tool_resolution_receipt`, `callability_receipt`, and physical-dispatch receipt.
A profile/assignment/session change invalidates `session_selection_receipt`,
`prompt_load_receipt`, `tasks_ready_receipt`, and the affected
`builder_ready_receipt`, `reviewer_ready_receipt`, and affected
`bootstrap_gate_receipt`. A capability, identity, scope, or policy change
invalidates `tool_resolution_receipt`, `callability_receipt`,
`authentication_receipt`, `authorization_receipt`, `effect_receipt`,
`tasks_ready_receipt`, `builder_ready_receipt`, `reviewer_ready_receipt`,
`bootstrap_gate_receipt`, and physical-dispatch receipt.
No state or receipt on one axis infers a state or satisfies a transition on
another.

#### Skill-curation gates CG0--CG8 and decision matrices

These **skill-curation CG0--CG8 gates** have `gate_family=skill-curation` and
are separate from the existing Domain-Gauntlet G0--G7 gates, which have
`gate_family=domain-gauntlet`. They govern only source-catalog analysis and
later source implementation; they do not authorize runtime effect.

| Curation gate | Required success predicate |
| --- | --- |
| CG0 inventory freeze | denominator, locators, hashes, classifier version, and digest-bound manifest receipt are recorded |
| CG1 structural validity | frontmatter, namespace, nesting, size, and duplicate findings are classified; invalid input is quarantined |
| CG2 provenance and license | source, license disposition, donor restrictions, and authority class are recorded |
| CG3 semantic triage | candidate purpose, trigger, ring, overlap, and owner are reviewed or explicitly deferred |
| CG4 authority reconciliation | canonical source, seed, worktree, runtime projection, root, manifest, and registry conflicts have a disposition |
| CG5 profile/role fit | required role, non-collapse/independence impact, and tester-gap treatment are recorded |
| CG6 projection design | target harness presence, loader, scope, freshness, rollback, and no-parity claim are specified |
| CG7 source-only implementation proof | schema/catalog/validator fixtures prove source behavior and negative cases with no runtime effect |
| CG8 promotion-readiness plan | a digest-bound plan defines the future install, readback, callability, rollback, and authorization requirement; it grants no activation authority |

| Decision | Exact condition | Allowed effect |
| --- | --- | --- |
| GO (source-only) | CG0--CG7 pass for the bounded catalog change and no unresolved equal-precedence conflict | commit/review source contracts only |
| CONDITIONED-GO | CG0--CG7 pass and the CG8 promotion-readiness plan receipt is complete, while a later promotion/activation authorization receipt is absent | retain source artifact as inactive; no activation or runtime effect |
| NO-GO | malformed input, unresolved authority conflict, missing provenance, no profile fit, failed negative fixture, or absent authorization when the requested effect is activation/promotion | quarantine/defer; no projection, profile binding, or runtime effect; absent activation authorization is expected for inactive source-only planning |
| NON-GOAL | broad semantic rewrite of all 2,564 packages, global mirror mutation, vendor parity assertion, automatic retirement, or Plane portability | do not schedule or infer it |

Receipt families are unified only by a registry, never by alias: every gate
receipt and gate validator names an exact `gate_family`, family-qualified
`gate_id`, owner, consumer, and digest field. Non-gate receipts name their
closed `receipt_family` instead. The only gate families here are
`skill-curation:CG*` and `domain-gauntlet:G*`. `bootstrap_gate_receipt` and
closure receipts are receipt types, never gate families; they MUST NOT alias,
consume, or satisfy a gate across families.

Formal success metrics are: 100% of the frozen denominator has a locator,
hash, and structural class; 100% of invalid frontmatter and unresolved
collisions are non-resolvable; 100% of canonical/projection entries carry a
digest and authority locator; 100% of promoted candidates have a semantic
review and ring/profile disposition; 100% of harness projections distinguish
presence, loader, callability, and authorization; 0 unauthorized runtime
loads, installs, promotions, migrations, retirements, or lifecycle writes; and
0 unresolved cross-manifest/consumer-registry conflicts represented as parity;
and 100% of curation receipts/validators declare `gate_family=skill-curation`.

#### Hermes donor improvements

Hermes operational lessons are adopted as portable curation controls, not as a
Hermes runtime dependency: candidate freshness must be checked against the
current catalog revision; late evidence is reconciled against the active
candidate rather than silently closing stale work; every child wave has a
closeout record over its frozen denominator; requested-versus-delivered scope
is recorded in the return packet; and every capability records its generation,
owner, and denominator. These controls make evidence late-binding explicit
without rewriting transcripts, inventing capability, or changing Hermes state.

### Skill Catalog Authority and Projection (D12)

The repository-owned skill catalog is the canonical definition of governed
skill identifiers, versions, activation contracts, integrity digests, and
retirement state. A runtime catalog, installed mirror, profile reference, or
agent-visible listing is a read-only projection with a source locator,
catalog revision, and digest; it is never a competing authoring surface.
Resolution binds an assignment to the canonical catalog revision and verifies
that the projected entry has the same identifier, digest, namespace, and
retirement status. A missing, stale, divergent, or unverified projection
blocks bootstrap ACK rather than being inferred from a similarly named local
package.

D12 remains an architecture record from historical lineage only. For v0.7+
bytes, existing readers remain in place; source implementation, runtime sync,
installation, promotion, and any active catalog projection require independent
acceptance and a valid canonical `phase_implementation_authorization_receipt`. This proposal
does not supply either receipt.

### Project-local `.accelerate` overlay (D13)

A project-local `.accelerate/` workspace is a scoped overlay, not a second
skill catalog or control plane. It may bind project facts, selected profiles,
approved local policy, workflow projections, and evidence pointers to an
identified repository catalog revision. It may narrow capability, tool, and
mutation scope; it MUST NOT widen a base profile, shadow a canonical skill,
alter a catalog entry, or promote itself into a runtime/global authority.

Overlay activation requires a locator, owner, scope, base catalog revision and
digest, precedence declaration, and readback receipt. A missing base, stale
digest, equal-precedence conflict, or widening request blocks activation and
returns to its designated authority. D13 is historical architecture lineage
only for this successor. `.accelerate/` continues under the current
local-workspace contract until independent acceptance plus separate
digest-/scope-bound implementation and overlay activation/readback receipts
exist; no capability widening, installation, or promotion is implied.

### Namespace, collision, and retirement (D14)

Every cataloged skill, profile, adapter, overlay, and generated projection has
one canonical, typed namespace identifier. Aliases are explicit compatibility
records with an owner, target, expiry/retirement state, and digest; name
similarity is not resolution. A collision, ambiguous alias, cross-kind reuse,
or projection that resolves to a retired identifier MUST reject before
assignment/bootstrap. Retirement is an append-only lifecycle operation: first
mark deprecated with a replacement or retained-reader rationale, then prove no
active canonical reader depends on it, and only then mark it retired. Historical
paths may remain readable but MUST NOT become a second authority.

D14 is historical architecture lineage only for this successor. No source
implementation, namespace migration, alias activation, removal, or reader
retirement is authorized until independent acceptance and separate
digest-/scope-bound implementation, migration/retirement receipts, and
denominator proof exist.

### Agent profile

The normative `agent_assignment` contract sets `can_approve=false` and
`can_close=false` for every agent identity, including root/orchestrator. Root
recommends and reconciles only; operator acceptance and `operator_closure_receipt`
alone authorize approval/closure. Existing source ontology/validator mismatch is
a Phase-3 blocker, not an implemented claim.
Any current validator/schema that permits root `can_approve=true` or `can_close=true` is non-conformant and cannot satisfy Phase-3 proof; a future, separately authorized Phase-3 change must correct and test it.

An agent profile is a persistent, runtime-neutral role declaration. It owns:

- identity and purpose;
- allowed and forbidden scopes;
- required and optional skills;
- tool capability classes;
- write and mutation authority;
- escalation conditions;
- expected input and output packet schemas;
- default quality/model class rather than a hard-coded vendor model;
- independence requirements;
- nesting and delegation permissions.

### Assignment

An assignment is an immutable per-task envelope containing:

- `canonical_work_item_binding` locator, id, revision, and digest; Plane
  locator/id/revision fields are REQUIRED only when Karval `policy_mode=required`;
- objective and non-goals;
- exact files, domains, or surfaces owned;
- frozen denominator where applicable;
- input artifacts and accepted source set;
- allowed mutations and forbidden operations;
- expected proof;
- timeout, retry, and correction budget;
- return packet schema;
- integration owner.

For gauntlet dispatch, the assignment additionally declares `assignment_id`,
`loop_id`, parent loop, domain, capability/use case, seam where applicable,
objective and non-goals, owned and forbidden surfaces, workspace, model,
reasoning effort, `fork_turns`, recursion grant, proof/oracle/reference
digests, reviewer pair and independence rule, budget, and return schema.

### Runtime instance

A runtime instance is a live execution created by an adapter. It receives the
resolved profile, assignment, model/quality mapping, workspace policy, and
tool policy. Its transcript, status, messaging, and isolation are runtime
facts, not portable assumptions.

### Evidence packet

Evidence is a typed receipt tied to an assignment, candidate, commit, artifact
digest, environment, and time. Evidence may prove implementation, static
validation, runtime behavior, review, browser truth, persistent regression, or
forensic closure. Evidence never inherits across a changed candidate unless
explicitly reconciled.

## Target layered architecture

```text
operator
  |
  v
Accelerate root control plane
  |-- hardened execution packet
  |-- Domain Gauntlet state, gates, budgets, candidates, and evidence
  |-- selected canonical-work-item binding adapter
  |-- specification lifecycle router
  |     `-- OpenSpec Core adapter
  |-- APAF agent factory
  |     |-- portable profile registry
  |     |-- assignment compiler
  |     `-- runtime adapters
  |-- proof and review lanes
  `-- forensic closure

OpenSpec WebUI -- read/observe --> OpenSpec workspace artifacts
canonical binding -- authority --> work items and lifecycle
Plane          -- Karval `policy_mode=required` adapter --> canonical binding
```

The proposed repository growth is:

```text
accelerate/
├── core/
│   ├── specification-lifecycle/
│   ├── agent-fabric/
│   ├── task-graph/
│   ├── domain-gauntlet/
│   ├── review-loops/
│   ├── evidence/
│   ├── stores/gauntlet-event-store/
│   └── validators/
├── adapters/
│   ├── specification/
│   │   └── openspec/
│   ├── workflow/
│   │   ├── binding-contract/
│   │   └── plane/                 # only Karval policy_mode=required
│   └── runtime/
│       ├── codex/
│       └── <future-runtime>/
├── agents/
│   ├── registry/
│   ├── constitutions/
│   ├── assignments/
│   └── return-packets/
├── schemas/
│   ├── accelerate-governed/
│   └── agent-fabric/
├── fixtures/
│   ├── execution-input-manifest-v1/
│   ├── review-candidate-manifest-v1/
│   ├── gauntlet-state-v1/
│   ├── runtime-lease-v1/
│   ├── review-receipt-v1/
│   ├── webui-boundary-v1/
│   └── migration-parity-v1/
├── profiles/                       # existing stack profile resolver layer
├── onboarding/                     # existing bootstrap, reentry, discovery layers
├── planning/                       # existing artifact router and architecture authority
├── overlays/                       # existing scoped policy overlays
├── docs/                           # mixed current/historical reader surface; proposal authority remains planning/architecture
├── references/                     # existing compatibility/provenance readers
└── skills/
    └── openspec-sdd-adapter/
```

This declares incremental additions to the existing repository tree, not a
replacement tree or authorization to create every directory in one migration.
The concrete schema, durable-store, validator, and fixture roots above are
mandatory target paths; existing profile, onboarding, planning, overlay, docs,
reference, and compatibility-reader layers remain in the denominator.

### Source-to-target migration and parity

The accepted `accelerate-sdd-v1` layers remain core, workflow adapters, runtime
adapters, profiles, agent factory, onboarding, planning, and overlays. Portable
binding is owned by `adapters/workflow`; Plane is one adapter selected by
deployment policy, not a universal layer.

| Source / current authority | Target owner | Compatibility reader | Migration phase | Parity proof | Deprecation / retention condition | Rollback |
| --- | --- | --- | --- | --- | --- | --- | --- |
| root `SKILL.md`, `README.md` | root routing and operational guide | generated runtime mirror | 7 | digest/index and invocation fixture | retain root files permanently; retire duplicated doctrine only after reader parity | restore prior committed root pair |
| `core/` | `core/` contracts and gauntlet store | legacy core imports | 1,5 | contract/schema fixtures | retain compatibility facade until consumers migrate | pin prior core release |
| `adapters/workflow/` | canonical binding interface and `plane/` adapter | current local workflow reader | 2 | binding readback and projection fixture | Plane-specific compatibility only while Karval policy requires it | select previous adapter revision |
| `adapters/runtime/` | runtime adapter contracts | current Codex runtime reader | 4,7 | ACK/capability/fencing fixtures | keep legacy adapter only while callable consumers exist | route to prior runtime adapter |
| `adapters/README.md` and `adapters/docs/**` | `adapters-shared-docs` | adapter-contract, migration, and compatibility readers | 7 | exact-path inventory, link/readback, retention and rollback fixture | retain each declared reader until its replacement link is verified | restore the exact prior `adapters/README.md` and `adapters/docs/**` paths |
| `profiles/` | stack profiles | profile resolver | 3 | resolved-profile digest and deny-wins fixture | retain aliases until profile migration receipt | restore alias mapping |
| `agents/` | registry, constitutions, assignments, return packets | legacy role loader | 3 | assignment/return schema fixtures | retain legacy descriptors until registry readback | revert registry pointer |
| `scripts/` | deterministic helper owner named by each script manifest | CLI and workflow callers | 7 | script index, invocation and digest/readback fixture | retain legacy entrypoints until every declared caller migrates | restore prior script manifest and executable |
| `tests/` and `tests/fixtures/` | test-engineering owner and fixture registry | test runner and validator readers | 7 | fixture inventory, expected-result digest, no-orphan fixture scan | retain fixtures for supported compatibility readers | restore prior test/fixture tree |
| `examples/` | documentation/example owner | tutorial and smoke-test readers | 7 | example index, runnable/readback digest | retain supported examples until replacement reader parity | restore prior examples pointer |
| `global-runtime/` generated/export | runtime export owner | installed/runtime mirror readers | 7 | generated-export source digest, consumer readback, parity fixture | retain previous export until active consumer readback | reselect prior generated export |
| `.accelerate/workflow` and `.accelerate/review/status` | local-workspace state owner | canonical local state plus read-only projections | 7 | canonical/projection revision+digest readback and stale-projection reject | retain only governed retention window; projections never become authority | restore last verified canonical state snapshot |
| `skills/` | skills owner under Agent Skills standard | skill resolver and generated runtime mirror | 7 | activation/index digest and invocation fixture | retain prior skill until resolver parity | restore prior skill pointer |
| `onboarding/` | onboarding contracts | current onboarding scripts | 7 | clean-bootstrap and reentry receipt | retain old entry docs until both paths pass | restore prior onboarding entry |
| `planning/` | planning artifact router | OpenSpec/local planning readers | 1,2 | artifact dependency/readback fixture | retain old planning format until converter parity | select previous planning reader |
| `docs/` | mixed: exact current-authority paths enumerated by `AGENTS.md` plus retained historical/reference paths | `AGENTS.md` current-stage, documentation-link, migration, and provenance readers | 7 | docs inventory digest, authority-classification/link/readback, no-orphan fixture | retain current authority until superseded and history/retirement markers until every declared reader resolves | restore prior docs tree |
| overlays and `references/` | profiles/overlays and `references/` | existing references readers | 7 | source map, digest, and no-orphan scan | preserve readable history until replacement links are verified | restore retained reference links |

`.github/**` is retained auxiliary CI/hosting configuration, not behavior
authority: its inventory row names owner, reader set, retention, rollback, and
no-canonical-reader proof. Temporary/cache data is regenerable, backups are
recovery material, and worktrees are runtime isolation; each excluded row needs
the A11 no-orphan evidence.

#### Frozen migration denominator inventory

Before Phase 7 mutation, the migration owner MUST freeze
`planning/architecture/migration-denominator-v1.json` as RFC 8785 canonical
JSON and record `migration_denominator_digest=sha256:<64 lowercase hex>`.
It is the exhaustive machine-readable denominator, not an illustrative table.
Each included row has `id`, `source_globs`, `target_paths`, `reader_set`,
`retention`, `rollback`, and `owner`; each excluded row has the same identity,
an `exclusion_rationale`, and proof that it has no canonical or retained
compatibility reader. The initial inventory MUST include:

| id | Concrete source globs | Explicit target paths | Reader set; retention; rollback |
| --- | --- | --- | --- |
| root | `SKILL.md`, `README.md`, `AGENTS.md` | same root paths and declared generated routing projections | root/bootstrap; permanent; prior committed root tree |
| root-config | `.gitignore` | `.gitignore` | repository/tooling reader; retained; prior root config |
| local-state | `.accelerate/**` | same paths or declared canonical successor | local workflow/review; governed window; verified canonical snapshot |
| local-policy | `.claude/**` | declared repo-local policy target | declared policy reader; while referenced; prior policy tree |
| ci-hosting-auxiliary | `.github/**` | retained auxiliary path | CI/hosting owner/readers; retained; prior CI/hosting tree |
| core | `core/**` | `core/**` | core/compatibility readers; facade while used; prior release |
| workflow | `adapters/workflow/**` | `adapters/workflow/**` | binding/local workflow; selected-adapter retention; prior adapter revision |
| runtime | `adapters/runtime/**` | `adapters/runtime/**` | runtime readers; callable-compatibility retention; prior adapter |
| adapters-shared-docs | `adapters/README.md`, `adapters/docs/**` | same exact paths | adapter-contract/migration/compatibility readers; declared-reader retention; exact prior paths |
| profiles-agents | `profiles/**`, `agents/**` | `profiles/**`, `agents/**` | profile/role loaders; alias/descriptor retention; prior mappings |
| scripts | `scripts/**` | `scripts/**` | CLI/workflow callers; declared-entrypoint retention; prior manifest/executable |
| tests-fixtures | `tests/**`, `fixtures/**` if present | `tests/**`, `fixtures/**` | runner/validator; supported-fixture retention; prior tree |
| examples | `examples/**` | `examples/**` | tutorial/smoke readers; supported-example retention; prior pointer |
| global-runtime | `global-runtime/**` | `global-runtime/**` generated/export target | installed/runtime mirrors; previous-export retention; prior export |
| skills | `skills/**` | `skills/**` | resolver/generated mirror; prior-skill retention; prior pointer |
| onboarding | `onboarding/**` | `onboarding/**` | bootstrap/reentry; until both paths pass; prior entry |
| planning | `planning/**` | `planning/**` | OpenSpec/local-planning; converter compatibility; prior reader |
| docs | `docs/**`, classified into the exact `AGENTS.md` current-stage paths (`docs/architecture/accelerate-pre-agents-baseline.md`, `docs/architecture/accelerate-control-plane.md`, `docs/architecture/accelerate-sdd-v1.md`, `docs/architecture/accelerate-classification-matrix.md`, `docs/architecture/accelerate-migration-plan.md`, `docs/architecture/accelerate-onboarding-model.md`) and retained historical/reference remainder | `docs/**`, preserving the same per-path class | docs/provenance/current-stage; current paths until superseded and historical paths retained; prior docs tree |
| overlays-references | `overlays/**`, `references/**` | `overlays/**`, `references/**` | profile/reference readers; readable-link retention; retained links |

These are the only tracked-path rows: every tracked path has exactly one row
and exactly one class. `docs/**` has the exact current-stage paths listed in
`AGENTS.md` classified as current authority and all remaining paths classified
retained historical/reference, never mixed or inferred by directory name.

Explicit excluded rows are `.git/**` (VCS metadata), `.codex/**` only when no
declared repository reader exists, `.backups/**`, `.playwright-mcp/**`,
`.pytest_cache/**`, `.tmp/**`, `.worktrees/**`, and declared regenerable cache
paths. Any root entry not present in this closed inventory, including an
unexpected `+`, is `UNCLASSIFIED_ROOT`; it blocks Phase 7 until an owner adds a
disposition row and its reader/retention/rollback proof. It is never silently
included, excluded, or blessed.

`.github/**` is retained auxiliary CI/hosting configuration under its declared
owner/reader/rollback row; `.tmp/**`,
`.pytest_cache/**`, `**/__pycache__/**`, and cache paths are regenerable;
`.backups/**` is recovery material; `.worktrees/**` is runtime isolation. Their
exclusion rows are mandatory. Negative fixtures reject an omitted authoritative
root, undeclared source glob, or orphan canonical/retained reader.

## OpenSpec Core: what to adopt

OpenSpec Core contributes a useful artifact engine because it separates a
change into inspectable, filesystem-backed objects and provides machine-readable
CLI contracts.

### OpenSpec Core adoption — change-scoped artifact graph

Use a change directory as the bounded specification workspace. The minimum
Accelerate schema should materialize:

1. `proposal` — objective, context, scope, non-goals, affected capabilities;
2. `specs` — behavioral requirements, scenarios, domains, capabilities,
   seams, and invariants;
3. `design` — architecture, decisions, alternatives, risks, migrations, and
   the domain-capability-flow graph;
4. `test-design` — hard floor, selected oracles, gates, negative fixtures, and
   lowest-effect validation plan;
5. `tasks` — vertical-slice DAG, loop IDs, dependencies, owners, and gates;
6. `delegation-plan` — builder/reviewer pair, spawn/ACK contract, runtime
   class, isolation statement, and return contract for every dispatchable slice.

The custom schema is named `accelerate-governed`. It extends OpenSpec instead
of reshaping Accelerate around the default schema. The Phase-2 specification
owner owns its schema and selector policy. Before that owner ships a closed
enum and validator, `selected_proportional_depth`, applicable loop selector,
gate selector, and risk class are `UNRESOLVED` and fail closed: no dispatch or
gate advance is legal. The canonical-binding policy is a closed enum
`binding_policy_mode={required,optional,none,unavailable}`; task bindings are
REQUIRED for `required` and `optional` when a binding is selected, forbidden
for `none`, and dispatch is forbidden for `unavailable`—never “only when one
exists”.

OpenSpec stores durable planning composition, not live gauntlet execution
state. Accelerate Core owns active state, candidate/evidence lineage, gates,
budgets, verdicts, and resume legality. The deployment-selected canonical
binding governs lifecycle (Plane only under Karval policy).

### OpenSpec Core adoption — dependency-aware artifact readiness

Artifact readiness is computed from declared dependencies. A downstream
artifact becomes editable only when its prerequisite artifacts are present and
structurally valid. This supports pause/resume and prevents task execution from
starting on an incomplete design.

OpenSpec's file-existence status is insufficient by itself, so Accelerate adds
semantic states:

```text
missing
  -> materialized
  -> structurally-valid
  -> independently-reviewed
  -> planning-approved
  -> execution-ready
```

`planning-approved` means that the artifact set is approved as an input to
planning and dispatch readiness. It is not product, delivery, or closure
acceptance. Only `execution-ready` may contribute tasks to `TASKS_READY`.
Projection and lifecycle are separate axes/records/receipts: a Plane or other
binding projection neither advances OpenSpec semantic readiness nor proves a
task executable.

### OpenSpec Core adoption — custom schemas and templates

The schema and its templates should be repo-owned. Templates must produce
bounded, reviewable artifacts and avoid giant embedded prompts. Long guidance
belongs in directly linked references and validators.

### OpenSpec Core adoption — JSON command contracts

Prefer machine-readable commands for status, instructions, validation, and
archive operations. The adapter captures:

- command and immutable tool version;
- workspace and change identifier;
- exit status;
- parsed JSON;
- artifact digests;
- adapter verdict;
- timestamp and environment class.

Human terminal text is supplementary evidence, never the integration API.

### OpenSpec Core adoption — delta specifications

Change-scoped spec deltas are valuable for explicit additions, modifications,
and removals. Accelerate should preserve the delta and the resulting canonical
spec so reviewers can compare intent, change, and final state.

### OpenSpec Core adoption — archive as a lifecycle operation

Archive moves a completed change into durable history. It must occur only
after:

- artifacts are structurally valid;
- implementation and proof are frozen;
- independent review passes;
- root review-of-review passes;
- selected canonical-binding reconciliation succeeds (Plane only when Karval
  `policy_mode=required`);
- operator acceptance receipt is present when policy marks it `required`.

Archive is not closure by itself and must not auto-close the canonical binding
or Plane.

### OpenSpec Core adaptation — validation

OpenSpec validation is structural specification evidence. It can prove that
required sections, syntax, and references are coherent. It cannot prove:

- code correctness;
- tests passing;
- runtime behavior;
- visual truth;
- security posture;
- acceptance;
- absence of regression.

The adapter must label this evidence `structural-spec-validation`, never
`delivery-proof`.

### OpenSpec Core adaptation — verify-change

Heuristic change verification can be used as an advisory reviewer. Any result
based on keyword matching or inference remains a non-authoritative signal. It
may open findings; it may not close a gate without corroborating evidence.

## OpenSpec Plus: what to absorb

OpenSpec Plus contributes valuable execution doctrine, especially in its
Apply workflow. These ideas should become native Accelerate process contracts,
not a direct installation of the upstream skill bundle.

### Five-lens discovery

Before planning, inspect the task through five lenses:

1. product intent and user value;
2. domain and behavioral contract;
3. architecture and integration boundaries;
4. testability and proof strategy;
5. delivery, operation, and rollback risk.

The output feeds the hardened execution packet and the OpenSpec proposal,
rather than becoming an unstructured research transcript.

### What before how

Specifications own observable behavior and acceptance. Design owns mechanism,
structure, trade-offs, and migration. Tasks own execution order and proof. A
single artifact should not silently mix these authorities.

### Testable scenarios

Every material requirement must have one or more scenarios with:

- precondition or initial state;
- action or event;
- expected observable result;
- proof class;
- owner;
- risk level.

Gherkin is allowed but not mandatory. The contract is testability, not a
specific prose syntax.

### Alternatives before a material design decision

For ADR-worthy choices, design presents two or three credible alternatives,
their trade-offs, and the selection rationale. Rejected alternatives remain in
the decision record so a later agent does not reopen the same question without
new evidence.

### Incremental approval gates

Large changes should allow explicit approval after proposal, design, test
design, and task graph. Approval is recorded as a digest-bound receipt. Editing
an approved upstream artifact invalidates dependent approvals.

### Vertical slices

Tasks should deliver thin, end-to-end behavior with local proof whenever
possible. Layer-only task decomposition is permitted only when a real
dependency or migration boundary requires it.

## Governed Apply protocol

The strongest contribution from OpenSpec Plus is its Apply logic. Accelerate
should adopt the intent with stricter authority and evidence boundaries.

### Apply preconditions

Apply is blocked unless all are true:

- canonical work-item binding is valid for the selected deployment: `required`
  bindings need fresh `callable` and `authorized` adapter readback; `optional`
  bindings may execute but cannot advance their backend lifecycle; `none` may
  execute/reconcile local evidence but cannot close an external lifecycle; and
  `unavailable` may only plan, never dispatch, reconcile, close, or cause an
  external effect;
- an OpenSpec artifact set is identified only in `full` Apply mode; `core` Apply
  uses the accepted native specification/artifact contract without OpenSpec;
- proposal, specs, design, test-design, tasks, and delegation-plan satisfy the
  selected proportional depth;
- unresolved decisions are empty or explicitly deferred outside scope;
- task denominator and dependency graph are frozen;
- runtime adapter capability is fresh and callable;
- worktree or workspace isolation policy is resolved;
- rollback and stop conditions are explicit;
- `TASKS_READY` is reached; and
- `ROUTE_SELECTED=orchestrated` is receipted.

Preflight also freezes the task denominator and all shared contracts before
parallel work. It derives the domain-capability-flow graph, seam ownership,
candidate-lineage rules, oracle taxonomy, reference snapshots, and applicable
local, seam, integration, and global loops. A provider effect with external
consequences is classified before dispatch; a real refund, for example, has
zero automatic replay budget.

### `TASKS_READY` predicate

`TASKS_READY` is initial builder-dispatch readiness only. It is true only when
a digest-bound `tasks_ready_receipt` binds the frozen initial-builder task-DAG
denominator; every initial builder node's owner, profile, immutable assignment,
scope, dependencies, acceptance requirements, and proof requirements; all
prerequisite planning artifacts at `execution-ready`; satisfied/current binding
policy readback; selected route; resolved capabilities; risk/quorum decision;
no unresolved decision; and current execution-input manifest/planning-artifact
digests. It never requires a future reviewer assignment, review candidate, or
candidate-bound proof. The receipt
names its validator, owner, consumer, expiry/freshness basis, and each bound
input digest.

`tasks_ready_receipt` is a closed, versioned `receipt_family=dispatch-readiness`
schema, not a gate receipt. It has exactly: `schema_version` (closed enum
`tasks-ready-v1`), `receipt_family`, `owner_actor_id`, `consumer_id`,
`root_run_id`, `task_dag_denominator_digest`, sorted `node_bindings` (each with
node/owner/profile/assignment/scope/dependency/acceptance/proof digests plus
`required_skill_ids`/digests and expected artifact/projection/loader
requirements),
`planning_artifact_digests`, `binding_readback_digest`, `route_id`, sorted
`capability_digests`, `risk_quorum_digest`, `execution_input_manifest_digest`,
`planning_manifest_digest`, `issued_at`, `expires_at`, `freshness_basis`, and
`validator_signature`. Unknown, missing, duplicate, unsorted, invalid-enum, or
digest-mismatched fields reject. Node bindings express only the required skill
plan and capability to attempt load; they MUST NOT bind a session
`prompt_load_receipt` or claim actual worker loading.
Required negative fixtures are `tasks-ready-bare-family-reject`,
`tasks-ready-duplicate-node-reject`, `tasks-ready-stale-binding-reject`,
`tasks-ready-missing-required-skill-plan-reject`,
`tasks-ready-unresolvable-loader-capability-reject`, and
`tasks-ready-bound-input-change-reject`.

Any bound input, DAG, scope, binding, capability, or risk change invalidates
the receipt and requires a successor. `TASKS_READY` admits physical
spawn/bootstrap only. It neither proves actual worker loading nor permits a
task-owned mutation; the route-specific adapter still requires its own fresh
capability, authorization, physical-dispatch, and readback predicates.

Planning availability is not worker bootstrap loading. `TASKS_READY` never
requires a session prompt-load receipt or future reviewer object.

`builder_ready_receipt` is a closed, versioned
`receipt_family=builder-readiness` schema emitted only after physical builder
spawn and bootstrap ACK. It contains exactly `schema_version=builder-ready-v1`,
`receipt_family`, worker/runtime-instance identity, builder assignment digest,
execution-input manifest digest, required artifact loader-confirmation/readback
digests, actual builder-assignment-/input-bound prompt-load receipt digests,
capability digest, fence, lease, freshness fields, and verifier signature.
Unknown, missing, or duplicate fields reject. It is invalidated by worker,
assignment, input, skill, loader, capability, lease, or fence change.
G3_BUILDER consumes this receipt and binds it with the pre-spawn
`tasks_ready_receipt`; if either proof is absent, activation is `NO-GO`.

`reviewer_ready_receipt` is a closed, versioned
`receipt_family=review-readiness` schema created only after builder return,
review-candidate freeze, candidate-bound proof, and reviewer assignment/lease/ACK.
It contains exactly `schema_version=reviewer-ready-v1`, `receipt_family`,
`review_candidate_digest`, immutable `reviewer_assignment_digest`,
`reviewer_actor_id`, `reviewer_actor_epoch`, `runtime_instance_id`,
`context_root_digest`, `profile_digest`, `scope_digest`, `lease_digest`,
`fence_token_digest`, `bootstrap_ack_digest`, bootstrap-ACK actor identity,
required-skill loader-confirmation/readback digests, candidate-/assignment-bound
prompt-load receipt digests, `proof_digest`, `independence_digest`,
`quorum_risk_digest`, capability digest set, `issued_at`, `expires_at`,
`freshness_basis`, and verifier signature. Unknown, missing, or duplicate
fields reject. G3_REVIEW consumes this receipt and binds every listed identity,
lease/fence, ACK, capability, skill, prompt-load, candidate, and proof digest
in the G3_REVIEW `bootstrap_gate_receipt`; it is invalidated by candidate,
proof, assignment, actor/epoch/runtime/context, lease/fence, skill-loader,
capability, or freshness change.

### Apply state machine

Closed enums are `root_state={DRAFT,FROZEN,APPLYING,FAN_IN,REVIEWING,CORRECTING,LIFECYCLE_RECONCILING,CLOSED,BLOCKED,CANCELLED}`, `node_state={PLANNED,RESERVED,BOOTSTRAPPED,ACTIVE,RETURNED,CANDIDATE_FROZEN,PROVING,PROVEN,UNKNOWN,FAILED,BLOCKED,REVIEWING,ACCEPTED,CORRECTION_REQUIRED,REPLACED,CANCELLED}`, `lease_state={RESERVED,ACQUIRED,RELEASED,EXPIRED,RECLAIMED}`, and `review_state={PLANNED,RESERVED,ACKED,ACTIVE,PASS,FAIL,RECUSED,EXPIRED}`. No unlisted state or transition is legal.

| Machine | Legal transitions | Preconditions / actor | Receipt, invalidation, retry |
| --- | --- | --- | --- |
| root | `DRAFT->FROZEN`; `FROZEN->APPLYING`; `APPLYING->FAN_IN`; `FAN_IN->REVIEWING`; `FAN_IN/REVIEWING/LIFECYCLE_RECONCILING->CORRECTING`; `CORRECTING->APPLYING`; `REVIEWING->LIFECYCLE_RECONCILING`; `LIFECYCLE_RECONCILING->CLOSED`; any nonterminal `->BLOCKED/CANCELLED` | `DRAFT->FROZEN` consumes G0; frozen DAG admission and `FROZEN->APPLYING` consume G1 and G2. `APPLYING->FAN_IN` and root-manifest acceptance require every frozen-DAG denominator node to be current, non-superseded, `ACCEPTED`, bound to its accepted candidate, and to carry its acceptance and quorum receipt digests. `FAN_IN->REVIEWING` requires frozen `root_review_candidate_manifest` and current candidate-bound global proof. `REVIEWING->LIFECYCLE_RECONCILING` requires the derived G7 global-closure-eligibility receipt after the whole-change PASS quorum. `LIFECYCLE_RECONCILING->CLOSED` additionally consumes a valid `operator_closure_receipt` and required binding readback | CAS; G7 is derived after root candidate freeze and is never an input to that manifest. Every recoverable child correction while root is `FAN_IN` atomically CASes root `FAN_IN->CORRECTING` in the same serializable transaction, whether or not a root manifest/evidence exists; only the dependent invalidation subset may be empty. After successor acceptance the root takes `CORRECTING->APPLYING->FAN_IN`, freezes a new manifest/current child set, and reruns global proof and whole-change review before a new G7. Terminal root state resumes only through a successor root run |
| node | `PLANNED->RESERVED->BOOTSTRAPPED->ACTIVE->RETURNED->CANDIDATE_FROZEN->PROVING->PROVEN->REVIEWING->ACCEPTED`; `PROVING->CORRECTION_REQUIRED->REPLACED`; `PROVING->FAILED/BLOCKED`; `ACTIVE->UNKNOWN`; `UNKNOWN->FAILED/BLOCKED/REPLACED` or `UNKNOWN->RESERVED->BOOTSTRAPPED->ACTIVE` only after reconciliation and a fresh lease/fence/ACK; `ACTIVE->FAILED/BLOCKED`; `REVIEWING->CORRECTION_REQUIRED->REPLACED`; any nonterminal `->CANCELLED` | builder `BOOTSTRAPPED->ACTIVE` consumes a valid G3_BUILDER receipt after bootstrap ACK and `builder_ready_receipt`; reviewer activation consumes a valid G3_REVIEW receipt. A proof failure is one transaction: it selects `CORRECTION_REQUIRED` only when recoverable, authority/hard-floor/budget predicates permit it, and its `correction_key` cap has capacity; it atomically validates/assigns the next distinct `correction_attempt_id`, records it, increments the bucket count, creates exactly one successor candidate, successor node, replacement assignment, lease, and fence, carries all counters, and invalidates predecessor proof/reviews. If cap, hard floor, authority, runtime, or budget fails, that same transaction selects `FAILED` (terminal proof) or `BLOCKED` (unavailable authority/runtime/budget), creates no successor, and leaves no reservation. Reviewer reservation/lease is legal only from `PROVEN`, then requires fresh review-candidate-bound ACK | `FAILED` and `BLOCKED` are terminal for this node and never enter review; `REPLACED` links the exact successor manifest/node with invalidation receipt |
| lease | `RESERVED->ACQUIRED->RELEASED`; `RESERVED/ACQUIRED->EXPIRED`; `EXPIRED->RECLAIMED`; `RECLAIMED->ACQUIRED/RELEASED` | scheduler with current CAS and lease TTL | expiry invalidates holder authority and moves active node to `UNKNOWN` |
| review | `PLANNED->RESERVED->ACKED->ACTIVE->PASS/FAIL/RECUSED/EXPIRED` | fresh independent review-candidate-bound reviewer / adapter after review-candidate freeze and candidate-bound proof | `ACTIVE->PASS` is a CAS transaction that may atomically permit `node.REVIEWING->ACCEPTED` only when every required, non-superseded candidate-bound review dimension and required quorum is verified `PASS`; otherwise node remains `REVIEWING`. A required `FAIL` invokes the same serializable correction-origin transaction as recoverable proof failure: one distinct `correction_attempt_id` in the `correction_key` bucket, predecessor proof/review invalidation, root-dependent invalidation when applicable, and exactly one successor candidate/node/assignment/lease/fence or no effect for a loser. `RECUSED` or `EXPIRED` never accepts and requires a replacement review. Whole-change PASS/quorum produces G7; only G7 gates `root.REVIEWING->LIFECYCLE_RECONCILING` |

Bootstrap authority chain is operator accepted intent -> valid G0 -> root
hardened packet -> selected binding readback when `policy_mode=required` ->
valid G1/G2 frozen-DAG admission -> builder admission reservation -> valid
G3_BUILDER -> builder activation -> builder execution/provisional-output
return -> root review-candidate freeze -> candidate-bound proof -> reviewer
assignment/lease/ACK -> valid G3_REVIEW reviewer activation. The pairing in planning is a
logical planned pair, not atomic dual activation before a candidate exists.
Conflicts escalate root to operator;
root cannot self-accept a conflict. Initial accepted receipts are issued by the
operator for intent and by root only after operator intent plus validation.

Assignment, builder, reviewer, runtime instance, lease, and ACK schemas MUST
include ids, role, candidate/assignment digest, owner, state, issued/expiry,
fencing token, scope/tool intersection, independence receipt, and successor/
recusal reason. Review verdict vocabulary is exactly `PASS`, `FAIL`, `RECUSED`,
`EXPIRED`; a FAIL cannot be silently converted to PASS. Every task-owned
mutation, return, review, or store transition MUST include the current CAS
revision and fencing token. The durable mutation envelope applies equally to
root, operator, validator, specification authority, graph compiler, evidence
producer/verifier, binding adapter, and outbox writer: `{record_id,
expected_revision, actor_id, actor_epoch, token_domain, fencing_token,
effect_idempotency_key, payload_digest}`. `token_domain` is the record's active
lease domain (`root-run`, `node`, `review`, `binding`, or `outbox`); token
rotation occurs on reserve, reclaim, successor creation, expiry, actor-epoch
change, and explicit revocation. The store accepts an effect once per
`token_domain + effect_idempotency_key` only with the current revision/token;
stale or duplicate envelopes reject without an external effect. A retry reuses
only a proven idempotency key and current successor
revision; otherwise it creates a successor linked to predecessor, reason, and
invalidated evidence. `ACCEPTED`, `REPLACED`, `CANCELLED`, root `CLOSED`, root
`CANCELLED`, and root `BLOCKED` are terminal; a terminal record never reopens.
`CLOSED` requires an `operator_closure_receipt` bound to root-run id, candidate,
scope, proof and candidate digests plus canonical-binding readback digest when
policy requires it; root can only recommend that closure.

`node.ACTIVE` references exactly one current `lease_state=ACQUIRED`, unexpired
builder lease whose assignment id, actor id/epoch, token domain, fencing token,
and execution-input digest equal the node's active assignment. `review.ACTIVE`
references exactly one current `ACQUIRED`, unexpired reviewer lease whose
assignment id, actor id/epoch, token domain, fencing token, and
review-candidate digest equal the review record. `RESERVED`, `RELEASED`,
`EXPIRED`, reclaimed, mismatched, or duplicate leases cannot support either
ACTIVE state. Releasing or expiring the referenced lease atomically invalidates
its ACK and authority: an active node becomes `UNKNOWN`; an active review
becomes `EXPIRED` and leaves its node non-accepted. A replacement lease is a
new assignment/actor epoch/fencing token and may be acquired only after CAS
invalidates the former lease; concurrent replacement attempts conflict.

### Content-addressed execution input and review candidate manifests

All three Phase-1 manifest schemas — `execution_input_manifest`,
`review_candidate_manifest`, and `root_review_candidate_manifest` — are closed
objects and domain-separated by distinct prefixes. They use RFC 8785 JCS over
UTF-8 bytes and SHA-256 of exact bytes, prefixed respectively by
`accelerate-execution-input-manifest-v1\n`,
`accelerate-review-candidate-manifest-v1\n`, and
`accelerate-root-review-candidate-manifest-v1\n`. Duplicate JSON keys reject. Inputs
MUST satisfy I-JSON and RFC 8785 number/string rules; verifiers fail closed for
non-finite or differently representable numbers. `null` is explicitly known
empty; absence is legal only for a schema-optional field. Dependency arrays use
ordinal then id, set-like references use bytewise UTF-8 lexical digest order,
and sequences use immutable sequence order.

Phase 1 core is the sole schema owner, canonicalizer, and validator for all
three manifests; no Phase-5 rule defines or extends a manifest schema. Phase 1
exit includes deterministic JCS bytes/hashes and positive and negative fixtures
for every one of the three schemas. Phase 5 consumes and enforces those frozen
schemas only.

At fan-in, root freezes one content-addressed
`root_review_candidate_manifest` using the same JCS/UTF-8/SHA-256 procedure,
with prefix `accelerate-root-review-candidate-manifest-v1\n`. It is immutable
for the root review and contains: `root_run_id`, execution-input manifest id and
digest, the frozen DAG denominator, every current non-superseded denominator
child node id, `ACCEPTED` state, accepted review-candidate id/digest, and exact
acceptance/quorum receipt ids/digests, the current child-set digest, exact G4/G5/G6
receipt ids/digests, fan-in and integration-output
snapshot plus proof, whole-change proof plan, and non-goals. `FAN_IN->REVIEWING`
requires the complete manifest and candidate-bound global proof; a whole-change
reviewer binds exactly that root candidate digest. `REVIEWING->LIFECYCLE_RECONCILING`
requires derived G7 after all mandatory whole-change dimensions/quorum `PASS`
and current child receipts. G7 is not an input to the root manifest. Any
unknown field, duplicate semantic child, non-denominator child, current-child-set
mismatch, nonaccepted/`FAILED`/`BLOCKED`/`UNKNOWN`/`ACTIVE` child, omitted,
stale, replaced, or mismatched child/candidate/acceptance/quorum receipt,
missing G4/G5/G6, incomplete fan-in, or absent global proof rejects. Omission
is legal only when an accepted, signed scope/DAG-successor disposition explicitly
invalidates every affected join; an invalid omission or replacement rejects.
Required fixtures are
`root-manifest-accept`, `root-manifest-unknown-field-reject`,
`root-manifest-duplicate-semantic-child-reject`,
`root-manifest-non-denominator-child-reject`,
`root-manifest-current-child-set-mismatch-reject`,
`root-manifest-nonaccepted-child-reject`, `root-manifest-failed-child-reject`,
`root-manifest-blocked-child-reject`, `root-manifest-unknown-active-child-reject`,
`root-manifest-invalid-omission-or-replacement-reject`,
`root-manifest-omitted-child-reject`, `root-manifest-stale-child-reject`,
`root-manifest-missing-gates-reject`, and `root-global-proof-mismatch-reject`.

The three Phase-1 schemas use `additionalProperties:false` or an equivalent
rejection rule. They define every required and optional field,
cardinality, JSON type, and null rule; an optional field is absent unless the
schema explicitly permits `null`. Every digest field has the normalized grammar
`sha256:<64 lowercase hexadecimal characters>`; uppercase, bare, malformed,
or algorithm-substituted values reject. Unknown fields, duplicate JSON keys,
and duplicate semantic references (the same logical artifact/assignment/actor
under distinct syntax) reject. RFC 8785 behavior is pinned by exact fixtures
for Unicode normalization-sensitive strings, member ordering, unknown fields,
duplicate semantic references, and invalid digests. Schema implementation is
Phase-1 work; this contract does not claim it exists.

`execution_input_manifest` is immutable before builder dispatch and contains
`schema_version`, canonical-binding digest, accepted intent/scope/spec/task-DAG
digests, ordered accepted input artifacts, assignment lineage, selected
reference/profile/capability digests, selected proportional depth, loop/gate
selectors, and risk-class digest. It contains no builder output or test result.
Its digest is bound into every builder assignment and ACK.

`review_candidate_manifest` is immutable only after the builder return. It
contains its `execution_input_manifest_digest`, canonical output snapshot, and
generated artifact digests plus dependency/lock/config digests where those are
in the frozen denominator. The output snapshot is either an immutable commit
and tree digest, or an explicit no-commit tree digest produced by the governed
snapshot algorithm. A supplied commit/tree/output digest mismatch rejects.
Builder pre-freeze proof is diagnostic/provisional, is retained for forensics,
and is never gate evidence. After root freezes this manifest, implementation
proof MUST run or rerun and bind to its digest before reviewer assignment.

`candidate-output-snapshot-v1` is the canonical output-snapshot object. It
contains `mode` (`commit` or `no_commit`), repository root identity, allowed
denominator paths, tracked/untracked/ignored policy, and one sorted entry per
path with path, type (`regular`, `symlink`, or `submodule`), mode including the
executable bit, byte size, and either content digest, symlink-target digest, or
submodule commit digest. It also contains generated-artifact digests and every
declared dependency, lockfile, configuration, and non-secret environment-input
digest. In `commit` mode it binds immutable commit id, tree digest, every
submodule commit, and a clean denominator; ignored or untracked material is
excluded unless explicitly declared in the allowed denominator and hashed. In
`no_commit` mode the same complete root snapshot is materialized without a
commit and must declare its clean/materialization policy. Proof runs only in a
clean materialization of this exact snapshot and rejects extra, missing, type,
mode, executable-bit, content/target, submodule, generated-artifact, or input
mismatch. Phase 1 fixtures include commit/no-commit extra-file, missing-file,
symlink-target, executable-bit, submodule, ignored-untracked, generated-output,
and dependency/lock/config/env-input mismatch rejects.

Observed timestamps, PIDs, transcripts, secrets, caches, host paths, and lease
expiry are excluded. Any verifier MUST regenerate JCS bytes and reject a
supplied hash that differs. Phase 1 MUST add deterministic fixtures with exact
UTF-8 bytes and hashes, including `proof-before-review-candidate-freeze-reject`
(`REJECTED`, no review lease and no gate evidence) and
`output-tree-mismatch-reject` (`REJECTED`, revision unchanged, no assignment or
review effect); this proposal does not claim the fixtures exist now.

### Closed go/no-go and closure receipts

`bootstrap_gate_receipt` is a receipt type, not a gate family. It is a closed,
signed, single-consumption schema with `gate_family=domain-gauntlet` and
`gate_id={domain-gauntlet:G0,domain-gauntlet:G1,domain-gauntlet:G2,domain-gauntlet:G3_BUILDER,domain-gauntlet:G3_REVIEW}`, plus exactly: `verdict=GO`,
`issuer_actor_id`, `issuer_actor_epoch`, issuer authority/signature,
`root_run_id`, subject id, issued/expiry/revocation fields, one allowed
transition or activation stage, CAS predecessor digest, and bindings required
by the gate. G0 binds accepted intent, authority and hardened-packet scope and
only permits `DRAFT->FROZEN`; G1/G2 bind root, frozen DAG and execution-input
manifest and only permit frozen-DAG admission/`FROZEN->APPLYING`; G3_BUILDER
binds root, builder subject node/assignment, execution-input manifest,
pre-spawn `tasks_ready_receipt`, and post-spawn `builder_ready_receipt`, and only
permits builder `BOOTSTRAPPED->ACTIVE`; G3_REVIEW binds root, subject review
assignment, `reviewer_ready_receipt`, review-candidate manifest/candidate and
candidate-bound proof and only permits reviewer activation. The verifier checks issuer/actor authority,
freshness, expiry and revocation, exact root/subject/manifest/candidate
bindings, stage, predecessor, and unused consumption marker; absent, stale,
revoked, cross-root, wrong-stage, cross-manifest, or cross-candidate receipts
reject with no advance or effect.

`go_no_go_receipt` is a Phase-5-owned, Phase-5-validated closed schema with
`gate_family=domain-gauntlet` and exactly: family-qualified `gate_id`,
`verdict`, `root_run_id`, exact candidate digest and (where
the gate is root-scoped) root-manifest digest, child loop id, immediate parent
loop id, frozen DAG/flow/seam denominator digest, prerequisite receipt ids and
digests, participant child set, verifier actor/epoch/signature/freshness, and
the single allowed state advance. Its enum registry is
`gate_id={domain-gauntlet:G4,domain-gauntlet:G5,domain-gauntlet:G6,domain-gauntlet:G7}`, `verdict={GO,NO_GO}`, and an exact gate/advance
combination registry; unknown, extra, absent, duplicate, incompatible, or bare
gate IDs reject. The required negative fixture `go-no-go-bare-id-reject` proves
that `G4`, `G5`, `G6`, and `G7` cannot be consumed without their family. G4 binds the child, its immediate parent, and its current candidate. G5
binds the exact frozen seam and complete current participant set and consumes
current G4 receipts. G6 binds the exact frozen integration flow and complete
current seam set and consumes current G5 receipts. The root manifest enumerates
and verifies G4/G5/G6; it cannot enumerate G7. Cross-parent, cross-candidate,
stale, missing-child, partial-seam, and partial-flow receipts reject.

G7 is a derived `global_closure_eligibility` receipt, issued only after root
review-candidate freeze, candidate-bound global proof, and whole-change PASS
quorum. It binds root candidate/run, frozen denominator, and the complete set
of current children. It alone permits `REVIEWING->LIFECYCLE_RECONCILING`; it is
not an input to `root_review_candidate_manifest`.

`operator_closure_receipt` is a Phase-5-owned, Phase-5-validated closed schema
with `receipt_family=closure` . It contains operator identity,
signer authorization/signature/freshness, `root_run_id`, scope/non-goal digest,
`root_review_candidate_digest`, root global-proof and whole-change-quorum
digests, `policy_mode`, and binding readback digest when required. For
`policy_mode={optional,none}`, it carries an explicit external-lifecycle
prohibition; no external lifecycle advance is legal. It is consumed only by
`LIFECYCLE_RECONCILING->CLOSED` after G7. Root/candidate mismatch, stale scope
or proof, bad signature, missing required readback, and optional/none external
advance reject. Missing or wrong `receipt_family` rejects; the receipt registry
lists `closure` as a receipt-family value, never a gate-family value.

### Candidate and root-run lineage

External late evidence or a root-detected defect after `FAN_IN` never reopens
an `ACCEPTED` predecessor. The authorized root trigger, within the correction
budget and under one CAS transaction, moves root `FAN_IN->CORRECTING`, creates
a new successor node/candidate/assignment from the accepted predecessor with
lineage and invalidation receipts, and marks that predecessor superseded for
the current root candidate while preserving its historical terminal state. No
`ACCEPTED->...` transition exists. Reentry requires the successor to become
`ACCEPTED`, then a new root manifest, global proof, and whole-change review
before `CORRECTING->APPLYING->FAN_IN`; authority, CAS, and budget failure has
no successor or partial state effect.

A review-candidate successor is a new immutable review candidate within the
same `root_run_id`, created only by CAS `successor_receipt` naming predecessor,
output correction, invalidated proof/reviews, carried mission counters, and
replacement node ids. An upstream accepted-input change creates an execution-
input successor, invalidates its builder/reviewer assignments and all dependent
review candidates, and requires new assignments. A terminal root always needs a
successor root run, never an in-place successor candidate. A successor root run is a new
`root_run_id`, linked by a fresh, signed `root_successor_receipt` to an immutable
terminal predecessor state with no predecessor mutation. It binds terminal
reason, operator disposition, explicit carried/reset counter and budget policy,
and rejects any silent hard-floor reset. The successor has fresh G0--G7
receipts, manifests, proof and reviews; it does not reuse predecessor gate
evidence. A `FAILED` or
`BLOCKED` node is terminal for that node: it can never be reopened, retried, or
reviewed; recovery is either a reconciled fresh-lease continuation allowed from
`UNKNOWN`, a successor candidate/node, or a successor root run. Root `FAILED`
is represented by terminal `BLOCKED` plus a failure disposition receipt; only a
successor root run can resume terminal `BLOCKED`/`CANCELLED`/`CLOSED` work.

The correction-origin transaction is unified for recoverable proof failure and
required reviewer `FAIL`; neither origin has a separate successor path:

```text
node.PROVING --recoverable proof failure--> CORRECTION_REQUIRED
  --one successor transaction--> REPLACED
  -> successor(PLANNED/RESERVED/BOOTSTRAPPED/ACTIVE ... CANDIDATE_FROZEN/PROVING)
```

The successor transaction uses `correction_key=loop_id+root_run_id` only as its
cap bucket and the immutable `correction_attempt_id` as its attempt identity.
At SERIALIZABLE isolation it atomically validates/assigns the next round,
records the attempt, increments the bucket count and applicable `corrections`,
`successors`, `spawns`, and `reproofs`, copies inherited counters and remaining
cap, inserts the successor candidate/node/assignment, reserves capacity,
creates its lease and new fence, marks predecessor evidence and reviews invalid,
and commits all rows or none. A same-attempt replay returns the original receipt
without state, counter, lease, or external effect; distinct attempts may take
rounds 1--3, round 4 rejects, and concurrent same-attempt requests have one
winner.

If the corrected child is already represented by a current
`root_review_candidate_manifest`, or later root evidence binds that child, the
transaction invalidates that dependent subset: root manifest, candidate-bound
global proof, whole-change reviews/quorum, derived G7, closure eligibility, and
any unconsumed `operator_closure_receipt`. Independently, every recoverable
child correction while root is `FAN_IN` CASes root `FAN_IN->CORRECTING` in that
same transaction even when no manifest/evidence exists; then the dependent
invalidation subset is empty. It then creates exactly one child successor and
invalidates predecessor node evidence. These root and child effects are one
serializable all-or-none transaction: rollback leaves no partial root/child
invalidation, successor, ledger consumption, or transition. If no root manifest
exists, the dependent-root invalidation set is empty, but `FAN_IN->CORRECTING`
still applies. A concurrent root-invalidation loser is `REJECTED` with no
effect. After child-successor acceptance, root progression is exactly
`CORRECTING->APPLYING->FAN_IN`; it freezes a NEW root manifest/current child set
and reruns global proof plus whole-change review/quorum before any new G7. Late
proof, review, closure, or reconciliation evidence that is not bound to the
current child and root manifest is recorded only as stale forensic evidence and
cannot advance lifecycle. `LIFECYCLE_RECONCILING->CORRECTING` is legal before
`CLOSED`; once `CLOSED`, in-place correction is `REJECTED` and a successor-root
receipt is required. A third-round cap race has one winner at most; a losing
racer observes the new revision and performs no effect. Required fixtures: `proof-correction-full-path`,
`review-correction-full-path`, `proof-correction-cap-race-reject`,
`proof-correction-successor-race-reject`,
`review-correction-successor-race-reject`, and proof/review rollback fixtures
that prove no partial successor effect.

### Mission scheduler and fencing

`max_active_assignments=3` applies mission-wide. Builder admission and a
review-candidate-bound reviewer each count separately, but only concurrently
live leases count: a planned reviewer has zero capacity until candidate-bound
proof completes. Builder assignment/reservation/ACK may proceed alone; after
return, review-candidate freeze, and candidate-bound proof, the fresh reviewer
is independently assigned, leased, and ACKed. The
mission ledger has immutable caps and monotonic counters for `tokens`,
`elapsed_ms`, `cost_minor_units`, `spawns`, `corrections`, `successors`,
`reproofs`, and `external_effects`. Correction cap is exactly three per
`loop_id + root_run_id`; each retry, successor, and reproof consumes its named
counter and propagates the remaining cap/counters to every successor. A child
cannot reset, borrow, or exceed a parent/mission cap. Lease TTL and renewal are
explicit in the assignment. Every write, return, and review carries a
monotonically increasing fencing token; the store accepts only the current
token. On expiry, the worker is `UNKNOWN`, its token is invalid, and it cannot
write. Resume first reconciles `UNKNOWN` against runtime/readback evidence;
only then may it create a fresh reservation, lease, token and ACK, or select
`FAILED`, `BLOCKED`, or `REPLACED`. Budget exhaustion yields `BLOCKED` unless
operator issues an external-effect or budget-extension receipt; external
effects never gain replay authority from a retry.

There is exactly one scheduler-ledger admission operation per `root_run_id`.
It executes at SERIALIZABLE isolation (or a single-record CAS with an equivalent
serializable conflict rule), rereads aggregate current live leases and all
mission/correction counters, checks candidate lineage and hard floors, reserves
one slot, increments every applicable spawn/correction/reproof/successor
counter, and creates assignment, `RESERVED` lease, and fencing token together.
Admission includes ordinary builders, eligible candidate-bound reviewers,
recovery reservations, and correction successors; no side admission path is
legal. A serialization/CAS conflict rolls back every reservation, counter,
assignment, lease, and fence with no external effect. Required fixtures:
`concurrent-third-slot-one-winner`, `correction-cap-race-one-winner`, and
`successor-admission-race-one-winner`.

### Domain Gauntlet gates

| Gate | Required receipt | Meaning |
| --- | --- | --- |
| `domain-gauntlet:G0` | single-consumption `bootstrap_gate_receipt` | accepted intent, hardening, and authority bind only `DRAFT->FROZEN` |
| `domain-gauntlet:G1` | single-consumption `bootstrap_gate_receipt` | frozen domain-capability-flow graph/non-goals bind frozen-DAG admission/`FROZEN->APPLYING` |
| `domain-gauntlet:G2` | single-consumption `bootstrap_gate_receipt` | frozen contracts/seams/oracles/reference snapshots bind frozen-DAG admission/`FROZEN->APPLYING` |
| `domain-gauntlet:G3_BUILDER` / `domain-gauntlet:G3_REVIEW` | single-consumption `bootstrap_gate_receipt` | execution-input-bound builder activation after bootstrap ACK is distinct from review-candidate/proof-bound reviewer activation |
| `domain-gauntlet:G4` | current child-and-immediate-parent `go_no_go_receipt` | a local capability loop may advance only to its named immediate parent |
| `domain-gauntlet:G5` | current complete-seam `go_no_go_receipt` consuming exact G4 set | a frozen boundary contract is jointly proven by every current seam participant |
| `domain-gauntlet:G6` | current complete-flow `go_no_go_receipt` consuming exact G5 set | the frozen end-to-end capability flow is proven |
| `domain-gauntlet:G7` | derived global-closure-eligibility receipt | after root candidate freeze, global proof, and whole-change PASS quorum, lifecycle reconciliation may begin |

The gate is `NO-GO` for ambiguous ownership, a mutable shared contract, an
unavailable runtime adapter, invalid reference material, a failing hard floor,
stale evidence, a repeated blocker, or a scope, architecture, or irreversible
decision that exceeds the loop authority.

### Receipt predicates and freshness

`valid(receipt)` means its schema validates, payload/candidate/scope digests
match the gate, signature or actor identity verifies, CAS predecessor is known,
and it is not revoked, superseded, expired, or conflicted. `fresh(receipt)`
means `valid` plus `issued_at` no older than 15 minutes for runtime/capability,
lease, ACK, authorization, binding readback, and WebUI facts; and same
candidate plus same-or-newer canonical revision for spec, graph, evidence, and
review facts. `callable(receipt)` means a fresh adapter probe completed through
the selected adapter with a bounded response; `authorized(receipt)` means a
fresh policy/signer check grants this exact actor, operation, scope, and expiry.
`independent(receipt)` means verifier-confirmed pairwise-distinct reviewer
actor IDs, actor epochs, runtime instances, context roots, and context lineages
across all three Phase-0 successor reviews and across builder/reviewer pairs.
Each reviewer is also distinct from the candidate author and architecture owner
on those five identity/context dimensions. No review context is shared, review
is read-only, `fork_turns=none`, and a reviewer has no mutation authority over
the candidate or review-set and no acceptance authority. Each reviewer binds
the same document/candidate and rubric digest and has no builder transcript,
reasoning inheritance, or shared write lease. Trust roots are recorded for
audit, but a shared runtime trust root alone neither satisfies nor disqualifies
independence; it MUST NOT conceal authority overlap or any shared context or
context lineage. The verifier is the named validator/trust boundary for every
gate, never root assertion alone.
Predicate failure is a fail-closed `NO-GO`: stale facts require revalidation;
fresh-context independence cannot be waived by runtime limitation and instead
blocks physical review.

### Preflight

The root verifies:

- current repository and dirty-worktree truth;
- governing instructions and accepted sources;
- canonical work-item binding and lifecycle readback when policy requires it;
- selected specification artifact status and digests;
- selected runtime adapter status;
- model/quality mapping availability;
- exact target surfaces;
- secrets and destructive-action boundaries;
- proof commands and external dependencies.

### Execution-mode selection

Accelerate routes outside the full Domain Gauntlet/Governed Apply are:

- `direct-fast-path`: root-owned, known work classified outside the high-stakes
  predicate, with zero spawns and
  focal proof under the root route contract;
- `scoped`: a root-owned bounded lane with zero or one sidecar as permitted by
  the repository route contract. It may use proportional correction/reproof,
  but cannot claim G0-G7, G3, a physical builder/reviewer pair, or full
  gauntlet candidate lineage.

Full Domain Gauntlet/Governed Apply admits only
`execution_route=orchestrated`. Work requiring OpenSpec Governed Apply, a full
gauntlet loop, a physical independent review pair, complex candidate lineage,
or G0-G7 must be routed `orchestrated`; it must not synthesize a virtual G3 or
redefine `scoped`.

When `orchestrated`, execution was requested, `TASKS_READY` was reached, and a
callable collaboration primitive exists, physical dispatch is mandatory before
task-owned mutation.

### Dependency DAG and parallelism

Tasks become DAG nodes with explicit inputs, outputs, owned surfaces, proof,
and integration order. Parallel execution is permitted only when nodes:

- have no dependency edge between them;
- do not share mutable files or runtime state;
- do not depend on an unfrozen shared contract;
- have an explicit fan-in owner;
- can be independently validated.

The root records why parallelism is safe. Mere task count is not enough.

### Per-slice execution

For every ready slice admitted to Governed Apply, root compiles an immutable
assignment and dispatches the smallest capable agent profile. The implementer
may mutate only its assigned surface. It returns code/artifacts plus a
Subagent Return Packet; it does not declare the overall task complete.

#### Staged physical spawn and bootstrap ACK

`spawn_ack_receipt` is the sole physical-dispatch receipt, not an additional
receipt. It binds callable native primitive/tool identity, call id and runtime
instance, assignment/input/candidate digests, reservation/lease/fence linkage,
issued/fresh/readback facts, exact worker actor/profile, and loader-confirmation
linkage. Builder readiness and the G3 gate consume it; no separate
physical-dispatch receipt exists. A06 additionally requires
`spawn-ack-cross-call-reject`, `spawn-ack-fake-export-only-reject`,
`spawn-ack-no-readback-reject`, `spawn-ack-stale-reject`, and
`spawn-ack-cross-assignment-reject` with no spawn/effect.

Before any task-owned write, the causal path is `TASKS_READY -> physical
spawn/reservation -> bootstrap ACK -> builder_ready_receipt -> G3_BUILDER ->
ACTIVE`. The execution-input-bound builder runtime adapter returns the assignment digest,
agent/call identifier, current working directory and repository root, resolved
profile, tool/capability/write scope, recursion status, contract/reference
digests, and `ready` or explicit blockers. Root validates it against the
assignment, emits `builder_ready_receipt` only when its exact post-spawn proof
is complete, and MUST NOT permit a task-owned mutation before G3_BUILDER. After
the builder returns a provisional output snapshot, root
freezes the review candidate and candidate-bound proof runs or reruns; root
then compiles a review-candidate-bound reviewer assignment and requires a fresh
reviewer reservation, lease and ACK before that reviewer can become `ACTIVE`.
Missing, divergent, stale, non-callable, or candidate-mismatched ACKs block.

Prompt restrictions in a shared filesystem are not physical sandbox proof.
The runtime adapter must separately prove what enforcement and callability it
actually provides; a profile prompt may narrow intent but cannot claim an
unavailable isolation primitive.

### Per-slice review order

Each implementation passes two distinct reviews:

1. **Specification compliance review** asks whether the candidate satisfies
   the accepted requirement and did not expand scope.
2. **Quality and risk review** asks whether the solution is correct, secure,
   maintainable, minimal, and aligned with the stack.

Both review functions must be independent of the implementer for every slice.
For a slice classified outside the high-stakes predicate, one independent reviewer instance may perform
the two logically distinct reviews and must return separate verdicts. Use two
distinct reviewer instances for authentication, authorization, billing,
permissions, migrations, destructive data behavior, secrets, externally
irreversible effects, or another risk class selected by the root. After a
correction, each affected review function runs again independently against the
new candidate.

The reviewer is distinct, read-only, and in independently verified fresh
context with `fork_turns=none`. It receives accepted spec/design, review candidate and
evidence digests, and the applicable reference snapshot, but not the builder's
private transcript or rationale. Its structured verdict identifies scope,
oracle, finding, evidence, severity, and one gauntlet state. High-stakes work
requires separate specification and risk/security/domain reviewers whenever the
high-stakes classifier selects those review dimensions.

### Per-slice proof

The slice's builder proof is provisional only. Root freezes a review candidate
from its output snapshot, then runs or reruns the lowest-effect implementation
proof that can falsify its claim, followed by applicable stack gates, before
independent critique. Every gate evidence item is bound to that exact review
candidate and
its lineage. A candidate change invalidates dependent evidence, preserves it as
superseded forensic material, and opens correction/reproof rather than a new
unexplained approval.

### Oracle taxonomy and eligibility

Oracle selection is domain-sensitive:

| Surface | Primary oracle |
| --- | --- |
| UI, visual, prose | visual comparison, accessibility, and human/product review |
| backend/domain | domain invariants and deterministic tests |
| API/seam | schema, compatibility, auth, idempotency, and error contracts |
| provider adapter | official versioned contract, fixtures, sandbox, then governed runtime proof |
| integration/global | logs, traces, browser truth, E2E, rollback, and forensic checks |

The universal Correction/Reproof Loop runs against the functional,
security, and contract hard floor first. A Reference Quality Loop is optional:
anonymous comparative/reference evaluation is permitted only for eligible
candidates and comparable surfaces. Visual judgment is never the oracle for
financial invariants, auth, API behavior, migrations, or idempotency.

### Fan-in and integration

Root owns integration. It verifies overlapping assumptions, applies only
integration repairs, reruns invalidated proof, and records the integrated
candidate. Root must not quietly finish work that belonged to a child
assignment.

### Whole-change review

After fan-in, root MUST issue a fresh, candidate-bound whole-change assignment.
Its reviewer is physically distinct from every implementer, the integrator,
and every slice-review assignment with a non-superseded verdict referenced by
the current candidate evidence graph, and receives fresh context rather than a
transcript projection. It examines the complete change against proposal, specs,
design, task denominator, non-goals, and proof plan. For high-stakes work,
two distinct slice `PASS` reviews for every review dimension selected by the
D04 high-stakes classifier output for the current candidate, one
independent whole-change `PASS`, and root review-of-review are required before
lifecycle reconciliation. Deterministic fixtures MUST reject reused identities,
candidate mismatch, missing whole-change review, and insufficient high-stakes
quorum.

### Bounded correction and reproof loop

Each `correction_key=loop_id+root_run_id` is a cap bucket with an enforced
maximum of three distinct `correction_attempt_id` rounds. Every candidate and
node successor inherits that same ledger and counters. A same-attempt replay
returns its original receipt with no effect; distinct rounds 1--3 are legal and
round 4 rejects. No operator override silently extends this root-run bucket:
any renewed authority uses a successor root with its explicit successor policy.

```text
review finding
  -> root classifies and routes
  -> implementer corrects
  -> proof reruns
  -> independent reviewer re-reviews
```

The loop stops early when:

- the same blocker repeats without new evidence;
- correction requires a scope or architecture decision;
- a destructive or externally irreversible operation is required;
- the agent reaches its authority boundary;
- evidence becomes ambiguous;
- the third correction fails.

The defect ledger remains complete in every round, even when the largest gap
sets the next priority. Repetition of the same blocker without new evidence
escalates early. `BUDGET_EXHAUSTED` never approves a candidate; any extension
requires a new operator authorization and receipt. Correction and reproof of a
real external effect occur in fixture or sandbox by default. A real provider
effect, including a refund, has zero automatic replay and requires separate
effect authorization.

Stopping produces an `ESCALATED`, `BLOCKED`, or `BUDGET_EXHAUSTED` receipt and
returns control to root/operator. It never converts failure into acceptance.

### Pause and resume

Apply must be resumable from committed state, not conversation memory. The
resume packet contains:

- canonical binding state readback when policy requires it;
- selected specification artifact digests;
- frozen denominator and DAG version;
- completed, active, blocked, and pending nodes;
- execution-input digest and review-candidate output snapshot/digest per node;
- accepted and invalidated evidence;
- correction count;
- next legal transition.

On resume, every external or runtime fact is refreshed before dispatch.

### Failure discipline

Apply never ignores a failing test, reviewer finding, incomplete task, missing
agent return, ambiguous mutation, stale evidence, or adapter capability gap.
It classifies the failure, records impact, and either corrects, defers outside
scope with authority, or blocks.

## Agent model

### Base constitution

Every agent receives a small common constitution:

- obey root and assignment authority;
- preserve user work and secrets;
- do not expand scope;
- do not claim unverified completion;
- stop at destructive or authorization boundaries;
- report exact evidence and residuals;
- do not delegate unless the profile and assignment permit it;
- do not mutate Plane unless explicitly assigned through an authorized
  adapter;
- return control rather than inventing missing capabilities.

### Role contract

The initial portable catalog is:

| Role | Primary authority | Default mutation posture |
| --- | --- | --- |
| `orchestrator` / root `review-of-review` | route, task graph, fan-in, review reconciliation, closure recommendation | integration only |
| `research-explorer` | source and repository discovery | read-only |
| `implementer` (portable alias: `implementation-worker`) | bounded implementation | assigned surfaces only |
| `test-engineer` | test design and test implementation | tests/fixtures only unless assigned |
| `mechanical-fixer` | prescribed deterministic correction | exact files only |
| `adversarial-reviewer` | invalidating cases, abuse paths, and counterexamples | read-only |
| `independent-reviewer` | spec and quality findings | read-only |
| `qa-runtime-reviewer` | runtime/browser/proof assessment | read-only by default |
| `high-stakes-reviewer` | security, data, auth, billing review | read-only |

Runtime-specific names such as `python-backend`, `nextjs-frontend`, `data-db`,
and `integrations-ops` are specialization overlays over these portable roles.
The gauntlet introduces no generic mandatory `gauntlet-agent`; it reuses the
orchestrator, implementer, test-engineer, adversarial-reviewer,
independent-reviewer, qa-runtime-reviewer, and high-stakes-reviewer roles with
domain-specialized profiles selected by the
frozen domain-capability-flow graph and the current candidate's oracle/risk
classifier output.

The following is a typed function/identity matrix, not an activation list. A
candidate skill remains `candidate` until its provenance, semantic review,
ring, profile binding, and CG0--CG7 disposition exist.

| Function | Required distinct identity boundary | Candidate skill/disposition |
| --- | --- | --- |
| implementer | MUST differ from every independent/adversarial reviewer for the same candidate | implementation-stack candidates; `branch-required` only after review |
| test-engineer | MUST differ from implementer when its test proof is required for acceptance | `test-engineering`, `test-driven-development`, `api-contract-testing`; candidate, tester-gap review |
| adversarial-reviewer | MUST differ from implementer and test-engineer for the reviewed claim | `evidence-reconciliation`, `source-verification`; candidate, read-only review |
| qa-runtime-reviewer | MUST differ from implementer for runtime/browser proof adjudication | `frontend-qa-accessibility`, runtime-proof candidates; candidate, read-only review |
| independent-reviewer | MUST differ from builder and from any reviewer whose finding it independently confirms | `specification-lifecycle`, `solution-minimalism`; candidate, read-only review |
| root review-of-review / orchestrator | MUST NOT reuse a child identity to self-accept its own conflict or quorum | root `accelerate`; minimal-resident-core only under existing authority |
| high-stakes-reviewer | distinct specialization where risk policy requires it; never silently collapsed into independent review | security/data/auth/billing candidates; profile-specialist only after risk binding |

Actor reuse is prohibited wherever it would make a builder verify its own
claim, make a test engineer independently accept its own proof, make an
adversarial reviewer confirm its own finding as independent, or make root
self-accept a conflict. Runtime inability to provide the required distinct
identity is a `NO-GO`, not a role-collapse exception.

### Profile composition

A resolved profile is built in this order:

```text
base constitution
  + role contract
  + specialization overlay
  + runtime policy
  + project profile
  + immutable assignment
```

Later layers may narrow authority but may not silently widen an earlier
boundary.

### Skill, tool, and capability resolution

Before bootstrap ACK, the adapter resolves every REQUIRED skill, tool, and
capability predicate from a versioned/digested source. The effective tool scope
is the intersection of profile, assignment, runtime, and deployment policy;
deny wins. A revoked, missing, stale, unverifiable, or scope-expanded
capability makes the ACK `blocked`, never degraded by inference. The assignment
records required predicates, source version/digest, effective intersection,
and revocation freshness receipt. A negative fixture MUST prove that a revoked
or stale capability and a profile/assignment scope conflict are rejected.

### Model and reasoning classes

Portable profiles request quality classes, for example:

- `fast-readonly-research`;
- `mechanical-prescribed`;
- `standard-implementation`;
- `independent-review`;
- `high-stakes-readonly`.

Each runtime adapter maps these classes to models and reasoning effort it
actually supports and returns the effective mapping. Unsupported mappings
block or require explicit operator-authorized degradation.

### Subagent Return Packet

Every child returns:

- assignment and `canonical_work_item_binding` locator/id/revision/digest;
  Plane-specific metadata only when Karval `policy_mode=required`;
- resolved profile and effective runtime/model receipt;
- owned surfaces;
- requested versus delivered;
- files/artifacts changed;
- commands and proof results;
- findings and decisions;
- assumptions;
- blockers and residuals;
- execution-input digest, provisional output snapshot, and review-candidate digest;
- recommended next gate;
- explicit statement of what it did not verify.

Root validates the packet against repository truth before accepting it.
The packet is distinct from the pre-write bootstrap ACK: a valid return cannot
repair a missing or invalid G3 dispatch receipt retroactively.

## Canonical binding and OpenSpec reconciliation

The selected canonical binding and OpenSpec serve different purposes and must
not compete. OpenSpec is optional: `core` Apply has no OpenSpec dependency;
`full` Apply requires a selected and validated OpenSpec adapter.

### Authority rules

- A `required` binding creation/readback precedes full-mode OpenSpec artifact
  mutation for mutating work. Karval's required binding is Plane.
- Every OpenSpec change stores immutable canonical binding locator/revision and
  URL where available in adapter metadata.
- Every dispatchable task follows the closed `binding_policy_mode`: it carries
  the selected binding for `required`/`optional`, carries no binding for `none`,
  and cannot dispatch for `unavailable`.
- OpenSpec task checkboxes are projections of execution state, not tracker
  authority or proof.
- Agents never mark projected tasks complete merely because implementation
  returned.
- Root reconciles child evidence, OpenSpec task status, and bound lifecycle state.
- OpenSpec archive cannot auto-close a bound lifecycle.
- Closure requires the normal AI Review Report, proof stack, forensic closure,
  lifecycle packet, and required binding readback. For Karval, no disposition
  may advance lifecycle, dispatch, closure, or external effects without fresh
  Plane readback.

### Reconciliation table

| OpenSpec state | Bound lifecycle meaning | Allowed action |
| --- | --- | --- |
| artifact materialized | planning evidence exists | continue artifact gates |
| artifact valid | structural validation passed | independent review |
| tasks ready | execution graph accepted | dispatch only after all Apply preconditions, `TASKS_READY`, route-specific physical-dispatch proof, and required binding/authorization/readback predicates pass |
| task checked | projected candidate delivered | validate evidence, do not close |
| change complete | implementation denominator materialized | whole-change review |
| change archived | durable spec history | eligible for binding closure checks |

### Drift handling

If bound-lifecycle scope changes, root updates the hardened packet first, then
produces a successor specification artifact revision and invalidates dependent
approvals. If an artifact changes without required binding authority, execution
fails closed until reconciled. Each operation has durable outbox record,
logical-operation id, request digest, idempotency key/capability fallback, and
outcome `APPLIED`, `NOT_APPLIED`, or `UNKNOWN`; `UNKNOWN` blocks all advance.

## Proof architecture

The required proof order remains:

1. implementation proof;
2. backend/frontend QA proof;
3. browser truth through Chrome DevTools;
4. persistent regression proof through Playwright;
5. forensic closure.

OpenSpec contributes planning and structural evidence before this stack. It
does not replace any lane.

For each proof, store:

- claim;
- proof class;
- exact command or observation method;
- execution-input digest, review-candidate digest, and output snapshot digest;
- environment;
- result;
- timestamp;
- owner;
- invalidation triggers.

## WebUI decision: authorized LAN exposure

The OpenSpec WebUI is intentionally allowed to bind to all host interfaces:

```bash
openspec-webui --host 0.0.0.0 --port <configured-port>
```

This is an accepted deployment requirement, not a finding to be "fixed" back
to loopback. Binding to `0.0.0.0` changes the trust boundary: it does not, by
itself, make the service Internet-authorized.

### Intended role

The WebUI is a non-authoritative upstream interface with mutable surfaces. It
MUST be exposed only through an enforcing proxy/backend method-path-WebSocket
allowlist and backend-port isolation, or replaced by a generated read-only
artifact copy. Trusted-lab segmentation alone is insufficient. Its allowed
observation functions are project navigation, artifact inspection, version and
validation visibility, and operator review; all other routes are deny-by-default.

It is not:

- Plane authority;
- an Accelerate control plane;
- an acceptance engine;
- an agent dispatcher;
- a security boundary;
- proof that an artifact is approved.

### Upstream security reality

The frozen WebUI snapshot provides a Fastify/Svelte interface and supports the
requested host binding (`README.md`; `src/cli/program.ts`; `src/cli/runtime.ts`).
The inspection found no explicit application-level authentication,
authorization, CSRF, origin-enforcement, or rate-limit boundary in
`src/server/index.ts`, `src/server/routes/api.ts`,
`src/server/project-registry.ts`, or `src/server/websocket/handler.ts`; this is
not a claim about every repository path or a deployed runtime. `index.ts`
registers `GET /ws` and listens on configured host/port; the API includes
project GET/POST/DELETE/activate and `POST /api/validate`; validation invokes
the strict concurrent JSON command in its working directory with 120-second
limit; registry accepts a directory containing `openspec` and persists under
XDG/`~/.config`. These are version-bound proposal inputs, not runtime proof:
the frozen candidate must be re-audited with an inspection receipt before
deployment.

Its browsing and project-registration surfaces may reveal filesystem paths and
artifact contents available to the process. Therefore, process privileges and
network placement are part of the data boundary.

### Mandatory controls for `0.0.0.0`

Before a general LAN deployment, require:

- bind only on the authorized private-LAN host;
- no public Internet exposure, public NAT, or broad ingress rule;
- enforcing proxy and backend endpoint/method/path/WebSocket allowlists; backend
  port isolated so clients cannot bypass the proxy; trusted proxy identity;
- host firewall allowlist or a dedicated trusted VLAN (not sufficient alone);
- reverse-proxy authentication and TLS when the reachable audience is broader
  than a tightly controlled lab LAN;
- application origin/session protection through a governed wrapper or fork if
  browser clients are not fully trusted;
- D05 MUST freeze the authentication transport and CSRF applicability. In
  cookie/session mode, every unsafe HTTP method and every WebSocket upgrade
  requires a valid CSRF token and same approved origin check; missing, invalid,
  or cross-origin requests reject. In non-cookie mode, ambient cookie
  authentication is prohibited and the D05 receipt records `csrf_applicability=N/A`;
- non-root service account;
- explicit allowlist of OpenSpec project roots;
- least filesystem permissions for the service account;
- configurable, reserved port;
- no secret-bearing repositories in the accessible denominator;
- mandatory authenticated identity and source-IP rate and burst limits, frozen
  by D05; request-body and WebSocket message/payload/idle limits; and separate
  bounded validation concurrency, queue length, timeout, process kill, and
  saturation receipts;
- canonical-root containment: every configured project root is canonicalized
  once, each request path is descriptor-opened beneath that root without
  following symlinks, then revalidated at use against the same device/inode
  ancestry; symlinks are denied unless a D05 allowlisted target is separately
  canonicalized and revalidated;
- outbound update/version checks treated as advisory, preferably disabled or
  blocked in controlled deployments;
- structured access and error logs without artifact or secret leakage;
- startup receipt showing immutable package version, command, host, port,
  service user, project allowlist digest, and active configuration digest;
- socket proof that the expected process is listening on the expected port;
- remote LAN canary from an authorized client;
- mandatory negative canary from disallowed identity/IP and burst saturation,
  oversized request/WS payload, WS message flood/idle expiry, validation queue
  saturation/timeout/kill bypass, method/path/WebSocket, direct backend port,
  traversal, symlink, and descriptor-race TOCTOU request; all MUST deny;
- documented stop, rollback, and residual-process checks.

If the enforcement proxy/backend allowlists, backend isolation, authentication,
or project-root allowlist cannot be added before a canary, no upstream WebUI
exposure is allowed; use a read-only artifact copy. General LAN promotion
remains blocked until those controls exist.

### Recommended integration shape

Do not patch upstream directly in place. Add an Accelerate deployment adapter
that can choose one of two modes:

1. `trusted-lab-lan`: upstream WebUI only behind enforcing proxy/backend
   allowlists and backend-port isolation, with explicit roots and no Internet
   ingress; it inherits **every** mandatory control above, including
   authenticated identity, source-IP rate/burst limits, D05-frozen transport,
   and the applicable CSRF/origin control; or a read-only artifact copy;
2. `authenticated-lan`: immutable upstream payload behind a governed reverse
   proxy or a maintained wrapper/fork that adds identity, origin protection,
   path allowlisting, and auditability.

The adapter owns deployment receipts and proof. The upstream WebUI is
non-authoritative; no read-only behavior is presumed.

D05 selects authentication transport and CSRF applicability; it never waives
identity. The A09 closed vector set is exactly
`{identity_ip_rate_burst,request_ws_size_idle,validation_saturation_kill,direct_backend_bypass,symlink,descriptor_toctou,cross_origin_http_mutation,websocket_origin,http_method_path_allowlist,websocket_endpoint_or_upgrade_allowlist,path_traversal}`.
It requires one fixture instance of each new vector: an unallowlisted
`POST /api/project` or method/path pair denies without backend mutation;
an unallowlisted WebSocket endpoint or upgrade denies without upgrade; and
`../`, encoded traversal, and absolute-path forms deny after canonical-root
resolution without opening outside the root. Omitted or unknown vectors reject.

## Source adoption matrix

| Source behavior | Decision | Accelerate adaptation |
| --- | --- | --- |
| OpenSpec change artifacts | adopt | custom `accelerate-governed` schema |
| Custom schemas/templates | adopt | repo-owned and validator-backed |
| JSON CLI contracts | adopt | adapter consumes structured output |
| Spec deltas | adopt | preserve delta plus canonical result |
| Structural validation | adapt | planning evidence only |
| Heuristic verify-change | adapt | advisory reviewer only |
| Archive | adapt | gated history operation, no auto-close |
| Plus five-lens discovery | adopt | hardened packet inputs |
| Plus What-before-How | adopt | artifact authority separation |
| Plus testable scenarios | adopt | syntax-neutral proof mapping |
| Plus alternatives | adopt | ADR-worthy decisions only |
| Plus vertical slices | adopt | task graph default |
| Plus Apply workflow | adopt/adapt | governed state machine and physical dispatch |
| Plus bounded Apply/review doctrine | adapt | Accelerate owns the three-round cap |
| Plus pause/resume | adopt | committed resume packet |
| Plus giant embedded prompts | reject | progressive-disclosure skills |
| Plus moving-main updater | reject | immutable release governance |
| Plus copy/overwrite install | reject | transactional adapter promotion |
| Checkbox equals completion | reject | projected state only |
| Automatic archive/closure | reject | operator closure receipt and selected canonical-binding gate; Plane only for Karval `policy_mode=required` |
| Universal strict TDD | reject | proportional test-design and lowest-effect proof |
| Reviewer self-correction | reject | correction returns to implementer, then re-review |
| Optional subagent after TASKS_READY | reject | physical dispatch mandatory when available |
| Silent inline fallback | reject | explicit blocked/degraded receipt |
| Duolahypercho Domain Gauntlet prompt | adapt critically | domain-loop vocabulary and prompt constraints only; no runtime claim |
| Robonuggets composer/comparison ideas | adapt critically | optional reference-quality ideas after hard-floor eligibility |
| original Claude-of-Duty assessment | adapt critically | preserve harness/process cautions; no claimed benchmark success |

## Dependency and release governance

OpenSpec components are external dependencies. Before any installation:

- verify official source and license;
- resolve an immutable published version/tag;
- record source commit and package provenance;
- compare required Node/runtime versions with the active service environment;
- create a recoverable backup of affected configuration and artifacts;
- stage in an isolated test root;
- validate CLI JSON contracts against fixtures;
- validate schema behavior against a compatibility matrix;
- prove rollback;
- promote through a repo-owned adapter;
- read back installed, configured, active, callable, and authorized states
  separately.

Moving `main`, `master`, or an updater's `--latest` choice is never stable
release authority.

The source snapshot used for this proposal was:

- OpenSpec Core package release `v1.11.0`, tag commit
  `a0ddb60d040c61f4907436a9d91310934b1dda63`;
- OpenSpec Core inspected main commit
  `d0071d7326689a0269332a500c8f56b3f2218ba9`;
- OpenSpec Plus inspected main commit
  `7358841abdade7629a7b6bcb3fc02bc760e064f9`, with repository `VERSION`
  reporting `1.4.1` and no immutable tag observed in the inspection;
- OpenSpec WebUI release `v1.3.0`, commit
  `ce3ed35a98613f3949062acc83fe77a7868fd6fa`.

These locators are analysis evidence, not authorization to install.

### Source Provenance Appendix

All records were accessed `2026-09-01`; direct immutable links are the
authority for D07, now resolved for proposal provenance.

| Source / immutable locator | Paths / license | Claim and verdict |
| --- | --- | --- |
| `https://github.com/Fission-AI/OpenSpec/tree/a0ddb60d040c61f4907436a9d91310934b1dda63` | `README.md`, `package.json`, `LICENSE`; MIT | artifact/JSON/CLI lifecycle only; never delivery acceptance |
| `https://github.com/sudokar/openspec-plus/tree/7358841abdade7629a7b6bcb3fc02bc760e064f9` | `README.md`, `VERSION`, `LICENSE`, `skills/openspec-plus-apply/SKILL.md`, `skills/openspec-plus-apply/spec-compliance-reviewer-prompt.md`, `skills/openspec-plus-apply/code-quality-reviewer-prompt.md`, `skills/openspec-plus-apply/final-review-prompt.md`; MIT | doctrine only: vanilla Step-6 takeover, spec-compliance before code-quality, strict TDD, no skipped failures, and no commits are source facts; Accelerate adopts only bounded compatible doctrine |
| `https://github.com/oioi555/openspec-webui/tree/ce3ed35a98613f3949062acc83fe77a7868fd6fa` | `README.md`, `src/cli/program.ts`, `src/cli/runtime.ts`, `src/server/index.ts`, `src/server/routes/api.ts`, `src/server/project-registry.ts`, `src/server/websocket/handler.ts`; MIT | host/route/security observations are limited to these frozen files and require deployment re-audit |
| `https://github.com/duolahypercho/gauntlet-loop/tree/b63fbb6e86c03cf348c7fc30f32b500d2005061f` | `README.md`, `skills/gauntlet-loop/SKILL.md`, `skills/gauntlet-loop/AGENTS.md`, `LICENSE`; MIT | prompt/skill only; Domain Gauntlet adaptation is ours |
| `https://github.com/robonuggets/gauntlet-loop/tree/9b1975a1b8f01981f3f1e6b667ad3aaf907178ea` | `README.md`, `.claude/skills/gauntlet-loop/SKILL.md`, `LICENSE`; CC BY 4.0 | for shared/adapted licensed expression, attribution and change indication are legally required; for independently paraphrased ideas, retained credit/provenance is project policy; no protected text copied |
| `https://github.com/mshumer/Claude-of-Duty/tree/d9b237b75c9304ab8d9ef4cfa0c3568c7c11a853` | `README.md`, `LICENSE`; MIT | candid non-success/sequential ownership are self-reported contextual evidence only |

Additional immutable analysis sources are deliberately adopted only as bounded
ideas, not as proof of general effectiveness or runtime capability:

- Duolahypercho, commit `b63fbb6e86c03cf348c7fc30f32b500d2005061f`, current
  pure-prompt material, MIT: useful for declaring domain constraints, but it
  does not implement a governed runtime.
- Robonuggets, commit `9b1975a1b8f01981f3f1e6b667ad3aaf907178ea`, prompt
  composer/comparative ideas, CC BY 4.0: useful only as input to an optional,
  eligible Reference Quality Loop; it does not implement a runtime.
- original Claude-of-Duty, commit `d9b237b75c9304ab8d9ef4cfa0c3568c7c11a853`:
  useful for its prompt, harness, and candid assessment/process note; it does
  not establish that the original case achieved CoD or that its forks implement
  runtime behavior.

The original case observed directory-based fan-out failing while sequential
concern ownership improved the result. This is a contextual design signal, not
a universal rule or a general proof that one execution topology is superior.

## Skills strategy

### Keep `accelerate` concise and authoritative

`SKILL.md` remains the activation and root-routing layer. It should reference
the new architecture rather than absorb the full procedure.

### Add one focused OpenSpec adapter skill

The first new skill candidate is `openspec-sdd-adapter`. It activates when work
needs OpenSpec artifact discovery, custom-schema operation, status/validation,
selected canonical-binding reconciliation (Plane only for Karval
`policy_mode=required`), or governed archive.

It should not own:

- root classification;
- task execution;
- agent dispatch;
- acceptance;
- Plane mutation authority;
- WebUI deployment.

### Agent profiles reference skills

Profiles list mandatory and conditional skills. Skills never contain hidden
authority to instantiate a worker. Dispatch decisions remain explicit in the
task graph and runtime adapter.

### WebUI deployment belongs in an adapter

LAN exposure, process identity, firewall/proxy expectations, health, canaries,
and rollback are operational deployment concerns. They belong in a runtime or
deployment adapter plus a concise operating skill, not in the OpenSpec SDD
skill.

## Machine-readable contracts to implement later

The following twenty-one rows are the only closed execution-control schemas
normatively specified by this proposal: Phase 1 core owns
`tasks_ready_receipt`, `builder_ready_receipt`, and `reviewer_ready_receipt`
schemas plus their positive and negative fixtures; Phase 5 owns
`bootstrap_gate_receipt`, `go_no_go_receipt`, and `operator_closure_receipt`
schemas plus their positive and negative fixtures. Each schema has one version,
owner, phase, validator, closed receipt/gate family, and fixture denominator;
unknown/missing/duplicate fields and wrong family/owner/phase bindings reject.
This 21-row table is exhaustive authority for the current normative schema
denominator. Issuer or approver MAY differ from `owner_id`, but absent or
unknown schema ownership rejects.

| schema_id | schema_version | owner phase | owner_id | validator | contract family | fixture owner/matrix |
| --- | --- | --- | --- | --- | --- |
| `execution_input_manifest` | `v1` | 1 | `phase1-core-owner` |`validate-candidate` | artifact | A04 |
| `review_candidate_manifest` | `v1` | 1 | `phase1-core-owner` |`validate-candidate` | artifact | A04 |
| `root_review_candidate_manifest` | `v1` | 1 | `phase1-core-owner` |`validate-candidate` | artifact | A04 |
| `tasks_ready_receipt` | `tasks-ready-v1` | 1 | `phase1-core-owner` |`validate-dispatch-readiness` | dispatch-readiness | A04 |
| `builder_ready_receipt` | `builder-ready-v1` | 1 | `phase1-core-owner` |`validate-builder-readiness` | builder-readiness | A04 |
| `reviewer_ready_receipt` | `reviewer-ready-v1` | 1 | `phase1-core-owner` |`validate-reviewer-readiness` | review-readiness | A04 |
| `bootstrap_gate_receipt` | `v1` | 5 | `phase5-root-owner` |`validate-state-gates-and-closure` | domain-gauntlet | A05 |
| `go_no_go_receipt` | `v1` | 5 | `phase5-root-owner` |`validate-state-gates-and-closure` | domain-gauntlet | A05 |
| `operator_closure_receipt` | `v1` | 5 | `phase5-root-owner` |`validate-state-gates-and-closure` | closure | A05 |
| `domain_gauntlet_g4_receipt_set` | `v1` | 1 | `phase1-core-owner` |`validate-candidate` | domain-gauntlet | A04 |
| `domain_gauntlet_g5_receipt_set` | `v1` | 1 | `phase1-core-owner` |`validate-candidate` | domain-gauntlet | A04 |
| `domain_gauntlet_g6_receipt_set` | `v1` | 1 | `phase1-core-owner` |`validate-candidate` | domain-gauntlet | A04 |
| `agent_assignment` | `v1` | 3 | `phase3-agent-owner` |`validate-authority` | assignment | A02 |
| `agent_identity_receipt` | `v1` | 3 | `phase3-agent-owner` |`validate-authority` | identity | A02 |
| `spawn_ack_receipt` | `v1` | 4 | `phase4-runtime-owner` |`validate-runtime-lease` | runtime | A06 |
| `runtime_capability_receipt` | `v1` | 4 | `phase4-runtime-owner` |`validate-runtime-lease` | capability | A06 |
| `runtime_lease_receipt` | `v1` | 4 | `phase4-runtime-owner` |`validate-runtime-lease` | runtime | A06 |
| `fence_token_receipt` | `v1` | 4 | `phase4-runtime-owner` |`validate-runtime-lease` | runtime | A06 |
| `loader_confirmation_receipt` | `v1` | 4 | `phase4-runtime-owner` |`validate-runtime-lease` | runtime | A06 |
| `prompt_load_receipt` | `v1` | 4 | `phase4-runtime-owner` |`validate-runtime-lease` | session-load | A06 |
| `independence_receipt` | `v1` | 5 | `phase5-review-owner` |`validate-review` | review | A08 |

Filenames MAY be kebab-case but are never schema aliases; canonical
underscore `schema_id` collisions or duplicates reject.
Validator IDs are canonical kebab-case; an executable filename/display either
equals that ID or is separately mapped as a filename, never an implicit alias.

The following are non-normative candidate schema asset filenames. They are not
required, authorized, or implementable until a successor adds canonical
`schema_id`, version, owner, validator, family, and fixture matrix entry; a
kebab-case filename is never an alias identifier:

- `hardened-execution-packet`;
- `openspec-change-binding`;
- `artifact-acceptance-receipt`;
- `task-graph`;
- `domain-gauntlet-graph`;
- `gauntlet-loop-node`;
- `agent-profile`;
- `spawn-validation-receipt`;
- `subagent-return-packet`;
- `review-finding`;
- `defect-graph`;
- `evidence-graph`;
- `correction-cycle`;
- `proof-receipt`;
- `resume-packet`;
- `webui-lan-deployment-receipt`;

These extend rather than duplicate the existing packet and evidence contracts.
Every schema must have positive fixtures, negative fixtures, and a validator.
The Phase-1 core owner owns all three manifest schemas; the Phase-2 specification
owner owns proportional-depth, loop/gate-selector, risk-class, and canonical-
binding-policy schemas; the Phase-5 root owner owns `go_no_go_receipt`,
`operator_closure_receipt`, their validators, and runtime enforcement.
Unknown enum values, absent owners, and absent validators are `REJECTED` with
no dispatch, state advance, or external effect.
Required negative fixtures include: the same executor and reviewer; missing
model, reasoning effort, or fork; absent or divergent ACK; reviewer writes;
candidate change with stale evidence; a shared seam parallelized before contract
freeze; loop beyond budget; local GO closing global delivery; missing or
mismatched reference; retry of a real provider effect; and nested spawn without
an explicit grant.

## Proposed delivery phases

### Phase 0 — Architecture acceptance

#### Phase-0 immutable common review rubric

The following delimited block is the sole common base rubric. Every Phase-0
marked block uses this canonical normalization algorithm: encode as UTF-8;
replace CRLF and CR with LF; strip ASCII space and tab from the end of every
line; include its start- and end-marker lines; exclude explanatory prose; and
end the canonical byte stream immediately after the final `>` of the end
marker, with no terminal LF. This block is frozen before dispatch as
`base_rubric_digest=SHA256(UTF8 exact normalized rubric block)`. It is not a
whole-document digest and is never self-referential.

<!-- phase0-common-rubric-v1:start -->
`phase0-common-rubric-v1`

Required axes: `authority-and-scope`, `state-and-transition-safety`,
`evidence-and-freshness`, `lineage-and-fencing`, `manifest-and-snapshot-integrity`,
`migration-denominator-and-rollback`, `security-and-lan-boundary`,
`testability-and-negative-fixtures`, and `internal-consistency`.

For each axis the reviewer records `PASS|FAIL|BLOCKED`, claim locator,
contradiction or gap, evidence locator, and required correction. `PASS` means
no unresolved contradiction or missing mandatory predicate in that axis.
<!-- phase0-common-rubric-v1:end -->

The following three delimited blocks are the complete immutable overlays, not
external references. Each preserves every base axis and adds only its exact
questions.

<!-- phase0-lens-control-plane-v1:start -->
`phase0-lens-control-plane-v1`
Preserved axes: `authority-and-scope`, `state-and-transition-safety`,
`evidence-and-freshness`, `lineage-and-fencing`, `manifest-and-snapshot-integrity`,
`migration-denominator-and-rollback`, `security-and-lan-boundary`,
`testability-and-negative-fixtures`, `internal-consistency`.
Questions: Are root/operator/binding authorities exclusive and fail-closed? Are
G0-G7 receipts sufficient and correctly parent-scoped? Is lifecycle projection
conditional on binding policy without permitting non-root closure?
<!-- phase0-lens-control-plane-v1:end -->

<!-- phase0-lens-runtime-concurrency-v1:start -->
`phase0-lens-runtime-concurrency-v1`
Preserved axes: `authority-and-scope`, `state-and-transition-safety`,
`evidence-and-freshness`, `lineage-and-fencing`, `manifest-and-snapshot-integrity`,
`migration-denominator-and-rollback`, `security-and-lan-boundary`,
`testability-and-negative-fixtures`, `internal-consistency`.
Questions: Does one serializable scheduler admission own every live lease and
counter? Do fences/CAS prevent stale writes and cap races? Does every proof or
review correction atomically invalidate evidence and create exactly one lineage?
<!-- phase0-lens-runtime-concurrency-v1:end -->

<!-- phase0-lens-migration-security-v1:start -->
`phase0-lens-migration-security-v1`
Preserved axes: `authority-and-scope`, `state-and-transition-safety`,
`evidence-and-freshness`, `lineage-and-fencing`, `manifest-and-snapshot-integrity`,
`migration-denominator-and-rollback`, `security-and-lan-boundary`,
`testability-and-negative-fixtures`, `internal-consistency`.
Questions: Does the inventory classify every root entry or block? Are retained
docs paths current versus historical correctly? Do all LAN modes retain
authenticated identity and every mandatory boundary control?
<!-- phase0-lens-migration-security-v1:end -->

For every Phase-0 marked block, normalization is UTF-8; CRLF and CR become LF;
ASCII space and tab are stripped from the end of each line; start/end marker
lines are included; explanatory prose is excluded; and the canonical byte
stream MUST end immediately after the final `>` of the end marker with no
terminal LF. Each block digest is
`SHA256(UTF8 exact normalized block)`. At dispatch the verifier computes a
closed `phase0-review-set-manifest-v1` containing immutable candidate digest,
candidate-author actor id/epoch/trust-root, architecture-owner actor
id/epoch/trust-root, `phase0_acceptance_work_item=CODEX-25`, document digest,
base-rubric digest, ordered overlay
ids/digests, the required digest-bound predecessor-to-successor handoff record,
and verifier version; it is immutable and
candidate-bound. The Phase-0 internal-consistency receipt binds this manifest,
deterministic contradiction/heading/source-locator/path-reference scans. The
successor-review verifier recomputes every digest and rejects root assertion,
self-verification, a missing or mismatched handoff, missing/extra overlay, or
mismatched review-set.

The manifest additionally contains an exact ordered closed mapping of three
items `{review_slot,required_overlay_id,required_overlay_digest}`, covering
each of the three normative overlays exactly once. Each
`phase0-successor-review-v1` binds exactly one assigned `review_slot` and its
required overlay id/digest, records substantive findings against that overlay's
questions/axes, and cannot satisfy another slot. The verifier proves exhaustive
one-to-one coverage. Exact negatives
`phase0-duplicate-slot-reject`, `phase0-duplicate-overlay-reject`,
`phase0-omitted-overlay-reject`, `phase0-cross-slot-reject`,
`phase0-unassigned-overlay-reject`, `phase0-wrong-overlay-digest-reject`, and
`phase0-no-substantive-overlay-answer-reject` each block operator acceptance
and Phase-1 entry.

- Inputs: this body, complete provenance appendix, internal-consistency receipt,
  and three fresh independent successor `PASS` reviews.
- Owned decision: operator architecture acceptance; no implementation output.
- Each successor-review receipt schema is `phase0-successor-review-v1` with
  immutable `candidate_digest`, `candidate_author_actor_id`,
  `candidate_author_actor_epoch`, `candidate_author_trust_root`,
  `architecture_owner_actor_id`, `architecture_owner_actor_epoch`,
  `architecture_owner_trust_root`, `predecessor_successor_handoff_digest`,
  `issued_at`, `expires_at`, `freshness_basis`, `review_set_verifier_actor_id`, `review_set_verifier_actor_epoch`, `review_set_verifier_trust_root`, `document_digest`, reviewer actor
  ID/epoch/runtime instance/context root/context lineage/trust root, `fresh_context` receipt,
  `read_only=true`, base rubric
  digest, named lens-overlay ids/digests, verdict, findings,
  conflicts, issue time, and verifier signature. All three reviews MUST be
  pairwise independent and distinct from both candidate author and architecture
  owner by actor ID, actor epoch, runtime instance, context root, and context
  lineage (author may equal owner, but neither may overlap any reviewer on those
  dimensions). Every reviewer MUST use `fork_turns=none`, a fresh read-only
  context, and hold neither candidate/review-set mutation authority nor
  acceptance authority. Trust roots are recorded, while the same runtime trust
  root alone is neither sufficient nor disqualifying; it MUST NOT mask an
  authority overlap or shared context/context lineage. No shared review context
  is legal; all review receipts bind the same candidate/document/rubric digest
  and a verifier-confirmed trust boundary. The exact negatives
  `phase0-author-as-reviewer-reject={REJECTED,FAIL,unchanged,no_operator_acceptance,independence+candidate}` and
  `phase0-owner-as-reviewer-reject={REJECTED,FAIL,unchanged,no_operator_acceptance,independence+candidate}`
  block operator acceptance. The exact negatives `phase0-review-set-expired-reject={REJECTED,FAIL,unchanged,no_operator_acceptance,independence+candidate}` and `phase0-verifier-overlap-reject={REJECTED,FAIL,unchanged,no_operator_acceptance,independence+candidate}` require the verifier to differ from candidate author, architecture owner, all reviewers, and operator acceptor where applicable; no acceptance on fail. Operator acceptance directly forbids root
  self-acceptance; A02 later tests that same invariant.
- `phase0_operator_acceptance_receipt` is the closed design-governance schema
  `phase0-operator-acceptance-v1`, explicitly outside the 21 execution-control
  schema denominator. Its owner is `phase0-architecture-owner` and validator is
  `validate-phase0-acceptance`. It requires current candidate/document digest
  plus digest algorithm, `phase0_acceptance_work_item=CODEX-25`, Phase-0 review-set-manifest digest, required
  predecessor-successor-handoff digest, verified exhaustive slot-overlay mapping digest, exact ordered
  three PASS review receipt digests, acceptor actor id/epoch/trust-root,
  signer authority/signature, issued/expires/freshness/revocation status,
  CAS current-digest revalidation, and a single-consumption idempotency key.
  The acceptor MUST differ from root, candidate author, architecture owner,
  all reviewers, and review-set verifier. If architecture owner is operator,
  that does not permit self-acceptance: an independent operator acceptor or a
  separately governed machine-bound exception is required. Exact negatives
  `phase0-root-as-acceptor-reject`, `phase0-author-as-acceptor-reject`,
  `phase0-owner-as-acceptor-reject`, `phase0-acceptance-stale-reject`,
  `phase0-acceptance-revoked-reject`, `phase0-acceptance-cross-candidate-reject`,
  `phase0-acceptance-cross-review-set-reject`,
  `phase0-acceptance-missing-or-nonpass-review-reject`,
  `phase0-acceptance-current-digest-cas-mismatch-reject`, and
  `phase0-acceptance-replay-divergent-consumption-reject` each yield no effect
  and no Phase-1 entry.
- `phase_implementation_authorization_receipt` is the closed governance schema
  `phase-implementation-authorization-v1`, outside the 21 execution-control
  schemas, owned by the operator and validated by
  `validate-phase-implementation-authorization`. It binds current proposal
  candidate/document digest plus algorithm, accepted Phase-0 receipt digest,
  exact target phase or closed enumerated phase set, exact allowed
  paths/components/effects and non-goals, prerequisite-output and D-record
  disposition digests, authorizer id/epoch/trust-root/signature,
  issued/expires/freshness/revocation, single-consumption/idempotency, and CAS
  currentness. Root cannot issue it. A phase/scope authorization never bleeds
  to another phase/scope; expansion or a new effect requires a successor
  receipt. Every Phase 1--7 entry requires a valid current, non-revoked,
  scope-sufficient receipt. A multi-phase receipt must enumerate each phase and
  bind that phase's scope/prerequisites; each entry revalidates it. Architecture
  acceptance is not implementation authorization. Exact negatives
  `phase-auth-missing-reject`, `phase-auth-stale-reject`,
  `phase-auth-revoked-reject`, `phase-auth-wrong-phase-reject`,
  `phase-auth-scope-expansion-reject`, `phase-auth-cross-candidate-reject`,
  `phase-auth-prerequisite-mismatch-reject`, `phase-auth-d-record-mismatch-reject`,
  `phase-auth-root-issued-reject`, and `phase-auth-replay-divergent-reject`
  each yield `{REJECTED,NO_GO,unchanged,no_phase_entry_or_effect,phase-authorization}`; `phase-auth-valid-entry={ACCEPTED,AUTHORIZED,changed,no_effect_before_phase_entry,phase-authorization}` is the positive
  phase-entry assertion.
- Exit: valid current `phase0_operator_acceptance_receipt`; it authorizes no
  implementation. Open implementation decisions may remain
  deferred with a D-record; they do not block proposal acceptance.

### Phase 1 — OpenSpec adapter spike

- freeze an immutable OpenSpec Core release;
- implement D12/D14 successor source contracts only when their current disposition/contract digests are bound inside the canonical phase authorization; do not activate a projection, install a catalog, migrate a
  namespace, or retire a reader;
- add fixture-only adapter experiments;
- create the `accelerate-governed` schema draft;
- own, canonicalize, and validate all three closed manifest schemas;
- prove status, instructions, validation, and archive behavior in a test root;
- produce an ADR and compatibility receipt.

Entry is valid current, non-revoked, scope-sufficient `phase_implementation_authorization_receipt` for Phase 1 plus valid current `phase0_operator_acceptance_receipt` plus D01, D08, and D11 dispositions **and** the
current D12/D14 disposition/contract digests bound inside that receipt. Exit is A03
and A04 fixtures, exact execution-input/review-candidate/root-review-candidate
manifest bytes/hashes plus positive and negative fixtures for all three,
ADR, and rollback receipt.

### Phase 2 — Specification lifecycle integration

- add repo-owned OpenSpec adapter contracts;
- add selected canonical-binding/OpenSpec binding and drift validation; add the
  Plane adapter only when Karval `policy_mode=required`;
- add `openspec-sdd-adapter` under the Agent Skills standard;
- add structural tests and docs.

Entry is valid current, non-revoked, scope-sufficient `phase_implementation_authorization_receipt` for Phase 2 plus Phase-1 outputs plus D02 and D11 plus still-valid relied-on D01/D08 dispositions. Exit is A01 and A10 fixtures plus owned
binding/reconciliation rollback receipt.

### Phase 3 — APAF registry and assignment compiler

- materialize portable profile schemas;
- implement the D13 successor source contract only when their current disposition/contract digests are bound inside the canonical phase authorization; any project-local `.accelerate` overlay remains inert until
  activation/readback proof;
- compile profiles from constitution, role, overlay, runtime policy, and
  assignment;
- validate authority narrowing;
- add return-packet plus assignment/identity/authority validators and negative
  fixtures; retain runtime-handoff drafts only, with no spawn-ACK validation;
- materialize domain-capability-flow, seam, oracle, and loop contract drafts.

Entry is valid current, non-revoked, scope-sufficient `phase_implementation_authorization_receipt` for Phase 3 plus Phase-2 outputs plus D04 and D10 and current D13 disposition digest bound inside that receipt. Exit is A02 assignment/identity/authority closed fixtures.

### Phase 4 — Codex runtime adapter

- map quality classes to supported Codex collaboration profiles;
- enforce physical dispatch at `TASKS_READY`;
- implement spawn-ACK validation and all six A06 schemas:
  `spawn_ack_receipt`, `runtime_capability_receipt`, `runtime_lease_receipt`,
  `fence_token_receipt`, `loader_confirmation_receipt`, and
  `prompt_load_receipt`, with their positive/negative fixtures and
  readback/load/lease/fence enforcement;
- prove worktree/shared-workspace behavior and fan-in;
- add independent reviewer freshness/read-only and bounded correction/reproof
  tests, including ACK divergence and recursion denial;
- prove adapter callability/enforcement separately from prompt restrictions.

Entry is valid current, non-revoked, scope-sufficient `phase_implementation_authorization_receipt` for Phase 4 plus Phase-3 outputs plus D03. Exit is A06 closed fixtures for spawn ACK,
runtime capability, lease, fence token, loader confirmation, and prompt load,
plus physical overlap and
cleanup receipts.

### Phase 5 — Governed Apply

- implement the task DAG and Apply state machine;
- add four gauntlet loops, gate receipts, execution-input and review-candidate
  freezes, root-review-candidate consumption/enforcement, defect/evidence
  lineage, pause/resume, and evidence invalidation;
- add hard-floor eligibility, optional reference-quality routing, whole-change
  review, G7 derivation, closed operator-closure validation, and forensic
  closure integration;
- expose one aggregate `validate-state-gates-and-closure` validator: its
  `transition_digest` binds every consumed `go_no_go_digest` and
  `operator_closure_digest`, and it owns the single A05 fixture family;
- prove bounded loops and fixture/sandbox-only correction for provider effects;
- dogfood on a bounded change.

Entry is valid current, non-revoked, scope-sufficient `phase_implementation_authorization_receipt` for Phase 5 plus Phase-4 outputs plus D01 and D04 dispositions. Exit is A05, A07, A08, and deterministic
root/node/UNKNOWN/fence/whole-change/high-stakes fixtures.

### Phase 6 — WebUI LAN enforcing boundary

- freeze an immutable WebUI release;
- choose `trusted-lab-lan` or `authenticated-lan` mode;
- implement project-root allowlisting and deployment receipts;
- start with `--host 0.0.0.0` only after firewall/proxy preflight;
- run socket, authorized-client, negative-access, log, stop, and rollback proof;
- expose only the explicitly allowlisted observation interface; upstream
  behavior is otherwise treated as mutable and non-authoritative.

Entry is valid current, non-revoked, scope-sufficient `phase_implementation_authorization_receipt` for Phase 6 plus Phase-5 outputs plus D05 and D09. Exit is A09 and owned LAN
negative-canary/rollback receipts.

### Phase 7 — Additional runtime adapters

- add one runtime at a time;
- declare real primitive and capability status;
- prove model mapping, tools, isolation, messaging, and return contracts;
- never claim parity from prompt similarity alone.

Entry requires a valid current, non-revoked, scope-sufficient
`phase_implementation_authorization_receipt` for Phase 7, all mapped
non-revoked prior outputs required by the D06 migration denominator, plus D06
and D14 disposition/retirement digests bound inside that receipt. Exit is A11 source-target
parity/readback/rollback receipt.

## Acceptance criteria for the architecture

These are future implementation contracts, not commands that exist. They do
not block proposal acceptance and each blocks only its mapped phase.
Every fixture assertion below has the closed receipt grammar
`{code,result_state,revision_effect,forbidden_effect,receipt_digests}`. It is
an object with exactly those five required fields and no additional fields:
`code` is `ACCEPTED`, `REJECTED`, or `NOT_APPLICABLE`; `result_state`,
`revision_effect`, and `forbidden_effect` are closed fixture enums; and
`receipt_digests` is a non-empty, sorted object whose values each satisfy
`sha256:<64 lowercase hexadecimal characters>`. Branch renderings below retain
that exact field order. A fifth-field shorthand such as `proof+transition` is
notation only: it expands to an exact sorted `receipt_digests` object with the
named keys `proof_digest` and `transition_digest`, each holding a runtime
`sha256:<64 lowercase hexadecimal characters>` value. Token normalization is
lowercase ASCII token text plus the `_digest` suffix; unknown, duplicate, or
unmapped tokens reject. Omitted fields, aliases, and implicit effects are
prohibited.

The grammar is mechanically closed: `revision_effect={unchanged,changed}`;
`result_state` is exactly the uppercase result tokens rendered in A01--A11,
plus `UNCLASSIFIED_ROOT`; and `forbidden_effect` is exactly the lowercase
effect tokens rendered in A01--A11. The validator derives both domains by
parsing those tables in UTF-8 source order, deduplicating byte-identical tokens,
and rejecting any token not in that derived set, every unknown combination, and
every extra/missing digest key. This is a deterministic closed schema rather
than an open prose convention.

The exact shorthand token registry is:
`ack->ack_digest`, `assignment->assignment_digest`, `authority->authority_digest`,
`acceptance->acceptance_digest`, `bootstrap-gate->bootstrap_gate_digest`,
`binding-policy->binding_policy_digest`, `candidate->candidate_digest`,
`conflict->conflict_digest`, `csrf-applicability->csrf_applicability_digest`,
`event-log->event_log_digest`, `fence->fence_digest`, `idempotency->idempotency_digest`,
`independence->independence_digest`, `invalidation->invalidation_digest`,
`lease->lease_digest`, `ledger->budget_ledger_digest`, `missing-readback->missing_readback_digest`,
`negative-canary->negative_canary_digest`, `operation->operation_digest`,
`outbox->outbox_digest`, `parity->parity_digest`, `policy->policy_digest`,
`predecessor->predecessor_digest`, `proof->proof_digest`, `quorum->quorum_digest`,
`readback->binding_readback_digest`, `reader->reader_digest`, `regenerated-tree->regenerated_tree_digest`,
`retention->retention_digest`, `review->review_digest`, `rollback->rollback_digest`,
`source->source_digest`, `successor->successor_digest`, `target->target_digest`,
`token->token_digest`, `transition->transition_digest`,
`execution-input-manifest->execution_input_manifest_digest`,
`operator-disposition->operator_disposition_digest`, `rubric->rubric_digest`,
`supplied->supplied_digest`, `go-no-go->go_no_go_digest`,
`root-manifest->root_review_candidate_manifest_digest`,
`closure->operator_closure_digest`, `scope->scope_digest`,
`global-proof->global_proof_digest`, `whole-change-quorum->whole_change_quorum_digest`,
`root-successor->root_successor_receipt_digest`,
`correction-attempt->correction_attempt_digest`, `identity->identity_digest`, `runtime-capability->runtime_capability_digest`, `loader-confirmation->loader_confirmation_receipt_digest`, `prompt-load->prompt_load_receipt_digest`, `schema->schema_digest`, `phase-authorization->phase_implementation_authorization_receipt_digest`, `tasks-ready->tasks_ready_receipt_digest`, `builder-ready->builder_ready_receipt_digest`, `reviewer-ready->reviewer_ready_receipt_digest`, `domain-gauntlet:G0->domain_gauntlet_g0_bootstrap_gate_digest`, `domain-gauntlet:G1->domain_gauntlet_g1_bootstrap_gate_digest`, `domain-gauntlet:G2->domain_gauntlet_g2_bootstrap_gate_digest`, `domain-gauntlet:G3_BUILDER->domain_gauntlet_g3_builder_bootstrap_gate_digest`, and `domain-gauntlet:G3_REVIEW->domain_gauntlet_g3_review_bootstrap_gate_digest`.
For A04/A05, exact gate keys are additionally
`domain-gauntlet:G4->domain_gauntlet_g4_go_no_go_digest`,
`domain-gauntlet:G5->domain_gauntlet_g5_go_no_go_digest`,
`domain-gauntlet:G6->domain_gauntlet_g6_go_no_go_digest`, and
`domain-gauntlet:G7->domain_gauntlet_g7_go_no_go_digest`,
`domain-gauntlet:G4-set->domain_gauntlet_g4_receipt_set_digest`,
`domain-gauntlet:G5-set->domain_gauntlet_g5_receipt_set_digest`, and
`domain-gauntlet:G6-set->domain_gauntlet_g6_receipt_set_digest`; all entries in this paragraph are registry mappings.
`domain-gauntlet:G4-set`, `domain-gauntlet:G5-set`, and
`domain-gauntlet:G6-set` are closed sorted aggregate schemas binding the exact
receipt IDs/digests and participant denominator for their current G4/G5/G6
sets. Empty, duplicate, omitted, or wrong-participant members reject; required
negatives are `g4-set-multi-child-omission-reject`,
`g5-set-multi-seam-omission-reject`, and `g6-set-wrong-participant-reject`.
Machine-readable filenames MAY be kebab-case, but canonical `schema_id` values
are the underscore identifiers used by normative contracts; filenames are not
aliases.
Each shorthand is expanded 1:1 into its sorted `receipt_digests` keys; any
unregistered table shorthand, alias, duplicate, or omitted key rejects.

| ID | First phase | Future owner command | Fixture / exact expected assertion | Receipt digest field |
| --- | --- | --- | --- | --- |
| A01 | 2 | `validate-binding` | `binding-none={ACCEPTED,LOCAL_ONLY,unchanged,no_backend_lifecycle_advance,binding-policy+readback}`; `karval-no-readback={REJECTED,NO_READBACK,unchanged,no_dispatch_or_lifecycle_advance,binding-policy+missing-readback}` | `binding_readback_digest` |
| A02 | 3 | `validate-authority` | `equal-precedence-conflict={REJECTED,OPERATOR_ESCALATION,unchanged,no_acceptance_or_authority_mutation,conflict+authority}`; `root-self-acceptance={REJECTED,OPERATOR_ESCALATION,unchanged,no_root_self_acceptance,conflict+authority}`; `operator-disposition={ACCEPTED,RESOLVED,changed,operator_only,operator-disposition+authority}` | `authority_digest` |
| A03 | 1 | `validate-gauntlet-store` | `crash-replay={ACCEPTED,REPLAYED,unchanged,no_duplicate_effect,event-log+idempotency}`; `divergent-replay={REJECTED,CONFLICT,unchanged,no_appended_event_or_effect,event-log+conflict}` | `event_log_digest` |
| A04 | 1 | `validate-candidate` | `execution-input-manifest-v1={ACCEPTED,MANIFEST_MATCH,unchanged,no_forbidden_effect,execution-input-manifest}`; `review-candidate-manifest-v1={ACCEPTED,MANIFEST_MATCH,unchanged,no_forbidden_effect,candidate}`; `root-manifest-accept={ACCEPTED,MANIFEST_MATCH,unchanged,no_forbidden_effect,root-manifest+execution-input-manifest+acceptance+quorum+domain-gauntlet:G4-set+domain-gauntlet:G5-set+domain-gauntlet:G6-set}`; `root-manifest-unknown-field-reject={REJECTED,UNKNOWN_FIELD,unchanged,no_root_review_advance,root-manifest}`; `root-manifest-duplicate-semantic-child-reject={REJECTED,DUPLICATE_SEMANTIC_REFERENCE,unchanged,no_root_review_advance,root-manifest}`; `root-manifest-non-denominator-child-reject={REJECTED,DENOMINATOR_MISMATCH,unchanged,no_root_review_advance,root-manifest}`; `root-manifest-current-child-set-mismatch-reject={REJECTED,CHILD_SET_MISMATCH,unchanged,no_root_review_advance,root-manifest}`; `root-manifest-nonaccepted-child-reject={REJECTED,FAN_IN_INCOMPLETE,unchanged,no_root_review_advance,root-manifest+acceptance}`; `root-manifest-failed-child-reject={REJECTED,FAN_IN_INCOMPLETE,unchanged,no_root_review_advance,root-manifest+acceptance}`; `root-manifest-blocked-child-reject={REJECTED,FAN_IN_INCOMPLETE,unchanged,no_root_review_advance,root-manifest+acceptance}`; `root-manifest-unknown-active-child-reject={REJECTED,FAN_IN_INCOMPLETE,unchanged,no_root_review_advance,root-manifest+acceptance}`; `root-manifest-invalid-omission-or-replacement-reject={REJECTED,DENOMINATOR_MISMATCH,unchanged,no_root_review_advance,root-manifest+operator-disposition}`; `included-input-mutation={ACCEPTED,SUCCESSOR_CREATED,changed,no_forbidden_effect,predecessor+successor}`; `proof-before-review-candidate-freeze-reject={REJECTED,NO_GATE_EVIDENCE,unchanged,no_reviewer_lease_or_gate_evidence,candidate}`; `output-tree-mismatch-reject={REJECTED,OUTPUT_SNAPSHOT_MISMATCH,unchanged,no_assignment_or_review_effect,supplied+regenerated-tree}`; `tasks-ready-valid={ACCEPTED,READY,changed,no_spawn_or_write,tasks-ready}`; `tasks-ready-missing-required-skill-plan-reject`, `tasks-ready-unresolvable-loader-capability-reject`, `tasks-ready-duplicate-node-reject`, and `tasks-ready-bound-input-change-reject` each yield `{REJECTED,NO_GO,unchanged,no_spawn_or_write,tasks-ready}`; `builder-ready-valid={ACCEPTED,READY,changed,no_write_before_g3,builder-ready}`; `builder-ready-missing-worker-reject`, `builder-ready-wrong-worker-reject`, `builder-ready-missing-ack-reject`, `builder-ready-lease-fence-reject`, `builder-ready-prompt-load-reject`, and `builder-ready-capability-reject` each yield `{REJECTED,NO_GO,unchanged,no_write_or_active,builder-ready}`; `reviewer-ready-valid={ACCEPTED,READY,changed,no_review_before_g3,reviewer-ready}`; `reviewer-ready-missing-candidate-reject`, `reviewer-ready-wrong-assignment-reject`, `reviewer-ready-actor-runtime-reject`, `reviewer-ready-ack-lease-fence-reject`, `reviewer-ready-prompt-load-reject`, `reviewer-ready-proof-independence-reject`, and `reviewer-ready-capability-reject` each yield `{REJECTED,NO_GO,unchanged,no_review_active,reviewer-ready}` | `candidate_digest`, `tasks_ready_receipt_digest`, `builder_ready_receipt_digest`, `reviewer_ready_receipt_digest` |
| A05 | 5 | `validate-state-gates-and-closure` | Aggregate `transition_digest` binds `go_no_go_digest`, `bootstrap_gate_digest`, and `operator_closure_digest`: `legal-root-node-path={ACCEPTED,ACCEPTED,changed,none,transition+candidate+proof}`; `g0-draft-freeze-accept={ACCEPTED,FROZEN,changed,no_unbound_advance,transition+domain-gauntlet:G0}`; `g1-g2-frozen-admission-accept={ACCEPTED,APPLYING,changed,no_unbound_advance,transition+domain-gauntlet:G1+domain-gauntlet:G2}`; `g3-builder-activation-accept={ACCEPTED,ACTIVE,changed,no_unbound_activation,transition+domain-gauntlet:G3_BUILDER+tasks-ready+builder-ready}`; `g3-review-activation-accept={ACCEPTED,ACTIVE,changed,no_unbound_activation,transition+domain-gauntlet:G3_REVIEW+reviewer-ready}`; `bootstrap-gate-absent-reject`, `bootstrap-gate-stale-reject`, `bootstrap-gate-revoked-reject`, `bootstrap-gate-cross-root-reject`, `bootstrap-gate-wrong-stage-reject`, `bootstrap-gate-cross-manifest-reject`, and `bootstrap-gate-cross-candidate-reject` each yield `{REJECTED,NO_GO,unchanged,no_advance_or_effect,transition+bootstrap-gate}`; `proof-failure-recoverable={ACCEPTED,CORRECTION_REQUIRED,changed,no_review_lease,proof+transition}`; `proof-failure-terminal={ACCEPTED,FAILED,changed,no_review_or_successor_reopen,proof+transition}`; `review-fail={ACCEPTED,CORRECTION_REQUIRED,changed,no_acceptance,review+transition}`; `accept-without-all-pass={REJECTED,REVIEWING,unchanged,no_acceptance,review+quorum}`; `terminal-reopen-reject={REJECTED,TERMINAL,unchanged,no_reopen,transition}`; `proof-correction-full-path={ACCEPTED,REPLACED,changed,no_inherited_gate_evidence,predecessor+successor+invalidation+transition}`; `review-correction-full-path={ACCEPTED,REPLACED,changed,no_inherited_gate_evidence,predecessor+successor+invalidation+transition}`; `post-fanin-no-manifest-child-correction={ACCEPTED,CORRECTING,changed,no_root_evidence_invalidation,predecessor+successor+invalidation+transition}`; `late-evidence-accepted-predecessor-successor={ACCEPTED,CORRECTING,changed,no_accepted_reopen,predecessor+successor+invalidation+transition}`; `post-fanin-child-correction-accepted={ACCEPTED,CORRECTING,changed,no_inherited_gate_evidence,predecessor+successor+invalidation+transition+root-manifest+global-proof+whole-change-quorum+go-no-go+closure}`; `post-fanin-correction-reentry={ACCEPTED,FAN_IN,changed,no_inherited_gate_evidence,transition+root-manifest}`; `concurrent-root-invalidation-race-loser={REJECTED,CONFLICT,unchanged,no_root_or_child_invalidation,predecessor+root-manifest}`; `root-correction-transaction-rollback={REJECTED,ROLLED_BACK,unchanged,no_partial_root_or_child_invalidation,predecessor+root-manifest+ledger}`; `closed-successor-root-full-path={ACCEPTED,CLOSED,changed,no_predecessor_mutation,root-successor+operator-disposition+domain-gauntlet:G0+domain-gauntlet:G1+domain-gauntlet:G2+domain-gauntlet:G3_BUILDER+domain-gauntlet:G3_REVIEW+root-manifest+global-proof+whole-change-quorum+domain-gauntlet:G7+closure}`; `closed-root-correction-reject={REJECTED,TERMINAL,unchanged,no_in_place_correction,predecessor+transition}`; `proof-correction-cap-race-reject={REJECTED,CAP_EXCEEDED,unchanged,no_lease_or_spawn,ledger+transition}`; `root-manifest-omitted-child-reject={REJECTED,FAN_IN_INCOMPLETE,unchanged,no_root_review_advance,transition+root-manifest}`; `root-manifest-stale-child-reject={REJECTED,STALE,unchanged,no_root_review_advance,transition+root-manifest}`; `root-manifest-missing-gates-reject={REJECTED,FAN_IN_INCOMPLETE,unchanged,no_root_review_advance,transition+root-manifest}`; `root-global-proof-mismatch-reject={REJECTED,CONFLICT,unchanged,no_root_lifecycle_advance,transition+root-manifest+global-proof}`; `non-root-closure-receipt-reject={REJECTED,NO_CLOSURE_RECEIPT,unchanged,no_closure,transition+root-manifest}`; `g4-current-child-parent={ACCEPTED,GO,changed,no_cross_parent_advance,transition+go-no-go+candidate}`; `g5-complete-seam={ACCEPTED,GO,changed,no_partial_seam_advance,transition+go-no-go+candidate}`; `g6-complete-flow={ACCEPTED,GO,changed,no_partial_flow_advance,transition+go-no-go+root-manifest}`; `g7-derived-global-eligibility={ACCEPTED,GO,changed,no_pre_g7_lifecycle_advance,transition+go-no-go+root-manifest+global-proof+whole-change-quorum+domain-gauntlet:G7}`; `go-no-go-bare-id-reject={REJECTED,NO_GO,unchanged,no_state_advance,transition+go-no-go}`; `cross-parent-go-no-go-reject`, `cross-candidate-go-no-go-reject`, `stale-go-no-go-reject`, `missing-child-go-no-go-reject`, `partial-seam-go-no-go-reject`, and `partial-flow-go-no-go-reject` each yield `{REJECTED,NO_GO,unchanged,no_state_advance,transition+go-no-go}`; `closure-required-binding-accept={ACCEPTED,CLOSED,changed,no_forbidden_effect,transition+closure+root-manifest+scope+global-proof+whole-change-quorum+domain-gauntlet:G7+readback}`; `closure-optional-none-local-accept={ACCEPTED,CLOSED,changed,no_external_lifecycle_advance,transition+closure+root-manifest+scope+global-proof+whole-change-quorum+domain-gauntlet:G7}`; `closure-root-mismatch-reject`, `closure-stale-scope-reject`, `closure-stale-proof-reject`, `closure-bad-signature-reject`, `closure-required-readback-missing-reject`, `closure-missing-g7-reject`, and `closure-optional-none-external-advance-reject` each yield `{REJECTED,NO_CLOSURE,unchanged,no_closure,transition+closure}` | `transition_digest` |
| A06 | 4 | `validate-runtime-lease` | `builder-bootstrap-ack-required={REJECTED,PLANNED,unchanged,no_write_or_active_lease,assignment+ack}`; `active-with-reserved-reject={REJECTED,RESERVED,unchanged,no_active_state,lease+assignment}`; `mismatched-assignment-candidate-actor-reject={REJECTED,MISMATCH,unchanged,no_active_state_or_write,lease+assignment+candidate}`; `ack-after-expiry-reject={REJECTED,EXPIRED,unchanged,no_ack_or_active_state,lease+ack}`; `concurrent-lease-replacement-reject={REJECTED,CONFLICT,unchanged,no_second_active_lease,lease+fence}`; `expired-lease-unknown={ACCEPTED,UNKNOWN,changed,no_stale_write,lease}`; `old-token-write-reject={REJECTED,STALE_FENCE,unchanged,no_write_or_effect,lease+token}` | `lease_digest` |
| A07 | 5 | `validate-scheduler` | `fourth-live-lease-reject={REJECTED,CAP_EXCEEDED,unchanged,no_lease_or_spawn,ledger}`; `aggregate-cap-overflow-reject={REJECTED,CAP_EXCEEDED,unchanged,no_lease_or_spawn,ledger}`; `concurrent-third-slot-one-winner={ACCEPTED,RESERVED,changed,no_second_active_lease,ledger+lease}`; `correction-rounds-1-3-sequential={ACCEPTED,REPLACED,changed,no_new_budget,ledger+correction-attempt+predecessor+successor}`; `correction-same-attempt-replay={ACCEPTED,REPLAYED,unchanged,no_counter_or_successor_effect,ledger+correction-attempt}`; `correction-round-4-reject={REJECTED,CAP_EXCEEDED,unchanged,no_lease_or_spawn,ledger+correction-attempt}`; `correction-same-attempt-concurrent-one-winner={ACCEPTED,REPLACED,changed,no_second_successor_or_counter_effect,ledger+correction-attempt+successor}`; `correction-cap-race-one-winner={ACCEPTED,REPLACED,changed,no_new_budget,ledger+predecessor+successor}`; `proof-correction-successor-race-reject={REJECTED,CONFLICT,unchanged,no_successor_effect,ledger+predecessor}`; `review-correction-successor-race-reject={REJECTED,CONFLICT,unchanged,no_successor_effect,ledger+predecessor}`; `proof-correction-rollback-reject={REJECTED,ROLLED_BACK,unchanged,no_partial_successor_effect,ledger+predecessor}`; `review-correction-rollback-reject={REJECTED,ROLLED_BACK,unchanged,no_partial_successor_effect,ledger+predecessor}`; `root-correction-race-one-winner={ACCEPTED,REPLACED,changed,no_second_root_or_child_successor,ledger+predecessor+successor+invalidation+transition}`; `root-correction-race-loser={REJECTED,CONFLICT,unchanged,no_root_or_child_invalidation,ledger+predecessor}`; `root-correction-rollback-reject={REJECTED,ROLLED_BACK,unchanged,no_partial_root_or_child_invalidation,ledger+predecessor+root-manifest}`; `closed-successor-admission-counter-policy={ACCEPTED,RESERVED,changed,no_predecessor_counter_or_hard_floor_reset,ledger+root-successor+successor}`; `successor-admission-race-one-winner={ACCEPTED,RESERVED,changed,no_second_active_lease,ledger+lease+successor}` | `budget_ledger_digest` |
| A08 | 5 | `validate-review` | `reviewer-reuse-reject={REJECTED,PLANNED,unchanged,no_pass_or_lifecycle_advance,independence+candidate+rubric}`; `fresh-context-independence-reject={REJECTED,PLANNED,unchanged,no_pass_or_lifecycle_advance,independence+candidate+rubric}`; `candidate-mismatch-reject={REJECTED,PLANNED,unchanged,no_pass_or_lifecycle_advance,independence+candidate+rubric}`; `whole-change-independence-reject={REJECTED,PLANNED,unchanged,no_pass_or_lifecycle_advance,independence+candidate+rubric}`; `high-stakes-quorum-reject={REJECTED,PLANNED,unchanged,no_pass_or_lifecycle_advance,independence+candidate+rubric}`; `valid-review={ACCEPTED,PASS,changed,no_write_by_reviewer,independence+candidate+rubric}` | `independence_digest` |
| A09 | 6 | `validate-webui-boundary` | `boundary-deny[vector]={REJECTED,DENY,unchanged,no_backend_mutation_or_upgrade,negative-canary+policy}` for exactly one fixture instance of every closed `vector={identity_ip_rate_burst,request_ws_size_idle,validation_saturation_kill,direct_backend_bypass,symlink,descriptor_toctou,cross_origin_http_mutation,websocket_origin,http_method_path_allowlist,websocket_endpoint_or_upgrade_allowlist,path_traversal}`; `http-method-path-allowlist-deny`, `websocket-endpoint-upgrade-allowlist-deny`, and `path-traversal-deny` are the required final-three instances; `vector-omitted-or-unknown={REJECTED,VECTOR_COVERAGE_INVALID,unchanged,no_backend_mutation_or_upgrade,negative-canary+policy}`; `missing-csrf-cookie-session={REJECTED,DENY,unchanged,no_backend_mutation_or_upgrade,negative-canary+policy}`; `missing-csrf-non-cookie={NOT_APPLICABLE,CSRF_NOT_APPLICABLE,unchanged,no_ambient_cookie_auth,csrf-applicability+policy}` | `negative_canary_digest` |
| A10 | 2 | `validate-reconciliation` | `partial-outbox={ACCEPTED,UNKNOWN,changed,no_advance_or_external_replay,operation+outbox}`; `duplicate-effect={ACCEPTED,APPLIED,unchanged,no_second_effect,operation+idempotency}` | `operation_digest` |
| A11 | 7 | `validate-tree-parity` | closed `included_row_class={root,root-config,local-state,local-policy,ci-hosting-auxiliary,core,workflow,runtime,adapters-shared-docs,profiles-agents,scripts,tests-fixtures,examples,global-runtime,skills,onboarding,planning,docs,overlays-references}` and `excluded_row_class={vcs-metadata,no-reader-codex,backup,playwright-mcp,pytest-cache,temp,worktree,cache}` require one fixture each: `included-row[class]={ACCEPTED,PARITY_MATCH,unchanged,no_orphan,source+target+reader+retention+rollback}` and `excluded-row[class]={ACCEPTED,EXCLUDED_WITH_RATIONALE,unchanged,no_canonical_reader_orphan,source+reader+retention+rollback}`. `adapters-shared-docs-exact-path={ACCEPTED,PARITY_MATCH,unchanged,no_orphan,source+target+reader+retention+rollback}`; `adapters-shared-docs-orphan-reject={REJECTED,ORPHAN,unchanged,no_migration_effect,source+reader}`; `adapters-shared-docs-undeclared-source-reject={REJECTED,UNCLASSIFIED_ROOT,unchanged,no_migration_effect,source+parity}`; `unclassified={REJECTED,UNCLASSIFIED_ROOT,unchanged,no_migration_effect,source+parity}`; `omitted-config={REJECTED,OMITTED_ROOT,unchanged,no_migration_effect,source+parity}`. No Phase-7 effect occurs before a classified disposition | `parity_digest` |

#### A04 normative supplemental fixture matrix

This table is additive-only and part of the same A04 denominator and
`validate-candidate` ownership; it neither overrides nor supersedes the main
A04 row. The canonical A04 denominator is the union of that row and this table.
Both are required for Phase-1 exit, fixture names are globally unique, and each
row is parsed by the same exact five-field grammar and token registry.

| A04 fixture | Exact expected assertion |
| --- | --- |
| `tasks-ready-bare-family-reject` | `{REJECTED,NO_GO,unchanged,no_spawn_or_write,tasks-ready}` |
| `tasks-ready-stale-binding-reject` | `{REJECTED,NO_GO,unchanged,no_spawn_or_write,tasks-ready}` |
| `g4-set-multi-child-omission-reject` | `{REJECTED,DENOMINATOR_MISMATCH,unchanged,no_root_review_advance,domain-gauntlet:G4-set}` |
| `g5-set-multi-seam-omission-reject` | `{REJECTED,DENOMINATOR_MISMATCH,unchanged,no_root_review_advance,domain-gauntlet:G5-set}` |
| `g6-set-wrong-participant-reject` | `{REJECTED,DENOMINATOR_MISMATCH,unchanged,no_root_review_advance,domain-gauntlet:G6-set}` |

#### A02/A06/A08 normative supplemental fixture matrices

These rows are part of the named A02/A06 denominators and use the same exact
five-field grammar. `valid-review` is the positive `independence_receipt`
fixture; `schema-closed-fields-reject[schema_id]` is the closed nine-schema
unknown/missing/duplicate-field family for the new inventory rows.

| Matrix | Fixture / exact assertion |
| --- | --- |
| A02 | `assignment-valid={ACCEPTED,VALID,changed,no_scope_expansion,assignment+authority}`; `assignment-missing-scope-reject={REJECTED,NO_GO,unchanged,no_assignment_effect,assignment+authority}`; `assignment-cross-actor-reject={REJECTED,MISMATCH,unchanged,no_assignment_effect,assignment+identity}`; `identity-valid={ACCEPTED,VALID,changed,no_authority_expansion,identity+authority}`; `identity-epoch-mismatch-reject={REJECTED,MISMATCH,unchanged,no_assignment_effect,identity+authority}` |
| A06 | `spawn-ack-valid={ACCEPTED,ACKED,changed,no_write_before_g3,ack+assignment}`; `runtime-capability-valid={ACCEPTED,CALLABLE,changed,no_effect,runtime-capability}`; `runtime-capability-stale-reject`, `runtime-capability-revoked-reject`, and `runtime-capability-cross-actor-reject` each yield `{REJECTED,NO_GO,unchanged,no_spawn_or_effect,runtime-capability}`; `lease-fence-valid={ACCEPTED,ACTIVE,changed,no_stale_write,lease+fence}` |
| A02/A06/A08 | `schema-closed-fields-reject[agent_assignment,agent_identity_receipt]={REJECTED,INVALID_SCHEMA,unchanged,no_effect,schema}`; `schema-closed-fields-reject[spawn_ack_receipt,runtime_capability_receipt,runtime_lease_receipt,fence_token_receipt,loader_confirmation_receipt,prompt_load_receipt]={REJECTED,INVALID_SCHEMA,unchanged,no_effect,schema}`; `schema-closed-fields-reject[independence_receipt]={REJECTED,INVALID_SCHEMA,unchanged,no_effect,schema}` |
| A02 | `root-approval-flag-reject={REJECTED,OPERATOR_ESCALATION,unchanged,no_root_self_acceptance,assignment+authority}`; `root-closure-flag-reject={REJECTED,OPERATOR_ESCALATION,unchanged,no_root_self_acceptance,assignment+authority}` |
| A06 | `loader-confirmation-valid={ACCEPTED,CONFIRMED,changed,no_spawn_or_write,loader-confirmation}`; `loader-confirmation-stale-reject` and `loader-confirmation-wrong-loader-reject` each yield `{REJECTED,NO_GO,unchanged,no_spawn_or_write,loader-confirmation}`; `prompt-load-valid={ACCEPTED,LOADED,changed,no_write_before_g3,prompt-load}`; `prompt-load-cross-assignment-reject`, `prompt-load-stale-reject`, and `prompt-load-candidate-mismatch-reject` each yield `{REJECTED,NO_GO,unchanged,no_write_or_active,prompt-load}` |

| Phase | Entry gate / owner | Exit proof and rollback | Blockers |
| --- | --- | --- | --- |
| 0 | Phase-0 inputs only under `CODEX-25`; architecture owner | acceptance receipt; no mutation | three successor PASS reviews, provenance, digest-bound `CODEX-24` to `CODEX-25` handoff, operator |
| 1 | valid current, non-revoked, scope-sufficient phase_implementation_authorization_receipt for that phase binding current D12/D14 disposition/contract digests; Phase-0 output, D01/D08/D11; core owner | A03/A04 and owned ADR/rollback | missing/currentness-invalid D12/D14 dispositions; invalid phase authorization |
| 2 | valid current, non-revoked, scope-sufficient phase_implementation_authorization_receipt for that phase; Phase-1 outputs and D02/D11 plus still-valid relied-on D01/D08; workflow owner | A01/A10 and owned rollback | D02/D11 or revoked D01/D08; invalid phase authorization |
| 3 | valid current, non-revoked, scope-sufficient phase_implementation_authorization_receipt for that phase binding current D13 disposition digest; Phase-2 outputs, D04/D10; agent owner | A02 closed schema/validator fixtures | D04, D10, or missing/currentness-invalid D13 disposition; invalid phase authorization |
| 4 | valid current, non-revoked, scope-sufficient phase_implementation_authorization_receipt for that phase; Phase-3 outputs and D03; runtime owner | A06 closed schema/validator fixtures and ACK/overlap proof | D03; invalid phase authorization |
| 5 | valid current, non-revoked, scope-sufficient phase_implementation_authorization_receipt for that phase; Phase-4 outputs and D01/D04; root | A05/A07/A08 named fixtures | D01 or D04; invalid phase authorization |
| 6 | valid current, non-revoked, scope-sufficient phase_implementation_authorization_receipt for that phase; Phase-5 outputs and D05/D09; operator | A09 and LAN rollback proof | D05, D09; invalid phase authorization |
| 7 | valid current, non-revoked, scope-sufficient phase_implementation_authorization_receipt for that phase; all mapped, non-revoked prior outputs required by D06 migration denominator, D06, and D14 retirement proof; migration owner | A11 parity/readback/rollback | D06, missing D14 retirement proof, or absent/revoked denominator output; invalid phase authorization |

Architecture-candidate acceptance requires internal-consistency checks, a
complete Source Provenance Appendix, three independent successor `PASS`
reviews, and operator acceptance. It does not authorize implementation. A
phase starts only with its prior-phase outputs and mapped, non-revoked
dispositions (including any still-relied-on prior disposition), and exits only
with its owned validators, fixtures, and receipts.

### Unresolved-decision gate tiers and resolved operational boundaries

An open D-record is not a generic implementation blocker. Its tier declares
exactly when it becomes blocking and what is permitted before then:

| Tier | Meaning | Effect before acceptance |
| --- | --- | --- |
| `T0 architecture-record` | Phase-0 design decision with an explicit owner and receipt | proposal review may proceed; no implementation authority follows from the record |
| `T1 phase-entry hard gate` | Required before the named phase can create its owned artifact or behavior | planning/fixture analysis only; affected phase cannot start |
| `T2 activation hard gate` | Required before a compiled profile, overlay, projection, dispatch, install, promotion, or retirement becomes active | inert artifacts may be inspected only; activation and runtime effect are blocked |
| `T3 migration/retirement hard gate` | Required before a reader, alias, namespace, or historical path changes canonical status | retain current readers and paths; no removal or authority transfer |

D01--D11 retain their existing mapped phase gates. D12--D14 are historical
architecture decisions only for the v0.7+ successor: no historical source
implementation authority transfers to these bytes or scope. D12 retains a
`T2` projection/activation blocker, D13 a `T2` project-local overlay blocker,
and D14 a `T3` alias/migration/reader-retirement blocker. Future implementation
requires independent acceptance and a separate digest- and scope-bound
authorization. A receipt can satisfy only its declared tier and phase scope;
it cannot imply installation, promotion, deployment, WebUI exposure, migration,
or runtime mutation.

## Resolved decisions

| ID | Decision / owner | Resolved at / boundary | Interim behavior | Required receipt |
| --- | --- | --- | --- | --- |
| D07 | Proposal provenance / architecture owner | Resolved in Phase 0 by [Source Provenance Appendix](#source-provenance-appendix); it governs only proposal-source claims, while deployment route inventory ends at the D05/Phase-6 boundary | no implementation or deployment authority; WebUI remains unexposed | immutable locator, path inventory, license/claim-verdict row, document digest, and Phase-0 successor-review receipt |
| D12 | Skill Catalog Authority and Projection / architecture owner | Historical ADR lineage only; v0.7+ source implementation, runtime/install/promotion, and projection activation require independent acceptance plus a valid canonical `phase_implementation_authorization_receipt` binding the applicable current D12 disposition/contract digest | preserve existing readers; do not implement or activate successor contracts | ADR, source/projection mapping, stale/divergent-projection negative fixture, and valid canonical `phase_implementation_authorization_receipt` binding the applicable current disposition/contract digest |
| D13 | project-local `.accelerate` overlay / agent owner | Historical ADR lineage only; v0.7+ implementation and active overlay semantics require independent acceptance plus a valid canonical `phase_implementation_authorization_receipt` binding the applicable current D13 disposition/contract digest | preserve current local-workspace behavior; do not implement or activate successor overlay semantics | ADR, precedence/readback receipt, widening/conflict negative fixture, and valid canonical `phase_implementation_authorization_receipt` binding the applicable current disposition/contract digest |
| D14 | namespace, collision, alias, and retirement lifecycle / architecture and migration owners | Historical ADR lineage only; v0.7+ implementation, migration, and retirement require independent acceptance plus a valid canonical `phase_implementation_authorization_receipt` binding the applicable current D14 disposition/contract digest | retain names/readers; do not implement, migrate, or retire successor contracts | ADR, collision negative fixture, dependency denominator, retirement/readback, and valid canonical `phase_implementation_authorization_receipt` binding the applicable current disposition/contract digest |

## Open decisions for the next analysis

| ID | Decision, owner | Affected phase(s) | Allowed interim behavior | Evidence / disposition receipt |
| --- | --- | --- | --- | --- |
| D01 | durable store, CAS, retention, backup; core owner | 1,5 | planning only | ADR plus restore/CAS fixture digest |
| D02 | binding backend/error/idempotency taxonomy; workflow owner | 2 | local projection only; no required lifecycle advance | adapter decision and readback fixture |
| D03 | workspace and runtime isolation capability; runtime owner | 4 | no physical dispatch | overlap/cleanup capability receipt |
| D04 | high-stakes classifier, quorum, signer/revocation; operator | 3,5 | classify as high-stakes and block ambiguity | signed policy and quorum fixture |
| D05 | LAN proxy/auth transport/CSRF applicability/root/WS topology and frozen identity/IP rate+burst, request/WS payload-message-idle, validation concurrency/queue/timeout/kill, canonical-root/symlink parameters; operator | 6 | no WebUI exposure | topology approval, auth/CSRF parameter digest, and negative-canary authority |
| D06 | migration/parity artifacts and readers; migration owner | 7 | retain current readers | source-target parity receipt |
| D08 | OpenSpec delivery form; architecture owner | 1 | fixture-only isolation | ADR and provenance receipt |
| D09 | WebUI compatibility/fork/panels; operator | 6 | generated read-only artifact copy | compatibility/security decision receipt |
| D10 | initial APAF profiles versus overlays; agent owner | 3 | no profile promotion | registry mapping receipt |
| D11 | artifact location; architecture owner | 1,2 | test root only | location policy and cleanup receipt |

## Recommendation

Implementation remains blocked. Independent acceptance of this v0.7.25
candidate is necessary but insufficient: every future implementation also needs
a valid canonical `phase_implementation_authorization_receipt`. Thereafter each authorized
phase is separately gated by its mapped decisions and owned future contracts;
no acceptance or historical record alone authorizes an effect.
