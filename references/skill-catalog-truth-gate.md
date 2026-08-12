# Skill Catalog Truth Gate

Before selecting a specialist, thinning resident skills, or claiming a catalog
capability, obtain a fresh runtime inventory with the declared discovery
command in `adapters/runtime/codex/skill-catalog-manifest.toml`.

Treat the measured inventory as runtime evidence, not repository authority.
Classify each required skill as `core`, `specialist`, `on-demand`, or
`host-injected`; record unavailable or versioned plugin paths as a blocker,
never as silently covered capability. Route hidden specializations through
`skill-catalog-router` and prove the effective prompt inventory after a change.

Do not widen a root envelope because a skill might exist somewhere on disk.
Do not disable a skill until its specialist or on-demand recovery route has
been recorded and tested.

## Codex Profile Contract

The manifest is the exact inventory and routing authority. Render an additive
logical profile with:

```bash
python3 scripts/render-codex-skill-profile.py \
  adapters/runtime/codex/skill-catalog-manifest.toml \
  --mode profile --profile <profile> --output ~/.codex/<profile>.config.toml
codex -p <profile>
```

Current profiles are `django-backend`, `next-react-frontend`, `data-db`,
`integrations-ops`, `product-browser-qa`, `governance-review`, and
`catalog-librarian`. The `on-demand` profile is the controlled recovery route
for the rare, broad set. A profile restores only its declared specialist skills on
top of the compact core; it is a capability-selection mechanism, not a host
sandbox, credential boundary, MCP allowlist, or promotion to a physical agent.
Root retains cross-surface reconciliation, Plane writes, external delivery,
and closure.
