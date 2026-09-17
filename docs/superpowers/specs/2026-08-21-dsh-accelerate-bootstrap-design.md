# DSH Accelerate Bootstrap Design

## Status

Approved direction: preset bootstrap with proportional prompt hardening.

Deferred evolution: a native DSH plugin may later enforce critical entry and
mutation gates mechanically. The plugin is not part of the initial delivery.

## Goal

Make Accelerate the reliable engineering entry workflow in DeepSeek Harness
(DSH) so that each request is classified before execution and, when useful,
converted into a clearer execution input. Preserve a fast path for trivial
work and use the existing OmniRouter reasoning lane only when ambiguity or risk
justifies it.

The design also adds focused operational skills for DSH, OpenHands, and
OmniRouter and projects those skills into OpenCode, DSH/OpenHands, Codex, and
Hermes without making deployed user-home copies the authoring authority.

## Non-Goals

- Do not patch the DSH core in the initial delivery.
- Do not create an always-expensive second-model planning pass.
- Do not make OmniRouter a workflow or closure authority.
- Do not claim that prompt instructions are mechanical enforcement.
- Do not enable or claim OpenHands child-agent bindings that current runtime
  evidence classifies as unavailable.
- Do not duplicate Accelerate classification inside each operational skill.

## Existing Runtime Capabilities

The active DSH `code-orchestrated` preset already provides the required
building blocks:

- filesystem skill discovery from project roots, `~/.dsh/skills`, and
  `~/.agents/skills`;
- a durable session skill catalog and model-facing `skill` loader;
- `subagent`, `subagent_reasoning`, `subagent_fast`, and `workflow` tools;
- dedicated OmniRouter aliases for coding, reasoning, and fast work;
- plan, goal, todo, filesystem, shell, and background-job tools;
- a four-agent workflow concurrency limit.

The missing behavior is a reliable entry decision. Accelerate is discoverable
through `~/.agents/skills/accelerate`, but the model still decides whether to
load it. Therefore classification and hardening can be skipped even though the
runtime can perform them.

## Selected Architecture

### 1. Preset Bootstrap

The DSH coding preset receives a compact, stable bootstrap instruction:

1. For engineering work, load `accelerate` before task actions.
2. Classify the request as conversational/no-op, trivial bounded, or
   non-trivial, then choose the proportionate direct, scoped, or orchestrated
   execution route.
3. Apply prompt hardening only when the classification identifies material
   ambiguity, cross-surface risk, or missing acceptance authority.
4. Preserve root ownership of synthesis, integration, review-of-review, and
   closure.

The bootstrap is intentionally small. It routes into Accelerate; it does not
copy the full skill into the preset or create a second root workflow.

### 2. Proportional Input Hardening

Accelerate produces one of two entry artifacts.

For clear, bounded, low-risk work, it emits a compact branch entry contract:

```text
goal | target | constraints | proof | residuals
```

For ambiguous, risky, or non-trivial work, it produces a hardened execution
packet:

```text
objective
success criteria
authority set
scope and non-goals
known facts and unresolved decisions
risk classification
acceptance criteria
proof plan
execution route
model and effort decision
delegation decision
stop conditions
```

The hardened packet becomes the input to implementation or delegation. It is
not a second user request and must not silently broaden the user's objective.

### 3. Model Routing

Model use remains proportional:

- direct, deterministic normalization: root model, no child;
- bounded factual discovery: `subagent_fast` using `auto/best-fast`;
- material ambiguity, architecture, root-cause analysis, or critical review:
  `subagent_reasoning` using `auto/best-reasoning`;
- bounded implementation: root or `subagent` using `auto/best-coding`;
- multiple independent implementation or proof lanes: `workflow`, capped at
  four concurrent agents.

The reasoning lane returns a proposed hardened packet. The root verifies and
adopts, adjusts, or rejects it. Child output never becomes execution authority
by itself.

### 4. Operational Skills

Three operational skills complement Accelerate without duplicating it:

- `dsh-operations`: immutable release handling, profiles, presets, local
  patches, services, RPC/readback, session proof, and rollback;
- `openhands-operations`: Agent Canvas lifecycle, version boundaries, Agent
  Profiles, governed skill materialization, guards, health, runtime truth, and
  the current child-binding limitation;
- `omnirouter-operations`: aliases, pools, member priority, concurrency,
  failover, health, model enumeration, and real tool-calling proof.

Accelerate decides when and why work runs. An operational skill explains how a
specific runtime operation is performed and proven.

## Source Of Truth And Projection

The Accelerate repository remains authoritative. Runtime copies are generated
projections.

Proposed repository ownership:

```text
adapters/runtime/dsh/
adapters/runtime/openhands/
adapters/runtime/omnirouter/
skills/operations/dsh-operations/
skills/operations/openhands-operations/
skills/operations/omnirouter-operations/
```

Projection targets:

```text
DSH and OpenHands: ~/.agents/skills/<name>
OpenCode:          ~/.config/opencode/skills/<name>
Codex:             ~/.codex/skills/<name>
Hermes:            ~/.hermes/skills/<category>/<name>
```

Materializers must:

