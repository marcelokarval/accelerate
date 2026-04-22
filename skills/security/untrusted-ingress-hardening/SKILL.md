---
name: untrusted-ingress-hardening
description: Codex-native hardening skill for uploads, imports, images, and other untrusted ingress, covering privacy, parser safety, transformation-first handling, and bounded storage/serving posture.
metadata:
  category: security
  origin: accelerate-native-adapted
---

# Untrusted Ingress Hardening

Use this skill when the work touches any user-supplied or externally sourced
file, image, media blob, import payload, or remote-ingress artifact that the
system may parse, store, transform, or serve back.

This skill is adapted for Accelerate from strong public security-review patterns,
including skills.sh security-audit material and OWASP upload guidance, but the
rules here are rewritten around active stack profiles, user-facing product
surfaces, and backend-authoritative validation.

## When to Use

Use this skill when the slice touches:

- avatar uploads
- image uploads
- document uploads
- spreadsheet imports (`.csv`, `.xls`, `.xlsx`)
- drag-and-drop upload flows
- remote image or file ingestion
- parser-backed imports or transformations
- any feature where an external payload can become stored state

Do not use it for:

- purely visual upload-zone styling with no backend, parser, or serving changes
- harmless static asset authoring controlled entirely by the repo

## Core Principle

Treat uploads and imports as **untrusted ingress**, not as passive content.

The workflow must assume risk across four axes:

1. safety of the incoming payload
2. privacy and metadata leakage
3. parser and transformation risk
4. storage and serving exposure

Do not trust:

- filename
- extension
- browser-declared MIME
- frontend limits
- spreadsheet structure
- image metadata

## Output Contract

The result should make these things explicit:

1. ingress type
2. allowed formats and limits
3. backend validation authority
4. transformation or sanitation path
5. storage and serving posture
6. abuse paths reviewed
7. residual risks and follow-ups

## Workflow

### 1. Classify The Ingress Surface

Identify:

- direct user upload vs externally fetched payload
- image/media vs tabular import vs generic file
- transient processing vs long-lived storage
- private serving vs public serving

### 2. Define The Allowlist

Make format acceptance explicit:

- allowed extensions
- allowed MIME families
- expected file signature or parser-backed verification
- size, dimensions, row-count, sheet-count, and frame/page limits where relevant

Reject-by-default is the baseline.

### 3. Separate Detection From Trust

Do not trust a single indicator.

Check combinations such as:

- extension
- declared MIME
- actual file signature or decoding success
- parser validation outcome

If those disagree, fail closed.

### 4. Prefer Transformation-First Handling

For images and imports, prefer a bounded normalization path over raw pass-through.

Examples:

- re-encode images rather than preserving arbitrary originals when product
  requirements allow it
- strip EXIF and non-essential metadata from user-facing image surfaces
- parse tabular imports into bounded internal structures instead of forwarding
  raw workbook semantics through the system

### 5. Review Privacy And Tracker Leakage

For images and media, explicitly ask:

- does the payload retain EXIF, GPS, device, author, or software metadata?
- can hidden metadata or image structure leak private information?
- can the returned or served asset expose more than the product needs?

When the product does not explicitly need the metadata, remove it.

### 6. Bound Parser And Import Risk

For `.csv`, `.xls`, and `.xlsx` style imports, review:

- row-count and column-count limits
- parser library safety and supported subset
- normalization of headers and field mapping
- rejection of unsupported formulas, macros, or workbook behaviors when the
  product does not need them
- transformation into canonical internal data before downstream use

### 7. Review Storage And Serving Posture

Make these decisions explicit:

- random or generated storage names instead of user filenames
- private vs public storage
- whether the asset should be served directly, proxied, or transformed first
- whether content-disposition, cache, or content-type needs tightening

### 8. Review Abuse Paths

At minimum, ask:

- can this be spammed?
- can oversized or malformed payloads exhaust memory, CPU, parser time, or
  storage?
- can a private upload become publicly reachable?
- can a workbook or import path smuggle unsupported logic or hidden state?

Pair with `anti-abuse-review` when the flow is user-facing or self-service.

## Accelerate Usage Rules

- backend validation remains authoritative
- frontend checks are convenience only
- pair with `security-patterns` for ownership, serving posture, remote-fetch
  risk, or SSRF-adjacent review
- pair with `product-runtime-review` when the upload/import flow is user-facing
- pair with `django-service-patterns` when service-owned transformation or
  persistence is in scope
- if the work lands in an issue backend, the review should explicitly mention
  ingress class, validation posture, transformation posture, and serving
  posture

## Typical Smells

- trusting `file.type` or extension alone
- storing the raw user filename
- preserving EXIF or private metadata for no product reason
- accepting arbitrarily large images or sheets
- import code that trusts workbook structure without normalization
- frontend-only file-size or file-type validation
- direct passthrough of remote URLs or remote files without verification
- public serving of content that should stay private

## Required References

Read these when needed:

- `references/image-and-media-ingress.md`
- `references/tabular-import-ingress.md`
- `references/storage-and-serving-posture.md`

## Verification

This skill is being used correctly if:

- ingress type and limits are explicit
- backend validation is authoritative
- privacy/metadata leakage is reviewed
- transformation-first handling is justified
- storage and serving posture are named
- abuse paths are checked rather than assumed away
