#!/usr/bin/env bash
set -euo pipefail
: "${SAMPLE_JSON:?Set SAMPLE_JSON}"; jq -e -c . "$SAMPLE_JSON" >/tmp/p32-eve-single.json
/var/ossec/bin/wazuh-logtest < /tmp/p32-eve-single.json
