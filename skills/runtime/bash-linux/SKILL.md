---
name: bash-linux
description: Codex-native Bash and Linux shell patterns for safe inspection, automation, and project-aligned command-line workflows.
user-invocable: true
related-skills: python-pro
---

# bash-linux

Use this skill for shell usage, small scripts, file inspection, and pragmatic
Linux/macOS command-line workflows.

## Purpose

Provide safe, readable shell patterns aligned with the way this Codex session
operates.

## Load When

Load this skill when the task touches:

- shell commands
- log inspection
- small Bash scripts
- environment inspection
- developer workflow automation

## Core Rules

1. Prefer `rg` for search when available.
2. Keep shell commands readable and purpose-specific.
3. Avoid destructive commands unless explicitly requested.
4. Use strict shell options in scripts when appropriate.
5. Match project command conventions, including `uv run ...` for Python.
6. In this repo, never suggest or run raw `python`, `pytest`, `pip`, or
   `source .venv/bin/activate` when `uv run` / `uv sync` is the correct path.

## Codex-Specific Guidance

- Prefer parallel reads through the available tool layer rather than forcing
  complex shell pipelines when the tools already support concurrency.
- Avoid unreadable chained commands if the output will be hard to interpret.

## Review Checklist

- Is there a simpler shell command?
- Is the command safe for the current workspace?
- Does it match project conventions?
