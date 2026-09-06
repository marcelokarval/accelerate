# Traffic Inspector — Internal Solo-Developer Operating Contract

## Intended Mode

Karval operates OmniRoute on an authorized private machine/network with a solo developer. Traffic Inspector is a **dangerous, explicit diagnostic control**. On OmniRoute 3.8.50 it must remain stopped by default and be started only for a bounded investigation, because leaving `:8080` running produced a `ProxyFetch localhost:8080` warning storm. A controlled restart stopped the listener and eliminated warnings.

This authorization does not imply system-wide interception, TLS MITM, public exposure, unrestricted retention, automatic replay, or permanent listener availability.

## Target State

```text
credentialRedactionEnabled=true
httpProxy.running=false by default; true only during a bounded capture
httpProxy.port=8080 while active
systemProxy.applied=false
tlsIntercept.enabled=false
customHosts.enabledCount=0
recording session=none unless a bounded investigation is active
```

Use explicit client routing:

```text
HTTP_PROXY=http://127.0.0.1:8080
HTTPS_PROXY=http://127.0.0.1:8080
```

Prefer setting these only for the process under investigation. Do not apply OS-wide proxy settings merely because the listener is available.

## Redaction Boundary

`credentialRedactionEnabled` activates OmniRoute's credential masker guardrail for payloads/responses. Prove it with synthetic fake credentials, never real ones. Verify the captured record does not contain the synthetic secret literal.

Redaction is defense in depth, not permission to export raw customer traffic. Captured prompts and responses can still contain PII or business data that are not credentials.

## Capture Tiers

1. **Available/on-demand:** HTTP proxy stopped; API/UI available.
2. **Bounded investigation:** start the listener and a named session, route one process, reproduce, stop session and listener.
3. **HAR export:** only to a restricted local task artifact after redaction inspection.
4. **TLS interception/custom hosts/system proxy:** separately scoped, normally forbidden.

## Replay

`POST /requests/{id}/replay` creates a new provider call and can duplicate cost or side effects. Never replay by default. Require explicit request-level scope and an idempotent/synthetic payload.

## Retention and Cleanup

- In-memory buffer has a bounded UI capacity; clear after a sensitive investigation.
- Recording sessions are durable evidence; stop promptly and delete when no longer required.
- HAR files are sensitive. Store under a `0700` task directory with `0600` files and exclude from public/sync boundaries.
- Reports contain metadata only: IDs, host, status, timing, route, redaction verdict.

## Canary

1. Enable credential redaction through `PATCH /api/settings`.
2. Start HTTP proxy with `POST .../capture-modes/http-proxy` and `{"action":"start"}`.
3. Read back modes; system proxy/TLS intercept/custom hosts remain off.
4. Route a synthetic local HTTP request containing a fake bearer value through `:8080` to an approved local endpoint.
5. Retrieve the capture and assert the literal fake value is absent.
6. Clear the synthetic record.
7. Verify health, port ownership and recent logs.

If the proxy does not persist across OmniRoute restart, document it as an attended runtime control or add a separately reviewed owner-safe startup mechanism; do not silently add a daemon wrapper.

## Rollback

```json
{"action":"stop"}
```

Then verify port 8080 closed, system proxy/TLS intercept still off, and no active recording session remains.
