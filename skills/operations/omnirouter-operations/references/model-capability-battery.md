# Model Capability Battery Contract

Use this contract to qualify a specific requested route under a frozen,
versioned battery. It measures evidence for that configuration; it does not
establish a general model capability, current availability, or routing policy.

## Freeze before dispatch

Create a redacted manifest using
`assets/capability-battery-manifest.schema.json`. Freeze its battery version,
catalog snapshot identifier, planned canonical slots, rubric versions, input
SHA-256 values, controls, and requested route/configuration. A slot is one
capability assertion under one declared input and rubric. Slots may cover text,
structured output, vision/OCR, audio, image generation, long context, tool
protocol, reasoning, or stability, but no fixed category set is universal.

Record the requested model separately from `effective_model`. An echoed route
or model ID only supports gateway binding; it is not downstream, modality, or
semantic success. A catalog entry proves neither a connection nor a callable
model. A connection state proves neither catalog visibility nor capability.

Use declared controls (for example isolation headers, serial web-provider
dispatch, timeout, client version, and no-cache/no-memory policy) consistently.
Controls are observations and reproducibility aids, not proof by themselves.

## Evidence and statuses

Retain one redacted evidence record for every attempt. Canonical statuses are:

| Status | Meaning |
|---|---|
| `pass` | transport, binding, and frozen semantic rubric passed |
| `semantic_fail` | request completed but failed the declared rubric |
| `transport_fail` | no usable completed response (including timeout/network) |
| `protocol_fail` | response violated the declared API/output contract |
| `not_run` | deliberately not attempted; state the reason |
| `inconclusive` | evidence cannot decide the rubric |

Do not overwrite a failed record with a recovery. A retry gets a new monotonic
attempt number for the same slot and retains all prior records. The manifest
must represent every planned slot, including `not_run` after a stop condition.
Never silently treat a uniform HTTP 400 as proof that every model lacks a
capability: it may be a shared request, endpoint, account, or gateway fault.

Interpret modalities from their actual output and rubric: a text description is
not image generation; gateway TTS/STT fallback is not native model support;
OCR-like text is not broad visual understanding. Preserve the response digest,
content-type, parsed semantic verdict, and redacted artifact locator where
applicable. Do not retain raw prompts, bodies, headers, tokens, cookies, or
authorization values.

## Ranking and report

Rank only comparable, completed slots with the same frozen rubric and controls.
Show coverage and status counts next to any score. Keep provider-local and
global views distinct, retain ties/unknowns, and state that a low denominator,
alias convergence, retries, provider incidents, cost uncertainty, or changed
configuration limits comparison. Never convert a score into promotion.

Run the offline validator before rendering:

```bash
python3 scripts/validate_capability_battery.py --manifest manifest.json --receipt-out validation.json
python3 scripts/render_capability_report.py --manifest manifest.json --validation-receipt validation.json --out-dir report
```

The validator uses heuristic secret detection plus schema and bounded-field
constraints; it is not a mathematical redaction guarantee. It rejects
secret-shaped raw fields, missing planned slots, invalid input hashes, duplicate
attempts, and retry histories that hide a prior result. The renderer freshly
validates the manifest and checks the matching receipt before rendering;
it writes its Markdown report below the explicit output directory. Include the
manifest digest, validator receipt, frozen denominator, per-slot attempts,
requested/effective distinction, controls, limitations, and redacted artifact
locators in the final report.
