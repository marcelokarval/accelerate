---
name: using-superpowers
description: Translate an explicit legacy using-superpowers reference into the Accelerate and Codex progressive-skill workflow. Use only when an imported prompt, plan, or runtime contract names using-superpowers or its compatibility behavior must be assessed; never use it as a second root classifier.
---

# Using Superpowers Compatibility

Preserve compatibility with legacy skill-first instructions without importing
their runtime assumptions. `accelerate` remains the only root classifier.

## Core Rule

When an artifact explicitly requires `using-superpowers`, interpret it as a
request to classify through `accelerate`, load the smallest relevant visible or
repo-indexed skill, and keep the resulting route observable. Do not create a
second mandatory pre-response ritual.

## Workflow

1. Confirm the explicit legacy reference or compatibility question.
2. Load and follow `accelerate` for engineering classification and gates.
3. Prefer an already-visible exact skill; otherwise use
   `skill-catalog-router` and verify its indexed path and SHA-256.
4. Load only the selected skill body and directly linked resource needed for
   the task.
5. Record the compatibility mapping and continue under the active Accelerate
   branch. Do not duplicate packets, plans, issue ownership, or closure gates.

## Boundaries

- This compatibility overlay is on-demand and never a root-core dependency.
- Do not assume Claude `Skill`, `TodoWrite`, hook, or command semantics exist.
- Do not use a one-percent heuristic to load unrelated skills.
- Skill discovery does not authorize mutation, provider access, delegation, or
  closure.

The unmodified imported procedure is retained for provenance in
[the legacy procedure](references/full-procedure.md). It is evidence of the
compatibility source, not current operating authority.

## Return Evidence

Return the explicit legacy trigger, Accelerate branch, selected skill ID/path/
digest, any unmapped runtime assumption, and the root-owned next action.
