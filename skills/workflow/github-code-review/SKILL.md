---
name: github-code-review
description: Codex-native GitHub PR and diff review guidance. Use when reviewing another branch or pull request, leaving comments, or reconciling code review findings with repo reality.
metadata:
  category: review
  origin: standalone-adapted-from-global
  related_skills: [requesting-code-review, verification-before-completion, github-pr-workflow]
---
# GitHub Code Review

Use this skill when the job is reviewing existing GitHub changes, not verifying
your own uncommitted work.

For your own local changes before commit, prefer `requesting-code-review`.
For final closure judgment after review findings are reconciled, prefer `verification-before-completion`.

## Preferred Access Order

1. GitHub MCP if it exposes the needed review operations
2. `gh pr view`, `gh pr diff`, `gh pr review`
3. git diff + GitHub REST fallback

## Review Workflow

### 1. Identify the review surface

- PR number
- branch comparison
- specific files or commits

### 2. Read the diff fully

```bash
gh pr diff 123
# or
git diff origin/main...HEAD
```

### 3. Review against real criteria

- correctness
- scope control
- tests and verification
- security and abuse sensitivity
- contract drift
- documentation or migration fallout

### 4. Leave structured feedback

```bash
gh pr review 123 --comment --body "Main findings: ..."
```

Use inline comments when file-level precision matters.

## Red Flags

- reviewing summaries instead of the actual diff
- calling something approved without checking tests or runtime claims
- mixing local pre-commit verification with PR review as if they were the same lane

## Verification

A review is trustworthy when:

- the exact diff or PR was inspected
- findings tie back to file- or behavior-level evidence
- approval/request-changes matches the actual severity of findings
