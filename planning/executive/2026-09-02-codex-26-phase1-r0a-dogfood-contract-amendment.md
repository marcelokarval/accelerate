# CODEX-26 C13 R0a — Dogfood Contract Amendment

## Discovery

R0 proved that the current workspace must be `partial-reonboarding` for Plane
`CODEX-26`, while `tests/dogfood-workspace-contract.sh` still requires every
lifecycle file to contain `accepted`.  Its failure is therefore a real
contract contradiction, not a permission to retain stale May state.

## Bounded successor task

One Terra/medium executor may modify only
`tests/dogfood-workspace-contract.sh`.

The successor must make that contract distinguish:

1. historical May acceptance, which may remain as named historical evidence;
2. the current `CODEX-26` C13 local projection, which must be Plane-bound and
   `partial-reonboarding` / in progress; and
3. acceptance/closure/promotion claims for the current C13 cycle, which must
   fail closed.

It must not change local state, adapter state, Phase-1 semantics, historic
receipts, provider state, or the frozen proposal.  It must supply a compact
positive proof and intentional negative probes.  This amendment neither
accepts C13 nor waives the planned isolated final gates.
