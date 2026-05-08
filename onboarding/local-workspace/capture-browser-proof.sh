#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 /path/to/target-repo url [output-json] [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
url="$2"
mode=""
if [ "${@: -1}" = "--dry-run" ]; then
  mode="--dry-run"
  set -- "${@:1:$(($#-1))}"
fi
output_path="${3:-.accelerate/review/browser-proof.json}"

case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac
URL_TO_CHECK="${url}" python3 - <<'PY'
import os
import sys
from urllib.parse import urlparse

parsed = urlparse(os.environ["URL_TO_CHECK"])
allowed_hosts = {"localhost", "127.0.0.1", "0.0.0.0", "::1"}
if parsed.scheme not in {"http", "https"} or parsed.hostname not in allowed_hosts:
    print("browser proof currently supports localhost-only targets; remote browser capture requires a request-intercepting adapter", file=sys.stderr)
    sys.exit(2)
if parsed.username or parsed.password:
    print("browser proof URL must not contain userinfo", file=sys.stderr)
    sys.exit(2)
PY

output_abs="${root}/${output_path}"
output_real_dir="$(dirname "${output_abs}")"
mkdir -p "${output_real_dir}"
case "$(readlink -f "${output_real_dir}")" in "${root}"|"${root}"/*) ;; *) echo "output escapes target repo: ${output_path}" >&2; exit 1 ;; esac
if [ -L "${output_abs}" ]; then
  echo "output path must not be a symlink: ${output_path}" >&2
  exit 1
fi

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"browser","mode":"dry-run","url":"%s","output":"%s","remote_calls":false,"phases":["server-readiness","server-crashed-after-readiness","browser-capture","readiness-only","capture-failed","persistent-regression-handoff"],"readiness_check":"would-run-before-browser-launch"}\n' "${url}" "${output_path}"
  exit 0
fi

readiness_detail="$(mktemp)"
capture_stdout="$(mktemp)"
capture_stderr="$(mktemp)"
tmp_js=""
capture_profile_dir=""
cleanup_tmp() {
  rm -f "${readiness_detail}" "${capture_stdout}" "${capture_stderr}" "${tmp_js}"
  if [ -n "${capture_profile_dir}" ]; then
    rm -rf "${capture_profile_dir}"
  fi
}
trap cleanup_tmp EXIT

write_packet() {
  local status="$1"
  local phase="$2"
  local browser_launched="$3"
  local reason="$4"
  local correction_signal="$5"
  local detail_file="$6"
  local http_code_value="${7:-}"
  URL_TO_CHECK="${url}" \
  OUTPUT_PATH="${output_path}" \
  OUTPUT_ABS="${output_abs}" \
  STATUS="${status}" \
  PHASE="${phase}" \
  BROWSER_LAUNCHED="${browser_launched}" \
  REASON="${reason}" \
  CORRECTION_SIGNAL="${correction_signal}" \
  DETAIL_FILE="${detail_file}" \
  HTTP_CODE_VALUE="${http_code_value}" \
  ACCELERATE_BROWSER_PROOF_SERVER_PID="${ACCELERATE_BROWSER_PROOF_SERVER_PID:-}" \
  ACCELERATE_BROWSER_PROOF_SERVER_STDOUT="${ACCELERATE_BROWSER_PROOF_SERVER_STDOUT:-}" \
  ACCELERATE_BROWSER_PROOF_SERVER_STDERR="${ACCELERATE_BROWSER_PROOF_SERVER_STDERR:-}" \
  python3 - <<'PY'
import datetime
import json
import os
import re
import signal
from pathlib import Path


SECRET_PATTERNS = [
    (re.compile(r"Authorization:\s*Bearer\s+\S+", re.IGNORECASE), "Authorization: Bearer [redacted]"),
    (re.compile(r"Bearer\s+\S+", re.IGNORECASE), "Bearer [redacted]"),
    (re.compile(r"(LINEAR_API_KEY|api[_-]?key|token|secret|password)\s*[:=]\s*\S+", re.IGNORECASE), r"\1=[redacted]"),
    (re.compile(r"(sk_live|sk_test|pk_live)_[A-Za-z0-9_]+"), r"\1_[redacted]"),
    (re.compile(r"(ghp_|github_pat_)[A-Za-z0-9_]+"), r"\1[redacted]"),
]


def redact(text: str) -> str:
    redacted = text
    for pattern, replacement in SECRET_PATTERNS:
        redacted = pattern.sub(replacement, redacted)
    return redacted


def tail(path_value: str) -> str:
    if not path_value:
        return ""
    path = Path(path_value)
    if not path.exists() or not path.is_file():
        return ""
    return redact(path.read_text(errors="replace")[-4000:])


def process_alive(pid_value: str):
    if not pid_value:
        return None
    try:
        pid = int(pid_value)
        os.kill(pid, 0)
        return True
    except (ValueError, ProcessLookupError):
        return False
    except PermissionError:
        return True

http_code_raw = os.environ.get("HTTP_CODE_VALUE", "")
http_code = None
if http_code_raw and http_code_raw.isdigit():
    http_code = int(http_code_raw)

detail_path = Path(os.environ["DETAIL_FILE"])
detail = ""
if detail_path.exists():
    detail = redact(detail_path.read_text(errors="replace")[:4000])

pid_value = os.environ.get("ACCELERATE_BROWSER_PROOF_SERVER_PID", "")
stdout_path = os.environ.get("ACCELERATE_BROWSER_PROOF_SERVER_STDOUT", "")
stderr_path = os.environ.get("ACCELERATE_BROWSER_PROOF_SERVER_STDERR", "")
status = os.environ["STATUS"]
phase = os.environ["PHASE"]
browser_launched = os.environ["BROWSER_LAUNCHED"] == "true"
readiness_passed = status in {"captured", "readiness-only"} or phase in {"browser-capture", "readiness-only", "capture-failed"}
packet = {
    "schema_version": 1,
    "adapter": "browser",
    "status": status,
    "phase": phase,
    "captured_at": datetime.datetime.now(datetime.timezone.utc).isoformat().replace("+00:00", "Z"),
    "url": os.environ["URL_TO_CHECK"],
    "output": os.environ["OUTPUT_PATH"],
    "browser_launched": browser_launched,
    "reason": os.environ["REASON"] or None,
    "server_readiness": {
        "checked": True,
        "passed": readiness_passed,
        "http_code": http_code,
        "detail": detail,
    },
    "server_monitor": {
        "process": {
            "tracked": bool(pid_value),
            "pid": int(pid_value) if pid_value.isdigit() else None,
            "alive": process_alive(pid_value),
        },
        "stdout_tail": tail(stdout_path),
        "stderr_tail": tail(stderr_path),
        "http_code": http_code,
    },
    "cleanup": {
        "performed": False,
        "owned_by_helper": False,
        "detail": "capture-browser-proof.sh does not own external server processes; fixture tests must kill and leak-check their servers",
    },
    "browser_session": {
        "posture": "fresh" if browser_launched else "not-launched",
        "isolation": "dedicated temporary userDataDir under project .tmp" if browser_launched else "n/a",
        "profile": None,
    },
    "correction_signal": os.environ["CORRECTION_SIGNAL"] or None,
    "readiness_impact": "supports-closure" if status == "captured" else ("supports-review-not-browser-closure" if status == "readiness-only" else "still-blocked"),
    "persistent_regression_handoff": {
        "status": "not-run",
        "required_before_persistent_e2e_claim": True,
        "detail": "Browser capture/readiness packets do not prove persistent Playwright or E2E regression coverage.",
    },
    "privacy": {"cookies_logged": False, "tokens_redacted": True, "response_body_logged": False},
}
Path(os.environ["OUTPUT_ABS"]).write_text(json.dumps(packet, indent=2) + "\n")
PY
}

if command -v curl >/dev/null 2>&1; then
  http_code="$(curl --silent --show-error --location --max-time "${ACCELERATE_BROWSER_PROOF_READINESS_TIMEOUT:-5}" --output /dev/null --write-out '%{http_code}' "${url}" 2>"${readiness_detail}" || true)"
  if [ -s "${readiness_detail}" ] || [ -z "${http_code}" ] || [ "${http_code}" = "000" ] || [ "${http_code}" -ge 500 ]; then
    printf 'http_code=%s\n' "${http_code:-none}" >>"${readiness_detail}"
    readiness_correction="start_or_fix_the_local_server_before_requesting_browser_proof"
    readiness_reason="server_readiness_failed"
    if [ -n "${ACCELERATE_BROWSER_PROOF_SERVER_PID:-}" ] && ! kill -0 "${ACCELERATE_BROWSER_PROOF_SERVER_PID}" 2>/dev/null; then
      readiness_correction="restart_crashed_local_server_before_requesting_browser_proof"
      readiness_reason="server_process_not_alive"
      printf 'server_pid=%s not_alive\n' "${ACCELERATE_BROWSER_PROOF_SERVER_PID}" >>"${readiness_detail}"
    fi
    write_packet "blocked" "server-readiness" "false" "${readiness_reason}" "${readiness_correction}" "${readiness_detail}" "${http_code:-}"
    printf 'browser proof blocked before launch: server readiness failed; wrote %s\n' "${output_path}" >&2
    exit 3
  fi
  printf 'http_code=%s\n' "${http_code}" >"${readiness_detail}"
else
  printf 'curl unavailable; cannot verify server readiness before browser launch\n' >"${readiness_detail}"
  write_packet "blocked" "server-readiness" "false" "server_readiness_checker_unavailable" "install_curl_or_use_a_runtime_adapter_with_an_equivalent_readiness_probe" "${readiness_detail}" ""
  printf 'browser proof blocked before launch: no readiness checker; wrote %s\n' "${output_path}" >&2
  exit 3
fi

if [ "${ACCELERATE_BROWSER_PROOF_READINESS_ONLY:-0}" = "1" ]; then
  write_packet "readiness-only" "readiness-only" "false" "" "" "${readiness_detail}" "${http_code}"
  printf '%s\n' "${output_path}"
  exit 0
fi

if ! command -v node >/dev/null 2>&1; then
  printf 'node is required for browser proof capture after readiness passed\n' >"${readiness_detail}"
  write_packet "blocked" "capture-failed" "false" "browser_runtime_unavailable" "install_node_and_browser_automation_or_use_readiness_only_for_server_monitoring" "${readiness_detail}" "${http_code}"
  printf 'browser proof blocked after readiness: node unavailable; wrote %s\n' "${output_path}" >&2
  exit 4
fi

capture_profile_dir="${root}/.tmp/browser-proof/profile.$$"
mkdir -p "${capture_profile_dir}"

# The browser receives a dedicated project-local profile so the helper never
# reuses or kills ambient Chrome/MCP/Playwright sessions.
tmp_js="$(mktemp)"
cat >"${tmp_js}" <<'JS'
const fs = require('fs');

function redact(text) {
  return text
    .replace(/Authorization:\s*Bearer\s+\S+/gi, 'Authorization: Bearer [redacted]')
    .replace(/Bearer\s+\S+/gi, 'Bearer [redacted]')
    .replace(/(LINEAR_API_KEY|api[_-]?key|token|secret|password)\s*[:=]\s*\S+/gi, '$1=[redacted]')
    .replace(/(sk_live|sk_test|pk_live)_[A-Za-z0-9_]+/g, '$1_[redacted]')
    .replace(/(ghp_|github_pat_)[A-Za-z0-9_]+/g, '$1[redacted]');
}

function tail(pathValue) {
  if (!pathValue) return '';
  try {
    if (!fs.existsSync(pathValue) || !fs.statSync(pathValue).isFile()) return '';
    return redact(fs.readFileSync(pathValue, 'utf8').slice(-4000));
  } catch (_) {
    return '';
  }
}

function processAlive(pidValue) {
  if (!pidValue) return null;
  const pid = Number(pidValue);
  if (!Number.isInteger(pid) || pid <= 0) return false;
  try {
    process.kill(pid, 0);
    return true;
  } catch (error) {
    return error && error.code === 'EPERM';
  }
}

async function loadPuppeteer() {
  try {
    return require('puppeteer');
  } catch (_) {
    return require('puppeteer-core');
  }
}

async function main() {
  const [, , url, outputPath, httpCode, userDataDir] = process.argv;
  const puppeteer = await loadPuppeteer();
  const browser = await puppeteer.launch({
    headless: 'new',
    userDataDir,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
  });
  try {
    const page = await browser.newPage();
    const allowedHosts = new Set(['localhost', '127.0.0.1', '0.0.0.0', '[::1]', '::1']);
    await page.setRequestInterception(true);
    page.on('request', (request) => {
      try {
        const parsed = new URL(request.url());
        if (!allowedHosts.has(parsed.hostname)) {
          return request.abort('blockedbyclient');
        }
      } catch (_) {
        return request.abort('blockedbyclient');
      }
      return request.continue();
    });
    const consoleEvents = [];
    const networkEvents = [];
    page.on('console', (msg) => {
      consoleEvents.push({ type: msg.type(), text: msg.text().replace(/Bearer\s+\S+/gi, 'Bearer [redacted]').slice(0, 1000) });
    });
    page.on('requestfinished', (request) => {
      const response = request.response();
      networkEvents.push({ url: request.url().split('?')[0], method: request.method(), status: response ? response.status() : null });
    });
    page.on('requestfailed', (request) => {
      networkEvents.push({ url: request.url().split('?')[0], method: request.method(), failed: true, error: request.failure()?.errorText || 'unknown' });
    });
    await page.setViewport({ width: 1440, height: 1000, deviceScaleFactor: 1 });
    await page.goto(url, { waitUntil: 'networkidle2', timeout: 30000 });
    const title = await page.title();
    const screenshotPath = outputPath.replace(/\.json$/, '.png');
    await page.screenshot({ path: screenshotPath, fullPage: true });
    const serverPid = process.env.ACCELERATE_BROWSER_PROOF_SERVER_PID || '';
    const serverStdout = process.env.ACCELERATE_BROWSER_PROOF_SERVER_STDOUT || '';
    const serverStderr = process.env.ACCELERATE_BROWSER_PROOF_SERVER_STDERR || '';
    const packet = {
      schema_version: 1,
      adapter: 'browser',
      status: 'captured',
      phase: 'browser-capture',
      captured_at: new Date().toISOString(),
      url,
      output: outputPath,
      browser_launched: true,
      server_readiness: { checked: true, passed: true, http_code: Number(httpCode) },
      server_monitor: {
        process: {
          tracked: Boolean(serverPid),
          pid: /^\d+$/.test(serverPid) ? Number(serverPid) : null,
          alive: processAlive(serverPid),
        },
        stdout_tail: tail(serverStdout),
        stderr_tail: tail(serverStderr),
        http_code: Number(httpCode),
      },
      viewport: { width: 1440, height: 1000 },
      title,
      screenshot: screenshotPath,
      console: consoleEvents,
      network: networkEvents,
      cleanup: {
        browser_closed: true,
        performed: true,
        owned_by_helper: false,
        server_owned_by_helper: false,
        profile_dir_removed_by_trap: true,
        detail: 'Browser process is closed by the helper. External/fixture server ownership remains with caller/test trap and must be leak-checked there.',
      },
      browser_session: { posture: 'fresh', isolation: 'dedicated temporary userDataDir under project .tmp', profile: userDataDir },
      correction_signal: null,
      readiness_impact: 'supports-closure',
      persistent_regression_handoff: {
        status: 'not-run',
        required_before_persistent_e2e_claim: true,
        detail: 'Successful capture is browser proof only; persistent regression requires a separate repo-owned E2E proof.'
      },
      privacy: { cookies_logged: false, tokens_redacted: true, response_body_logged: false },
    };
    fs.writeFileSync(outputPath, `${JSON.stringify(packet, null, 2)}\n`);
  } finally {
    await browser.close();
  }
}

main().catch((error) => {
  console.error(error && error.stack ? error.stack : String(error));
  process.exit(1);
});
JS

set +e
(cd "${root}" && node "${tmp_js}" "${url}" "${output_path}" "${http_code}" "${capture_profile_dir}") >"${capture_stdout}" 2>"${capture_stderr}"
capture_status=$?
set -e
if [ "${capture_status}" -ne 0 ]; then
  {
    printf 'browser_capture_exit=%s\n' "${capture_status}"
    printf 'stdout:\n'
    sed -e 's/[[:cntrl:]]//g' "${capture_stdout}" | tail -n 40
    printf '\nstderr:\n'
    sed -e 's/[[:cntrl:]]//g' "${capture_stderr}" | tail -n 80
  } >"${readiness_detail}"
  capture_reason="browser_capture_failed"
  capture_correction="inspect_browser_runtime_installation_or_route_failure_then_retry_capture"
  capture_browser_launched="true"
  if grep -E "Cannot find module 'puppeteer|Cannot find module 'puppeteer-core|MODULE_NOT_FOUND" "${capture_stderr}" >/dev/null 2>&1; then
    capture_reason="browser_runtime_unavailable"
    capture_correction="install_puppeteer_or_puppeteer_core_with_a_compatible_browser_then_retry_capture"
    capture_browser_launched="false"
  fi
  if [ -n "${ACCELERATE_BROWSER_PROOF_SERVER_PID:-}" ] && ! kill -0 "${ACCELERATE_BROWSER_PROOF_SERVER_PID}" 2>/dev/null; then
    capture_reason="server_crashed_after_readiness"
    capture_correction="restart_or_fix_the_local_server_then_retry_browser_capture"
    printf '\nserver_pid=%s not_alive_after_readiness\n' "${ACCELERATE_BROWSER_PROOF_SERVER_PID}" >>"${readiness_detail}"
  fi
  write_packet "blocked" "capture-failed" "${capture_browser_launched}" "${capture_reason}" "${capture_correction}" "${readiness_detail}" "${http_code}"
  printf 'browser proof capture failed after readiness; wrote %s\n' "${output_path}" >&2
  exit 5
fi
printf '%s\n' "${output_path}"
