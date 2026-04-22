---
name: skill-developer
description: Codex-native skill development guidance for creating, adapting, testing, and registering Accelerate skills without copying foreign runtime assumptions.
user-invocable: true
related-skills: codex-skill-promotion-protocol, writing-skills, verification-before-completion
---

# skill-developer

Use this skill when creating or materially changing a governed Accelerate skill.

## Purpose

Keep skills operationally useful, small enough to load, and aligned with the
Codex/Accelerate runtime rather than another agent ecosystem.

## Core Rules

1. Write skills for the active runtime, not for copied tool names or paths.
2. Keep `SKILL.md` concise; move deep examples into `references/` when needed.
3. Use metadata for category, provenance, mirror path, and source-of-truth
   policy.
4. Register every governed skill in `skills/_registry/manifest.md`.
5. Sync only after repo-local content is correct.
6. Verify parity with the global runtime mirror before closure.

## Required Shape

Each governed skill should include:

- `SKILL.md`
- `metadata.yaml`
- optional `references/`, `examples/`, `tests/`, `evals/`, `assets/`,
  `scripts/`, or `templates/`

## Adaptation Checklist

- remove foreign runtime names unless they are explicit provenance
- remove hardcoded project paths
- replace project-specific business rules with active stack/profile language
- keep domain-specific behavior in overlays or clearly named domain skills
- update category READMEs and the registry manifest

## Verification

A skill change is closure-ready only when:

- local registry validation passes
- local skill files mirror into `~/.codex/skills/`
- support directories required by the skill also mirror correctly
- stale references to old paths or foreign runtime assumptions are removed
