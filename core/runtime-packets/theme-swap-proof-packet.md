# Theme Swap Proof Packet

Use this packet when a branch claims that a visual change can be adopted through
theme tokens, `global.css`, Tailwind variables, or an equivalent token authority
without changing component anatomy.

```text
Theme Swap Proof Packet
- target route/state:
- token authority file:
- source theme artifact:
- alternate theme artifact:
- active selector/provider:
- baseline capture:
- swapped capture:
- console evidence:
- network evidence:
- expected changed values:
- expected unchanged anatomy/data/state:
- Tailwind/config mapping proof:
- primitive token consumption proof:
- residual non-portable surfaces:
- readiness impact: supports-closure|review-only|blocked
```

## Requirements

- Baseline and swapped captures must cover the same route and comparable state.
- Console and network evidence must be named when the theme is applied through a
  runtime provider, hydration boundary, server state, or client-side toggle.
- The packet must distinguish token value changes from anatomy/template changes.
- If anatomy changes are visible, use `template-swap-proof-packet.md` or declare a
  mixed layer in the Theme / Template Portability Packet.
