# Durable Learning Registration Gate

## Purpose

This gate decides whether a learning may stay transient or must be preserved
before closure.

## Rule

Do not leave repeated, cross-session, or high-impact workflow truth trapped in
commentary only.

When a run produces durable workflow truth, leave a visible registration
disposition before closure:

- ephemeral
- candidate for promotion
- durably registered

## Minimum Evidence

When local workspace state exists, use:

- `.accelerate/status/learnings.jsonl`
- the current closure packet
- the active governing artifact when a stronger home already exists

## Failure Conditions

Treat the gate as failed when:

- a repeated or high-impact learning exists but no disposition is visible
- closure is claimed while durable learning is still transient
- a learning is promoted narratively without any durable artifact
