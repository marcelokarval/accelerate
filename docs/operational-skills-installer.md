# Operational skills installer

The installer implements a **cooperative recoverable batch with rename-atomic
steps**. It writes a schema-v2 manifest and journal under
`$HOME/.local/state/accelerate/operational-skills`, holds an exclusive
cooperative lock, records intent before each switch, and fsyncs journal and
target-directory updates. A subsequent invocation classifies the physical
target/candidate/backup state and resumes the recorded apply or rollback goal.
The lock is a regular 0600 file held with `fcntl.flock`; its pathname is never
used as a stale-PID lease and is not unlinked during release.

This is not ACID, all-or-nothing, or power-loss proof. Residual risks include
readers observing mixed generations, writers that do not cooperate with the
lock, filesystem/storage implementations that do not honor rename or fsync
durability, and the fact that recovery requires a later invocation. Terminal
backup records are retained for explicit rollback and audit.

Only regular, non-symlink payloads with the recorded digest are eligible;
control, lock, and active-pointer ownership/modes are enforced. Ambiguous
target, marker, backup, hardlink, or special-file state fails closed without
overwriting the target. Candidate and
manifest/journal schemas, entry identities, plan digests, and exact marker
bytes are checked before recovery can rename anything. Explicit rollback runs
the complete target and backup preflight before arming its recovery goal.

Subprocess crash-window hooks used by the tests require explicit test mode and
a temp-root allowlist; they are ignored during normal installation.
