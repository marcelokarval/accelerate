# Parity map

This map preserves Plane operating behavior from the Hermes skill family while
binding execution to the Codex MCP rather than Hermes connectors.

| Hermes capability | Codex equivalent | Proof requirement |
|---|---|---|
| Action registry and API discovery | `plane_catalog` | Exact operation is present in the current tool inventory. |
| Account/project/work-item/state/member reads | `plane_read_action` and read shortcuts | Provider response identifies the requested entity. |
| Generic create/update preflight | `plane_action_descriptor` | Descriptor is labeled proposal only. |
| Bounded governed create/update/transition | `plane_mutation_action` | Exact authorization receipt, one attempt, idempotency, mutation receipt, fresh GET. |
| Append-only governed lifecycle comment | `plane_render_lifecycle_comment` then `plane_add_lifecycle_comment` | Render passes; returned comment ID and provider readback verify. |
| Readiness/lifecycle validation | `plane_validate_work_item_contract` | Validation precedes claimed lifecycle state. |
| Title normalization and icon contract | `plane_normalize_title`, `plane_validate_title_contract` | Normalized frozen title equals provider readback. |
| Completion/readback | `get_work_item` plus comment read/list action | FINISH and final Done state are both freshly provider-read. |
| Provider/tool drift diagnosis | `plane_catalog`, descriptor, mutation receipt, provider GET | Report each layer separately. |

Hermes-only connector calls, local token handling, provider plugins, and direct
HTTP are deliberately excluded: the governed Codex MCP is the only executor.
This is a runtime substitution, not a reduction of issue lifecycle or provider
operation guarantees.
