# CODEX-26 Phase 1 R0 + C13 Reentry SDD

## State and authority

- SDD mode: `critical` (governance, authority, trusted validation, and an
  existing blocked implementation).
- State: `implementing`, authorized by the current operator message and the
  C13 authorization packet.
- Governing proposal: the immutable v0.7.25 proposal, SHA-256
  `749d829a5b5868370b05007ad71e4b4b285623db79cbefeaa47ba9a3b07e7cca`.
- Reentry predecessor: C12 rejected by independent review and root
  review-of-review; it is forensic evidence only.
- Canonical work item: CODEX-26. Plane remains lifecycle authority.

## Requirements

| ID | Requirement | Owner | Planned proof |
| --- | --- | --- | --- |
| R0-1 | Currentness must bind the CODEX-25/CODEX-26 lineage and retain CODEX-17 as historical only. | R0 lane | valid/current historical negative fixtures and current positive fixture |
| R0-2 | Local workspace must not represent the May Linear cycle as current CODEX-26 state. | R0 lane | structured local-state validation/readback |
| R0-3 | Canonical suite must explicitly exercise the offline Phase-1 regression lane; real OpenSpec remains separately opt-in. | R0 lane | root-suite invocation contract plus offline run |
| C13-1 | A04 expected five-field values and receipt-key sets must come from an independent normative artifact. | C13-core lane | old implementation RED, independent-artifact Green, mutation-negative tests |
| C13-2 | Included-input mutation must validate an eligible immutable predecessor, construct/validate a successor, preserve predecessor bytes, and bind both real candidate digests. | C13-core lane | `None`, string, arbitrary-map RED plus successor lineage Green |
| C13-3 | Omission/replacement must have explicit valid and invalid normalized outcomes, never generic semantic mismatch for a valid disposition. | C13-core lane | valid/invalid disposition RED/Green matrix |
| C13-4 | Candidate validation must run in isolated copies with no candidate-root cache writes. | root proof | twin-run receipt and candidate inventory/hash readback |

## Dispositions

- ADR: consolidated in the frozen proposal and the C12 rejection packet; no new
  architecture choice is made.
- Product/UI: not applicable; this is repository governance/source work.
- Test Design: separate C13 test design is required and is bound by the
  operator authorization packet.
- Agents: two bounded Terra/medium implementers, each with one file-owned
  scope; fresh read-only tester and reviewer after fan-in.
- Rollout: not applicable; source-only Phase 1.
- Rollback: remove only C13-owned files or revert C13-owned edits; preserve all
  historical receipts and unrelated dirty worktree entries.
- Observability: append candidate/freeze/review receipts under the CODEX-26
  evidence appendix; no secrets or raw provider payloads.
- Governing docs: frozen proposal bytes are not changed; a current-status index
  may be added as a successor operational artifact.

## Entry and stop rules

The root may dispatch only after the task graph and C13 authorization packet
exist. Every child must return a requested-vs-implemented report, self-review,
self-forensic review, and exact validation output. Any authority conflict, new
P0 outside this SDD, or two material C13 correction attempts blocks the run.
Root alone integrates, freezes, requests independent review, reconciles Plane,
and closes.

