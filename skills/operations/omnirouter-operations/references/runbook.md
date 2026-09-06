# OmniRoute Operations Runbook

## Authorized LAN Binding

The production listener at `0.0.0.0:20128` is deliberate in this Karval environment:
the host is an authorized private-LAN backend for remote Hermes Desktop clients. Do not
rebind it to loopback or flag it as a defect solely because it is not `127.0.0.1`.
Require login/authentication and preserve the operator-owned LAN/firewall boundary; this
does not authorize Internet exposure. Use loopback URLs for same-host probes.

## 1. Runtime Truth

```bash
omniroute --version
systemctl --user show omniroute.service \
  -p ActiveState -p SubState -p MainPID -p NRestarts -p ExecStart -p FragmentPath
curl --fail --silent --show-error http://127.0.0.1:20128/api/health
journalctl --user -u omniroute.service --since "2 hours ago" --no-pager
```

Confirm the exact installed package/version and service launcher. Never use a moving branch or `--latest` as stable authority.

## 2. Safe Management Readback

Use an authenticated dashboard session or management API without printing credentials. Capture only reduced, non-secret fields from:

```text
GET /api/settings
GET /api/settings/compression
GET /api/settings/memory
GET /api/resilience
GET /api/rate-limits
GET /api/providers
GET /api/storage/health
GET /api/tools/traffic-inspector/capture-modes
```

Do not persist raw provider responses.

## 3. Backup

Before mutation, prefer the supported backup API only after it is live-qualified. OmniRoute 3.8.50 has a known contract mismatch where `POST /api/db-backups` is documented as create but can require `backupId`.

Safe local fallback: use Python `sqlite3.Connection.backup` from `~/.omniroute/storage.sqlite` into the task stack, mode `0600` under a `0700` directory. Run `PRAGMA quick_check`, record SHA-256, and preserve the exact file as rollback material. Do not copy a live SQLite file with plain `cp`.

## 4. Endpoint Input-Integrity Gate

Generic OpenAI-compatible critical clients and all frozen benchmarks send:

```http
X-OmniRoute-Compression: off
X-OmniRoute-No-Cache: true
X-OmniRoute-No-Memory: true
```

Global CCR remains disabled. Record response compression/cache annotations and token counts; HTTP 200 alone is not acceptance.

## 5. Supported Mutation

- `PATCH /api/settings` for general fields.
- `PUT /api/settings/compression` for compression settings.
- `PUT /api/settings/memory` for memory settings.
- `PATCH /api/resilience` for resilience settings.
- Traffic Inspector capture-mode APIs for its listener/modes.

Send the smallest partial object. Immediately read back the complete affected denominator. Avoid direct SQLite writes.

A settings-only mutation does not imply service restart. Restart only if live readback/canary proves the owner process did not apply the change or the API explicitly reports restart required.

## 6. Routing and Tool Proof

For each governed alias:

1. enumerate alias/members and effective order;
2. issue a synthetic no-cache/no-memory/no-compression request requiring a small tool call;
3. record alias, requested/effective model, attempt count, tool-call presence, latency and status;
4. prove fallback with a supported non-secret mechanism—never by corrupting a credential;
5. confirm failover occurs before retry and no completed response is duplicated.

Expected Karval alias intent may evolve; always read the live Combo definition. Historical expectations are not runtime truth.

### 6A. Web-provider qualification lane (mandatory)

This lane is mandatory for any provider whose effective transport is a browser, web session, scraping/web bridge, or otherwise rate-limited interactive web upstream. It applies even when the provider is accessed through the local OpenAI-compatible endpoint.

1. **One provider, one active wave.** Do not run capability groups (for example 1–4, 5–8 and 9–12) concurrently against a web provider. Do not combine a web-provider qualification with any other provider load test.
2. **Serial default.** Send one request at a time. Do not raise concurrency until a completed short-canary wave supplies evidence of stable provider and gateway health; a web qualification never uses more than two in-flight requests, and two requires an explicit recorded reason.
3. **Ramp by cost.** Run two short text canaries first, checkpoint them, then run the remaining short tests. Long-context, streaming, repeat-consistency, upload, image, audio and other expensive probes are separate subwaves and begin only after a fresh health plus short-canary readback.
4. **Stop, do not amplify.** Immediately stop scheduling new requests after any HTTP 429, connection/timeout, a provider 5xx, or a health probe that fails to return HTTP 200 within its bounded timeout. Preserve completed receipts, mark unfinished rows as not_run_due_to_web_lane_stop, and do not call them unsupported.
5. **Recovery gate.** There is no automatic retry storm. Resume only from a clean queue after a fresh gateway health readback and one serial, isolated short sentinel succeeds. Keep the prior failed receipts and record the incident interval; never overwrite them.
6. **Worker design.** Persist one redacted structured receipt per completed request atomically (requested/effective ID where available, status, latency, error class, controls and output hash). A killed worker must leave a resumable queue and must not discard partial evidence.
7. **Controls.** Every critical request still sends compression off, no-cache and no-memory headers; its credential comes only from the governed environment source and is never logged or put in process arguments.

