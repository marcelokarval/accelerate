# Dense Dispatch and Caveman Protocol

## Status, scope, and language

This is an architecture proposal, not an implementation, schema, validator,
skill, registry entry, runtime export, or runtime qualification. It defines two
candidate notations for reducing avoidable handoff text without changing
Accelerate authority, runtime behavior, or gateway settings. Repository sources
remain authoritative. The proposal is deliberately non-operational until the
roadmap's qualification gates are met.

In this document, **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY**
are normative for a future implementation. A notation is a versioned,
non-authorizing projection: it can reference, select, expand, or render existing
artifacts, but it cannot replace their schemas, receipts, validators, lifecycle,
or authority. It does not make an unknown value null, empty, `none`, `false`, or
zero unless the target's closed contract explicitly permits that representation.

The source hierarchy remains the repository-first control plane described in
[Accelerate Control Plane](./accelerate-control-plane.md), the semantic
delegation core in [Runtime-neutral Delegation](../../core/delegation/runtime-neutral-delegation.md),
and the runtime adapter boundary in [Runtime Adapter Contract](../../adapters/runtime/adapter-contract.md).

## Problem: token bloat in Master -> Worker -> Subagent systems

Multi-level delegation often repeats the same policy, task context, scope,
assignment intent, proof requirements, and return template at every hop. This
creates **Token Bloat**: repeated boilerplate consumes context without adding
new authority or evidence. It causes five related failures:

1. Repeated boilerplate obscures the task-specific delta and increases copy
   errors.
2. Semantic dilution turns precise terms into paraphrases, losing distinctions
   such as quality class versus model binding or verifier versus reviewer.
3. Context pressure forces truncation or compression of constraints, evidence,
   and prohibited authority before task-relevant content.
4. Stale copies cause a child to act on an older policy, issue binding, or proof
   requirement than the root froze.
5. Verification cost rises because a reviewer must compare many near-identical
   handoffs rather than verify one immutable base plus a small assignment delta.

The goal is not minimum text. The goal is one verifiable base, explicit bounded
delta, and a terse return that preserves the source packet's meaning. Compression
that requires an LLM to infer omitted meaning is semantic loss, not dispatch
efficiency.

## Decision

Two related formats are proposed:

- **Dense-Dispatch Skeleton YAML v1** is a strict, machine-expandable input
  projection. It selects immutable, hash-verified repository sources and states
  the assignment delta explicitly.
- **Caveman Return v1** is a telegraphic, human-readable output projection of
  an existing child-owned Agent Return Packet. It shortens labels, not values or
  root decisions.

Both formats are non-authorizing. The canonical schema, receipt, packet, and
runtime adapter remain the authority. Dense input cannot dispatch by itself;
Caveman output cannot accept work, change lifecycle, recommend promotion, or
close a run. Existing closed schemas MUST NOT gain fields merely to host either
projection.

## Terms that MUST remain distinct

| Term | Meaning | Must not be treated as |
| --- | --- | --- |
| Quality class | Portable work-quality need, such as `implementation-medium`. | A requested or effective runtime model. |
| Requested binding | Root-selected runtime model, reasoning effort, and fork value. | Evidence that the runtime honored it. |
| Effective binding | Adapter/runtime readback of the actual binding. | A substitute for requested intent or quality class. |
| Lifecycle state | Canonical run or assignment progression. | Assignment outcome, recommendation, or root disposition. |
| Outcome | Canonical assignment result: `pending`, `succeeded`, `failed`, `blocked`, or `cancelled`. | Lifecycle, recommendation, or acceptance. |
| Recommendation | Child suggestion: `done`, `partial`, `follow-up`, or `blocked`. | Root closure; `recommendation: done` is not closure. |
| Orchestrator handling | Root-only disposition of a return. | A child-owned return category or lifecycle transition. |
| Verifier | Evidence-producing Tester role. It has no approval or closure authority. | Reviewer. |
| Reviewer | Declared-target evaluator with independence requirements. | Verifier or root. |

