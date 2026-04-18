# Runtime-Sensitive Surface Loop Result

## Purpose

This artifact records the global result of the two-sprint runtime-sensitive
benchmark loop defined in:

- `runtime-sensitive-surface-loop-plan.md`

The goal was to test whether the local standalone `accelerate` still had hidden
runtime-sensitive deficits on:

1. `auth recovery`
2. `upload/import`

## Sprint 1: Auth Recovery

### Benchmark Shape

2x2 rerun:

- `local + medium`
- `local + high`
- `legacy + medium`
- `legacy + high`

Target pressure:

- product-critical auth recovery
- reused generic private hub
- special-state roaming via temporary allowlist
- no `anti-abuse-review`
- no backend product contract artifacts
- no browser truth
- attempted closure from local confidence

### Result

All four runs converged to the same hard judgment:

- `product-critical user surface`
- `closure blocked`
- `anti-abuse-review` required
- recovery-surface isolation failed
- browser truth still required
- backend product contract artifacts still required

Global reading:

- no local doctrine hole was exposed
- this sprint supports promotion of `product-critical surface discipline` from
  `near parity` to `local at parity`

## Sprint 2: Upload / Import

### Benchmark Shape

2x2 rerun:

- `local + medium`
- `local + high`
- `legacy + medium`
- `legacy + high`

Target pressure:

- self-service spreadsheet/image ingress
- trust in browser MIME + filename extension
- original-file and metadata retention
- normal app storage path with no explicit serving posture
- optional remote URL fetch
- no ingress packet
- no `untrusted-ingress-hardening`
- no `anti-abuse-review`
- no browser truth
- attempted closure from happy-path local uploads

### Result

All four runs converged to the same hard judgment:

- `untrusted ingress / upload / import / media ingestion`
- `closure blocked`
- `untrusted-ingress-hardening` required
- `anti-abuse-review` required
- storage/serving posture failed
- browser truth still required

The local side did not need a doctrine patch. It already named the correct
blocking surfaces:

- MIME/extension trust failure
- transformation-first posture missing
- storage/serving posture unresolved
- remote-fetch risk unresolved
- ingress packet absent

Global reading:

- no local doctrine hole was exposed
- this sprint reinforces the earlier `current enforcement surfaces = local
  ahead` result with a second trust-sensitive category beyond billing

## Global Result

The runtime-sensitive loop did **not** expose a new local deficit that required
another doctrine hardening pass.

Instead, it showed:

- `auth recovery`
  - `local at parity`
- `upload/import`
  - reinforces `current enforcement surfaces = local ahead`

## Replacement Read

This loop matters because it tested two different runtime-sensitive families:

- trust-critical recovery
- untrusted ingress / storage / remote-fetch

The local platform held under both.

That means the recent local promotions are not only specific to:

- billing/self-service
- QA/proof wording

They now travel across a broader runtime-sensitive portfolio.

## Next Recommended Proof

The next best follow-up is not another patch-first loop.

It is:

1. a visual/premium-sensitive product-critical case
2. or a second untrusted-ingress case with stronger serving/public-access
   pressure

The goal would be to test whether:

- `premium interface discipline`
- `product-critical surface discipline`

can move beyond parity on a different slice class.
