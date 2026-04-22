---
name: github-auth
description: Codex-native GitHub authentication and capability-detection guide. Use when you need to decide between GitHub MCP, gh CLI, SSH/HTTPS git auth, or raw REST access.
metadata:
  category: integrations
  origin: standalone-adapted-from-global
  related_skills: [native-mcp, mcporter, github-issues, github-code-review, github-pr-workflow, github-repo-management]
---
# GitHub Auth

Use this skill when GitHub access is required and the question is how this
runtime should authenticate safely.

## Preferred Access Order

1. GitHub MCP if configured in `~/.codex/config.toml`
2. `gh` CLI if already authenticated
3. git over SSH or HTTPS
4. raw GitHub REST calls with an explicit token only when needed

## Quick Checks

```bash
# MCP config presence
rg -n "\[mcp_servers.github\]" ~/.codex/config.toml

# gh auth
command -v gh && gh auth status

# git remotes
git remote -v
```

## MCP Pattern

In this runtime, GitHub MCP may be launched through a shell wrapper that sources
`~/.codex/mcp-secrets.env`. Prefer that path for durable automation.

## gh CLI Pattern

```bash
gh auth status
gh auth login
```

Use `gh` when the work is interactive and the MCP route is unavailable or not
sufficient for the requested operation.

## Git Transport Checks

### HTTPS

```bash
git remote get-url origin
```

If using HTTPS, verify whether a credential helper already stores access.

### SSH

```bash
ssh -T git@github.com
```

Use SSH when cloning/pushing frequently and machine-level key management is
already in place.

## REST Fallback

Use raw API calls only when MCP and `gh` are unavailable or the workflow needs a
specific endpoint.

```bash
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

## Relationship To Other Skills

- `native-mcp` when the durable path should be GitHub MCP in `~/.codex/config.toml`
- `mcporter` when you want to inspect or test an MCP server ad hoc before committing to config
- `github-issues`, `github-code-review`, `github-pr-workflow`, and `github-repo-management` once the auth path is proven

## Verification

Authentication is good enough when:

- the chosen access path is explicit
- you can prove it works with a real read operation
- credentials are not hardcoded into repo files
- you are not bypassing an existing better-native path such as MCP
