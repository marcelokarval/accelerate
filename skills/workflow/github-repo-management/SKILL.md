---
name: github-repo-management
description: Codex-native repository setup and remote-management guidance. Use when cloning, creating, forking, wiring remotes, or checking a repo's GitHub connectivity and identity.
metadata:
  category: integrations
  origin: standalone-adapted-from-global
  related_skills: [github-auth, github-pr-workflow, github-issues]
---
# GitHub Repo Management

Use this skill for repo-level GitHub operations.

## Typical Jobs

- clone an existing repo
- create a new repo
- fork a repo
- inspect or rewrite remotes
- connect a local repo to GitHub

## Clone

```bash
git clone git@github.com:OWNER/REPO.git
# or
git clone https://github.com/OWNER/REPO.git
```

## Inspect remotes

```bash
git remote -v
git remote get-url origin
```

## Add or change origin

```bash
git remote add origin git@github.com:OWNER/REPO.git
# or
git remote set-url origin git@github.com:OWNER/REPO.git
```

## Create via gh

```bash
gh repo create OWNER/REPO --private --clone
```

## Fork via gh

```bash
gh repo fork OWNER/REPO --clone
```

## MCP / API Use

If GitHub MCP is configured, prefer it for metadata-aware repo operations where
available. Use `gh` or git when the operation is fundamentally local or shell-based.

## Relationship To Other Skills

- `github-auth` first when the main uncertainty is credentials or transport choice
- `github-pr-workflow` once the repo is connected and the task becomes branch/PR execution

## Verification

Repo management is correct when:

- the intended owner/repo is explicit
- remote URLs match the expected transport
- local and remote identities are not confused
- follow-up push or fetch succeeds
