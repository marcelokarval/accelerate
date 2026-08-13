---
name: codex
description: "Delegate coding to OpenAI Codex CLI (features, PRs)."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [Coding-Agent, Codex, OpenAI, Code-Review, Refactoring]
    related_skills: [claude-code, hermes-agent]
---

# Codex CLI

Delegate coding tasks to [Codex](https://github.com/openai/codex) via the Hermes terminal. Codex is OpenAI's autonomous coding agent CLI.

## When to use

- Building features
- Refactoring
- PR reviews
- Batch issue fixing

Requires the codex CLI and a git repository.

## Prerequisites

- Codex installed: `npm install -g @openai/codex`
- OpenAI auth configured: either `OPENAI_API_KEY` or Codex OAuth credentials
  from the Codex CLI login flow
- **Must run inside a git repository** — Codex refuses to run outside one
- Use `pty=true` in terminal calls — Codex is an interactive terminal app

For Hermes itself, `model.provider: openai-codex` uses Hermes-managed Codex
OAuth from `~/.hermes/auth.json` after `hermes auth add openai-codex`. For the
standalone Codex CLI, a valid CLI OAuth session may live under
`~/.codex/auth.json`; do not treat a missing `OPENAI_API_KEY` alone as proof
that Codex auth is missing.

## GPT-5 Model Selection Policy

Use source-backed model selection. Do not choose GPT-5 family models by
apparent version number alone.

Official OpenAI sources behind this policy:

- OpenAI API Models: `https://developers.openai.com/api/docs/models`
- OpenAI GPT-5.5 model guide:
  `https://developers.openai.com/api/docs/guides/latest-model`
- OpenAI GPT-5.5 release:
  `https://openai.com/index/introducing-gpt-5-5/`
- OpenAI GPT-5.3-Codex-Spark release:
  `https://openai.com/index/introducing-gpt-5-3-codex-spark/`

### Baseline

- Do not use `gpt-5.2*` as the baseline for new Codex assistants.
- Minimum acceptable baseline for routine assistants is `gpt-5.4/low`.
- Preferred baseline for most persistent engineering assistants is
  `gpt-5.4/medium` or `gpt-5.5/medium`.
- Use `gpt-5.5/medium` for complex reasoning, coding, long-context analysis,
  agentic workflows, professional work, and tool-heavy execution.
- Use `gpt-5.4/medium` when the task is still professional coding/workflow
  work but cost or quota pressure matters.
- Use `gpt-5.4/low` for bounded, routine, low-risk tasks with explicit success
  criteria.

### Reasoning Effort

OpenAI states that GPT-5.5 defaults to `medium` reasoning effort and that
`medium` is the balanced starting point for quality, reliability, latency, and
cost.

- Start at `medium` for main assistants.
- Use `low` for latency-sensitive work that still needs tool use, planning,
  search, or multi-step decisions.
- Use `none` only for latency-critical tasks that do not need reasoning or
  multi-chained tool calls.
- Use `high` only when the task needs hard reasoning and latency matters less.
- Use `xhigh` only for the hardest asynchronous agentic tasks or evals that
  intentionally test the boundary of model intelligence.
- Do not make `high` or `xhigh` the default. Higher reasoning effort is not
  automatically better; OpenAI warns that weak stopping criteria, conflicting
  instructions, or open-ended tool access can cause overthinking, unnecessary
  searching, or output-quality regressions.

### GPT-5.3-Codex-Spark

Treat `gpt-5.3-codex-spark` as a strategic low-latency coding tier, not as a
replacement for frontier long-horizon execution.

OpenAI describes GPT-5.3-Codex-Spark as:

- a research preview;
- a smaller version of GPT-5.3-Codex;
- designed for real-time coding in Codex;
- optimized for near-instant interaction on low-latency hardware;
- strong for targeted edits, reshaping logic, and refining interfaces;
- text-only with a 128k context window at launch;
- governed by separate rate limits during the preview;
- lightweight by default: it makes minimal targeted edits and does not
  automatically run tests unless asked.

Use Spark when:

- the user is iterating interactively and latency matters more than maximal
  autonomy;
- the task is a small or medium targeted edit with clear files and acceptance
  criteria;
- you need quick alternatives, patch proposals, or focused local refactors;
- quota telemetry shows a separate Spark pool is available and standard Codex
  quota should be conserved.

Avoid Spark when:

- the task requires broad repo archaeology, long-horizon planning, or sustained
  autonomous execution;
- the work is security-critical, financial, migration-heavy, or contract-heavy
  without a stronger reviewer;
- the task needs image understanding or multimodal inputs;
- the expected completion requires automatic test selection and execution
  without explicit instructions.

If Spark is used for implementation, pair it with explicit instructions to run
or report the relevant verification steps, then have the root orchestrator or a
stronger reviewer validate the result before closure.

### Prop4You Assistant Defaults

For Prop4You/AionUI persistent assistants:

| Assistant type | Default | Escalate when |
| --- | --- | --- |
| Architect / governance | `gpt-5.5/medium` | ADR-critical or ambiguous cross-system decisions may use `gpt-5.5/high` |
| Backend engineer | `gpt-5.4/medium` or `gpt-5.5/medium` | complex migrations, query-shape risk, or cross-domain contracts |
| Frontend engineer | `gpt-5.4/medium` | complex Inertia/runtime contracts or design-system changes may use `gpt-5.5/medium` |
| Contract reviewer | `gpt-5.5/medium` | hard drift, hidden prop churn, or multi-surface contract failures |
| QA / forensic reviewer | `gpt-5.5/medium` | security, abuse, or high-risk closure may use `gpt-5.5/high` |
| PM / planning / docs | `gpt-5.4/low` or `gpt-5.4/medium` | broad planning synthesis may use `gpt-5.5/medium` |
| Spark lane | `gpt-5.3-codex-spark` | only for real-time targeted coding loops with explicit validation |

## One-Shot Tasks

```
terminal(command="codex exec 'Add dark mode toggle to settings'", workdir="~/project", pty=true)
```

For scratch work (Codex needs a git repo):
```
terminal(command="cd $(mktemp -d) && git init && codex exec 'Build a snake game in Python'", pty=true)
```

## Background Mode (Long Tasks)

Codex CLI has no native Hermes-style `delegate_task` equivalent. Treat each delegated Codex run as a CLI/process subagent that needs explicit polling, log review, and cleanup. Prefer foreground `codex exec` for bounded work; use background only when the task is long-running or genuinely parallel.

```
# Start in background with PTY
terminal(command="codex exec --full-auto 'Refactor the auth module'", workdir="~/project", background=true, pty=true)
# Returns session_id

# Monitor progress
process(action="poll", session_id="<id>")
process(action="log", session_id="<id>")

# Send input if Codex asks a question and the answer is safe/in-scope
process(action="submit", session_id="<id>", data="yes")

# Kill only after evidence of real stall, unsafe drift, or completed idle process
process(action="kill", session_id="<id>")
```

Polling discipline:

1. Record command, `session_id`, PID if available, worktree, branch, prompt, and expected output files.
2. Poll with `process(action="poll")`; read logs with `process(action="log")` when progress is unclear.
3. Check file progress independently: expected files, diffs, test artifacts, server logs.
4. Ping or submit safe input before declaring a long task stalled.
5. Kill only with evidence: no response to interaction, no file/log progress, no active tests/builds, or process/server deadlock/crash signs.
6. After completion or kill, collect final logs, terminate leftovers, and verify no orphan server/process remains.
7. Never treat Codex subagent output as approval; root/orchestrator verification remains mandatory.
```

## Key Flags

| Flag | Effect |
|------|--------|
| `exec "prompt"` | One-shot execution, exits when done |
| `--full-auto` | Sandboxed but auto-approves file changes in workspace |
| `--yolo` | No sandbox, no approvals (fastest, most dangerous) |

## PR Reviews

Clone to a temp directory for safe review:

```
terminal(command="REVIEW=$(mktemp -d) && git clone https://github.com/user/repo.git $REVIEW && cd $REVIEW && gh pr checkout 42 && codex review --base origin/main", pty=true)
```

## Parallel Issue Fixing with Worktrees

```
# Create worktrees
terminal(command="git worktree add -b fix/issue-78 /tmp/issue-78 main", workdir="~/project")
terminal(command="git worktree add -b fix/issue-99 /tmp/issue-99 main", workdir="~/project")

# Launch Codex in each
terminal(command="codex --yolo exec 'Fix issue #78: <description>. Commit when done.'", workdir="/tmp/issue-78", background=true, pty=true)
terminal(command="codex --yolo exec 'Fix issue #99: <description>. Commit when done.'", workdir="/tmp/issue-99", background=true, pty=true)

# Monitor
process(action="list")

# After completion, push and create PRs
terminal(command="cd /tmp/issue-78 && git push -u origin fix/issue-78")
terminal(command="gh pr create --repo user/repo --head fix/issue-78 --title 'fix: ...' --body '...'")

# Cleanup
terminal(command="git worktree remove /tmp/issue-78", workdir="~/project")
```

## Batch PR Reviews

```
# Fetch all PR refs
terminal(command="git fetch origin '+refs/pull/*/head:refs/remotes/origin/pr/*'", workdir="~/project")

# Review multiple PRs in parallel
terminal(command="codex exec 'Review PR #86. git diff origin/main...origin/pr/86'", workdir="~/project", background=true, pty=true)
terminal(command="codex exec 'Review PR #87. git diff origin/main...origin/pr/87'", workdir="~/project", background=true, pty=true)

# Post results
terminal(command="gh pr comment 86 --body '<review>'", workdir="~/project")
```

## Rules

1. **Always use `pty=true`** — Codex is an interactive terminal app and hangs without a PTY
2. **Git repo required** — Codex won't run outside a git directory. Use `mktemp -d && git init` for scratch
3. **Use `exec` for one-shots** — `codex exec "prompt"` runs and exits cleanly
4. **`--full-auto` for building** — auto-approves changes within the sandbox
5. **Background for long tasks** — use `background=true` and monitor with `process` tool
6. **Don't interfere** — monitor with `poll`/`log`, be patient with long-running tasks
7. **Parallel is fine** — run multiple Codex processes at once for batch work
8. **Do not assume prompt-only tool restrictions are enforced** — in environments with global MCP config, Codex CLI may auto-start configured MCP sidecars (e.g. GitHub, Stripe, Playwright, Chrome DevTools) even for local-only prompts. For strict bounded tool minimization, first find/use a no-MCP invocation path or choose a delegation mechanism with explicit toolsets. If sidecars appear, record the deviation, kill/retire the subagent when appropriate, and do not count it as approval without root verification.
