# Storage And Serving Posture

Use this reference when uploaded or imported content will be stored, retained,
or served back to users.

## Questions To Answer

1. is the content private or public?
2. does the storage name reveal user input?
3. is the served content a normalized derivative or the raw original?
4. is the response posture tighter than the browser defaults when needed?

## Baseline Rules

- prefer generated storage identifiers instead of user filenames
- keep private content private by default
- serve normalized derivatives when raw preservation is unnecessary
- make retention and cleanup posture explicit for transient imports

## Review Points

- object storage ACL or local storage privacy
- whether download URLs are scoped and time-bounded when appropriate
- whether direct static serving leaks more than intended
- whether cached public outputs expose private ingress by accident

## Common Smells

- user-controlled filename becomes a permanent public URL
- private business imports stored in a public bucket/path
- raw uploads retained forever without product need