These distinctions follow [Assignment Ontology](../../core/delegation/assignment-ontology.md),
[Agent Return Packet](../../core/runtime-packets/agent-return-packet.md), and
[Runtime-neutral Delegation](../../core/delegation/runtime-neutral-delegation.md).

## Dense-Dispatch Skeleton YAML v1

### Contract

Dense-Dispatch is a JSON-compatible YAML document with
`projection_version: dense-dispatch/v1`. It is an input projection to the
proposed `runtime-neutral-assignment-projection/v1` target, not a replacement
assignment schema or dispatch receipt. V1 expansion yields one selected
runtime-neutral assignment plus required projection-envelope metadata: identity,
verified base references, requested binding, targets, constraints, forbidden
paths, and evidence gates. It is then validated against the existing selected
assignment definition and the Dense projection grammar. The target is proposed
notation, not an existing schema or canonical dispatch receipt. The root creates
it after hardening and before runtime-specific dispatch only when a future
qualified codec can prove exact expansion. In a dispatchable skeleton, every
envelope task-semantic value is an assertion against the hash-pinned root-owned
assignment/binding decision; the compact document cannot create or alter it.

The root owns classification, hardening, task graph, route, staffing, assignment
intent, integration, review-of-review, promotion, workflow mutation, and closure.
The projection MAY make a child packet shorter; it MUST NOT give a child nested
delegation, workflow mutation, issue closure, or root authority.

### Required skeleton shape

The root MUST supply all fields below. In v1, `delta` is a compact,
non-authorizing visibility/assertion subset of the selected assignment. Every
present value MUST exactly equal its corresponding selected-assignment field; it
is not a replacement or patch language. Writable root-issued deltas are deferred
to a future version and would require a separate hash-pinned root-owned
assignment artifact.

```yaml
projection_version: dense-dispatch/v1
example_kind: doctrine-conformance-expansion-only
identity:
  run_id: semantic-core-positive
  assignment_id: implement
  named_expansion_target: runtime-neutral-assignment-projection/v1
verified_base:
  authority_refs:
    - ref: core/hardening/prompt-hardening.md
      sha256: e5b401aad4a056d242708dcdcf0bd11f651ee6c911557bcd734fd8b15700b9ba
    - ref: core/delegation/runtime-neutral-delegation.schema.json
      sha256: 54c7bb702ce7f79eddd71d404aec18e036fa09909cd5aa5986f4072930694e4a
    - ref: core/runtime-packets/agent-return-packet.md
      sha256: fa24f47d5b924362acdf953d47308f28217cfdbf5251675cb8f184bc5f18ffa1
  named_source:
    ref: tests/fixtures/runtime-delegation-semantics/valid-run.json
    sha256: 9df19ace6a3f0cf5479643295c10df0d8a9c85a49c00eb21bcc54d21a1675131
    assignment_id: implement
  binding_policy:
    ref: adapters/runtime/codex-collaboration/role-policy.json
    sha256: 69f8912fef4591493ac1b71b54fee59931bf6b35bf3f43d3542bca0e7e883f22
    profile: implementation
requested:
  model: gpt-5.6-terra
  reasoning_effort: medium
  fork_turns: none
targets:
  surfaces: [governance]
  paths: [core/]
constraints:
  - ASCII only
  - preserve root-owned closure
forbidden_paths:
  - core/runtime-packets/delegation-dispatch-receipt.schema.json
  - adapters/runtime/openchamber/
evidence_gates:
  - focused-document-review
  - source-link-check
delta:
  objective: implement bounded change
  write_scopes: [core/]
  proof_requirement: focused test
```

The example hashes are full SHA-256 digests of the current named repository
files. A future encoder MUST recalculate and verify them from exact repository
bytes; any later source change makes this example stale and non-expandable until
its hashes are deliberately updated.

This is a doctrine-conformance/expansion example, not dispatch authorization;
therefore it intentionally omits the production `run_artifacts` block described
below. The selector is a closed v1 `assignment_id`. It MUST match exactly one object in
the verified run's `assignments` array; zero or multiple matches fail closed.
Every assignment omission in the example resolves from that selected immutable
assignment: role, dependencies, parent assignment, read scopes, assignment identity,
quality class, lifecycle, and outcome are not inferred. Fan-in, review, and root
ownership are instead separately preserved verified whole-run context from the
same named source. No field may be omitted merely because it seems conventional.
The return contract is the hash-pinned
`core/runtime-packets/agent-return-packet.md` authority reference already
present in `authority_refs`; it is not an assignment delta field.

