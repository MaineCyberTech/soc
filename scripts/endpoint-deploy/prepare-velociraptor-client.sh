#!/usr/bin/env bash
# prepare-velociraptor-client.sh
# Generates a working Velociraptor client.config.yaml from the server config
# with all known fixes applied (server_urls SAN hostname, matching CA, matching nonce).
# Run on the Wazuh host. Output: ./client.config.yaml (+ base64 for level.io).
# Usage: prepare-velociraptor-client.sh [--out client.config.yaml]
set -uo pipefail

SERVER_CFG="${VELO_SERVER_CONFIG:-/opt/mct-security-stack/data/velociraptor/server.config.yaml}"
OUT="${1:-client.config.yaml}"
if [ "$OUT" = "--out" ]; then OUT="${2:-client.config.yaml}"; fi
TMP="$(mktemp)"

if [ ! -f "$SERVER_CFG" ]; then
  echo "ERROR: server config not found: $SERVER_CFG"
  exit 1
fi

echo "Generating client config from $SERVER_CFG"
/usr/local/bin/velociraptor --config "$SERVER_CFG" config generate 2>/dev/null > "$TMP"

python3 << EOF
import yaml

d = yaml.safe_load(open("$TMP"))
s = yaml.safe_load(open("$SERVER_CFG"))

# 1. server_urls must use the frontend cert SAN hostname + actual port
port = s["Frontend"].get("bind_port", 8002)
host = s.get("defaults", {}).get("fqdn", "") or "VelociraptorServer"
d["Client"]["server_urls"] = [f"https://{host}:{port}/"]

# 2. CA must match the server (config generate embeds a different CA)
d["Client"]["ca_certificate"] = s["Client"]["ca_certificate"]

# 3. nonce must match the server (config generate regenerates it)
d["Client"]["nonce"] = s["Client"]["nonce"]

# 4. writeback path - per-OS default is fine (service install sets it), but
#    keep explicit for predictability
d["Client"]["writeback_linux"] = "/etc/velociraptor.writeback.yaml"
d["Client"]["writeback_darwin"] = "/etc/velociraptor.writeback.yaml"
d["Client"]["writeback_windows"] = r"\$ProgramFiles\Velociraptor\velociraptor.writeback.yaml"

yaml.safe_dump(d, open("$OUT", "w"), default_flow_style=False)
print("Wrote $OUT")
print("server_urls:", d["Client"]["server_urls"])
EOF

echo
echo "base64 (paste into level.io VELO_CONFIG_B64 as encrypted variable):"
base64 -w0 "$OUT"
echo
echo "or serve $OUT at a protected URL and set VELO_CONFIG_URL."
rm -f "$TMP"
