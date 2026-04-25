# Web Content Reader Runtime Adapter

This adapter owns governed one-shot reading of external web content for
Accelerate workflows.

It is not a copied `web-reader` implementation. It preserves the useful pattern
from external replay evidence while removing provider, CLI, scheduler, and
platform lock-in.

## Capability Inventory

This adapter may support:

- one-shot URL content capture
- rendered or non-rendered HTML capture when the active runtime supports it
- readable text extraction
- metadata and freshness recording
- bounded cache use
- source observation packets for research, docs drift, design-system intake, or
  workflow self-evolution

This adapter does not yet authorize:

- recurring scheduled fetching
- arbitrary user-submitted URL ingestion in product code
- authenticated/paywalled source access
- persistent crawler processes
- raw HTML serving back to users
- provider-specific SDK or CLI dependence

## Safety Boundary

External web content is untrusted ingress.

Before any implementation of this adapter can fetch a URL, it must define:

- source allowlist and denylist policy
- network egress and SSRF posture
- redirect handling
- private IP, localhost, link-local, metadata service, and internal hostname
  rejection
- timeout, size, and content-type limits
- robots.txt / ToS policy
- HTML sanitization and raw-content storage policy
- cache retention and deletion policy
- provider or token-cost budget when a provider is used
- observation packet shape

## Evidence Shape

Every successful read should produce a durable observation packet:

```text
Web Content Observation Packet
- source URL:
- source class: docs | vendor docs | public article | benchmark | other
- allowlist decision:
- fetch mode: static | rendered | tool-provided
- timestamp:
- final URL after redirects:
- content type:
- content length / bounded reason:
- extracted title:
- extracted text summary:
- cache key / retention:
- trust limitations:
- downstream use:
```

## Failure Handling

Fail closed when:

- the URL is not allowlisted
- DNS, redirect, or final URL enters a denied network range
- content exceeds size or time limits
- content type is unsupported
- robots/ToS policy blocks use
- auth, cookies, or personal data would be required
- extracted content cannot be sanitized for the downstream use

## Relationship To Existing Runtime Surfaces

- `webfetch` or browser tools may provide a one-shot implementation mechanism.
- `dogfood` remains for exploratory browser QA of applications.
- `extract-html-design-system-v2` remains the design-system extraction skill;
  this adapter can feed it captured source evidence.
- `native-mcp` and `mcporter` remain MCP/tool integration surfaces, not web
  observation policy.
- Playwright remains persistence/regression proof, not a crawler.

## Scheduled Observer Boundary

Recurring observation is a separate capability. Do not add cron, daemon, or
scheduled fetch behavior to this adapter without a workflow-change approval,
budget policy, storage policy, and explicit source-observer contract.
