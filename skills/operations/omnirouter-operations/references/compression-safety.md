# OmniRoute Compression Safety and Request Contract

## Production-safe default

For ordinary OpenAI-compatible chat/completions or responses calls that do not
implement an authenticated same-turn retrieval loop, send all three headers:

```http
X-OmniRoute-Compression: off
X-OmniRoute-No-Cache: true
X-OmniRoute-No-Memory: true
```

Use the API key only in the process environment or an in-memory request header.
Never print it, persist it in receipts, or invoke verbose HTTP logging.

`X-OmniRoute-Compression: off` is the explicit input-integrity control. The
other two headers isolate semantic-cache replay and memory injection so a test
measures the frozen prompt rather than prior state.

## CCR restriction

CCR replaces large text blocks with a marker such as:

```text
[CCR retrieve hash=<hash> chars=<N>]
```

The active OmniRoute 3.8.50 runtime preserves the full block in a principal-scoped
in-process store when CCR is eligible. Version 3.8.50 prevents CCR compression when
the caller does not advertise the retrieval tool, but that fix does not make CCR a
transparent universal compressor. A client that advertises retrieval capability still
must complete the authenticated same-turn `omniroute_ccr_retrieve` loop and return
the retrieved block to the model turn.

Therefore:

- keep global `engines.ccr.enabled=false` for generic endpoint clients;
- keep `relevance` disabled for complex architectural/governance prompts unless a
  task-specific semantic-retention gate proves it safe; on the frozen Prompt B it
  reduced actual prompt tokens from 827 to 246 and the rubric score from the
  90–100 range to 42;
- do not treat a CCR marker, HTTP 200, or `finish_reason=stop` as success;
- permit CCR only in an isolated capability test that proves marker creation,
  authenticated retrieval, same-flow reinjection, and semantic completion;
- fail closed or preserve the original text when retrieval is unavailable.

## Supported compression override grammar

The request header supports:

```text
off

default
engine:<enabled-engine-id>
<named-combo-id-or-name>
```

`engine:<id>` selects that engine only when it is enabled in the current global
engine map. An unrecognized or disabled engine falls through to normal plan
resolution; the response echo alone does not prove the engine ran. Read back
the global settings and inspect the response compression annotation.

## Global disable invariant

`defaultMode=off` is insufficient when explicit engines remain enabled. For an
unambiguous production-off state require:

```text
enabled=false
defaultMode=off
activeComboId=null
engines.ccr.enabled=false
outputStyles=[]
```

Engine configuration may remain stored for explicit future qualifications, but no
implicit compressor may run. For every benchmark, retain the three request headers
because they also isolate cache and memory.

## Required receipt

For every benchmark or qualification request, record only non-secret data:

```text
prompt_sha256
requested_model
effective_model
requested_compression_header
response_compression_header
cache_status
http_status
prompt_tokens
completion_tokens
output_sha256
contains_ccr_marker
latency
```

Acceptance requires:

- the response compression source matches the requested control;
- cache is `MISS` or `BYPASS`, never an unexplained `HIT`;
- prompt tokens remain inside the frozen expected range;
- no CCR marker is present unless CCR retrieval is the explicit test subject;
- the output satisfies the semantic rubric, not merely transport success.

## Compressor experiment method

1. Freeze prompt, model, decoding parameters, timeout and scoring rubric.
2. Discover engines from authenticated `GET /api/compression/engines`.
3. Snapshot global settings from `GET /api/settings/compression`.
4. Keep CCR globally disabled outside its isolated negative/capability control.
5. Test sequentially with no-cache and no-memory:
   - implicit global default;
   - explicit `off`;
   - each discovered engine in isolation, enabling it temporarily through the
     official settings API only when required;
   - each documented intensity/config variant where the engine exposes one;
   - each operator-defined named combo; do not invent comma-separated or
     exponential subset headers because the protocol does not support them.
6. For Caveman/RTK, update both the engine toggle/level and the corresponding
   `cavemanConfig`/`rtkConfig`; for Ultra and Responses, enable the dedicated
   `ultra.enabled`/`codexResponsesConfig.enabled` gate. A toggle or echo without
   these gates can be a no-op or fallback.
7. Distinguish registry presence from request selectability. An engine returned by
   `/api/compression/engines` may be absent from the settings catalog and therefore
   impossible to select through `engine:<id>`; record that as a control-plane gap.
8. Restore the frozen global settings after every temporary engine/config
   mutation and verify readback.
9. Stop on service degradation, secret risk, failed rollback, or input-integrity
   failure.

A single-engine request may still report `mode=stacked` when that engine is
stackable; verify the pipeline/engine breakdown rather than inferring from the
mode label alone.
