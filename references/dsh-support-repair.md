# DSH support-file integrity repair

Use when a DSH-specific Accelerate entry references documents missing from its
installed package. This is a narrow repair, not bootstrap or policy sync.

Run from the canonical Accelerate checkout:

    python3 scripts/repair-dsh-support.py --target "$HOME/.agents/skills/accelerate"

Inspect the zero-write plan, then privately back up the target directory and
save the plan. Apply with the same command plus `--apply`. The tool restores
only absent files from this repository, including discoverable native document
dependencies; existing runtime-specific files and SKILL.md remain untouched.
Run again without `--apply`: count must be zero. Compare the copied files with
the source hashes printed in the plan. The QA reference must resolve its
`../core/runtime-packets/qa-proof-stack.md` authority, not just exist as a stub.

Validation:

    python3 tests/test_dsh_support_repair.py
    bash tests/qa-proof-stack-strict-contract.sh

Missing required sources and escaping symlinks stop preflight. A racing file
creation causes exclusive creation to fail rather than overwrite operator data.
A mid-apply IO error may leave a partial missing-only repair: retain the plan,
resolve the IO failure, and rerun the dry-run. Rollback removes only paths from
the saved plan whose hashes still match, or restores the private backup after
checking for subsequent user edits. Never delete unrelated runtime files.

This repairs files behind an existing loaded entry. No model/session reset is
needed for a subsequent file read; it does not retroactively remove historical
failed tool cards or guarantee correction of already-running model decisions.