The pinned `binding_policy` is one adapter-specific source selected by the root;
the projection grammar remains runtime-neutral. For a dispatchable skeleton,
`requested.model`, `requested.reasoning_effort`, and `requested.fork_turns` MUST
exactly match both an explicit root selection in the hash-pinned binding-decision
artifact and the selected policy profile plus its policy-level fork rule. Policy
defaults alone never authorize a binding. The adapter still owns effective
binding readback and must not infer it from `requested` or the policy.

### Production run artifacts

A dispatchable skeleton MUST include `run_artifacts`, with a repository-relative
locator and full SHA-256 for each root-owned artifact: hardening, the Stage B
semantic implication receipt when applicable, spec, task graph, and
assignment/binding decision. Missing, unpinned, stale, or inapplicable-as-claimed
artifacts block dispatch. The assignment/binding decision MUST bind selected
assignment identity, requested binding, targets, constraints, forbidden paths,
and evidence gates; every corresponding projection value MUST match it exactly.
This proposal intentionally gives no current concrete `run_artifacts` paths
because the example is not a dispatch authorization.

### `delta` allowlist

For v1, `delta` MUST contain only these keys:

```text
objective
read_scopes
write_scopes
proof_requirement
```

Each present key is an equality assertion against the named source's uniquely
selected assignment; any mismatch fails closed. An absent allowlisted key means
the source value is not repeated. Arrays compare as whole arrays in order; they
never append, merge, deduplicate, or inherit item-by-item. A future version may
add an allowlisted key only with a version bump, repository schema/doctrine
review, and qualification evidence. `delta` MUST NOT set model, effort, fork,
quality class, lifecycle, outcome, root ownership, reviewer identity, issue
lifecycle, exception, adapter primitive, or closure state.

### Deterministic expansion and fail-closed rules

An implementation MUST perform the following exact procedure before dispatch:

1. Parse only JSON-compatible YAML. Reject duplicate keys and unknown keys at
   every projection boundary.
2. Reject YAML tags, anchors, aliases, merge keys, interpolation, environment
   expansion, command substitution, network includes, and filesystem paths
   outside the repository allowlist.
3. Resolve each `ref` as repository-relative, normalized, contained, allowlisted,
   and present. Reject absolute paths, `..` escapes, symlink escape, unpinned
   sources, partial hashes, and any digest other than a matching 64-lowercase-
   hexadecimal SHA-256.
4. Verify every `authority_refs` hash, the `binding_policy` full hash, and the
   `named_source` full hash before
   reading omitted values. Parse the named source as a whole runtime-neutral run,
   then select exactly one assignment whose `assignment_id` equals the closed v1
   selector. Unknown source, absent source, zero matches, multiple matches, or a
   mismatch is a hard failure, not an empty value.
5. Verify that requested model, effort, and fork exactly match the explicit
   root selection in the hash-pinned binding-decision artifact and the selected
   binding-policy profile plus its policy-level fork rule. Reject missing
   production `run_artifacts`, absent root selection, policy/profile mismatch,
   or any attempt to authorize a requested binding from a policy default alone.
   Verify every envelope task-semantic value against that same root-owned
   decision artifact.
6. Select `named_expansion_target` from a closed target vocabulary. Reject an
   unknown target, an unknown `delta` key, or a `delta` field that has no exact
   selected-assignment field. For every present `delta` value, require exact
   equality with the selected assignment; a mismatch fails closed.
7. Create the proposed v1 output from the uniquely selected assignment and the
   required projection-envelope metadata. Preserve the verified whole-run
   context separately; do not copy or ambiguously overwrite the whole source
   document. Copy `delta` only as verified visibility, never as an assignment
   replacement. Apply no implicit defaults and no LLM reconstruction, paraphrase,
   completion, coercion, fallback, or repair.