- use explicit registries and denominators;
- add a managed marker and source digest;
- refuse to overwrite unmanaged skills;
- stage and replace atomically;
- support dry-run drift detection;
- validate the deployed digest after application;
- avoid copying credentials or runtime state.

## Runtime-Specific Boundaries

### DSH

Initial enforcement is bootstrap and prompt based. DSH's durable skill catalog
proves that the skill was available; the retained `skill` tool result proves
that its body was loaded. Neither proves that every classification decision was
correct. Reports must use `prompt-enforced` or `observable`, not `mechanically
enforced`.

### OpenHands

OpenHands consumes governed skills from `~/.agents/skills`. Current Accelerate
authority classifies native child dispatch as `prompt-contract-only` with child
bindings unavailable. The operational skill must preserve this fail-closed
claim until a fresh runtime and provider proof changes the manifest.

### Codex

Codex consumes generated skill mirrors and keeps its global `AGENTS.md` as the
runtime bootstrap authority. New skills must enter the governed catalog and
digest index rather than becoming unindexed global-only files.

### OpenCode

OpenCode consumes the generated operational skill bundles from
`~/.config/opencode/skills`. The bundles use OpenCode's native skill loader but
remain projections of the Accelerate repository. A new OpenCode process is the
runtime-readback boundary after catalog changes.

### Hermes

Hermes consumes its categorized skill tree through `skills.external_dirs`.
`using-superpowers` remains the only preload. The operational skills are loaded
by trigger; they do not become additional global preloads. Persisted
`thor-task-stack` validation remains Hermes-specific mechanical enforcement.

### OmniRouter

OmniRouter owns model availability, priority, concurrency, and failover. It does
not classify work, authorize mutation, validate task completion, or own closure.
The DSH adapter maps Accelerate quality classes to OmniRouter aliases.

## Failure Handling

- Missing Accelerate skill: stop engineering execution and report bootstrap
  drift.
- Unknown or unavailable operational skill: stop the affected runtime operation
  rather than improvising commands from memory.
- Reasoning child failure: retain the original request and either harden in the
  root when safe or report a blocked decision; do not silently weaken a
  required gate.
- Required dispatch failure: use only the governed degradation reasons and do
  not perform delegated task-owned work silently in the root.
- Runtime/document disagreement: live runtime readback wins for operational
  status; repository policy remains normative for desired behavior.
- Material mutation after proof: invalidate the affected proof and rerun the
  relevant lane.

## Verification Strategy

### Static And Catalog Proof

- Validate skill frontmatter, size, linked resources, and forbidden secret
  patterns.
- Validate registry denominators and unique skill names.
- Verify source and deployed-tree digests.
- Verify DSH discovers the three skills and Accelerate from the expected roots.

### DSH Session Proof

Use fresh disposable sessions to prove:

1. a trivial request loads Accelerate and remains direct without a child;
2. an ambiguous request routes through `subagent_reasoning` and returns a
   complete hardened packet;
3. a bounded research request uses `subagent_fast`;
4. independent work uses the workflow path and respects the concurrency cap;
5. root synthesis challenges child claims before closure;
6. missing skill or failed hardening produces an explicit blocked result.

### Operational Skill Proof

Each operational skill receives trigger evals and a non-mutating runtime
readback test. Mutating procedures additionally require dry-run, rollback, and
post-change health/readback contracts.

### Cross-Runtime Proof

Validate that OpenCode, Codex, Hermes, DSH, and OpenHands receive semantically
equivalent skill content while preserving runtime-specific tool names, loaders,
authority, and enforcement claims.

## Deferred Native DSH Plugin

A native DSH Cordis plugin is a desirable future evolution because it can move
critical gates from model compliance into the operation that performs a
mutation. It should be considered after the preset-based design has produced
real execution evidence.

The plugin becomes eligible when all of the following are true:

1. DSH exposes a stable plugin and session-event contract suitable for a local
   maintained extension, preferably after the current release-candidate phase.
2. Session evidence shows repeated bootstrap, classification, mutation, or
   closure bypasses that prompt improvements do not correct.
3. The gate can be checked from authoritative session state rather than by
   parsing model prose.
4. The plugin can be tested in a real assembled composition and maintained
   without patching upstream DSH core files.
5. A rollback path can disable the plugin without damaging sessions or skill
   catalogs.

The future plugin should minimally:

- record a typed Accelerate entry receipt in session state;
- validate its schema and active-request identity;
- intercept mutating tool execution at the executor boundary;
- deny mutation when a required entry or approval receipt is absent or stale;
- invalidate proof receipts after material mutation;
- expose explicit denial diagnostics to the model and operator;
- leave read-only discovery and truly conversational turns unblocked.

It must not become a second classifier, rewrite user intent, infer approval from
conversation tone, or duplicate the full Accelerate workflow in TypeScript.
Accelerate remains semantic authority; the plugin only enforces a small set of
machine-checkable gates.

## Promotion Decision

The initial release uses preset bootstrap plus proportional hardening. The
native plugin remains a recorded target, not an assumed requirement. Promotion
requires measured violations and a stable executor-level integration point.
This preserves immediate value and portability while keeping a credible path
to stronger DSH enforcement.
