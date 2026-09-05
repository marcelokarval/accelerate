# Assignment Ontology

Machine authority is
[`assets/schemas/assignment-ontology.schema.json`](../../assets/schemas/assignment-ontology.schema.json).
Validate a receipt with:

```bash
python3 scripts/validate-assignment-ontology.py receipt.json
```

This is a closed, static vocabulary. It does not install profiles, dispatch
work, or claim that a runtime enforces process, tool, credential, filesystem,
or isolation boundaries.

## Roles and modes

`authority_role`, `work_role`, and `review_mode` are orthogonal. `work_role`
names work performed, not a job title; authority and review posture do not
silently turn into a physical profile.

- Tester is the human-facing name for `authority_role=verifier` plus
  `work_role=verification`. It produces evidence and has neither approval nor
  closure authority. Its typed `verification_mode` is `standard` or
  `adversarial`; it does not borrow `review_mode`. Adversarial verification or
  review requires nonempty closed `proof.negative_evidence`, not generic proof
  alone.
- A reviewer evaluates a declared target. Adversarial posture is a
  `review_mode`,
  not a separate physical agent profile.
- `QA` is the discipline and set of proof lanes defined in
  [`qa-proof-stack.md`](../runtime-packets/qa-proof-stack.md), not a physical
  identity. One small physical profile may perform a Tester or Reviewer
  assignment when its bounded evidence and role are explicit.

Only `authority_role=root` may have approval or closure authority.
`write_mode` is closed: reviewers are `read-only`; verifiers are `read-only`
or `test-only`; executors are `read-only` or `bounded-write`; roots are
`root-only`.

Independence is an evidence property, not a label: an independent review must
name a candidate whose `runtime_instance.agent_id` and
`runtime_instance.call_id` both differ from the reviewer, carry an
`isolation_reference`, and bind the exact candidate and governing spec through
closed `{locator, sha256}` binding objects.

Every reviewer receipt is independent: `review.independent=true`, distinct
candidate `assignment_id` and runtime IDs, isolation evidence, candidate/spec
bindings, and exact equality between `receipt.target` and `review.target` are
mandatory. Other authority roles carry null review fields and
`independent=false`.

## Target specialization

Every assignment states `logical_profile`, `logical_agent`, and a concrete
`runtime_instance` (`agent_id` and `call_id`), one or more closed `surfaces`:
`backend`, `frontend`, `integrations`, `data`, `runtime`, or `governance`.
`domain_path` is a hierarchical list, for example
`["financial", "gateway", "refund"]`. It specializes the assignment without
creating a profile per domain or per surface.

`proof_lanes` records the applicable QA discipline. Multi-surface work crosses
a seam and must include at least one `seam_proof` reference. A reviewer must
cover every target surface and the exact target domain path; partial coverage
cannot represent complete review.

Each selected surface has an allow-list proof minimum: backend/data need backend
QA, contract, or runtime proof; frontend needs frontend QA or browser truth;
integrations need contract, runtime, or seam proof; runtime needs runtime proof
or browser truth; governance needs contract or forensic-closure proof.

The small fixed physical Codex profile set remains the topology authority.
This ontology only makes each assignment's role, target, proof, and review
boundaries explicit.