8. Validate the selected assignment against its existing runtime-neutral
   assignment definition and validate the envelope against the Dense projection
   grammar. The codec must preserve closed enum values exactly; it MUST NOT
   represent the output as a whole canonical dispatch receipt.
9. Serialize the expanded artifact as UTF-8 RFC 8785 JSON Canonicalization
   Scheme after YAML is parsed to I-JSON-compatible values. Reject floats and
   non-finite values, preserve exact strings without Unicode normalization, hash
   those canonical bytes with SHA-256, and emit that final expanded-artifact
   hash next to the expansion result. The final hash binds the real dispatch
   input, not the skeleton alone.
10. Fail closed before dispatch if any parse, path, hash, target, expansion,
   schema, or final-hash check fails. The root records the blocker in the
   existing appropriate receipt; the projection does not invent a new exception.

Unknown means unrepresentable in this projection unless its target explicitly
allows a particular representation. It MUST NOT silently become `null`, `[]`,
`none`, `false`, or `0`.

### Invalid input example

The following is invalid and MUST fail before dispatch. It omits the required
hash for an authority reference, omits required production `run_artifacts`, uses
an unknown `delta` key and mismatched objective assertion, and tries to rely on
an unstated default for `fork_turns`:

```yaml
projection_version: dense-dispatch/v1
identity: {run_id: acc-bad, assignment_id: bad-1, named_expansion_target: runtime-neutral-assignment-projection/v1}
verified_base:
  authority_refs: [{ref: core/hardening/prompt-hardening.md}]
  named_source: {ref: planning/packets/base.json, sha256: 0ad3c644ae8aac28b3e2174e2f4d4c8267f380fd5c91c03d88a8e796c2671592, assignment_id: bad-1}
requested: {model: gpt-5.6-terra, reasoning_effort: medium}
targets: {surfaces: [governance], paths: [docs/architecture/x.md]}
constraints: []
forbidden_paths: []
evidence_gates: [focused-document-review]
delta: {close_issue: true, objective: invent new authority}
```

## Caveman Return v1

### Contract

Caveman is a telegraphic display projection for a completed child return. It
MUST preserve every child-owned category from the canonical Agent Return Packet
and leave the separate root-only `orchestrator handling` visibly separate. It
does not replace the full packet, its evidence roots, or its canonical values.
The root stores and evaluates the canonical packet; the concise rendering is for
fast human scan and may be regenerated from that packet.

The canonical categories and enum values remain:

```text
requested-vs-implemented: met|partial|missed|blocked + notes
recommendation: done|partial|follow-up|blocked
final closure authority statement: root-owned|missing
orchestrator handling: accepted-for-integration|needs-review|needs-correction|conflicts-with-other-return|rejected-out-of-scope|blocked
```

### Valid Caveman example

```text
Caveman Return v1
role: executor / documentation
slice: executor-doc-1
scope: docs/architecture/dense-dispatch-and-caveman-protocol.md
touch: docs/architecture/dense-dispatch-and-caveman-protocol.md; write: docs/architecture/dense-dispatch-and-caveman-protocol.md
seen: hardening; delegation schema; return packet; W1 proposal
proof: link + ASCII + required-term + line/scope checks
ask-vs-did: met - proposal only
self: no contradictions found
forensic: no hidden authority or runtime claim
defects: none
residual: non-operational until codec qualification
recommend: done
closure: root-owned

orchestrator handling: needs-review
```

The labels are terse, but each maps one-to-one to the child-owned Agent Return
Packet categories: role, slice, scope, actual scope, write scope, files/surfaces,
evidence roots, validations/proof, requested-vs-implemented, self-review,
self-forensic review, defects/disposition suggestion, residual risks,
recommendation, and final closure authority statement. `orchestrator handling`
is intentionally outside that child-owned block. A child may report facts that
inform it; only the root sets or records the root disposition. In particular,
`recommend: done` only says the child recommends completion of its slice.

## Accelerate integration

