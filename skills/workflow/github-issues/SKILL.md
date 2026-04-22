---
name: github-issues
description: Codex-native GitHub issue workflow guidance. Use when creating, reading, updating, triaging, or linking GitHub issues through MCP, gh, or REST.
metadata:
  category: integrations
  origin: standalone-adapted-from-global
  related_skills: [github-auth, github-pr-workflow, linear-pm]
---
# GitHub Issues

Use this skill for GitHub issue work.

## Preferred Access Order

1. GitHub MCP when available
2. `gh issue ...`
3. GitHub REST via `curl`

## Typical Operations

- list/search issues
- inspect one issue deeply
- create a new issue
- update labels, assignees, state, or milestones
- link issue work to branches or PRs

## Minimal Workflow

### 1. Identify owner/repo

```bash
REMOTE_URL=$(git remote get-url origin)
OWNER_REPO=$(echo "$REMOTE_URL" | sed -E 's|.*github\.com[:/]||; s|\.git$||')
echo "$OWNER_REPO"
```

### 2. Prefer MCP or gh for reads

```bash
gh issue list
gh issue view 123
```

### 3. Create/update with explicit metadata

```bash
gh issue create --title "Bug: broken login redirect" --body "Steps, expected, actual"
gh issue edit 123 --add-label bug --add-assignee @me
```

### 4. REST fallback only when needed

```bash
curl -s -H "Authorization: token $GITHUB_TOKEN"   "https://api.github.com/repos/$OWNER_REPO/issues?state=open"
```

## Discipline

- search before creating duplicates
- keep labels and state truthful
- prefer updates over issue churn when the same problem already exists
- when a PR is part of the workflow, cross-link issue and PR explicitly

## Relationship To Other Skills

- `github-auth` first when the access path is still unclear
- `github-pr-workflow` when issue work is paired with branch/PR execution
- `linear-pm` when the real source of scope and lifecycle authority lives in Linear instead of GitHub Issues

## Verification

Issue work is correct when:

- the repository target is explicit
- the issue identity/number is captured
- labels, assignee, and state match reality
- any claimed create/update has tool evidence behind it
