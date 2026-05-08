# Browser Truth Contract

Browser truth should include screenshots/captures, console evidence, network
evidence, target route/URL, viewport, auth/session posture, and residual gaps.
It should also record browser session posture and profile/isolation strategy
whenever the browser tool exposes shared profile behavior.

Screenshot-only proof is insufficient for UI/runtime behavior.

`onboarding/local-workspace/capture-browser-proof.sh` is the repo-local browser
proof helper. It defaults to localhost-only URLs, writes a JSON proof packet, and
records screenshot, console, network, viewport, URL, server-readiness metadata,
server monitor metadata, cleanup ownership, and privacy metadata. Before
launching browser automation it performs a target server/readiness preflight.
Readiness failures write a structured `server-readiness` blocked packet with
`browser_launched: false`, `server_readiness.checked: true`, HTTP code/probe
detail, optional server PID/stdout/stderr liveness detail from
`ACCELERATE_BROWSER_PROOF_SERVER_*`, cleanup ownership detail, and a correction
signal so the execution-to-spec loop can start or fix the server before retrying.
`ACCELERATE_BROWSER_PROOF_READINESS_ONLY=1` writes a `readiness-only` packet and
never launches the browser. If readiness passes but browser automation is missing
or fails, the helper writes `capture-failed` instead of conflating it with server
readiness. Capture-failed packets re-check supplied server PID liveness; if a
server that passed preflight has exited, the correction signal points to
restarting/fixing the local server rather than to browser installation. Successful
one-off capture writes `browser-capture`, includes the same server monitor tails,
and uses a dedicated temporary browser profile under project `.tmp/` so ambient
Chrome/MCP/Playwright sessions are neither reused nor killed. The helper removes
that profile through its trap; fixture tests still own and leak-check servers they
start. Successful packets include a persistent-regression handoff stating that
persistent E2E/Playwright still needs separate repo-owned proof. Remote URLs are
blocked until a request-intercepting adapter can prevent page-triggered private
network and metadata-host subresource requests.

When Chrome DevTools reports that its shared `chrome-profile` is already
running, route through `core/runtime-packets/browser-proof-packet.md` profile
conflict rules. Prefer `--isolated`, then a dedicated temporary `userDataDir`
under project `.tmp/`, then intentional existing-session attachment only when
the proof requires that session state. Otherwise mark browser proof blocked and
do not close browser-required work.