Dense-Dispatch and Caveman fit after the current hardening and assignment work;
they do not create a new workflow. Prompt hardening still exposes the exact
existing fields from [Prompt Hardening](../../core/hardening/prompt-hardening.md):
`goal`, `success criteria`, `constraints`, `output`, `stop rules`, `explicit
non-goals`, `risks or ambiguity resolved`, and `proof required`. The skeleton
may hash-reference the hardened artifact and a named base that contains these
fields. It MUST NOT add fields to a closed hardening, delegation, dispatch, or
return schema.

Existing receipts retain their authority and vocabulary:

- The runtime-neutral semantic core records run, policy, state, budget,
  assignments, exceptions, fan-in, review, root ownership, and promotion.
- The current Codex-specific dispatch receipt retains its fixed primitive,
  model enum, artifact hashes, route, budget, assignments, exception enum, and
  root write lock.
- The Agent Return Packet retains the child return categories and root-only
  disposition.

Dense is therefore a pre-dispatch projection of an already valid assignment
source, not a transport-independent receipt successor. A future neutral receipt
successor proposed for runtime adapters remains an independent W1 design and
MUST NOT be preempted, named, shaped, or made authoritative here.

## OpenChamber W1 non-collision matrix

The OpenChamber runtime adapter proposal remains unimplemented and unqualified.
Dense/Caveman neither call it nor claim it is callable. W1 owns runtime
primitives and the corresponding adapter receipts; this proposal reserves no
competing field, lifecycle, or receipt authority.

| Concern | W1 / OpenChamber owner | Dense/Caveman position |
| --- | --- | --- |
| Runtime primitives | Adapter maps concrete runtime primitives. | No primitive names or calls; Dense only references an already approved target. |
| Sessions | Adapter creates, observes, identifies, and contains sessions. | No session ID generation, reuse, tracking, or terminal inference. |
| Worktrees and branches | Adapter owns isolated worktree/branch identity and collision handling. | `targets.paths` is logical scope, never a worktree or branch instruction. |
| Project/directory resolution | Adapter proves project identity and contained canonical directory. | Refs resolve only repository source files; no runtime project selection. |
| Requested/effective readback | Adapter records and compares requested/effective model and quality bindings. | Dense carries explicit requested model/effort/fork only; no effective claim. |
| Tracking and timeouts | Adapter performs active tracking, bounded waits, and timeout classification. | No polling, wait policy, or completion claim. |
| Runtime failures | Adapter records precise runtime state and failure evidence. | Parse/hash/expansion failures block before dispatch; they are not runtime failures. |
| Containment and cleanup | Adapter proves close, retain, or equivalent containment. | No cleanup action or success implication. |
| Adapter receipts | W1 defines adapter-specific receipt extensions and may propose a neutral successor. | Projection metadata is not an adapter receipt and cannot preempt that successor. |

This follows the explicit non-operational boundary in
[OpenChamber Runtime Adapter Proposal](./openchamber-runtime-adapter-proposal.md).

## OmniRoute non-collision

This document's word "Caveman" is not OmniRoute Caveman/RTK compression. The
notation is repository-local projection and rendering doctrine; it does not
change any OmniRoute gateway setting, header, engine toggle, CCR policy,
`cavemanConfig`, `rtkConfig`, cache/memory behavior, model request, or
qualification result. It supplies no evidence that any gateway compression is
safe.

Any actual OmniRoute compression experiment remains governed by
[Compression Safety](../../skills/operations/omnirouter-operations/references/compression-safety.md),
including frozen prompts, retrieval restrictions, non-secret receipts, semantic
rubrics, and explicit gateway readback. Dense/Caveman must not be cited as a
compression qualification or transport-control override.

### Transport-specific anti-example

The following is prohibited. It treats Dense as a gateway payload compressor and
then assumes a successful HTTP response proves a complete dispatch:

```text
POST /v1/responses
X-OmniRoute-Compression: engine:caveman
body: <Dense-Dispatch Skeleton YAML>
claim: HTTP 200 means the child received all omitted policy and is done
```

It is invalid because the transport may not retrieve the named source, a gateway
engine cannot verify repository hashes or expand an assignment packet, and HTTP
200 is neither runtime readback nor task completion. No transport may infer
missing content or bypass pre-dispatch expansion validation.

