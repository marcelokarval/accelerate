---
name: codex-skill-promotion-protocol
description: Accelerate-native protocol for promoting, reconciling, and optionally exporting skills from the repo-owned skill tree without making user-home catalogs authoritative.
metadata:
  category: devops
  origin: project-local
  related_skills: [accelerate, native-mcp, mcporter, verification-before-completion]
---
# codex-skill-promotion-protocol

Use this skill when a skill or skill bundle is being promoted into the
Accelerate repository catalog and you need the result to be operationally true,
not just copied.

## Purpose

Prevent catalog drift across these surfaces:

1. repo-owned source tree in `skills/`
2. accelerate/control-plane references
3. derived docs when the promoted skill changes visible workflow truth
4. optional runtime exports when export is explicitly in scope

## Core Rule

Promotion is not "copy a folder".

A promotion is only complete when:

- the target skill content is reconciled with the live Codex runtime model
- references to the skill catalog are truthful
- optional runtime exports are generated only after the repo-local source is
  correct
- local registry/self-containment is verified
- public docs are updated when the change affects published workflow truth

## When to Use

Use this protocol when:

- importing or adapting a skill from another ecosystem
- promoting a sandbox-only skill into the governed Accelerate catalog
- reconciling naming drift between docs and real skills
- adding a new branch-critical skill to accelerate
- fixing catalog drift after iterative workflow changes

## Do Not Use For

- tiny typo fixes in an existing skill with no catalog implications
- private scratch skills that are not intended for governed runtime use

## Source Of Truth Order

Use this precedence order:

1. repo policy in `AGENTS.md`
2. governed root skill tree under `skills/`
3. canonical architecture docs such as `docs/architecture/accelerate-control-plane.md`
4. derived docs when present
5. optional runtime export, only when the current task explicitly includes
   export

Runtime exports are deployment targets, not authoring sources.

## Protocol

### 1. Classify the promotion

Decide what kind of promotion this is:

- `new-skill promotion`
- `rename / reconciliation`
- `workflow-lane promotion`
- `metadata / discoverability cleanup`
- `public-doc alignment`

If the change mutates accelerate, workflow routing, mandatory gates, or branch
skill bundles, treat it as workflow-level mutation and apply explicit approval
and evidence discipline.

### 2. Audit the real catalog first

Before writing anything, inspect:

- whether the target skill already exists in seed
- whether an optional runtime export already exists, if export is in scope
- whether adjacent skills already cover the same lane
- whether public docs or accelerate references already mention it

Typical audit questions:

- is this a real gap or duplicate overlap?
- should the skill be created, renamed, merged, or referenced differently?
- does the promoted text still contain foreign runtime assumptions?

### 3. Reconcile before copying

When adapting from another ecosystem:

- remove references to the wrong runtime or tool names
- remove foreign path assumptions
- reconcile commands with repo/runtime policy
- replace stale sibling references with actual Codex catalog neighbors
- normalize naming and category to fit the governed catalog

Do not sync a skill that still lies about its runtime.

### 4. Patch the governed seed first

Make all edits in:

- `skills/<category>/<skill-name>/...`

Prefer:

- concise root `SKILL.md`
- progressive disclosure through references when needed
- metadata that helps discovery:
  - `category`
  - `origin`
  - `related_skills` when useful

### 5. Reconcile references and docs

If the promotion changes workflow truth, update the right reference surfaces in
the same mutation package.

Typical surfaces:

- root `SKILL.md` or root skill references
- accelerate reference modules
- `docs/architecture/accelerate-control-plane.md`
- public docs when present

Examples of when this is required:

- new closure lane skill
- new QA/proof lane skill
- new MCP/integration lane skill
- renamed or removed skill that docs still mention

### 6. Optionally export repo skill -> runtime target

After the repo-owned skill is correct, export only when the current task needs a
runtime copy.

Do not hand-edit any runtime export as the primary mutation surface.

### 7. Verify parity

Local verification is mandatory. Runtime parity verification is mandatory only
when runtime export is in scope.

At minimum verify:

- skill exists in seed
- skill is registered in the repo manifest
- directory contents match for changed skills when runtime export is in scope
- references no longer point at nonexistent skill names
- public docs are not advertising stale workflow truth

### 8. Leave a closure note

Summarize:

- what was promoted or reconciled
- what adjacent references were updated
- what was synchronized
- what still remains intentionally deferred

## Minimum Evidence Packet

Every promotion should leave evidence for:

- promotion target(s)
- source of imported/adapted material
- runtime assumptions removed or changed
- references/docs touched
- export target(s), if any
- local validation and export parity result, when export is in scope

## Common Failure Modes

- copying a skill without reconciling runtime assumptions
- updating a runtime export but not the repo-owned skill tree
- updating skills but leaving accelerate docs stale
- adding a branch-critical skill without updating public workflow docs
- keeping duplicate lane skills with overlapping names and no explicit boundary
- improving docs discoverability before catalog truth is reconciled
- treating generated session artifacts as if they were automatically canonical repo artifacts
- leaving runtime-generated proof surfaces untracked without an explicit persistence policy

## Artifact Persistence Policy

When a promotion or workflow change materializes files on disk, decide explicitly
which outputs are canonical and which are runtime/session outputs.

### Usually versioned

- governed contracts
- stable context packs
- hand-curated example artifacts
- small canonical fixture datasets when they are part of the approved proof surface

### Usually not versioned

- per-session analysis outputs
- per-session manifests
- repeated runtime proof dumps whose filenames or content are session-specific

### Rule

Do not leave this ambiguous.

If the workflow creates a durable audit surface, the mutation package should also
make the persistence policy explicit by one or more of:

- committing the canonical artifacts
- adding ignore rules for runtime/session outputs
- documenting the distinction in the review/closure note

A repo with generated artifacts sitting untracked in limbo is not fully closed.

## Practical Checklist

- [ ] classify the promotion type
- [ ] audit existing catalog state
- [ ] reconcile content to Accelerate/runtime truth
- [ ] write changes in governed seed first
- [ ] update accelerate/control-plane/public docs when required
- [ ] optionally export only if runtime export is in scope
- [ ] verify local registry and optional export parity
- [ ] summarize residual drift or defer reasons honestly

## Relationship To Other Skills

- `accelerate` when the promoted skill changes workflow truth
- `verification-before-completion` when the question is whether the promotion is actually closure-ready
- `native-mcp` / `mcporter` when the promoted skill affects integration posture or MCP capability discovery

## Verification

This protocol is being used correctly if:

- seed remains the authoring source of truth
- runtime export only changes after seed reconciliation
- no stale skill names remain in active workflow docs
- the promoted skill is operationally usable in the actual runtime
- local validation is explicit, and runtime parity is checked when export is in scope
