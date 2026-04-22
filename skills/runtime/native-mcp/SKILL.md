---
name: native-mcp
description: Codex-native MCP client guide for configuring and using MCP servers through ~/.codex/config.toml. Use when adding servers, understanding transport options, or troubleshooting why MCP-backed tools are or are not available.
metadata:
  category: integrations
  origin: standalone-adapted-from-global
  related_skills: [mcporter, github-auth, github-issues, github-code-review, github-pr-workflow, linear-pm]
---
# Native MCP

Use this skill when the job depends on Model Context Protocol servers that are
configured directly in the Codex runtime.

## When to Use

- adding a new MCP server to Codex
- checking whether a server is already configured
- understanding stdio vs HTTP MCP transports
- troubleshooting startup, auth, or approval behavior
- deciding whether to use native MCP or an ad-hoc CLI such as `mcporter`

## Core Rule

Prefer the native Codex MCP runtime for durable, reused capabilities.
Use `mcporter` for ad-hoc one-off inspection or experimentation.

## Source Of Truth

The live MCP catalog is configured in:

- `~/.codex/config.toml`

In this environment, Codex already uses `[mcp_servers.<name>]` entries such as:

- `context7`
- `sequential_thinking`
- `memory`
- `github`
- `linear`
- `chrome-devtools`
- `playwright`

Secrets for shell-launched servers may be sourced from:

- `~/.codex/mcp-secrets.env`

## Transport Types

### 1. stdio transport

Use when Codex should launch a local process:

```toml
[mcp_servers.example]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-example"]
startup_timeout_sec = 120.0
```

### 2. HTTP transport

Use when the MCP server is remote:

```toml
[mcp_servers.example_remote]
url = "https://example.com/mcp"
startup_timeout_sec = 120.0
```

## Approval Controls

Individual tools can require approval explicitly:

```toml
[mcp_servers.chrome-devtools.tools.click]
approval_mode = "approve"
```

Use this when a tool has side effects or should stay human-gated.

## Shell + Secret Pattern

For servers that need credentials, this runtime commonly uses a shell wrapper:

```toml
[mcp_servers.github]
command = "bash"
args = ["-lc", "set -a; source ~/.codex/mcp-secrets.env; set +a; exec npx -y @modelcontextprotocol/server-github"]
startup_timeout_sec = 120.0
```

This pattern keeps tokens out of the main config file and makes rotation easier.

## Workflow

### 1. Inspect current config

Use file reads/searches against `~/.codex/config.toml` first.
Do not guess whether a server exists.

### 2. Decide native vs ad-hoc

Use native MCP when:

- the capability will be reused
- the server should be available across many sessions
- approval rules or named server identity matter

Use `mcporter` when:

- the call is exploratory
- the server should not be permanently added yet
- you need to inspect or test a remote server quickly

### 3. Add or edit the server entry

Keep the config minimal and explicit:

- server name
- transport (`command` + `args` or `url`)
- timeout
- per-tool approval rules when needed
- secret sourcing only when actually required

### 4. Validate the runtime path

After changing config, verify:

- the server entry is syntactically correct
- required commands exist (`npx`, `node`, `bash`, etc.)
- required secrets file entries exist when referenced
- the intended MCP-backed workflow now has the needed tools

## Troubleshooting

### Server exists in config but tools do not appear

Check:

- malformed TOML
- wrong command or package name
- missing credentials in `~/.codex/mcp-secrets.env`
- too-short startup timeout
- approval rules that are stricter than expected

### Stdio server fails to start

Check:

- `command` exists on PATH
- the shell wrapper command actually runs standalone
- any sourced secret file exists and is readable

### HTTP server fails

Check:

- URL correctness
- auth headers or wrapper logic
- network availability

## Relationship To Other Skills

- `mcporter` for ad-hoc MCP inspection and direct calls
- `github-auth` when the configured server is GitHub MCP and capability/auth posture must be verified
- `github-issues`, `github-code-review`, and `github-pr-workflow` when GitHub operations are the real task rather than MCP config itself
- `linear-pm` when the configured server is Linear MCP
- `product-runtime-review` when browser MCP tools are part of proof gathering

## Verification

This skill is being used correctly if:

- MCP claims are grounded in `~/.codex/config.toml`
- secrets stay outside the main config when possible
- native MCP is chosen for durable capabilities
- ad-hoc tooling is chosen for exploration instead of unnecessary permanent config