## Failure, security, privacy, and provenance

### Failure posture

Projection failures are operationally important but are not dispatch-degradation
exceptions. They include malformed JSON-compatible YAML, duplicate or unknown
keys, disallowed YAML features, unknown target, path escape, hash mismatch,
missing immutable source, unsupported delta, failed target validation, and final
expanded-hash mismatch. Each MUST fail closed before dispatch and preserve the
last confirmed state in the applicable existing artifact.

There is no automatic retry, fallback, LLM repair, source substitution, array
merge, model substitution, dispatch, session fork, workflow write, or closure
action. An operator must explicitly authorize any later attempt and keep the
prior failed evidence intact.

These failures remain distinct from the only three valid dispatch degradation
exceptions in [Post-Spec Delegation Dispatch Gate](../../core/control-plane/post-spec-delegation-dispatch-gate.md):
`explicit_user_opt_out`, `collaboration_unavailable`, and
`spawn_failed_operator_authorized`. A hash mismatch, parser failure, timeout,
model mismatch, child failure, readback failure, dirty worktree, review failure,
or cleanup failure does not independently authorize degradation.

### Security and provenance

- References MUST be contained repository-relative allowlisted paths and pinned
  with full SHA-256 digests. The expanded artifact hash is mandatory provenance
  for the actual input.
- Projections MUST carry only minimum necessary task context. Credentials,
  tokens, cookies, private keys, private provider payloads, and raw sensitive
  transcripts are prohibited.
- Hashes and bounded locators are preferred durable evidence. Export and storage
  follow [Privacy Classification](../../core/control-plane/privacy-classification.md):
  unknown classification fails closed, and `secret-prohibited` never exports.
- Children receive immutable workflow context only. They MUST NOT mutate a
  workflow backend, create or close work items, change lifecycle state, post
  comments, or claim root closure. The root alone owns integration,
  review-of-review, external mutation, promotion, and closure.

## Qualification and repo-first micro-skill roadmap

The candidate repository path is
`skills/workflow/dense-dispatch-caveman/`. It is not created by this proposal.
The future skill must be repo-owned, registered, and tested before any optional
export. User-home directories, including `~/.agents/skills/`, are never source
authority; see [Skill Sync Topology](../../core/control-plane/skill-sync-topology.md)
and [Skills](../../skills/README.md).

1. Write RED pressure scenarios: repeated boilerplate, stale base, ambiguous
   omission, duplicate key, unknown key, hash mismatch, path escape, forbidden
   YAML feature, unknown target, missing production run artifact, binding-policy
   or root-selection mismatch, delta assertion mismatch, and false closure from
   `recommendation: done`.
2. Implement the smallest codec only after RED cases fail correctly. Prove
   byte-stable codec round-trip from canonical source to Dense projection to
   canonical expanded artifact, including the final expanded-artifact hash.
3. Add negative fixtures for every fail-closed rule and canonical enum
   preservation. Include valid Dense and Caveman fixtures plus the invalid and
   transport anti-examples as doctrine checks. Add canonical-byte fixtures for
   key ordering, float/non-finite numeric rejection, exact Unicode/string
   handling without normalization, and semantically duplicate references.
4. Run registry/doctrine tests proving no closed schema gains keys, no root
   authority is delegated, W1 remains non-colliding, and OmniRoute qualification
   semantics remain unchanged.
5. Produce generated export proof, source provenance, drift detection, and
   rollback/cleanup proof from the repository source. Generated export is a
   deployment artifact, not authority.
6. Only then may maintainers consider an optional `~/.agents/skills/`
   projection. That copy must remain generated, non-authoritative, removable on
   drift, and unable to alter the repository's governing contract.

Qualification requires exact expansion, deterministic failure behavior, full
provenance, evidence that no sensitive input is persisted, and review that the
notation reduces duplication without changing meaning. Passing static fixtures
does not qualify any runtime, transport, OpenChamber W1 adapter, gateway
compression path, workflow mutation, or closure path.
