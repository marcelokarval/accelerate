# Web Reader External Skill Replay Result

## Purpose

This artifact records the second independent external-skill replay after the
Z.ai / GLM harvest implementation.

It exercises the new local surfaces:

- `core/risk/external-skill-vetting-gate.md`
- `core/workflows/skill-evaluation-lab.md`

The target was intentionally not the previously implemented `agent-browser`
surface. The replay used the GLM / Z.ai `web-reader` skill to test whether the
new local process can vet another external capability without reconstructing the
whole framework manually.

## Runtime Packet

- `active branch`: external skill / adapter vetting
- `phase`: Frame -> Vet -> Evaluate -> Register
- `issue stack`: pre-adapter / no-backend exception; durable executive artifact
  used as registration
- `proof lane`: source inspection, vetting packet, skill-evaluation packet,
  insertion decision
- `single-threaded exception`: replay was read-only and judgment-heavy; no
  independent implementation slice existed

## Source

Inspected external artifact:

- `/home/marcelo-karval/Backup/Projetos/all-agrelli-projects/ht-agrelli-com-bot-telegram-dashboard/skills/web-reader/SKILL.md`
- `/home/marcelo-karval/Backup/Projetos/all-agrelli-projects/ht-agrelli-com-bot-telegram-dashboard/skills/web-reader/scripts/web-reader.ts`

## External Skill Vetting Packet

### Source

GLM / Z.ai `web-reader` skill.

### Capability

The skill provides web page content extraction through `z-ai-web-dev-sdk` and a
`z-ai` CLI `page_reader` function.

It covers:

- single URL extraction
- batch URL extraction
- content metadata
- article text extraction
- feed-like aggregation
- caching
- rate limiting
- parallel processing
- Express API wrappers
- scheduled content fetching through `node-cron`

### Runtime Powers

- outbound network fetches to arbitrary URLs
- provider/API execution through `z-ai-web-dev-sdk`
- optional CLI execution through `z-ai function`
- filesystem output when CLI `-o` is used
- scheduled recurring execution through `node-cron`
- raw HTML ingestion and transformation
- token/cost usage through provider metering
- possible persistent process lifetime when scheduled fetcher is started

### Platform Assumptions

- `z-ai-web-dev-sdk` is installed
- `z-ai` CLI exists
- backend JavaScript/TypeScript runtime is the implementation surface
- provider-owned `page_reader` function exists
- SDK credentials are configured outside the snippet
- examples use Express and Node conventions

### Useful Pattern

The useful pattern is not the Z.ai SDK. It is the capability shape:

```text
source allowlist
  -> bounded URL fetch
  -> content extraction
  -> metadata / freshness record
  -> cache / rate-limit / cost tracking
  -> durable observation result
```

This is relevant to future source-monitoring, research, documentation drift,
competitive intelligence, and external signal observer lanes.

### Unsafe Or Non-Portable Pattern

Do not import directly because:

- provider-specific SDK and CLI are assumed
- arbitrary URL ingestion can create SSRF-like risk in app contexts
- scheduled fetchers can run indefinitely without budget or issue registration
- raw HTML storage/display requires sanitization and privacy handling
- output files can accumulate sensitive scraped content
- examples do not enforce domain allowlists
- examples do not define robots.txt / ToS compliance as executable policy
- user-provided URLs in Express examples are not trust-boundary hardened
- token/cost usage is noted but not enforced as a blocker

### Decision

Decision:

- `pattern-only`

Reason:

- capability is valuable
- implementation is platform-bound
- risk posture is too broad for direct import
- the local architecture should preserve the pattern as a future source/content
  observer adapter, not as a copied Z.ai web reader

### Insertion Target

Immediate insertion:

- executive replay artifact only

Candidate future insertion:

- `adapters/runtime/web-content-reader/README.md`
- or `core/review/source-observer.md` if recurring source monitoring becomes a
  first-class proof/research lane

### Proof Needed

Before a future adapter lands:

- URL allowlist / denylist policy
- network egress and SSRF risk posture
- auth/paywall/robots/ToS policy
- raw HTML sanitization and storage policy
- cache retention and deletion policy
- provider-cost budget
- scheduled run budget
- durable observation packet shape

