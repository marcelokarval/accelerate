#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# codebase-memory-mcp installer & OpenCode registration
# Part of Accelerate Graph & Memory Intelligence Pipeline
# ==============================================================================

echo "=== Installing codebase-memory-mcp ==="

# 1. Global install via npm/npx environment
if command -v npm >/dev/null 2>&1; then
    echo "Running npm install -g codebase-memory-mcp..."
    npm install -g codebase-memory-mcp@latest || {
        echo "Global npm install failed or requires sudo. Trying local user prefix..."
        npm install --prefix "${HOME}/.local" -g codebase-memory-mcp@latest
    }
else
    echo "Error: npm is not available in PATH." >&2
    exit 1
fi

# Locate the binary
CBM_BIN="$(command -v codebase-memory-mcp || echo "${HOME}/.local/bin/codebase-memory-mcp")"

if [ ! -x "$CBM_BIN" ]; then
    echo "Warning: codebase-memory-mcp binary not found directly. Fallback to npx will be configured."
    CBM_CMD='["npx", "-y", "codebase-memory-mcp@latest"]'
else
    echo "Found binary at: $CBM_BIN"
    CBM_CMD="[\"$CBM_BIN\"]"
fi

# 2. Register into ~/.config/opencode/opencode.json
CONFIG_FILE="${HOME}/.config/opencode/opencode.json"

if [ -f "$CONFIG_FILE" ]; then
    echo "Registering codebase-memory in $CONFIG_FILE..."
    node -e "
const fs = require('fs');
const path = '$CONFIG_FILE';
const config = JSON.parse(fs.readFileSync(path, 'utf8'));

config.mcp = config.mcp || {};
config.mcp['codebase-memory'] = {
    type: 'local',
    command: $CBM_CMD,
    enabled: true
};

fs.writeFileSync(path, JSON.stringify(config, null, 2), 'utf8');
console.log('Successfully registered codebase-memory MCP in opencode.json');
"
else
    echo "Config file $CONFIG_FILE not found. Skipping auto-registration."
fi

echo "=== codebase-memory-mcp installation complete ==="
