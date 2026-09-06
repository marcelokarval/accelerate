# Antigravity and `agy` Provider/CLI Contract

## Distinct Surfaces

Do not collapse these names:

- `antigravity`: OmniRoute provider using the IDE-oriented OAuth/client profile.
- `agy`: the installed Antigravity CLI executable and OmniRoute provider records using the CLI-oriented profile. OmniRoute may translate an `agy/...` Combo step to the internal `antigravity/...` transport in request logs; preserve both the public step ID and effective transport in evidence instead of reporting this as a silent provider swap.

A running `agy` process or successful `agy models` command proves the local CLI is installed/authenticated. It does **not** prove OmniRoute's stored `agy` connection is active or refreshed.

## Local CLI Evidence

Canonical binary in this installation:

```text
~/.local/bin/agy
```

Useful read-only checks:

```bash
~/.local/bin/agy --version
~/.local/bin/agy models
~/.local/bin/agy agents
```

As of the 2026-08-30 qualification, `agy --version` returned `1.1.22` and model discovery returned Gemini, Claude and GPT-OSS options. Recheck live; never treat this reference as current runtime truth.

## OmniRoute Evidence

Read both:

```text
GET /api/providers
GET /api/rate-limits
```

For each `antigravity`/`agy` connection retain only:

```text
provider
authType
clientProfile
active/test state
token expiry state
plan/tier
masked account label
quota freshness
```

Do not save tokens, OAuth scopes containing sensitive identity context, cookies, project secrets or full provider payloads.

## Admission to Routing

A connection may enter a governed alias only when all pass:

1. provider connection is active in OmniRoute;
2. token is not expired and refresh succeeds;
3. model enumeration includes the intended model;
4. direct no-cache/no-memory/no-compression chat succeeds;
5. a real tool-call round trip succeeds;
6. streaming/structured output passes if the alias requires it;
7. quota readback is fresh enough for routing;
8. failure is classified correctly by model/account/provider denominator;
9. fallback does not duplicate a completed response.

Do not activate an expired OmniRoute `agy` connection merely because the local CLI works. Use the supported import/auth/refresh flow and reread the provider record.

## Routing Guidance

- Prefer explicit model IDs during qualification.
- Add `agy` only as a lower-priority member until it has stable canary history.
- Preserve an independent provider family as fallback; two accounts backed by the same upstream are not full provider diversity.
- Treat Antigravity signature caching as provider-specific transport behavior, not OmniRoute semantic cache.

## Troubleshooting Sequence

```text
binary exists -> CLI version/models -> OmniRoute provider record
-> token/active state -> direct model canary -> tool canary
-> quota -> alias membership -> fallback proof
```

Stop before credential mutation if the supported refresh/import method is unclear. Never copy tokens manually between the CLI and OmniRoute database.
