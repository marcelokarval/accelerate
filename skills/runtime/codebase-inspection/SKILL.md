---
name: codebase-inspection
description: Codex-native codebase metrics guidance using pygount or equivalent shell tooling. Use when asked for LOC counts, language breakdown, repo size, or code-vs-comment composition.
metadata:
  category: analysis
  origin: standalone-adapted-from-global
  related_skills: [github-repo-management, architecture]
---
# Codebase Inspection

Use this skill when the question is about repository size or composition.

## Preferred Tool

Use `pygount` when available.

## Basic Summary

```bash
pygount --format=summary   --folders-to-skip=".git,node_modules,venv,.venv,__pycache__,.cache,dist,build,.next,.tox,vendor"   .
```

## Common Uses

- lines of code count
- language breakdown
- code vs comment ratio
- rough repo composition before deeper analysis

## Pitfalls

- always skip dependency/build directories
- markdown and docs may count as comments rather than code
- large monorepos may need targeted suffix filters

## Useful Variants

```bash
pygount --suffix=py --format=summary .
pygount --format=json .
```

## Verification

Inspection is correct when:

- excluded directories are explicit
- the chosen scope matches the user's question
- reported numbers clearly state whether they are repo-wide or filtered
