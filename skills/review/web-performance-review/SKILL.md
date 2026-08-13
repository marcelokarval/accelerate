---
name: web-performance-review
description: Review web performance with explicit quick-static or deep-measured modes and source-labelled evidence. Use when assessing loading, interaction, rendering, network, bundle, or Core Web Vitals risk; when interpreting CrUX, Lighthouse, or browser traces; or when performance opportunities must be reported honestly without fabricated metrics.
---

# Web Performance Review

Choose one evidence mode and label every metric by source. Unmeasured
opportunity is not an observed regression, and a synthetic result is not field
user experience.

## Select the Mode

- `quick-static`: inspect code, assets, network design, loading strategy, and
  existing artifacts. Report numerical metrics as `unavailable` unless a valid
  cited artifact already exists.
- `deep-measured`: collect or inspect authorized measurements with reproducible
  environment, URL/build identity, timestamp, device/network conditions, and
  tool/version metadata.

Start quick-static when runtime access, stable build, consent, representative
traffic, or measurement tooling is unavailable. Do not upgrade a static
inference into measured evidence.

## Workflow

1. Read accepted performance goals, user journeys, architecture, and baseline.
2. Identify the exact page, build, device class, environment, and time window.
3. Select quick-static or deep-measured and record why.
4. Inspect loading, rendering, interaction, network, caching, fonts, images,
   scripts, third parties, hydration, and long-task risks.
5. In deep-measured mode, classify evidence sources using
   [measurement-sources.md](references/measurement-sources.md).
6. Correlate metrics with a reproducible behavior or trace before confirming a
   finding.
7. Propose the smallest change that addresses the evidenced bottleneck and
   name the proof needed after correction.

Route functional flow truth, DOM behavior, and visual acceptance to the browser
QA authority. This skill owns performance evidence only and does not absorb
browser QA acceptance.

Use the existing `product-browser-qa` catalog group with
`product-runtime-review` for live browser truth and `dogfood` for exploratory
QA/issue capture. Web performance remains the owner only of source-labelled
performance evidence.

## Metric Honesty

- `CrUX` is field data aggregated from eligible real-user Chrome experience.
- `Lighthouse` is a controlled lab run whose environment must be recorded.
- A browser `trace` explains main-thread, network, rendering, and interaction
  timing for a captured run.
- Application telemetry is only comparable when definition, sampling, and
  population are stable.
- Static bundle or source inspection yields opportunities, not observed Core
  Web Vitals.

Never combine sources into a single unlabeled number. Never invent a baseline,
percentile, score, timestamp, or improvement. Mark missing data `unavailable`
or `unmeasured` and state the measurement needed.

## Review Dimensions

- navigation and server response;
- critical resources, cache policy, compression, and priority;
- JavaScript cost, hydration, long tasks, and interaction latency;
- image, font, CSS, and layout stability;
- third-party cost and failure isolation;
- representative mobile/desktop and warm/cold conditions;
- accessibility or correctness regressions from proposed optimization;
- observability and post-change comparison plan.

Use [report-schema.md](references/report-schema.md) for the return.

## Boundaries

- Stay read-only unless remediation is explicitly assigned elsewhere.
- Do not run expensive or production-impacting measurements without authority.
- Do not present one lab run as universal user impact.
- Do not recommend removing correctness, security, accessibility,
  compatibility, observability, or rollback guards for speed.
- Do not use a universal score threshold as closure authority.

## Return Contract

Return:

- mode and selection reason;
- reviewed journey, build, environment, device/network, and time window;
- source-labelled metrics, with unavailable fields explicit;
- static opportunities separated from confirmed findings;
- reproduction, confidence, impact, correction, and required remeasurement;
- self-review, self-forensic review, defects, residual risk, and root boundary.

## Verification

- Mode is exactly quick-static or deep-measured.
- Every number names CrUX, Lighthouse, trace, telemetry, or another exact source.
- Deep measurements include reproducibility metadata.
- Quick-static reports absent runtime metrics as unmeasured.
- Conclusions do not exceed the population or environment observed.
