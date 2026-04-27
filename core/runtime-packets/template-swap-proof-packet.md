# Template Swap Proof Packet

Use this packet when a branch changes a product template, route shell,
navigation model, dashboard frame, shared composition, or component anatomy.

```text
Template Swap Proof Packet
- target route family:
- template authority artifact:
- minimum owner layer:
- anatomy changed:
- primitives affected:
- composites affected:
- shells/layouts affected:
- pages affected:
- responsive states covered:
- empty/loading/error/auth states covered:
- baseline capture:
- swapped capture:
- console evidence:
- network evidence:
- design-system comparison result:
- theme-token compatibility:
- residual template drift:
- readiness impact: supports-closure|review-only|blocked
```

## Requirements

- A template swap must name the changed anatomy. Do not hide shell or primitive
  changes inside a theme claim.
- Runtime proof must cover at least one representative route/state for every
  changed shell or composite family.
- If the template keeps theme portability, prove that the resulting components
  still consume the canonical token layer.