The root/orchestrator owns this gate. A worker must not substitute a fallback provider, retry in parallel, restart OmniRoute, alter provider settings, or continue an expensive subwave after the stop condition.

### 6B. Web serial-per-model battery (mandatory baseline)

For a complete capability battery on a web provider, qualify one requested model
route at a time. The unit of execution is `provider + requested model`, never a
parallel capability column across all models.

1. Read fresh health and the provider catalog, freeze the requested IDs and
   declared context-window metadata before the first request.
2. For each model, run a short direct admission sentinel first (for example,
   exact `2+2 -> 4`). Only then run points 1 through 12 in their documented
   order. Point 11 retains its three serial repetitions and point 12 its two
   serial controls.
3. There is exactly one in-flight provider request. Persist an atomic,
   redacted receipt before scheduling the next point. Include requested and
   effective model when returned, declared and observed context data, status,
   latency/TTFT where applicable, rubric status, error class and isolation
   controls.
4. Insert a short bounded cooldown after every completed request and a fresh
   health check before changing model. The scheduler must implement the wait
   without busy-looping; no parallel request may be released during it.
5. A stop condition in 6A ends the current provider wave immediately. Mark all
   remaining points and models as not run due to web lane stop; preserve the
   completed rows. Resume only through the 6A recovery gate.
6. Report a provider-specific full table and update the global condensed table
   only from completed, reviewed rows. Do not borrow availability, context,
   latency or capability results from another provider.

This is the required reusable baseline for subsequent web-provider tests.

### 6C. Deterministic-battery executor policy (all providers)

This policy applies to every model/provider qualification battery, independent
of transport (web, OAuth, API, CLI), execution cadence (serial or parallel) or
modality.

1. **Default executor: Luna/medium.** A deterministic, pre-frozen battery is
   executed by a Luna/medium worker. This is a normative local harness default
   under active root authority, not an empirical capability conclusion from
   archived model-role research. Its role is mechanical only: run the approved
   queue, persist receipts and obey stop/recovery gates.
2. **Root and review remain Terra/Sol.** Terra owns hardening, denominator,
   prompt/rubric freeze, operational gates, evidence reconciliation and
   micro-review. Sol is reserved for macro review at Wave closure. Neither is
   the default bulk-request executor.
3. **No semantic improvisation.** The executor must not alter prompts, tool
   schemas, files, model IDs, controls, retry policy, routing or pass/fail
   rubric. Any ambiguity is returned to Terra/root before the next request.
4. **Exception receipt.** A different executor requires a recorded reason:
   Luna unavailable, a capability unavailable to Luna, or a bounded task that
   genuinely needs non-mechanical judgment. Agy/local CLI may be selected only
   through such an explicit receipt; it never changes the test subject.
5. **No mid-Wave swap.** Do not replace an executor while a provider/model
   battery is active. Finish or stop the current Wave, preserve its receipts,
   then start a fresh Wave with the selected executor and comparable controls.

The executor choice affects operational cost and harness reliability; it does
not qualify or disqualify the provider/model being tested.

## 7. Traffic Inspector Proof

Follow `traffic-inspector.md`. Enable credential redaction before starting the explicit HTTP proxy. Keep system proxy, TLS intercept and custom hosts off. Use a synthetic fake secret canary, prove the literal is absent, and clear the canary capture.

## 8. Antigravity/`agy`

Follow `provider-antigravity-agy.md`. CLI model discovery does not prove OmniRoute connection health. Do not admit an inactive or expired `agy` connection to an alias.

## 9. Rollback

Rollback triggers:

```text
health failure
settings readback mismatch
credential/redaction failure
prompt-integrity failure
alias or tool regression
unexpected cache/memory injection
fallback duplication or loop
Traffic Inspector invasive mode enabled unexpectedly
```

Restore through the supported database restore path when qualified. If using the SQLite backup, stop only the `omniroute.service` owner, preserve the failed current file, restore the validated backup with correct mode/ownership, restart, and rerun health/settings/models/tool/fallback proof.

## 10. Closure Evidence

```text
version/service/PID/restarts
backup path/hash/quick_check
pre/post reduced settings
provider and alias denominator
focused endpoint/tool/fallback results
Traffic Inspector mode/redaction result
recent warning/error window
skill validation and cross-client parity
rollback target and residuals
```
