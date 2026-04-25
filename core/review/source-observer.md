# Source Observer

## Purpose

Use this review surface when external source material is read, monitored, or
converted into durable Accelerate evidence.

Examples:

- framework documentation drift checks
- provider docs research
- benchmark or competitive source intake
- design-system URL/source capture
- external workflow-learning evidence

## Rule

External source observation must be bounded, attributable, and safe.

Do not turn arbitrary web reading into hidden crawler behavior. Do not promote a
workflow rule from an external page unless the observation packet, source limits,
and downstream use are explicit.

## Activation

Activate this surface when a task needs to:

- read public URLs as evidence for a governed decision
- preserve external source content for later workflow review
- compare current local doctrine against provider/framework documentation
- feed URL content into design-system extraction
- propose recurring source monitoring

## Source Observer Packet

```text
Source Observer Packet
- source class:
- source URL(s):
- reason for observation:
- active adapter:
- allowlist / denylist decision:
- retention policy:
- downstream artifact:
- trust limits:
- privacy / ToS / robots notes:
- decision impact:
```

## Governance

- Use `adapters/runtime/web-content-reader/` for runtime capability boundaries.
- Pair with `untrusted-ingress-hardening` when raw HTML or externally sourced
  content is parsed, stored, transformed, or served.
- Pair with `security-patterns` when URL intake, SSRF-like risk, credentials, or
  private network exposure is plausible.
- Pair with `skill-evaluation-lab` when the observation may promote workflow
  doctrine.
- Pair with `extract-html-design-system-v2` only after URL/HTML source evidence
  has been captured and bounded.

## Closure Blockers

Do not close source-observer work if:

- the source URL was not recorded
- the source class and downstream use are unclear
- raw external content is stored without retention policy
- source trust limitations are missing
- URL intake bypasses allowlist/denylist policy
- recurring monitoring is implied but no budget/schedule/owner is named
- external content becomes workflow law without a durable observation packet
