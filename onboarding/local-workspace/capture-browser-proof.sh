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

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"browser","mode":"dry-run","url":"%s","output":"%s","remote_calls":false}\n' "${url}" "${output_path}"
  exit 0
fi

command -v node >/dev/null 2>&1 || { echo "node is required for browser proof capture" >&2; exit 1; }

tmp_js="$(mktemp)"
trap 'rm -f "${tmp_js}"' EXIT
cat >"${tmp_js}" <<'JS'
const fs = require('fs');

async function loadPuppeteer() {
  try {
    return require('puppeteer');
  } catch (_) {
    return require('puppeteer-core');
  }
}

async function main() {
  const [, , url, outputPath] = process.argv;
  const puppeteer = await loadPuppeteer();
  const browser = await puppeteer.launch({
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
  });
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
  const packet = {
    schema_version: 1,
    adapter: 'browser',
    captured_at: new Date().toISOString(),
    url,
    viewport: { width: 1440, height: 1000 },
    title,
    screenshot: screenshotPath,
    console: consoleEvents,
    network: networkEvents,
    privacy: { cookies_logged: false, tokens_redacted: true },
  };
  fs.writeFileSync(outputPath, `${JSON.stringify(packet, null, 2)}\n`);
  await browser.close();
}

main().catch((error) => {
  console.error(error && error.stack ? error.stack : String(error));
  process.exit(1);
});
JS

(cd "${root}" && node "${tmp_js}" "${url}" "${output_path}")
printf '%s\n' "${output_path}"
