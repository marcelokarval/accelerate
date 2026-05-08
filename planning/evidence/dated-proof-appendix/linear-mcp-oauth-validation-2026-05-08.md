# Linear OAuth MCP Validation — 2026-05-08

## Scope

RC24 validates the **host-authenticated Linear OAuth MCP lane** separately from the repo-local `LINEAR_API_KEY`/GraphQL shell fallback.

This appendix records sanitized discovery/read proof only. It does not commit Linear provider JSON, OAuth tokens, API keys, raw email addresses, private payloads, or broad private issue details.

## Lane Separation

| Lane | Current status | Boundary |
| --- | --- | --- |
| `linear-oauth-mcp` | `conditional` / host-available for this Codex/Hermes MCP host | Authenticated MCP tools can read bounded Linear workflow state for governing issues when privacy and scope gates are satisfied. This proof is host capability evidence, not portable CI/script proof. |
| `linear-api-key-graphql` | `planned` / blocked for repo-local shell fallback without `LINEAR_API_KEY` and safe fixture env | Repo-local scripts remain fail-closed until `LINEAR_API_KEY`, `ACCELERATE_LINEAR_LIVE_FIXTURE=1`, fixture team, and target status are provided outside committed state. |

## Sanitized OAuth MCP Discovery Proof

Observed through Linear MCP tools in the RC24 run:

```text
operation=user-discovery
transport=linear-oauth-mcp
authenticated_user=present
raw_email_committed=false
raw_provider_payload_committed=false
team_key_discoverable=P4Y
team_id_discoverable=true
```

```text
operation=status-discovery
transport=linear-oauth-mcp
team_key=P4Y
statuses_discoverable=true
status_names_observed=Backlog, Todo, In Progress, In Review, Done, Duplicate, Canceled
raw_status_ids_committed=false
```

```text
operation=governing-issue-read
transport=linear-oauth-mcp
issue=P4Y-1298
status_observed_at_rc24=In Progress
project_link_present=true
labels_present=true
assignee_present=true
parent_issue=false
raw_description_committed=false
raw_provider_payload_committed=false
```

```text
operation=child-issue-read
transport=linear-oauth-mcp
issue=P4Y-1299
parent=P4Y-1298
status_observed_at_rc24=In Progress
labels_present=true
assignee_present=true
raw_description_committed=false
raw_provider_payload_committed=false
```

## Mutation Boundary

No broad mutation was performed by this RC24 implementation. The observed governing/child issues were already present and in progress for this run. Future mutation proof must remain bounded to `P4Y-1298`, its approved children, or explicit non-sensitive fixture issues.

## Promotion Decision

- Promote the **host OAuth MCP read/discovery lane** only to `conditional` for this authenticated host and bounded Linear workflow operations.
- Do **not** promote repo-local `linear-api-key-graphql` helpers to `available`; RC18 remains the current shell fallback evidence and is blocked by missing non-sensitive fixture prerequisites.
- Do **not** claim portable CI availability or script availability from OAuth MCP host proof.

## Related Proof

- API-key GraphQL fallback blocked appendix: `planning/evidence/dated-proof-appendix/linear-mcp-live-validation-2026-05-08.md`
- Targeted tests for lane separation/status honesty:
  - `bash tests/linear-structured-mcp-binding.sh`
  - `bash tests/linear-oauth-status-honesty.sh`
  - `bash tests/semantic-negative-fixtures.sh`
