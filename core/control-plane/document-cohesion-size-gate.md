# Document Cohesion Size Gate

## Purpose

Use this gate when auditing or changing Markdown doctrine, plans, packets,
skills, references, or other living documentation where file size, duplicated
context, or weak separation can degrade Accelerate's operability.

This gate does not optimize for small files at the expense of context. It
optimizes for navigable doctrine with stable authority boundaries.

## Activation

Activate this gate when the request mentions or implies:

- Markdown size or `.md` size
- large docs
- split / merge / separation / cohesion
- duplicated or redundant docs
- documentation architecture
- loss of context during refactor
- index, README, packet, gate, skill, plan, or reference organization

Also activate it during broad self-audits of Accelerate's own doctrine.

## Size Bands

Use line count as a heuristic, not an automatic refactor trigger:

- `0-120` lines: compact reference or focused gate; splitting usually hurts
- `121-250` lines: normal doctrine surface; check heading clarity and ownership
- `251-400` lines: large surface; require section map and explicit reason to stay whole
- `401-700` lines: aggregation risk; require split candidates or aggregator justification
- `700+` lines: archive/plan/reference corpus likely; require table of contents, ownership
  statement, or decomposition plan unless the file is intentionally historical

Do not split historical plans, benchmark corpora, or external design references
just because they are large. Mark them as archive/reference if they are not live
operating doctrine.

## Cohesion Checks

For each large or suspicious document, classify it as one of:

- `single-authority`: one live doctrine owner, should stay together
- `aggregator`: central template/index/catalog that may stay large with section map
- `reference-corpus`: intentionally long source material, not execution law
- `archive/plan`: historical or planning artifact; do not over-normalize
- `mixed-authority`: contains separable owners and should be split or cross-linked
- `duplicated-authority`: repeats law already owned elsewhere and should point instead

## Required Audit Packet

When active, use `Document Cohesion Size Packet` from
`core/runtime-packets/document-cohesion-size-packet.md` or include the same
fields inline.

## Split Rules

Split a Markdown file only when all are true:

- the file mixes at least two authority owners or workflows
- the split creates a clearer canonical owner
- the original file can become a map/index or can be safely replaced by links
- no context, examples, failure labels, or proof requirements are lost
- references and README/index surfaces are updated in the same slice

Prefer extracting stable sub-surfaces over deleting duplicated context. If two
files overlap, first decide which one owns the law and which one should become a
pointer.

## Closure Blockers

Do not close when:

- a large live doctrine file was changed without size/cohesion classification
- a split removed examples, packet fields, failure labels, or proof requirements
- two files still claim to own the same gate/packet without an owner index
- README/index surfaces no longer list the new owner files
- a line-count audit led to mechanical splitting with worse navigation

## Failure Labels

- `md-size-ignored`
- `mechanical-split-lost-context`
- `mixed-authority-left-unclassified`
- `duplicated-authority-left-active`
- `index-not-updated-after-doc-split`
