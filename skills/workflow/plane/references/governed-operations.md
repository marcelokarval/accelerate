# Governed operations

## Read route

1. Use `plane_catalog` for unfamiliar capabilities. Its `query` is a literal
   substring filter; prefer a distinctive word or filter by method/surface.
2. Resolve an explicit `workspace_slug`. It is not the workspace UUID. Without
   it, limit work to account-level reads and report the missing context.
3. Discover projects, work items, states, members, labels, modules, cycles, or
   comments with `plane_read_action` or the relevant read shortcut.
4. Record only the evidence needed for the user request. Redact sensitive
   provider fields from the report.

## Mutation route

Use this exact sequence for one write. A multi-item wave is a separate bounded
plan: freeze every target/payload/idempotency key and prove each readback.

1. Read the target and all referenced provider entities. Freeze the existing
   values that must be preserved.
2. Build the minimum payload. Canonical work-item fields are `assignees` and
   `labels`; do not substitute undocumented aliases because a descriptor happens
   to render them.
3. Call `plane_action_descriptor` for the exact registered operation. It
   confirms operation/path/payload shape, not authorization or provider effect.
   For `issue__add_issue`, also validate the separate issue-creation readiness
   document and bind its SHA-256 fingerprint in the authorization receipt. For
   every mutation, copy the descriptor's
   `authorization_receipt_template.payload_fingerprint` exactly; fields named
   `payload_hash` or `payload_sha256` are not accepted substitutes.
4. Run the matching semantic gate: title normalization/validation, lifecycle
   artifact validation, or lifecycle-comment rendering.
5. Assemble the authorization receipt for exactly that operation and target:
   action, HTTP method, approved live mutation, one-operation/one-target scope,
   exact path parameters, payload SHA-256, workspace/project/work-item context,
   `attempts=1`, and a unique 16–200 character idempotency key.
6. Call `plane_mutation_action` for a registered create/update/transition or
   `plane_add_lifecycle_comment` for one append-only governed comment. Set
   `approved_live_mutation=true` only when the user request or current governed
   lifecycle explicitly authorizes this exact write.
7. Require the mutation receipt. For a normal mutation it must identify the
   provider item and report `mutation_applied=true` and
   `readback_verified=true`. For lifecycle comments require its comment ID and
   `readback_verified=true`.
8. Independently GET the work item; for comments also GET/list the exact
   comment when the surface provides it. Compare the requested field, frozen
   preservation set, item/comment IDs, state, and canonical `web_url`.

## Authorization and retries

- A clear imperative such as “crie a issue”, “registre”, “mova para Done”, or
  “encerre se não houver erros” authorizes the minimum matching bounded write.
  Do not impose a Telegram-only origin restriction.
- Ask before an action that changes the intended target, owner, scope,
  acceptance, or has destructive/bulk/high-impact consequences.
- Never retry a write with a new idempotency key after an ambiguous response.
  First GET and reconcile the original target/key. Reuse of a key for a
  different payload fails closed.
- A capability that is descriptor-only remains a documented blocker. Do not
  use direct HTTP to obtain a mutation outside the governed MCP.

## Provider incidents and schema drift

- Separate MCP availability, descriptor validation, mutation receipt, and
  provider readback in the diagnosis.
- After an MCP/tool change, restart/reopen the Codex runtime and inspect the
  injected tool inventory. A persisted configuration or a healthy service does
  not prove the current session can call the action.
- Do not report a generic provider acknowledgement as exact field persistence;
  perform the GET comparison yourself.
