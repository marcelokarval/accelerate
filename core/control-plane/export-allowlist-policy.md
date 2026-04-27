# Export Allowlist Policy

Accelerate uses explicit allowlists for artifact export.

## Rules

- Export is opt-in.
- Allowlist beats denylist.
- Unknown artifact classes are blocked.
- Secrets, tokens, cookies, credentials, private keys, browser cookie stores, and
  provider credentials are never exported intentionally.
- Export packets must name source path, destination path, privacy class, and
  approval source.

## Required Local Check

Any export script must validate the privacy map before writing or sending an
artifact outside the target workspace.
