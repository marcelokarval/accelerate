# Manifest Truth Gate

Adapter manifests are executable truth contracts. A capability may be marked
`native` only when the repository can prove the backing behavior without relying
on prose, chat history, or unstructured LLM prompts.

## Rules

- `status: implemented` requires live proof for every remote native write
  capability.
- `status: planned` may expose helper commands, but unproven write capabilities
  must remain `planned` or `blocked`.
- `native` read capabilities require either live read proof or a local command
  that is executable and fail-closed.
- `native` write capabilities require a registry entry in
  `adapters/workflow/remote-write-registry.yaml` with `structured_write: yes`.
- LLM-mediated MCP prompts are not structured writes.
- `linked` is allowed for provider surfaces that preserve traceability but do not
  own the full lifecycle or topology.
