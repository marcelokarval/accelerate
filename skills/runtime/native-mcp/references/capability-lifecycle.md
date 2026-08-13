# MCP capability lifecycle

Use this lifecycle to describe exactly what an MCP capability can do. Never
promote a server from configuration evidence alone.

## States

1. `defined`: configuration or credentials are present.
2. `registered`: the current runtime catalog contains the named server.
3. `materialized`: the pinned launcher, package, executable, and required
   runtime assets exist and pass provenance/preflight checks.
4. `initialized`: a fresh client completed the MCP initialize handshake.
5. `tools-listed`: that initialized client returned its tool catalog.
6. `callable`: the exact required read or browser action succeeded.
7. `authenticated`: the provider accepted the credential and identity/scope
   needed for the operation.

These states are independent. `tools-listed` does not prove provider auth, and
`authenticated` does not authorize an arbitrary write.

## Fresh-session diagnosis

An already-running session may retain cached command, arguments, environment,
tool inventory, or server availability from startup. After changing MCP config
or a launcher, start a fresh client process. Do not interpret a failure in the
old session as evidence that the persisted correction failed.

For each server, record:

- persisted config identity;
- command/launcher and exact version;
- active client PID and parent session;
- initialize result and protocol version;
- tools/list count;
- one relevant real call;
- authentication/authorization disposition;
- cleanup result.

## Release parity

For a daemon-backed MCP, compare the registered client release, active client
process, stable launcher target, daemon release, and protocol/tool schema.
Changing configuration affects only new clients. Classify old clients by live
parent/session ownership before recycling them; never use a broad process kill.

## Failure classification

- Startup interrupted by the operator is not server failure.
- Config registration is not materialization.
- A healthy daemon is not a client handshake.
- `tools/list` is not callability.
- ENV presence is not authentication.
- A cached session warning is not proof about a fresh session.
- Initial-connect failure must leave no pending task, process, or event-loop
  error; otherwise lifecycle cleanup is incomplete.

## Closure evidence

Close only with fresh-process evidence at the highest state actually claimed,
exact release parity or an accepted compatibility disposition, and ownership-
aware cleanup of failed or superseded clients.
