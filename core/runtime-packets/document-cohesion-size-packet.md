# Document Cohesion Size Packet

Use this packet when the `Document Cohesion Size Gate` is active.

## Packet

```text
Document Cohesion Size Packet

- audit scope: <all md|core md|changed docs|specific paths>
- line-count source: <command|tool|manual>
- largest live doctrine files:
  - <path>: <lines>, classification=<single-authority|aggregator|reference-corpus|archive/plan|mixed-authority|duplicated-authority>
- size-band thresholds applied: <yes|no>
- split candidates:
  - <path>: <reason|none>
- merge/pointer candidates:
  - <path>: <reason|none>
- duplicated authority findings:
  - <paths + owner decision|none>
- context preservation risks:
  - <risk|none>
- index/README updates required:
  - <path|none>
- action taken: <none|split|merged|pointer-added|index-updated>
- residual gaps: <...>
```

## Rule

This packet must separate file-size concern from authority concern. Large files
are not automatically bad; ambiguous authority is the actual defect.
