#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

fail() {
  printf 'browser-proof-monitoring failed: %s\n' "$1" >&2
  exit 1
}

script="onboarding/local-workspace/capture-browser-proof.sh"
[ -x "${script}" ] || fail "browser proof helper is missing or not executable"

workdir="$(mktemp -d "${TMPDIR:-/tmp}/accelerate-browser-proof.XXXXXX")"
server_pid=""
cleanup() {
  if [ -n "${server_pid}" ] && kill -0 "${server_pid}" 2>/dev/null; then
    kill "${server_pid}" 2>/dev/null || true
    wait "${server_pid}" 2>/dev/null || true
  fi
  rm -rf "${workdir}"
}
trap cleanup EXIT

mkdir -p "${workdir}/app"

dry_run_output="$(bash "${script}" "${workdir}/app" "http://127.0.0.1:9" ".accelerate/review/dry-run.json" --dry-run)"
printf '%s' "${dry_run_output}" | grep -F '"remote_calls":false' >/dev/null || fail "dry-run did not declare remote_calls false"
printf '%s' "${dry_run_output}" | grep -F 'would-run-before-browser-launch' >/dev/null || fail "dry-run did not expose readiness preflight"
printf '%s' "${dry_run_output}" | grep -F 'capture-failed' >/dev/null || fail "dry-run did not expose separated browser-proof phases"

set +e
ACCELERATE_BROWSER_PROOF_READINESS_TIMEOUT=1 bash "${script}" "${workdir}/app" "http://127.0.0.1:9" ".accelerate/review/server-down.json" >"${workdir}/server-down.stdout" 2>"${workdir}/server-down.stderr"
server_down_status=$?
set -e
[ "${server_down_status}" -ne 0 ] || fail "server-down proof unexpectedly succeeded"
[ -f "${workdir}/app/.accelerate/review/server-down.json" ] || fail "server-down structured packet was not written"
python3 - "${workdir}/app/.accelerate/review/server-down.json" <<'PY'
import json
import sys
from pathlib import Path
packet = json.loads(Path(sys.argv[1]).read_text())
assert packet["status"] == "blocked", packet
assert packet["phase"] == "server-readiness", packet
assert packet["browser_launched"] is False, packet
assert packet["server_readiness"]["checked"] is True, packet
assert packet["server_readiness"]["passed"] is False, packet
assert packet["server_monitor"]["http_code"] in (0, None), packet
assert packet["server_monitor"]["process"]["tracked"] is False, packet
assert packet["cleanup"]["owned_by_helper"] is False, packet
assert packet["correction_signal"] == "start_or_fix_the_local_server_before_requesting_browser_proof", packet
assert packet["persistent_regression_handoff"]["required_before_persistent_e2e_claim"] is True, packet
PY

echo '<!doctype html><title>Accelerate fixture</title><h1>ready</h1>' >"${workdir}/app/index.html"
port="$(python3 - <<'PY'
import socket
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
    sock.bind(('127.0.0.1', 0))
    print(sock.getsockname()[1])
PY
)"
python3 -m http.server "${port}" --bind 127.0.0.1 --directory "${workdir}/app" >"${workdir}/server.stdout" 2>"${workdir}/server.stderr" &
server_pid=$!

for _ in $(seq 1 50); do
  if curl --silent --show-error --max-time 1 --output /dev/null "http://127.0.0.1:${port}" 2>/dev/null; then
    break
  fi
  if ! kill -0 "${server_pid}" 2>/dev/null; then
    fail "fixture server exited early"
  fi
  sleep 0.1
done
curl --silent --show-error --max-time 1 --output /dev/null "http://127.0.0.1:${port}" 2>/dev/null || fail "fixture server did not become ready"

ACCELERATE_BROWSER_PROOF_SERVER_PID="${server_pid}" \
ACCELERATE_BROWSER_PROOF_SERVER_STDOUT="${workdir}/server.stdout" \
ACCELERATE_BROWSER_PROOF_SERVER_STDERR="${workdir}/server.stderr" \
ACCELERATE_BROWSER_PROOF_READINESS_ONLY=1 bash "${script}" "${workdir}/app" "http://127.0.0.1:${port}" ".accelerate/review/readiness-only.json" >/dev/null
python3 - "${workdir}/app/.accelerate/review/readiness-only.json" <<'PY'
import json
import sys
from pathlib import Path
packet = json.loads(Path(sys.argv[1]).read_text())
assert packet["status"] == "readiness-only", packet
assert packet["phase"] == "readiness-only", packet
assert packet["browser_launched"] is False, packet
assert packet["server_readiness"]["checked"] is True, packet
assert packet["server_readiness"]["passed"] is True, packet
assert 200 <= packet["server_readiness"]["http_code"] < 500, packet
assert packet["server_monitor"]["process"]["tracked"] is True, packet
assert packet["server_monitor"]["process"]["alive"] is True, packet
assert packet["cleanup"]["performed"] is False, packet
assert packet["persistent_regression_handoff"]["status"] == "not-run", packet
PY

set +e
ACCELERATE_BROWSER_PROOF_SERVER_PID="${server_pid}" \
ACCELERATE_BROWSER_PROOF_SERVER_STDOUT="${workdir}/server.stdout" \
ACCELERATE_BROWSER_PROOF_SERVER_STDERR="${workdir}/server.stderr" \
bash "${script}" "${workdir}/app" "http://127.0.0.1:${port}" ".accelerate/review/capture.json" >"${workdir}/capture.stdout" 2>"${workdir}/capture.stderr"
capture_status=$?
set -e
[ -f "${workdir}/app/.accelerate/review/capture.json" ] || fail "capture path did not write a structured packet"
python3 - "${workdir}/app/.accelerate/review/capture.json" "${capture_status}" <<'PY'
import json
import sys
from pathlib import Path
packet = json.loads(Path(sys.argv[1]).read_text())
status = int(sys.argv[2])
assert packet["phase"] in {"browser-capture", "capture-failed"}, packet
assert packet["server_readiness"]["checked"] is True, packet
assert packet["server_readiness"]["passed"] is True, packet
assert 200 <= packet["server_readiness"]["http_code"] < 500, packet
assert packet["persistent_regression_handoff"]["required_before_persistent_e2e_claim"] is True, packet
if status == 0:
    assert packet["status"] == "captured", packet
    assert packet["phase"] == "browser-capture", packet
    assert packet["browser_launched"] is True, packet
    assert packet.get("screenshot"), packet
    assert Path(Path(sys.argv[1]).parent.parent.parent / packet["screenshot"]).exists() or Path(packet["screenshot"]).exists(), packet
else:
    assert packet["status"] == "blocked", packet
    assert packet["phase"] == "capture-failed", packet
    assert packet["correction_signal"], packet
PY

kill "${server_pid}" 2>/dev/null || true
wait "${server_pid}" 2>/dev/null || true
server_pid=""

if pgrep -f "python3 -m http.server .*${workdir}/app" >/dev/null 2>&1; then
  fail "fixture server process leaked"
fi

if pgrep -af "node .*${workdir}|chrome.*${workdir}|chromium.*${workdir}|puppeteer.*${workdir}" >/dev/null 2>&1; then
  pgrep -af "node .*${workdir}|chrome.*${workdir}|chromium.*${workdir}|puppeteer.*${workdir}" >&2 || true
  fail "browser/runtime fixture process leaked"
fi

printf 'browser proof monitoring passed\n'
