---
name: skill-catalog-router
description: Use when an engineering task may need a governed specialist skill that is not visible in the compact root catalog; resolve it from the repo-owned current index, verify its exact route and digest, and load only the matching SKILL.md.
---

# Skill Catalog Router

Use this skill for progressive discovery. The repository owns the catalog;
`~/.codex/skills` is only its deployed runtime mirror.

## Core Rule

Resolve the smallest relevant skill from [the current index](references/index.tsv),
verify the indexed route, and read only that `SKILL.md` before acting. Never load
the full catalog into the prompt.

## Workflow

1. Search `references/index.tsv` by skill ID and description keywords.
2. Prefer a skill already visible in the active prompt when it is an exact fit.
3. For a hidden governed skill, select exactly one indexed row unless the task
   clearly crosses multiple independent capability boundaries.
4. At runtime, require the indexed absolute runtime path to exist and its file
   SHA-256 to equal the indexed digest.
5. Load that exact file, follow it, and record the resolved ID, path, and digest
   in the assignment or runtime packet.
6. Fail closed on an absent, duplicate, stale, path-escaping, or hash-mismatched
   route. Return the gap to the root instead of guessing another catalog.

## Boundaries

- The index is discovery and integrity evidence, not tool, MCP, credential,
  process, or filesystem isolation.
- Do not treat a global mirror, cache, plugin path, or generated profile as
  authoring authority.
- Do not silently substitute a similarly named community skill.
- Root retains staffing, issue topology, integration, review-of-review, and
  closure authority.

## Maintenance

After a repo-owned governed skill is added, removed, renamed, or materially
changed, rebuild and check the index:

```bash
python3 skills/governance/skill-catalog-router/scripts/build_index.py \
  --repo-root "$PWD" --write
python3 skills/governance/skill-catalog-router/scripts/build_index.py \
  --repo-root "$PWD" --check
```

The builder covers `skills/*/*/SKILL.md` plus the root runtime package at
`global-runtime/accelerate/SKILL.md`. Detailed row semantics and failure rules
are in [the catalog contract](references/catalog-contract.md).

## Return Evidence

Return the selected skill ID, exact path, verified SHA-256, why it is the
smallest fit, and any unresolved catalog gap.
