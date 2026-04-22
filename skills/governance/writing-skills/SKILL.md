---
name: writing-skills
description: Codex-native methodology for writing effective skills with clear trigger scope, progressive disclosure, examples, and verification fixtures.
user-invocable: true
related-skills: skill-developer, codex-skill-promotion-protocol
---

# writing-skills

Use this skill when drafting a new skill body or rewriting a weak one.

## Principle

A skill is an operational reference that future runs can reliably discover,
load, and execute. It is not a blog post, session log, or broad knowledge dump.

## Discovery Rules

- The description must say when to use the skill.
- Do not summarize the full workflow in the description so heavily that the
  model skips reading the body.
- Use names that match how operators ask for the capability.

## Content Rules

1. Start with when to use and when not to use.
2. State the core rule before examples.
3. Keep the main file concise.
4. Put long examples, matrices, fixtures, and edge cases in references.
5. Prefer checklists and output contracts over vague advice.
6. Include verification criteria.

## Anti-Patterns

- copying another runtime's hooks, commands, or paths as if they apply here
- burying required behavior in long prose
- mixing project-specific overlays into universal core skills
- adding new mandatory skills without registry updates
- claiming a skill works without a small proof or parity check

## Review Checklist

- Is the trigger clear?
- Is the scope bounded?
- Are neighboring skills named?
- Is the output contract testable?
- Does it avoid stale runtime assumptions?
