# Runtime forensic closure

Use this checklist when completion affects a daemon, MCP, browser runtime,
background worker, scheduler, CLI installation, global configuration, or other
persistent host state.

## Inventory and ownership

1. Freeze the expected service, daemon, launcher, client, worker, browser, and
   temporary-root inventory.
2. Compare active clients with their parent session and exact PID/start time.
3. Identify legacy clients from superseded configurations or releases.
4. Establish release parity among persisted config, stable launcher, active
   client, daemon/service, dependency lock, and materialized runtime.
5. Distinguish active external state, owned test state, dead residue, and an
   ambiguous target that must remain untouched.

## Cleanup proof

- Revalidate owner, mode, canonical path, no path escape, PID/start identity,
  process group, descendants, sockets, locks, and receipts immediately before
  any signal or move.
- Check open files or sockets before moving a dead runtime root.
- Signal only the exact owned process tree; never use a broad name/prefix kill.
- Prefer recoverable quarantine for material residue. Record its absolute path,
  owner/mode, contents count, and restoration or deletion disposition.
- Preserve active roots and clients with a documented ownership reason.
- Re-scan for exact process, port, socket, lock, profile, session, temp root,
  cache, and artifact residue after cleanup.

## Final runtime readback

Require the narrowest applicable proof:

- service manager state and exact executable/arguments;
- health or identity read;
- MCP initialize, tools/list, and the real call supporting the claim;
- CLI/package/browser version and provenance;
- database/provider authority and read-only identity probe;
- provider readback for issue state and final lifecycle comment.

Do not collapse these into a generic `tested` statement. Report each surface as
proven, intentionally retained, not applicable, or blocked.

## Completion rule

Completion is unsupported while an unexplained legacy client, release mismatch,
owned orphan process, dead root, open file, failed cleanup, missing quarantine
disposition, or absent provider readback remains. An external live process may
remain only with exact evidence that it belongs to another active session.
