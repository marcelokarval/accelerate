# Threat Review Contract

## Context

- assets and security objectives;
- actors, identities, roles, tenants, and privilege levels;
- entrypoints, data flows, stores, processes, and external providers;
- trust boundaries and privilege transitions;
- dependencies, build inputs, artifacts, and deployment provenance.

## STRIDE Matrix

| Category | Questions |
| --- | --- |
| Spoofing | Can identity, origin, signature, token, or provider be impersonated? |
| Tampering | Can input, state, message, artifact, or audit evidence be altered? |
| Repudiation | Is an attributable, integrity-protected audit trail available? |
| Information disclosure | Can secrets, PII, tenant data, or internal state leak? |
| Denial of service | Can resource, retry, queue, parser, or dependency limits be exhausted? |
| Elevation of privilege | Can an actor cross role, owner, tenant, or execution boundaries? |

Record `finding`, `pass`, or `not-applicable` plus evidence and residual risk
for every category.

## Abuse Variants

Vary actor, tenant, object, role, order, timing, concurrency, replay, encoding,
payload size, partial failure, stale state, provider response, dependency
version, and cleanup. Use variants relevant to the data flow; record substantive
reasons for omissions.

## Supply-Chain Provenance

Verify the package/artifact identity, source, pinned or locked version,
integrity mechanism, build/release provenance, known advisories, maintainer or
publisher boundary, transitive reach, and rollback path. Popularity is not
provenance.

## Exploitability And Safe PoC

Record prerequisites, attacker access, complexity, required timing/state,
affected population, blast radius, and confidence. A safe PoC must use
authorized disposable data and bounded resources. Choose one disposition:

- `executed-safe`: authorized, contained, reproducible evidence exists;
- `designed-not-executed`: execution would exceed authority or safe scope;
- `not-applicable`: a substantive reason explains why reproduction is not useful.

Never obtain persistence, expose credentials/PII, contact unauthorized systems,
degrade production, or bypass provider rules.

## Negative Proof

Prove the hostile or unauthorized path fails closed at the authoritative
boundary. Include exact command/case, fixture identity, exit/outcome, redaction,
logs or trace locator, correction generation, and remaining variants. A happy
test, static scan, or generic suite pass is not sufficient negative proof.