## Skill Evaluation Lab Packet

### Target

Evaluate whether the new local external-skill replay process can classify a
second external artifact without turning it into blind import or workflow bloat.

### Hypothesis

The local process should:

- preserve useful external capability
- reject platform-specific import
- name runtime powers and trust risks
- choose a proportional insertion target
- avoid mutating core doctrine before proof

### Baseline

Before the GLM-harvest implementation, the local platform had:

- generic self-evolution durable capture
- generic governance/risk principles
- no explicit external skill vetting gate
- no explicit skill-evaluation lab
- no named decision vocabulary for direct-import / pattern-only / sandbox /
  reject

### Candidate

After the GLM-harvest implementation, the local platform has:

- external skill vetting packet
- capability preservation rule
- explicit decision semantics
- skill evaluation lab packet
- anti-bloat rule
- durable result expectation

### Eval Prompts

Representative prompts:

- "Can we import this Z.ai `web-reader` skill into accelerate?"
- "Can this become a scheduled observer?"
- "What is the safe local equivalent of page extraction?"
- "Should this mutate core workflow doctrine now?"

### Assertions

| Assertion | Result |
| --- | --- |
| identifies provider/platform lock-in | pass |
| identifies runtime/network powers | pass |
| identifies trust and abuse risks | pass |
| preserves useful capability | pass |
| rejects direct import | pass |
| avoids immediate core workflow mutation | pass |
| leaves durable decision artifact | pass |

### Rubric

The candidate process is better if it:

- is more specific than generic governance
- blocks unsafe import
- preserves useful capability instead of rejecting everything
- produces a reusable future insertion target
- keeps self-evolution promotion conservative

### Blind Comparison

Blind comparison was not run with separate anonymous outputs in this replay.

Reason:

- the goal was to exercise the new local process end-to-end, not to compare two
  generated answers
- the earlier post-implementation benchmark already compared local and legacy
  behavior on the GLM-harvest stimulus

Residual gap:

- a future replay should use two independent generated outputs and a blind
  comparator to fully exercise this lab's comparator contract

### Analyst Pass

The candidate local process performed materially better than the pre-harvest
baseline for this replay.

It did not merely say "be careful with external dependencies." It produced a
layered decision:

- `web-reader` as direct import: rejected
- web content extraction as capability: preserved
- scheduled source monitoring: possible future observer
- immediate doctrine mutation: rejected
- future adapter: possible after additional proof

### Cost / Time Notes

The replay was document-only and did not invoke external network fetches or the
Z.ai SDK.

### Decision

Decision:

- candidate process passes this replay
- do not promote broad self-evolution yet
- do not add a new runtime adapter yet
- use this as the second behavioral proof input for the next parity judgment

## Result

The local replay succeeded as a behavioral exercise of the new lanes.

It proved the new surfaces can classify an independent external skill into a
bounded `pattern-only` decision with concrete future insertion criteria.

It did not prove:

- browser/UI polishing runtime execution
- real scheduled observer execution
- blind comparator output quality
- future `*.toml` agent behavior

## Effect On Parity

This result strengthens the case that `autoresearch / self-evolution` is moving
from passive capture toward executable learning behavior.

Recommended next verdict to test:

- `autoresearch / self-evolution`: candidate for `local at parity`

Reason:

- first external workflow-learning event was captured
- first implementation pass landed native lanes
- first post-implementation benchmark found specific GLM-harvest capability
  `local ahead`
- second independent external replay now exercised the new lanes without core
  mutation or blind import

The next step should be a focused local-vs-legacy parity judgment for the broad
self-evolution surface using this replay as evidence.

## AI Review Report

### Self-Review

The replay stayed bounded. It did not add a new adapter prematurely and did not
claim that Z.ai `web-reader` itself should be imported.

### Self-Forensic Review

Main risk:

- over-counting a document-only replay as full runtime proof

Mitigation:

- result is limited to external-skill vetting / skill-evaluation behavior
- future adapter and scheduled observer proof remain explicitly unproven
