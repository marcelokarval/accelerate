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
printf '%s' "${dry_run_output}" | grep -F 'server-crashed-after-readiness' >/dev/null || fail "dry-run did not expose server crash monitoring phase"

set +e
ACCELERATE_BROWSER_PROOF_READINESS_TIMEOUT=1 bash "${script}" "${workdir}/app" "http://127.0.0.1:9" ".accelerate/review/server-down.json" >"${workdir}/server-down.stdout" 2>"${workdir}/server-down.stderr"
server_down_status=$?
set -e
[ "${server_down_status}" -ne 0 ] || fail "server-down proof unexpectedly succeeded"
[ -f "${workdir}/app/.accelerate/review/server-down.json" ] || fail "server-down structured packet was not written"
ln -s /tmp/accelerate-browser-proof-symlink-escape.json "${workdir}/app/.accelerate/review/symlink.json"
if ACCELERATE_BROWSER_PROOF_READINESS_TIMEOUT=1 bash "${script}" "${workdir}/app" "http://127.0.0.1:9" ".accelerate/review/symlink.json" >/tmp/accelerate-browser-proof-symlink.out 2>&1; then
  fail "browser proof helper accepted a symlink output path"
fi
grep -F 'output path must not be a symlink' /tmp/accelerate-browser-proof-symlink.out >/dev/null || fail "symlink output rejection did not explain the failure"
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
printf 'Authorization: Bearer server...t\n' >>"${workdir}/server.stdout"
printf 'token: stderr-secret\nghp_abcdef1234567890\n' >>"${workdir}/server.stderr"

dead_pid=999999
while kill -0 "${dead_pid}" 2>/dev/null; do
  dead_pid=$((dead_pid - 1))
done
set +e
ACCELERATE_BROWSER_PROOF_SERVER_PID="${dead_pid}" \
ACCELERATE_BROWSER_PROOF_SERVER_STDOUT="${workdir}/server.stdout" \
ACCELERATE_BROWSER_PROOF_SERVER_STDERR="${workdir}/server.stderr" \
ACCELERATE_BROWSER_PROOF_READINESS_ONLY=1 bash "${script}" "${workdir}/app" "http://127.0.0.1:${port}" ".accelerate/review/dead-supplied-pid.json" >"${workdir}/dead-pid.stdout" 2>"${workdir}/dead-pid.stderr"
dead_pid_status=$?
set -e
[ "${dead_pid_status}" -ne 0 ] || fail "dead supplied server pid proof unexpectedly succeeded"
python3 - "${workdir}/app/.accelerate/review/dead-supplied-pid.json" "${dead_pid}" <<'PY'
import json
import sys
from pathlib import Path
packet = json.loads(Path(sys.argv[1]).read_text())
dead_pid = int(sys.argv[2])
assert packet["status"] == "blocked", packet
assert packet["phase"] == "server-readiness", packet
assert packet["browser_launched"] is False, packet
assert packet["reason"] == "server_process_not_alive", packet
assert packet["server_readiness"]["checked"] is True, packet
assert packet["server_readiness"]["passed"] is False, packet
assert 200 <= packet["server_readiness"]["http_code"] < 500, packet
assert packet["server_monitor"]["process"]["tracked"] is True, packet
assert packet["server_monitor"]["process"]["pid"] == dead_pid, packet
assert packet["server_monitor"]["process"]["alive"] is False, packet
assert packet["browser_capture"]["launch_skipped"] is True, packet
assert packet["correction_signal"] == "restart_crashed_local_server_before_requesting_browser_proof", packet
assert "not_alive_after_successful_http_probe" in packet["server_readiness"]["detail"], packet
PY

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
assert packet["browser_session"]["posture"] == "not-launched", packet
assert packet["server_readiness"]["checked"] is True, packet
assert packet["server_readiness"]["passed"] is True, packet
assert 200 <= packet["server_readiness"]["http_code"] < 500, packet
assert packet["server_monitor"]["process"]["tracked"] is True, packet
assert packet["server_monitor"]["process"]["alive"] is True, packet
assert "stdout_tail" in packet["server_monitor"], packet
assert "stderr_tail" in packet["server_monitor"], packet
assert "server-secret-token" not in packet["server_monitor"]["stdout_tail"], packet
assert "lin_secret" not in packet["server_monitor"]["stdout_tail"], packet
assert "stderr-secret" not in packet["server_monitor"]["stderr_tail"], packet
assert "abcdef1234567890" not in packet["server_monitor"]["stderr_tail"], packet
assert "Bearer [redacted]" in packet["server_monitor"]["stdout_tail"], packet
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
    assert packet["server_monitor"]["process"]["tracked"] is True, packet
    assert packet["server_monitor"]["process"]["alive"] is True, packet
    assert packet["browser_session"]["posture"] == "fresh", packet
    assert "dedicated temporary userDataDir" in packet["browser_session"]["isolation"], packet
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

