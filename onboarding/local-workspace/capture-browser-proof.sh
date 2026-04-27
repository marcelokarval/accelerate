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
case "${url}" in
  http://localhost:*|http://127.0.0.1:*|http://0.0.0.0:*|http://[::1]:*) ;;
  https://localhost:*|https://127.0.0.1:*|https://0.0.0.0:*|https://[::1]:*) ;;
  *)
    if [ "${ACCELERATE_ALLOW_REMOTE_BROWSER:-}" != "1" ]; then
      echo "browser proof defaults to localhost-only; set ACCELERATE_ALLOW_REMOTE_BROWSER=1 for remote URL: ${url}" >&2
      exit 2
    fi
    case "${url}" in http://*|https://*) ;; *) echo "browser proof allows only http(s) URLs" >&2; exit 2 ;; esac
    host="$(printf '%s' "${url}" | sed -E 's#^[a-z]+://([^/:]+).*#\1#')"
    case "${host}" in
      169.254.169.254|metadata.google.internal|metadata|10.*|192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*)
        echo "browser proof blocks metadata and private network targets: ${host}" >&2
        exit 2
        ;;
    esac
    ;;
esac

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
