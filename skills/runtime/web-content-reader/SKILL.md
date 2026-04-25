---
name: web-content-reader
description: Governed Accelerate runtime skill for bounded external URL/content observation, source evidence packets, and safe web-content intake without provider lock-in or crawler behavior.
---
# Web Content Reader

Use this skill when Accelerate needs to read or preserve external web content as
evidence for research, documentation drift, design-system source intake,
benchmark review, or workflow self-evolution.

This skill is the repo-local adaptation of the useful `web-reader` pattern. It
does not import external `web-reader` code, Z.ai SDKs, provider CLIs, Express
wrappers, cron jobs, or unbounded fetching behavior.

## Activation

Use when the user asks to:

- read one or more public URLs as evidence
- compare local doctrine against live provider/framework docs
- capture a URL for design-system extraction
- build a durable source-observation packet
- evaluate whether recurring source monitoring should exist

Do not use for:

- exploratory QA of a web application; use `dogfood`
- design-system extraction itself; use `extract-html-design-system-v2` after
  source capture
- MCP setup; use `native-mcp` or `mcporter`
- persistent crawling or cron behavior; this requires a separate approved
  observer contract

## Required Reading

Before implementation or durable recommendation, read:

- `adapters/runtime/web-content-reader/README.md`
- `core/review/source-observer.md`
- `core/risk/external-skill-vetting-gate.md` when adapting external tooling

## Protocol

### 1. Classify Source

Name the source class:

- official docs
- provider docs
- public article
- public benchmark/reference
- competitor/public website
- user-provided URL
- unknown

Unknown and user-provided URLs require stronger allowlist and SSRF review.

### 2. Bound The Read

Before reading, define:

- allowlist/denylist decision
- maximum URL count
- timeout and size expectations
- redirect policy
- content types allowed
- whether rendered browser capture is required
- whether raw HTML may be stored

### 3. Preserve Evidence

Leave a `Web Content Observation Packet` or `Source Observer Packet` with:

- source URL and final URL
- timestamp
- fetch mode
- extracted title or summary
- trust limitations
- downstream use
- retention policy

### 4. Fail Closed

Stop and report a blocker if:

- the source is not allowlisted
- the URL resolves or redirects to private/local/internal network ranges
- auth, cookies, or private data are required
- content exceeds limits
- robots/ToS policy blocks the intended use
- raw content would be stored without retention policy

## Closure Blockers

Do not close if:

- external content influenced a governed decision but no observation packet exists
- recurring monitoring was implied but not explicitly scoped and approved
- provider-specific implementation details were copied into Accelerate
- URL intake skipped SSRF/network boundary review
- cache, retention, or deletion policy is missing
- the result claims source freshness without timestamp or final URL evidence

## Relationship To Web Reader Replay

The external replay classified the old `web-reader` capability as
`pattern-only`. Preserve the pattern:

```text
source allowlist
  -> bounded URL fetch
  -> content extraction
  -> metadata / freshness record
  -> cache / rate-limit / cost tracking
  -> durable observation result
```

Reject direct import of provider-bound code.