cat >"${workdir}/oneshot_server.py" <<'PY'
import http.server
import sys
from pathlib import Path

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'<!doctype html><title>one shot</title><h1>ready then crash</h1>')
    def log_message(self, fmt, *args):
        print(fmt % args, file=sys.stderr)

server = http.server.HTTPServer(('127.0.0.1', int(sys.argv[1])), Handler)
Path(sys.argv[2]).write_text('ready\n')
server.handle_request()
server.server_close()
PY
crash_port="$(python3 - <<'PY'
import socket
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
    sock.bind(('127.0.0.1', 0))
    print(sock.getsockname()[1])
PY
)"
crash_ready="${workdir}/crash-server.ready"
python3 "${workdir}/oneshot_server.py" "${crash_port}" "${crash_ready}" >"${workdir}/crash-server.stdout" 2>"${workdir}/crash-server.stderr" &
server_pid=$!
for _ in $(seq 1 50); do
  [ -f "${crash_ready}" ] && break
  if ! kill -0 "${server_pid}" 2>/dev/null; then
    fail "one-shot fixture server exited before readiness marker"
  fi
  sleep 0.1
done
[ -f "${crash_ready}" ] || fail "one-shot fixture server did not become ready"

set +e
ACCELERATE_BROWSER_PROOF_SERVER_PID="${server_pid}" \
ACCELERATE_BROWSER_PROOF_SERVER_STDOUT="${workdir}/crash-server.stdout" \
ACCELERATE_BROWSER_PROOF_SERVER_STDERR="${workdir}/crash-server.stderr" \
ACCELERATE_BROWSER_PROOF_READINESS_TIMEOUT=2 bash "${script}" "${workdir}/app" "http://127.0.0.1:${crash_port}" ".accelerate/review/server-crashed-after-readiness.json" >"${workdir}/crash-capture.stdout" 2>"${workdir}/crash-capture.stderr"
crash_capture_status=$?
set -e
[ "${crash_capture_status}" -ne 0 ] || fail "server-crash proof unexpectedly succeeded"
[ -f "${workdir}/app/.accelerate/review/server-crashed-after-readiness.json" ] || fail "server-crash structured packet was not written"
python3 - "${workdir}/app/.accelerate/review/server-crashed-after-readiness.json" <<'PY'
import json
import sys
from pathlib import Path
packet = json.loads(Path(sys.argv[1]).read_text())
assert packet["status"] == "blocked", packet
assert packet["phase"] == "capture-failed", packet
assert packet["server_readiness"]["passed"] is True, packet
assert packet["server_monitor"]["process"]["tracked"] is True, packet
assert packet["server_monitor"]["process"]["alive"] is False, packet
assert packet["reason"] == "server_crashed_after_readiness", packet
assert packet["correction_signal"] == "restart_or_fix_the_local_server_then_retry_browser_capture", packet
assert "not_alive_after_readiness" in packet["server_readiness"]["detail"], packet
PY
wait "${server_pid}" 2>/dev/null || true
server_pid=""

if [ -d "${workdir}/app/.tmp/browser-proof" ] && find "${workdir}/app/.tmp/browser-proof" -mindepth 1 -maxdepth 1 -type d | grep -q .; then
  find "${workdir}/app/.tmp/browser-proof" -mindepth 1 -maxdepth 1 -type d >&2
  fail "browser proof temporary profile directory leaked"
fi

if pgrep -f "python3 -m http.server .*${workdir}/app" >/dev/null 2>&1; then
  fail "fixture server process leaked"
fi

if pgrep -af "node .*${workdir}|chrome.*${workdir}|chromium.*${workdir}|puppeteer.*${workdir}" >/dev/null 2>&1; then
  pgrep -af "node .*${workdir}|chrome.*${workdir}|chromium.*${workdir}|puppeteer.*${workdir}" >&2 || true
  fail "browser/runtime fixture process leaked"
fi

printf 'browser proof monitoring passed\n'
