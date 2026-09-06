import sys
import subprocess
import json
import time
import os

server_bin = sys.argv[1]

env = os.environ.copy()
env["PLANE_API_KEY"] = "dummy"
env["PLANE_WORKSPACE_SLUG"] = "dummy"
env["PLANE_BASE_URL"] = "http://dummy"

p = subprocess.Popen(
    [server_bin, "stdio"],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True,
    bufsize=1,
    env=env
)

print(f"**Process PID:** `{p.pid}`")
print("\n### Initialize Sequence")

init_req = {
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
        "protocolVersion": "2024-11-05",
        "capabilities": {},
        "clientInfo": {
            "name": "smoke-test",
            "version": "1.0.0"
        }
    }
}
print(f"**Request:**\n```json\n{json.dumps(init_req, indent=2)}\n```\n")

raw = json.dumps(init_req) + "\n"
p.stdin.write(raw)
p.stdin.flush()

res1 = p.stdout.readline()
print(f"**Response:**\n```json\n{json.dumps(json.loads(res1), indent=2)}\n```\n")

initialized_notif = {
    "jsonrpc": "2.0",
    "method": "notifications/initialized"
}
p.stdin.write(json.dumps(initialized_notif) + "\n")
p.stdin.flush()

print("### Tools/List Sequence")

tools_req = {
    "jsonrpc": "2.0",
    "id": 2,
    "method": "tools/list",
    "params": {}
}
print(f"**Request:**\n```json\n{json.dumps(tools_req, indent=2)}\n```\n")

raw = json.dumps(tools_req) + "\n"
p.stdin.write(raw)
p.stdin.flush()

res2 = p.stdout.readline()
print(f"**Response:**\n```json\n{json.dumps(json.loads(res2), indent=2)}\n```\n")

p.terminate()
try:
    p.wait(timeout=5)
    print("### Clean Exit")
    print(f"Process terminated cleanly. Exit code: {p.returncode}")
except subprocess.TimeoutExpired:
    p.kill()
    print("### Forced Exit")
    print("Process killed.")

print("\n### Residual Process Check")
check = subprocess.run(["ps", "-p", str(p.pid)], capture_output=True, text=True)
if str(p.pid) in check.stdout:
    print(f"WARNING: Residual process {p.pid} still exists!")
else:
    print(f"Verified no residual process exists for PID {p.pid}.")

