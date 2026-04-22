---
name: github-pr-workflow
description: Codex-native pull request lifecycle guidance. Use when creating a branch, opening a PR, checking CI, updating the PR, or merging through GitHub-aware tooling.
metadata:
  category: integrations
  origin: standalone-adapted-from-global
  related_skills: [github-auth, github-code-review, requesting-code-review, verification-before-completion, github-issues, github-repo-management]
---
# GitHub PR Workflow

Use this skill for the pull request lifecycle.

## Preferred Access Order

1. git for branch and commit operations
2. GitHub MCP or `gh` for PR operations
3. REST fallback only when necessary

## Workflow

### 1. Sync and branch

```bash
git fetch origin
git checkout main && git pull origin main
git checkout -b feat/my-change
```

### 2. Commit truthfully

```bash
git add -A
git commit -m "feat: concise description"
```

### 3. Push

```bash
git push -u origin HEAD
```

### 4. Create PR

```bash
gh pr create --title "feat: concise description" --body "## Summary
- ..."
```

### 5. Watch checks

```bash
gh pr checks --watch
```

### 6. Update or merge

```bash
gh pr view
gh pr merge --squash --delete-branch
```

## CI / Review Discipline

- do not open a PR with knowingly broken local validation unless that is the explicit point of the PR
- if checks fail, inspect and fix before merge
- keep PR title/body aligned with what actually landed

## Relationship To Other Skills

- `github-auth` first when the repo access path is still unclear
- `requesting-code-review` before opening or updating the PR when local verification is still missing
- `github-code-review` when the job shifts from opening the PR to reviewing an existing one
- `verification-before-completion` when merge-readiness or closure truth is the actual question

## Verification

The workflow is correct when:

- branch, commit, and PR identities are explicit
- CI state was actually checked
- merge strategy matches team practice
- the PR body is not lying about scope or validation
