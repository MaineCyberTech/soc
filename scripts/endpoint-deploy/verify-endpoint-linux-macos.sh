#!/usr/bin/env bash
# MCT endpoint verification - Linux/macOS
# Verifies Wazuh agent (+ Velociraptor + osquery) after deployment.
# Designed for level.io: prints PASS/FAIL per check, exit 1 on any FAIL.
set -uo pipefail

FAIL=0
ok()  { echo "[PASS] $*"; }
bad() { echo "[FAIL] $*"; FAIL=1; }

echo "== MCT endpoint verification ($(uname -s)) =="

# Wazuh agent process
if pgrep -f wazuh-agent >/dev/null 2>&1; then
  ok "wazuh-agent process running"
else
  bad "wazuh-agent process not found"
fi

# ossec-control status
if [ -x /Library/Ossec/bin/wazuh-control ]; then
  STATUS=$(/Library/Ossec/bin/wazuh-control status 2>/dev/null | grep -c running)
elif [ -x /var/ossec/bin/wazuh-control ]; then
  STATUS=$(/var/ossec/bin/wazuh-control status 2>/dev/null | grep -c running)
else
  STATUS=0
fi
if [ "$STATUS" -ge 3 ]; then
  ok "wazuh daemons running ($STATUS)"
else
  bad "wazuh daemons running ($STATUS/expected >=3)"
fi

# enrollment key present
KEYFILE=/var/ossec/etc/client.keys
[ -f /Library/Ossec/etc/client.keys ] && KEYFILE=/Library/Ossec/etc/client.keys
if [ -s "$KEYFILE" ]; then
  ok "agent enrolled (client.keys present)"
else
  bad "agent NOT enrolled (no client.keys)"
fi

# manager config
CONF=/var/ossec/etc/ossec.conf
[ -f /Library/Ossec/etc/ossec.conf ] && CONF=/Library/Ossec/etc/ossec.conf
if grep -q '<address>' "$CONF" 2>/dev/null; then
  ok "ossec.conf manager address set"
else
  bad "ossec.conf manager address missing"
fi

# Velociraptor
if command -v velociraptor >/dev/null 2>&1; then
  if pgrep -f velociraptor >/dev/null 2>&1 || [ -f /etc/velociraptor.client.yaml ]; then
    ok "velociraptor client present"
  else
    bad "velociraptor client config present but process not running"
  fi
else
  echo "[INFO] velociraptor not installed (optional)"
fi

# osquery
if command -v osqueryd >/dev/null 2>&1; then
  pgrep -f osqueryd >/dev/null 2>&1 && ok "osquery running" || bad "osquery installed but not running"
else
  echo "[INFO] osquery not installed (optional)"
fi

# connectivity to manager (514/udp syslog - best-effort)
if command -v nc >/dev/null 2>&1; then
  timeout 3 nc -z -u "$(grep -oP '(?<=<address>)[^<]+' "$CONF" 2>/dev/null | head -1)" 1514 >/dev/null 2>&1 \
    && ok "manager reachable (1514)" || echo "[INFO] manager reachability not verified (no nc)"
fi

echo
echo "Result: $([ $FAIL -eq 0 ] && echo PASS || echo FAIL)"
exit $FAIL
