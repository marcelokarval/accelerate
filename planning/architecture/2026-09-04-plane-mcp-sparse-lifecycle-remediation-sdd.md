# Plane MCP — Sparse Lifecycle Remediation SDD

## Status

- Owner: Accelerate root / governed Plane MCP remediation
- Date: 2026-09-04
- Source: `prompt-i-task-i02-plane-closure-no-go.md`
- Classification: orchestrated non-trivial work
- Route: orchestrated; one physical implementation worker followed by an
  independent review worker
- Target source: `~/.hermes/apps/mcp-servers/plane-mcp-karval/`
- Runtime promotion: explicitly separate and not authorized by this SDD

## Problem

The current provider project exposes five physical states (`Backlog`, `Todo`,
`In Progress`, `Done`, `Cancelled`). The MCP lifecycle contract demands unique
provider IDs for eleven semantic roles and also requires `REVIEW` before
`FINISH`. Consequently a legitimate `In Progress -> Done` closure cannot reach
the provider PATCH; it is rejected during local validation.

## Objective

Permit a governed, evidence-complete lifecycle for sparse Plane projects without
inventing provider states, weakening user approval, or allowing direct HTTP.

## Non-goals

- no provider state creation, deletion, or relabeling;
- no direct Plane HTTP, credentials, database edits, service restart, runtime
  promotion, commit, push, merge, deploy, or retry of CODEX-26 closure;
- no broad replacement of the existing receipt, idempotency, readback, or
  reconciliation model.

## Target design

1. Separate *semantic lifecycle phases* from *physical provider state IDs*.
2. Add a trusted, project-bound sparse role mapping with only the roles that
   the provider can materially represent; collapsed review/QA evidence is
   explicitly declared, never inferred from a duplicate ID.
3. For a sparse close, server issues one receipt that binds:
   - an append-only REVIEW evidence comment while physical state remains
     `In Progress`;
   - one non-atomic `In Progress -> Done` PATCH;
   - a terminal FINISH comment and independent readbacks for all subactions.
4. Any partial outcome stays in durable reconciliation; there is no automatic
   rollback or replay.
5. Dense projects retain their existing explicit provider-role transitions.

## Acceptance

- five-state fixture can produce a legal review-plus-finish plan;
- no untrusted/caller-supplied role map is accepted;
- missing/stale/foreign registry, drifted revision, duplicate external effect,
  invalid semantic sequence, and partial write all fail closed;
- focused unit tests and MCP integration tests pass;
- independent review accepts the frozen candidate;
- no live provider mutation or runtime restart occurs in this remediation wave.

## Task graph

| Task | Owner | Result |
| --- | --- | --- |
| TASK-R01 | root | this SDD, scope freeze, target provenance and task graph |
| TASK-R02 | root | Plane work-item bootstrap/readback for remediation, if the governed creation path is callable |
| TASK-R03 | physical implementer | sparse lifecycle mapping/receipt/comment flow and focused tests inside target allowlist |
| TASK-R04 | root | freeze candidate and run focused proof |
| TASK-R05 | independent reviewer | inspect frozen diff, negative proof and receipt safety |
| TASK-R06 | root | correction loop (max three material generations), review-of-review and stop before promotion |

## Allowlist for TASK-R03

- `src/plane_mcp_karval/lifecycle_transition_contract.py`
- `src/plane_mcp_karval/server.py`
- `src/plane_mcp_karval/plane_work_item_contract.py` only if semantic
  separation requires it
- `src/plane_mcp_karval/assets/plane-state-role-registry.v2.json` or a new,
  directly tested sparse-profile asset
- focused tests under `tests/test_plane_lifecycle_contract_v2.py` and
  `tests/test_plane_mcp_karval.py`

## Stop conditions

- any provider mutation, state catalog mutation, restart, promotion, or source
  control action;
- touching unrelated dirty files;
- accepting aliases without trusted project/catalog binding;
- suppressing REVIEW evidence merely to permit FINISH;
- any ambiguous mutation receipt.
