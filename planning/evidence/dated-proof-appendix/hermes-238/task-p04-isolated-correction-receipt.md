# HERMES-238 — TASK-P04 Isolated Correction Receipt

## Candidate decision

`GO_TO_INDEPENDENT_SOURCE_PROMOTION_REVIEW`

This is a decision about the disposable source candidate only. No shared source
mutation, index mutation, commit, push, runtime promotion, restart, provider
call or external-catalog update occurred.

## Frozen construction evidence

| Receipt | SHA-256 |
| --- | --- |
| 29-path source manifest | `0c71b6ff32d231c9b6268b53dde51fc7de788acf2390242a2756560787ac979a` |
| candidate manifest | `e6aa1f9fdd2d1786033b53f41b5f4f74bcc688f613f2de3fbd78bc9f843b2d05` |
| isolated correction patch | `d5e89083f9dfba604b4afc052d56622f0ccccecb5ae963c3096c079d5228041b` |
| machine receipt | `844b2a7117e228034b68256e117b5ba7b945463be0ba7e21a5fe76579014adb5` |
| candidate wheel | `6f08d2ed77f5ec47d2968680c782273da13ac3f3f5d60ad7f74a31f7dd3f8dd9` |

The source manifest has one sorted row for each selected file with path,
source SHA-256, shared-state disposition, package/import role, wheel inclusion
and index blob. Candidate rows bind source/candidate hashes and correction
status.

The isolated construction compared three pre/post fingerprints; all matched:

| Surface | Fingerprint |
| --- | --- |
| target porcelain | `54a9263f9c5b8d23265291f44caa18b38427000c3780f989549497d4081667af` |
| target index | `68118f003ba483a5f622ad9e16531dc7354f0abfa9d179964f360747a8072356` |
| selected 29-file worktree | `3689c7b92d3bfccb1f033f734263248a6112b784d661e91f41ebb2a6f53d5ef3` |

## P1 correction

Only the disposable candidate changes:

- `tests/test_plane_skill_parity_v2.py` makes the home-catalog parity test an
  explicit `PLANE_MCP_EXTERNAL_PARITY_AUDIT=1` audit; and
- `README.md` states the default hermetic package-proof lane and the separate
  read-only external audit lane.

The stale OpenCode destination hash was neither replaced nor accepted. The
external audit remains observable drift, not package proof.

## Isolated verification

```text
uv sync --frozen --all-groups    # pass
uv lock --check                  # pass
uv build --wheel                 # pass
installed-wheel import           # pass
normal hermetic suite            # 133 passed, 5 explicit external-audit skips
external parity audit            # 1 failed, 4 passed; known stale external hash
```

The wheel contains runtime Python/resources and excludes tests/docs. The only
remaining failure belongs to the separately labeled external-runtime audit.

## Open questions for TASK-P05

The independent reviewer must verify the candidate patch actually preserves
normal test semantics, that an opt-in gate cannot hide needed package proof,
that the 29-path manifest is complete and replayable, and that external parity
drift is not being silently converted into a runtime claim. A PASS permits only
the next **source-promotion review** gate; it does not authorize promotion.
