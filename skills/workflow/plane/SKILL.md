---
name: plane
description: Governed Plane work-item operations for Codex. Use when reading, creating, hydrating, updating, commenting on, transitioning, reviewing, or closing Plane work items; when shaping issue scope, acceptance, ownership, dependencies, priority, or lifecycle evidence; and when diagnosing Plane MCP/provider behavior. Use this skill before any Plane mutation or completion claim.
---

# Plane for Codex

Operate Plane through the governed MCP available to this Codex session. This
skill is the Codex adaptation of the Hermes Plane family: it retains the
provider lifecycle, governance, and readback guarantees, but never calls
Hermes connectors, scripts, credentials, or direct HTTP.

## Runtime boundary

- Use only the injected `mcp__plane__*` tools. First prove the relevant tool is
  available; no direct HTTP, copied Hermes credentials, or fallback CLI.
- `plane_catalog` discovers capabilities; `plane_read_action` and the read
  shortcuts perform reads; `plane_action_descriptor` is preflight only.
- Governed writes use either `plane_mutation_action` or
  `plane_add_lifecycle_comment`. A descriptor or rendered comment is never a
  provider mutation.
- A missing approved adapter/tool is a hard stop for writes. Report the missing
  capability instead of bypassing governance.

## Choose the route

- Read-only inventory, issue lookup, state/member discovery, or API diagnosis:
  use the *read route* in [governed operations](references/governed-operations.md).
- New issue, substantial update, transition, review, or closure: load both
  [governed operations](references/governed-operations.md) and
  [lifecycle contract](references/lifecycle-contract.md) before acting.
- New issue creation: also load [issue creation readiness](references/issue-creation-readiness.md) and satisfy the adapter's mandatory pre-creation contract.
- A new or in-scope changed title, type/label/priority/module/cycle/date/estimate,
  hierarchy, or dependency: also load [taxonomy and title](references/taxonomy-and-title.md).

## Non-negotiable rules

1. Discover `workspace_slug`, project UUID, work-item UUID, available states,
   and any referenced member/label/module/cycle before a payload. Do not guess
   identifiers or state names.
2. Preserve proposal versus provider truth. Treat readiness, taxonomy, title,
   lifecycle, authorization, mutation, and readback as separate proofs.
3. Create only execution-ready work: objective, bounded scope/non-goals,
   testable acceptance, owner/disposition, priority rationale, dependencies,
   validation, and required metadata must be concrete or explicitly
   dispositioned. A partial create is `created-needs-rehydration`, never ready.
4. Mutate only under a clear user imperative or a valid governed lifecycle
   continuation. Bind one exact action/target/payload to an authorization
   receipt, a 16–200 character idempotency key, and `attempts=1`.
5. For every create/update/comment/transition/close: preflight with the
   matching MCP semantic gate (`plane_validate_work_item_contract`,
   `plane_render_lifecycle_comment`, `plane_normalize_title`, or
   `plane_validate_title_contract`), execute the narrow live mutation, then
   perform a fresh GET readback. Claim success only with the receipt and readback.
6. Keep lifecycle history append-only. Use complete START, PROGRESS, BLOCKED,
   REVIEW, and FINISH packets; never invent historical events to repair a late
   record or jump a substantive issue directly to Done.
7. Never put credentials, raw prompts/transcripts, chain-of-thought, tokens,
   secrets, or sensitive personal data in Plane.
8. Deletion, cancellation, archive, bulk/high-impact mutation, reassignment to
   another person, material scope change, or unresolved taxonomy/ownership is
   a stop condition requiring explicit direction.

## Verification and handoff

- For a live write, report the operation, exact target, provider ID/`web_url`,
  `mutation_applied`, `readback_verified`, and any residual. If the mutation
  API reports only provider acknowledgement, the separate GET is mandatory.
- For no-write work, say that no provider mutation occurred; do not imply it.
- For an issue completion claim, verify the FINISH comment and final work-item
  state via fresh provider reads. See [lifecycle contract](references/lifecycle-contract.md).

## References

- [governed operations](references/governed-operations.md): Codex MCP routes,
  descriptors, authorization receipts, idempotency, readback, and incident handling.
- [lifecycle contract](references/lifecycle-contract.md): readiness, comments,
  state transitions, retrospective handling, and closure proof.
- [taxonomy and title](references/taxonomy-and-title.md): semantic fields and
  exact title validation through the Plane MCP.
- [parity map](references/parity-map.md): Hermes capability-to-Codex MCP mapping
  and the intentionally excluded runtime-specific paths.
