# DSH Runtime Adapter

This adapter maps Accelerate's runtime-neutral execution routes onto the native
DeepSeek Harness collaboration surface used by the `code-orchestrated` preset.

## Current Contract

- Status: `supported`
- Enforcement: `prompt-enforced`
- Loader: managed bootstrap in the `code-orchestrated` Agent Preset
- Root alias: `auto/best-coding`
- Child ceiling: four concurrent children

The root owns hardening, fan-in, integration, review-of-review, and closure.
Reasoning children propose evidence or a hardened packet; their output is never
execution authority by itself.

## Native Mapping

| Need | DSH tool | OmniRouter alias |
| --- | --- | --- |
| Bounded factual research | `subagent_fast` | `auto/best-fast` |
| Ambiguity, architecture, risk, root cause, critical review | `subagent_reasoning` | `auto/best-reasoning` |
| Bounded implementation or QA | `subagent` | `auto/best-coding` |
| Multiple independent lanes | `workflow` | `auto/best-coding` |

No-op and trivial work must not delegate merely because a tool is available.
Unknown tools or child types fail closed.

## Enforcement Boundary

The preset makes Accelerate prompt-mandatory and session events make tool use
observable. This does not mechanically prove that every classification was
correct. Reports must say `prompt-enforced` or `observable`.

A native Cordis executor plugin remains `planned`. It may later validate typed
Accelerate receipts before mutation, but it must not become a second classifier
or require patches to DSH core.

Validate this adapter with:

```bash
python3 adapters/runtime/dsh/validate-adapter.py
```
