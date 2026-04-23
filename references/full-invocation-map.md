# Full Invocation Map

## Local Authority Status

Primary local authority lives in:

- `../core/control-plane/quick-invocation-map.md`

Use this reference for the larger inherited N+1 discovery map, not as the
first local authority.

Use this module when the operator needs the richer N+1 map of what `accelerate`
can become when invoked across different kinds of work.

## Invocation Families

```text
╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                  ACCELERATE — N+1 INVOCATION MAP                                                       ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ ENTRY                                                                                                                   ║
║  User Request                                                                                                           ║
║      │                                                                                                                  ║
║      ▼                                                                                                                  ║
║  Frame / Spec                                                                                                           ║
║      │                                                                                                                  ║
║      ├── [A] conversational / no-op                                                                                     ║
║      ├── [B] trivial bounded read-only                                                                                  ║
║      ├── [C] trivial bounded mutation                                                                                   ║
║      ├── [D] ambiguous / long / epic-like ───────────────▶ Prompt Hardening                                            ║
║      └── [E] engineering non-trivial ───────────────────▶ Branch Select                                                 ║
╠══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ BRANCH SELECT                                                                                                           ║
║                                                                                                                          ║
║ [1] issue architecture / triage                                                                                         ║
║ [2] bug / regression / failure                                                                                          ║
║ [3] backend-only implementation                                                                                         ║
║ [4] frontend-only implementation                                                                                        ║
║ [5] full-stack feature delivery                                                                                         ║
║ [6] architecture / governance doubt                                                                                     ║
║ [7] product-critical user surface                                                                                       ║
║ [8] visual / artifact-driven frontend                                                                                   ║
║ [9] query / contract-sensitive backend                                                                                  ║
║[10] admin / operator / unfold                                                                                           ║
║[11] browser-proof broad audit                                                                                            ║
║[12] E2E regression authoring                                                                                             ║
║[13] security / hostile-path review                                                                                       ║
║[14] upload / import / untrusted ingress                                                                                  ║
║[15] i18n / translation-boundary                                                                                          ║
║[16] transport / dependency / legacy doubt                                                                                ║
║[17] multi-agent sprint / bounded delegation                                                                              ║
║[18] release / closure-only pass                                                                                          ║
║[19] hotfix / incident response                                                                                            ║
║[20] rollout / feature flag / experiment                                                                                  ║
║[21] observability / performance / N+1                                                                                    ║
║[22] legacy truth extraction only                                                                                         ║
║[23] data-contract / DTO / presenter stabilization                                                                        ║
║[24] provider-runtime audit                                                                                                ║
║[25] docs / living-doc sync                                                                                                ║
║[26] design-reference extraction                                                                                            ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

## Notes

- This map is intentionally larger than the always-active branch set.
- `accelerate` should discover broadly, then activate minimally.
- The point of the full map is to make future agent derivation and branch growth
  explicit without loading the entire catalog on every run.
- When governed `.accelerate/` local status is active and a fast handoff read is
  needed, prefer `review/handoff-summary.md` before opening the full persisted
  packet and bundle set.
