# Browser Truth Contract

Browser truth should include screenshots/captures, console evidence, network
evidence, target route/URL, viewport, auth/session posture, and residual gaps.
It should also record browser session posture and profile/isolation strategy
whenever the browser tool exposes shared profile behavior.

Screenshot-only proof is insufficient for UI/runtime behavior.

`onboarding/local-workspace/capture-browser-proof.sh` is the repo-local browser
proof helper. It defaults to localhost-only URLs, writes a JSON proof packet, and
records screenshot, console, network, viewport, URL, server-readiness metadata,
and privacy metadata. Before launching browser automation it performs a target
server/readiness preflight. Readiness failures write a structured blocked packet
with `browser_launched: false`, `server_readiness.checked: true`, a failure
detail, and a correction signal so the execution-to-spec loop can start or fix
the server before retrying. Remote URLs are blocked until a request-intercepting
adapter can prevent page-triggered private network and metadata-host subresource
requests.

When Chrome DevTools reports that its shared `chrome-profile` is already
running, route through `core/runtime-packets/browser-proof-packet.md` profile
conflict rules. Prefer `--isolated`, then a dedicated temporary `userDataDir`
under project `.tmp/`, then intentional existing-session attachment only when
the proof requires that session state. Otherwise mark browser proof blocked and
do not close browser-required work.
