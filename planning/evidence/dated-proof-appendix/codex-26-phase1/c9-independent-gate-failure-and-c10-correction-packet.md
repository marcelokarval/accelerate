# CODEX-26 Phase 1 — C9 Independent Gate Failure / C10 Correction

- rejected candidate: `CODEX-26-P1-IMPLEMENT-C9`
- frozen aggregate: `sha256:5238804725120c83a3b6bb174ff7d1e44e4ad37e5cea53586fef0e5bac635032`
- freeze receipt file: `sha256:661352c8718711e3ee72725b58d084961f0f1b20a1baf1476adfafeab596b15c`
- tester verdict: `FAIL`
- reviewer verdict: `FAIL`
- successor: `C10`
- operator-extra correction round: `6/8`

## Closed correction denominator

1. Trust registry/key selection belongs to a trusted verifier instance or
   immutable fixture authority source, separate from untrusted expected
   bindings. Replacing the whole validator/root/key bundle and re-signing must
   reject. Expected context carries current material bindings and time only.
2. A04 `changed` is derived by the production boundary from trusted pre/post
   state snapshots and artifact observations. A bare boolean or caller claim is
   not transition proof. The exact counterexample
   `execute_a04("tasks-ready-valid", lambda: True)` must reject.

The freeze receipt is a content digest, not a Git commit ID. Phase 1 does not
require or authorize a commit; inability to resolve that SHA through
`git rev-parse` is therefore not a defect.

All other C9 probes remain regression requirements. C10 requires two real
runs, zero skips, deterministic validated receipts, no caches, clean diff and
zero known residuals before freeze. No acceptance, promotion, runtime,
namespace, reader, Plane closure or Phase-2 authority is granted.
