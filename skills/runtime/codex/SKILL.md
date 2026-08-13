---
name: codex
description: Use when a task explicitly concerns Codex CLI or app runtime behavior, configuration, profiles, prompt/debug introspection, or a bounded fresh-process Codex invocation; prefer native collaboration for subagents, use current source-backed options, and prove capability in a fresh process.
---

# Codex Runtime Operations

Operate the Codex runtime from Codex-native tools and current evidence. This
skill does not replace `accelerate`, a stack specialist, or official product
documentation.

## Core Rules

- Use native Codex collaboration for subagents. Do not recursively launch the
  CLI merely to imitate delegation.
- Read local `codex --help`, current configuration, and fresh debug output
  before asserting that an option, profile, skill, MCP, or model is available.
- Treat configuration and credential presence as inventory, not callability.
- Use official OpenAI documentation for version-sensitive product claims when
  the `openai-docs` skill is available.
- Never copy secrets, auth files, or environment values into prompts or output.

## Workflow

1. State the exact Codex surface: CLI invocation, configuration, profile,
   prompt-input inspection, runtime proof, or troubleshooting.
2. Inspect the smallest current surface with read-only commands such as
   `codex --version`, `codex --help`, a relevant subcommand help, or a bounded
   `codex debug` call.
3. Prefer `collaboration.spawn_agent` for agent work. Use a fresh `codex exec`
   process only when the request explicitly requires CLI/runtime proof or an
   isolated Codex process.
4. Bind a fresh process to an explicit repository, prompt, sandbox posture,
   success criterion, and output/log collection. Use a PTY only when actual
   interaction requires it; do not assume every `codex exec` needs one.
5. Monitor a long-running process through the active execution-session tools,
   inspect file/test progress independently, and terminate only on completion,
   unsafe drift, or evidence of a real stall.
6. Re-read the resulting state. A version line, registration, or process exit
   alone does not prove an MCP handshake, tool call, mutation, or runtime effect.

## Safety Boundaries

- Do not default to unrestricted or approval-bypassing flags.
- Do not publish, commit, push, mutate a provider, or close an issue unless the
  governing workflow separately authorizes that action.
- Account for configured MCP sidecars in fresh CLI processes; strict tool
  minimization requires an invocation path that actually enforces it.
- Do not hardcode model recommendations from version ordering. Follow the
  current repo role policy or current official documentation.

The imported Hermes-era procedure is retained only for provenance in
[the legacy procedure](references/full-procedure.md). Its Hermes tool names,
paths, flags, and model table are not runtime authority here.

## Return Evidence

Return the inspected command/surface, version or config provenance, observed
capability, unproved assumptions, process cleanup state, and the root-owned
next action.
