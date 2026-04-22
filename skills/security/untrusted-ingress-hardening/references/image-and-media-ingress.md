# Image And Media Ingress

Use this reference when the incoming artifact is an image or other media-like
payload.

## Main Questions

1. is the file type explicitly allowlisted?
2. is the backend validating more than the extension?
3. does the system preserve metadata it does not need?
4. can the transformed or served asset leak private information?

## Baseline Rules

- use extension + MIME + decode/parser-backed checks together when feasible
- bound image dimensions, file size, and frame count when relevant
- prefer re-encoding or normalization over raw preservation when product allows
- strip EXIF and other metadata unless the product has an explicit reason to
  keep it
- do not let the original user filename become the storage identity

## Privacy And Tracker Review

Explicitly review whether the image may carry:

- EXIF
- GPS coordinates
- device or software metadata
- hidden thumbnails or extra embedded metadata blocks

If the product surface does not need them, remove them.

## Serving Posture

Ask:

- should the file be private?
- should it be transformed into a normalized output before serving?
- should content-disposition or caching be constrained?

## Common Smells

- trusting browser-declared MIME only
- preserving originals indefinitely for avatar-like use cases
- not bounding dimensions for image uploads
- serving user uploads publicly without explicit product need
